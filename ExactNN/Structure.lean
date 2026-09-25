import ExactNN.Basic
namespace ExactNN
/-- Finite feedforward expressions, with one globally shared parameter assignment. -/
inductive Expr (Input Param : Type) where
  | const (q : ℚ)
  | input (i : Input)
  | param (p : Param)
  | add (a b : Expr Input Param)
  | mul (a b : Expr Input Param)
  | relu (a : Expr Input Param)

noncomputable def Expr.eval {I P : Type} (x : I → ℝ) (θ : P → ℝ) : Expr I P → ℝ
  | .const q => (q : ℝ)
  | .input i => x i
  | .param p => θ p
  | .add a b => a.eval x θ + b.eval x θ
  | .mul a b => a.eval x θ * b.eval x θ
  | .relu a => ExactNN.relu (a.eval x θ)

def Expr.substitute {I J P : Type} (g : I → Expr J P) : Expr I P → Expr J P
  | .const q => .const q
  | .input i => g i
  | .param p => .param p
  | .add a b => .add (a.substitute g) (b.substitute g)
  | .mul a b => .mul (a.substitute g) (b.substitute g)
  | .relu a => .relu (a.substitute g)

theorem Expr.eval_substitute {I J P : Type} (e : Expr I P) (g : I → Expr J P)
    (x : J → ℝ) (θ : P → ℝ) :
    (e.substitute g).eval x θ = e.eval (fun i => (g i).eval x θ) θ := by
  induction e <;> simp_all [Expr.substitute, Expr.eval]

/-- Joint feasibility retains the shared assignment and all intermediate samples. -/
theorem coupled_feasibility {I J P S Q : Type}
    (g : I → Expr J P) (out : Q → Expr I P) (X : S → J → ℝ) (Y : S → Q → ℝ) :
    (∃ θ : P → ℝ, ∀ s q, ((out q).substitute g).eval (X s) θ = Y s q) ↔
    (∃ θ : P → ℝ, ∃ Z : S → I → ℝ,
      (∀ s i, (g i).eval (X s) θ = Z s i) ∧
      (∀ s q, (out q).eval (Z s) θ = Y s q)) := by
  constructor
  · rintro ⟨θ, hf⟩
    refine ⟨θ, fun s i => (g i).eval (X s) θ, fun _ _ => rfl, ?_⟩
    intro s q
    simpa only [Expr.eval_substitute] using hf s q
  · rintro ⟨θ, Z, hg, hf⟩
    refine ⟨θ, fun s q => ?_⟩
    rw [Expr.eval_substitute]
    have hz : (fun i => (g i).eval (X s) θ) = Z s := funext (hg s)
    rw [hz]
    exact hf s q

noncomputable def Shallow.reindex {d h : ℕ} (N : Shallow d h)
    (p : Fin h ≃ Fin h) : Shallow d h where
  weight := fun j => N.weight (p j)
  hiddenBias := fun j => N.hiddenBias (p j)
  coeff := fun j => N.coeff (p j)
  outputBias := N.outputBias

theorem Shallow.eval_reindex {d h : ℕ} (N : Shallow d h)
    (p : Fin h ≃ Fin h) (x : Fin d → ℝ) : (N.reindex p).eval x = N.eval x := by
  unfold Shallow.eval Shallow.reindex
  congr 1
  exact Equiv.sum_comp p (fun j =>
    N.coeff j * relu (affine (N.weight j) (N.hiddenBias j) x))

/-- Reordering and consistent duplicate insertion as surjective resampling. -/
theorem exactFit_resample {m n d h : ℕ} (D : ScalarData m d)
    (r : Fin n → Fin m) (hr : Function.Surjective r) :
    ExactFit (⟨fun i => D.x (r i), fun i => D.y (r i)⟩ : ScalarData n d) h ↔
      ExactFit D h := by
  constructor
  · rintro ⟨H, hH, N, hf⟩
    refine ⟨H, hH, N, fun i => ?_⟩
    obtain ⟨j, rfl⟩ := hr i
    exact hf j
  · rintro ⟨H, hH, N, hf⟩
    exact ⟨H, hH, N, fun i => hf (r i)⟩
end ExactNN
