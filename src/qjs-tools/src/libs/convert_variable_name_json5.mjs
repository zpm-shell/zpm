import JSON5 from "./json5.mjs";

/**
 * convert the variable name in json5 string.
 * like: {
 *      "key1": "${KEY1_VAL}", // <-- instead the variable name from the outside args.
 *      "key2": "${key1}"      // <-- instead the variable name from itself.
 * }
 *
 * @param {string} json5Str
 * @param {object} variableNameMapValue
 * @return {string}
 */
function convertVariableNameJson5(json5Str, variableNameMapValue) {
  let jsonTxt = JSON.stringify(JSON5.parse(json5Str));
  // replace the variable name in jsonTxt from variableNameMapValue
  for (const keyName of Object.keys(variableNameMapValue)) {
    const regexPattern = `\\$\\{\\{\\s*${keyName}\\s*\\}\\}`;
    const regexObj = new RegExp(regexPattern, "g");
    jsonTxt = jsonTxt.replace(regexObj, variableNameMapValue[keyName]);
  }
  // 2 replace the variable name in jsonTxt from itself
  // 2.1 Collect the remaining variable names
  const regex = /\${{\s*(\w+\.\w+)\s*}}/g;
  const matches = jsonTxt.match(regex);
  const variableNames =
    matches && matches.map((m) => m.replace(/\${{\s*|\s*}}/g, ""));
  // 2.2 Remove the remaining variable names and save them in a set
  const variableNameSet = new Set(variableNames);
  // 2.3 Remove the variable name that do not exist in the json5 file
  const jsonObj = JSON5.parse(jsonTxt);
  variableNameSet.forEach((name) => {
    let isRemove = false;
    name.split(".").reduce((o, i) => {
      if (o[i] === undefined) {
        isRemove = true;
        return;
      }
      return o[i];
    }, jsonObj);

    isRemove && variableNameSet.delete(name);
  });
  // 2.4 Replace the variable name with the value in the json5 file
  variableNameSet.forEach((name) => {
    const value = name.split(".").reduce((o, i) => o[i], jsonObj);
    const keyNameInRegex = name.replace(".", "\\.");
    const regexPattern = `\\$\\{\\{\\s*(${keyNameInRegex})\\s*\\}\\}`;
    const keyNameRegex = new RegExp(regexPattern, "g");
    jsonTxt = jsonTxt.replace(keyNameRegex, value);
  });

  return jsonTxt;
}

export { convertVariableNameJson5 };
