import optionParser, { OptionType } from "../src/lib/cli-option-parser";

describe("optionParser", () => {
  it("should parse boolean options correctly", () => {
    const optionConfig: OptionType = {
      verbose: { alias: "v", type: "boolean", description: "Verbose output" },
      debug: { alias: "d", type: "boolean", description: "" },
    };
    const args = ["--verbose", "-d"];

    const result = optionParser(optionConfig, args);

    expect(result).toEqual({ verbose: true, debug: true });
  });

  it("should parse string options correctly", () => {
    const optionConfig: OptionType = {
      name: { alias: "n", type: "string", description: "" },
      age: { alias: "a", type: "string", description: "" },
    };
    const args = ["--name", "John", "-a", "25"];

    const result = optionParser(optionConfig, args);

    expect(result).toEqual({ name: "John", age: "25" });
  });

  it("should throw an error for unknown options", () => {
    const optionConfig: OptionType = {
      verbose: { alias: "v", type: "boolean", description: "" },
    };
    const args = ["--unknown"];

    expect(() => optionParser(optionConfig, args)).toThrowError(
      "Unknown option: --unknown"
    );
  });

  it("should throw an error for missing values", () => {
    const optionConfig: OptionType = {
      name: { alias: "n", type: "string", description: "" },
    };
    const args = ["--name"];

    expect(() => optionParser(optionConfig, args)).toThrowError(
      "Missing value: --name"
    );
  });

  it("should throw an error if no options provided", () => {
    const optionConfig: OptionType = {
      verbose: { alias: "v", type: "boolean", description: "" },
    };
    const args: string[] = [];

    expect(() => optionParser(optionConfig, args)).toThrowError(
      "No options provided"
    );
  });
});
