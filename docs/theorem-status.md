# Theorem status — 2026-09-25

All 59 declarations below compiled with Lean 4.19.0 and passed the per-theorem
axiom audit. Each uses only a subset of `propext`, `Classical.choice`, and
`Quot.sound`. The exact declarations, including every hypothesis, are in the
linked Lean modules. Proof explanations use the M-labels in
[mathematics.md](mathematics.md).

The complete evidence is in [the build log](../verification/build.log),
[axioms log](../verification/axioms.log), and
[source-hash summary](../verification/summary.json).

## Source proofs and Lean coverage

The previous report mixed incomplete Lean translation with mathematical work
left open by the source. The [corrected O1–O8 table](obligations.md) gives exact
source theorem references and separates those statuses.

| Subject | Existing source argument | Lean coverage and remaining work |
|---|---|---|
| Family 1 | §3, Theorems 1–2; reference LP complexity | Characterizations checked; executable LP/bit-cost formalization pending |
| Family 2 | §4, Theorem 3: minimum width, construction and costs | Supporting lemmas checked; full source-proof translation pending (O1) |
| Family 3 | §§5–7, Theorems 4–8: threshold and complete bounded representations | Structural components checked; full translations pending (O2); selector separately open in source (O3) |
| Family 4 | §§9–10, Theorems 10–12: construction, rational bounds and bounded equivalence | Complementarity/binary components checked; full translations pending (O4); selector separately open in source (O5) |
| Broader coverage | Dated §1 scope plus handoff Part 4 request | Shared composition checked; broader class/transformation still to be specified and formalized (O6) |
| Algorithm | Theorem 13 conditional soundness, §13 costs, Theorem 14 conditional completion | Partial-outcome component checked; source arguments/code connection pending; completion retains selectors (O7) |
| Complexity consequence | §14.3, Theorem 16 conditional argument | Definitions/implication pending; matching ETR reduction separately open in the dated source (O8) |

The checked helper-count, big-M and residue declarations expose their hypotheses.
The source gives wider arguments supplying relevant geometric or numerical
conditions; those complete arguments have not all been translated here.

## Complete declaration list

| Declaration | Lean module | Proof correspondence | Status |
|---|---|---|---|
| `ExactNN.relu_zero` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.relu_nonneg` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.le_relu` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.relu_of_nonneg` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.relu_of_nonpos` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.relu_mul` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.relu_sub_relu_neg` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.relu_eq_iff` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.relu_target_iff` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.affine_scale` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.affine_shift` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.common_implies_mixed` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.exactFit_mono` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.exactFit_constant` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.exactFit_zero_iff` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.exactFit_no_conflict` | [Basic.lean](../ExactNN/Basic.lean) | M01–M02: exact models, ReLU algebra, preprocessing | Verified; audit passed |
| `ExactNN.gram_kernel_iff` | [Certificates.lean](../ExactNN/Certificates.lean) | M09–M10: certificate algebra and sound partial outcomes | Verified; audit passed |
| `ExactNN.linear_infeasible_of_certificate` | [Certificates.lean](../ExactNN/Certificates.lean) | M09–M10: certificate algebra and sound partial outcomes | Verified; audit passed |
| `ExactNN.firstResolved_sound` | [Certificates.lean](../ExactNN/Certificates.lean) | M09–M10: certificate algebra and sound partial outcomes | Verified; audit passed |
| `ExactNN.oneFit_iff_positive_or_negative` | [Family1.lean](../ExactNN/Family1.lean) | M03–M04: scalar and shared multiple-output characterizations | Verified; audit passed |
| `ExactNN.relu_shift` | [Family1.lean](../ExactNN/Family1.lean) | M03–M04: scalar and shared multiple-output characterizations | Verified; audit passed |
| `ExactNN.positiveFit_iff_lp_at_min` | [Family1.lean](../ExactNN/Family1.lean) | M03–M04: scalar and shared multiple-output characterizations | Verified; audit passed |
| `ExactNN.oneFit_iff_twoLP` | [Family1.lean](../ExactNN/Family1.lean) | M03–M04: scalar and shared multiple-output characterizations | Verified; audit passed |
| `ExactNN.vectorOneFit_coordinate` | [Family1.lean](../ExactNN/Family1.lean) | M03–M04: scalar and shared multiple-output characterizations | Verified; audit passed |
| `ExactNN.vectorOneFit_collinear` | [Family1.lean](../ExactNN/Family1.lean) | M03–M04: scalar and shared multiple-output characterizations | Verified; audit passed |
| `ExactNN.vectorOneFit_of_coordinate` | [Family1.lean](../ExactNN/Family1.lean) | M03–M04: scalar and shared multiple-output characterizations | Verified; audit passed |
| `ExactNN.vectorOneFit_iff_collinear_coordinate` | [Family1.lean](../ExactNN/Family1.lean) | M03–M04: scalar and shared multiple-output characterizations | Verified; audit passed |
| `ExactNN.vectorOneFit_constant` | [Family1.lean](../ExactNN/Family1.lean) | M03–M04: scalar and shared multiple-output characterizations | Verified; audit passed |
| `ExactNN.collinear_direction_ratio` | [Family1.lean](../ExactNN/Family1.lean) | M03–M04: scalar and shared multiple-output characterizations | Verified; audit passed |
| `ExactNN.univariate_hinge_identity` | [FamilyBridge.lean](../ExactNN/FamilyBridge.lean) | M11: width-preserving one-dimensional equivalence | Verified; audit passed |
| `ExactNN.univariate_term_decomposition` | [FamilyBridge.lean](../ExactNN/FamilyBridge.lean) | M11: width-preserving one-dimensional equivalence | Verified; audit passed |
| `ExactNN.mixedFit_iff_shallow_one` | [FamilyBridge.lean](../ExactNN/FamilyBridge.lean) | M11: width-preserving one-dimensional equivalence | Verified; audit passed |
| `ExactNN.exactFit_dim_one_iff_mixed` | [FamilyBridge.lean](../ExactNN/FamilyBridge.lean) | M11: width-preserving one-dimensional equivalence | Verified; audit passed |
| `ExactNN.hinge_reflection` | [OneDimensional.lean](../ExactNN/OneDimensional.lean) | M05–M06: hinge geometry and explicit helper premises | Verified; audit passed |
| `ExactNN.hinge_orientation` | [OneDimensional.lean](../ExactNN/OneDimensional.lean) | M05–M06: hinge geometry and explicit helper premises | Verified; audit passed |
| `ExactNN.secant_left_eq_right_sub_one` | [OneDimensional.lean](../ExactNN/OneDimensional.lean) | M05–M06: hinge geometry and explicit helper premises | Verified; audit passed |
| `ExactNN.curvature_orientation_invariant` | [OneDimensional.lean](../ExactNN/OneDimensional.lean) | M05–M06: hinge geometry and explicit helper premises | Verified; audit passed |
| `ExactNN.common_left_iff_reflected_right` | [OneDimensional.lean](../ExactNN/OneDimensional.lean) | M05–M06: hinge geometry and explicit helper premises | Verified; audit passed |
| `ExactNN.pair_reconstruction` | [OneDimensional.lean](../ExactNN/OneDimensional.lean) | M05–M06: hinge geometry and explicit helper premises | Verified; audit passed |
| `ExactNN.merge_hinges_outside_gap` | [OneDimensional.lean](../ExactNN/OneDimensional.lean) | M05–M06: hinge geometry and explicit helper premises | Verified; audit passed |
| `ExactNN.samples_eq_of_differences` | [OneDimensional.lean](../ExactNN/OneDimensional.lean) | M05–M06: hinge geometry and explicit helper premises | Verified; audit passed |
| `ExactNN.helper_count_bound` | [OneDimensional.lean](../ExactNN/OneDimensional.lean) | M05–M06: hinge geometry and explicit helper premises | Verified; audit passed |
| `ExactNN.unique_helpers_at_bound` | [OneDimensional.lean](../ExactNN/OneDimensional.lean) | M05–M06: hinge geometry and explicit helper premises | Verified; audit passed |
| `ExactNN.residue_eq_iff_of_abs_sub_lt` | [Orientation.lean](../ExactNN/Orientation.lean) | M09: exact residue tests with explicit range bounds | Verified; audit passed |
| `ExactNN.cardinality_window` | [Orientation.lean](../ExactNN/Orientation.lean) | M09: exact residue tests with explicit range bounds | Verified; audit passed |
| `ExactNN.cardinality_residue_iff` | [Orientation.lean](../ExactNN/Orientation.lean) | M09: exact residue tests with explicit range bounds | Verified; audit passed |
| `ExactNN.Shallow.eval_pad` | [SharedParameters.lean](../ExactNN/SharedParameters.lean) | M07–M08: normalized shared formulation and bounded linearization | Verified; audit passed |
| `ExactNN.exactFit_iff_slots` | [SharedParameters.lean](../ExactNN/SharedParameters.lean) | M07–M08: normalized shared formulation and bounded linearization | Verified; audit passed |
| `ExactNN.exactFit_one_iff` | [SharedParameters.lean](../ExactNN/SharedParameters.lean) | M07–M08: normalized shared formulation and bounded linearization | Verified; audit passed |
| `ExactNN.signCoeff_cases` | [SharedParameters.lean](../ExactNN/SharedParameters.lean) | M07–M08: normalized shared formulation and bounded linearization | Verified; audit passed |
| `ExactNN.normalize_term` | [SharedParameters.lean](../ExactNN/SharedParameters.lean) | M07–M08: normalized shared formulation and bounded linearization | Verified; audit passed |
| `ExactNN.Shallow.eval_normalize` | [SharedParameters.lean](../ExactNN/SharedParameters.lean) | M07–M08: normalized shared formulation and bounded linearization | Verified; audit passed |
| `ExactNN.exactFit_iff_sharedComplementarity` | [SharedParameters.lean](../ExactNN/SharedParameters.lean) | M07–M08: normalized shared formulation and bounded linearization | Verified; audit passed |
| `ExactNN.binary_product_iff` | [SharedParameters.lean](../ExactNN/SharedParameters.lean) | M07–M08: normalized shared formulation and bounded linearization | Verified; audit passed |
| `ExactNN.bigM_relu_iff` | [SharedParameters.lean](../ExactNN/SharedParameters.lean) | M07–M08: normalized shared formulation and bounded linearization | Verified; audit passed |
| `ExactNN.Expr.eval_substitute` | [Structure.lean](../ExactNN/Structure.lean) | M01, M10: shared composition, permutations and resampling | Verified; audit passed |
| `ExactNN.coupled_feasibility` | [Structure.lean](../ExactNN/Structure.lean) | M01, M10: shared composition, permutations and resampling | Verified; audit passed |
| `ExactNN.Shallow.eval_reindex` | [Structure.lean](../ExactNN/Structure.lean) | M01, M10: shared composition, permutations and resampling | Verified; audit passed |
| `ExactNN.exactFit_resample` | [Structure.lean](../ExactNN/Structure.lean) | M01, M10: shared composition, permutations and resampling | Verified; audit passed |
