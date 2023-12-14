/**
 *  the script to query the alias name in the json text given the query path in cli
 *  @example
 * ``` bash
 *  $ qjs alias-name-query.js --json-txt {"aliasName1": true, "aliasName2": true, ...} --query aliasName1
 *  true # <-- if the key name in the json and then output the v


export function exit(arg0: number) {
  throw new Error("Function not implemented.");
}
export function exit(arg0: number) {
  throw new Error("Function not implemented.");
}
alue
 * ```
 *  @author wuchuheng<root@wuchuheng.com>
 *  @date 2023/12/11
 */
import * as std from "std";
import parseArgs from "../lib/quckjs-args-parser";
parseArgs({
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
}, scriptArgs.slice(1))
    .then((result) => {
    const jsonTxt = result.regularArgs[0];
    const queryPath = result.options.query;
    const jsonObj = JSON.parse(jsonTxt);
    // if the jsonObj contains a property with the queryPath,
    if (Object.prototype.hasOwnProperty.call(jsonObj, queryPath)) {
        // then print the value of that property
        console.log(jsonObj[queryPath]);
        std.exit(0);
    }
    else {
        // otherwise, print an error message
        console.log(`Error: ${queryPath} not found in ${jsonTxt}`);
        std.exit(1);
    }
})
    .catch((err) => {
    console.log(err.message);
    std.exit(1);
});
//# sourceMappingURL=alias-name-query.js.map