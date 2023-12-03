all: autoload

unit-test:
	zsh src/boot/unit-test-boot.zsh

mod:
	zsh -c './bin/mod'

tmp:
	zsh src/tmp.zsh

autoload:
	ZMOD_DIR=${PWD} ZMOD_APP_PATH=${PWD} zsh src/autoload.zsh