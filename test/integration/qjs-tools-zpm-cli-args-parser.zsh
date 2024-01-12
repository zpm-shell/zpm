function test_zpm-cli-args-parser() {
    local expectedVal="{success:false,printTxt:'Usage: zpm [command] [options]\n\nVersion: 0.0.1\nzpm is a package manager for zsh\nCommands:\n  zpm init\t\tcreate a zpm-package.json file\n\nGlobal options:\n  -h, --help\t\tShow this help message and exit\n  -v, --version\t\tShow version information and exit\n'}"
    local actual;
    actual=$( ${ZPM_DIR}/src/qjs-tools/bin/zpm-cli-args-parser 2>&1 )
    expect_equal --expected 0 --actual "$?"
    expect_equal --expected "${expectedVal}" --actual "${actual}"
}