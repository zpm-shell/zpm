function getChars() {
  return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
}

function decodeBase64(base64String) {
  const chars = getChars();
  let output = "";
  base64String = base64String.replace(/=+$/, ""); // Remove any '=' padding

  for (
    let bc = 0, bs, buffer, i = 0;
    (buffer = base64String.charAt(i++));
    ~buffer && ((bs = bc % 4 ? bs * 64 + buffer : buffer), bc++ % 4)
      ? (output += String.fromCharCode(255 & (bs >> ((-2 * bc) & 6))))
      : 0
  ) {
    buffer = chars.indexOf(buffer);
  }

  return output;
}

function encodeBase64(str) {
  const chars = getChars();
  let output = "";
  let binStr = "";

  for (let i = 0; i < str.length; i++) {
    binStr += str.charCodeAt(i).toString(2).padStart(8, "0");
  }

  for (let i = 0; i < binStr.length; i += 6) {
    const chunk = binStr.substring(i, i + 6).padEnd(6, "0");
    output += chars[parseInt(chunk, 2)];
  }

  while (output.length % 4) {
    output += "=";
  }

  return output;
}

export { decodeBase64, encodeBase64 };
