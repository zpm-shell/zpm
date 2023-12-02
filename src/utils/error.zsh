#!/usr/bin/env zsh

##
# @desc 获取一个文件1-10行内容
# @use  print_number_line <file path> <file line>
# @example  print_number_line "/Users/wuchuheng/dotfiles/tmp.sh" 5
# @return
#
#    1  | readonly ALL_UNIT_TEST_FILES=(
#    2  | utils/__test__/unit_tests/1_helper.test.sh
#    3  | utils/__test__/unit_tests/2_helper.test.sh
#    4  | utils/__test__/unit_tests/3_helper.test.sh
#  > 5  | utils/__test__/unit_tests/4_helper.test.sh
#    6  | utils/__test__/unit_tests/5_helper.test.sh
#    7  | utils/__test__/unit_tests/6_helper.test.sh
#    8  | utils/__test__/unit_tests/7_helper.test.sh
#    9  | utils/__test__/unit_tests/8_helper.test.sh
#    10 | utils/__test__/unit_tests/9_helper.test.sh
#    11 | utils/__test__/unit_tests/10_helper.test.sh
#
##
function print_number_line() {
  # assert the file exists
  if [[ ! -f "$1" ]]; then
    echo "File $1 does not exist."
    return "${FALSE}"
  fi
  # assert the line number is valid
  if [[ ! $2 =~ ^[0-9]+$ ]]; then
    echo "The line number must be a number."
    return "${FALSE}"
  fi
  # assert the line number was not greater than the file line
  if (( $2 > $(wc -l $1 | awk '{print $1}') )); then
    echo "The line number must be less than the file line."
    return "${FALSE}"
  fi
  local file=$1
  local lineNumber=$2;
  local allLine=$(wc -l ${file} | awk '{print $1}')
  local intervalStart=$lineNumber # 区间开始坐标
  local intervalEnd=$lineNumber # 区间结始坐标
  for (( i=1; i <= 5; i++ )); do
    if ((((intervalStart - 1)) > 0)) ; then
      ((intervalStart--))
    else
      ((intervalEnd++))
    fi
    if (( ((intervalEnd + 1)) <= ${allLine} )); then
      ((intervalEnd++))
    else
      if ((((intervalStart - 1)) > 0)) ; then
        ((intervalStart--))
      fi
    fi
  done
  local result=`sed -n "${intervalStart},${intervalEnd}p" $file`
  local cln=${intervalStart}
  local lineNumberWidth=${#intervalEnd}
  while IFS= read -r line; do
    local gray="\e[90m"
    local noColor="\e[0m"
    if (( cln == lineNumber )); then
      printf " \e[91;1m>${noColor} ${gray}%-${lineNumberWidth}s |${noColor} $line\n" $cln
    else
      printf "   ${gray}%-${lineNumberWidth}s |${noColor} $line\n" $cln
    fi
    ((cln++))
  done <<< "$result"
}


#@param $1: the error message
#@param $2: the level of the function call stack
function throw() {
  local errorMessage="${1:-''}"
  local funcFileTraceLevel="${2:-1}"
  local prevFileLine="${funcfiletrace[${funcFileTraceLevel}]}"

  # print the error detail.
  local redColor="\e[0;31m"
  local noColor="\e[0m"
  printf "${redColor}Error: ${errorMessage}${noColor}\n"

  #2 print the number line in the file
  #2.1 Splitting the file path and line number
  local filePath="${prevFileLine%:*}"
  local lineNumber="${prevFileLine##*:}"
  #2.2 print the number line in the file
  print_number_line ${filePath} "${lineNumber}"

  #3 print the function call stack
  for (( i = ${funcFileTraceLevel}; i <= ${#funcfiletrace[@]}; i++ )); do
    local stackNumberLine=${funcfiletrace[$i]}
    if [[ ${#stackNumberLine} -gt ${#ZMOD_APP_PATH} && ${stackNumberLine:0:${#ZMOD_APP_PATH}} == ${ZMOD_APP_PATH} ]]; then
        stackNumberLine=${stackNumberLine#${ZMOD_APP_PATH}/}
    fi
    printf " ${stackNumberLine}\n"
  done

  #4 return error code
  return "${FALSE}"
}
