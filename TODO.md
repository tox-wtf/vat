# To-do List

## VAT
- [x] Report should include the number of processed, checked, skipped, and
  failed project:channel fetches.
- [ ] Potentially rework changelog generation in release script.
- [ ] Write a shell script to find package versions that have not been updated
  in a while. These might then be manually confirmed.
- [ ] Consider how VAT might (and whether it should) integrate with nvchecker.
- [ ] Write man pages
    - [ ] Document vat usage in vat(1)
    - [ ] Document utility functions in vat(3)
    - [ ] Document project config format in vat(5)

## Projects
- [ ] Migrate remaining projects from VAT 2.x
- [ ] Run some experiments
    - [ ] Define `expected` at the top level
    - [ ] Define `fetch` at the top level
    - [ ] Nest serde within the rust project directory
    - [ ] Define a project without channels (nonsensical but I'm curious)
