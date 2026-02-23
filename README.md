<div align="center">
    <!-- TODO: When merging dev into master, change the line below -->
    <img src="https://github.com/tox-wtf/vat/tree/dev/assets/vat.jpg" width="25%">
    <h1 align="center">VAT</h1>
</div>

<h2 align="center">Version Aggregator and Tracker</h2>

VAT aggregates and tracks arbitrarily many versions for a collection of
packages. Though designed with Linux From Scratch maintenance in mind, VAT
is adaptable to most tasks requiring version fetching. The version database is
updated every ~6 hours (as long as my server doesn't randomly go offline).

VAT aims to be simple, fast, and powerful. It's merely a collection of
(parallelized) bash scripts. VAT is configured through its
[config file](./config).

Projects are tracked in the [project database](./p). Each project gets a
directory and config, and projects may be nested. VAT sources configs for
projects and fetches their version channels. For most projects, the `commit` and
`release` version channels are specified. Here are a few project configs:
- [ACL](./p/acl/config)
- [Gawk](./p/gawk/config)
- [GCC](./p/gcc/config)
- [JDK](./p/jdk/config)
- [libtree](./p/libtree/config)
- [Linux](./p/linux/config)
- [rip](./p/rip/config)

A project's versions are recorded to `v.*`. These version files are stored next
to the project's config. Currently supported formats include TSV and JSON. Here
are the `v.tsv`s for the above packages:
- [ACL](./p/acl/v.tsv)
- [Gawk](./p/gawk/v.tsv)
- [GCC](./p/gcc/v.tsv)
- [JDK](./p/jdk/v.tsv)
- [libtree](./p/libtree/v.tsv)
- [Linux](./p/linux/v.tsv)
- [rip](./p/rip/v.tsv)


## Using the APIs
The version file APIs are provided in multiple formats for convenience. Choose
whichever works best for your use case.

> [!WARNING]
> API stability is not currently guaranteed, though I'll try not to break it.

You may choose to use any of the following API base URLS:
- https://raw.githubusercontent.com/tox-wtf/vat/refs/heads/master/p/
- https://vat.tox.wtf/

The `curl` commands below will assume `$VAT_URL` is set to one of the above
URLs. For example:
```sh
export VAT_URL=https://vat.tox.wtf/
```

Versions for individual projects are stored under `/$project/v.$ext`. All
versions for all projects are available at `/ALL.$ext`.


### TSV API
This plaintext API is intended for easy use from a shell with standard
utilities. VAT uses this API internally to generate reports after a run.

> [!NOTE]
> Verbatim tabs are present in this section. It may be best viewed somewhere
> that highlights these.

#### Examples
To check the release version channel of FFmpeg:
```sh
curl -fsSL "$VAT_URL/ffmpeg/v.tsv | grep -F release | cut -f3
```

To check the sdk version channel of Glslang:
```sh
curl -fsSL "$VAT_URL/glslang/v.tsv | grep -F sdk | cut -f3
```

To retrieve the release, unstable, and commit version channels of Gavin Howard's
bc, and then save them to an associative array:
```bash
unset channels
declare -A channels

while IFS= read -r line; do
    IFS=$'\t' read -r _ channel version <<< "$line"
    channels[$channel]=$version
done < <(curl -fsSL "$VAT_URL/gavinhoward/bc/v.tsv")
unset channel version

# Then print the keys and values
for i in "${!channels[@]}"; do
    echo "${i}=${channels[$i]}"
done
```

To retrieve all version channels for all packages, display them, and then parse
out acl's release and inih's commit:
```sh
curl -fsSL "$VAT_URL/ALL.tsv" > _

# display versions prettily
expand -t 32,44 _

# You may prefer '\s', a literal tab, or '.' over [[:blank:]]
acl_release=$(grep "^acl[[:blank:]]release[[:blank:]]" _ | cut -f3)
inih_commit=$(grep "^inih[[:blank:]]commit[[:blank:]]" _ | cut -f3)
rm _
```

To count the number of tracked release versions:
```sh
curl -fsSL "$VAT_URL/ALL.txt" |
    grep -F '	release	' |
    wc -l
```


### JSON API

#### Examples
To retrieve a JSON object of btop's version channels:
```sh
curl -fsSL "$VAT_URL/btop/v.json"
```

> [!NOTE] Keys may contain characters `jq` does not interpret as strings, so
> it's wise to quote them if dealing with variable keys.

To retrieve the release version of Gavin Howard's bc:
```sh
curl -fsSL "$VAT_URL/gavinhoward/bc/v.json" |
    jq -r '."gavinhoward/bc"."release"'

# Or
curl -fsSL "$VAT_URL/gavinhoward/bc/v.json" |
    jq -r '.[]."release"'
```

To retrieve the release version of GNU's bc from `ALL.json`:
```sh
curl -fsSL "$VAT_URL/ALL.json" |
    jq -r '."gnu/bc"."release"'
```

And here's a simple Rust implementation:
```rust
use std::collections::HashMap;

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct VatProject(HashMap<String, HashMap<String, String>>);

fn main() {
    let v = VatProject(HashMap::from(
        [("7zip".into(), HashMap::from([
            ("release".into(), "26.00".into()),
            ("commit".into(), "839151eaaad24771892afaae6bac690e31e58384".into())
        ]))
    ]));

    println!("{}", serde_json::to_string_pretty(&v).unwrap());
}
```


## Running
VAT must be run from its source directory. This is by design as VAT is intended
to be run in a controlled/contained environment, and doing so lets VAT make more
assumptions.

<!-- TODO: Add some way to test things -->
<!-- To test that all packages work, execute the following command: -->
<!-- ```bash -->
<!-- make test -->
<!-- ``` -->

To update the database, execute VAT:
```sh
./vat
```

> [!TIP]
> You may want to reset the runcount:
> ```sh
> echo 0 > runcount
> ```


### Dependencies
<!-- TODO: Figure out if I depend on GNU's implementations of: -->
<!--     - awk -->
<!--     - coreutils -->
<!--     - grep -->
<!--     - sed -->

Since VAT is just a shell script, all its dependencies are runtime. While VAT
may work without some of these, it's best to have all of the following:
- Awk
- Bash
- Coreutils
- Curl
- Git
- Grep
- jq (or jaq)
- Sed
- [Versort](https://github.com/tox-wtf/versort)
- XMLStarlet


## Contributing
I'd love to work alongside anyone building a package repository, and I want this
to be a community-driven project. I'm open to tracking new packages. For more
information, read [the contributing guidelines](./CONTRIBUTING.md).

If you wish to contribute, a good place to start is [the to-do list](./TODO.md).
The following command might also be of use:
```sh
rg 'TODO|HACK|FIXME'
```
