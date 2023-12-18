import ../../../src/utils/log.zsh --as log

function test_debug_log() {
    local actual="$( call log.debug hello)"
    local currentFilePath="test/unit/utils/log.test.zsh"
    currentFilePath=${currentFilePath:A}
    local expectVal="${currentFilePath}:4 [\e[1;93mDEBUG\e[0m] hello"
    expectVal=$(echo ${expectVal})
    expect_equal --expected "${expectVal}" --actual "${actual}"
}

function test_info_log() {
    local actual="$( call log.info hello)"
    local currentFilePath="test/unit/utils/log.test.zsh"
    currentFilePath=${currentFilePath:A}
    local expectVal="${currentFilePath}:13 [\e[1mINFO\e[0m] hello"
    expectVal=$(echo ${expectVal})
    expect_equal --expected "${expectVal}" --actual "${actual}"
}