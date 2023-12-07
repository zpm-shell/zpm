import parseArgs from "./libs/quckjs_args_parser/dist/index.js"
import * as std from "std"

parseArgs(
  {
    name: "alias-name-query",
    description: "Query the alias name of a given alias",
    args: [
      {
        name: "json-txt",
        description: "the json text",
        type: "string",
      },
    ],
    options: [
      {
        name: "query",
        alias: "q",
        description: "the query path",
        required: true,
        type: "boolean",
      },
    ],
  },
  scriptArgs.slice(1)
)
  .then((result) => {
    const jsonTxt  = result.regularArgs[0];
    const queryPath = result.options.query;
    const jsonObj = JSON.parse(jsonTxt);
    // if the jsonObj contains a property with the queryPath,
    if (jsonObj.hasOwnProperty(queryPath)) {
      // then print the value of that property
      console.log(jsonObj[queryPath]);
      std.exit(0)
    } else {
      // otherwise, print an error message
      console.log(`Error: ${queryPath} not found in ${jsonTxt}`);
      std.exit(1)
    }
    
  })
  .catch((err) => {
    console.log(err.message);
    std.exit(1);
  });