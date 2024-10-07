#!/usr/bin/env zsh

# If the env $ZPM_DIR is empty and then try to init this env.
if [[ -z ${ZPM_DIR} ]]; then
    if [[ -d ~/.zpm && ! -z "$(ls -A ~/.zpm)" ]]; then
        ZPM_DIR=${HOME}/.zpm
    else
        echo "The env:\$ZPM_DIR was not found."
        sleep 5; exit 1;
    fi
fi
if [[ ${ZPM_DIR}/.zpmrc  ]]; then
    . ${ZPM_DIR}/.zpmrc || exit 1;
fi
. ${ZPM_DIR}/src/autoload.zsh ${@} || exit 1;
import ../src/utils/ref.zsh --as ref;
import ../src/utils/ref-hash.zsh --as hash;
import ../src/utils/zpm/zpm.zsh --as zpm;

local zpm_cli_conf='
{
    "name": "zpm",
    "description": "zpm is a zsh package manager.",
    "version": "0.1.4",
    "commands": {
        "install": { "args": [{"name": "package name", "required": false}], "flags": {}, "docs": [
            "zpm install                         Install all dependences",
            "zpm install   <package name>        Install a dependence"
        ]},
        "init": { "args": [{"name": "package name", "required": true}], "flags": {}, "docs": [
            "zpm init      <package name>        Create a zpm-package.json file in current directory."
        ]},
        "run": { "args": [{"name": "script", "required": true}], "flags": {
            "workspace": {
                "type": "string",
                "default": "",
                "description": "the workspace path",
                "alias": "w",
                "required": false
            }
        }, "docs": [
            "zpm run       <file or script>      Run a zpm-package.json script or a zsh file."
        ]},
        "uninstall": { "args": [{"name": "package name", "required": true}], "flags": {}, "docs": [
            "zpm uninstall <package name>        Install a package"
        ]},
        "test": { "args": [{"name": "file.zsh", "required": false}], "flags": {}, "docs": [
            "zpm test                            Test all test fils like: *.test.zsh.",
            "zpm test [<test.zsh> | <directory>] Test a specifc test file or directory."
        ]},
        "create": { "args": [{"name": "package name", "required": true}], "flags": {
            "template": {
                "type": "string",
                "default": "package",
                "description": "create a project template,options: package(default),plugin,dotfiles",
                "alias": "t",
                "required": true
            }
        }, "docs": [
            "zpm create    <project name>        Create a new zpm project."
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
        create)
            call zpm.create -d "${commandData}"
        ;;
    esac
fi
