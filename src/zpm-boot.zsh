#!/usr/bin/env zsh

. ${ZPM_DIR}/.zpmrc || exit 1;
. ${ZPM_DIR}/src/autoload.zsh || exit 1;
import ../src/utils/ref.zsh --as ref;
import ../src/utils/ref-hash.zsh --as hash;
import ../src/utils/zpm.zsh --as zpm;

local zpm_cli_conf='
{
    name: "zpm",
    description: "zpm is a zsh package manager.",
    version: "0.0.1",
    commands: {
        init: { args: [{name: "package name"}], flags: {}, docs: [
            "zpm init    <package name>        Create a zpm.json5 file in current directory."
        ]},
        run: { args: [{name: "script"}], flags: {}, docs: [
            "zpm run     <file or script>      Run a zpm.json5 script or a zsh file.",
        ]},
        install: { args: [{name: "package name"}], flags: {}, docs: [
            "zpm install <package name>        Install a package"
        ]},
    }
}'

local jq5=${ZPM_DIR}/src/qjs-tools/bin/json5-query
local cliData=$(${ZPM_DIR}/src/qjs-tools/bin/cli-parser -c "${zpm_cli_conf}" "$@")
local ok=$($jq5 -j "${cliData}" -q "success" -t get)
local output=$($jq5 -j "${cliData}" -q "output" -t get)
local action=$($jq5 -j "${cliData}" -q "action" -t get)
if [[ ${output} != "" ]]; then
    if [[ "${ok}" == "true" ]]; then
        echo "${output}"
    else
        echo "${output}" >&2
    fi
fi
[[ "${ok}" == "false" ]] && exit 1

if [[ "${action}" == "command" ]]; then
    local commandName=$($jq5 -j "${cliData}" -q "command.name" -t get)
    local commandData=$($jq5 -j "${cliData}" -q "command" -t get)
    case ${commandName} in
        init)
            call zpm.create_zpm_json5 -d "${commandData}"
        ;;
        run)
            call zpm.run_script -d "${commandData}"
        ;;
    esac
fi