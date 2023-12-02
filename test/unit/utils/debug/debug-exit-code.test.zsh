function test_assert_gt() {
    assert_gt "1" "2" > /dev/null 2>&1
    expect_equal "$?" 1
    assert_gt "2" "1" > /dev/null 2>&1
    expect_equal "$?" 0
}

