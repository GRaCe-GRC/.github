# Reusable workflows

Shared CI for GRaCe-GRC repositories. A repository keeps a small `ci.yml` that calls one of these
workflows instead of copying the steps.

| Workflow | For | Steps |
|---|---|---|
| `maven-ci.yml` | Java / Spring Boot services | Set up Temurin, `./mvnw -B verify` |
| `angular-ci.yml` | Angular applications | Set up Node.js, `npm ci`, `npm run lint`, `npm test -- --watch=false`, `npm run build` |
| `image.yml` | Every code repository | Build the container image and push it to GHCR |

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
| `image.yml` | `version` | required | Version to build and tag, without the leading `v` |
| `image.yml` | `java-version` | `25` | Temurin Java version (Maven repositories) |
| `image.yml` | `push` | `true` | `false` builds the image without pushing it |

Override an input with `with`:

```yaml
jobs:
  ci:
    uses: GRaCe-GRC/.github/.github/workflows/maven-ci.yml@main
    with:
      java-version: '21'
```

## Container images

`image.yml` builds the repository's image and pushes it to the GitHub Container Registry as
`ghcr.io/grace-grc/<repository>:<version>` and `:latest`:

| Repository | Build |
|---|---|
| Has `pom.xml` | Cloud Native Buildpacks (`./mvnw spring-boot:build-image -Drevision=<version>`) |
| Otherwise | The repository's `Dockerfile` (`linux/amd64` and `linux/arm64`); `package.json` gets the version first |

Images carry the `org.opencontainers.image.source` label, which links the package to its
repository. Buildpacks images are `linux/amd64` only; on Apple silicon they run under emulation.

Run it after a release:

```yaml
  image:
    needs: release
    if: needs.release.outputs.version != ''
    permissions:
      contents: read
      packages: write
    uses: GRaCe-GRC/.github/.github/workflows/image.yml@main
    with:
      version: ${{ needs.release.outputs.version }}
```

The first push creates the package in the organization. If it is not public, open the package
settings and change its visibility to **Public**, so the sandbox can pull it without signing in.

## Starter templates

The workflow templates in [`workflow-templates/`](../../workflow-templates) contain the same `ci.yml`
callers. In a repository, choose **Actions → New workflow** to add one.
