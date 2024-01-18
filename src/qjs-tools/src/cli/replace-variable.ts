/**
 * replace a variable in a file, like a json file
 * {
 * "name": "${{NAME}}",
 * "version": "${{VERSION}}",
 * "description": "${{DESCRIPTION}}"
 * }
 * and then replace it with the value in scriptArgs, like: Name=xxx Version=xxx Description=xxx
 * and then to save the changes in the file.
 */

import * as std from "std";
import * as io from "../lib/io";

class CliError extends Error {
  constructor(msg: string) {
    super(msg);
  }
}

function getFilePathFromArgs(args: string[]): string {
  for (let index = 0; index < args.length; index++) {
    const arg = args[index];
    if (arg === "-f" || arg === "--file") {
      const nexIndex = index + 1;
      if (args.length <= nexIndex) {
        throw new CliError(`the value of flag -f was not provided`);
      }
      const nextArg = args[nexIndex];
      // check the nextArg was not flag.
      if (nextArg.startsWith("-") || nextArg.startsWith("--")) {
        throw new CliError(`the value of flag -f was not provided`);
      }
      const filePath = nextArg;
      return filePath;
    }
  }

  throw new CliError(`the flag -f was not provided`);
}

function removeFilePathFlag(args: string[]): string[] {
  for (let index = 0; index < args.length; index++) {
    const arg = args[index];
    if (["-f", "--file"].includes(arg)) {
      args.splice(index, 2);
      return args;
    }
  }

  return args;
}

function removeOutputFlag(args: string[]): string[] {
  for (let index = 0; index < args.length; index++) {
    const arg = args[index];
    if (["-o", "--output"].includes(arg)) {
      args.splice(index, 2);
      return args;
    }
  }

  return args;
}

function getNameMapVal(args: string[]): Map<string, string> {
  const result = new Map<string, string>();

  // check the args must be in the format of key=value.
  for (const arg of args) {
    const [key, value] = arg.split("=");
    if (!key || !value) {
      throw new CliError(`invalid argument: ${arg}`);
    }

    result.set(key, value);
  }

  return result;
}

function fileExists(filePath: string): void {
  if (std.loadFile(filePath) === null) {
    throw new CliError(`File not found: ${filePath}`);
  }
}
function replaceVariable(
  filePath: string,
  nameMapVal: Map<string, string>
): string {
  let fileData = std.loadFile(filePath, "utf-8")!.toString();
  // replace the value to fileData with the variable name in file.
  nameMapVal.forEach((value, key) => {
    fileData = fileData.replace(`\${{${key}}}`, value);
  });
  return fileData;
}

function checkHasPrintDocFlag(args: string[]): void {
  for (let index = 0; index < args.length; index++) {
    if (args[index] === "-h" || args[index] === "--help") {
      console.log(
        `Usage: 
    replace-variable NAME=<value> NAME2=<value> -f <file path>
Flags:
    --file,-f     the file path to replace the variable.  (Required)
    --output,-o   save the content transited to a file.   (Optional)
    --help,-h     print the help docs.                    (Optional)`
      );
      std.exit(0);
    }
  }
}

function hasOutputFlag(args: string[]): string {
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (["-o", "--output"].includes(arg)) {
      const nexIndex = i + 1;
      if (args.length <= nexIndex) {
        throw new CliError(`the value for flag --output|-o must be provided.`);
      }
      const nexArg = args[nexIndex];
      if (nexArg.startsWith("-") || nexArg.startsWith("--")) {
        throw new CliError(`The output file path must be provided.`);
      }
      return nexArg;
    }
  }
  return "";
}

let args = scriptArgs.slice(1);

checkHasPrintDocFlag(args);
const filePath = getFilePathFromArgs(args);
fileExists(filePath);
args = removeFilePathFlag(args);
const outputFile = hasOutputFlag(args);
args = removeOutputFlag(args);
const nameMapVal = getNameMapVal(args);
const result = replaceVariable(filePath, nameMapVal);
if (outputFile === "") {
  console.log(result);
} else {
  io.writeFile(outputFile, result);
}
