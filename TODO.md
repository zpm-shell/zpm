# TODO List

1. [ ] rename js-scripts to js-tools
2. [ ] add the create command in zmod-cli to create a new zmod project.
3. [ ] the shellBootloader and shellBootloadProvider key name in zmod.json5 and it was an objest list, like: 
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