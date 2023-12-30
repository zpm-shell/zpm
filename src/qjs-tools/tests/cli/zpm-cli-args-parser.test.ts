import { execSync } from "child_process";

describe("zpm-cli-args-parser tests", () => {
  it("should print the json5 incle the helpe document after execute the cli", () => {
    let json5: string = execSync("./bin/zpm-cli-args-parser").toString();
    json5 = json5.trim();
    const expectedVal =
      "{success:false,printTxt:" +
      "'Usage: zpm [command] [options]\\n\\nVersion: 0.0.1\\nzpm is a package manager for zsh\\nCommands:\\n  zpm init\\t\\tcreate a zpm-package.json5 file\\n\\nGlobal options:\\n  -h, --help\\t\\tShow this help message and exit\\n  -v, --version\\t\\tShow version information and exit\\n" +
      "'}";
    expect(json5).toBe(expectedVal);
  });

  it("should print the documents in JSON5", () => {
    let json5: string = execSync("./bin/zpm-cli-args-parser --help").toString();
    json5 = json5.trim();
    const expectedVal =
      "{success:true,printTxt:" +
      "'Usage: zpm [command] [options]\\n\\nVersion: 0.0.1\\nzpm is a package manager for zsh\\nCommands:\\n  zpm init\\t\\tcreate a zpm-package.json5 file\\n\\nGlobal options:\\n  -h, --help\\t\\tShow this help message and exit\\n  -v, --version\\t\\tShow version information and exit\\n" +
      "'}";
    expect(json5).toBe(expectedVal);

    json5 = execSync("./bin/zpm-cli-args-parser -h").toString();
    json5 = json5.trim();
    expect(json5).toBe(expectedVal);
  });

  it("should print the JSON5 inclded a version", () => {
    let json5: string = execSync(
      "./bin/zpm-cli-args-parser --version"
    ).toString();
    json5 = json5.trim();
    const expectedVal = "{success:true,printTxt:'0.0.1'}";
    expect(json5).toBe(expectedVal);

    json5 = execSync("./bin/zpm-cli-args-parser -v").toString();
    json5 = json5.trim();
    expect(json5).toBe(expectedVal);
  });
});
