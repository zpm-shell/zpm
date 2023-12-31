#!/usr/bin/env zsh

function test_install_new_package() {
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

    # check the zpm-package.json5 file was exists
    local isExistsZpmPackageJson5=${FALSE}
    if [[ -f "${tmpDir}/zpm-package.json5" ]]; then
        isExistsZpmPackageJson5=${TRUE}
    fi
    expect_equal --actual "${isExistsZpmPackageJson5}" --expected "${TRUE}"

    # check the package was added to the zpm-package.json5 file
    local isAddedPackageToZpmPackageJson5=${FALSE}
    local zpmPackageJson5=$(cat "${tmpDir}/zpm-package.json5")
    local jq5=${ZPM_DIR}/src/qjs-tools/bin/json5-query
    local isDependenceField=$(${jq5} -q dependencies -j "${zpmPackageJson5}" -t has)
    expect_equal --actual "${isDependenceField}" --expected "true"
    local dependenciesData=$(${jq5} -q dependencies -j "${zpmPackageJson5}" -t get)
    expect_equal --actual "${dependenciesData%%:*}" --expected "{\"github.com/zpm-shell/lib-demo\""

    cd -
}

function test_using_third_package_func() {
    local tmpDir=$(mktemp -d)
    cd ${tmpDir}
    zpm init github.com/zpm-shell/demo
    zpm install github.com/zpm-shell/lib-demo
    cat > lib/main.zsh <<EOF
#!/usr/bin/env zpm
import ./main.zsh --as self
import github.com/zpm-shell/lib-demo --as thirdPackage

function init() {
    call thirdPackage.main
}

EOF
    local actual=$(zpm run start)
    local expect="lib-demo: Hello!"
    expect_equal --actual "${actual}" --expected "${expect}"
}