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

* [ ] add cli: zpm test in zpm-cli, the cli will execute the test/test.zsh script to test the zsh scripts under the test/**

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
        .zpm/src/utils/zpm.zsh:24
        .zpm/src/autoload.zsh:285
        .zpm/bin/zpm:31
* [ ] To execute a script in the "scripts" section of zpm-package.json, like:
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
* [ ] Implement the cli: zpm uninstall <domain>/username/repository, to
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

* [ ] Instead of the json format, use the pure json format to write the zpm-package.json file.