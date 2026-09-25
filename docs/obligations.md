# Remaining exact proof obligations

These are work items, not Lean axioms. The source specification explicitly leaves
the selectors and ETR reduction open. A failed Lean tactic would be a translation
or tooling failure, not a mathematical disproof.

## O1 — Family 2 minimum-width theorem

For sorted rational samples, let s[i]=(y[i+1]-y[i])/(x[i+1]-x[i]),
g[0]=s[0], and g[i]=s[i]-s[i-1]. Prove that the right-facing minimum width is
sum over same-sign nonzero runs of ceil(length/2). Connect actual hinge
contributions to the path independent set, prove its cardinality, and assemble
the reconstructed secants. Verify the scan and its bit bounds. The helper-count
and pair-reconstruction lemmas are components, not this whole theorem.

## O2 — Complete Family 3 representations

For nonzero curvature, K is the alternating-anchor count. Prove the geometric
lower bound K, upper bound K+1, and the complete group-flow and critical-width
anchor equivalences. Include both endpoints, cancellations, the slope equation,
circulation removal, finite bounds, and reconstruction. The abstract helper
lemma requires proof that a real hinge helps at most one chosen anchor.

## O3 — SELECT_ANCHORS

On every rational bounded anchor system from specification §7, return integral
side/orientation choices and a continuous realization, or full-system infeasibility.
Prove both outcomes sound, completeness, termination, and polynomial total bit
time/space in the original input length. Include generated LPs, cuts, state
representations, operands, and reconstruction.

The supplied modular procedure uses O(n(k+1)q) state operations per retained count.
The modulus q is a numerical value. The verified condition |S-R|<q makes residue
equality exact but does not bound q polynomially in its binary length. A budget
exhaustion remains UNRESOLVED. No replacement enumerator is attributed to the method.

## O4 — Rational witnesses and finite parameter bounds in Lean

Prove the source width cap h<=m-1 after preprocessing. For denominator clearer Delta,
C=max(1,Delta,|Delta*x|,|Delta*y|), R0=m(h+1), B=R0!*C^R0 and M=(d+1)*C*B,
formalize the independent-support/determinant argument for bounded rational
witnesses and its bit bounds. Combine this with the exact big-M constraints.

The current complementarity equivalence retains real parameters and is unconditional.
It does not by itself imply rational witnesses or the bound B. Big-M lemmas expose
their required numerical bound as a hypothesis.

## O5 — SELECT_SHARED_FEATURES

On every full shared-parameter system from specification §10, find integral signs
and activations plus an exact realization, or establish full-system infeasibility,
with polynomial bit time/space. Each hidden vector and sign is shared across every
sample. Prove coverage of all permissible features in every negative branch.
A supplied dictionary, fixed group deletion, or failed local exchange is not
already such a selector.

## O6 — Broader four-family coverage

The source §1 defines four shallow families, not a general deep-network reduction.
For the wider objective, define the source graph class, transformation R, and
coupled FamilyFeasible predicate. Prove ExactFit(I) iff FamilyFeasible(R(I)),
retaining shared parameters, existential interfaces, depth, outputs, activations,
biases, width, size, construction cost, and witness recovery.

The current composition theorem uses one common parameter assignment across
all samples and components. It establishes expression composition semantics,
not a reduction of arbitrary graphs to independently solved shallow instances.

## O7 — Unified algorithm and bit complexity

Connect the source code to the mathematical rules. Prove full-problem negative
soundness, completeness, termination, and total bit costs for the actual LP and
selection procedures. The partial-outcome composition theorem permits UNRESOLVED.
The source Fourier–Motzkin and pivot-limited backends are not automatically a
verified polynomial-time LP implementation.

## O8 — ETR reduction and the final class equality

Fix standard binary encodings, machines, polynomial time, ETR, and its reduction
class. Construct a polynomial many-one reduction ETR -> the exact-training language
actually decided by O7, with precisely matching architecture and constraints.
Prove preservation in both directions and size/construction bounds. Encoding
training into ETR is the opposite direction and does not establish this obligation.

Only after O7 and O8 are proved does composition establish ETR in P; prove both
class containments under the fixed definitions. No unconditional P=exists-R
statement, or assumption standing in for it, is present in the current Lean files.
