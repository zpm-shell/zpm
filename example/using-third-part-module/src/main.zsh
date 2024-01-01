import ./main.zsh --as self
import github.com/zpm-shell/lib-demo --as demo

function hello() {
    echo "hello"
}

function init() {
    call self.hello
}


