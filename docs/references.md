# Sources actually used

The mathematical research source is `Exact_NN_Formal_Specification_2026-09-17.md`,
with matching PDF/LaTeX and source bundle; source identities are recorded by SHA-256
in the provenance inventory. The handoff supplied in this session sets the scope.
The compact-representation notes, source code and saved JSON were inspected.
The specification source ZIP is not treated as the executable solver.

The current development does not import an external ETR-hardness or polynomial-LP
result as a completed Lean theorem. Literature listed in the source specification
has not been silently promoted into this project's verified dependency chain.

Primary formalization dependencies:

* [Lean 4.19.0 release](https://github.com/leanprover/lean4/releases/tag/v4.19.0).
  Locally executed compiler identifies commit `6caaee842e94`.
* [mathlib pinned revision](https://github.com/leanprover-community/mathlib4/tree/c44e0c8ee63ca166450922a373c7409c5d26b00b).
  The full transitive dependency revisions are in `lake-manifest.json`.
* [Matrix/Mul.lean](https://github.com/leanprover-community/mathlib4/blob/c44e0c8ee63ca166450922a373c7409c5d26b00b/Mathlib/Data/Matrix/Mul.lean).
  `Matrix.mulVec_mulVec`, `Matrix.dotProduct_mulVec`, and `Matrix.vecMul_transpose`
  rewrite the quadratic form in the direct proof of the factor-kernel identity.
  A finite sum of nonnegative squares then forces every coordinate to vanish.
* [Fintype/Card.lean](https://github.com/leanprover-community/mathlib4/blob/c44e0c8ee63ca166450922a373c7409c5d26b00b/Mathlib/Data/Fintype/Card.lean).
  Finite cardinality and injection/surjection facts support the abstract helper argument.

Proof-producing tactics (`linarith`, `nlinarith`, `ring`, `field_simp`, `omega`,
and simplification) construct proof terms checked by Lean. Native evaluation is
not used as an additional proof trust mechanism. Imported foundational axioms are
recorded explicitly by the audit; no selector, coverage theorem, or complexity
consequence is inserted as a custom axiom.
