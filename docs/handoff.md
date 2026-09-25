# Handoff to the manuscript session — 2026-09-25

The companion project now contains 59 Lean-verified theorems in eight modules.
The [complete status table](theorem-status.md) and
[verification record](../verification/summary.json) identify their exact scope
and source versions. Every listed theorem passed `#print axioms`; dependencies
are limited to the standard foundational axioms `propext`, `Classical.choice`,
and `Quot.sound`. No additional native-evaluation trust was used.

## Results available for the manuscript

The scalar one-ReLU two-affine-system characterization and shared-feature
multiple-output characterization are proved, including the all-active bias
normalization. The mixed-hinge and one-dimensional shallow models are proved
equivalent with the same width bound. The general scalar shallow model is
proved equivalent to the normalized shared-parameter complementarity system.
Supporting algebra, reconstruction, preprocessing, certificate, residue and
composition lemmas are also checked. Exact statements and complete derivations
are recorded as M01–M11 in [mathematics.md](mathematics.md).

All these statements retain the supplied model: rational data, unrestricted
real parameters, free output bias, no affine skip, and shared parameters.
The hypothetical conditions of the helper-count, big-M and residue lemmas
remain visible in their declarations. No missing global theorem was inserted
as an axiom or a circular hypothesis.

## Accounting for the required manuscript parts

| Part | Material available | Work still required |
|---|---|---|
| 1. Introduction and main results | Verified result statements and dependency map | Final principal claims must follow the complete proof chain |
| 2. Exact Neural Network Training | Exact model predicates and preprocessing semantics | Binary encodings and decision/construction interfaces |
| 3. Structural principles | ReLU algebra, normalization, padding, permutations, shared composition | Broader computation-graph class and cost semantics |
| 4. Four-family representation | Family predicates, mixed/shallow equivalence and coupled interfaces | O2/O4/O6 complete bounded and broader representations |
| 5. Analysis of the four families | M03–M09 and M11, with all four families represented | O1–O5 complete minimum-width, representation, bound and selector arguments |
| 6. Unified algorithm | Source-to-component contracts and partial-outcome soundness | O7 all-input correctness, termination and implementation connection |
| 7. Time and space | Explicit arithmetic/bit distinction and global accounting requirements | O3/O5/O7 polynomial bounds and O4 witness encoding bounds |
| 8. Complexity-class consequence | Required reduction direction and architecture matching specified | O8 standard definitions, matching ETR reduction and final containments |
| References | Original research provenance and pinned formalization sources | Verify any additional result before using it |
| Appendices | Source inventories, unchanged benchmark, M01–M11, theorem map, build and axiom records | Remaining algorithm, arithmetic, representation and complexity proofs |

The original page plan remains in [manuscript-map.md](manuscript-map.md).
The source inventory records 22 inspected artifacts and their checksums.
The saved benchmark remains 757/757; this proof build neither reruns the
experiment nor verifies every saved solver decision.

## Next mathematical dependencies

Continue with the exact statements O1–O8 in [obligations.md](obligations.md).
O1 connects the checked hinge reconstruction/counting components to the full
Family 2 run formula. O2 supplies the full group/anchor representations.
O3 and O5 require complete selection procedures with polynomial total bit cost.
O4 derives rational witness and finite parameter bounds. O6 handles broader
graph coverage if that is the source class of the intended theorem. O7 joins
the actual algorithm and all its costs, and O8 supplies the matching ETR-to-
training reduction and final class containments.

The repository currently contains no Lean theorem asserting
$\mathrm{P}=\exists\mathbb{R}$. The checked component theorems can be cited as
such; the manuscript's unconditional complexity-class conclusion still needs
the specified derivations.
