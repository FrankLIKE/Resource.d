# Resource.d

#### Introduction
-----------------

**Resource.d** is a resource encoder and manager for programs written in D2. 
Its purpose is to generate a D2 module containing some constant data (the resources) 
and some accessors functions to extract and use those data.

It can be compared to the Windows P.E resource system but additionally it's:
* **multi-platform**: the same resource system works on the 3 major platforms.
* **cross-platform**: the D module generated on a platform doesn't have to be re-generated on another one.
* the resources are **directly put in the source code** by using various binary-to-text encoders (including: *UTF-8*, *base16*, *base64*, *Z85* and *e7F*)

The encoding is the most important part of this tool, since the resources must be valid D source text.
For example, this raw pattern *0xFFFFFFFF0C* would be invalid if explicitly cast as chars of a string litteral.
( *0xFFFFFFFF* exceeds *0x7FFFFFFF*, the max UTF-32 value, cf.[supported source code encoding](http://dlang.org/lex) ).
When a resource represents a _*.bmp_, a _*.dll_ or a _*.so_, such pattern are common, so encoding is mandatory.

#### Setup
----------

Setup files are located in the sub folder named `build`:
* a [Coedit project file](https://github.com/BBasile/Coedit) is included. It's cross-platform.
* more simply the shell script for Linux or the batch file for Windows.

Additionally, a DUB package description is located in project root folder. 

#### Usage
----------

Compose a command-line using the following options and run the tool:
```
+---------------------------------------------------------+
| -h --help............: displays this message.           |
| -m --main............: adds an empty main().            |
| -v --verbose.........: verbose output.                  |
+---------------------------------------------------------+
| --of=file............: output filename.                 |
| --om=the.module......: output qualified module name.    |
+---------------------------------------------------------+
| --fraw=file;file.....: files, content is utf8 encoded.  |
| --fb16=file;file.....:       "           base16   "     |
| --fb64=file;file.....:       "           base64   "     |
| --fz85=file;file.....:       "           base85   "     |
| --fe7F=file;file.....:       "           7F       "     |
+---------------------------------------------------------+
| --draw=folder;folder.: folders entries are utf8 encoded.|
| --db16=folder;folder.:       "             base16 "     |
| --db64=folder;folder.:       "             base64 "     |
| --dz85=folder;folder.:       "             base85 "     |
| --de7F=folder;folder.:       "             7F     "     |
+---------------------------------------------------------+
| --itms=<itm>;<itm>...: itm are encoded according to...  |
| <itm>=<f>%<i>%<t>%<e>: itm is formed of 4 members       |
| <f>=filename.........: file whose content is to encode  |
| <i>=identifier.......: string identifying the resource  |
| <t>=metadata.........: additional data for the resource |
| <e>=encoder kind.....: raw, base16, base64, z85 or e7F  |
+---------------------------------------------------------+
```
The output module can be imported in the target project and can be used with the following *API* (integrated to each resource module produced by the tool):
```D
/// returns the resource count.
public size_t resourceCount();

/// returns the index of the resource associated to resIdent.
public ptrdiff_t resourceIndex(string resIdent);

/// returns the identifier of the resIndex-th resource.
public string resourceIdent(size_t resIndex);

/// returns the metadata of the resIndex-th resource.
public string resourceMeta(size_t resIndex);

/// returns the signature of the decoded resource form.
public uint resourceInitCRC(size_t resIndex);

/// returns the signature of the encoded resource form.
public uint resourceFinalCRC(size_t resIndex);

/// returns true if the encoded form of a resource is corrupted.
public bool isResourceEncCorrupted(size_t resIndex);

/// returns true if the decoded form of a resource is corrupted.
public bool isResourceDecCorrupted(size_t resIndex);

/// returns the encoder kind of the resIndex-th resource.
public ResEncoding resourceEncoding(size_t resIndex);

/// decodes the resIndex-th resource in dest.
public bool decode(size_t resIndex, ref ubyte[] dest);
```

A few examples are available in the aptly named `example` folder.
They illustrate how to generate a resource module. 
Additionaly, here is a short example of the *API* usage:

```D
// the resource module generated for this program
import myResource.d
import std.file;

auto index = resourceIndex("myResourceIdentifier");
if(index != -1) {
    ubyte[] resourceData;
    if (decode(index, resourceData)) {
        string filename = "myFileName.txt";
        std.file.write(filename, resourceData);
    }
}
```

#### Other Information
----------------------
* status: alpha 1.
* license: MIT.
