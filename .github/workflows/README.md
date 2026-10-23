# Reusable workflows

Shared CI for GRaCe-GRC repositories. A repository keeps small caller workflows that call these
workflows instead of copying the steps.

| Workflow | Steps |
|---|---|
| `maven-ci.yml` | Set up Temurin, `./mvnw -B verify` |
| `angular-ci.yml` | Set up Node.js, `npm ci`, `npm run lint`, `npm test -- --watch=false`, `npm run build` |

## Branch verify

Every repository has `.github/workflows/branch-verify.yml`. It runs on every push to a branch
other than `main`, and on every pull request. Java services call `maven-ci.yml`:

```yaml
name: Branch verify

on:
  push:
    branches-ignore: [ main ]
  pull_request:

permissions:
  contents: read

jobs:
  verify:
    uses: GRaCe-GRC/.github/.github/workflows/maven-ci.yml@main
```

`admin-console-ui` calls `angular-ci.yml` instead:

```yaml
jobs:
  verify:
    uses: GRaCe-GRC/.github/.github/workflows/angular-ci.yml@main
```

A branch with an open pull request gets two runs per push: one for the push and one for the pull
request. Angular repositories need `lint`, `test` and `build` scripts in `package.json`.

## Inputs

| Workflow | Input | Default | Description |
|---|---|---|---|
| `maven-ci.yml` | `java-version` | `25` | Temurin Java version |
| `angular-ci.yml` | `node-version` | `24` | Node.js version |

Override an input with `with`:

```yaml
jobs:
  verify:
    uses: GRaCe-GRC/.github/.github/workflows/maven-ci.yml@main
    with:
      java-version: '21'
```

## Starter templates

The workflow templates in [`workflow-templates/`](../../workflow-templates) contain the same
caller workflows (`branch-verify-maven`, `branch-verify-angular`). In a repository, choose
**Actions → New workflow** to add one.
