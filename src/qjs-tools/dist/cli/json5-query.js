import optionParser from "../lib/cli-option-parser";
import JSON5 from "../lib/json5/json5";
/**
 * to query json5 string by query string
 * @param json5 the json5 string
 * @param query the query string
 */
const json5Query = (json5, query, queryType) => {
    const json5Obj = JSON5.parse(json5);
    const queryArr = query.split(".");
    const checkKeyExist = (obj, key) => {
        if (!Object.keys(obj).includes(key)) {
            throw new Error(`key ${key} not exist`);
        }
    };
    let i = 0;
    switch (queryType) {
        case "get":
            return queryArr.reduce((prev, curr) => {
                checkKeyExist(prev, curr);
                return prev[curr];
            }, json5Obj);
        case "has":
            return queryArr.reduce((prev, curr) => {
                const isLastElement = i === queryArr.length - 1;
                i++;
                if (isLastElement) {
                    return Object.keys(prev).includes(curr);
                }
                else {
                    try {
                        checkKeyExist(prev, curr);
                        return prev[curr];
                    }
                    catch (e) {
                        console.log(`query: ${query} is not exist`);
                        checkKeyExist(prev, curr);
                    }
                }
            }, json5Obj);
        case "size":
            return queryArr.reduce((prev, curr) => {
                const isLastElement = i === queryArr.length - 1;
                i++;
                checkKeyExist(prev, curr);
                if (isLastElement) {
                    return Object.keys(prev[curr]).length;
                }
                else {
                    return prev[curr];
                }
            }, json5Obj).length;
    }
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
    queryType: {
        alias: "t",
        type: "string",
        description: "query type: has, get, size",
    },
}, scriptArgs.slice(1));
const result = json5Query(parserResult["json5String"], parserResult["query"], parserResult.queryType);
// if result is a simple type, like string, number, boolean, null, undefined, then print it directly
if (typeof result !== "object") {
    console.log(result);
}
else {
    // otherwise, use JSON.stringify to print it
    console.log(JSON.stringify(result));
}
//# sourceMappingURL=json5-query.js.map