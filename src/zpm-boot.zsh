#!/usr/bin/env zsh

. ${ZPM_DIR}/.zpmrc || exit 1;
. ${ZPM_DIR}/src/autoload.zsh || exit 1;
import ../src/utils/ref.zsh --as ref;
import ../src/utils/ref-hash.zsh --as hash;
import ../src/utils/zpm.zsh --as zpm;

local zpm_cli_conf='
{
    "name": "zpm",
    "description": "zpm is a zsh package manager.",
    "version": "0.0.28",
    "commands": {
        "install": { "args": [{"name": "package name"}], "flags": {}, "docs": [
            "zpm install                         Install all dependences",
            "zpm install   <package name>        Install a dependence"
        ]},
        "init": { "args": [{"name": "package name"}], "flags": {}, "docs": [
            "zpm init      <package name>        Create a zpm-package.json file in current directory."
        ]},
        "run": { "args": [{"name": "script"}], "flags": {}, "docs": [
            "zpm run       <file or script>      Run a zpm-package.json script or a zsh file."
        ]},
        "uninstall": { "args": [{"name": "package name"}], "flags": {}, "docs": [
            "zpm uninstall <package name>        Install a package"
        ]},
        "test": { "args": [], "flags": {}, "docs": [
            "zpm test                            Test the scripts flowing the test folder, if the folder is exists."
        ]}
    }
}'

local jq=${ZPM_DIR}/src/qjs-tools/bin/jq
local cliData=$(${ZPM_DIR}/src/qjs-tools/bin/cli-parser -c "${zpm_cli_conf}" "$@")
local ok=$($jq -j "${cliData}" -q "success" -t get)
local output=$($jq -j "${cliData}" -q "output" -t get)
local action=$($jq -j "${cliData}" -q "action" -t get)
if [[ ${output} != "" ]]; then
    if [[ "${ok}" == "true" ]]; then
        echo "${output}"
    else
        echo "${output}" >&2
    fi
fi
[[ "${ok}" == "false" ]] && exit 1

if [[ "${action}" == "command" ]]; then
    local commandName=$($jq -j "${cliData}" -q "command.name" -t get)
    local commandData=$($jq -j "${cliData}" -q "command" -t get)
    case ${commandName} in
        init)
            call zpm.create_zpm_json -d "${commandData}"
        ;;
        run)
            call zpm.run_script -d "${commandData}"
        ;;
        install)
            call zpm.install_package -d "${commandData}"
        ;;
        uninstall)
            call zpm.uninstall_package -d "${commandData}"
        ;;
        test)
            call zpm.test -d "${commandData}"
        ;;
    esac
fi
