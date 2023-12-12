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
type OptionType = StringTypeOption | BooleanTypeOption;
type ArgType = {
    name: string;
    description: string;
};
type CommandType = {
    name: string;
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
    isPrint: false;
    result: {
        value: string;
        args: string[];
        options: Record<string, string | boolean>;
    };
} | {
    isPrint: true;
};
/**
 *
 * @param argsConf args config
 * @param arg cli arg
 * @returns
 */
declare function parseArgs(argsConf: ProgramArgsType, arg: string): Promise<CliCommandParsedResultType>;
export type { ProgramArgsType, CliCommandParsedResultType, CommandType, ArgType, OptionType, };
export default parseArgs;
