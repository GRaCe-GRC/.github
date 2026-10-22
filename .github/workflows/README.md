# Reusable workflows

Shared CI for GRaCe-GRC repositories. A repository keeps a small `ci.yml` that calls one of these
workflows instead of copying the steps.

| Workflow | For | Steps |
|---|---|---|
| `maven-ci.yml` | Java / Spring Boot services | Set up Temurin, `./mvnw -B verify` |
| `angular-ci.yml` | Angular applications | Set up Node.js, `npm ci`, `npm run lint`, `npm test -- --watch=false`, `npm run build` |

## Usage

Add `.github/workflows/ci.yml` to the repository.

### Maven

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:

permissions:
  contents: read

jobs:
  ci:
    uses: GRaCe-GRC/.github/.github/workflows/maven-ci.yml@main
```

### Angular

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:

permissions:
  contents: read

jobs:
  ci:
    uses: GRaCe-GRC/.github/.github/workflows/angular-ci.yml@main
```

The Angular workflow expects `lint`, `test` and `build` scripts in `package.json`.

## Inputs

| Workflow | Input | Default | Description |
|---|---|---|---|
| `maven-ci.yml` | `java-version` | `25` | Temurin Java version |
| `angular-ci.yml` | `node-version` | `24` | Node.js version |

Override an input with `with`:

```yaml
jobs:
  ci:
    uses: GRaCe-GRC/.github/.github/workflows/maven-ci.yml@main
    with:
      java-version: '21'
```

## Starter templates

The workflow templates in [`workflow-templates/`](../../workflow-templates) contain the same `ci.yml`
callers. In a repository, choose **Actions → New workflow** to add one.
