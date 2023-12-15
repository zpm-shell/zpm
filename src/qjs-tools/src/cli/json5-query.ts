import optionParser from "../lib/cli-option-parser";
import JSON5 from "../lib/json5/json5";
/**
 * to query json5 string by query string
 * @param json5 the json5 string
 * @param query the query string
 */
const json5Query = (json5: string, query: string): string => {
  const json5Obj = JSON5.parse(json5);
  query.split(".").reduce((acc, key) => {
    if (Object.prototype.hasOwnProperty.call(acc, key)) {
      return acc[key];
    } else {
      throw new Error(`json5Query: ${key} is not a valid key`);
    }
  }, json5Obj);
};

optionParser(json5Query);
