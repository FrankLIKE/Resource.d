module project.resources;

static const resource_txt = [
	"313233343536383720393837343132353820393637383933323534373531",
	"41656E65616E206D61757269732076656C69742C20696163756C697320757420656E696D2065742C20696D706572646965742072686F6E63757320697073756D2E20416C697175616D206567657420646F6C6F722076656C206F72636920706C616365726174206672696E67696C6C6120696E206575206C6F72656D2E204372617320617420636F6D6D6F646F2066656C69732E20437261732076656C6974207475727069732C20666175636962757320717569732068656E647265726974206E6F6E2C20657569736D6F64207669746165206C616375732E204372617320706F72747469746F722074656D70757320766573746962756C756D2E204D6F726269206D6174746973206E657175652071756973206C65637475732070656C6C656E7465737175652C206163207665686963756C61206C656374757320616363756D73616E2E20517569737175652074656D706F72206D61676E612076656C20616363756D73616E206C6163696E69612E20457469616D206163206C656F206F64696F2E204E616D20736564206D617373612065752073617069656E2076756C70757461746520666575676961742065752065676574206469616D2E20566573746962756C756D2069642065737420696420656C6974207661726975732066696E696275732061742061742070757275732E2041656E65616E206F726E6172652066656C69732065676574206C696265726F20657569736D6F642C20696E2066657567696174206C6F72656D206C6163696E69612E2050686173656C6C7573206566666963697475722061742066656C697320717569732074696E636964756E742E",
	"89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000001974455874536F6674776172650041646F626520496D616765526561647971C9653C000000984944415478DA62FCFFFF3F0325800544DCBB77EF0090B22751EF4125252507B0014057D89361B93DDC05FFFEFDA3CC0B7FFFFE850BD4D5D581E9A6A6261485B8C4310CF8F3E70F03BA183E710C2FC014A27B0B973823281A2F5CB840565C1A181830B2209B4E954024CB00647F151717E3D5D0DBDB4B5C2CE00258630159B0BBBB9B7403284E8940034099C98144BD07E0E980120010600044976348725D6E140000000049454E44AE426082",
	"89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000001974455874536F6674776172650041646F626520496D616765526561647971C9653C000000F24944415478DAA4934D0E444010855F4F6CECEC09E1040E40B887A3482C9CC4514C5859710122616F67E36774273A8698092A699D7CAA4ABF579ACCF38C2721D0475996F1B239176BDF8661B8ACC1720AE7C6C71D7E82699A9E4918C791832008D81E86E157E2193F341886017BF68B1F24AC897B59679CD031E6797E6B96A6691261DBFD4EBC565D74655906DFF751140567EBA28CBEA3392B3B78208A22FABE471445D0340D8AA230DE340DEABA062184E56C7D601EA469CA3DA8AA0A4992A06D5B745DC7982449906519B66D43D7755E6C5916398C515555789E77AAF9EF186FFD894B037A99DC8BB531F7E0497C0418000E329965008731E60000000049454E44AE426082",
	"89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000001974455874536F6674776172650041646F626520496D616765526561647971C9653C000000E84944415478DAAC53390A844010AC011F606CA2088289E00384D97798F911033F62E8371CF0018A89911888B10FF0586740F158173C3A9886A28FAAEE1E328E239E98C49FB22CE3C9D18BB94CD7F58F2830B1A0379AD385C1300CCF24F47DBF00BEEF0B1F04C126F00C3F14E8BA0E7BEC1F7E903007EE659DE184AF314DD35BBBB46D9B48EBEAAF0CB1AA2A244982A669D0B6ADC0645986A228701C079AA69DCFA0280A8461C8EF02AAAAC2300C81D775CD6522CB32789E07D3347F33983BBAAE0BCBB2369DF23C4714452266CD580C9131766B889452F2CE254E05F867FA5CCC8D17094FEC2BC000E86B85BA4D90B09F0000000049454E44AE426082",
	"A469D4B5F6DF896AD84687D64F654DB0D4B6D406B46D874B6A40D4886ADAD48AD464DA8B86A4BD684ADB7867AD6B48A4D7BA64DB4564654DA4B64A6DB7AD1B23A1D32A4B6AD45B41A3D4B416AD4BA68D4B65A4DB6565E6B6D54F6E464A65465D44C665D4C6D4646D4C",
	"E0BA82E0BAADE0BB89E0BA8DE0BA81E0BAB4E0BA99E0BB81E0BA81E0BB89E0BAA7E0BB84E0BA94E0BB89E0BB82E0BA94E0BA8DE0BA97E0BAB5E0BB88E0BAA1E0BAB1E0BA99E0BA9AE0BB8DE0BB88E0BB84E0BA94E0BB89E0BB80E0BAAEE0BAB1E0BA94E0BB83E0BAABE0BB89E0BA82E0BAADE0BB89E0BA8DE0BB80E0BA88E0BAB1E0BA9A",
	"E0A4AE20E0A495E0A4BEE0A481E0A49A20E0A496E0A4BEE0A4A820E0A4B8E0A495E0A58DE0A49BE0A58220E0A4B020E0A4AEE0A4B2E0A4BEE0A48820E0A495E0A587E0A4B9E0A4BF20E0A4A8E0A58020E0A4B9E0A581E0A4A8E0A58DE2808DE0A4A8E0A58D",
	"C3A9C3A825C2A720C3A020C2A320C3A7C3A720E282AC20E282AC20C3B9"
];

static const resource_idt = [
	"res_ansi_1",
	"res_ansi_2",
	"res_img1",
	"res_img2",
	"res_img3",
	"res_rnd1",
	"res_utf8_1",
	"res_utf8_2",
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
	"",
	""
];

static const resource_enc = [
	ResEncoding.base16,
	ResEncoding.base16,
	ResEncoding.base16,
	ResEncoding.base16,
	ResEncoding.base16,
	ResEncoding.base16,
	ResEncoding.base16,
	ResEncoding.base16,
	ResEncoding.base16 
];

static const uint[] resource_sumi = [
	832533648,
	1951281988,
	3830768605,
	3119248986,
	2501545372,
	9092863,
	2472579997,
	2342516385,
	419127154
];

static const uint[] resource_sume = [
	471418432,
	2518604207,
	543641089,
	149048335,
	1068072948,
	469500517,
	1406068463,
	143152600,
	1183704631
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
void main(){}