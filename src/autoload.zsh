#!/usr/bin/env zsh

. ${ZMOD_DIR}/src/utils/test.zsh
. ${ZMOD_DIR}/src/utils/error.zsh
. ${ZMOD_DIR}/src/utils/debug.zsh

##
# @param --from {string} the module source path
# @param --as {string} the alias name for for module
# @example
#   import --from /src/utils/error.zsh --as error
# @return {void}
##
function import() {
    local from=''
    local as=''
    # parse arguments
    for i in "$@"; do
        case $i in
            --from*)
                from="$2"
                shift
                ;;
            --as*)
                as="$1"
                shift
                ;;
        esac
    done
    
    
    echo "from: ${from}, as: ${as}"
}

import --from /src/utils/error.zsh --as error