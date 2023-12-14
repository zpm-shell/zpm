function test_alias_name_query_bin() {
  ${ZPM_DIR}/src/qjs-tools/bin/alias-name-query '{"aliasName1": true, "aliasName2": true }' --query aliasName1 >> /dev/null 2>&1
  expect_equal --actual "$?" --expected "0"
}

function test_option-args-parser_bin() {
    local actual;
    actual=$(
    ${ZPM_DIR}/src/qjs-tools/bin/cli-option-args-parser  --option-config '[{name: "name", alias: "n", description: "The name", required: true, default: "", type: "string"}]' --args '--name hello'  2>&1 /dev/null
    ) 
    expect_equal --actual "$?" --expected "0"
    expect_equal --actual "${actual}" --expected '{"name":"hello"}'

    actual=$(
        ${ZPM_DIR}/src/qjs-tools/bin/cli-option-args-parser  --option-config '[{name: "name", alias: "n", description: "The name", required: true, default: "", type: "string"}]' --args '--tmp hello'  2>&1
    ) 
    expect_equal --actual "$?" --expected "1"
}

function test_get-import-path-in-zsh-file_bin() {
    local actual;
    actual=$(
        ${ZPM_DIR}/src/qjs-tools/bin/get-import-path-in-zsh-file  -f test/integration/test-module.zsh -a this 2>&1
      )
    expect_equal --actual "$?" --expected "0"
    expect_equal --actual "${actual}" --expected "./test-module.zsh"
    ${ZPM_DIR}/src/qjs-tools/bin/get-import-path-in-zsh-file  -f test/integration/test-module.zsh -a thias >> /dev/null 2>&1
    expect_equal --actual "$?" --expected "1"
}