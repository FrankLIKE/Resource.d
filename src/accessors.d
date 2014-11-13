/// enumerates the supported encoder kinds.
public enum ResEncoding {
    raw, base16, base64, z85
};

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
    }
    return true;
}

private void decoderaw(size_t resIndex, ref ubyte[] dest){
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

private void decodez85(size_t resIndex, ref ubyte[] dest){
    // problem: z85 is not std
}

