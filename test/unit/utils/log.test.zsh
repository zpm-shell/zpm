import ../../../src/utils/log.zsh --as log

function test_debug_log() {
    local old_zpm_log_level="${ZPM_LOG_LEVEL}";
    ZPM_LOG_LEVEL="DEBUG"
    local actual="$( call log.debug hello)"
    ZPM_LOG_LEVEL="${old_zpm_log_level}"
    local currentFilePath="test/unit/utils/log.test.zsh"
    currentFilePath=${currentFilePath}
    local expectVal="${currentFilePath}:6 [\e[1;93mDEBUG\e[0m] hello"
    expectVal=$(echo ${expectVal})
    expect_equal --expected "${expectVal}" --actual "${actual}"
}

function test_info_log() {
    local actual="$( call log.info hello)"
    local currentFilePath="test/unit/utils/log.test.zsh"
    currentFilePath=${currentFilePath}
    local expectVal="${currentFilePath}:16 [\e[1mINFO\e[0m] hello"
    expectVal=$(echo ${expectVal})
    expect_equal --expected "${expectVal}" --actual "${actual}"
}