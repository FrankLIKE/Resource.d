
:: --db16: list of folders whose files content will be encoded as hex strings 
:: --of: the output filename.d
:: --om: the module, fully.qua.li.fied name.
:: --main: add an empty main(). can be used to quickly test the res file, e.g as a Coedit runnable module.

..\bin\resource.d.exe ^
--db16=..\res\ ^
--of=generate2.d ^
--om=project.resources ^
--main

pause
