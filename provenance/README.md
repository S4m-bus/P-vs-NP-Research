# Provenance records

`source-inventory.json` identifies the 22 source artifacts recovered and inspected
in the work session, with versions, byte lengths, SHA-256 identities, purpose and
relationship to the specification. All named starting/supporting artifacts in
the handoff were located. Original research files are not bundled in this Lean
repository.

`implementation-inventory.json` records the relevant implementation and saved
record files found in those bundles. `available: true` describes availability
at the 2026-09-25 source inspection, not a claim that the file is distributed in
this repository or formally verified.

`historical-benchmark.json` preserves the supplied saved benchmark object. Its
757/757 total and family counts are unchanged. This work adds no experimental
cases and does not rerun or certify all historical solver decisions.

`theorem-index.json` tracks project declarations. Their verification evidence is
in `../verification/`; the source inventory and experimental record are not
substitutes for those proof checks.
