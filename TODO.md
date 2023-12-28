# TODO List

1. [x] rename js-scripts to js-tools
2. [x] add the create command in zpm-cli to create a new zpm project.
3. [ ] the shellBootloader and shellBootloadProvider key name in zpm.json5 and it was an objest list, like: 
```json5
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

4. [ ] add cli: zpm test in zpm-cli, the cli will execute the test/test.zsh script to test the zsh scripts under the test/**

5. [ ] 🎉 If you call a function with emoji in it, the code will be messed up and not displayed.
6. [ ] the number line was incorect after throw an error, like:
        Error: The zpm.json5 file already exists
        19 |     done
        20 | 
        21 |     # if the input data is empty, then exit
        22 |     if [[ -z "${inputData}" ]]; then
        23 |         throw --error-message "The flag: --data|-d was requird" --exit-code 1
        > 24 |     fi
        25 | 
        26 |     # if the zpm.json5 file exists, then exit
        27 |     if [[ -f "zpm.json5" ]]; then
        28 |         throw --error-message "The zpm.json5 file already exists" --exit-code 1
        29 |     fi
        .zpm/src/utils/zpm.zsh:24
        .zpm/src/autoload.zsh:285
        .zpm/bin/zpm:31
