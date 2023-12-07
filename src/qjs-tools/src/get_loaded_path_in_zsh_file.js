import parseArgs from "./libs/quckjs_args_parser/dist/index.js";
import { readFile } from "./libs/std.mjs";
import * as std from "std";

function getAliasNameFromZshFile(filePath, aliasName) {
  const fileContent = readFile(filePath);
  // get the alias name from the zsh file: like the string: import --from ./src/index.js --as index, and i just want the index
  //   const regexPattern = `\$\{\{\s*\s*\}\}`;
  const regexPattern = `\\s*import\\s*--from\\s+["|']?([\\.|\\/|a-z|A-Z|0-9|\\-|\\_]*)["|']?\\s+--as\\s+${aliasName}\\s*`;
  const r = new RegExp(regexPattern);
  const match = fileContent.match(r);
  if (match.legth < 1) {
    std.exit(1);
  } else {
    const tagName = match[1];
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
      result.options["file-path"],
      result.options["alias-name"]
    );
  })
  .catch((err) => {
    console.log(JSON.stringify(err));
  });
