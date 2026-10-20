# Contributing to GRaCe-GRC

Thanks for helping out! This guide applies to every repository in the organization
unless a repository provides its own.

## Workflow
1. Open or pick an issue so work isn't duplicated.
2. Create a branch from `main`: `feat/<short-name>`, `fix/<short-name>` or `chore/<short-name>`.
3. Keep pull requests small and focused; link the issue (`Closes #123`).
4. All checks must pass and at least one reviewer must approve before merge.

## Commit messages
Use [Conventional Commits](https://www.conventionalcommits.org/):
`feat: add risk scoring endpoint`, `fix(admin-console): correct pagination`.

## Java / Spring Boot services
- Java 21, Maven wrapper (`./mvnw verify` must pass locally).
- Tests: JUnit 5; aim to cover new logic with unit tests.
- Never put secrets in `application*.yml`; use environment variables or a secrets manager.

## Angular Admin Console
- Node LTS; install with `npm ci`.
- `npm run lint`, `npm test` and `npm run build` must pass.
- Follow the Angular style guide; prefer standalone components.

## Reporting bugs and ideas
Use the issue forms in the repository's **Issues** tab. For security problems, follow
[SECURITY.md](SECURITY.md) instead of opening a public issue.
