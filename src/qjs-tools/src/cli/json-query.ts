import optionParser from "../lib/cli-option-parser";

/**
 * to query json string by query string
 * @param json the json string
 * @param query the query string
 */
const jsonQuery = (
  json: string,
  query: string,
  queryType: QueryType
): unknown => {
  const jsonObj = JSON.parse(json);
  const queryArr: string[] = [];
  let itemPrefix = "";
  query.split(".").forEach((item) => {
    // foreach the chars from the last one to the first one
    // if the count of \ is odd, then the char is not a separator
    let backslashCount = item
      .split("")
      .reverse()
      .join("")
      .search(/(\\\\)*\\/);
    backslashCount++;
    if (backslashCount % 2 === 0) {
      if (itemPrefix === "") {
        queryArr.push(item);
      } else {
        queryArr.push(itemPrefix + "." + item);
      }
    } else {
      itemPrefix =
        itemPrefix === ""
          ? item.substring(0, item.length - 1)
          : itemPrefix + "." + item;
    }
  });

  const checkKeyExist = (obj: Record<string, string>, key: string): void => {
    if (!Object.keys(obj).includes(key)) {
      throw new Error(`key ${key} not exist`);
    }
  };
  let i: number;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let tmpData: any;
  switch (queryType) {
    case "get":
      return queryArr.reduce((prev, curr) => {
        checkKeyExist(prev, curr);
        return prev[curr];
      }, jsonObj);
    case "has":
      i = 0;
      return queryArr.reduce((prev, curr) => {
        const isLastElement = i === queryArr.length - 1;
        i++;
        if (isLastElement) {
          return Object.keys(prev).includes(curr);
        } else {
          try {
            checkKeyExist(prev, curr);
            return prev[curr];
          } catch (e) {
            console.log(`query: ${query} is not exist`);
            checkKeyExist(prev, curr);
          }
        }
      }, jsonObj);
    case "size":
      i = 0;
      return queryArr.reduce((prev, curr) => {
        const isLastElement = i === queryArr.length - 1;
        i++;
        checkKeyExist(prev, curr);
        if (isLastElement) {
          return Object.keys(prev[curr]).length;
        } else {
          return prev[curr];
        }
      }, jsonObj);
    case "keys":
      i = 0;
      return queryArr.reduce((prev, curr) => {
        const isLastElement = i === queryArr.length - 1;
        i++;
        checkKeyExist(prev, curr);
        if (isLastElement) {
          return Object.keys(prev[curr]);
        } else {
          return prev[curr];
        }
      }, jsonObj);
    case "delete":
      i = 0;
      queryArr.forEach((item) => {
        if (i === 0) {
          tmpData = jsonObj[item];
        } else if (i === queryArr.length - 1) {
          delete tmpData[item];
        } else {
          tmpData = tmpData[item];
        }
        i++;
      });

      return jsonObj;
  }
};

const parserResult = optionParser(
  {
    query: {
      alias: "q",
      type: "string",
      description: "query string",
    },
    jsonString: {
      alias: "j",
      type: "string",
      description: "json string",
    },
    queryType: {
      alias: "t",
      type: "string",
      description: "query type: has, get, size, keys, delete",
    },
  },
  scriptArgs.slice(1)
);
type QueryType = "get" | "has" | "size" | "keys" | "delete";

const result = jsonQuery(
  parserResult["jsonString"] as string,
  parserResult["query"] as string,
  parserResult.queryType as QueryType
);

// if result is a simple type, like string, number, boolean, null, undefined, then print it directly
if (typeof result !== "object") {
  console.log(result);
} else {
  // otherwise, use JSON.stringify to print it
  console.log(JSON.stringify(result, null, 2));
}
