import ../core/test_beta.zsh --as test

function test_install_all_dependenceis() {
    local currentDir=$(pwd)
    local tmpDir=$(mktemp -d)

    # clean the package cache
    local testDependencies=(
        github.com/zpm-shell/deep-dependence-test-package1
        github.com/zpm-shell/deep-dependence-test-package2
    )
    local loopInstalledDependencies=(
        github.com/zpm-shell/deep-dependence-test-package1-1
        github.com/zpm-shell/deep-dependence-test-package1-1-1
        github.com/zpm-shell/deep-dependence-test-package1-2
    )
    local packageCacheDir="${ZPM_DIR}/packages"
    local package='';
    for packae in ${testDependencies[@]}; do
        local saveDir="${packageCacheDir}/${packae}"
        [[ -d ${saveDir} ]] && rm -rf ${saveDir}
    done
    for packae in ${loopInstalledDependencies[@]}; do
        local saveDir="${packageCacheDir}/${packae}"
        [[ -d ${saveDir} ]] && rm -rf ${saveDir}
    done

    # install the packages
    cd ${tmpDir}
    zpm init github.com/zpm-shell/demo-test
    cat > zpm-package.json <<EOF
{
    "name": "github.com/zpm-shell/demo-test",
    "version": "1.0.0",
    "description": "A zpm package",
    "main": "lib/main.zsh",
    "scripts": {
        "start": "zpm run lib/main.zsh",
        "test": "echo \"Error: no test specified\" && exit 1"
    },
    "keywords": [],
    "author": "",
    "license": "ISC",
    "dependencies": {
        "github.com/zpm-shell/deep-dependence-test-package1": "725eabe129bd07888c61a03ec2d90403b7a13974",
        "github.com/zpm-shell/deep-dependence-test-package2": "a544789921bab0ae51c4b6a135c75b01c63cede4"
  }
}
EOF

    zpm install ${package}
    cd ${currentDir}

    # assert the packages for the current project.
    for package in ${testDependencies[@]}; do
        local saveDir="${packageCacheDir}/${package}"
        local hasInstalledPackage=${FALSE}
        if [[ -d ${saveDir} ]]; then
            hasInstalledPackage=${TRUE}
        fi
        call test.equal -e ${hasInstalledPackage} -a ${TRUE}
    done

    # assert the packages for the loop installed project.
    for package in ${loopInstalledDependencies[@]}; do
        local saveDir="${packageCacheDir}/${package}"
        local hasInstalledPackage=$(test -d ${saveDir} && echo ${TRUE} || echo ${FALSE} )
        call test.equal -e ${hasInstalledPackage} -a ${TRUE}
    done
}

function test_install_single_lib() {
    local flowingLiberies=(
        github.com/zpm-shell/test-lib-1-1
    )
    local willBeInstalledLibs=(
        github.com/zpm-shell/test-lib-1
    )


    # clean the package cache
    local packageCacheDir="${ZPM_DIR}/packages"
    local package='';
    for packae in ${flowingLiberies[@]}; do
        local saveDir="${packageCacheDir}/${packae}"
        [[ -d ${saveDir} ]] && rm -rf ${saveDir}
    done
    for packae in ${willBeInstalledLibs[@]}; do
        local saveDir="${packageCacheDir}/${packae}"
        [[ -d ${saveDir} ]] && rm -rf ${saveDir}
    done

    local currentDir=$(pwd)

    # install the packages
    local tmpDir=$(mktemp -d)
    cd ${tmpDir}
    zpm init github.com/zpm-shell/demo-test
    for package in ${willBeInstalledLibs[@]}; do
        zpm install ${package}
    done
    cd ${currentDir}
    
    # assert the packages for the current project.
    for package in ${willBeInstalledLibs[@]}; do
        local saveDir="${packageCacheDir}/${package}"
        local hasInstalledPackage=${FALSE}
        if [[ -d ${saveDir} ]]; then
            hasInstalledPackage=${TRUE}
        fi
        call test.equal -e ${hasInstalledPackage} -a ${TRUE}
    done
    for package in ${flowingLiberies[@]}; do
        local saveDir="${packageCacheDir}/${package}"
        local hasInstalledPackage=${FALSE}
        if [[ -d ${saveDir} ]]; then
            hasInstalledPackage=${TRUE}
        fi
        call test.equal -e ${hasInstalledPackage} -a ${TRUE}
    done
}