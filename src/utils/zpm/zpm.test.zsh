import ../../core/test_beta.zsh --as test

##
# test the docs for the cmd: zpm create -h
#
##
function test_zpm_create_cmd_docs() {
    local actual=$(zpm create -h)
    local expect='Usage: 
zpm create    <project name>        Create a new zpm project.

Flags:
	-t, --template		create a project template,options: package(default),plugin,dotfiles'

    call test.equal -a "${actual}" -e "${expect}"

    actual=$(zpm create --help)
    call test.equal -a "${actual}" -e "${expect}"
}

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

function test_workspace_in_runing_script() {
    local tmpDir=$(mktemp -d)
    local currentDir=$(pwd)
    cd ${tmpDir}
    zpm init github.com/zpm-shell/demo-test
    cat > lib/main.zsh <<EOF
#!/usr/bin/env zsh

echo "$ZPM_WORKSPACE"
EOF
    local expectWorkspace="${tmpDir}/lib"

    zpm run -w ${expectWorkspace} lib/main.zsh > result.log
    local actualWorkspace=$(cat result.log)
    local actualVal1=$(cat result.log)
    zpm run --workspace ${expectWorkspace} lib/main.zsh > result.log
    local actualVal2=$(cat result.log)
    cd ${currentDir}
    call test.equal -e "${actualWorkspace}" -a "${actualVal1}"
    call test.equal -e "${actualWorkspace}" -a "${actualVal2}"
}

##
# this test to test the feature that the init function will be called after the script executed with the cmd: 
# zpm run <script.zsh>
# or
# zpm <script.zsh>
# like this snippet in demo.zsh file:
# #!/usr/bin/env zpm
# function init() { # <- this function will be called after the script executed.
#   echo "hello"
# }
#
# function other_func_name() {
# ...
#}
# ...
function test_auto_call_init_function() {
    local tmpDir=$(mktemp -d)
    local currentDir=$(pwd)
    cd ${tmpDir}
    local scriptFile="${tmpDir}/demo.zsh"
    cat > ${scriptFile} <<EOF
#!/usr/bin/env zpm
function init() {
    echo "hello"
}
EOF
    cd ${currentDir}
    local actual1=$(zpm run ${scriptFile})
    local actual2=$(zpm ${scriptFile})
    local expect="hello"
    call test.equal -e "${actual1}" -a "${expect}"
    call test.equal -e "${actual2}" -a "${expect}"
}

##
# add the test to test the feature to call the function in the same file with a frendly name.like:
# #!/usr/bin/env zpm
# function init() {
# call foo # <- this will call the function foo in the same file.
# }
#
# function foo() {
# echo "foo"
# }
function test_call_function_in_the_same_file() {
    local tmpDir=$(mktemp -d)
    local currentDir=$(pwd)
    cd ${tmpDir}
    local scriptFile="${tmpDir}/demo.zsh"
    cat > ${scriptFile} <<EOF
#!/usr/bin/env zpm
function init() {
    call foo
}
function foo() {
    echo "foo"
}
EOF
    cd ${currentDir}
    local actual=$(zpm run ${scriptFile})
    call test.equal -e "${actual}" -a "foo"
}

##
# add the test to test the feature to reference the function from a third party
# package with a special file path.like:
# #!/usr/bin/env zpm
# import github.com/username/third-party-package/a/specifical/path/file.zsh --as thirdFild
# function init() {
# call thirdFild.foo # <- this will call the function foo in the file.zsh.
# }
function test_call_function_in_the_third_party_package() {
    local tmpDir=$(mktemp -d)
    local currentDir=$(pwd)
    cd ${tmpDir}
    zpm init github.com/zpm-shell/demo-test
    zpm install github.com/zpm-shell/deep-dependence-test-package2
    local scriptFile="${tmpDir}/demo.zsh"
    cat > ${scriptFile} <<EOF
#!/usr/bin/env zpm
import github.com/zpm-shell/deep-dependence-test-package2/lib/otherFile.zsh --as other

function init() {
    call other.other
}
EOF
    zpm run ${scriptFile} > result.log
    cat result.log
    local actual=$(cat result.log)
    local expect="I got caught"
    cd ${currentDir}
    call test.equal -e "${actual}" -a "${expect}"
}
    