# Contributing

## Quick Start
You're probably interested in adding a project. The first step is forking and
cloning this repo.

### Maintainer Utilities
Maintainer utilities are provided in the [dev library](./lib/dev). You'll want
to source this file from bash.

You can add a project with `va $project`. There are various utility functions
defined in [the base library](./lib/base). Peruse existing projects for an idea
of how to use them.

### Fields
The available fields are as follows:

- `upstream` usually contains the project's git repo.
- `chance` is an integer between 0 and 100, that defaults to 100. This is the
  chance that a project or channel is fetched, and is used mostly for dead
  projects.
- `expected` is a (bash) regex which the version should match.
- `fetch` is a function that fetches the version usually using VAT's utility
  functions. This is almost always defined within a channel's scope.
- `channel` is a function beginning with `:`. The above fields may be overridden
  for a channel by defining them within this function.

The only required field is an upstream, but you'll also want to specify at least
one channel. Everything else uses a sane default.

For example:
```bash
upstream="gh:git/git"

:release() { :; }
:unstable() { :; }
:commit() { :; }
```

Here, we rely on defaults everywhere. Note that we must include `:` in the body
of the function or else bash complains.


### Editor Configuration
The following config snippet should make working with VAT in Neovim a little
more pleasant by automatically setting the filetype to TOML, enabling syntax
highlighting:

```lua
-- VAT config filetype
vim.filetype.add({
    pattern = {
        [".*/p/.*/config"] = "bash",
    }
})
```

## Commits
VAT follows a variant of conventional commits.

Some general rules:
- Keep commit subject length to 72 characters or fewer.
- Commit subjects should be limited to ASCII, and are preferred to be lowercase.
  Descriptions should also keep to ASCII, but may be capitalized as desired.
- The subject line of minor breaking changes should be prefixed with '!'.
- The subject line of major breaking changes should be prefixed with '!!'.

To add a project, the commit message would be:
```git
feat(p): add someproject
```

To fix the release fetch for a project, the commit message would be:
```git
fix(p): fix release fetch for someproject
```

To make a breaking change to the `vtrim` function in the base library,
addressing an issue:
```git
!feat(lib): adjust vtrim behavior

Instead of only trimming a leading 'v', vtrim now trims any leading alphabetic
character if it's immediately followed by a number.

Resolves: #488
References: #122, #556
```

### Commit Types
| Type  | Description                    |
|-------|--------------------------------|
| auto  | Automatic commits made by VAT  |
| chore | Changes to auxiliary files     |
| docs  | Changes to any documentation   |
| feat  | A new feature or project       |
| fix   | A bugfix                       |

### Scopes
| Scope | Description                    |
|-------|--------------------------------|
| (p)   | Packages                       |
| (lib) | Library files                  |
| (aux) | Auxiliary files                |

Unscoped commits refer to VAT itself.
