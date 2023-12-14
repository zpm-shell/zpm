type StringTypeOption = {
  name: string;
  alias: string;
  description: string;
  default: string;
  type: "string";
};

type BooleanTypeOption = {
  name: string;
  alias?: string;
  description: string;
  default: boolean;
  type: "boolean";
};

// Union type for options
type OptionType = StringTypeOption | BooleanTypeOption;

type ArgType = {
  name: string;
  description: string;
};

type CommandType = {
  description: string;
  args: ArgType[];
  options: OptionType[];
};

type ProgramArgsType = {
  name: string;
  version: string;
  description: string;
  commands: Record<string, CommandType>;
};

type CliCommandParsedResultType =
  | {
      isPrint: false;
      result: {
        value: string;
        args: string[];
        options: Record<string, string | boolean>;
      };
    }
  | { isPrint: true };

/*
 */
function printHelp(argsConf: ProgramArgsType): void {
  console.log(`Usage: ${argsConf.name} [command] [options]\n`);

  console.log(`Version: ${argsConf.version}`);
  console.log(`${argsConf.description}\n`);

  console.log("Commands:");
  Object.keys(argsConf.commands).forEach((commandName) => {
    const command = argsConf.commands[commandName];
    console.log(`  ${argsConf.name} ${commandName}\t\t${command.description}`);
    command.options.forEach((option) => {
      const optionString = option.alias
        ? `-${option.alias}, --${option.name}`
        : `    --${option.name}`;
      console.log(
        `    ${optionString}\t${option.description} (default: ${option.default})`
      );
    });
    console.log(""); // Add an empty line for readability
  });

  console.log("Global options:");
  console.log("  -h, --help\t\tShow this help message and exit");
  console.log("  -v, --version\t\tShow version information and exit\n");
}

/**
 *
 * @param argsConf args config
 * @param arg cli arg
 * @returns
 */
async function parseArgs(
  argsConf: ProgramArgsType,
  args: string[]
): Promise<CliCommandParsedResultType> {
  const resultToPrint: CliCommandParsedResultType = { isPrint: true };
  // # Check if the user is asking for help
  const isHelp =
    args.find((arg) => arg.includes("--help") || arg.includes("-h")) || false;
  if (isHelp || args.length === 0) {
    printHelp(argsConf);
    return resultToPrint;
  }
  //# Check if the user is asking for version
  const isAskVersion =
    args.find((arg) => arg.includes("--version") || arg.includes("-v")) ||
    false;
  if (isAskVersion) {
    console.log(argsConf.version);
    return resultToPrint;
  }

  //# Check the command existed or not
  const command = args[0];
  const commandConf = argsConf.commands[command];
  if (!commandConf) {
    throw new Error(`
Unknown command: "${command}"

To see a list of supported zpm commands, run:
zpm --help`);
  }

  // # Parse the options and arguments
  // ## Initialize results with default values
  // ### Initialize result value
  const results: CliCommandParsedResultType = {
    isPrint: false,
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
        throw new Error(`Unknown option: ${arg}`);
      }
      // ### Set the option value bewteen the boolean and string
      // #### if the boolean value required in option config and  Set the option value as boolean
      if (optionConf.type === "boolean") {
        results.result.options[optionConf.name] = true;
        // #### Set the option value as boolean
      } else if (optionConf.type === "string") {
        // ##### If it's a string, take the next argument as its value
        i++; // Move to the next argument
        if (i < args.length) {
          const arg = args[i];
          if (arg.includes("-"))
            throw new Error(`Option ${arg} requires a string value.`);
          results.result.options[optionConf.name] = arg;
        } else {
          throw new Error(`Option ${arg} requires a string value.`);
        }
      }
    } else {
      // # Get the argument
      results.result.args.push(arg);
    }
  }

  return results;
}

export type {
  ProgramArgsType,
  CliCommandParsedResultType,
  CommandType,
  ArgType,
  OptionType,
};

export default parseArgs;
