function test_zpm-cli_help_docs() {
    local expectedVal=$(cat <<EOF
Usage: zpm [command] [options]

Version: 0.0.1
zpm is a package manager for zsh

Commands:
  zpm init		create a zpm.json5 file

Global options:
  -h, --help		Show this help message and exit
  -v, --version		Show version information and exit

EOF
    )
    local actual;
    actual=$( ${ZPM_DIR}/src/qjs-tools/bin/zpm-cli-args-parser 2>&1 )
    expect_equal --expected 0 --actual "$?"
    expect_equal --expected "${expectedVal}" --actual "${actual}"
}