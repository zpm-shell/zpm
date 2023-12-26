#!/usr/bin/env zsh

. ${ZPM_DIR}/src/autoload.zsh || exit 1;
import ../src/utils/ref.zsh --as ref
import ../src/utils/ref-hash.zsh --as hash

local zpm_cli_conf='
{
    name: "zpm",
    description: "ZPM is a package manager for zsh",
    version: "0.0.1",
    commands: {
        init: { args: [], flags: {}, description: "Create a zpm.json5 file" }
    }
}'

${ZPM_DIR}/src/qjs-tools/bin/cli-parser -c "${zpm_cli_conf}" "$@"
