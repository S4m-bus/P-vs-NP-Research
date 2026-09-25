import ExactNN.Basic
namespace ExactNN
noncomputable def Shallow.pad {d h : ℕ} (N : Shallow d h) (k : ℕ) : Shallow d (h + k) where
  weight := Fin.addCases N.weight (fun _ _ => 0)
  hiddenBias := Fin.addCases N.hiddenBias (fun _ => 0)
  coeff := Fin.addCases N.coeff (fun _ => 0)
  outputBias := N.outputBias

theorem Shallow.eval_pad {d h : ℕ} (N : Shallow d h) (k : ℕ) (x : Fin d → ℝ) :
    (N.pad k).eval x = N.eval x := by
  simp [Shallow.eval, Shallow.pad, Fin.sum_univ_add]

theorem exactFit_iff_slots {m d h : ℕ} (D : ScalarData m d) :
    ExactFit D h ↔ ∃ N : Shallow d h, ∀ i, N.eval (D.input i) = (D.y i : ℝ) := by
  constructor
  · rintro ⟨H, hH, N, hf⟩
    obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le hH
    exact ⟨N.pad k, fun i => by rw [Shallow.eval_pad]; exact hf i⟩
  · rintro ⟨N, hf⟩
    exact ⟨h, le_rfl, N, hf⟩

theorem exactFit_one_iff {m d : ℕ} (D : ScalarData m d) :
    ExactFit D 1 ↔ OneFit D.input (fun i => (D.y i : ℝ)) := by
  rw [exactFit_iff_slots]
  constructor
  · rintro ⟨N, hf⟩
    refine ⟨N.weight 0, N.hiddenBias 0, N.coeff 0, N.outputBias, fun i => ?_⟩
    simpa [Shallow.eval, Fin.sum_univ_one] using hf i
  · rintro ⟨w, b, a, c, hf⟩
    refine ⟨⟨fun _ => w, fun _ => b, fun _ => a, c⟩, fun i => ?_⟩
    simpa [Shallow.eval, Fin.sum_univ_one] using hf i

noncomputable def signCoeff (a : ℝ) : ℝ := if 0 ≤ a then 1 else -1

theorem signCoeff_cases (a : ℝ) : signCoeff a = 1 ∨ signCoeff a = -1 := by
  unfold signCoeff
  split_ifs <;> simp

theorem normalize_term (a v : ℝ) :
    signCoeff a * relu (|a| * v) = a * relu v := by
  rw [relu_mul (abs_nonneg a)]
  by_cases ha : 0 ≤ a
  · simp [signCoeff, ha, abs_of_nonneg ha]
  · rw [abs_of_neg (lt_of_not_ge ha)]
    simp [signCoeff, ha]

noncomputable def Shallow.normalize {d h : ℕ} (N : Shallow d h) : Shallow d h where
  weight := fun j k => |N.coeff j| * N.weight j k
  hiddenBias := fun j => |N.coeff j| * N.hiddenBias j
  coeff := fun j => signCoeff (N.coeff j)
  outputBias := N.outputBias

theorem Shallow.eval_normalize {d h : ℕ} (N : Shallow d h) (x : Fin d → ℝ) :
    N.normalize.eval x = N.eval x := by
  unfold Shallow.eval Shallow.normalize
  congr 1
  apply Finset.sum_congr rfl
  intro j _
  rw [affine_scale, normalize_term]

/-- Every slot has one affine vector shared across all samples. -/
def SharedComplementarity {m d : ℕ} (D : ScalarData m d) (h : ℕ) : Prop :=
  ∃ N : Shallow d h, ∃ z : Fin m → Fin h → ℝ,
    (∀ j, N.coeff j = 1 ∨ N.coeff j = -1) ∧
    (∀ i j, 0 ≤ z i j ∧ affine (N.weight j) (N.hiddenBias j) (D.input i) ≤ z i j ∧
      z i j * (z i j - affine (N.weight j) (N.hiddenBias j) (D.input i)) = 0) ∧
    (∀ i, N.outputBias + ∑ j, N.coeff j * z i j = (D.y i : ℝ))

/-- Semantic equivalence, not an algorithm for selecting activations. -/
theorem exactFit_iff_sharedComplementarity {m d h : ℕ} (D : ScalarData m d) :
    ExactFit D h ↔ SharedComplementarity D h := by
  rw [exactFit_iff_slots]
  constructor
  · rintro ⟨N, hf⟩
    refine ⟨N.normalize,
      fun i j => relu (affine (N.normalize.weight j) (N.normalize.hiddenBias j) (D.input i)),
      fun j => signCoeff_cases (N.coeff j), ?_, ?_⟩
    · intro i j
      exact (relu_eq_iff _ _).mp rfl
    · intro i
      change N.normalize.eval (D.input i) = _
      rw [Shallow.eval_normalize]
      exact hf i
  · rintro ⟨N, z, _, hz, hy⟩
    refine ⟨N, fun i => ?_⟩
    unfold Shallow.eval
    convert hy i using 1
    congr 1
    apply Finset.sum_congr rfl
    intro j _
    rw [(relu_eq_iff _ _).mpr (hz i j)]

def bit (b : Bool) : ℝ := if b then 1 else 0

theorem binary_product_iff (b : Bool) (M z u : ℝ) (hz : 0 ≤ z) (hM : z ≤ M) :
    (0 ≤ u ∧ u ≤ z ∧ u ≤ M * bit b ∧ z - M * (1 - bit b) ≤ u) ↔
      u = bit b * z := by
  cases b <;> simp only [bit, Bool.false_eq_true, ↓reduceIte]
  · constructor
    · rintro ⟨h0, _, hu, _⟩
      nlinarith
    · intro hu
      constructor
      · nlinarith
      constructor
      · nlinarith
      constructor <;> nlinarith
  · constructor
    · rintro ⟨_, hu, _, hl⟩
      nlinarith
    · intro hu
      constructor
      · nlinarith
      constructor
      · nlinarith
      constructor <;> nlinarith

theorem bigM_relu_iff (M v z : ℝ) (hv : |v| ≤ M) :
    (∃ b : Bool, 0 ≤ z ∧ v ≤ z ∧ z ≤ M * bit b ∧
      z ≤ v + M * (1 - bit b)) ↔ relu v = z := by
  constructor
  · rintro ⟨b, hz, hvz, h1, h2⟩
    cases b
    · simp [bit] at h1 h2
      have hz0 : z = 0 := le_antisymm h1 hz
      rw [hz0]
      apply relu_of_nonpos
      linarith
    · simp [bit] at h1 h2
      have h : z = v := le_antisymm h2 hvz
      rw [h]
      apply relu_of_nonneg
      linarith
  · intro he
    rcases abs_le.mp hv with ⟨hlo, hhi⟩
    by_cases hv0 : 0 ≤ v
    · rw [relu_of_nonneg hv0] at he
      refine ⟨true, ?_⟩
      simp only [bit, ↓reduceIte]
      constructor
      · linarith
      constructor
      · linarith
      constructor <;> nlinarith
    · rw [relu_of_nonpos (le_of_not_ge hv0)] at he
      refine ⟨false, ?_⟩
      simp only [bit, Bool.false_eq_true, ↓reduceIte]
      constructor
      · linarith
      constructor
      · linarith
      constructor <;> nlinarith
end ExactNN
