# Mathematical statements and proof correspondence

This record explains the declarations being formalized. Kernel verification status
is determined by `verification/summary.json` and the accompanying build/axiom logs,
not by the existence of this prose. Unfinished global results are in `obligations.md`.

## M01 — Exact semantics and preprocessing

`ScalarData m d` contains m rational input vectors of dimension d and m rational
targets. A `Shallow d H` network has H real incoming vectors, hidden biases and
scalar coefficients, and one real output bias. Its value is

\[
f(x)=c+\sum_{j=1}^H a_j\max(0,b_j+\sum_{k=1}^d w_{jk}x_k).
\]

`ExactFit D h` means that some H<=h and one such network fit every sample. Thus
parameters are shared across samples. There is no affine skip connection.
Finite empty sums are zero, so zero-width fitting is equivalent to constant target
data. Empty data are vacuously constant and therefore fit with zero width. Widening
the permitted bound preserves a witness. Identical inputs have identical evaluations,
so conflicting targets cannot fit. Surjective resampling preserves feasibility in
both directions: compose the fitting equations with the surjection in one direction;
choose a preimage of each original sample in the other. This covers reordering and
consistent duplicate insertion without silently dropping any original sample.

Lean: `ExactFit`, `exactFit_mono`, `exactFit_constant`, `exactFit_zero_iff`,
`exactFit_no_conflict`, `exactFit_resample`.

## M02 — ReLU algebra

For a>=0, max(0,ax)=a max(0,x), by the cases x>=0 and x<=0.
Also max(0,x)-max(0,-x)=x. For any real v,z,

\[
z=\max(0,v)\iff z\ge0\;\land\;v\le z\;\land\;z(z-v)=0.
\]

Necessity follows by the sign of v. Conversely the product equation says z=0 or
z=v. In the first case v<=0; in the second z>=0 forces v>=0. These cases give the
same ReLU value, including v=z=0.

For t>=0, ReLU(v)=t is equivalent to v=t when t>0 and v<=0 when t=0.
No strict activation convention excludes zero preactivations.

Lean: `relu_mul`, `relu_sub_relu_neg`, `relu_eq_iff`, `relu_target_iff`.

## M03 — One-ReLU scalar completeness (specification Theorem 1)

Let X[i] be arbitrary real input vectors and y[i] real targets. Choose sample
indices ilo,ihi attaining the minimum and maximum targets. A fit
c+a ReLU(w.X[i]+b)=y[i] exists iff one of two affine feasibility systems exists:

* base=min(y), residual t[i]=y[i]-base;
* base=-max(y), target vector -y, residual t[i]=max(y)-y[i].

In each system t[i]>=0 and the constraints are affine(i)=t[i] if t[i]>0,
and affine(i)<=0 if t[i]=0.

First normalize a by positive homogeneity. When a>=0, absorb a into w,b to
obtain y[i]=c+ReLU(v[i]); this also handles a=0. When a<0, absorb -a and negate
the targets to obtain the same positive-output form for -y.

For the positive form, put t=y[ilo]-c=ReLU(v[ilo])>=0. Minimality gives
t<=ReLU(v[i]) for every i. The identity

\[
\operatorname{ReLU}(v-t)=\operatorname{ReLU}(v)-t
\quad(0\le t\le\operatorname{ReLU}(v))
\]

follows directly if t=0. If t>0, then v>=t>0 and both ReLU evaluations can be
removed. Replace b by b-t. The resulting feature equals y[i]-y[ilo], giving the
first affine system. Apply this proof to -y for the second system. This deals
explicitly with the all-active case, without assuming an inactive sample exists.

Conversely, the target-ReLU equivalence reconstructs the positive form from
either affine system. Negate the scalar output for the second system. Both
directions preserve one feature and the free bias. Constant data are permitted.
For an empty sample set no extrema are chosen; M01 supplies the zero-width witness.

Lean: `oneFit_iff_positive_or_negative`, `relu_shift`,
`positiveFit_iff_lp_at_min`, `oneFit_iff_twoLP`.
`exactFit_one_iff` connects `OneFit` to the at-most-one-neuron rational-data model.
This is a characterization, not a formal polynomial-time LP implementation.

## M04 — Shared multiple outputs (specification Theorem 2)

Suppose Y[i1,a]!=Y[i0,a]. A shared-feature fit
Y[i,k]=c[k]+v[k] ReLU(w.X[i]+b) exists iff coordinate a has a scalar fit and
there is one vector r with

\[
Y[i,k]=Y[i0,k]+r[k](Y[i,a]-Y[i0,a])\quad\hbox{for all }i,k.
\]

Necessity: the differing values imply v[a]!=0. Subtract the equations at i and
i0 and use r[k]=v[k]/v[a]. Every coordinate uses the same hidden feature.
Furthermore evaluating at i1 gives exactly the source algorithm's ratio
r[k]=(Y[i1,k]-Y[i0,k])/(Y[i1,a]-Y[i0,a]). Its denominator is nonzero by hypothesis.

Sufficiency: for a scalar fit c_s+s ReLU(u), set
c[k]=Y[i0,k]+r[k](c_s-Y[i0,a]) and v[k]=r[k]s. Substitution proves all output
identities with the same u. Constant vector targets use v=0 and their common
value as c. Zero output dimension is vacuous in the definitions.

Lean: `vectorOneFit_coordinate`, `vectorOneFit_collinear`,
`vectorOneFit_of_coordinate`, `vectorOneFit_iff_collinear_coordinate`,
`vectorOneFit_constant`, `collinear_direction_ratio`.

## M05 — One-dimensional building blocks

Reflection takes a left hinge at t into a right hinge at -t on input -x.
The identity ReLU(t-x)=ReLU(x-t)-(x-t) shows that changing orientation subtracts
one from each secant of a unit hinge on distinct endpoints. Consecutive secant
differences therefore remain unchanged. Multiplication by a signed coefficient
scales the identity; the curvature argument does not assume positive outputs.

For x0<x1 and nonzero same-sign u,v, set A=u+v and

\[
t=(u x_0+v x_1)/A.
\]

A!=0 and x0<t<x1. For positive u,v these inequalities follow by multiplying
by positive A; for negative u,v both inequalities reverse when multiplying by A,
giving the same knot interval. Direct algebra, with nonzero denominators, gives
A(x1-t)/(x1-x0)=u and A(t-x0)/(x1-x0)=v.

For nonnegative a,b with a+b>0 and knots t,s in one closed sample gap [l,r],
the weighted knot (at+bs)/(a+b) stays in [l,r]. At every x<=l both hinge sides
are zero; at every x>=r they are affine and weighted averaging gives

\[
(a+b)\operatorname{ReLU}(x-(at+bs)/(a+b))
=a\operatorname{ReLU}(x-t)+b\operatorname{ReLU}(x-s).
\]

This is sample preservation outside the open gap. No equality inside the gap
is asserted. Multiplying both sides by a common sign handles same-sign groups.
Finally equal first values and equal consecutive differences imply equality on
a finite ordered sample sequence, by induction.

Lean: `hinge_reflection`, `hinge_orientation`, `secant_left_eq_right_sub_one`,
`curvature_orientation_invariant`, `common_left_iff_reflected_right`,
`pair_reconstruction`, `merge_hinges_outside_gap`, `samples_eq_of_differences`.

## M06 — Counting helpers without an unproved geometric premise

Let K anchors and H neurons be finite, with relation helps(j,k). Assume every
anchor has a helper and each neuron helps at most one anchor. Choose one helper
per anchor. Two anchors cannot choose the same helper, so this choice is injective
and K<=H. If K=H, the finite injection is surjective. Any additional helper of an
anchor is already assigned to some anchor, and the at-most-one premise forces
that anchor to be the same one. Hence every anchor and every neuron have a unique
partner. This theorem does not assume a stronger disjoint-support condition.

Lean: `helper_count_bound`, `unique_helpers_at_bound`.
The geometric premise and path count still need to be connected to the full
Family 2/3 theorem; see O1–O2.

## M07 — Exact normalized shared-parameter formulation

For any scalar shallow network set q_j=|a_j|(w_j,b_j) and eta_j=1 if a_j>=0,
otherwise -1. Positive homogeneity gives eta_j ReLU(q_j.xbar)=a_j ReLU(w_j.x+b_j)
for every real input. Zero coefficients produce zero features, so choosing eta=1
there is harmless. Padding with zero slots preserves the function and proves that
at-most-h feasibility is equivalent to an h-slot network.

Now introduce z[i,j] with the complementarity constraints of M02 for
v[i,j]=q_j.xbar[i], and output equations y[i]=c+sum_j eta_j z[i,j]. A fitting
network supplies these values. Conversely the constraints force the exact ReLU
values at every sample and the outputs fit. Each q_j and eta_j remains shared
across all samples. The equivalence holds for every m,d,h, including zero sizes.

Lean: `Shallow.eval_pad`, `exactFit_iff_slots`, `normalize_term`,
`Shallow.eval_normalize`, `exactFit_iff_sharedComplementarity`.

## M08 — Binary linearization with explicit bounds

For a Boolean b let bit(b) be 0 or 1. If 0<=z<=M, the constraints
0<=u<=z, u<=M bit(b), u>=z-M(1-bit(b)) hold iff u=bit(b)z.
For b=0 the bounds force u=0; for b=1 they force u=z. The hypotheses suffice
for the reverse direction in both cases.

If |v|<=M, the existence of Boolean d and constraints
0<=z, v<=z, z<=M bit(d), z<=v+M(1-bit(d)) is equivalent to z=ReLU(v).
For d=0, z=0 and v<=0; for d=1, z=v>=0. Conversely choose the active bit by
the sign of v and use the supplied bound. The theorem does not derive M or permit
fractional bits. The full finite-witness bound is a separate obligation O4.

Lean: `binary_product_iff`, `bigM_relu_iff`.

## M09 — Certificate and modular soundness

For a real factor matrix H, (H^T H)v=0 iff Hv=0. The reverse direction is immediate.
For the forward direction multiply by v^T to obtain ||Hv||^2=0, forcing Hv=0.
The formal proof rewrites the matrix products to a finite sum of nonnegative
squares. A zero sum forces every square to be zero, hence every coordinate of Hv
is zero. The proof uses the pinned matrix identities and finite-sum lemmas.
It tests the specified group factor and does not select a deletion set.

For Ax<=b, any lambda>=0 with lambda^T A=0 and lambda^T b<0 is an infeasibility
certificate: multiplying and summing gives 0<=lambda^T b, a contradiction.
This is certificate soundness, not completeness of a certificate search.

For integers q>0 and |S-R|<q, S mod q=R mod q iff S=R. Equality of residues means
S-R=qk. If k>=1 the difference is at least q, and if k<=-1 it is at most -q.
Both contradict the strict bound, so k=0. For S in [L,U], the choice
q=1+max(R-L,U-R) gives the strict bound. When R also lies in [L,U], q>0.
This verifies the exactness step used by the fixed-cardinality orientation rule;
it gives no polynomial bound for q in terms of input bit length.

Lean: `gram_kernel_iff`, `linear_infeasible_of_certificate`,
`residue_eq_iff_of_abs_sub_lt`, `cardinality_window`, `cardinality_residue_iff`.

## M10 — Composition and partial outcomes

Expression evaluation is structural recursion on a finite syntax tree with one
shared parameter assignment theta. Substituting input expressions commutes with
evaluation, by induction. Therefore feasibility of a composed expression is
equivalent to existentially choosing theta and all intermediate sample values Z,
with every prefix equation and suffix equation using that same theta. This proves
the joint interface condition and never infers joint feasibility from independent
parameter choices. It is not the broader four-family coverage theorem O6.

Hidden-neuron permutations preserve finite sums. Partial outcomes retain YES with
a valid witness, NO only for full infeasibility, and UNRESOLVED. Selecting the first
resolved outcome of two sound partial procedures is sound by a three-way case split.
Completeness of either procedure is not inferred.

Lean: `Expr.eval_substitute`, `coupled_feasibility`, `Shallow.eval_reindex`,
`firstResolved_sound`.

## M11 — Family 3 is exactly the one-dimensional shallow model

For a nonzero scalar incoming weight w, put t=-b/w. If w>0 then
ReLU(wx+b)=w ReLU(x-t). If w<0 then
ReLU(wx+b)=(-w) ReLU(t-x). Thus the coefficient becomes a|w| and the orientation
is chosen by the sign of w. If w=0, the contribution a ReLU(b) is constant and
is absorbed into the free output bias; its retained slot has coefficient zero.
This transformation preserves the number of slots and every real input value.

Conversely, a right hinge has incoming weight 1 and bias -t, and a left hinge
has incoming weight -1 and bias t. Replacing every oriented hinge by these
parameters preserves the sum and width. These constructions prove the equivalence
of mixed-direction fitting with the d=1 shallow scalar model, including constants
and zero-width data. No affine skip is introduced by normalization.

Lean: `univariate_hinge_identity`, `univariate_term_decomposition`,
`mixedFit_iff_shallow_one`, `exactFit_dim_one_iff_mixed`.
