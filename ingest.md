# ingest.js

## What does this do?

- Uses the GitHub API to create a tree of every file in the following repositories:
  - `khulnasoft/khulnasoft`
  - `khulnasoft/.github`
  - `khulnasoft/go.d.plugin`
  - `khulnasoft/agent-service-discovery`
- Filters out every file except `.md`/`.mdx` files (L425).
- Filters out specific `.md`/`.mdx` files as defined by `excludePatterns` (L427-L438).
- Downloads the content of each file from GitHub.
- Sanitizes content by removing unnecessary frontmatter, h1s, and Google Analytics tags.
- Renames `README.md` files by the folder that contains them.
- Normalizes links between documents to match the final structure in the `/docs` folder.
- Writes files to their target directory.

## Usage

```
node ingest.js
```

### Options

The script takes two additional options: a GitHub username and a branch name. These options override the default
username and branch to ingest documentation files from the `khulnasoft/khulnasoft` repository, which are `khulnasoft` and
`master`.

By overriding the defaults, you can test how a documentation file will look and operate when published on Khulnasoft Docs,
or test the functionality of the script itself.

**You must use these options together**.

```
node ingest.js USER BRANCH
```

> Currently, these options only affect how `ingest.js` pulls files from the `khulnasoft/khulnasoft` repository. The other
> repositories still ingest from the `khulnasoft` user and `master` branches.

#### Example: Override branch only

If you want to pull from a `dashboard` branch that exists _on the `khulnasoft/khulnasoft` repository, pass `khulnasoft` for the
username.

```
node ingest.js khulnasoft dashboard
```

#### Example: Override both user and branch

For example, let's say you have a fork of the `khulnasoft/khulnasoft` repository under a GitHub account named `userXYZ`. You
also have a `charts` branch on your fork that you want ingest on your local development environment. You would run:

```
node ingest.js userXYZ charts
```

`ingest.js` now pulls files from the `charts` branch from the `userXYZ/khulnasoft` repository instead of the default.
