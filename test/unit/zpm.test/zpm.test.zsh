function test_version() {
    local version=$(zpm --version)
    local expectVal="0.0.28"
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
    "name": "github.com/wuchuheng/zpm-hello",
    "version": "1.0.0",
    "description": "A zpm package",
    "main": "lib/main.zsh",
    "scripts": {
        "start": "zpm run lib/main.zsh",
        "test": "echo \"Error: no test specified\" && exit 1"
    },
    "keywords": [],
    "author": "",
    "license": "ISC"
}
Create zpm-package.json success
EOF
)
    expect_equal --expected "${expectVal}" --actual "${successOutput}"
    local effectFile="${tmpdir}/zpm-package.json"

    local isExist=$([[ -f ${effectFile} ]] && echo "true" || echo "false")
    expect_equal --expected "true" --actual "${isExist}"


    expectVal=$(cat <<EOF
{
    "name": "github.com/wuchuheng/zpm-hello",
    "version": "1.0.0",
    "description": "A zpm package",
    "main": "lib/main.zsh",
    "scripts": {
        "start": "zpm run lib/main.zsh",
        "test": "echo \"Error: no test specified\" && exit 1"
    },
    "keywords": [],
    "author": "",
    "license": "ISC"
}
EOF
)
    local effectFileContent=$(cat "${effectFile}")
    expect_equal --expected "${expectVal}" --actual "${effectFileContent}"

    # check the lib/main.zsh file was created or not.
    local isCreated=$([[ -f "${tmpdir}/lib/main.zsh" ]] && echo "true" || echo "false")
    expect_equal --expected "true" --actual "${isCreated}"
    
    # check the code of lib/main.zsh file.
    local expectVal=$(cat <<EOF
#!/usr/bin/env zpm
function() {
    echo "Hello world"
}
EOF
)
    local effectFileContent=$(cat "${tmpdir}/lib/main.zsh")
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

function test_zpm_run_help() {
    local actual=$( zpm run --help )
    expect_equal --expected 0 --actual "$?"
    actual=$( zpm run -h )
    expect_equal --expected 0 --actual "$?"

    local expectVal=$( cat ${ZPM_DIR}/test/unit/zpm.test/expect_zpm_run_help_doc.txt )
    expect_equal --expected "${expectVal}" --actual "${actual}"
}
