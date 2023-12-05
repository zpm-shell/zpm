all: unit-test

unit-test:
	ZMOD_DIR=${PWD} ZMOD_APP_PATH=${PWD} zsh src/boot/unit-test-boot.zsh

mod:
	zsh -c './bin/mod'

tmp:
	ZMOD_DIR=${PWD} ZMOD_APP_PATH=${PWD} zsh src/tmp/tmp.zsh

autoload:
	ZMOD_DIR=${PWD} ZMOD_APP_PATH=${PWD} zsh src/autoload.zsh