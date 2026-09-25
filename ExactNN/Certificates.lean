import ExactNN.Basic
import Mathlib.LinearAlgebra.Matrix.DotProduct
namespace ExactNN
/-- Exact deletion test for the supplied factor; not a group selector. -/
theorem gram_kernel_iff {r n : ℕ} (H : Matrix (Fin r) (Fin n) ℝ) (v : Fin n → ℝ) :
    (H.transpose * H).mulVec v = 0 ↔ H.mulVec v = 0 := by
  constructor
  · intro hv
    have hd : dotProduct v ((H.transpose * H).mulVec v) =
        dotProduct (H.mulVec v) (H.mulVec v) := by
      rw [← Matrix.mulVec_mulVec, Matrix.dotProduct_mulVec, Matrix.vecMul_transpose]
    have hz : ∑ i, (H.mulVec v) i * (H.mulVec v) i = 0 := by
      change dotProduct (H.mulVec v) (H.mulVec v) = 0
      rw [← hd, hv, dotProduct_zero]
    funext i
    have hi := congrFun ((Fintype.sum_eq_zero_iff_of_nonneg
      (fun i => mul_self_nonneg ((H.mulVec v) i))).mp hz) i
    exact mul_self_eq_zero.mp hi
  · intro hv
    rw [← Matrix.mulVec_mulVec, hv, Matrix.mulVec_zero]

/-- Soundness of a supplied rational/real linear infeasibility certificate. -/
theorem linear_infeasible_of_certificate {r n : ℕ}
    (A : Fin r → Fin n → ℝ) (b multiplier : Fin r → ℝ)
    (hλ : ∀ i, 0 ≤ multiplier i)
    (hcancel : ∀ j, ∑ i, multiplier i * A i j = 0)
    (hneg : ∑ i, multiplier i * b i < 0) :
    ¬ ∃ x : Fin n → ℝ, ∀ i, (∑ j, A i j * x j) ≤ b i := by
  rintro ⟨x, hx⟩
  have hsum : (∑ i, multiplier i * (∑ j, A i j * x j)) ≤ ∑ i, multiplier i * b i := by
    apply Finset.sum_le_sum
    intro i _
    exact mul_le_mul_of_nonneg_left (hx i) (hλ i)
  have hz : (∑ i, multiplier i * (∑ j, A i j * x j)) = 0 := by
    simp_rw [Finset.mul_sum, ← mul_assoc]
    rw [Finset.sum_comm]
    simp_rw [← Finset.sum_mul, hcancel, zero_mul]
    simp
  linarith

inductive Outcome (W : Type) where
  | yes (witness : W)
  | no
  | unresolved

def OutcomeSound {W : Type} (valid : W → Prop) : Outcome W → Prop
  | .yes w => valid w
  | .no => ¬ ∃ w, valid w
  | .unresolved => True

def firstResolved {W : Type} (a b : Outcome W) : Outcome W :=
  match a with
  | .unresolved => b
  | other => other

theorem firstResolved_sound {W : Type} (valid : W → Prop) (a b : Outcome W)
    (ha : OutcomeSound valid a) (hb : OutcomeSound valid b) :
    OutcomeSound valid (firstResolved a b) := by
  cases a <;> simp_all [firstResolved, OutcomeSound]
end ExactNN
