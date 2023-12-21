import ../../../src/utils/ref_list.zsh --as list
import ../../../src/utils/ref.zsh --as ref

function test_create() {
    local listRef=$(call ref.create)
    call list.create --ref $listRef
    # get the type of the variable
    
    local actual=''
    eval "
        actual=\$(declare -p ${listRef})
    "
    local expectVal="typeset -g -a ${listRef}=(  )"
    expect_equal --expected "$expectVal" --actual "$actual"
}