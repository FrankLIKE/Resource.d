module z85;

//  --------------------------------------------------------------------------
//  Reference implementation for rfc.zeromq.org/spec:32/Z85
//
//  This implementation provides a Z85 codec as an easy-to-reuse C class
//  designed to be easy to port into other languages.

//  --------------------------------------------------------------------------
//  Copyright (c) 2010-2013 iMatix Corporation and Contributors
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//  --------------------------------------------------------------------------

import std.stdio, std.conv;

///  Maps base 256 to base 85
static string encoder =
    "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-:+=^!/*?&<>()[]{}@%$#";

///  Maps base 85 to base 256
static immutable ubyte[96] decoder = [
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

/// Encodes a byte array as a string whose charset is defined by encoder.
char[] Z85_encode(ubyte[] input)
in
{
    assert(input.length, "nothing to encode");
    assert(!(input.length & 3), "input data length must be a multiple of 4");
}
body
{
    size_t encoded_size = input.length * 5 / 4;
    char[] encoded;
    encoded.length = encoded_size;
    uint char_nbr;
    uint byte_nbr;
    uint value;
    while (byte_nbr < input.length)
    {
        value = value * 256 + input [byte_nbr++];
        if ((byte_nbr & 3) == 0)
        {
            uint divisor = 85 * 85 * 85 * 85;
            while (divisor)
            {
                encoded[char_nbr++] = encoder[value / divisor % 85];
                divisor /= 85;
            }
            value = 0;
        }
    }
    assert (char_nbr == encoded_size);
    return encoded;
}

/// Decodes an encoded string into a byte array.
ubyte[] Z85_decode (char[] input)
in
{
    assert(!(input.length % 5), "input data length must be a multiple of 5");
}
body
{
    size_t decoded_size = input.length * 4 / 5;
    ubyte[] decoded;
    decoded.length = decoded_size;
    uint byte_nbr;
    uint char_nbr;
    uint value;
    while (char_nbr < input.length)
    {
        value = value * 85 + decoder [cast(ubyte) input[char_nbr++] - 32];
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
    return decoded;
}

/**
 * Container for a z85 decoded form.
 * It features an automatic tail handling and can be kept in sync
 * with its encoded form.
 */
struct Z85Dec
{
    private:

        static immutable ubyte[3] _filler;
        ubyte[] _data;
        size_t _tail;
        Z85Enc* _outPtr;

    public:

        this(ubyte[] input)
        {
            data = input;
        }

        this(char[] input)
        {
            data = cast(ubyte[])input;
        }

        void encode(Z85Enc* encoded)
        {
            encoded.data = Z85_encode(_data);
            encoded._tail = _tail;
            encoded._inpPtr = &this;
            _outPtr = encoded;
        }

        @property void data(ubyte[] input)
        {
            if(_outPtr && _outPtr._inpPtr == &this)
                _outPtr._inpPtr = null;
            _tail = 0;
            _outPtr = null;
            auto rem = input.length & 3;
            if (rem) _tail = 4 - rem;
            _data = input;
            _data ~= _filler[0 .. _tail];
        }

        @property ubyte[] data()
        {
            return _data[0 .. $-_tail];
        }

        @property bool hasEncoded()
        {
            return (_outPtr != null);
        }

        @property const(char[]) encoded()
        {
            if (hasEncoded)
                return _outPtr._data;
            else
                return typeof(return).init;
        }

        @property const(size_t) tail()
        {
            return _tail;
        }
}

/**
 * Container for a z85 encoded form.
 * It can be kept in sync with its decoded form.
 */
struct Z85Enc
{
    private:

        char[] _data;
        size_t _tail;
        Z85Dec* _inpPtr;

    public:

        this(char[] input)
        {
            data = input;
        }

        void decode(Z85Dec* decoded)
        {
            decoded.data = Z85_decode(_data);
            decoded._outPtr = &this;
            _inpPtr = decoded;
            _tail = decoded._tail;
        }

        @property void data(char[] input)
        {
            if(_inpPtr && _inpPtr._outPtr == &this)
                _inpPtr._outPtr = null;
            _tail = 0;
            _inpPtr = null;
            _data = input;
        }

        @property char[] data()
        {
            return _data;
        }

        @property bool hasDecoded()
        {
            return (_inpPtr != null);
        }

        @property const(ubyte[]) decoded()
        {
            if (hasDecoded)
                return _inpPtr._data;
            else
                return typeof(return).init;
        }

        @property const(size_t) tail()
        {
            return _tail;
        }
}

version (none) void main(string[] args)
{

    ubyte[8] test_data_1  = [
        0x86, 0x4F, 0xD2, 0x6F, 0xB5, 0x59, 0xF7, 0x5B
    ];
    ubyte[32] test_data_2 = [
        0x8E, 0x0B, 0xDD, 0x69, 0x76, 0x28, 0xB9, 0x1D,
        0x8F, 0x24, 0x55, 0x87, 0xEE, 0x95, 0xC5, 0xB0,
        0x4D, 0x48, 0x96, 0x3F, 0x79, 0x25, 0x98, 0x77,
        0xB4, 0x9C, 0xD9, 0x06, 0x3A, 0xEA, 0xD3, 0xB7
    ];
    char[] encoded;
    ubyte[] decoded;

    encoded = Z85_encode (test_data_1);
    assert (encoded.length == 10, to!string(encoded.length));
    assert (encoded == "HelloWorld");
    decoded = Z85_decode (encoded);
    assert (test_data_1[0..$] == decoded[0..$] );
    decoded = decoded.init;
    encoded = encoded.init;
    encoded = Z85_encode (test_data_2);
    assert (encoded.length == 40);
    assert (encoded == "JTKVSB%%)wK0E.X)V>+}o?pNmC{O&4W4b!Ni{Lh6");
    decoded = Z85_decode (encoded);
    assert (test_data_2[0..$] == decoded[0..$] );
    decoded = decoded.init;
    encoded = encoded.init;

    //  Standard test keys defined by zmq_curve man page
    ubyte[32] client_public = [
        0xBB, 0x88, 0x47, 0x1D, 0x65, 0xE2, 0x65, 0x9B,
        0x30, 0xC5, 0x5A, 0x53, 0x21, 0xCE, 0xBB, 0x5A,
        0xAB, 0x2B, 0x70, 0xA3, 0x98, 0x64, 0x5C, 0x26,
        0xDC, 0xA2, 0xB2, 0xFC, 0xB4, 0x3F, 0xC5, 0x18
    ];
    ubyte[32] client_secret  = [
        0x7B, 0xB8, 0x64, 0xB4, 0x89, 0xAF, 0xA3, 0x67,
        0x1F, 0xBE, 0x69, 0x10, 0x1F, 0x94, 0xB3, 0x89,
        0x72, 0xF2, 0x48, 0x16, 0xDF, 0xB0, 0x1B, 0x51,
        0x65, 0x6B, 0x3F, 0xEC, 0x8D, 0xFD, 0x08, 0x88
    ];
    encoded = Z85_encode (client_public);
    encoded = encoded.init;
    encoded = Z85_encode (client_secret);
    encoded = encoded.init;

    ubyte server_public [32] = [
        0x54, 0xFC, 0xBA, 0x24, 0xE9, 0x32, 0x49, 0x96,
        0x93, 0x16, 0xFB, 0x61, 0x7C, 0x87, 0x2B, 0xB0,
        0xC1, 0xD1, 0xFF, 0x14, 0x80, 0x04, 0x27, 0xC5,
        0x94, 0xCB, 0xFA, 0xCF, 0x1B, 0xC2, 0xD6, 0x52
    ];
    ubyte server_secret [32] = [
        0x8E, 0x0B, 0xDD, 0x69, 0x76, 0x28, 0xB9, 0x1D,
        0x8F, 0x24, 0x55, 0x87, 0xEE, 0x95, 0xC5, 0xB0,
        0x4D, 0x48, 0x96, 0x3F, 0x79, 0x25, 0x98, 0x77,
        0xB4, 0x9C, 0xD9, 0x06, 0x3A, 0xEA, 0xD3, 0xB7
    ];
    encoded = Z85_encode (server_public);
    encoded = encoded.init;
    encoded = Z85_encode (server_secret);
    encoded = encoded.init;

    auto dec = Z85Dec("12345".dup);
    Z85Enc enc;
    assert(!dec.hasEncoded);
    assert(dec.tail == 3);
    dec.encode(&enc);
    assert(dec.hasEncoded);
    assert(enc.hasDecoded);
    assert(enc.tail == 3);
    enc.data = "1234567891".dup;
    assert(!enc.hasDecoded);
    assert(!dec.hasEncoded);
    enc.decode(&dec);
    assert(dec.hasEncoded);
    assert(enc.hasDecoded);
    assert(enc.tail == dec.tail);
}
