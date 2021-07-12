# GitHub Acctions Workflows for Terraform

## Workflows

See the main [READEME](../README.md) for details on each of the worflows. This document contains some information on how to quickly test some of the steps in this workflow locally.

## git diff for generating the matrix

There is a bit of `awk`/`sed`/`grep` trickery to collect the subfolders where changes occurred since we are working in a mono repo. To test this locally, it's necessary to understand what the `actions/checkout@v2` actually do. When the action runs on a GitHub hosted runner, there is a bit of extra work for setting up the git authorization that we don't need to worry about when testing locally. Assuming that the local environment has `git` and GitHub authorization proberly setup, the sequence of commands to replicate `actions/checkout@v2` looks like the following. This assumes you are starting in a `temp` folder somewhere on your local workstation.

```bash
git init ./terraform-testdev-ghatesting
cd terraform-testdev-ghatesting
git remote add origin https://github.com/MITLibraries/terraform-testdev-ghatesting
git config --local gc.auto 0
git -c protocol.version=2 fetch --no-tags --prune --progress --no-recurse-submodules --depth=1 origin +<commit_id>:refs/remotes/origin/<branch_name>
git checkout --progress --force -B <branch_name> refs/remotes/origin/<branch_name>
git log -1 --format='%H'
```

While slightly different from the actual workflow, it's easiest to just compare the current commit on the branch to the last commit on the `main` branch:

```bash
git fetch origin main --depth=1
export MAIN_SHA=$( git rev-parse origin/main )
export GITHUB_SHA=$( git log -1 --format='%H' )
export DIFF=$( git diff --dirstat=files,0,cumulative $MAIN_SHA $GITHUB_SHA )
```

That will show you the complete list of folders with changes. Now, you can mess around with `awk`/`sed`/`grep` to your heart's content for testing.

## Clean up for matrix

To make the list of folders ready for the GitHub Actions `matrix` functionality, it needs a few other tweaks. First, newlines need to be escaped:

```bash
export MATRIX_DIFF=$( echo "$DIFF" | sed ':a;N;$!ba;s/\n/%0A/g' )
```

Then, the list of folders needs to be converted to a single-line JSON array:

```bash
DIFF=$( echo "$DIFF" | sed ':a;N;$!ba;s/\n/%0A/g' )
JSON="{\"tfpaths\":["

while read path; do
    JSONline="\"$path\","
    if [[ "$JSON" != *"$JSONline"* ]]; then
        JSON="$JSON$JSONline"
    fi
done <<< "$DIFF"

if [[ $JSON == *, ]]; then
 JSON="${JSON%?}"
fi
JSON="$JSON]}"

echo $JSON
```

## Reference

* The current `awk` command (`awk -F ' ' '{print $2}'`) just isolates the folder name from the `git diff` command
* The current `sed` command (`sed 's:/*$::'`) strips trailing slashes from the folder names
* The current `grep -vE` command (`grep -vE '(^.github|^scripts|^tests|^docs|ansible|packer|vagrant)'`) strips out all the folders that do not actually have `.tf` files even if there are changes there.
* The current `grep -E` command (`grep -E '(\/)'`) removes all top level folders that only contain subfolders
