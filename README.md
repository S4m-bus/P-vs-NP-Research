# Exact Neural Network Training — Lean 4

**59 theorems in 8 modules compiled and passed an axiom audit on 2026-09-25.**
This is a verified formalization of specific components of the four-family
specification dated 2026-09-17. It does **not** establish the final equality
$\mathrm{P}=\exists\mathbb{R}$.

The model retains rational samples, unrestricted real parameters, free output
bias, no affine skip connection, shared parameters across samples and outputs,
and a supplied upper bound on the hidden-neuron count.

## Verified results

- Exact fitting semantics, constant/zero-width cases, conflicting duplicates,
  width monotonicity, zero padding, permutations, and surjective resampling.
- The one-ReLU scalar characterization by two affine feasibility systems,
  including the all-active case; the shared-feature multiple-output
  characterization by collinearity and one scalar coordinate.
- One-dimensional reflection, orientation and curvature identities,
  same-sign pair reconstruction, sample-preserving hinge merging, and helper
  counting with its geometric premise explicit.
- The width-preserving equivalence of mixed-direction hinges and the
  one-dimensional shallow model.
- The exact shared-parameter complementarity formulation, plus binary product
  and big-M ReLU equivalences with the required bounds stated explicitly.
- The Gram-kernel criterion, linear infeasibility-certificate soundness,
  exactness of bounded residue tests, shared expression composition, and
  sound composition of partial outcomes.

These results characterize feasibility and establish supporting mathematical
identities. The Python solver and its runtime bounds have not been formally
verified. The source already contains proofs of the Family 2 minimum-width
theorem (Theorem 3), Family 3 representations (Theorems 4–8), and bounded
rational/shared-feature results (Theorems 10–12). Their complete Lean translation
is still unfinished in this repository. Separately, the dated source explicitly
leaves the general polynomial selectors and matching ETR reduction as completion
interfaces. The [source/Lean status table](docs/obligations.md) distinguishes them.

## Proof and verification records

- [Theorem-by-theorem status](docs/theorem-status.md)
- [Mathematical statements and proofs](docs/mathematics.md)
- [Handoff to the manuscript session](docs/handoff.md)
- [Source proof status and remaining Lean work O1–O8](docs/obligations.md)
- [Manuscript, algorithm and complexity correspondence](docs/manuscript-map.md)
- [Source references](docs/references.md)
- [Machine-readable theorem index](provenance/theorem-index.json)
- [Build log](verification/build.log), [axiom audit](verification/axioms.log),
  [compiler identification](verification/toolchain.txt), and
  [source hashes and verification summary](verification/summary.json)

Every theorem is checked by Lean and listed in `Audit.lean`. The audit permits
only Lean's standard foundational axioms `propext`, `Classical.choice`, and
`Quot.sound`. No theorem depends on `sorryAx` or a custom mathematical axiom.
The project contains no `sorry`, `admit`, or native-evaluation proof shortcut.
No independent kernel reimplementation was run.

## Reproduce

Use the version in `lean-toolchain`: Lean **4.19.0**, compiler commit
`6caaee842e94`. Mathlib is pinned to
`c44e0c8ee63ca166450922a373c7409c5d26b00b`; all transitive revisions are
recorded in `lake-manifest.json`. With Lean/Lake and Python 3 available:

```sh
bash scripts/fetch-cache.sh
python3 scripts/verify.py
```

The first command fetches the official compiled cache for the imported mathlib
modules. The second builds the project, generates `Audit.lean`, checks every
listed theorem's axioms, and records the output and source hashes. A failure
removes the previous success summary. To reproduce a clean project build,
remove only the project's `.lake/build` directory before running verification;
the pinned dependency cache can be retained.

Verification was performed locally. This branch adds no automatic GitHub Actions
workflow.

## Research provenance

The historical saved benchmark is preserved at **757/757**, with the original
family totals **86/86, 486/486, 92/92, and 93/93**. It was not expanded or rerun
as part of this proof build, and is not an all-input completeness theorem.
See [the unchanged saved record](provenance/historical-benchmark.json).

[Source inventory](provenance/source-inventory.json) and
[implementation inventory](provenance/implementation-inventory.json) record the
files inspected in the work session, their versions and SHA-256 identities.
The original source documents and research archives are not bundled here.
