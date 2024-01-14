import ../core/test_beta.zsh --as test

function test() {
    call test.equal -e "hello" -a "hello"
}