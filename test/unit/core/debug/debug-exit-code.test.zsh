function test_assert_gt_exit_code() {
    assert_gt "1" "2" > /dev/null 2>&1
    expect_equal --expected "$?" --actual 1
    assert_gt "2" "1" > /dev/null 2>&1
    expect_equal --expected "$?" --actual 0
}


function test_assert_equal_exit_code() {
    assert_equal "1" "2" > /dev/null 2>&1
    expect_equal --expected "$?" --actual 1
    assert_equal "1" "1" > /dev/null 2>&1
    expect_equal --expected "$?" --actual 0
}

function test_assert_egt_exit_code() {
    assert_egt "1" "2" > /dev/null 2>&1
    expect_equal --expected "$?" --actual 1
    assert_egt "1" "1" > /dev/null 2>&1
    expect_equal --expected "$?" --actual 0
    assert_egt "2" "1" > /dev/null 2>&1
    expect_equal --expected "$?" --actual 0
}