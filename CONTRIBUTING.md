# Contributing

Thanks for taking the time to contribute — you’re helping make the Dart ecosystem better.

This repository is a **template** for Dart packages. If you’re using it for your own project, feel free to edit this file to match your workflow.

By participating in this project, you agree to follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## Ways to contribute

- Report bugs
- Suggest enhancements
- Improve documentation
- Submit pull requests
- Share examples and use-cases

## Questions and discussions

If you’re unsure whether something is a bug or a feature request, open an issue and describe:

- What you expected to happen
- What actually happened
- Steps to reproduce (if applicable)
- Your Dart SDK version (`dart --version`)

## Filing issues

When opening an issue, please include:

- A clear title and description
- Reproduction steps (minimal, if possible)
- Expected vs actual behavior
- Logs, stack traces, or screenshots (if relevant)

## Development setup

Prerequisites:

- Dart SDK (see `pubspec.yaml` for the supported SDK range)

Common commands:

- Get dependencies: `dart pub get`
- Format: `dart format .`
- Analyze: `dart analyze`
- Run tests: `dart test`

Tip: Keep your editor set to “format on save”.

## Pull requests

We welcome PRs of all sizes. Small, focused PRs are easiest to review.

### Before you submit

- Run `dart format .`
- Run `dart analyze`
- Run `dart test`
- Update documentation if behavior or APIs changed
- Add or update tests for bug fixes and new features
- If you changed public API, update `CHANGELOG.md`

### PR scope guidelines

- Keep PRs focused on a single concern (feature, fix, docs)
- Avoid drive-by refactors unless they’re necessary for the change
- Prefer backwards-compatible improvements when possible

### Review process

Maintainers will aim to respond, but response time can vary. If you haven’t heard back after a reasonable amount of time, a gentle ping is welcome.

## Security

If you discover a security issue, please **do not** open a public issue.

Instead, report it privately to the maintainer(s)!

![contributors badge](https://readme-contribs.as93.net/contributors/kerberjg/dart_package_template?textColor=888888)

## Licensing of contributions

Unless stated otherwise, contributions you submit are provided under this project’s license (see [LICENSE](LICENSE)).

If your organization requires a Contributor License Agreement (CLA) or similar, replace this section with your preferred process.
