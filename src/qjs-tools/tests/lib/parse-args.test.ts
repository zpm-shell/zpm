import parseArgs, { ProgramArgsType } from "../../src/lib/parse-args";

describe("optionParser", () => {
  it("Shout ", () => {
    const argsConf: ProgramArgsType = {
      name: "zpm",
      description: "zpm is a package manager for zsh",
      version: "1.0.0",
      commands: {
        init: {
          description: "",
          args: [
            {
              name: "<repository/username/module-name>",
              description: "",
            },
          ],
          options: [],
        },
      },
    };

    const args = ["init", "hello"];

    const result = parseArgs(argsConf, args);

    expect(result.success).toBe(true);
    expect(result.result?.command).toBe("init");
    expect(result.result?.args[0]).toBe("hello");
    expect(result.result?.args.length).toEqual(1);
    expect(JSON.stringify(result.result?.options)).toBe("{}");
  });

  //   it("should return help text if --help option is provided", () => {
  //     const argsConf:  = {
  //       version: "1.0.0",
  //       commands: {
  //         test: {
  //           options: [
  //             {
  //               name: "--help",
  //               alias: "-h",
  //               type: "boolean",
  //               default: false,
  //             },
  //             {
  //               name: "--version",
  //               alias: "-v",
  //               type: "boolean",
  //               default: false,
  //             },
  //           ],
  //         },
  //       },
  //     };

  //     const args = ["init", "hello"];

  //     const result = parseArgs(argsConf, args);

  //     expect(result.success).toBe(true);
  //     expect(result.printTxt).toContain("Help text goes here");
  //   });

  //   it("should return version if --version option is provided", () => {
  //     const argsConf = {
  //       version: "1.0.0",
  //       commands: {
  //         test: {
  //           options: [
  //             {
  //               name: "--help",
  //               alias: "-h",
  //               type: "boolean",
  //               default: false,
  //             },
  //             {
  //               name: "--version",
  //               alias: "-v",
  //               type: "boolean",
  //               default: false,
  //             },
  //           ],
  //         },
  //       },
  //     };

  //     const args = ["--version"];

  //     const result = parseArgs(argsConf, args);

  //     expect(result.success).toBe(true);
  //     expect(result.printTxt).toBe("1.0.0");
  //   });

  //   it("should return unknown command error if command does not exist", () => {
  //     const argsConf = {
  //       version: "1.0.0",
  //       commands: {
  //         test: {
  //           options: [
  //             {
  //               name: "--help",
  //               alias: "-h",
  //               type: "boolean",
  //               default: false,
  //             },
  //             {
  //               name: "--version",
  //               alias: "-v",
  //               type: "boolean",
  //               default: false,
  //             },
  //           ],
  //         },
  //       },
  //     };

  //     const args = ["unknown-command"];

  //     const result = parseArgs(argsConf, args);

  //     expect(result.success).toBe(false);
  //     expect(result.printTxt).toContain('Unknown command: "unknown-command"');
  //     expect(result.printTxt).toContain(
  //       "To see a list of supported zpm commands, run:"
  //     );
  //     expect(result.printTxt).toContain("zpm --help");
  //   });

  //   it("should parse options and arguments correctly", () => {
  //     const argsConf = {
  //       version: "1.0.0",
  //       commands: {
  //         test: {
  //           options: [
  //             {
  //               name: "--help",
  //               alias: "-h",
  //               type: "boolean",
  //               default: false,
  //             },
  //             {
  //               name: "--version",
  //               alias: "-v",
  //               type: "boolean",
  //               default: false,
  //             },
  //             {
  //               name: "--name",
  //               alias: "-n",
  //               type: "string",
  //               default: "",
  //             },
  //           ],
  //         },
  //       },
  //     };

  //     const args = ["test", "--name", "John", "arg1", "arg2"];

  //     const result = parseArgs(argsConf, args);

  //     expect(result.success).toBe(true);
  //     expect(result.printTxt).toBe("");
  //     expect(result.result.value).toBe("test");
  //     expect(result.result.args).toEqual(["arg1", "arg2"]);
  //     expect(result.result.options).toEqual({
  //       "--help": false,
  //       "-h": false,
  //       "--version": false,
  //       "-v": false,
  //       "--name": "John",
  //       "-n": "John",
  //     });
  //   });
});
