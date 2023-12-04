var ErrorType;
(function (ErrorType) {
  ErrorType["PRINT_HELP"] = "print help";
  // the count of the arguments is not correct.
  ErrorType["INCORRECT_ARGUMENT_COUNT"] = "incorrect argument count";
  // the count of the options is not correct.
  ErrorType["INCORRECT_OPTION_COUNT"] = "incorrect option count";
})(ErrorType || (ErrorType = {}));
function printHelp(command) {
  let argsStr = "";
  command.args.forEach((arg) => {
    argsStr += ` <${arg.name}>`;
  });
  if (command.options.length > 0) {
    argsStr += " [options]";
  }
  console.log(`Usage: ${command.name} ${argsStr}`);
  console.log("Options:");
  command.options.forEach((option) => {
    console.log(`  --${option.name}, -${option.alias}\t${option.description}`);
  });
  console.log("");
  console.log(`${command.description}`);
}
async function parseArguments(command, args) {
  const options = {};
  const regularArgs = [];
  let currentOption = "";
  // if the args include the --help option, print the help message and exit.
  if (args.includes("--help")) {
    printHelp(command);
    throw new Error(ErrorType.PRINT_HELP);
  }
  // Mapping of the alias name to the long name in the command options list
  const aliasMap = {};
  for (let optionIndex = 0; optionIndex < command.options.length; optionIndex++) {
    const optionName = command.options[optionIndex].name;
    const alias = command.options[optionIndex].alias;
    aliasMap[alias] = optionName;
  }
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg.startsWith("--")) {
      currentOption = arg.substring(2);
      options[currentOption] = true; // Set a default value
    }
    else if (arg.startsWith("-")) {
      const aliasName = arg.substring(1);
      currentOption = aliasMap[aliasName];
      options[currentOption] = true; // Set a default value
    }
    else {
      if (currentOption.length !== 0) {
        // Assign the value to the last option
        options[currentOption] = arg;
        currentOption = "";
      }
      else {
        // Regular argument
        regularArgs.push(arg);
      }
    }
  }
  // check the total number of arguments
  if (regularArgs.length !== command.args.length) {
    throw new Error(ErrorType.INCORRECT_ARGUMENT_COUNT);
  }
  // check the required options was existed or not
  command.options
    .filter((e) => e.required)
    .forEach((el) => {
      // eslint-disable-next-line no-prototype-builtins
      if (!options.hasOwnProperty(el.name)) {
        throw new Error(ErrorType.INCORRECT_OPTION_COUNT);
      }
    });
  return { regularArgs, options };
}
function parseArgs(commandConfigs, args) {
  return new Promise((resolve, reject) => {
    parseArguments(commandConfigs, args)
      .then((result) => resolve(result))
      .catch((err) => {
        if (err.message != ErrorType.PRINT_HELP) {
          console.log(`${commandConfigs.name}: try '${commandConfigs.name} --help' for more information`);
        }
        return reject(err);
      });
  });
}
// const args = [
//   "command1",
//   "arg1",
//   "arg2",
//   "--option1",
//   "option1 value",
//   "--option2",
//   "option2 value",
//   "-a",
//   "option3 value",
//   "-c",
//   "option4 value",
// ];
// const commandConfigs: CommandType = {
//   name: "qjs.decodeBase64",
//   description: "qjs.decodeBase64 <arg1: base64 encode string> [options]",
//   args: [
//     {
//       name: "arg1",
//       type: "string",
//       description: "Argument 1 description",
//     },
//     {
//       name: "arg2",
//       type: "string",
//       description: "Argument 2 description",
//     },
//   ],
//   options: [
//     {
//       type: "string",
//       name: "option1",
//       alias: "o1",
//       description: "option 1",
//     },
//     {
//       type: "string",
//       name: "option2",
//       alias: "o2",
//       description: "option 1",
//     },
//     {
//       type: "string",
//       name: "option3",
//       alias: "a",
//       description: "option 1",
//     },
//     {
//       type: "string",
//       name: "option4",
//       alias: "c",
//       description: "option 1",
//     },
//   ],
// };
export { ErrorType };
export default parseArgs;
//# sourceMappingURL=index.js.map