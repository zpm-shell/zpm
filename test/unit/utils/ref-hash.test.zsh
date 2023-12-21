import ../../../src/utils/ref-hash.zsh --as hash
import ../../../src/utils/ref.zsh --as ref

function test_create() {
    call hash.create >> /dev/null
    expect_equal --expected 1 --actual "$?"

    local ref=$(call ref.create)
    # generate an expected value.
    local fileNumberline=${$(zpm_calltrace)[1]}
    local currentFile=${fileNumberline%:*}
    currentFile=${currentFile:A}
    currentFile=${currentFile//\//_}
    currentFile=${currentFile//\./_}
    currentFile=${currentFile//\-/_}
    currentFile=${currentFile:1}
    local expectVal="typeset -g -A ${currentFile}_8_1=( )"
    # # actual value.
    call hash.create --ref "${ref}"
    local actual=$(typeset -p ${ref})
    expect_equal --expected "$expectVal" --actual "$actual"
}

function test_set() {
    local hashRef=$(call ref.create)
    call hash.create --ref "${hashRef}"
    call hash.set -r "${hashRef}" -v "foo" -k "bar" >> /dev/null
    local actual=''
    eval "actual=\"\${${hashRef}[bar]}\""
    expect_equal --expected "foo" --actual "$actual"
}

function test_keys() {
    local hashRef=$(call ref.create)
    call hash.create --ref "${hashRef}"
    call hash.set -r "${hashRef}" -v "foo" -k "bar" >> /dev/null
    local actual=''
    eval "
        actual=\"\${(@k)${hashRef}}\"
    "
    expect_equal --expected "bar" --actual "$actual"
}