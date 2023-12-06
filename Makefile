all: test

test: unit-test integration-test

unit-test:
	ZMOD_DIR=${PWD} ZMOD_WORKSPACE=${PWD} zsh src/boot/test-boot.zsh src/config/unit-test-conf.zsh

integration-test:
	ZMOD_DIR=${PWD} ZMOD_WORKSPACE=${PWD} zsh src/boot/test-boot.zsh src/config/integrate-test-conf.zsh

tmp:
	ZMOD_DIR=${PWD} ZMOD_WORKSPACE=${PWD} zsh src/tmp/tmp.zsh
