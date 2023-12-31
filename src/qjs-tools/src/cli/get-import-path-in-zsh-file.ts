//
// the script to query the alias name in the json text given the query path in cli
// @example
//``` bash
// $ bin/get-import-path-in-zsh-file  -f <zsh file path> -a <as name>
// <file path> # <-- if the key name in the json and then output the value
//```
// @author wuchuheng<root@wuchuheng.com>
// @date 2023/12/12
//

import parseArgs from "../lib/quckjs-args-parser";
import { readFile } from "../lib/io";
import * as std from "std";

function getAliasNameFromZshFile(filePath: string, aliasName: string): void {
  const fileContent = readFile(filePath);
  // get the alias name from the zsh file: like the string: import ./src/index.js --as index, and i just want the index
  //   const regexPattern = `\$\{\{\s*\s*\}\}`;
  const regexPattern = `\\s*import\\s*\\s+["|']?([\\.|\\/|a-z|A-Z|0-9|\\-|\\_]*)["|']?\\s+--as\\s+${aliasName}\\s*`;
  const r = new RegExp(regexPattern);
  const match = fileContent.match(r);
  if (!match) {
    std.exit(1);
  }
  if (match!.length === 0) {
    std.exit(1);
  } else {
    const tagName = match![1];
    console.log(tagName); // Outputs: error
    std.exit(0);
  }
}

const args = scriptArgs.slice(1);

parseArgs(
  {
    name: "get-loaded-path-in-zsh-file",
    description: "get the loaded path in zsh file",
    args: [],
    options: [
      {
        name: "file-path",
        alias: "f",
        required: true,
        type: "string",
        description: "the file contain alias name",
      },
      {
        name: "alias-name",
        alias: "a",
        required: true,
        type: "string",
        description: "the alias name",
      },
    ],
  },
  args
)
  .then((result) => {
    getAliasNameFromZshFile(
      result.options["file-path"] as string,
      result.options["alias-name"] as string
    );
  })
  .catch((err) => {
    console.log(JSON.stringify(err));
  });
