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

function test_set() {
    local listRef=$(call ref.create)
    call list.create --ref $listRef
    local expectVal='a' 
    call list.set --ref $listRef --value "${expectVal}"
    local actual=''
    eval "
        local len=\${#${listRef}[@]}
        actual=\${${listRef}[\$len]}
    "
    expect_equal --expected "$expectVal" --actual "$actual"
}

function test_set_with_alias_option() {
    local listRef=$(call ref.create)
    call list.create --ref $listRef
    local expectVal='a' 
    call list.set -r $listRef -v "${expectVal}"
    local actual=''
    eval "
        local len=\${#${listRef}[@]}
        actual=\${${listRef}[\$len]}
    "
    expect_equal --expected "$expectVal" --actual "$actual"
}

function test_set_with_undifind_ref() {
    local listRef=$(call ref.create)
    local expectVal='a' 
    call list.set -r $listRef -v "${expectVal}" >> /dev/null
    expect_equal --expected "1" --actual "$?"
}

function test_length() {
    local listRef=$(call ref.create)
    call list.create --ref $listRef
    expect_equal --expected 0 --actual 0
    call list.set -r $listRef -v "a"
    local actual=$(call list.length -r $listRef)
    expect_equal --expected 1 --actual "$actual"
}

function test_values() {
    local listRef=$(call ref.create)
    call list.create --ref $listRef
    call list.set -r $listRef -v "a"
    call list.set -r $listRef -v "b"
    local actual=$(call list.values -r $listRef)
    expect_equal --expected "a b" --actual "$actual"
}