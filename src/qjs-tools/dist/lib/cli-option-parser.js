/**
 * Parses command line options based on the provided option configuration.
 *
 * @param optionConfig - The configuration object defining the available options.
 * @param args - The command line arguments to parse.
 * @returns An object containing the parsed options.
 * @throws Error if an unknown option is encountered or a required value is missing.
 */
// Define a function to parse command line options
const optionParser = (optionConfig, // Configuration for options
args // Command line arguments
) => {
    // Create an alias map option name for options
    const aliasMapOName = {};
    Object.keys(optionConfig).forEach((optionName) => {
        const { alias } = optionConfig[optionName];
        aliasMapOName[alias] = optionName;
    });
    // Initialize the result object
    const result = {};
    // Colect options from command line arguments to result object
    args.forEach((arg, index) => {
        if (!arg.startsWith("-"))
            return; // Skip if not an option
        let optionName = "";
        if (arg.startsWith("--")) {
            // Handle long option names
            optionName = arg.slice(2);
        }
        else if (arg.startsWith("-")) {
            // Handle short option names
            const alisName = arg.slice(1);
            if (!aliasMapOName[alisName])
                throw new Error(`Unknown option: ${arg}`);
            optionName = aliasMapOName[alisName];
        }
        if (optionName !== "") {
            // Check if option is valid
            if (!optionConfig[optionName])
                throw new Error(`Unknown option: ${arg}`);
            const config = optionConfig[optionName];
            // Handle boolean options
            if (config.type === "boolean") {
                result[optionName] = true;
            }
            else if (config.type === "string") {
                // Handle string options
                const arg = args[index + 1];
                if (!arg || arg.startsWith("-"))
                    throw new Error(`Missing value: --${optionName}`);
                result[optionName] = args[index + 1];
            }
        }
    });
    if (Object.keys(result).length === 0) {
        for (const optionName in optionConfig) {
            console.log(`--${optionName}, -${optionConfig[optionName].alias}\t\t${optionConfig[optionName].description}`);
        }
        throw new Error("No options provided");
    }
    return result;
};
export default optionParser;
//# sourceMappingURL=cli-option-parser.js.map