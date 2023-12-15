type OptionType = Record<
  string,
  {
    type: "boolean" | "string";
    alias: string;
    description: string;
  }
>;
// type OptionParserResultType = Record<string, string | boolean>;

// Define a union type for possible value types
type OptionValue<T extends "boolean" | "string"> = T extends "boolean"
  ? boolean
  : string;

// Update OptionParserResultType to use OptionValue type
type OptionParserResultType<T extends OptionType> = {
  [K in keyof T]: OptionValue<T[K]["type"]>;
};

/**
 * Parses command line options based on the provided option configuration.
 *
 * @param optionConfig - The configuration object defining the available options.
 * @param args - The command line arguments to parse.
 * @returns An object containing the parsed options.
 * @throws Error if an unknown option is encountered or a required value is missing.
 */
// Define a function to parse command line options
const optionParser = (
  optionConfig: OptionType, // Configuration for options
  args: string[] // Command line arguments
): OptionParserResultType<OptionType> => {
  // Create an alias map option name for options
  const aliasMapOName: Record<string, string> = {};
  Object.keys(optionConfig).forEach((optionName) => {
    const { alias } = optionConfig[optionName];
    aliasMapOName[alias] = optionName;
  });

  // Initialize the result object
  const result: OptionParserResultType<OptionType> = {};

  // Colect options from command line arguments to result object
  args.forEach((arg: string, index) => {
    if (!arg.startsWith("-")) return; // Skip if not an option

    let optionName: string = "";
    if (arg.startsWith("--")) {
      // Handle long option names
      optionName = arg.slice(2);
    } else if (arg.startsWith("-")) {
      // Handle short option names
      const alisName = arg.slice(1);
      if (!aliasMapOName[alisName]) throw new Error(`Unknown option: ${arg}`);
      optionName = aliasMapOName[alisName];
    }

    if (optionName !== "") {
      // Check if option is valid
      if (!optionConfig[optionName]) throw new Error(`Unknown option: ${arg}`);
      const config = optionConfig[optionName];

      // Handle boolean options
      if (config.type === "boolean") {
        result[optionName] = true;
      } else if (config.type === "string") {
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
      console.log(
        `--${optionName}, -${optionConfig[optionName].alias}\t\t${optionConfig[optionName].description}`
      );
    }
    throw new Error("No options provided");
  }

  return result;
};

export type { OptionType, OptionParserResultType };
export default optionParser;
