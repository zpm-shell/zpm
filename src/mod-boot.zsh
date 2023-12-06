#!/usr/bin/env zsh

TRUE=0
FALSE=1

local ZMOD_VERSION="0.0.1"

function print_zmod_docs() {
  cat <<EOF
zmod <command> [ script.zsh ]

Usage:

zmod install                                install all the dependencies in your project
zmod install <foo>                          add the <foo> dependency to your project
zmod test                                   run this project's tests
zmod run <foo>                              run the script named <foo>
zmod init <repository/username/module-name> create a zmod.json5 file
zmod --help,-h                              print the help documentation
zmod -v,--version                           print the help documentation
zmod [script.zsh]                           execute the script

zmod@${ZMOD_VERSION} ${ZMOD_DIR}/bin/zmod
EOF
}

##
# create a zmod.json5
# @params $1 {string} the package name
# @return <boolean>
##
function create_zmod_json5() {

  local zmodJson5="zmod.json5"
  if [[ -f ${zmodJson5} ]]; then
    echo "${zmodJson5} already exitst"
    exit ${FALSE};
  fi
  local packageName="$1"
  if [[ -z ${packageName} ]]; then
      local currentDir=$(pwd)
      local packageName=${currentDir##*/}
  fi
  cat > ${zmodJson5} << EOF
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

cat ${zmodJson5};
}

if [[ $# -eq 0 ]]; then
  print_zmod_docs;
  exit 1;
fi

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

if [[ ${isHelp} -eq ${TRUE} ]]; then
  print_zmod_docs;
elif [[  ${isVersion} -eq ${TRUE} ]]; then
  echo "${ZMOD_VERSION}"
  exit ${TRUE};
elif [[ ${isInit} -eq ${TRUE} ]]; then
  create_zmod_json5 "${initArgs}"
elif [[ ${isInvalidArgs} ]]; then
  cat <<EOF
unknown arg: --incorect-args
try 'zmod --help'
EOF
  exit ${FALSE}
elif [[ ${isScript} -eq ${TRUE} ]]; then
 ZMOD_WORKSPACE=$(pwd)
 . ${ZMOD_DIR}/src/autoload.zsh --source "${scriptPath}"
fi
