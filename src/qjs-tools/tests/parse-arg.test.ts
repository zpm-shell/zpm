import parseArgs, { ProgramArgsType } from "../src/parse-args";

test("test program-arg ", () => {
  const argsConfig: ProgramArgsType = {
    name: "test-cli",
    version: "0.0.1",
    description: "test description",
    commands: [
      {
        name: "run",
        description: "run the command",
        args: [
          {
            name: "arg1",
            description: "arg1 description",
          },
          {
            name: "arg2",
            description: "arg2 description",
          },
          {
            name: "arg3",
            description: "arg2 description",
          },
        ],
        options: [
          {
            name: "option1",
            description: "option1 description",
            default: "option1-default-value",
            alias: "o",
            type: "string",
          },
          {
            name: "option2",
            description: "option1 description",
            default: true,
            alias: "p",
            type: "boolean",
          },
          {
            name: "option3",
            description: "option1 description",
            default: true,
            type: "boolean",
          },
        ],
      },
    ],
  };
  parseArgs(argsConfig, "run arg1 arg2 arg3 -o option1 -p --option3 -h")
    .then((res) => {
      console.log(res);
    })
    .catch((err) => {
      console.log(err);
    });
  // expect(3).toBe(3);
});
