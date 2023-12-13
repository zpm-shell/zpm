# TODO List

1. [ ] rename js-scripts to js-tools
2. [ ] add the create command in zpm-cli to create a new zpm project.
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