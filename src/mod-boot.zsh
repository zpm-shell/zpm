#!/usr/bin/env zsh

TRUE=0
FALSE=1

local ZPM_VERSION="0.0.1"

function print_zpm_docs() {
  cat <<EOF
zpm <command> [ script.zsh ]

Usage:

zpm install                                install all the dependencies in your project
zpm install <foo>                          add the <foo> dependency to your project
zpm test                                   run this project's tests
zpm run <foo>                              run the script named <foo>
zpm init <repository/username/module-name> create a zpm.json5 file
zpm --help,-h                              print the help documentation
zpm -v,--version                           print the help documentation
zpm [script.zsh]                           execute the script

zpm@${ZPM_VERSION} ${ZPM_DIR}/bin/zpm
EOF
}

##
# create a zpm.json5
# @params $1 {string} the package name
# @return <boolean>
##
function create_zpm_json5() {
  local zpmJson5="zpm.json5"
  if [[ -f ${zpmJson5} ]]; then
    echo "${zpmJson5} already exitst"
    exit ${FALSE};
  fi
  local packageName="$1"
  if [[ -z ${packageName} ]]; then
      local currentDir=$(pwd)
      local packageName=${currentDir##*/}
  fi
  cat > ${zpmJson5} << EOF
{
  "name": "${packageName}",
  "version": "1.0.0",
  "description": "",
  "main": "lib/main.zsh",
  "keywords": [],
  "author": "",
  "license": "MIT"
}
EOF

cat ${zpmJson5};
}

local isScript=${FALSE}
local scriptPath=''
local isHelp=${FALSE}
local isVersion=${FALSE}
local isInit=${FALSE}
local initArgs=''
local isInvalidArgs=${FALSE}
local invalidArgs=''
local args=("$@")
for (( i = 1; i <= ${#args[@]}; i++ )); do
  local arg=${args[$i]}
  case ${arg}; in
    --help|-h)
      isHelp=${TRUE}
      ;;
    --version|-v)
      isVersion=${TRUE}
      ;;
    init)
      isInit=${TRUE}
      shift 1
      initArgs="$@"
      ;;
    --*|-*)
      isInvalidArgs=${TRUE}
      invalidArgs="$1"
      shift 1
      # if the prefix --* or -* was not in $1, and then shift
      if [[ $1 =~ "--*" ]]; then
          shift 1
      fi
    ;;
    *)
      local filePath=$1
      isScript=${TRUE}
      scriptPath="$1"
      shift 1
      ;;
  esac
done

[[ -z "${ZPM_WORKSPACE}" ]] && ZPM_WORKSPACE=$(pwd)

local zpmJson5="${ZPM_WORKSPACE}/zpm.json5"
if [[ ! -f ${zpmJson5} ]]; then
    echo "zpm.json5 not found in ${ZPM_WORKSPACE}"; exit ${FALSE};
fi

if [[ ${#args[@]} -eq 0 ]]; then
  print_zpm_docs;
  exit 1;
elif [[ ${isHelp} -eq ${TRUE} ]]; then
  print_zpm_docs;
elif [[  ${isVersion} -eq ${TRUE} ]]; then
  echo "${ZPM_VERSION}"
  exit ${TRUE};
elif [[ ${isInit} -eq ${TRUE} ]]; then
  create_zpm_json5 "${initArgs}"
elif [[ ${isInvalidArgs} -eq ${TRUE} ]]; then
  cat <<EOF
unknown arg: --incorect-args
try 'zpm --help'
EOF
  exit ${FALSE}
elif [[ ${isScript} -eq ${TRUE} ]]; then
 . ${ZPM_DIR}/src/autoload.zsh --source "${scriptPath}"
fi
