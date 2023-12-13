//
// To parse the option args from cli args
// @example:
//   bin/cli-option-args-parser --option-config '[{name: "tmp",alias:"t",description:"des",required:true, type: "string"}]' --args '--tmp hello'
//   {"tmp": "hello"}
//
import JSON5 from "./lib/json5/json5.js";
class OptionError extends Error {
    constructor(message, options) {
        super(message);
        this.options = options;
        this.printHelp();
    }
    printHelp() {
        this.options.forEach((option) => {
            if (option.alias.length > 0) {
                console.log(`  --${option.name}, -${option.alias} \t\t${option.description} (default: ${option.default})`);
            }
            else {
                console.log(`  --${option.name} \t\t${option.description} (default: ${option.default})`);
            }
        });
    }
}
/**
 * Parse the options from args
 * @param optionsConf The options config
 * @param args The args
 * @returns The options
 */
function optionParser(optionsConf, argsStr) {
    // # create a map for options
    const aliasNameMapConfig = {};
    const nameMapConfig = {};
    optionsConf.forEach((option) => {
        nameMapConfig[option.name] = option;
        aliasNameMapConfig[option.alias] = option;
    });
    const result = {};
    // # collect the options from args to result
    const args = argsStr.split(" ");
    args.forEach((arg, index) => {
        if (!arg.startsWith("-"))
            return;
        let optionName = "";
        // ## get the option name from arg
        if (arg.startsWith("--")) {
            optionName = arg.slice(2);
            if (!nameMapConfig[optionName]) {
                throw new OptionError(`Option ${arg} requires a string value.`, optionsConf);
            }
        }
        else {
            const aliasName = arg.slice(1);
            if (!aliasNameMapConfig[aliasName]) {
                throw new OptionError(`Option ${arg} requires a string value.`, optionsConf);
            }
            optionName = aliasNameMapConfig[aliasName].name;
        }
        // ## set the option value to result
        const config = nameMapConfig[optionName];
        // ### get the value from arg
        let value = config.default;
        switch (config.type) {
            case "boolean":
                value = true;
                break;
            case "string":
                if (index + 1 < args.length) {
                    value = args[index + 1];
                }
                else {
                    throw new OptionError(`Option ${arg} requires a string value.`, optionsConf);
                }
                break;
        }
        // ### set the value to result
        result[optionName] = value;
    });
    return result;
}
class CliOptionError extends Error {
    constructor(message) {
        super(message);
        console.log(`--option-config, -oc \tThe option json5 config, like: [{name: name, alias: n, description: "The name", required: true, default: "", type: string}]`);
        console.log(`--args, -a \t\tThe args, like: --name "The name"`);
    }
}
const args = scriptArgs.slice(1);
// get the option name and the value: --option-config, -oc and --args, -a
let optionConfigStr = "";
let argsStr = "";
const aliasNameMapName = {
    oc: "option-config",
    a: "args",
};
let isPreArgIsPotion = false;
args.forEach((arg) => {
    if (isPreArgIsPotion) {
        isPreArgIsPotion = false;
        return;
    }
    if (!arg.startsWith("-")) {
        return;
    }
    if (optionConfigStr.length > 0 && argsStr.length > 0) {
        return;
    }
    // get the option name from arg
    let optionName = "";
    if (arg.startsWith("--")) {
        optionName = arg.slice(2);
    }
    else if (arg.startsWith("-")) {
        const aliasName = arg.slice(1);
        if (!aliasNameMapName[aliasName]) {
            throw new CliOptionError(`alias name ${arg} is not supported.`);
        }
        optionName = aliasNameMapName[aliasName];
    }
    isPreArgIsPotion = true;
    // # parse the option name
    switch (optionName) {
        case "option-config":
            optionConfigStr = args[args.indexOf(arg) + 1];
            break;
        case "args":
            argsStr = args[args.indexOf(arg) + 1];
            break;
    }
});
// # Check the option name and the value
if (!optionConfigStr) {
    throw new CliOptionError(`--option-config, -oc is required.`);
}
if (!argsStr) {
    throw new CliOptionError(`--args, -a is required.`);
}
// # Parse the opions
const optionConfig = JSON5.parse(optionConfigStr);
const optionsObj = optionParser(optionConfig, argsStr);
const result = JSON.stringify(optionsObj);
console.log(result);
//# sourceMappingURL=cli-option-args-parser.js.map