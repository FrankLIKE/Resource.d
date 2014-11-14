module resource;

import core.exception;
//
import std.stdio, std.getopt;
import std.file, std.path;
import std.algorithm, std.conv, std.array;
import std.string: format;
//
import utils, item;

/// resource strings are splitted in multpiles lines
static uint resColumn = 100;


/*  Options
    =======

    (generates a template with empty resources, allow to compile/develop with a valid
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
        outputFname.append(format("\r\n\t%s.%s,", ResEncoding.stringof, resItems[i].encoding));
    outputFname.append(format("\r\n\t%s.%s \r\n];", ResEncoding.stringof, resItems[$-1].encoding));

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

    // appends the resource accessors template code.
    outputFname.append("\r\n\r\n");
    outputFname.append(import("accessors.d"));

    writeln("resource file written, press any key to exit.");
    readln;
}
