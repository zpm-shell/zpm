module.exports = {
  globals: {
    scriptArgs: "readonly",
  },
  env: {
    browser: true,
    es2020: true,
  },
  parser: "@typescript-eslint/parser",
  plugins: ["@typescript-eslint"],
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended", // Use recommended rules from @typescript-eslint/eslint-plugin
  ],
  overrides: [
    {
      env: {
        node: true,
      },
      files: [".eslintrc.{js,cjs}"],
      parserOptions: {
        sourceType: "script",
      },
    },
  ],
  parserOptions: {
    ecmaVersion: "latest",
    sourceType: "module",
  },
  rules: {
    "@typescript-eslint/explicit-function-return-type": "error", // or "error" if you want it to fail the linting process
  },
};
