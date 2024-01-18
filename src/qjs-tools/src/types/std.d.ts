// std.d.ts
declare module "std" {
  function loadFile(filePath: string, mod?: string): Uint8Array | null;
  function open(filename: string, flags: string): File | undefined;

  interface File {
    puts(content: string): unknown;
    readAsString(): string;
    close(): void;
  }

  function exit(code: number): void;

  // ... Declare other functions, classes, and types as needed
}
