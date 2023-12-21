import ../../../src/utils/ref.zsh --as ref

function test_create() {
    local actual="$( call ref.create)"
    # current file path
    local fileNumberline=${$(zpm_calltrace)[1]}
    local currentFile=${fileNumberline%:*}
    currentFile=${currentFile:A}
    # convert the / to _
    currentFile=${currentFile//\//_}
    currentFile=${currentFile//\./_}
    currentFile=${currentFile:1}
    local expectVal="${currentFile}_3_1"
    expect_equal --expected "${expectVal}" --actual "${actual}"
}