# Publication release audit | 2026-10-15

## Checks completed
- Local Git repository initialized; no commits or pushes.
- 71 Git candidate files enumerated.
- Raw and processed respondent-level data, virtual environment, classroom practice scripts and run logs are excluded through .gitignore.
- Candidate filenames and unusually large files screened: no flagged names or CSV files larger than 1 MB, and no candidate files above 5 MB.
- Model-comparison figure exists as PNG, 1600 x 950 pixels.
- The manuscript consistency audit previously passed 16 of 16 checks; this release inspection did not reexecute statistical scripts.
- The scientific review remains documented in reports/20_publication_review.md.

## Pending publication gates
1. Visually inspect figure legibility and ensure accessible alt text/captions.
2. Perform content-based secret scanning and inspect staged diff, not just filenames.
3. Decide whether exploratory research with documented nonresponse limitations is acceptable for public portfolio presentation.
4. Obtain final scientific/editorial sign-off.
5. Commit, connect a remote and publish only after the preceding checks.

**Release decision:** HOLD. This check does not establish scientific publication readiness or authorize a GitHub push.
