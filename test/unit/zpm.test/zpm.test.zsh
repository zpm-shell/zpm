function test_version() {
    local version=$(zpm --version)
    local expectVal="0.0.1"
    expect_equal --expected "${expectVal}" --actual "${version}"

    version=$(zpm -v)
    expect_equal --expected "${expectVal}" --actual "${version}"
}

function test_init() {
    local tmpdir=$(mktemp -d)
    cd "${tmpdir}"
    local successOutput=$(zpm init github.com/wuchuheng/zpm-hello )
    local expectVal=$(cat <<EOF
{
    name: "github.com/wuchuheng/zpm-hello",
    version: "1.0.0",
    description: "A zpm package",
    main: "src/main.zsh",
    scripts: {
        test: "echo \"Error: no test specified\" && exit 1"
    },
    keywords: [],
    author: "",
    license: "ISC"
}
Create zpm.json5 success
EOF
)
    expect_equal --expected "${expectVal}" --actual "${successOutput}"
    local effectFile="${tmpdir}/zpm.json5"

    local isExist=$([[ -f ${effectFile} ]] && echo "true" || echo "false")
    expect_equal --expected "true" --actual "${isExist}"


    expectVal=$(cat <<EOF
{
    name: "github.com/wuchuheng/zpm-hello",
    version: "1.0.0",
    description: "A zpm package",
    main: "src/main.zsh",
    scripts: {
        test: "echo \"Error: no test specified\" && exit 1"
    },
    keywords: [],
    author: "",
    license: "ISC"
}
EOF
)
    local effectFileContent=$(cat "${effectFile}")
    expect_equal --expected "${expectVal}" --actual "${effectFileContent}"
    cd -
}

function test_help_doc() {
    local actual=$( zpm -h )
    local expectVal=$(cat ${ZPM_DIR}/test/unit/zpm.test/expect_help_doc.txt)
    expect_equal --expected "${expectVal}" --actual "${actual}"

    actual=$( zpm --help )
    expect_equal --expected "${expectVal}" --actual "${actual}"
}

function test_zpm_cli() {
    local actual=$( zpm 2>&1 )
    local expectVal=$(cat ${ZPM_DIR}/test/unit/zpm.test/expect_help_doc.txt)
    expect_equal --expected "${expectVal}" --actual "${actual}"

    zpm 2>> /dev/null
    expect_equal --expected "1" --actual "$?"
}

function test_zpm_script() {
    local actual=$( zpm run hello)
    expect_equal --expected 0 --actual "$?"
    expect_equal --expected "hello world" --actual "${actual}"
}
