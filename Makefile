define exec-test
	PATH=${PWD}/bin:${PATH} \
	ZPM_DIR=${PWD}\
	ZPM_WORKSPACE=${PWD} \
	zsh src/boot/test-boot.zsh $1
endef

all: test

test: unit-test integration-test zpm-test

unit-test:
	$(call exec-test,src/config/unit-test-conf.zsh)

integration-test:
	$(call exec-test,src/config/integrate-test-conf.zsh)

zpm-test:
	PATH=${PWD}/bin:${PATH} \
	ZPM_DIR=${PWD}\
	ZPM_WORKSPACE=${PWD} \
	zpm test

tmp:
	ZPM_DIR=${PWD} ZPM_WORKSPACE=${PWD} zsh src/tmp/tmp.zsh

# install the git hooks
install_git_hooks:
	git config core.hooksPath .git_hooks/

# update the version in README.md with new version
#@param VERSION - new version
# example: make update_readme_version VERSION=1.2.3
update_readme_version:
	.dev_scripts/update_readme_version.sh $(VERSION)

# check if the version is valid, this is used in the release process to check if the version is valid
check_release_version:
	.dev_scripts/check_release_version.sh $(VERSION)

update_release_version:
	.dev_scripts/update_release_version.sh $(VERSION)

# print the change log with the new version
# this is used to get the change log for the release explanation on the github action.
change_log:
	.dev_scripts/change_log.sh $(VERSION)