# GRaCe-GRC / .github

Organization-wide defaults for every repository in **GRaCe-GRC**.

The organization page, [github.com/GRaCe-GRC](https://github.com/GRaCe-GRC), shows
[`profile/README.md`](profile/README.md); its logo and avatar are in `profile/assets/`.

| Path | Purpose |
|---|---|
| `profile/README.md`, `profile/assets/` | Public organization profile shown on github.com/GRaCe-GRC, with its logo and avatar |
| `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md` | Default community health files |
| `ISSUE_TEMPLATE/`, `PULL_REQUEST_TEMPLATE.md` | Default issue forms and PR template |
| `workflow-templates/` | Starter caller workflows (branch verify and release, for Maven and Angular) |
| `scripts/` | Scripts used by the reusable workflows (e.g. `jacoco-summary.sh`) |
| `.github/workflows/` | Reusable workflows (Maven and Angular CI, release); see [how to use them](.github/workflows/README.md) |

A repository that has its own version of any of these files uses its own copy instead of this default.
