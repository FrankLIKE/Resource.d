module project.resources;

static const resource_txt = [
	"ຂອ້ຍກິນແກ້ວໄດ້ໂດຍທີ່ມັນບໍ່ໄດ້ເຮັດໃຫ້ຂອ້ຍເຈັບ",
	"म काँच खान सक्छू र मलाई केहि नी हुन्‍न्",
	"313233343536383720393837343132353820393637383933323534373531",
	"41656E65616E206D61757269732076656C69742C20696163756C697320757420656E696D2065742C20696D706572646965742072686F6E63757320697073756D2E20416C697175616D206567657420646F6C6F722076656C206F72636920706C616365726174206672696E67696C6C6120696E206575206C6F72656D2E204372617320617420636F6D6D6F646F2066656C69732E20437261732076656C6974207475727069732C20666175636962757320717569732068656E647265726974206E6F6E2C20657569736D6F64207669746165206C616375732E204372617320706F72747469746F722074656D70757320766573746962756C756D2E204D6F726269206D6174746973206E657175652071756973206C65637475732070656C6C656E7465737175652C206163207665686963756C61206C656374757320616363756D73616E2E20517569737175652074656D706F72206D61676E612076656C20616363756D73616E206C6163696E69612E20457469616D206163206C656F206F64696F2E204E616D20736564206D617373612065752073617069656E2076756C70757461746520666575676961742065752065676574206469616D2E20566573746962756C756D2069642065737420696420656C6974207661726975732066696E696275732061742061742070757275732E2041656E65616E206F726E6172652066656C69732065676574206C696265726F20657569736D6F642C20696E2066657567696174206C6F72656D206C6163696E69612E2050686173656C6C7573206566666963697475722061742066656C697320717569732074696E636964756E742E",
	"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAJhJREFUeNpi/P//PwMlgAVE3Lt37wCQsidR70ElJSUHsAFAV9iTYbk93AX//v2jzAt///6FC9TV1YHppqYmFIW4xDEM+PPnDwO6GD5xDC/AFKJ7C5c4IygaL1y4QFZcGhgYMLIgm06VQCTLAGR/FRcX49XQ29tLXCzgAlhjAVmwu7ubdAMoTolAA0CZyYFEvQfg6YASABBgAESXY0hyXW4UAAAAAElFTkSuQmCC",
	"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAPJJREFUeNqkk00OREAQhV9PbOzsCeEEDkC4h6NILJzEUUxYWXEBImFvZ+NndCc6hpgJKmmdfKpKv1eazPOMJyHQR1mW8bI5F2vfhmG4rMFyCufGxx1+gmmankkYx5GDIAjYHobhV+IZPzQYhgF79osfJKyJe1lnnNAx5nl+a5amaRJh2/1OvFZddGVZBt/3URQFZ+uijL6jOSs7eCCKIvq+RxRF0DQNiqIw3jQN6roGIYTlbH1gHqRpyj2oqgpJkqBtW3Rdx5gkSZBlGbZtQ9d1XmxZFjmMUVVVeJ53qvnvGG/9iUsDepnci7Ux9+BJfAQYAA4ymWUAhzHmAAAAAElFTkSuQmCC",
	"Q?Ot^{tpZw/HyUEpI0n8!v9<hV#7N>ycZp8ytdf{!mvo>HnqH@o51P6T.QF6/sCIEmpY$7Q{-)jX2*O]Q0>F:ysDDNQTVT^TXkKJoj:{NwO72j!Ly6Ln[yE$m8&//-)!KooAk4)0@@r3",
	"C3A9C3A8%C2A7 C3A0 C2A3 C3A7C3A7 E282AC E282AC C3B9"
];

static const resource_idt = [
	"res_utf8_1",
	"res_utf8_2",
	"res_ansi_1",
	"res_ansi_2",
	"res_img1",
	"res_img2",
	"res_rnd1",
	"res_utf8_3"
];

static const resource_mdt = [
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	""
];

static const resource_enc = [
	ResEncoding.raw,
	ResEncoding.raw,
	ResEncoding.base16,
	ResEncoding.base16,
	ResEncoding.base64,
	ResEncoding.base64,
	ResEncoding.z85,
	ResEncoding.e7F 
];

static const uint[] resource_sumi = [
	2472579997,
	2342516385,
	832533648,
	1951281988,
	3830768605,
	3119248986,
	9092863,
	419127154
];

static const uint[] resource_sume = [
	2472579997,
	2342516385,
	471418432,
	2518604207,
	2005268032,
	4283104252,
	1307549914,
	516939061
];

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

/// returns the resource count.
public size_t resourceCount(){
    return resource_idt.length;
}

/// returns the index of the resource associated to resIdent.
public ptrdiff_t resourceIndex(string resIdent){
    import std.algorithm;
    return countUntil(resource_idt, resIdent);
}

/// returns the identifier of the resIndex-th resource.
public string resourceIdent(size_t resIndex){
    return resource_idt[resIndex];
}

/// returns the metadata of the resIndex-th resource.
public string resourceMeta(size_t resIndex){
    return resource_mdt[resIndex];
}

/// returns the signature of the decoded resource form.
public uint resourceInitCRC(size_t resIndex){
    return resource_sumi[resIndex];
}

/// returns the signature of the encoded resource form.
public uint resourceFinalCRC(size_t resIndex){
    return resource_sume[resIndex];
}

/// returns true if the encoded form of a resource is corrupted.
public bool isResourceEncCorrupted(size_t resIndex){
    import std.digest.crc;
    CRC32 hash;
    hash.put(cast(ubyte[])resource_txt[resIndex]);
    auto summarr = hash.finish;
    //
    uint sum;
    ubyte* ptr = cast(ubyte*) &sum;
    version(BigEndian)
        foreach(i; 0..4) * (ptr + i) = summarr[i];
    else
        foreach(i; 0..4) * (ptr + i) = summarr[3-i];
    return sum != resource_sume[resIndex];
}

/// returns true if the decoded form of a resource is corrupted.
public bool isResourceDecCorrupted(size_t resIndex){
    ubyte[] dec;
    bool result;
    result = decode(resIndex, dec);
    if (!result) return false;
    //
    import std.digest.crc;
    CRC32 hash;
    hash.put(dec);
    auto summarr = hash.finish;
    uint sum;
    ubyte* ptr = cast(ubyte*) &sum;
    version(BigEndian)
        foreach(i; 0..4) * (ptr + i) = summarr[i];
    else
        foreach(i; 0..4) * (ptr + i) = summarr[3-i]; 
    //
    return (sum == resource_sumi[resIndex]);    
}

/// returns the encoder kind of the resIndex-th resource.
public ResEncoding resourceEncoding(size_t resIndex){
    import std.conv;
    return to!ResEncoding(resource_enc[resIndex]);
}

/// decodes the resIndex-th resource in dest.
public bool decode(size_t resIndex, ref ubyte[] dest){
    scope(failure) return false;
    final switch(resourceEncoding(resIndex)){
        case ResEncoding.raw    : decoderaw(resIndex, dest); break;
        case ResEncoding.base16 : decodeb16(resIndex, dest); break;
        case ResEncoding.base64 : decodeb64(resIndex, dest); break;
        case ResEncoding.z85    : decodez85(resIndex, dest); break;
        case ResEncoding.e7F    : decodee7F(resIndex, dest); break;
    }
    return true;
}

private void decoderaw(size_t resIndex, ref ubyte[] dest){
    dest = cast(ubyte[])resource_txt[resIndex];
}

private void decodeb16(size_t resIndex, ref ubyte[] dest){
    import std.conv;
    dest.length = resource_txt[resIndex].length / 2;
    foreach(i; 0 .. dest.length){
        dest[i] = to!ubyte(resource_txt[resIndex][i * 2 .. i * 2 + 2], 16);
    }
}

private void decodeb64(size_t resIndex, ref ubyte[] dest){
    import std.base64;
    dest = Base64.decode(resource_txt[resIndex]);
}

///  Maps base 85 to base 256
private static immutable ubyte[96] z85_decoder = [
    0x00, 0x44, 0x00, 0x54, 0x53, 0x52, 0x48, 0x00,
    0x4B, 0x4C, 0x46, 0x41, 0x00, 0x3F, 0x3E, 0x45,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x40, 0x00, 0x49, 0x42, 0x4A, 0x47,
    0x51, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A,
    0x2B, 0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32,
    0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A,
    0x3B, 0x3C, 0x3D, 0x4D, 0x00, 0x4E, 0x43, 0x00,
    0x00, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10,
    0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
    0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20,
    0x21, 0x22, 0x23, 0x4F, 0x00, 0x50, 0x00, 0x00
];

/**
 * Decodes a z85 string as a byte array.
 *
 * Modified version of the reference implementation of Z85_decode.
 * It automatically handles the tail added to grant the 4/5 i/o ratio,
 * as described in Z85_endcode()
 */
private ubyte[] Z85_decode(in char[] input)
in
{
    assert(input.length % 5 == 0);
}
body
{
    // reference implementation
    size_t decoded_size = input.length * 4 / 5;
    ubyte[] decoded;
    decoded.length = decoded_size;
    uint byte_nbr;
    uint char_nbr;
    uint value;
    while (char_nbr < input.length)
    {
        value = value * 85 + z85_decoder [cast(ubyte) input[char_nbr++] - 32];
        if (char_nbr % 5 == 0)
        {
            uint divisor = 256 * 256 * 256;
            while (divisor)
            {
                decoded[byte_nbr++] = value / divisor % 256;
                divisor /= 256;
            }
            value = 0;
        }
    }
    assert (byte_nbr == decoded_size);

    // removes the tail things.
    ubyte added = decoded[$-4];
    decoded = decoded[0..$- (4 + added)];

    return decoded;
}

private void decodez85(size_t resIndex, ref ubyte[] dest){
    dest = Z85_decode(resource_txt[resIndex]);
}

/**
 * "7F" text-to-binary decoder.
 */
private ubyte[] decode_7F(in char[] input)
{
    ubyte[] result;
    size_t i;
    while(i < input.length)
    {
        char c = input[i];
        if (c == 0x7F)
        {    
            char[2] digits = input[i+1 .. i+3];
            import std.conv;
            result ~= to!ubyte(digits[], 16);    
            i += 2;
        } 
        else result ~= c;
        ++i;
    }    
    return result;
}

private void decodee7F(size_t resIndex, ref ubyte[] dest){
    dest = decode_7F(resource_txt[resIndex]);
}
