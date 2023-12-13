define exec-test
	PATH=${PWD}/bin:${PATH} \
	ZPM_DIR=${PWD}\
	ZPM_WORKSPACE=${PWD} \
	zsh src/boot/test-boot.zsh $1
endef

all: test

test: unit-test integration-test

unit-test:
	$(call exec-test,src/config/unit-test-conf.zsh)

integration-test:
	$(call exec-test,src/config/integrate-test-conf.zsh)

tmp:
	ZPM_DIR=${PWD} ZPM_WORKSPACE=${PWD} zsh src/tmp/tmp.zsh
