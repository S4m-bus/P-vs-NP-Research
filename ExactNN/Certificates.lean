import ExactNN.Basic
import Mathlib.LinearAlgebra.Matrix.DotProduct
namespace ExactNN
/-- Exact deletion test for the supplied factor; not a group selector. -/
theorem gram_kernel_iff {r n : ℕ} (H : Matrix (Fin r) (Fin n) ℝ) (v : Fin n → ℝ) :
    (H.transpose * H).mulVec v = 0 ↔ H.mulVec v = 0 := by
  simpa using Matrix.conjTranspose_mul_self_mulVec_eq_zero H v

/-- Soundness of a supplied rational/real linear infeasibility certificate. -/
theorem linear_infeasible_of_certificate {r n : ℕ}
    (A : Fin r → Fin n → ℝ) (b λ : Fin r → ℝ)
    (hλ : ∀ i, 0 ≤ λ i)
    (hcancel : ∀ j, ∑ i, λ i * A i j = 0)
    (hneg : ∑ i, λ i * b i < 0) :
    ¬ ∃ x : Fin n → ℝ, ∀ i, (∑ j, A i j * x j) ≤ b i := by
  rintro ⟨x, hx⟩
  have hsum : (∑ i, λ i * (∑ j, A i j * x j)) ≤ ∑ i, λ i * b i := by
    apply Finset.sum_le_sum
    intro i _
    exact mul_le_mul_of_nonneg_left (hx i) (hλ i)
  have hz : (∑ i, λ i * (∑ j, A i j * x j)) = 0 := by
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
