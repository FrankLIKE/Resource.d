module resource;

import core.exception;
import std.stdio, std.getopt;
import std.file, std.path;
import std.algorithm, std.conv, std.array;
import std.string: format;

alias uint32 = uint;

/// resource strings are splitted in multpiles lines
static uint32 resColumn = 100;

/**
 * describes the encoding algorithm of a resource.
 *  - safety: only raw is unsafe: if encoding/decoding fails then the program or resman crashes/raises an exception.
 *  - padding: the encoder can add a few chars (up to 2 for b64, up to 3 for z85)
 *  - average yield: from best to worst: utf8 (1/1), z85 (4/5), b64 (3/4), b16 (1/2).
 *  - usage: raw should only be used for strings, other encoders can be used for everything.
 */
enum ResEncoding {
    raw,    /// encode the raw data to an utf8 string.
    base16, /// encode as an hexadeciaml representation.
    base64, /// encode as a base64 representation.
    z85     /// encode as a base85 representation (ascii chars only),
};

/**
 * Resource item.
 * The resource properties and the encoded form are generated in the constructor.
 */
struct ResItem{
    private:

        static const resFileMsg = "resource file '%s' ";
        ResEncoding _resEncoding;
        string _resIdentifier;
        char[] _resTxtData;
        ubyte[] _resRawData;
        ubyte[4] _initialSum;
        ubyte[4] _encodedSum;
        uint32 _padding;

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
            }
        }

        /// encode _resRawData to an UTF8 string
        bool encodeRaw(){
            scope(failure) return false;
            _resTxtData = (cast(char[])_resRawData).dup;
            return true;
        }


        /// returns the hexadecimal representation of a ubyte.
        char[2] ubyte2Hex(ubyte value){
            // because to!string(int, radix) strips the leading 0 off.
            static const hexDigits = "0123456789ABCDEF";
            char[2] result;
            result[1] = hexDigits[((value & 0x0F)     )];
            result[0] = hexDigits[((value & 0xF0) >> 4)];
            return result;
        }

        /// encode _resRawData to a hex string
        bool encodeb16(){
            scope(failure) return false;
            foreach(b; _resRawData)
                this._resTxtData ~= ubyte2Hex(b);
            assert(_resTxtData.length == _resRawData.length * 2,
                "b16 representation length mismatches");
            return true;
        }

        /// encode _resRawData to a base64 string
        bool encodeb64(){
            import std.base64;
            scope(failure) return false;
            _resTxtData = Base64.encode(_resRawData);
            return true;
        }

        /// encode _resRawData to a Z85 string
        bool encodez85(){
            import z85;
            scope(failure) return false;
            auto dec = Z85Dec(_resRawData);
            Z85Enc enc;
            dec.encode(&enc);
            _resTxtData = enc.data;
            _padding = cast(uint32) dec.tail;
            assert(_resTxtData.length == (_resRawData.length + _padding) * 5 / 4,
                "z85 representation length mismatches");
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
            _initialSum = ihash.finish;

            // sets the resource identifier to the res filename if param is empty
            this._resIdentifier = resIdent;
            if (this._resIdentifier == "")
                this._resIdentifier = resFile.baseName.stripExtension;

            if (!encodeDispatcher)
                throw new Exception(format(resFileMsg ~ "encoding failed", resFile));
            this._resRawData.length = 0;
            CRC32 ehash;
            ehash.put(cast(ubyte[])_resTxtData);
            _encodedSum = ehash.finish;
        }

        ~this(){}

        /// returns the count, in byte, of additional data added to complete encoding
        uint32 padding(){return _padding;}

        /// returns the resource encoded as a string.
        char[] encoded(){return _resTxtData;}

        /// returns the resource identifier.
        string identifier(){return _resIdentifier;}

        /// returns the resource encoding kind.
        ResEncoding encoding(){return _resEncoding;}

        /// returns the signature of the original data.
        uint32 initialSum(){
            uint32 result;
            ubyte* ptr = cast(ubyte*) &result;
            version(BigEndian)
                foreach(i; 0..4) * (ptr + i) = _initialSum[i];
            else
                foreach(i; 0..4) * (ptr + i) = _initialSum[3-i];
            return result;
        }

        /// returns the signature of the encoded data.
        uint32 encodedSum(){
            uint32 result;
            ubyte* ptr = cast(ubyte*) &result;
            version(BigEndian)
                foreach(i; 0..4) * (ptr + i) = _encodedSum[i];
            else
                foreach(i; 0..4) * (ptr + i) = _encodedSum[3-i];
            return result;
        }
}

/*  Options
    =======

    (generates a template with no resource, allow to compile/develop with a valid
    import while resources are not yet ready. at least --of must also be specified.
    -t|--tmp)

    some fully described items
    --itms=<itm format>;<itm format>
        itm format: <fname>%<ident>%<enc>
            fname: a filename
            ident: an identifier
            enc: either raw, base16, base64, z85

    raw/b16,b64,z85 res, using filename as ident.
    --fraw=file;file;file
    --fb16=file;file;file
    --fb64=file;file;file
    --fz85=file;file;file

    output filename
    --of=<relative or absolute fname>

    output module, optional
    --om=<qualified.module.name>

    general help
    --help|-h

    raw/b16,b64,z85 res, using filenames in each dir as ident, non recursive.
    --draw=directory;directory
    --db16=directory;directory
    --db64=directory;directory
    --dz85=directory;directory
*/


void main(string[] args){

    // resources to write in the module
    ResItem*[] resItems;
    scope(exit){
    foreach(i; 0 .. resItems.length)
        delete resItems[i];
    }

    // options holders
    bool wantHelp;
    static string helptxt = import("help.txt");
    string outputFname;
    string moduleName;
    string opt;
    string[] fraws;
    string[] fb16s;
    string[] fb64s;
    string[] fz85s;

    // help display
    getopt(args, config.passThrough, "h|help", &wantHelp);
    if (wantHelp || args.length == 1){
        write(helptxt);
        stdout.flush;
        readln;
        return;
    }

    // get files to be encoded, without ident, by encoder kind.
    void getFilesToEncode(string aOpt, ref string[] aHolder)
    {
        opt = opt.init;
        getopt(args, config.passThrough, aOpt, &opt);
        foreach(elem; split(opt, ';'))
            aHolder ~= elem;
    }
    getFilesToEncode("fraw", fraws);
    getFilesToEncode("fb16", fb16s);
    getFilesToEncode("fb64", fb64s);
    getFilesToEncode("fz85", fz85s);

    // get folder of files to be be encoded, without ident, by encoder kind.
    void getFoldersToEncode(string foldOpt, ref string[] aHolder)
    {
        opt = opt.init;
        getopt(args, config.passThrough, foldOpt, &opt);
        foreach(foldname; split(opt, ';'))
            foreach(fname; dirEntries(foldname, SpanMode.shallow))
                aHolder ~= fname;
    }
    getFoldersToEncode("draw", fraws);
    getFoldersToEncode("db16", fb16s);
    getFoldersToEncode("db64", fb64s);
    getFoldersToEncode("dz85", fz85s);


    // get fully described items
    opt = opt.init;
    getopt(args, config.passThrough, "itms", &opt);
    foreach(itm; split(opt, ';')){
        string[] elems = split(itm, '%');
        assert(elems.length == 3);
        auto enc = to!ResEncoding(elems[2]);
        resItems ~= new ResItem(elems[0], enc, elems[1]);
    }

    if (!resItems.length)
        if (!fraws.length)
            if (!fb16s.length)
                if (!fb64s.length)
                    if (!fz85s.length){
        writeln("nothing to encode");
        return;
    }

    // gets options for the module
    getopt(args, config.passThrough, "of", &outputFname, "om", &moduleName);
    if (outputFname == "")
        throw new Exception("an output filename must be specified with --of");
    if (moduleName == "")
        moduleName = outputFname.baseName.stripExtension;
    // prompt for overwrite
    if (outputFname.exists){
        size_t i;
        string r;
        while(true) {
            r = r.init;
            if (i != 3)
                writefln("'%s' already exists, press Y to overwrite or N to cancel", outputFname);
            else
                writefln("Last chance, press Y to overwrite or N to cancel, otherwise the program will exit");
            stdout.flush;
            r = readln;
            ++i;
            if ((r == "Y\n") | (r == "y\n"))
                break;
            if ((i == 4) | (r == "N\n") | (r == "n\n"))
                return;
        }

        writefln("'%s' will be overwritten.", outputFname);
        std.file.remove(outputFname);
    }
    outputFname.append(format("module %s;", moduleName));


    // prepares the resources properties and their encoded form
    foreach(fname; fraws)
        resItems ~= new ResItem(fname, ResEncoding.raw);
    foreach(fname; fb16s)
        resItems ~= new ResItem(fname, ResEncoding.base16);
    foreach(fname; fb64s)
        resItems ~= new ResItem(fname, ResEncoding.base64);
    foreach(fname; fz85s)
        resItems ~= new ResItem(fname, ResEncoding.z85);


    // writes the resource representations to the module
    outputFname.append("\r\n\r\n");
    outputFname.append("static const resource_txt = [");
    for (auto i = 0; i < resItems.length -1; i++)
        outputFname.append(format("\r\n\t" ~ "\"" ~ "%s" ~ "\"" ~ ",", resItems[i].encoded));
    outputFname.append(format("\r\n\t" ~ "\"" ~ "%s" ~ "\"" ~ "\r\n];", resItems[$-1].encoded));

    // writes the resources identifiers to the module
    outputFname.append("\r\n\r\n");
    outputFname.append("static const resource_idt = [");
    for (auto i = 0; i < resItems.length -1; i++)
        outputFname.append(format("\r\n\t" ~ "\"" ~ "%s" ~ "\"" ~ ",", resItems[i].identifier));
    outputFname.append(format("\r\n\t" ~ "\"" ~ "%s" ~ "\"" ~ "\r\n];", resItems[$-1].identifier));

    // writes the resources encoder kind to the module
    outputFname.append("\r\n\r\n");
    outputFname.append("static const resource_enc = [");
    for (auto i = 0; i < resItems.length -1; i++)
        outputFname.append(format("\r\n\t %s.%s,", ResEncoding.stringof, resItems[i].encoding));
    outputFname.append(format("\r\n\t %s.%s \r\n];", ResEncoding.stringof, resItems[$-1].encoding));

    // writes the resources initial sums to the module
    outputFname.append("\r\n\r\n");
    outputFname.append("static const resource_sumi = [");
    for (auto i = 0; i < resItems.length -1; i++)
        outputFname.append(format("\r\n\t" ~ "%.d" ~ ",", resItems[i].initialSum));
    outputFname.append(format("\r\n\t" ~ "%.d" ~ "\r\n];", resItems[$-1].initialSum));

    // writes the resources encoded sums to the module
    outputFname.append("\r\n\r\n");
    outputFname.append("static const resource_sume = [");
    for (auto i = 0; i < resItems.length -1; i++)
        outputFname.append(format("\r\n\t" ~ "%.d" ~ ",", resItems[i].encodedSum));
    outputFname.append(format("\r\n\t" ~ "%.d" ~ "\r\n];", resItems[$-1].encodedSum));

    // writes the resources padding to the module
    outputFname.append("\r\n\r\n");
    outputFname.append("static const resource_pad = [");
    if (resItems.length > 1) for (auto i = 0; i < resItems.length -1; i++)
        outputFname.append(format("\r\n\t" ~ "%d" ~ ",", resItems[i].padding));
    outputFname.append(format("\r\n\t" ~ "%d" ~ "\r\n];", resItems[$-1].padding));

    // appends the templated resource accessors
    outputFname.append("\r\n\r\n");
    outputFname.append(import("accessors.d"));

    writeln("resource file written, press any key to exit.");
    readln;
}

