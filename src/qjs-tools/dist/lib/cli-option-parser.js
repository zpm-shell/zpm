"use strict";
const optionParser = (optionConfig, args) => {
    const aliasNameMapOptionName = {};
    Object.keys(optionConfig).forEach((optionName) => {
        const aliasName = optionConfig[optionName];
        aliasNameMapOptionName[aliasName] = optionName;
    });
    const result = {};
    let isContinue = false;
    args.forEach((arg, index) => {
        if (isContinue) {
            isContinue = false;
            return;
        }
        if (arg.startsWith("-")) {
            let optionName;
            if (arg.startsWith("--")) {
                optionName = arg.slice(2);
            }
            else if (arg.startsWith("-")) {
                const alisName = arg.slice(1);
                optionName = aliasNameMapConfig[alisName];
            }
        }
    });
};
//# sourceMappingURL=cli-option-parser.js.map