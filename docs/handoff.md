# Handoff to the manuscript session — 2026-09-25

The companion project now contains 59 Lean-verified theorems in eight modules.
The [complete status table](theorem-status.md) and
[verification record](../verification/summary.json) identify their exact scope
and source versions. Every listed theorem passed `#print axioms`; dependencies
are limited to the standard foundational axioms `propext`, `Classical.choice`,
and `Quot.sound`. No additional native-evaluation trust was used.

## Lean-verified results available for the manuscript

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

The source also already contains written proofs beyond this Lean coverage:
Theorem 3 (Family 2 minimum width), Theorems 4–8 (Family 3 representations), and
Theorems 10–12 (width construction, rational bounds and bounded shared-feature
representation). Their incomplete Lean translation is work still owed by the
assistant. The earlier report grouped this with source-open selector/reduction
interfaces; [the corrected status table](obligations.md) separates them.

## Accounting for the required manuscript parts

| Part | Material available in this Lean project | Lean work / source dependency |
|---|---|---|
| 1. Introduction and main results | Verified result statements and dependency map | Final principal claims must follow the complete proof chain |
| 2. Exact Neural Network Training | Exact model predicates and preprocessing semantics | Binary encodings and decision/construction interfaces |
| 3. Structural principles | ReLU algebra, normalization, padding, permutations, shared composition | Broader computation-graph class and cost semantics |
| 4. Four-family representation | Family predicates, mixed/shallow equivalence and coupled interfaces | O2/O4: translate source representation proofs; O6: broader coverage task |
| 5. Analysis of the four families | M03–M09 and M11, with all four families represented | O1/O2/O4: translate existing proofs; O3/O5: source-open selector contracts |
| 6. Unified algorithm | Source-to-component contracts and partial-outcome soundness | O7 all-input correctness, termination and implementation connection |
| 7. Time and space | Explicit arithmetic/bit distinction and global accounting requirements | Translate source component/witness bounds; total completion retains O3/O5/O7 |
| 8. Complexity-class consequence | Required reduction direction and architecture matching specified | O8: formalize definitions/source Theorem 16; establish the matching reduction |
| References | Original research provenance and pinned formalization sources | Verify any additional result before using it |
| Appendices | Source inventories, unchanged benchmark, M01–M11, theorem map, build and axiom records | Remaining algorithm, arithmetic, representation and complexity proofs |

The original page plan remains in [manuscript-map.md](manuscript-map.md).
The source inventory records 22 inspected artifacts and their checksums.
The saved benchmark remains 757/757; this proof build neither reruns the
experiment nor verifies every saved solver decision.

## Next formalization work and source-open interfaces

Continue with the [source-referenced O1–O8 record](obligations.md). O1, O2
and O4 primarily port existing mathematical proofs; they are not findings that
those proofs are absent. O7 also contains existing conditional soundness,
completion and cost arguments to formalize. O3/O5 are the complete polynomial
selection contracts explicitly left open in the dated specification. O8 contains
both an existing conditional proof to formalize and the matching ETR reduction
explicitly left open by that source. O6 records the handoff's broader scope request
and must not be presented as a failure of the dated shallow-family theorems.

The repository currently contains no Lean theorem asserting
$\mathrm{P}=\exists\mathbb{R}$. The checked component theorems can be cited as
such. Source proofs and source-open interfaces have the separate statuses
recorded above; the 59 declarations do not exhaust the source mathematics.
