import ../../../src/utils/ref-list.zsh --as list
import ../../../src/utils/ref.zsh --as ref

function test_create() {
    #TODO(fix): the following code was incorrect to test ref.create
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

function test_size() {
    local listRef=$(call ref.create)
    call list.create --ref $listRef
    expect_equal --expected 0 --actual 0
    call list.set -r $listRef -v "a"
    local actual=$(call list.size -r $listRef)
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

function test_get() {
    local listRef=$(call ref.create)
    call list.create --ref $listRef
    call list.set -r $listRef -v "a"
    call list.set -r $listRef -v "b"
    local actual=$(call list.get -r $listRef -i 2)
    expect_equal --expected "b" --actual "$actual"

    actual=$(call list.get -r $listRef -i 1)
    expect_equal --expected "a" --actual "$actual"

    actual=$(call list.get -r $listRef -i 3 2> /dev/null)
    expect_equal --expected "1" --actual "$?"

    actual=$( call list.get -r $listRef -i 0 )
    expect_equal --expected "1" --actual "$?"
}