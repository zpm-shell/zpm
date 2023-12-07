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

type CliArgsParsedResultType = {
  command: {
    name: string;
    value: string;
    args: string[];
    options: Record<string, string>;
  };
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
): Promise<CliArgsParsedResultType> {
  const isHelp: boolean = false;
  return {};
}

export default program;
