# Resource.d

##### Introduction
----------------------

**Resource.d** is a resource encoder and manager for programs written in D2. Its purpose is
to encode the content of some file to some constant data in a D module and to generate some accessor
functions to use those resources during the program run-time.

It can be compared to the P.E format resource system but additionally it's:
* **multiplateform**: the same resource system works on the 3 major plateforms.
* **crossplateform**: the D module generated on a plateform doesn't have to be re-generated on another one.
* the resources are **directly put in the source code** by using various binary-to-text encoders (including: *UTF-8*, *base16*, *base64* and *Z85*.)

##### Other Information
---------------------
* includes a Coedit project file.
* status: early alpha.
* license: MIT.