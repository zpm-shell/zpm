import parseArgs, { ProgramArgsType } from "../../src/lib/parse-args";

describe("Test to parse args", () => {
  it("should parse the cmd init with args", () => {
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

  it("should return help text if --help option is provided", () => {
    const argsConf: ProgramArgsType = {
      version: "0.0.1",
      description: "zpm is a package manager for zsh",
      name: "zpm",
      commands: {
        init: {
          description: "create a zpm.json5 file",
          args: [],
          options: [],
        },
      },
    };

    let result = parseArgs(argsConf, ["--help"]);

    expect(result.success).toBe(true);
    const expected =
      "Usage: zpm [command] [options]\n\nVersion: 0.0.1\nzpm is a package manager for zsh\nCommands:\n  zpm init\t\tcreate a zpm.json5 file\n\nGlobal options:\n  -h, --help\t\tShow this help message and exit\n  -v, --version\t\tShow version information and exit\n";

    expect(result.printTxt).toBe(expected);

    result = parseArgs(argsConf, ["-h"]);
    expect(result.printTxt).toBe(expected);
  });

  it("should return version if --version option is provided", () => {
    const argsConf: ProgramArgsType = {
      name: "zpm",
      version: "1.0.0",
      description: "zpm is a package manager for zsh",
      commands: {},
    };

    let result = parseArgs(argsConf, ["--version"]);
    expect(result.success).toBe(true);
    expect(result.printTxt).toBe("1.0.0");

    result = parseArgs(argsConf, ["-v"]);
    expect(result.success).toBe(true);
    expect(result.printTxt).toBe("1.0.0");
  });

  it("should return unknown command error if command does not exist", () => {
    const argsConf: ProgramArgsType = {
      version: "1.0.0",
      name: "zpm",
      description: "zpm is a package manager for zsh",
      commands: {
        test: {
          description: "",
          options: [],
          args: [],
        },
      },
    };

    const args = ["unknown-command"];

    const result = parseArgs(argsConf, args);

    expect(result.success).toBe(false);
    expect(result.printTxt).toContain('Unknown command: "unknown-command"');
    expect(result.printTxt).toContain(
      "To see a list of supported zpm commands, run:"
    );
    expect(result.printTxt).toContain("zpm --help");
  });

  it("should parse options and arguments correctly", () => {
    const argsConf: ProgramArgsType = {
      version: "1.0.0",
      name: "zpm",
      description: "zpm is a package manager for zsh",
      commands: {
        test: {
          description: "",
          options: [
            {
              name: "name",
              alias: "n",
              type: "string",
              default: "",
              description: "",
            },
          ],
          args: [],
        },
      },
    };

    const args = ["test", "--name", "John", "arg1", "arg2"];

    const result = parseArgs(argsConf, args);

    expect(result.success).toBe(true);
    expect(result.printTxt).toBe("");
    expect(result.result?.command).toBe("test");
    expect(result.result?.args).toEqual(["arg1", "arg2"]);
    expect(result.result?.options).toEqual({
      name: "John",
    });
  });
});
