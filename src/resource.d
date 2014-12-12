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
 
void main(string[] args){


    // resources to write in the module
    ResItem*[] resItems;
    scope(exit){
    foreach(i; 0 .. resItems.length)
        delete resItems[i];
    }

    // options holders
    bool wantHelp, addMain, verbose;
    static string header = import("header.txt");
    static string helptxt= import("help.txt");
    string outputFname;
    string moduleName;
    string opt;
    string[] fraws;
    string[] fb16s;
    string[] fb64s;
    string[] fz85s;
    string[] fe7Fs;

    writeln(header);
    // help display
    getopt(args, config.passThrough, "h|help", &wantHelp);
    if (wantHelp || args.length == 1){
        write(helptxt);
        stdout.flush;
        readln;
        return;
    }

    getopt(args, config.passThrough, "v|verbose", &verbose);

    // get files to be encoded, without ident, by encoder kind.
    void getFilesToEncode(string aOpt, ref string[] aHolder)
    {
        opt.reset;
        getopt(args, config.passThrough, aOpt, &opt);
        foreach (elem; split(opt, ';')){
            aHolder ~= elem;
            writeMessage(verbose, format("adding resource file '%s'", elem));
        }
    }
    getFilesToEncode("fraw", fraws);
    getFilesToEncode("fb16", fb16s);
    getFilesToEncode("fb64", fb64s);
    getFilesToEncode("fz85", fz85s);
    getFilesToEncode("fe7F", fe7Fs);

    // get folder of files to be be encoded, without ident, by encoder kind.
    void getFoldersToEncode(string foldOpt, ref string[] aHolder)
    {
        opt.reset;
        getopt(args, config.passThrough, foldOpt, &opt);
        foreach(foldname; split(opt, ';')){
            writeMessage(verbose, format("processing folder '%s'", foldname));
            foreach(fname; dirEntries(foldname, SpanMode.shallow)){
                aHolder ~= fname;
                writeMessage(verbose, format("adding resource file '%s'", fname));
            }
        }
    }
    getFoldersToEncode("draw", fraws);
    getFoldersToEncode("db16", fb16s);
    getFoldersToEncode("db64", fb64s);
    getFoldersToEncode("dz85", fz85s);
    getFoldersToEncode("de7F", fe7Fs);

    // get fully described items
    opt.reset;
    getopt(args, config.passThrough, "itms", &opt);
    writeMessage(verbose && opt.length, "creating the resources from --itms...");
    foreach(itm; split(opt, ';')){
        string[] elems = split(itm, '%');
        if (!elems.length) continue; // allow empty or final semicolon
        assert(elems.length == 4);
        auto enc = to!ResEncoding(elems[3]);
        resItems ~= new ResItem(elems[0], enc, elems[1], elems[2]);
    }

    if (!resItems.length)
        if (!fraws.length)
            if (!fb16s.length)
                if (!fb64s.length)
                    if (!fz85s.length)
                        if (!fe7Fs.length){
        writeMessage(true, "nothing to encode");
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
        writeMessage(true, "\r\n");
        while(true) {
            r.reset;
            if (i != 3)
                writeMessage(true, "the output file already exists, press Y+ENTER to overwrite or N+ENTER to quit");
            else
                writeMessage(true, "last chance, press Y+ENTER to overwrite otherwise the program will quit");
            stdout.flush;
            r = readln;
            ++i;
            if (r == "Y\n" || r == "y\n")
                break;
            if (i == 4 || r == "N\n" || r == "n\n")
                return;
        }

        writeMessage(true, format("'%s' will be overwritten.", outputFname));
        std.file.remove(outputFname);
    }
    writeMessage(verbose, "writing the module name...");
    outputFname.append(format("module %s;", moduleName));


    // prepares the resources properties and their encoded form
    writeMessage(verbose && fraws.length, "creating the resources from --fraw...");
    foreach (fname; fraws)
        resItems ~= new ResItem(fname, ResEncoding.raw);
    writeMessage(verbose && fb16s.length, "creating the resources from --fbase16...");
    foreach (fname; fb16s)
        resItems ~= new ResItem(fname, ResEncoding.base16);
    writeMessage(verbose && fb64s.length, "creating the resources from --fbase64...");
    foreach (fname; fb64s)
        resItems ~= new ResItem(fname, ResEncoding.base64);
    writeMessage(verbose && fz85s.length, "creating the resources from --fz85...");
    foreach (fname; fz85s)
        resItems ~= new ResItem(fname, ResEncoding.z85);
    writeMessage(verbose && fe7Fs.length, "creating the resources from --fe7F...");
    foreach (fname; fe7Fs)
        resItems ~= new ResItem(fname, ResEncoding.e7F);

    // writes the resource representations to the module
    writeMessage(verbose, "writing the resources text...");
    outputFname.append("\r\n\r\n");
    outputFname.append("static const resource_txt = [");
    foreach (i; 0 .. resItems.length -1)
        outputFname.append(format("\r\n\t" ~ "\"" ~ "%s" ~ "\"" ~ ",", resItems[i].encoded));
    outputFname.append(format("\r\n\t" ~ "\"" ~ "%s" ~ "\"" ~ "\r\n];", resItems[$-1].encoded));
//        outputFname.append(format("\r\n" ~ "%s,\r\n", splitConstString(resItems[i].encoded)));
//    outputFname.append(format("\r\n" ~ "%s];", splitConstString(resItems[$-1].encoded)));

    // writes the resources identifiers to the module
    writeMessage(verbose, "writing the resources identifiers...");
    outputFname.append("\r\n\r\n");
    outputFname.append("static const resource_idt = [");
    foreach (i; 0 .. resItems.length -1)
        outputFname.append(format("\r\n\t" ~ "\"" ~ "%s" ~ "\"" ~ ",", resItems[i].identifier));
    outputFname.append(format("\r\n\t" ~ "\"" ~ "%s" ~ "\"" ~ "\r\n];", resItems[$-1].identifier));
    
    // writes the resources metadata to the module
    writeMessage(verbose, "writing the resources metadata...");
    outputFname.append("\r\n\r\n");
    outputFname.append("static const resource_mdt = [");
    foreach (i; 0 .. resItems.length -1)
        outputFname.append(format("\r\n\t" ~ "\"" ~ "%s" ~ "\"" ~ ",", resItems[i].metaData));
    outputFname.append(format("\r\n\t" ~ "\"" ~ "%s" ~ "\"" ~ "\r\n];", resItems[$-1].metaData));    

    // writes the resources encoder kind to the module
    writeMessage(verbose, "writing the resources kind...");
    outputFname.append("\r\n\r\n");
    outputFname.append("static const resource_enc = [");
    foreach (i; 0 .. resItems.length -1)
        outputFname.append(format("\r\n\t%s.%s,", ResEncoding.stringof, resItems[i].encoding));
    outputFname.append(format("\r\n\t%s.%s \r\n];", ResEncoding.stringof, resItems[$-1].encoding));

    // writes the initial sums to the module
    writeMessage(verbose, "writing the resources initial sum...");
    outputFname.append("\r\n\r\n");
    outputFname.append("static const uint[] resource_sumi = [");
    foreach (i; 0 .. resItems.length -1)
        outputFname.append(format("\r\n\t" ~ "%.d" ~ ",", resItems[i].initialSum));
    outputFname.append(format("\r\n\t" ~ "%.d" ~ "\r\n];", resItems[$-1].initialSum));

    // writes the encoded sums to the module
    writeMessage(verbose, "writing the resources encoded sum...");
    outputFname.append("\r\n\r\n");
    outputFname.append("static const uint[] resource_sume = [");
    foreach (i; 0 .. resItems.length -1)
        outputFname.append(format("\r\n\t" ~ "%.d" ~ ",", resItems[i].encodedSum));
    outputFname.append(format("\r\n\t" ~ "%.d" ~ "\r\n];", resItems[$-1].encodedSum));

    // appends the resource accessors template code.
    writeMessage(verbose, "writing the resources accessors...");
    outputFname.append("\r\n\r\n");
    outputFname.append(import("encoders_knd.d"));
    outputFname.append("\r\n\r\n");
    outputFname.append(import("accessors.d"));

    // optional main()
    getopt(args, config.passThrough, "m|main", &addMain);
    writeMessage(verbose && addMain, "writing a dummy main()...");
    if (addMain) outputFname.append("void main(){}");

    writeMessage(true, "\r\n> resource file written, press any key to exit.");
    stdout.flush;
    readln;
}
