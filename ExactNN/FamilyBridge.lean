import ExactNN.SharedParameters
namespace ExactNN

noncomputable def weightDirection (w : ℝ) : Direction :=
  if 0 < w then .right else .left

/-- Every nonconstant one-dimensional ReLU is an oriented hinge. -/
theorem univariate_hinge_identity (w b x : ℝ) (hw : w ≠ 0) :
    relu (w * x + b) = |w| * hinge (weightDirection w) (-b / w) x := by
  by_cases hp : 0 < w
  · have he : w * x + b = w * (x - (-b / w)) := by field_simp; ring
    rw [he, relu_mul (le_of_lt hp)]
    simp [weightDirection, hp, hinge, abs_of_pos hp]
  · have hn : w < 0 := lt_of_le_of_ne (le_of_not_gt hp) hw
    have he : w * x + b = (-w) * ((-b / w) - x) := by field_simp; ring
    rw [he, relu_mul (le_of_lt (neg_pos.mpr hn))]
    simp [weightDirection, hp, hinge, abs_of_neg hn]

/-- Zero incoming weights are constants absorbed into the free output bias. -/
theorem univariate_term_decomposition (w b a x : ℝ) :
    a * relu (w * x + b) =
      (if w = 0 then a * relu b else 0) +
      (if w = 0 then 0 else a * |w|) * hinge (weightDirection w) (-b / w) x := by
  by_cases hw : w = 0
  · simp [hw]
  · simp only [hw, ↓reduceIte, zero_add]
    rw [univariate_hinge_identity w b x hw]
    ring

/-- Exact width-preserving connection between the mixed-hinge and shallow models. -/
theorem mixedFit_iff_shallow_one {m : ℕ} (x y : Fin m → ℝ) (h : ℕ) :
    MixedFit x y h ↔ ∃ H ≤ h, ∃ N : Shallow 1 H,
      ∀ i, N.eval (fun _ => x i) = y i := by
  constructor
  · rintro ⟨H, hH, a, t, o, c, hf⟩
    let N : Shallow 1 H := {
      weight := fun j _ => match o j with | .right => 1 | .left => -1
      hiddenBias := fun j => match o j with | .right => -t j | .left => t j
      coeff := a
      outputBias := c }
    refine ⟨H, hH, N, fun i => ?_⟩
    rw [← hf i]
    change c + ∑ j, a j * relu (affine (N.weight j) (N.hiddenBias j) (fun _ => x i)) = _
    congr 1
    apply Finset.sum_congr rfl
    intro j _
    congr 1
    cases ho : o j <;> simp [N, ho, affine, hinge, sub_eq_add_neg, add_comm]
  · rintro ⟨H, hH, N, hf⟩
    let w := fun j => N.weight j 0
    let a := fun j => if w j = 0 then 0 else N.coeff j * |w j|
    let t := fun j => -N.hiddenBias j / w j
    let o := fun j => weightDirection (w j)
    let c0 := fun j => if w j = 0 then N.coeff j * relu (N.hiddenBias j) else 0
    refine ⟨H, hH, a, t, o, N.outputBias + ∑ j, c0 j, fun i => ?_⟩
    calc
      (N.outputBias + ∑ j, c0 j) + ∑ j, a j * hinge (o j) (t j) (x i) =
          N.outputBias + ∑ j, (c0 j + a j * hinge (o j) (t j) (x i)) := by
            rw [Finset.sum_add_distrib]
            ring
      _ = N.eval (fun _ => x i) := by
        unfold Shallow.eval
        congr 1
        apply Finset.sum_congr rfl
        intro j _
        dsimp [a, t, o, c0]
        rw [← univariate_term_decomposition]
        simp [w, affine, Fin.sum_univ_one, add_comm]
      _ = y i := hf i

theorem exactFit_dim_one_iff_mixed {m h : ℕ} (D : ScalarData m 1) :
    ExactFit D h ↔ MixedFit (fun i => (D.x i 0 : ℝ)) (fun i => (D.y i : ℝ)) h := by
  rw [mixedFit_iff_shallow_one]
  have hi : ∀ i, D.input i = fun _ => (D.x i 0 : ℝ) := by
    intro i
    funext k
    have hk : k = 0 := Subsingleton.elim k 0
    simp [ScalarData.input, hk]
  simp only [ExactFit, hi]
end ExactNN
