// ./bin/json5-query -j '{hello:"world"}' -q hello
import { execSync } from "child_process";

describe("json5-query cli test", () => {
  it("should execute the json5-query cli correctly", () => {
    const result = execSync(
      `./bin/json5-query -j '{hello:"world"}' -q hello`
    ).toString();
    expect(result).toBe("world\n");
  });
});
