import ExactNN.Basic
namespace ExactNN

def PositiveFit {m d : ℕ} (X : Fin m → Fin d → ℝ) (y : Fin m → ℝ) : Prop :=
  ∃ (w : Fin d → ℝ) (b c : ℝ), ∀ i, c + relu (affine w b (X i)) = y i

def PositiveLP {m d : ℕ} (X : Fin m → Fin d → ℝ) (y : Fin m → ℝ)
    (base : ℝ) : Prop :=
  ∃ (w : Fin d → ℝ) (b : ℝ), ∀ i,
    (0 < y i - base → affine w b (X i) = y i - base) ∧
    (y i - base = 0 → affine w b (X i) ≤ 0)

theorem oneFit_iff_positive_or_negative {m d : ℕ}
    (X : Fin m → Fin d → ℝ) (y : Fin m → ℝ) :
    OneFit X y ↔ PositiveFit X y ∨ PositiveFit X (fun i => -y i) := by
  constructor
  · rintro ⟨w, b, a, c, hf⟩
    by_cases ha : 0 ≤ a
    · left
      refine ⟨fun k => a * w k, a * b, c, ?_⟩
      intro i
      rw [affine_scale, relu_mul ha]
      exact hf i
    · right
      have ha' : 0 ≤ -a := by linarith
      refine ⟨fun k => -a * w k, -a * b, -c, ?_⟩
      intro i
      rw [affine_scale, relu_mul ha']
      linarith [hf i]
  · rintro (⟨w, b, c, hf⟩ | ⟨w, b, c, hf⟩)
    · exact ⟨w, b, 1, c, fun i => by simpa using hf i⟩
    · refine ⟨w, b, -1, -c, fun i => ?_⟩
      linarith [hf i]

theorem relu_shift {x t : ℝ} (ht : 0 ≤ t) (hx : t ≤ relu x) :
    relu (x - t) = relu x - t := by
  by_cases ht0 : t = 0
  · simp [ht0]
  · have htpos : 0 < t := lt_of_le_of_ne ht (Ne.symm ht0)
    have hx0 : 0 ≤ x := by
      by_contra hn
      rw [relu_of_nonpos (le_of_not_ge hn)] at hx
      linarith
    rw [relu_of_nonneg hx0] at hx ⊢
    exact relu_of_nonneg (sub_nonneg.mpr hx)

/-- Bias normalization includes the all-active case. -/
theorem positiveFit_iff_lp_at_min {m d : ℕ}
    (X : Fin m → Fin d → ℝ) (y : Fin m → ℝ) (i₀ : Fin m)
    (hmin : ∀ i, y i₀ ≤ y i) :
    PositiveFit X y ↔ PositiveLP X y (y i₀) := by
  constructor
  · rintro ⟨w, b, c, hf⟩
    let t := y i₀ - c
    have ht : 0 ≤ t := by dsimp [t]; linarith [hf i₀, relu_nonneg (affine w b (X i₀))]
    refine ⟨w, b - t, fun i => ?_⟩
    apply (relu_target_iff (sub_nonneg.mpr (hmin i)) _).mp
    rw [affine_shift, relu_shift ht]
    · dsimp [t]
      linarith [hf i]
    · dsimp [t]
      linarith [hf i, hmin i]
  · rintro ⟨w, b, hf⟩
    refine ⟨w, b, y i₀, fun i => ?_⟩
    have he := (relu_target_iff (sub_nonneg.mpr (hmin i)) _).mpr (hf i)
    linarith

/-- Specification Theorem 1, including constant data with supplied extrema. -/
theorem oneFit_iff_twoLP {m d : ℕ}
    (X : Fin m → Fin d → ℝ) (y : Fin m → ℝ) (ilo ihi : Fin m)
    (hmin : ∀ i, y ilo ≤ y i) (hmax : ∀ i, y i ≤ y ihi) :
    OneFit X y ↔
      PositiveLP X y (y ilo) ∨ PositiveLP X (fun i => -y i) (-y ihi) := by
  rw [oneFit_iff_positive_or_negative,
    positiveFit_iff_lp_at_min X y ilo hmin,
    positiveFit_iff_lp_at_min X (fun i => -y i) ihi (fun i => neg_le_neg (hmax i))]

theorem vectorOneFit_coordinate {m d q : ℕ}
    {X : Fin m → Fin d → ℝ} {Y : Fin m → Fin q → ℝ}
    (hf : VectorOneFit X Y) (a : Fin q) : OneFit X (fun i => Y i a) := by
  obtain ⟨w, b, v, c, hf⟩ := hf
  exact ⟨w, b, v a, c a, fun i => hf i a⟩

def AffineCollinear {m q : ℕ} (Y : Fin m → Fin q → ℝ)
    (i₀ : Fin m) (a : Fin q) : Prop :=
  ∃ r : Fin q → ℝ, ∀ i k, Y i k = Y i₀ k + r k * (Y i a - Y i₀ a)

theorem vectorOneFit_collinear {m d q : ℕ}
    {X : Fin m → Fin d → ℝ} {Y : Fin m → Fin q → ℝ}
    (hf : VectorOneFit X Y) (i₀ i₁ : Fin m) (a : Fin q)
    (hne : Y i₁ a ≠ Y i₀ a) : AffineCollinear Y i₀ a := by
  obtain ⟨w, b, v, c, hf⟩ := hf
  have hva : v a ≠ 0 := by
    intro hz
    apply hne
    have h0 := hf i₀ a
    have h1 := hf i₁ a
    simp only [hz, zero_mul, add_zero] at h0 h1
    exact h1.symm.trans h0
  refine ⟨fun k => v k / v a, fun i k => ?_⟩
  rw [← hf i k, ← hf i₀ k, ← hf i a, ← hf i₀ a]
  field_simp [hva]
  <;> ring

theorem vectorOneFit_of_coordinate {m d q : ℕ}
    {X : Fin m → Fin d → ℝ} {Y : Fin m → Fin q → ℝ}
    (i₀ : Fin m) (a : Fin q) (hc : AffineCollinear Y i₀ a)
    (hf : OneFit X (fun i => Y i a)) : VectorOneFit X Y := by
  obtain ⟨r, hr⟩ := hc
  obtain ⟨w, b, s, c, hf⟩ := hf
  refine ⟨w, b, fun k => r k * s, fun k => Y i₀ k + r k * (c - Y i₀ a), ?_⟩
  intro i k
  rw [hr i k, ← hf i]
  ring

/-- Specification Theorem 2 with one supplied varying coordinate. -/
theorem vectorOneFit_iff_collinear_coordinate {m d q : ℕ}
    (X : Fin m → Fin d → ℝ) (Y : Fin m → Fin q → ℝ)
    (i₀ i₁ : Fin m) (a : Fin q) (hne : Y i₁ a ≠ Y i₀ a) :
    VectorOneFit X Y ↔ AffineCollinear Y i₀ a ∧ OneFit X (fun i => Y i a) := by
  constructor
  · intro hf
    exact ⟨vectorOneFit_collinear hf i₀ i₁ a hne, vectorOneFit_coordinate hf a⟩
  · rintro ⟨hc, hf⟩
    exact vectorOneFit_of_coordinate i₀ a hc hf

theorem vectorOneFit_constant {m d q : ℕ}
    (X : Fin m → Fin d → ℝ) (Y : Fin m → Fin q → ℝ)
    (c : Fin q → ℝ) (hc : ∀ i k, Y i k = c k) : VectorOneFit X Y := by
  refine ⟨fun _ => 0, 0, fun _ => 0, c, fun i k => ?_⟩
  simpa using (hc i k).symm

theorem collinear_direction_ratio {m q : ℕ}
    (Y : Fin m → Fin q → ℝ) (i₀ i₁ : Fin m) (a : Fin q)
    (r : Fin q → ℝ)
    (hr : ∀ i k, Y i k = Y i₀ k + r k * (Y i a - Y i₀ a))
    (hne : Y i₁ a ≠ Y i₀ a) :
    ∀ k, r k = (Y i₁ k - Y i₀ k) / (Y i₁ a - Y i₀ a) := by
  intro k
  apply (eq_div_iff (sub_ne_zero.mpr hne)).mpr
  linarith [hr i₁ k]
end ExactNN
