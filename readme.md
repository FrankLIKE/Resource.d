# Resource.d

#### Introduction
-----------------

**Resource.d** is a resource encoder and manager for programs written in D2. Its purpose is
to encode the content of some file to some constant data in a D module and to generate some accessors
functions to use those resources during the program run-time.

It can be compared to the P.E format resource system but additionally it's:
* **multi-platform**: the same resource system works on the 3 major platforms.
* **cross-platform**: the D module generated on a platform doesn't have to be re-generated on another one.
* the resources are **directly put in the source code** by using various binary-to-text encoders (including: *UTF-8*, *base16*, *base64* and *Z85*.)

#### Setup
----------

Setup files are located in the sub folder named `build`:
* a Coedit project file is included. It's cross-platform.
* more simply the shell script for Linux and the batch file for Windows.

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
+---------------------------------------------------------+
| --draw=folder;folder.: folders entries are utf8 encoded.|
| --db16=folder;folder.:       "             base16 "     |
| --db64=folder;folder.:       "             base64 "     |
| --dz85=folder;folder.:       "             base85 "     |
+---------------------------------------------------------+
| --itms=<itm>;<itm>...: itm are encoded according to...  |
| <itm>=<f>%<i>%<e>....: itm is formed of 3 members       |
| <f>=filename.........: file whose content is to encode  |
| <i>=identifier.......: a string used to identify the res|
| <e>=encoder kind.....: raw, base16, base64 or z85       |
+---------------------------------------------------------+
```
The output module can be imported in the target project and can be used with the following API (integrated to the each resource module produced by the tool):
```D
/// enumerates the supported encoder kinds.
public enum ResEncoding {
    raw, base16, base64, z85
};

/// returns the index of the resource associated to resIdent.
public size_t resourceIndex(string resIdent){}

/// returns the identifier of the resIndex-th resource.
public string resourceIdent(size_t resIndex){}

/// returns true if the encoded form of a resource is corrupted.
public bool isResourceEncCorrupted(size_t resIndex){}

/// returns the encoder kind of the resIndex-th resource.
public ResEncoding resourceEncoding(size_t resIndex){}

/// decodes the resIndex-th resource in dest.
public bool decode(size_t resIndex, ref ubyte[] dest){}
```

A few examples are available in the aptly named `example` folder. 

#### Other Information
----------------------
* status: alpha 1.
* license: MIT.