import optionParser from "../lib/cli-option-parser";
import * as io from "../lib/io";
const cliData = optionParser({
    file: {
        type: "string",
        alias: "f",
        description: "JSON file to edit",
    },
    key: {
        type: "string",
        alias: "k",
        description: "Key to edit",
    },
}, scriptArgs.slice(1));
const { file, key } = cliData;
const fileContent = io.readFile(file);
const data = JSON.parse(fileContent);
let result = "";
// init the key path
if (!data.dependencies) {
    data.dependencies = {};
}
if (Object.keys(data.dependencies).includes(key)) {
    result = data.dependencies[key];
}
console.log(result);
//# sourceMappingURL=zpm-json-dependencies-query.js.map