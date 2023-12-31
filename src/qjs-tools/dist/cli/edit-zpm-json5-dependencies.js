import optionParser from "../lib/cli-option-parser";
import * as io from "../lib/io";
import JSON5 from "../lib/json5/json5";
const result = optionParser({
    file: {
        type: "string",
        alias: "f",
        description: "JSON5 file to edit",
    },
    key: {
        type: "string",
        alias: "k",
        description: "Key to edit",
    },
    value: {
        type: "string",
        alias: "v",
        description: "Value to set",
    },
    action: {
        type: "string",
        alias: "a",
        description: "Action to perform: set, delete",
    },
}, scriptArgs.slice(1));
const { file, key, value, action } = result;
const fileContent = io.readFile(file);
const data = JSON5.parse(fileContent);
switch (action) {
    case "set":
        // init the key path
        if (!data.dependencies) {
            data.dependencies = {};
        }
        data.dependencies[key] = value;
        break;
}
const res = JSON5.stringify(data, null, 2);
console.log(res);
//# sourceMappingURL=edit-zpm-json5-dependencies.js.map