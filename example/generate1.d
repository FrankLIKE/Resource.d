module project.resources;

static const resource_txt = [
	"313233343536383720393837343132353820393637383933323534373531",
	"41656E65616E206D61757269732076656C69742C20696163756C697320757420656E696D2065742C20696D706572646965742072686F6E63757320697073756D2E20416C697175616D206567657420646F6C6F722076656C206F72636920706C616365726174206672696E67696C6C6120696E206575206C6F72656D2E204372617320617420636F6D6D6F646F2066656C69732E20437261732076656C6974207475727069732C20666175636962757320717569732068656E647265726974206E6F6E2C20657569736D6F64207669746165206C616375732E204372617320706F72747469746F722074656D70757320766573746962756C756D2E204D6F726269206D6174746973206E657175652071756973206C65637475732070656C6C656E7465737175652C206163207665686963756C61206C656374757320616363756D73616E2E20517569737175652074656D706F72206D61676E612076656C20616363756D73616E206C6163696E69612E20457469616D206163206C656F206F64696F2E204E616D20736564206D617373612065752073617069656E2076756C70757461746520666575676961742065752065676574206469616D2E20566573746962756C756D2069642065737420696420656C6974207661726975732066696E696275732061742061742070757275732E2041656E65616E206F726E6172652066656C69732065676574206C696265726F20657569736D6F642C20696E2066657567696174206C6F72656D206C6163696E69612E2050686173656C6C7573206566666963697475722061742066656C697320717569732074696E636964756E742E",
	"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAJhJREFUeNpi/P//PwMlgAVE3Lt37wCQsidR70ElJSUHsAFAV9iTYbk93AX//v2jzAt///6FC9TV1YHppqYmFIW4xDEM+PPnDwO6GD5xDC/AFKJ7C5c4IygaL1y4QFZcGhgYMLIgm06VQCTLAGR/FRcX49XQ29tLXCzgAlhjAVmwu7ubdAMoTolAA0CZyYFEvQfg6YASABBgAESXY0hyXW4UAAAAAElFTkSuQmCC",
	"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAPJJREFUeNqkk00OREAQhV9PbOzsCeEEDkC4h6NILJzEUUxYWXEBImFvZ+NndCc6hpgJKmmdfKpKv1eazPOMJyHQR1mW8bI5F2vfhmG4rMFyCufGxx1+gmmankkYx5GDIAjYHobhV+IZPzQYhgF79osfJKyJe1lnnNAx5nl+a5amaRJh2/1OvFZddGVZBt/3URQFZ+uijL6jOSs7eCCKIvq+RxRF0DQNiqIw3jQN6roGIYTlbH1gHqRpyj2oqgpJkqBtW3Rdx5gkSZBlGbZtQ9d1XmxZFjmMUVVVeJ53qvnvGG/9iUsDepnci7Ux9+BJfAQYAA4ymWUAhzHmAAAAAElFTkSuQmCC",
	"Q?Ot^{tpZw/HyUEpI0n8!v9<hV#7N>ycZp8ytdf{!mvo>HnqH@o51P6T.QF6/sCIEmpY$7Q{-)jX2*O]Q0>F:ysDDNQTVT^TXkKJoj:{NwO72j!Ly6Ln[yE$m8&//-)!KooAk4)"
];

static const resource_idt = [
	"res_ansi_1",
	"res_ansi_2",
	"res_img1",
	"res_img2",
	"res_rnd1"
];

static const resource_enc = [
	 ResEncoding.base16 ,
	 ResEncoding.base16 ,
	 ResEncoding.base64 ,
	 ResEncoding.base64 ,
	 ResEncoding.z85 
];

static const resource_sumi = [
	832533648,
	1951281988,
	3830768605,
	3119248986,
	9092863
];

static const resource_sume = [
	471418432,
	2518604207,
	2005268032,
	4283104252,
	3503196859
];

static const resource_pad = [
	0,
	0,
	0,
	0,
	3
];

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

