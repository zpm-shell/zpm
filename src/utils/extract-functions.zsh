##
# @param --zsh-file {string} the zsh file to extract functions from
# @echo {list} the list of function names
##
function extract_functions() {
    # parse arguments
    if [[ $# -eq 0 ]]; then
        throw --error-message "No zsh file provided"
        return ${FALSE}
    fi
    local filePath=''
    for i in "${@}"; do
        case "${i}" in
            --zsh-file)
                filePath="$2"
                shift
                ;;
            *)
            shift
                ;;
        esac
    done
    if [[ -z "${filePath}"  ]]; then
        throw --error-message "No zsh file provided"
        return ${FALSE}
    fi
    if [[ ! -f "${filePath}" ]]; then
        throw --error-message "File ${filePath} does not exist"
        return ${FALSE}
    fi

  # Extract the lines with test function names, strip of anything besides the
  # function name, and output everything on a single line.
  local regex_='^\s*((function [A-Za-z0-9_-]*)|([A-Za-z0-9_-]* *\(\)))'
#   egrep "${regex_}" "${filePath}" \
#   |command sed 's/^[^A-Za-z0-9_-]*//;s/^function //;s/\([A-Za-z0-9_-]*\).*/\1/g' \
#   |xargs

  grep -nE "${regex_}" "${filePath}"  \
  |sed -E 's/function[[:space:]]+//' \
  |sed -E 's/^[[:space:]]+//' \
  |sed -E 's/^([0-9]+:[A-Za-z0-9_-]+).*/\1/g' \
  |xargs
}