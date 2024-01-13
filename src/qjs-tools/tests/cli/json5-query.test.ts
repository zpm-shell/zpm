// ./bin/jq -j '{hello:"world"}' -q hello
import { execSync } from "child_process";

describe("jq cli test", () => {
  it("should execute the jq cli correctly", () => {
    const result = execSync(
      `./bin/jq -j '{"hello":"world"}' -q hello -t get`
    ).toString();
    expect(result).toBe("world\n");
  });
  it("should return the false value", () => {
    const result = execSync(
      `./bin/jq -j '{"hello": false}' -q hello -t get`
    ).toString();
    expect(result).toBe("false\n");
  });
});
