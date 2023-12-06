#!/usr/bin/env zsh

local ZMOD_VERSION="0.0.1"

function print_zmod_docs() {
  cat <<EOF
zmod <command> [ script.zsh ]

Usage:

zmod install        install all the dependencies in your project
zmod install <foo>  add the <foo> dependency to your project
zmod test           run this project's tests
zmod run <foo>      run the script named <foo>
zmod init           create a zmod.json5 file
zmod --help,-h      print the help documentation
zmod -v,--version   print the help documentation
zmod [script.zsh]   execute the script

zmod@${ZMOD_VERSION} ${ZMOD_DIR}/bin/zmod
EOF
}

if [[ $# -eq 0 ]]; then
  print_zmod_docs;
  exit 1;
fi

local args=("$@")
for (( i = 1; i <= ${#args[@]}; i++ )); do
  local arg=${args[$i]}
  case ${arg}; in
    --help|-h)
      print_zmod_docs
      exit 0
      ;;
    --version|-v)
      echo "${ZMOD_VERSION}"
      exit 0
      ;;
    *)
      echo "unknown arg: ${arg}"
      echo "try 'zmod --help'"
      exit 1
      ;;
  esac
done

