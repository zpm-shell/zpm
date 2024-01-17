# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.29] - 2024-01-17

#### Features
- Add Test for Cascade Installation of Dependencies in `zpm.zsh`. Implemented `test_install_single_lib` to ensure correct installation of dependencies. (2d5766d)
- Auto-Install Dependencies After Installing a Single Package in `zpm.zsh`. Added automatic initiation of project dependencies installation. (97ee8c3)
- Improved 'zpm install' Command for Comprehensive Dependency Installation. Enhanced command to support nested and multiple dependencies. (bcb2a9a)
- Enhanced Dependency Checks and Configuration Loading. Added checks to verify the existence of the dependencies field in 'zpm-package.json'. (ae4a0f8)
- Advanced Dependency Installation Logic in `zpm.zsh`. Moved `jq` variable declaration to global scope and enhanced `install_package` function. (2ffe678)
- Enhanced CLI Argument Handling and Dependency Installation. Updated CLI argument parsing to recognize required arguments. (21ea6a2)
- Implement advanced testing framework and color utilities. Added `test_beta.zsh` and `color.zsh` for improved testing and console output. (413a0a5)

#### Fixes
- Resolved Dependency Installation Issue in `zpm.zsh`. Fixed bugs in `install_all_dependence` and `loop_install_package` functions. (8d9825e)
- Fixed Formatting in Makefile's `zpm-test` Target. Corrected a missing space for better consistency and readability. (d724b12)

#### Refactoring
- Refinement of Dependency Handling Logic. Streamlined the process of retrieving dependencies. (ae4a0f8)
- Replace JSON5 with standard JSON in the project. Transitioned to using standard JSON for configuration handling. (d12f60d)

#### Documentation
- Update CLI Documentation for Enhanced Clarity. Improved documentation for the `install` command and CLI usage. (fc66d55)
- Update `README.md` with new version and usage examples. Provided clear examples for install and uninstall commands. (b1f6996)
- Update 'implement zpm install for dependencies' task to `TODO.md`. Reflected planned enhancements for bulk dependency installation. (523a57b)
- Update TODO.md to reflect completed tasks. Marked the execution of scripts and transition to pure JSON format as completed. (b3448f7)

#### Testing
- Add integration test for package uninstallation. Extended testing to cover the uninstallation process. (123843b)

#### Chores
- Restore `zpm-package.json` to Project's Configuration. Reverted to full configuration with updated dependency version. (chore: Restore zpm-package.json to Project's Configuration)
- Update Makefile for Enhanced Testing Environment Setup. Included new environment variables for better testing setup. (46fea54)
- Correct `CHANGELOG.md` for 0.0.28. (cb2cce7)
- Update the new version: 0.0.28 to `README.md`. (68bb4c0)

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
