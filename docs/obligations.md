# Source proof status and remaining Lean work

**Reporting correction — 2026-09-25.** The previous version grouped existing
source proofs awaiting formalization together with research interfaces left open
by the source. That classification was misleading. In particular, O1, O2 and O4
refer to proofs already written in the specification whose Lean translation is
incomplete in this repository. This is unfinished formalization work by the
assistant; it is not a finding that those proofs are absent from the research.

The source below is `Exact_NN_Formal_Specification_2026-09-17.md`, identified in
[the source inventory](../provenance/source-inventory.json). The section and
theorem references describe that dated document. “Source proof present” records
an existing mathematical argument; “Lean-verified” records an executed kernel
check of the matching declaration. They are distinct statuses.

| ID | Exact source location | Status in the source | Work remaining in this Lean project |
|---|---|---|---|
| O1 | §4, Theorem 3 and its Complexity paragraph | Minimum-width theorem, construction and bounds have written proofs/derivations | Formalize the complete theorem, scan and encoded costs |
| O2 | §§5–7, Theorems 4–8; §6.2 | Threshold, complete flow/anchor representations, amplitude bounds and reconstruction have written proofs | Translate and assemble the complete representation theorems |
| O3 | §7.1, §12 selector contract, §14.1 | Complete polynomial SELECT_ANCHORS is explicitly left as a research interface | Establish that contract and formalize its algorithm and costs |
| O4 | §9.2, Theorem 10; §10, Theorems 11–12 | Width cap, bounded rational witnesses and bounded shared-feature equivalence have written proofs | Formalize the existing construction, determinant argument and full bounded equivalence |
| O5 | §10, §12 selector contract, §14.1 | Complete representation is supplied; polynomial SELECT_SHARED_FEATURES is explicitly left as an interface | Establish the selection contract and formalize its algorithm and costs |
| O6 | §1 model scope; handoff Part 4 | Dated specification defines the four shallow families; the broader graph target is a separate scope/formalization request | Specify that source graph class and its exact transformation, if included in the intended coverage theorem |
| O7 | §§12–13, Theorem 13; §14.1, Theorem 14 | Current-rule conditional soundness, component costs and conditional completion have written arguments | Formalize those arguments and their code correspondence; total completion retains O3/O5 dependencies |
| O8 | §14.3, Theorem 16 | Conditional class-consequence theorem has a written proof; the matching ETR reduction is explicitly left open | Formalize standard definitions and the existing implication; establish the matching reduction |

The O-labels are retained for existing links. They are not Lean axioms. No entry
is a mathematical counterexample. A failed tactic, missing import or incomplete
translation does not change the status of a source argument.

## O1 — Formalize the existing Family 2 minimum-width proof

**Source proof present:** §4, Theorem 3. For strictly sorted samples with m>=2,
s[i]=(y[i+1]-y[i])/(x[i+1]-x[i]), g[0]=s[0], and g[i]=s[i]-s[i-1]. The source
proves the right-facing minimum is the sum over same-sign nonzero runs of
ceil(length/2). Its proof gives the alternating independent-set lower bound,
handles cancellation through target-sign helpers, and constructs one hinge for
each pair or singleton. The following paragraph supplies arithmetic and bit
bounds, including sorting.

**Lean translation remaining:** connect actual hinge contributions to that path,
formalize its independent-set cardinality, assemble all reconstructed secants,
and verify the scan and bit accounting. The existing pair-reconstruction and
abstract helper-count lemmas cover components of this source proof. Their limited
coverage describes this repository's progress, not the scope of Theorem 3.

## O2 — Formalize the existing Family 3 representation proofs

**Source proofs present:** Theorem 4 proves K<=H_min<=K+1 for nonzero curvature.
Theorem 5 proves the complete group representation. Theorem 6 proves bounded
amplitudes using circulation removal. Theorem 7 proves the anchor bijection,
and Theorem 8 proves the complete bounded anchor representation. Their proofs
include orientation effects, the initial-slope equation and reconstruction.
Section 6.2 supplies the prescribed-group matrix/deletion formulation.

**Lean translation remaining:** formalize endpoint normalization, all group
columns, the geometric helper property, circulation/path decomposition, the
amplitude bound and the two complete equivalences. The checked orientation,
merging, Gram-kernel and abstract helper lemmas do not yet assemble these source
theorems in Lean. No absence of a mathematical source proof is asserted here.

## O3 — SELECT_ANCHORS as the source's explicit completion interface

**Source status:** §7.1 supplies the bounded representation and selected-system
reconstruction; §12 explicitly leaves the complete polynomial selector as a
research contract. These are separate claims.

On every rational bounded anchor system, the requested selector must return
integral side/orientation choices and an exact continuous realization, or
full-system infeasibility, with completeness, termination and polynomial total
bit time/space in the original input length. Account for generated LPs, cuts,
states, operand lengths and reconstruction.

Section 8.3 already gives the specified modular recurrence, its inductive
completeness argument, reconstruction and O(n(k+1)q) state-operation bound.
It explicitly calls that magnitude-dependent bound pseudo-polynomial. The Lean
residue lemmas currently verify its bounded exact-equality step; the recurrence
and its stated costs remain to be translated. Budget exhaustion stays UNRESOLVED.

## O4 — Formalize the existing rational-witness and finite-bound proofs

**Source proofs present:** Theorem 10 in §9.2 proves the rational projection/rank
construction and the sufficient m-1 width bound for consistent nonconstant data
with at least two distinct inputs. Larger width requests can therefore be
handled before building the remaining formulation; the supplied request itself
is not assumed to satisfy h<=m-1.

Theorem 11 in §10.1 proves bounded rational witnesses. With denominator clearer
Delta, C=max(1,Delta,|Delta*x|,|Delta*y|), R0=m(h+1), B=R0!*C^R0 and
M=(d+1)*C*B, it fixes signs/activation labels, splits free variables, adds slacks,
reduces positive support to independent columns and applies Cramer's rule.
The source derives both the coordinate bounds and their polynomial bit lengths.
Theorem 12 proves the complete bounded mixed-integer shared-feature equivalence.

**Lean translation remaining:** formalize that width construction and support/
determinant proof, their encoding bounds, and the complete bounded system. The
checked normalization, complementarity and big-M identities are components;
Theorems 10–12 have not yet been fully ported by the assistant.

## O5 — SELECT_SHARED_FEATURES as the source's explicit completion interface

**Source status:** Theorem 12 represents every feasible shared-feature choice.
The specification does not limit that representation to a guessed dictionary.
Section 12 separately requests a complete polynomial integral-selection rule.

The remaining selector contract is to find integral signs and activations and
an exact realization, or certify full-system infeasibility, with polynomial
bit time/space and parameters shared across all samples. Formalize coverage of
all permissible features in each global negative branch. The source's existing
dictionary/deletion/exchange proofs retain their stated scope while this separate
contract is pursued.

## O6 — Define and formalize the broader coverage target from the handoff

This entry records a scope/formalization task, not a defect attributed to the
source's four shallow-family theorems. Section 1 fixes the dated model class.
Part 4 of the handoff additionally requests an exact coverage transformation
for any intended broader source class.

For that target, specify the graph class, transformation R and coupled
FamilyFeasible predicate, then establish ExactFit(I) iff FamilyFeasible(R(I)).
Retain shared parameters, existential interfaces, depth, outputs, activations,
biases, width, representation size, construction cost and witness recovery.
The current expression-composition theorem supplies shared-parameter semantics;
it is not yet the requested coverage formalization. A broader class must be
identified explicitly before a theorem about it can be audited.

## O7 — Formalize existing algorithm arguments and preserve their dependencies

**Source arguments present:** §12 gives current and completed pseudocode.
Theorem 13 proves conditional soundness of the current integrated rules under
exactly checked calls and correctly scoped negative conclusions. It permits
UNRESOLVED and does not claim Python-code verification. Section 13 gives
component cost bounds and global accounting. Theorem 14 proves conditional
completion when O3/O5 satisfy their polynomial contracts.

**Lean translation remaining:** port these statements and proofs, connect the
actual implementation to each mathematical branch, and formalize encoding,
termination, witness checking and cost accounting. The current partial-outcome
composition lemma proves only one component of that task. Formalizing the
existing conditional results and supplying their selector hypotheses are
separate work items.

Section 2 already distinguishes the polynomial reference LP algorithm from the
saved Fourier–Motzkin and pivot-bounded experimental backends. The Lean runtime
proof must specify which backend and theorem it uses.

## O8 — Formalize the existing conditional consequence and its stated bridge

**Source proof present:** §14.3, Theorem 16 proves the conditional ETR consequence
by composing a matching reduction with the completed polynomial algorithm.
The paragraph following it explicitly says that the matching ETR-hardness
reduction has not been established in the saved work covered by this dated source.

**Lean work:** fix standard binary encodings, machines, polynomial time, ETR and
its reduction class; formalize the existing conditional argument with its
hypotheses visible. The additional mathematical task named by the source is a
polynomial many-one ETR-to-training reduction into precisely the model decided
by the completed algorithm, with both preservation directions and size/cost
bounds. Training-to-ETR membership is a different direction.

The current repository contains no Lean declaration of unconditional class
equality. The report must describe that formalization status without treating
all source theorems as if their mathematical proofs were missing.
