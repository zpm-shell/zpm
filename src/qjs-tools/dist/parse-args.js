/*
 */
function printHelp(argsConf) {
    const printTxtList = [];
    printTxtList.push(`Usage: ${argsConf.name} [command] [options]\n`);
    printTxtList.push(`Version: ${argsConf.version}`);
    printTxtList.push(`${argsConf.description}`);
    printTxtList.push("Commands:");
    Object.keys(argsConf.commands).forEach((commandName) => {
        const command = argsConf.commands[commandName];
        printTxtList.push(`  ${argsConf.name} ${commandName}\t\t${command.description}`);
        command.options.forEach((option) => {
            const optionString = option.alias
                ? `-${option.alias}, --${option.name}`
                : `    --${option.name}`;
            printTxtList.push(`    ${optionString}\t${option.description} (default: ${option.default})`);
        });
        printTxtList.push(""); // Add an empty line for readability
    });
    printTxtList.push("Global options:");
    printTxtList.push("  -h, --help\t\tShow this help message and exit");
    printTxtList.push("  -v, --version\t\tShow version information and exit\n");
    return printTxtList.join("\n");
}
/**
 *
 * @param argsConf args config
 * @param arg cli arg
 * @returns
 */
function parseArgs(argsConf, args) {
    // # Check if the user is asking for help
    const isHelp = args.find((arg) => arg.includes("--help") || arg.includes("-h")) || false;
    if (isHelp || args.length === 0) {
        return {
            success: args.length !== 0,
            printTxt: printHelp(argsConf),
        };
    }
    //# Check if the user is asking for version
    const isAskVersion = args.find((arg) => arg.includes("--version") || arg.includes("-v")) ||
        false;
    if (isAskVersion) {
        return {
            success: true,
            printTxt: argsConf.version,
        };
    }
    //# Check the command existed or not
    const command = args[0];
    const commandConf = argsConf.commands[command];
    if (!commandConf) {
        return {
            success: false,
            printTxt: [
                `Unknown command: "${command}"`,
                ``,
                `To see a list of supported zpm commands, run:`,
                `zpm --help`,
            ].join("\n"),
        };
    }
    // # Parse the options and arguments
    // ## Initialize results with default values
    // ### Initialize result value
    const results = {
        success: false,
        printTxt: "",
        result: {
            value: command,
            args: [],
            options: {},
        },
    };
    // ### Populate options with default values
    for (const option of commandConf.options) {
        results.result.options[option.name] = option.default;
    }
    // ## Parse the options and arguments
    for (let i = 0; i <= args.length; i++) {
        const arg = args[i];
        // ### Get an option and check
        if (arg.startsWith("-")) {
            // #### Get the option name
            const isAlisName = arg.startsWith("--") ? false : true;
            const optionName = isAlisName ? arg.slice(1) : arg.slice(2);
            const optionConf = commandConf.options.find((o) => {
                const alisNameOk = isAlisName && o.alias === optionName;
                const longNameOk = !isAlisName && o.name === optionName;
                return alisNameOk || longNameOk;
            });
            // #### Check the option config exited or not
            if (!optionConf) {
                return {
                    success: false,
                    printTxt: `Unknown option: ${arg}`,
                };
            }
            // ### Set the option value bewteen the boolean and string
            // #### if the boolean value required in option config and  Set the option value as boolean
            if (optionConf.type === "boolean") {
                results.result.options[optionConf.name] = true;
                // #### Set the option value as boolean
            }
            else if (optionConf.type === "string") {
                // ##### If it's a string, take the next argument as its value
                i++; // Move to the next argument
                if (i < args.length) {
                    const arg = args[i];
                    if (arg.includes("-"))
                        return {
                            success: false,
                            printTxt: `Option ${arg} requires a string value.`,
                        };
                    results.result.options[optionConf.name] = arg;
                }
                else {
                    return {
                        success: false,
                        printTxt: `Option ${arg} requires a string value.`,
                    };
                }
            }
        }
        else {
            // # Get the argument
            results.result.args.push(arg);
        }
    }
    return results;
}
export default parseArgs;
//# sourceMappingURL=parse-args.js.map