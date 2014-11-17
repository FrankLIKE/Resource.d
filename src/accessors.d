/// returns the index of the resource associated to resIdent.
public size_t resourceIndex(string resIdent){
    import std.algorithm;
    return countUntil(resource_idt, resIdent);
}

/// returns the identifier of the resIndex-th resource.
public string resourceIdent(size_t resIndex){
    return resource_idt[resIndex];
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
 * Decodes a string as a byte array.
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
