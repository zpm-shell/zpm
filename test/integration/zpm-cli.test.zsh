#!/usr/bin/env zsh

function test_zpm_install_new_package() {
    local tmpDir=$(mktemp -d)
    cd ${tmpDir}
    cat > zpm-package.json5 <<EOF
{
    name: "github.com/zpm-shell/demo",
    version: "1.0.0",
    description: "A zpm package",
    main: "lib/main.zsh",
    scripts: {
        test: "echo \"Error: no test specified\" && exit 1"
    },
    keywords: [],
    author: "",
    license: "ISC"
}
EOF
    local packageName="github.com/zpm-shell/lib-demo"
    local effectDir="${ZPM_DIR}/packages/${packageName}"
    if [[ -d ${effectDir} ]]; then
        rm -rf ${effectDir}
    fi
    zpm install ${packageName}
    local isDownloadedPackage=${FALSE}
    if [[ -d ${effectDir} ]]; then
        isDownloadedPackage=${TRUE}
    fi
    expect_equal --actual "${isDownloadedPackage}" --expected "${TRUE}"
    cd -
}