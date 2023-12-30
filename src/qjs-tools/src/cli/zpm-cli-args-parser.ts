// zpm <command> [ script.zsh ]

import { ProgramArgsType } from "../lib/parse-args";
import parseArgs from "../lib/parse-args";
import JSON5 from "../lib/json5/json5";

// Usage:

// zpm install                                install all the dependencies in your project
// zpm install <foo>                          add the <foo> dependency to your project
// zpm test                                   run this project's tests
// zpm run <foo>                              run the script named <foo>
// zpm init <repository/username/module-name> create a zpm-package.json5 file
// zpm --help,-h                              print the help documentation
// zpm -v,--version                           print the help documentation
// zpm [script.zsh]                           execute the script

const programArgsConf: ProgramArgsType = {
  name: "zpm",
  version: "0.0.1",
  description: "zpm is a package manager for zsh",
  commands: {
    init: {
      description: "create a zpm-package.json5 file",
      args: [
        {
          name: "<repository/username/module-name>",
          description: "create a zpm-package.json5 file",
        },
      ],
      options: [],
    },
  },
};

const result = parseArgs(programArgsConf, scriptArgs.slice(1));
console.log(JSON5.stringify(result));
