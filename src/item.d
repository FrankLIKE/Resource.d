module item;

import core.exception;

import std.file, std.path;
import std.string: format;

import utils;

mixin(import("encoders_knd.d"));

/**
 * Resource item.
 * The resource properties and the encoded form are generated in the constructor.
 * The two 32 bit digests are used to check "data integrity", not for "security".
 */
struct ResItem{
    private:
        static const resFileMsg = "resource file '%s' ";
        ResEncoding _resEncoding;
        string _resIdentifier;
        char[] _resTxtData;
        ubyte[] _resRawData;
        uint _initialSum;
        uint _encodedSum;

        bool encodeDispatcher(){
            final switch(this._resEncoding){
                case ResEncoding.raw:
                    return encodeRaw();
                case ResEncoding.base16:
                    return encodeb16();
                case ResEncoding.base64:
                    return encodeb64();
                case ResEncoding.z85:
                    return encodez85();
                case ResEncoding.e7F:
                    return encodee7F();
            }
        }

        /// encodes _resRawData to an UTF8 string
        bool encodeRaw(){
            scope(failure) return false;
            _resTxtData = (cast(char[])_resRawData).dup;
            return true;
        }

        /// encodes _resRawData to a hex string
        bool encodeb16(){
            scope(failure) return false;
            foreach(b; _resRawData)
                this._resTxtData ~= ubyte2Hex(b);
            assert(_resTxtData.length == _resRawData.length * 2,
                "b16 representation length mismatches");
            return true;
        }

        /// encodes _resRawData to a base64 string
        bool encodeb64(){
            import std.base64;
            scope(failure) return false;
            _resTxtData = Base64.encode(_resRawData);
            return true;
        }

        /// encodes _resRawData to a Z85 string
        bool encodez85(){
            import z85;
            scope(failure) return false;
            _resTxtData = Z85_encode(_resRawData);
            assert(_resTxtData.length == _resRawData.length * 5 / 4,
                "z85 representation length mismatches");
            return true;
        }
        
        /// encodes _resRawData to a e7F string
        bool encodee7F()
        {
            import e7F;
            scope(failure) return false;
            _resTxtData = encode_7F(_resRawData);
            return true;
        }

    public:

        /// creates and encodes a new resource item.
        this(string resFile, ResEncoding resEnc, string resIdent = "")
        {
            this._resEncoding = resEnc;

            // load the raw content
            if (!resFile.exists)
                throw new Exception(format(resFileMsg ~ "does not exist", resFile));
            else
                _resRawData = cast(ubyte[])std.file.read(resFile);
            if (!_resRawData.length)
                throw new Exception(format(resFileMsg ~ "is empty", resFile));

            import std.digest.crc;
            CRC32 ihash;
            ihash.put(_resRawData);
            _initialSum = crc322uint(ihash.finish);

            // sets the resource identifier to the res filename if param is empty
            this._resIdentifier = resIdent;
            if (this._resIdentifier == "")
                this._resIdentifier = resFile.baseName.stripExtension;

            if (!encodeDispatcher)
                throw new Exception(format(resFileMsg ~ "encoding failed", resFile));
            this._resRawData.length = 0;
            CRC32 ehash;
            ehash.put(cast(ubyte[])_resTxtData);
            _encodedSum = crc322uint(ehash.finish);

            writeMessage(true, format("encoded resource file '%s'", resFile));
        }

        /// returns the resource encoded as a string.
        char[] encoded(){return _resTxtData;}

        /// returns the resource identifier.
        string identifier(){return _resIdentifier;}

        /// returns the resource encoding kind.
        ResEncoding encoding(){return _resEncoding;}

        /// returns the signature of the original data.
        uint initialSum(){return _initialSum;}

        /// returns the signature of the encoded data.
        uint encodedSum(){return _encodedSum;}
}
