import optionParser from "../lib/cli-option-parser";
import JSON5 from "../lib/json5/json5";
/**
 * to query json5 string by query string
 * @param json5 the json5 string
 * @param query the query string
 */
const json5Query = (json5, query) => {
    const json5Obj = JSON5.parse(json5);
    const resultObj = query.split(".").reduce((acc, key) => {
        if (acc[key]) {
            return acc[key];
        }
        else {
            throw new Error(`json5Query: ${key} is not a valid key`);
        }
    }, json5Obj);
    return resultObj;
};
const parserResult = optionParser({
    query: {
        alias: "q",
        type: "string",
        description: "query string",
    },
    json5String: {
        alias: "j",
        type: "string",
        description: "json5 string",
    },
}, scriptArgs.slice(1));
const result = json5Query(parserResult["json5String"], parserResult["query"]);
// if result is a simple type, like string, number, boolean, null, undefined, then print it directly
if (typeof result !== "object") {
    console.log(result);
}
else {
    // otherwise, use JSON.stringify to print it
    console.log(JSON.stringify(result));
}
//# sourceMappingURL=json5-query.js.map