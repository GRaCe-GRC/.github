# Reusable workflows

Shared CI for GRaCe-GRC repositories. A repository keeps small caller workflows that call these
workflows instead of copying the steps.

| Workflow | Steps |
|---|---|
| `maven-ci.yml` | Set up Temurin, `./mvnw -B verify` |
| `angular-ci.yml` | Set up Node.js, `npm ci`, `npm run lint`, `npm test -- --watch=false`, `npm run build` |
| `release.yml` | Tag a semantic version, create a GitHub Release, push the image to GHCR |

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

## Release

Every repository has `.github/workflows/release.yml`. It runs on every push to `main`: first the
repository's CI (`maven-ci.yml`, or `angular-ci.yml` in `admin-console-ui`), then the shared
release:

```yaml
name: Release

on:
  push:
    branches: [ main ]

permissions:
  contents: read

jobs:
  verify:
    uses: GRaCe-GRC/.github/.github/workflows/maven-ci.yml@main
  release:
    needs: verify
    permissions:
      contents: write
      packages: write
    uses: GRaCe-GRC/.github/.github/workflows/release.yml@main
```

The shared `release.yml` runs these jobs:

| Job | What it does |
|---|---|
| `tag` | semantic-release reads the commits since the last `vX.Y.Z` tag, creates the next tag and a GitHub Release with generated notes. Nothing is committed back to `main`: the tag is the version |
| `image` | Only when a version was released: builds the image and pushes `ghcr.io/grace-grc/<repository>:<version>` and `:latest` |

| Commit | Release |
|---|---|
| `fix: GRC-<n>: ...` | Patch (`0.1.0` → `0.1.1`) |
| `feat: GRC-<n>: ...` | Minor (`0.1.1` → `0.2.0`) |
| `feat!: ...` or a `BREAKING CHANGE:` footer | Minor while `initial-development` is `true`, major otherwise |
| `chore:`, `docs:`, `ci:`, ... | No release, no image |

| Repository | Image build |
|---|---|
| Has `pom.xml` | Cloud Native Buildpacks (`./mvnw spring-boot:build-image -Drevision=<version>`), `linux/amd64` |
| Otherwise | The repository's `Dockerfile`, `linux/amd64` and `linux/arm64`; `package.json` gets the version first |

Maven repositories use `<version>${revision}</version>` in `pom.xml` so the build takes the
released version. Images carry the `org.opencontainers.image.source` label, which links the
package to its repository. Buildpacks images run under emulation on Apple silicon.

Before the first release, tag the current `main` with the starting version, so the first
`feat` becomes `0.1.0` instead of `1.0.0`:

```bash
git tag v0.0.1 origin/main
git push origin v0.0.1
```

The first push creates the package in the organization. If it is not public, open the package
settings and change its visibility to **Public**, so the sandbox can pull it without signing in.

## Inputs

| Workflow | Input | Default | Description |
|---|---|---|---|
| `maven-ci.yml` | `java-version` | `25` | Temurin Java version |
| `angular-ci.yml` | `node-version` | `24` | Node.js version |
| `release.yml` | `initial-development` | `true` | Breaking changes bump the minor version (`0.x`); set `false` from 1.0 |
| `release.yml` | `java-version` | `25` | Temurin Java version for the image build (Maven repositories) |

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
caller workflows (`branch-verify-maven`, `branch-verify-angular`, `release-maven`,
`release-angular`). In a repository, choose
**Actions → New workflow** to add one.
