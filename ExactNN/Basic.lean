import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Fintype.Card
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Choose

/-! Rational data, unrestricted real parameters, free bias, no affine skip. -/
namespace ExactNN

noncomputable def relu (x : ℝ) : ℝ := max 0 x
@[simp] theorem relu_zero : relu 0 = 0 := max_self 0
theorem relu_nonneg (x : ℝ) : 0 ≤ relu x := le_max_left _ _
theorem le_relu (x : ℝ) : x ≤ relu x := le_max_right _ _
theorem relu_of_nonneg {x : ℝ} (h : 0 ≤ x) : relu x = x := max_eq_right h
theorem relu_of_nonpos {x : ℝ} (h : x ≤ 0) : relu x = 0 := max_eq_left h

theorem relu_mul {a : ℝ} (ha : 0 ≤ a) (x : ℝ) :
    relu (a * x) = a * relu x := by
  by_cases hx : 0 ≤ x
  · rw [relu_of_nonneg hx, relu_of_nonneg (mul_nonneg ha hx)]
  · have hx' : x ≤ 0 := le_of_not_ge hx
    rw [relu_of_nonpos hx', relu_of_nonpos (mul_nonpos_of_nonneg_of_nonpos ha hx')]
    ring

theorem relu_sub_relu_neg (x : ℝ) : relu x - relu (-x) = x := by
  by_cases hx : 0 ≤ x
  · rw [relu_of_nonneg hx, relu_of_nonpos (neg_nonpos.mpr hx)]
    ring
  · have hx' : x ≤ 0 := le_of_not_ge hx
    rw [relu_of_nonpos hx', relu_of_nonneg (neg_nonneg.mpr hx')]
    ring

theorem relu_eq_iff (v z : ℝ) :
    relu v = z ↔ 0 ≤ z ∧ v ≤ z ∧ z * (z - v) = 0 := by
  constructor
  · intro h
    subst z
    refine ⟨relu_nonneg v, le_relu v, ?_⟩
    by_cases hv : 0 ≤ v
    · rw [relu_of_nonneg hv]; ring
    · rw [relu_of_nonpos (le_of_not_ge hv)]; ring
  · rintro ⟨hz, hv, hc⟩
    rcases mul_eq_zero.mp hc with h | h
    · subst z
      exact relu_of_nonpos hv
    · have h : z = v := sub_eq_zero.mp h
      subst z
      exact relu_of_nonneg hz

theorem relu_target_iff {t : ℝ} (ht : 0 ≤ t) (v : ℝ) :
    relu v = t ↔ (0 < t → v = t) ∧ (t = 0 → v ≤ 0) := by
  constructor
  · intro h
    constructor
    · intro hp
      have : 0 < relu v := by rw [h]; exact hp
      have hv : 0 ≤ v := by
        by_contra hn
        rw [relu_of_nonpos (le_of_not_ge hn)] at this
        linarith
      rwa [relu_of_nonneg hv] at h
    · intro hzero
      have := le_relu v
      linarith
  · rintro ⟨hp, hz⟩
    rcases eq_or_lt_of_le ht with h | h
    · have ht0 : t = 0 := h.symm
      rw [ht0, relu_of_nonpos (hz ht0)]
    · rw [hp h, relu_of_nonneg ht]

noncomputable def affine {d : ℕ} (w : Fin d → ℝ) (b : ℝ)
    (x : Fin d → ℝ) : ℝ := b + ∑ k, w k * x k

theorem affine_scale {d : ℕ} (a : ℝ) (w : Fin d → ℝ) (b : ℝ)
    (x : Fin d → ℝ) :
    affine (fun k => a * w k) (a * b) x = a * affine w b x := by
  simp only [affine, mul_add, Finset.mul_sum, mul_assoc]

theorem affine_shift {d : ℕ} (w : Fin d → ℝ) (b t : ℝ)
    (x : Fin d → ℝ) : affine w (b - t) x = affine w b x - t := by
  unfold affine
  ring

structure ScalarData (m d : ℕ) where
  x : Fin m → Fin d → ℚ
  y : Fin m → ℚ

def ScalarData.input {m d : ℕ} (D : ScalarData m d) (i : Fin m) : Fin d → ℝ :=
  fun k => (D.x i k : ℝ)

structure Shallow (d h : ℕ) where
  weight : Fin h → Fin d → ℝ
  hiddenBias : Fin h → ℝ
  coeff : Fin h → ℝ
  outputBias : ℝ

noncomputable def Shallow.eval {d h : ℕ} (N : Shallow d h) (x : Fin d → ℝ) : ℝ :=
  N.outputBias + ∑ j, N.coeff j * relu (affine (N.weight j) (N.hiddenBias j) x)

def ExactFit {m d : ℕ} (D : ScalarData m d) (h : ℕ) : Prop :=
  ∃ H ≤ h, ∃ N : Shallow d H, ∀ i, N.eval (D.input i) = (D.y i : ℝ)

def OneFit {m d : ℕ} (X : Fin m → Fin d → ℝ) (y : Fin m → ℝ) : Prop :=
  ∃ (w : Fin d → ℝ) (b a c : ℝ), ∀ i, c + a * relu (affine w b (X i)) = y i

def VectorOneFit {m d q : ℕ} (X : Fin m → Fin d → ℝ)
    (Y : Fin m → Fin q → ℝ) : Prop :=
  ∃ (w : Fin d → ℝ) (b : ℝ) (v c : Fin q → ℝ),
    ∀ i k, c k + v k * relu (affine w b (X i)) = Y i k

inductive Direction where
  | right
  | left
  deriving DecidableEq

noncomputable def hinge (o : Direction) (t x : ℝ) : ℝ :=
  match o with
  | .right => relu (x - t)
  | .left => relu (t - x)

def CommonFit {m : ℕ} (x y : Fin m → ℝ) (h : ℕ) (o : Direction) : Prop :=
  ∃ H ≤ h, ∃ (a t : Fin H → ℝ) (c : ℝ),
    ∀ i, c + ∑ j, a j * hinge o (t j) (x i) = y i

def EitherCommonFit {m : ℕ} (x y : Fin m → ℝ) (h : ℕ) : Prop :=
  CommonFit x y h .right ∨ CommonFit x y h .left

def MixedFit {m : ℕ} (x y : Fin m → ℝ) (h : ℕ) : Prop :=
  ∃ H ≤ h, ∃ (a t : Fin H → ℝ) (o : Fin H → Direction) (c : ℝ),
    ∀ i, c + ∑ j, a j * hinge (o j) (t j) (x i) = y i

theorem common_implies_mixed {m : ℕ} {x y : Fin m → ℝ} {h : ℕ} {o : Direction}
    (hf : CommonFit x y h o) : MixedFit x y h := by
  obtain ⟨H, hH, a, t, c, hf⟩ := hf
  exact ⟨H, hH, a, t, fun _ => o, c, hf⟩

theorem exactFit_mono {m d h k : ℕ} {D : ScalarData m d} (hh : h ≤ k)
    (hf : ExactFit D h) : ExactFit D k := by
  obtain ⟨H, hH, N, hf⟩ := hf
  exact ⟨H, le_trans hH hh, N, hf⟩

theorem exactFit_constant {m d h : ℕ} (D : ScalarData m d) (c : ℝ)
    (hc : ∀ i, (D.y i : ℝ) = c) : ExactFit D h := by
  refine ⟨0, Nat.zero_le _, ⟨Fin.elim0, Fin.elim0, Fin.elim0, c⟩, ?_⟩
  intro i
  simpa [Shallow.eval] using (hc i).symm

theorem exactFit_zero_iff {m d : ℕ} (D : ScalarData m d) :
    ExactFit D 0 ↔ ∃ c : ℝ, ∀ i, (D.y i : ℝ) = c := by
  constructor
  · rintro ⟨H, hH, N, hf⟩
    have hH0 : H = 0 := Nat.eq_zero_of_le_zero hH
    subst H
    refine ⟨N.outputBias, fun i => ?_⟩
    simpa [Shallow.eval] using (hf i).symm
  · rintro ⟨c, hc⟩
    exact exactFit_constant D c hc

theorem exactFit_no_conflict {m d h : ℕ} {D : ScalarData m d} (hf : ExactFit D h)
    {i j : Fin m} (hx : D.x i = D.x j) : D.y i = D.y j := by
  obtain ⟨H, _, N, hf⟩ := hf
  have heq : D.input i = D.input j := congrArg (fun x => fun k => (x k : ℝ)) hx
  have hy : (D.y i : ℝ) = (D.y j : ℝ) := by rw [← hf i, ← hf j, heq]
  exact_mod_cast hy

end ExactNN
