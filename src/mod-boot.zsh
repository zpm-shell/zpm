#!/usr/bin/env zsh

. ${ZPM_DIR}/.zpmrc || exit 1;
. ${ZPM_DIR}/src/autoload.zsh || exit 1;
import ../src/utils/ref.zsh --as ref;
import ../src/utils/ref-hash.zsh --as hash;
import ../src/utils/zpm.zsh --as zpm;

local zpm_cli_conf='
{
    name: "zpm",
    description: "ZPM is a package manager for zsh.",
    version: "0.0.1",
    commands: {
        init: { args: [{name: "package name"}], flags: {}, description: "Create a zpm.json5 file" }
    }
}'

local jq5=${ZPM_DIR}/src/qjs-tools/bin/json5-query
local cliData=$(${ZPM_DIR}/src/qjs-tools/bin/cli-parser -c "${zpm_cli_conf}" "$@")
local ok=$($jq5 -j "${cliData}" -q "success")
local output=$($jq5 -j "${cliData}" -q "output")
local action=$($jq5 -j "${cliData}" -q "action")
echo "${output}"
[[ "${ok}" == "false" ]] && exit 1

if [[ "${action}" == "command" ]]; then
    local commandName=$($jq5 -j "${cliData}" -q "command.name")
    local commandData=$($jq5 -j "${cliData}" -q "command")
    case ${commandName} in
        init)
            call zpm.create_zpm_json5 -d "${commandData}"
        ;;
    esac
fi