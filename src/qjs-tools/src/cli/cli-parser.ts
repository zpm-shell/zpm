import * as std from "std";

type FlagValueType = string | number | boolean;
type FlagConfig = {
  type: "string" | "number" | "boolean";
  default: string | number | boolean;
  description: string;
  alias: string;
  required: boolean;
};
type CommandType = {
  args: { name: string; required: boolean }[];
  flags: Record<string, FlagConfig>;
  docs: string[];
};

type CliConfType = {
  name: string;
  version: string;
  description: string;
  commands: Record<string, CommandType>;
};

type OutputDataType = {
  success: boolean;
  action: "command" | "help" | "version";
  output: string;
  command?: {
    name: string;
    args: { name: string; value: string }[];
    flags: Record<string, string | number | boolean>;
  };
};

/**
 * ExitError
 */
class ExitError extends Error {
  constructor(message: string) {
    const outputError: OutputDataType = {
      success: false,
      action: "help",
      output: `\\e[1;41m ERROR \\e[0m ${message}`,
    };
    console.log(JSON.stringify(outputError));
    std.exit(1);
    super(message);
  }
}

/**
 *
 * @param cliArgs
 */
function parseCliConf(cliArgs: string[]): CliConfType {
  // Check if the user has passed a config file
  let cliConfig = "";
  cliArgs.forEach((arg, i) => {
    const isConfigFlag = arg === "--config" || arg === "-c";
    const hasNextArg = i + 1 <= cliArgs.length;
    if (isConfigFlag && hasNextArg) {
      const nextArg = cliArgs[i + 1];
      if (!nextArg.startsWith("-")) {
        cliConfig = nextArg;
      }
    }
  });
  if (cliConfig === "") {
    throw new ExitError(
      "No config file found, please add a config with the --config | -c flag"
    );
  }

  // check if the config was valid
  let cliConfObj;
  try {
    cliConfObj = JSON.parse(cliConfig);
  } catch (e) {
    throw new ExitError("Invalid config");
  }

  // check the config has the required name and the name property is a string
  if (!Object.prototype.hasOwnProperty.call(cliConfObj, "name")) {
    throw new ExitError("Config must have a name property");
  }
  if (typeof cliConfObj.name !== "string") {
    throw new ExitError("The name property must be a string");
  }

  // check the config has the required version and the version property is a string
  if (!Object.prototype.hasOwnProperty.call(cliConfObj, "version")) {
    throw new ExitError("Config must have a version property");
  }
  if (typeof cliConfObj.version !== "string") {
    throw new ExitError("The version property must be a string");
  }

  // check the config has the required description and the description property is a string
  if (!Object.prototype.hasOwnProperty.call(cliConfObj, "description")) {
    throw new ExitError("Config must have a description property");
  }
  if (typeof cliConfObj.description !== "string") {
    throw new ExitError("The description property must be a string");
  }

  // check the config has the required commands and the commands property is an Object, like: {
  // init: {args: [{name: string}], flags: {flag1: {type: string, default: '', description: string, alias: string}}},
  //}
  if (!Object.prototype.hasOwnProperty.call(cliConfObj, "commands")) {
    throw new ExitError("Config must have a commands property");
  }
  if (typeof cliConfObj.commands !== "object") {
    throw new ExitError("The commands property must be an object");
  }
  // check if the commands object has the required keys
  Object.keys(cliConfObj.commands).forEach((commandName: string) => {
    const commandConf = cliConfObj!.commands[commandName];

    //  check the args property is an array of objects like: [{name: string}]
    if (!Object.prototype.hasOwnProperty.call(commandConf, "args")) {
      throw new ExitError(
        `The command must have an args property in commands.${commandName}`
      );
    }
    if (!Array.isArray(commandConf.args)) {
      throw new ExitError(
        `The command args property must be an array in commands.${commandName}`
      );
    }
    if (commandConf.args.length > 0) {
      commandConf.args.forEach((arg: { name: string }) => {
        if (!Object.prototype.hasOwnProperty.call(arg, "name")) {
          throw new ExitError(
            `The command arg must have a name property in commands.${commandName}`
          );
        }
        if (typeof arg.name !== "string") {
          throw new ExitError(
            `The command arg name property must be a string in commands.${commandName}`
          );
        }
      });
    }

    // check the flags property is an object of objects like: {flags: {type: string, default: '', description: string, alias: string}}
    if (!Object.prototype.hasOwnProperty.call(commandConf, "flags")) {
      throw new ExitError(
        `The command must have an flags property in commands.${commandName}`
      );
    }
    if (typeof commandConf.flags !== "object") {
      throw new ExitError(
        `The command flags property must be an object in commands.${commandName}`
      );
    }
    if (Object.keys(commandConf.flags).length > 0) {
      Object.keys(commandConf.flags).forEach((flagName: string) => {
        const flagConf = commandConf.flags[flagName];
        // check the type property is a string
        if (!Object.prototype.hasOwnProperty.call(flagConf, "type")) {
          throw new ExitError(
            `The command flag must have a type property in commands.${commandName}`
          );
        }
        const allowedTypes = ["string", "number", "boolean"];
        if (![...allowedTypes].includes(flagConf.type)) {
          throw new ExitError(
            `The command flag type property must be a string, number or boolean in commands.${commandName}.flags.${flagName}`
          );
        }
        // check the default property is a string, number or boolean
        if (!Object.prototype.hasOwnProperty.call(flagConf, "default")) {
          throw new ExitError(
            `The command flag must have a default property in commands.${commandName}.flags.${flagName}`
          );
        }
        if (![...allowedTypes].includes(typeof flagConf.default)) {
          throw new ExitError(
            `The command flag default property must be a string, number or boolean in commands.${commandName}.flags.${flagName}`
          );
        }
        // check the description property is a string
        if (!Object.prototype.hasOwnProperty.call(flagConf, "description")) {
          throw new ExitError(
            `The command flag must have a description property in commands.${commandName}.flags.${flagName}`
          );
        }
        if (typeof flagConf.description !== "string") {
          throw new ExitError(
            `The command flag description property must be a string in commands.${commandName}.flags.${flagName}`
          );
        }
        // check the alias property is a string
        if (!Object.prototype.hasOwnProperty.call(flagConf, "alias")) {
          throw new ExitError(
            `The command flag must have an alias property in commands.${commandName}.flags.${flagName}`
          );
        }
        if (typeof flagConf.alias !== "string") {
          throw new ExitError(
            `The command flag alias property must be a string in commands.${commandName}.flags.${flagName}`
          );
        }
      });
    }

    // check the commandConf has the docs property as string[]
    if (!Object.prototype.hasOwnProperty.call(commandConf, "docs")) {
      throw new ExitError(
        `The command must have a docs property in commands.${commandName}`
      );
    }
    if (!Array.isArray(commandConf.docs)) {
      throw new ExitError(
        `The command docs property must be an array in commands.${commandName}.docs`
      );
    }
    if (commandConf.docs.length == 0) {
      throw new ExitError(
        `The command docs property must not be empty in commands.${commandName}.docs`
      );
    }
    if (commandConf.docs.length > 0) {
      commandConf.docs.forEach((doc: string) => {
        if (typeof doc !== "string") {
          throw new ExitError(
            `The command docs property must be an array of strings in commands.${commandName}.docs`
          );
        }
      });
    }
  });

  return cliConfObj as CliConfType;
}

/**
 *
 * @param cliArgs input from the cli
 */
function checkConfFlag(cliArgs: string[]): void {
  let hasConfFlag = false;
  for (let i = 0; i < cliArgs.length; i++) {
    const arg = cliArgs[i];
    // ignore --config and -c flags
    if (arg === "--config" || arg === "-c") {
      // check the next arg is not a flag
      if (cliArgs.length === i + 1) {
        throw new ExitError(`The --config|-c flag must be set with a value`);
      } else {
        hasConfFlag = true;
      }
    }
  }

  if (!hasConfFlag) {
    throw new ExitError(`The --config|-c flag must be set`);
  }
}

const hasFlag = (arg: string, commandConf: CommandType): string => {
  if (arg.startsWith("--")) {
    const flag = arg.slice(2);
    checkFlagNotEempty(flag);
    // check the flag is a valid flag
    if (!Object.keys(commandConf.flags).includes(flag)) {
      throw new ExitError(`The flag ${flag} is not a valid flag`);
    }
    return flag;
  }
  return "";
};

const hasAliasFlag = (
  arg: string,
  commandConf: CommandType,
  command: string
): string => {
  let flagName = "";
  const aliasMapFlag: Map<string, string> = new Map();
  Object.keys(commandConf.flags).forEach((flagName) => {
    const { alias } = commandConf.flags[flagName];
    aliasMapFlag.set(alias, flagName);
  });
  if (arg.startsWith("-")) {
    const aliasFlag = arg.slice(1);
    checkFlagNotEempty(aliasFlag);
    // check the alias flag is a valid flag
    if (!aliasMapFlag.has(aliasFlag)) {
      throw new ExitError(
        `The flag ${aliasFlag} is not a valid flag in ${command}`
      );
    }
    flagName = aliasMapFlag.get(aliasFlag) as string;
  }
  return flagName;
};

/**
 * Remove the --config and -c flags from the cli args
 * @param inputCliArgs input from the cli
 * @returns {string[]}
 */
function removeConfFlag(inputCliArgs: string[]): string[] {
  const newCliArgs = [];
  let isRemove = false;
  for (let i = 0; i < inputCliArgs.length; i++) {
    const arg = inputCliArgs[i];
    // ignore --config and -c flags
    if ((arg === "--config" || arg === "-c") && !isRemove) {
      // remove index i from newCliArgs
      isRemove = true;
      i++;
      continue;
    }
    newCliArgs.push(inputCliArgs[i]);
  }

  return newCliArgs;
}

/**
 *  Check if the flag is not empty
 * @param flag
 */
const checkFlagNotEempty = (flag: string): void => {
  if (flag === "") {
    throw new ExitError(`The flag ${flag} is not valid`);
  }
};

function checkFlag(
  inputArgsIndex: number,
  inputFlag: string,
  inputCommandConf: CommandType,
  inputCliArgs: string[],
  inputCommandName: string
): void {
  // check flag config is not empty
  const isFlagInConf = Object.keys(inputCommandConf.flags).find(
    (flag) => flag === inputFlag
  );
  if (!isFlagInConf) {
    throw new ExitError(
      `The flag ${inputFlag} is not a valid flag in command: ${inputCommandName}}`
    );
  }

  const flagConf = inputCommandConf.flags[inputFlag];
  if (
    ["string", "number"].includes(flagConf.type) &&
    inputCliArgs.length === inputArgsIndex + 1
  ) {
    throw new ExitError(
      `The flag --${inputFlag} must have a value in command: ${inputCommandName}`
    );
  }
}

/**
 * Parse the flag value
 * @param flagConf
 * @param cliArgs
 * @param i
 * @returns
 */
function parseFlag(
  flagConf: FlagConfig,
  cliArgs: string[],
  i: number
): [FlagValueType, number] {
  if (["number", "string"].includes(flagConf.type)) {
    const value = cliArgs[i + 1];
    if (flagConf.type === "number") {
      return [Number(value), i + 1];
    }
    return [value, i + 1];
  } else {
    return [true, i];
  }
}

class ExitWithScriptFile extends Error {
  constructor(scriptFile: string) {
    const outputError: OutputDataType = {
      success: true,
      action: "command",
      output: "",
      command: {
        name: "run",
        args: [{ name: "script", value: scriptFile }],
        flags: {},
      },
    };
    console.log(JSON.stringify(outputError));
    std.exit(0);
    super(scriptFile);
  }
}

/**
 * check if the command is a valid command
 * @param command
 * @param cliConf
 */
function checkCommand(command: string, cliConf: CliConfType): void {
  if (!Object.keys(cliConf.commands).includes(command)) {
    // check the command is a file path.
    if (std.loadFile(command) !== null) {
      throw new ExitWithScriptFile(command);
    }

    throw new ExitError(`The command ${command} is not a valid command`);
  }
}

function helpDoc(cliConf: CliConfType): string {
  const cmdDocs: string[] = [];
  Object.keys(cliConf.commands).forEach((command) => {
    const cmdConf = cliConf.commands[command];
    cmdConf.docs.forEach((doc) => cmdDocs.push(doc));
  });

  const doc = `${cliConf.name} - ${cliConf.description}

USAGE:
${cmdDocs.join("\n")}

GLOBAL OPTIONS:
--help, -h     show help (default: false)
--version, -v  show version (default: false)

${cliConf.name}@${cliConf.version}`;

  return doc;
}

/**
 * @param inputCliArgs
 * @param cliConf
 * @returns
 */
function parseCli(
  inputCliArgs: string[],
  cliConf: CliConfType
): OutputDataType {
  // if the first arg is version, and then print the version number.
  if (isVersion(inputCliArgs)) {
    return {
      success: true,
      action: "version",
      output: `${cliConf.version}`,
    };
  }
  let isHelpe = false;
  if (isArgsIncludeHelpFlag(inputCliArgs)) {
    inputCliArgs = removeHelpFlag(inputCliArgs);
    isHelpe = true;
  }
  // check the first arg is a command, version, help or empty
  if (inputCliArgs.length === 0) {
    return {
      success: isHelpe ?? false,
      output: helpDoc(cliConf),
      action: "help",
    };
  }

  // parse the command from args
  const command = inputCliArgs[0];
  checkCommand(command, cliConf);
  const result: OutputDataType = {
    success: true,
    action: isHelpe ? "help" : "command",
    output: "",
    command: {
      name: command,
      flags: {},
      args: [],
    },
  };
  // set the default values for the flags
  const commandConf: CommandType = cliConf.commands[command];
  Object.keys(commandConf.flags).forEach((key) => {
    const flagConf = commandConf.flags[key];
    if (flagConf.required && flagConf.default !== "") {
      result.command!.flags[key] = flagConf.default;
    }
  });

  // parse the args and flags
  const cliArgs = inputCliArgs.slice(1);
  const argIndex: number = 0;
  for (let i = 0; i < cliArgs.length; i++) {
    const arg = cliArgs[i];
    // if the arg is --version -v
    if (arg === "--version" || arg === "-v") {
      result.action = "version";
      result.output = `${cliConf.name}@${cliConf.version}`;
      return result;
    }

    // check if the arg is a flag
    const flag =
      hasFlag(arg, commandConf) || hasAliasFlag(arg, commandConf, command);
    if (flag !== "") {
      checkFlag(i, flag, commandConf, cliArgs, command);
      const [value, newArgIndex]: [FlagValueType, number] = parseFlag(
        commandConf.flags[flag],
        cliArgs,
        i
      );
      result.command!.flags[flag] = value;
      i = newArgIndex;
    } else {
      if (commandConf.args[argIndex]) {
        const argConf = commandConf.args[argIndex];
        // check if the arg is a command
        result.command!.args.push({
          name: argConf.name,
          value: arg,
        });
      } else {
        throw new ExitError(`The argument ${arg} is not a valid argument`);
      }
    }
  }

  // check if the help doc was required and then print the help doc for the command
  if (isHelpe) {
    const doc = `${cmdHelpDoc(result, cliConf)}`;
    result.output = doc;
    result.action = "help";
    return result;
  }

  // check if the required arguments was missing. then print the error and help doc
  const requiredArgNames = commandConf.args
    .filter((a) => a.required)
    .map((arg) => arg.name);
  if (result.command!.args.length < requiredArgNames.length) {
    const missingArgs: string[] = [];
    const resultArgNames = result.command!.args.map((arg) => arg.name);
    requiredArgNames.forEach((argName) => {
      if (!resultArgNames.includes(argName)) {
        missingArgs.push(argName);
      }
    });
    let errorMsg: string = `The required arguments ${missingArgs
      .map((e) => `<${e}>`)
      .join(", ")} was missing in command ${command}.`;
    if (result.action === "command") {
      errorMsg += `\n\n${cmdHelpDoc(result, cliConf)}`;
    }

    throw new ExitError(errorMsg);
  }

  return result;
}

function isVersion(inputCliArgs: string[]): boolean {
  if (inputCliArgs.length === 0) {
    return false;
  }

  const firstArg = inputCliArgs[0];
  if (
    firstArg === "--version" ||
    (firstArg === "-v" && inputCliArgs.length === 1)
  ) {
    return true;
  }

  for (let i = 0; i < inputCliArgs.length; i++) {
    const arg = inputCliArgs[i];
    if (arg === "--version" || arg === "-v") {
      throw new ExitError(`The --version|-v flag must be set alone`);
    }
  }

  return false;
}
function isArgsIncludeHelpFlag(inputCliArgs: string[]): boolean {
  let isDetectHelpFlag = false;
  for (let i = 0; i < inputCliArgs.length; i++) {
    const arg = inputCliArgs[i];
    if (arg === "--help" || arg === "-h") {
      if (isDetectHelpFlag) {
        throw new ExitError(`The --help|-h flag must be set alone`);
      }
      isDetectHelpFlag = true;
    }
  }

  return isDetectHelpFlag;
}

/**
 * Remove the --help and -h flags from the cli args
 * @param inputCliArgs
 * @returns
 */
function removeHelpFlag(inputCliArgs: string[]): string[] {
  const newCliArgs = [];
  let isRemove = false;
  for (let i = 0; i < inputCliArgs.length; i++) {
    const arg = inputCliArgs[i];
    // ignore --help and -h flags
    if ((arg === "--help" || arg === "-h") && !isRemove) {
      // remove index i from newCliArgs
      isRemove = true;
      i++;
      continue;
    }
    newCliArgs.push(inputCliArgs[i]);
  }

  return newCliArgs;
}

/**
 * Print the command help doc
 * @param action
 * @param cliConf
 * @returns
 */
function cmdHelpDoc(action: OutputDataType, cliConf: CliConfType): string {
  const name = action.command!.name;
  const cmdConf = cliConf.commands[name];
  const argsDoc: string[] = [];
  cmdConf.args.forEach((arg) => {
    argsDoc.push(`<${arg.name}>`);
  });

  const flagDocs: string[] = [];
  Object.keys(cmdConf.flags).forEach((flagName) => {
    const flag = cmdConf.flags[flagName];
    const aliasDoc = flag.alias ? `-${flag.alias}, ` : "";
    flagDocs.push(`\t${aliasDoc}--${flagName}\t\t${flag.description}`);
  });

  let flagSectionDocs: string = "";
  if (flagDocs.length > 0) {
    flagSectionDocs = `\nFlags:
${flagDocs.join("\n")}
`;
  }

  let cmdDoc: string = `Usage: 
${cmdConf.docs.join("\n")}
`;
  if (flagDocs.length > 0) {
    cmdDoc = `${cmdDoc}${flagSectionDocs}`;
  }

  return cmdDoc;
}

const cliArgs: string[] = scriptArgs.slice(1);
checkConfFlag(cliArgs);
const cliConf = parseCliConf(cliArgs);
const cliData = parseCli(removeConfFlag(cliArgs), cliConf);
if (cliData.action === "help" && cliData.command !== undefined) {
  cliData.output = cmdHelpDoc(cliData, cliConf);
}

console.log(JSON.stringify(cliData));
if (!cliData.success) {
  std.exit(1);
}
