type CommandType = {
    name: string;
    description: string;
    args: {
        name: string;
        type: "string" | "boolean";
        description: string;
    }[];
    options: {
        name: string;
        alias: string;
        required: boolean;
        type: "string" | "boolean";
        description: string;
    }[];
};
type OutputType = {
    regularArgs: string[];
    options: Record<string, boolean | string>;
};
declare enum ErrorType {
    PRINT_HELP = "print help",
    INCORRECT_ARGUMENT_COUNT = "incorrect argument count",
    INCORRECT_OPTION_COUNT = "incorrect option count"
}
declare function parseArgs(commandConfigs: CommandType, args: string[]): Promise<OutputType>;
export { ErrorType };
export default parseArgs;
//# sourceMappingURL=index.d.ts.map