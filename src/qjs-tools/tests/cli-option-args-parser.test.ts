import optionParser from "../src/cli-option-args-parser";

test("test cli-option-args-parser", () => {
  optionParser(
    [
      {
        name: "option1",
        description: "option1 description",
        alias: "o",
        required: true,
        default: "option1-default-value",
        type: "string",
      },
    ],
    "--option1"
  );
});
