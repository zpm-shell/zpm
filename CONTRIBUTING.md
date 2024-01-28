# Contributing to ProjectName

👍🎉 First off, thanks for taking the time to contribute! 🎉👍

The following is a set of guidelines for contributing to the zpm, which are hosted on [zpm-shell/zpm](https://github.com/zpm-shell/zpm) on GitHub. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.


## 1 The release process

For example, we want to release a new version `0.1.0`, and then the list of steps is as follows:

1. Add the change log to the `CHANGELOG.md` file
2. Modify the version number in the the flowing files:
    - `install.sh`
    - `src/zpm-boot.zsh`
    - `test/unit/zpm.test/expect_help_doc.txt`
    - `test/unit/zpm.test/zpm.test.zsh`
3. update the version number with the `make update_release_version VERSION=0.1.0`, to update the flowing files:
    - `zpm-package.json`
    - `install.sh`
4. git tag the version, like: `git tag -a 0.1.0 -m "release: 0.1.0"`
6. push the tag to github: `git push origin master 0.1.0`, and then the git action will release the new version to github release page and create a new commit to update the version number to `0.1.1` in `README.md` file.
7. if the version number was released successfully, then you should pull the new commit to your local repository with `git pull origin master` command.

After the steps was done, this release process was completed.
