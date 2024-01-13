# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.28] - 2024-01-13

### Changed

- Transitioned from JSON5 to standard JSON for project configuration. All instances of 'zpm-package.json5' have been renamed to 'zpm-package.json', ensuring compatibility with standard JSON parsing tools. (3cff713, 1289023)
- Finalized the transition to standard JSON throughout the project, simplifying the tooling and increasing compatibility with common JSON utilities. (8f28ebe)
- Renamed zpm-json5-dependencies-query to zpm-json-dependencies-query. Updated references in autoload.zsh to point to the new standard JSON query tool. (bc5117b)
- Renamed json5-query tools to jq to align with standard JSON tool naming conventions. (8f28ebe)
- Removed JSON5 parser dependencies and replaced them with standard JSON parsing. (8f28ebe)

### Fixed

- Corrected JSON string format in jq CLI tests to use double quotes for object keys, ensuring valid JSON input. (aa04ef5)

### Documentation

- Updated TODO.md and README.md with the new version information and relevant changes. (74f8f7b, 3dfdc47)

### Testing

- Modified test cases to check for zpm-package.json instead of zpm-package.json5. (1289023)
- Ensured all automated tests pass with the new configuration format and manually verified the installation and uninstallation processes. (3cff713)

## [0.0.27] - 2024-01-11

### Added

- feat(zpm-cli): add cli: zpm uninstall <package name>

### Fixed

### Changed



## [0.0.26] - 2024-01-11

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.25] - 2024-01-11

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.24] - 2024-01-11

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.23] - 2024-01-11

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.22] - 2024-01-11

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.21] - 2024-01-11

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.20] - 2024-01-11

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.19] - 2024-01-08

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.18] - 2024-01-08

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.17] - 2024-01-08

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.16] - 2024-01-08

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts


## [0.0.15] - 2024-01-08

### Added

### Fixed

### Changed

- refactor(dev_scripts): Rename and improve development scripts

## [0.0.14] - 2024-01-08

### Added

### Fixed

### Changed
- refactor(dev_scripts): Rename and improve development scripts

## [0.0.13] - 2024-01-08

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.12] - 2024-01-08

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.11] - 2024-01-07

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.10] - 2024-01-07

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.9] - 2024-01-07

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.8] - 2024-01-07

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.7] - 2024-01-07

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.6] - 2024-01-07

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.5] - 2024-01-07

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.4] - 2024-01-07

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.3] - 2024-01-07

### Added

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

## [0.0.2] - 2024-01-07

### Added

- :tada: add installation script

### Fixed

- :bug: fix the installaction script was not executable in cli.

### Changed

- :champagne: make the workflows more robust.

## [0.0.1] - 2024-01-13

### Added

- :tada: add cli: zpm init
- :tada: add cli: zpm install
- :tada: add cli: zpm uninstall

### Fixed

### Changed

### Removed
