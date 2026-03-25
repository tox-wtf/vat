# To-do List

## VAT
- [ ] Fix stale channels continuing to exist in `v.*`
  (and consequently in `p/ALL.*`)
- [ ] Write a script to find project versions that have not been updated in a
  while. These might then be manually confirmed.
- [ ] Do something if a project/channel with a low chance has been updated.
- [ ] Consider how VAT might (and whether it should) integrate with nvchecker.
- [ ] Write man pages.
    - [ ] Document vat usage in vat(1).
    - [ ] Document utility functions in vat(3).
    - [ ] Document project config format in vat(5).
- [x] Check that a new version is greater than an old version.
    - [x] Make this check configurable (per-project/channel).
        - `compare=true`, on by default
- [x] Add `fhigh` which filters out high version parts.
- [ ] Add Discord webhook integration

## Projects
- [ ] Track gd, celeste, terraria projects (mostly mods)
- [ ] Try to track gd/mega-hack (unfortunately closed source and releases are
  announced on Discord and Twitter of all places)
