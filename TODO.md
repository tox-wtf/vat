# To-do List

## VAT
- [x] Report should include the number of processed, checked, skipped, and
  failed project:channel fetches.
- [ ] Potentially rework changelog generation in release script.
- [ ] Write a shell script to find project versions that have not been updated
  in a while. These might then be manually confirmed.
- [ ] Consider how VAT might (and whether it should) integrate with nvchecker.
- [ ] Write man pages.
    - [ ] Document vat usage in vat(1).
    - [ ] Document utility functions in vat(3).
    - [ ] Document project config format in vat(5).
- [ ] Check that a new version is greater than an old version.
    - [ ] Make this check configurable (per-project/channel).
        - `compare=false`, on by default

## Projects
- [ ] Migrate remaining projects from VAT 2.x.
- [x] Run some experiments.
    - [x] Define `expected` at the top level.
    - [x] Define `fetch` at the top level.
    - [x] Nest projects within projects.
    - [x] Define a project without channels (nonsensical but I'm curious).
