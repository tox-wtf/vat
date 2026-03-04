#!/usr/bin/env bash

set -eu
set +H # disable history expansion
argv0="$0"

nl="
"

die() {
    printf "%s: %s\n" "$argv0" "$1"
    exit "${2:-1}"
}

# Checks
[[ -z "$(git status --porcelain=v1)" ]] || die "Uncommitted changes"
# TODO: Add a way to check packages
# make check || die "Failed checks"

# Get old semver
old_tag=$(git tag | grep -vF 'runs/' | versort | tail -n1)
old_tag_major=$(echo "$old_tag" | cut -d. -f1)
old_tag_minor=$(echo "$old_tag" | cut -d. -f2)
old_tag_patch=$(echo "$old_tag" | cut -d. -f3)

changes=$(git log --pretty=%s "$old_tag"..)

# Check for breaking changes, and determine new semver
if echo "$changes" | grep -q '^!!'; then
    new_tag_major=$((old_tag_major + 1))
    new_tag_minor=0
    new_tag_patch=0
elif echo "$changes" | grep -q '^!'; then
    new_tag_major=$old_tag_major
    new_tag_minor=$((old_tag_minor + 1))
    new_tag_patch=0
else
    new_tag_major=$old_tag_major
    new_tag_minor=$old_tag_minor
    new_tag_patch=$((old_tag_patch + 1))
fi

new_tag="$new_tag_major.$new_tag_minor.$new_tag_patch"

# Get changes
changes="$(git log --pretty=format:"- [ %ci %h ] %s" "$old_tag".. | grep -F ": "  | grep -v "auto.\+: " | sed 's, -[0-9][0-9][0-9][0-9] , | ,')"

# Write out the new changelog
{
    tac CHANGES
    printf "\n"
    printf "%s\n" "$changes" | tac
    printf "VAT %s\n" "$new_tag"
} | tac > _
mv -f _ CHANGES

"$new_tag" > version

git add CHANGES version
git commit -m "chore: release $new_tag" -m "VAT $new_tag$nl$changes"

git tag "$new_tag"
git push origin "$new_tag"
git push

git archive --format=tar -o vat-$new_tag.tar --prefix=vat-$new_tag/ $new_tag
xz -9e vat-$new_tag.tar
