import ExactNN.Basic
namespace ExactNN
/-- Modular equality is exact after proving the strict range bound. -/
theorem residue_eq_iff_of_abs_sub_lt {q S R : ℤ} (hq : 0 < q)
    (hw : |S - R| < q) : S % q = R % q ↔ S = R := by
  constructor
  · intro he
    have hd : q ∣ S - R := Int.dvd_of_emod_eq_zero
      (Int.emod_eq_emod_iff_emod_sub_eq_zero.mp he)
    obtain ⟨k, hk⟩ := hd
    have hbounds := abs_lt.mp hw
    have hk0 : k = 0 := by
      by_contra hn
      have hc : k ≤ -1 ∨ 1 ≤ k := by omega
      rcases hc with hc | hc
      · have := mul_le_mul_of_nonneg_left hc (le_of_lt hq)
        nlinarith
      · have := mul_le_mul_of_nonneg_left hc (le_of_lt hq)
        nlinarith
    rw [hk0, mul_zero] at hk
    exact sub_eq_zero.mp hk
  · intro h
    rw [h]

theorem cardinality_window (L U R S : ℤ) (hSL : L ≤ S) (hSU : S ≤ U) :
    |S - R| < 1 + max (R - L) (U - R) := by
  apply abs_lt.mpr
  constructor
  · have := le_max_left (R - L) (U - R)
    omega
  · have := le_max_right (R - L) (U - R)
    omega

theorem cardinality_residue_iff (L U R S : ℤ)
    (hRL : L ≤ R) (hRU : R ≤ U) (hSL : L ≤ S) (hSU : S ≤ U) :
    let q := 1 + max (R - L) (U - R)
    S % q = R % q ↔ S = R := by
  dsimp
  apply residue_eq_iff_of_abs_sub_lt
  · have := le_max_left (R - L) (U - R)
    omega
  · exact cardinality_window L U R S hSL hSU
end ExactNN
