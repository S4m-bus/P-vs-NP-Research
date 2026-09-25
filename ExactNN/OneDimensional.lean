import ExactNN.Basic
namespace ExactNN
noncomputable def secant (x₀ x₁ y₀ y₁ : ℝ) : ℝ := (y₁ - y₀) / (x₁ - x₀)

theorem hinge_reflection (t x : ℝ) : hinge .left t x = hinge .right (-t) (-x) := by
  simp only [hinge]
  congr 1
  ring

theorem hinge_orientation (t x : ℝ) :
    hinge .left t x = hinge .right t x - (x - t) := by
  have := relu_sub_relu_neg (x - t)
  have he : -(x - t) = t - x := by ring
  rw [he] at this
  simp only [hinge]
  linarith

theorem secant_left_eq_right_sub_one (t x₀ x₁ : ℝ) (hx : x₀ ≠ x₁) :
    secant x₀ x₁ (hinge .left t x₀) (hinge .left t x₁) =
      secant x₀ x₁ (hinge .right t x₀) (hinge .right t x₁) - 1 := by
  rw [hinge_orientation t x₀, hinge_orientation t x₁]
  unfold secant
  have hn : x₁ - x₀ ≠ 0 := sub_ne_zero.mpr (Ne.symm hx)
  field_simp [hn]
  <;> ring

theorem curvature_orientation_invariant (t x₀ x₁ x₂ : ℝ)
    (h01 : x₀ ≠ x₁) (h12 : x₁ ≠ x₂) :
    secant x₁ x₂ (hinge .left t x₁) (hinge .left t x₂) -
      secant x₀ x₁ (hinge .left t x₀) (hinge .left t x₁) =
    secant x₁ x₂ (hinge .right t x₁) (hinge .right t x₂) -
      secant x₀ x₁ (hinge .right t x₀) (hinge .right t x₁) := by
  rw [secant_left_eq_right_sub_one t x₁ x₂ h12,
    secant_left_eq_right_sub_one t x₀ x₁ h01]
  ring

theorem common_left_iff_reflected_right {m : ℕ} (x y : Fin m → ℝ) (h : ℕ) :
    CommonFit x y h .left ↔ CommonFit (fun i => -x i) y h .right := by
  constructor
  · rintro ⟨H, hH, a, t, c, hf⟩
    refine ⟨H, hH, a, fun j => -t j, c, fun i => ?_⟩
    simpa only [hinge_reflection] using hf i
  · rintro ⟨H, hH, a, t, c, hf⟩
    refine ⟨H, hH, a, fun j => -t j, c, fun i => ?_⟩
    simpa only [hinge_reflection, neg_neg] using hf i

theorem pair_reconstruction (u v x₀ x₁ : ℝ) (hx : x₀ < x₁)
    (hs : (0 < u ∧ 0 < v) ∨ (u < 0 ∧ v < 0)) :
    let A := u + v
    let t := (u * x₀ + v * x₁) / A
    A ≠ 0 ∧ x₀ < t ∧ t < x₁ ∧
      A * (x₁ - t) / (x₁ - x₀) = u ∧
      A * (t - x₀) / (x₁ - x₀) = v := by
  dsimp
  have ha : u + v ≠ 0 := by rcases hs with ⟨hu, hv⟩ | ⟨hu, hv⟩ <;> linarith
  have hgap : x₁ - x₀ ≠ 0 := by linarith
  refine ⟨ha, ?_, ?_, ?_, ?_⟩
  · rcases hs with ⟨hu, hv⟩ | ⟨hu, hv⟩
    · apply (lt_div_iff₀ (by linarith : 0 < u + v)).mpr
      nlinarith [mul_pos hv (sub_pos.mpr hx)]
    · apply (lt_div_iff_of_neg (by linarith : u + v < 0)).mpr
      nlinarith [mul_neg_of_neg_of_pos hv (sub_pos.mpr hx)]
  · rcases hs with ⟨hu, hv⟩ | ⟨hu, hv⟩
    · apply (div_lt_iff₀ (by linarith : 0 < u + v)).mpr
      nlinarith [mul_pos hu (sub_pos.mpr hx)]
    · apply (div_lt_iff_of_neg (by linarith : u + v < 0)).mpr
      nlinarith [mul_neg_of_neg_of_pos hu (sub_pos.mpr hx)]
  · field_simp [ha, hgap]
    <;> ring
  · field_simp [ha, hgap]
    <;> ring

/-- Sample preservation outside a gap, not equality between its knots. -/
theorem merge_hinges_outside_gap (a b t s l r x : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hab : 0 < a + b)
    (htl : l ≤ t) (htr : t ≤ r) (hsl : l ≤ s) (hsr : s ≤ r)
    (hx : x ≤ l ∨ r ≤ x) :
    (a + b) * relu (x - (a * t + b * s) / (a + b)) =
      a * relu (x - t) + b * relu (x - s) := by
  have htbarl : l ≤ (a * t + b * s) / (a + b) := by
    apply (le_div_iff₀ hab).mpr
    nlinarith [mul_nonneg ha (sub_nonneg.mpr htl), mul_nonneg hb (sub_nonneg.mpr hsl)]
  have htbarr : (a * t + b * s) / (a + b) ≤ r := by
    apply (div_le_iff₀ hab).mpr
    nlinarith [mul_nonneg ha (sub_nonneg.mpr htr), mul_nonneg hb (sub_nonneg.mpr hsr)]
  rcases hx with hx | hx
  · rw [relu_of_nonpos (by linarith : x - (a*t+b*s)/(a+b) ≤ 0),
      relu_of_nonpos (by linarith : x-t ≤ 0), relu_of_nonpos (by linarith : x-s ≤ 0)]
    ring
  · rw [relu_of_nonneg (by linarith : 0 ≤ x - (a*t+b*s)/(a+b)),
      relu_of_nonneg (by linarith : 0 ≤ x-t), relu_of_nonneg (by linarith : 0 ≤ x-s)]
    field_simp [ne_of_gt hab]
    <;> ring

theorem samples_eq_of_differences (n : ℕ) (f g : Fin (n + 1) → ℝ)
    (h0 : f 0 = g 0)
    (hs : ∀ i : Fin n, f i.succ - f i.castSucc = g i.succ - g i.castSucc) : f = g := by
  funext i
  refine Fin.induction h0 (fun j hj => ?_) i
  have := hs j
  linarith

/-- The geometric at-most-one-anchor premise remains explicit. -/
theorem helper_count_bound {K H : ℕ} (helps : Fin H → Fin K → Prop)
    (covered : ∀ k, ∃ j, helps j k)
    (uniqueAnchor : ∀ j k l, helps j k → helps j l → k = l) : K ≤ H := by
  classical
  choose helper hh using covered
  have hinj : Function.Injective helper := by
    intro k l h
    exact uniqueAnchor (helper k) k l (hh k) (h.symm ▸ hh l)
  simpa using Fintype.card_le_of_injective helper hinj

theorem unique_helpers_at_bound {K : ℕ} (helps : Fin K → Fin K → Prop)
    (covered : ∀ k, ∃ j, helps j k)
    (uniqueAnchor : ∀ j k l, helps j k → helps j l → k = l) :
    (∀ k, ∃! j, helps j k) ∧ (∀ j, ∃! k, helps j k) := by
  classical
  choose helper hh using covered
  have hinj : Function.Injective helper := by
    intro k l h
    exact uniqueAnchor (helper k) k l (hh k) (h.symm ▸ hh l)
  have hsurj : Function.Surjective helper := Finite.surjective_of_injective hinj
  constructor
  · intro k
    refine ⟨helper k, hh k, ?_⟩
    intro j hj
    obtain ⟨l, rfl⟩ := hsurj j
    have : l = k := uniqueAnchor (helper l) l k (hh l) hj
    exact congrArg helper this
  · intro j
    obtain ⟨k, rfl⟩ := hsurj j
    exact ⟨k, hh k, fun l hl => (uniqueAnchor (helper k) k l (hh k) hl).symm⟩
end ExactNN
