# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.8] - 2024-12-28

### Features
- Feat: Add a new command `zpm create` to create a new zpm project.

### Docs:
- Update the `README.md` for usage examples.
## [0.1.7] - 2024-10-07

### Features
- Feat: Add a new variable `ZPM_DIR` to the zsh environment.

## [0.1.6] - 2024-10-07

### Refactor
- Refactor: Make the installation script more friendly.

## [0.1.5] - 2024-10-07

### Fixes
- fix: make the printing message more frendly when the package installed failed.

## [0.1.2] - 2024-05-03
### Features
- **Installation**: Simplified post-install configuration in `~/.zshrc`.
  - Updated `install.sh` to directly export `PATH` with `${save_dir}/bin`, eliminating the need for a separate `ZPM_DIR` export.
  - Incorporated logic in `src/zpm-boot.zsh` to initialize `ZPM_DIR` automatically if not set, reinforcing the robustness of the installation process.

### Fixes
- **Testing**: Ensured environment variables are quoted to accommodate paths containing spaces.
  - Applied quotes around `PATH`, `ZPM_DIR`, and `ZPM_WORKSPACE` assignments in the Makefile to prevent failures when these paths include whitespace.
  - Adjusted the 'exec-test' definition, 'integration-test', 'zpm-test', and 'update_release_version' targets to handle paths with spaces properly.

## [0.1.1] - 2024-02-06

### Features
- **Testing**: Enhanced Test Command with Specific File or Directory Support. Implemented support for launching test processes with a specific file or directory path, allowing for more targeted testing within zpm projects. Updated `zpm.zsh` to process `--data|-d` flags for test command input and added a new unit test file `log.test.zsh`. Revised help documentation and test expectations to reflect the new testing capabilities. Fixed a syntax error in `zpm.zsh` and improved error handling for non-existent test paths, ensuring robustness in test execution.

### Fixes
- **Log**: Correct Error Output in Info Log Function. Fixed an issue in `log.info` function where the error output was not correctly formatted. Updated the `log.test.zsh` unit test to validate the corrected functionality, ensuring that the output matches expected values without printing the file path when the `--no-path` flag is used. Adjustments made to ensure adherence to the expected output format.
- **Utils**: Correct Color Formatting and Add Conditional Path Printing in Log Utility. Fixed incorrect color formatting in `color.zsh` and enhanced the `info` function in `log.zsh` to conditionally print the file path. Modified the `color.zsh` reset function to use more appropriate default values, improving the readability and utility of log messages.

### Documentation
- Refined CONTRIBUTING.md to focus on the release process for ZPM. Streamlined CONTRIBUTING.md by removing sections on local development, style guides, bug reporting, and enhancement suggestions. Introduced a detailed guide for the release process of new versions, including specific file updates and Git commands. Emphasized the importance of version consistency across multiple files and provided clear instructions for tagging releases in Git.

## [0.1.0] - 2024-01-28

### Features
- Enhanced 'jsonQuery' function with 'type' query capability in JSON Query CLI tool (42ff0a539addf75070ad429c28bc380efbecb7c9).
- Added test for third-party package function reference in ZPM tool (dac775ad088c6cf1b82051c9db068cdf1f131420).
- Implemented feature for self-referencing functions in scripts and associated tests (ef1607723b889d1447c923cffaad76f05f7add8a, f4a9e1f1926a7511e9bd4b9a3f27d026fbf0fa57).
- Auto-call 'init' function in scripts executed with ZPM (3101cf231f003561dda6fc341da588765c09cd33).
- Introduced replace-variable utility for dynamic file updates in ZPM (8160aad471b7d1553a5099381cca9fb260392e9c).
- Enable script execution with ZPM as interpreter (b73bbd9b5efd428df3c7a4ebf10a2d36b306cea9).
- Introduce dotfiles template for ZPM, enhancing the versatility and user-friendliness of the package manager (c07aee265f36af0b6bd410a19d3aada41b97607e).
- Introduced 'create' command for ZPM project initialization (01ecf3e4222c3b627dfbba1103e207c2e4ed88a5).

### Fixes
- Corrected parsing of workspace path in autoload script for ZPM (f96b15f5b4bd234a13c05c302b7ad3d85834bdf8).
- Resolved third-party module reference and workspace path issues in ZPM (cffe97c5d9b21a6c0505ab047e2fd63b1ebf9118).
- Allowed execution of executable files with ZPM interpreter (c1e51bfcdffc2bb26288d2374dca442cf0bc0200).
- Fixed ${ZPM_WORKSPACE} environment variable issue in `zpm run` command (efe34a7bb3094eb83990d53fbada51110c6f8b22).

### Refactoring
- Improved test execution output formatting in zpm.zsh (2abfbe81f0950a08b97033621248f581d087be3d).

### Documentation
- Added a new feature and documentation improvements to the TODO list (be31b6cf63e39b6194900e5aa09418e39374ebaa, docs: Update TODO List with New Features and Documentation Improvements).
- Enhanced CLI help documentation with alias information (c7bd3133dea7889e1c8544af89df4c700da20749, d01a9d5f8af6b5c2bc0f8b50d8222301833b9c87).
- Updated the new version: 0.0.29 in README.md (be60070c2d2ca760dafe81f96c0f54fe69491df4).

### Testing
- Exclude specific test directories in zpm test execution (5713b1bf63215533fe2407039bc5173bfd859407).
- Enhanced logging and testing for dotfiles creation in ZPM (6bf59a57c0b2857e0af96d027601da921314656b).
- Test update for `zpm create -h` command (dc0c6f96f9cc52576477041892d100bf244580be).

### Chores
- Added README.md template for ZPM dotfiles, providing clear guidelines for setting up and personalizing the Zsh environment with ZPM (875c5c462d22dd590ee01bae1f527ff8241292ae).
- Introduced install.zsh script in Dotfiles template for ZPM, automating the checking and installation of necessary tools for a new ZPM-managed dotfiles project (f3d5f28ac4f75d9152931ff388a5a764db68e6bd).
- Added TODO item for self-referencing functions enhancement in ZPM (7f08dc255b478831092e0b11258bcc907648d63d).

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
