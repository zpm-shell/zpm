import optionParser from "../lib/cli-option-parser";
import JSON5 from "../lib/json5/json5";

/**
 * to query json5 string by query string
 * @param json5 the json5 string
 * @param query the query string
 */
const json5Query = (
  json5: string,
  query: string,
  queryType: QueryType
): unknown => {
  const json5Obj = JSON5.parse(json5);
  const queryArr = query.split(".");
  let i: number = 0;
  const resultObj = queryArr.reduce((acc, key) => {
    const isLastKey = queryArr.length - 1 === i;
    i++;
    const getVal = (): unknown => {
      if (Object.keys(acc).includes(key)) {
        return acc[key];
      } else {
        throw new Error(`json5Query: ${key} is not a valid key`);
      }
    };
    if (isLastKey) {
      switch (queryType) {
        case "get":
          return getVal();
        case "has":
          return Object.keys(acc).includes(key);
        case "size":
          return Object.keys(acc).length;
        default:
          throw new Error(`json5Query: ${queryType} is not a valid queryType`);
      }
    } else {
      return getVal();
    }
  }, json5Obj);

  return resultObj;
};

const parserResult = optionParser(
  {
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
  },
  scriptArgs.slice(1)
);
type QueryType = "get" | "has" | "size";

const result = json5Query(
  parserResult["json5String"] as string,
  parserResult["query"] as string,
  parserResult.queryType as QueryType
);

// if result is a simple type, like string, number, boolean, null, undefined, then print it directly
if (typeof result !== "object") {
  console.log(result);
} else {
  // otherwise, use JSON.stringify to print it
  console.log(JSON.stringify(result));
}
