// zpm <command> [ script.zsh ]
import parseArgs from "./parse-args";
// Usage:
// zpm install                                install all the dependencies in your project
// zpm install <foo>                          add the <foo> dependency to your project
// zpm test                                   run this project's tests
// zpm run <foo>                              run the script named <foo>
// zpm init <repository/username/module-name> create a zpm.json5 file
// zpm --help,-h                              print the help documentation
// zpm -v,--version                           print the help documentation
// zpm [script.zsh]                           execute the script
const programArgsConf = {
    name: "zpm",
    version: "0.0.1",
    description: "zpm is a package manager for zsh",
    commands: {
        init: {
            description: "create a zpm.json5 file",
            args: [
                {
                    name: "<repository/username/module-name>",
                    description: "create a zpm.json5 file",
                },
            ],
            options: [],
        },
    },
};
parseArgs(programArgsConf, scriptArgs.slice(1))
    .then(() => { })
    .catch((err) => {
    console.log(err);
});
//# sourceMappingURL=zpm-cli-args-parser.js.map