/**
 * describes the encoding algorithm of a resource.
 * An encoder is actually a binary-to-text converter. The result has to be readable as a string in a D source file.
 *  - safeness: only raw is unsafe: the strings can contain invalid UTF-8 chars.
 *  - padding: the encoder can add a few chars (up to 2 for base64, up to 7 for Z85), this explains the "approximate" qualification of the yield.
 *  - approximate yield: from best to worst, (input_bytes/output_chars ratio): raw (1/1), z85 (4/5), b64 (3/4), b16 (1/2).
 *  - e7F is a kind of percent-encoding so its yield varies from 1/1 (ascii strings) to 1/3 (binary data).
 *  - usage: raw and e7F should only be used for ASCII, ANSI or UTF-8 strings, other encoders can be used for everything.
 */
public enum ResEncoding {
    raw,    /// cast the raw data as an utf8 string.
    base16, /// encode as an hexadecimal representation.
    base64, /// encode as a base64 representation.
    z85,    /// encode as a z85 representation
    e7F,    /// encode as a e7F representation.
};