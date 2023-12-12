/**
 *
 *read file with a file name and return the content
 * @param filename
 * @returns string
 */
declare const readFile: (filename: string) => string;
/**
 *
 * @param fileName
 * @param content
 */
declare const writeFile: (fileName: string, content: string) => void;
export { readFile, writeFile };
