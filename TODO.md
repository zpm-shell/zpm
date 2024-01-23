# TODO List

* [x] rename js-scripts to js-tools
* [x] add the create command in zpm-cli to create a new zpm project.
* [ ] the shellBootloader and shellBootloadProvider key name in zpm-package.json and it was an objest list, like: 
```json
    {
        "shellBootloader": [
            "<repository>/<username>/<package 1>",
            "<repository>/<username>/<package 2>",
            // ...
        ],
        "shellBootloadProvider": [
            "lib/shell-bootload-provider.zsh",
            // ...
        ]
    }
```

* [x] Implement the feature to execute all test files like`**/*.test.zsh` in anywhere of the project,the lanch command is `zpm test`, and the test file must be end with `.test.zsh`.

* [x] Implement the feature to include the test files in the zpm-package.json, like:
```json
    {
        "testIgnore": [
            "./test"
        ]
    }
```
    and then the test files will be executed when execute the command `zpm test`.
* [ ] 🎉 If you call a function with emoji in it, the code will be messed up and not displayed.
* [ ] the number line was incorect after throw an error, like:
        Error: The zpm-package.json file already exists
        19 |     done
        20 | 
        21 |     # if the input data is empty, then exit
        22 |     if [[ -z "${inputData}" ]]; then
        23 |         throw --error-message "The flag: --data|-d was requird" --exit-code 1
        > 24 |     fi
        25 | 
        26 |     # if the zpm-package.json file exists, then exit
        27 |     if [[ -f "zpm-package.json" ]]; then
        28 |         throw --error-message "The zpm-package.json file already exists" --exit-code 1
        29 |     fi
        .zpm/src/utils/zpm/zpm.zsh:24
        .zpm/src/autoload.zsh:285
        .zpm/bin/zpm:31
* [x] To execute a script in the "scripts" section of zpm-package.json, like:
    zpm-package.json
    {
        ...
        scripts: {
            cmd1: "echo hello"
        }
        ...
    }
    and then execute the cmd:`zpm run cmd1`
    
* [x] Execute the zsh script by zpm, like: zpm run <zsh-script>
* [x] Implement the cli: zpm uninstall <domain>/username/repository, to
    remove the dependence in zpm-package.json.
* [x] Create and implement ./install.sh to install zpm cli.
* [x] release: update the version number after the zpm released on github.
    after the new version release successful on github, and then then version of the flowing files must be the changed with a bash script on github action:
    - update the new version name in the version field in `zpm-package.json`
    - update the new version name in `README.md`
    - update the new version name in `install.sh`
    and then to create a new commit and push it to the repository.

* [ ] implement the frendly arguments in function, like:
    ```zsh
    function test(arg1, arg2, --flag flag1=true, --flag flag2=false) {
    }
    ```

* [x] to update the new version in README.md, must be to test the release version on github action.
* [x] Instead of the json format, use the pure json format to write the zpm-package.json file.
* [ ] Add a alias name for a longer package name, like:
    ```json
    {
        "alias": {
            "demo": "github.com/zpm-zpm/lib-demo"
        }
    }
    ```
    and then the package name can be used as `demo` instead of `github.com/zpm-zpm/lib-demo`. like:
    ```zsh
    import demo --as demo # instead of import github.com/zpm-zpm/lib-demo --as demo
    ```

* [x] implement the cli: zpm install, to install all the dependence in zpm-package.json.
* [x] add a new feature to set a workspace directory when execute a script, like:
```zsh
zpm run <script> --workspace <workspace>
# OR
zpm run <script> -w <workspace>
```
    and then the script will be executed in the workspace directory and used the zpm-package.json file in the workspace directory.

* [x] impreve the zpm docs, the actual docs is not friendly for the new user. for example, the zpm create command:
``` zsh
$ zpm create -h
Usage: 
zpm create    <project name>        Create a new zpm project.

Flags:
        --template              create a project template,options: package(default),plugin,dotfiles
```
the flag `--template` has been seted the alias name `-t`, but the `-t` was not displayed in the help docs.

* [ ] Add a new feature to call a function self, like:
> demo.zsh
``` zsh 
import ./demo.zsh --as self
function init() {
    call self.foo
}
function foo() {
    echo "hello"
}
```
to instead of:
```zsh
function init() {
    call foo # call the foo function
}
function foo() {
    echo "hello"
}
```
this feature to make the code more readable and clear.
