type OptionType = {
  name: string;
  alias: string;
  description: string;
  type: "boolean" | "string";
};

type ArgType = {
  name: string;
  description: string;
};

type CommandType = {
  name: string;
  required: boolean;
  description: string;
  args: ArgType[];
  options: OptionType[];
};

type ProgramArgsType = {
  name: string;
  version: string;
  description: string;
  commands: CommandType[];
};

type CliCommandParsedResultType = {
  value: string;
  args: string[];
  options: Record<string, string>;
};

/**
 *
 * @param argsConf args config
 * @param arg cli arg
 * @returns
 */
async function program(
  argsConf: ProgramArgsType,
  arg: string
): Promise<CliCommandParsedResultType> {
  // let isHelp: boolean = false;
  console.log(argsConf);
  console.log(arg);
  return {
    value: "",
    args: [],
    options: {},
  };
}

export default program;
