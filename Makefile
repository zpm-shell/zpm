all: test

test: unit-test integration-test

unit-test:
	ZPM_DIR=${PWD} ZPM_WORKSPACE=${PWD} zsh src/boot/test-boot.zsh src/config/unit-test-conf.zsh

integration-test:
	ZPM_DIR=${PWD} ZPM_WORKSPACE=${PWD} zsh src/boot/test-boot.zsh src/config/integrate-test-conf.zsh

tmp:
	ZPM_DIR=${PWD} ZPM_WORKSPACE=${PWD} zsh src/tmp/tmp.zsh
