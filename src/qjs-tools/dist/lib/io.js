import * as std from "std";
function fileExists(filePath) {
    if (std.loadFile(filePath) === null) {
        throw Error(`File not found: ${filePath}`);
    }
}
/**
 *
 *read file with a file name and return the content
 * @param filename
 * @returns string
 */
const readFile = (filename) => {
    fileExists(filename);
    const file = std.open(filename, "r");
    if (file) {
        const contents = file.readAsString();
        file.close();
        return contents;
    }
    else {
        throw new Error(`Could not open file: ${filename}`);
    }
};
/**
 *
 * @param fileName
 * @param content
 */
const writeFile = (fileName, content) => {
    const file = std.open(fileName, "w+");
    if (file) {
        file.puts(content);
        file.close();
    }
    else {
        throw new Error(`Could not open file: ${fileName}`);
    }
};
export { readFile, writeFile };
//# sourceMappingURL=io.js.map