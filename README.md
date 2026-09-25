# Exact Neural Network Training — Lean 4

Formalization of the four-family specification dated 2026-09-17.

Recovery checkpoint: the proof files on this branch are restored from the interrupted work session and are awaiting compilation. No verification success is claimed for this checkpoint.

The intended model retains rational samples, unrestricted real parameters, free output bias, no affine skip, shared parameters across samples and outputs, and supplied neuron bounds.

The dated specification leaves the complete polynomial selectors for Families 3–4 and the matching ETR reduction as explicit research obligations. They are not introduced as axioms. The historical benchmark remains 757/757.

Toolchain: Lean 4.19.0; mathlib c44e0c8ee63ca166450922a373c7409c5d26b00b.
