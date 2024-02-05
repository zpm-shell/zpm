#!/usr/bin/env zsh 

import ../../core/test_beta.zsh --as test
import ../log.zsh --as log

function test_info() {
call log.info "hello" --no-path
    # local a=$(call log.info "hello" --no-path)
#     cat > ${ZPM_DIR}/runtime/cache/test.log <<EOF
# $a
# EOF
#     echo "-->$a"
    # call test.equal -a "${a}" -e hello
}