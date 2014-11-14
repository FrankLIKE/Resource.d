
:: --db16: list of folders whose files content will be encoded as hex strings 
:: --of: the output filename.d
:: --om: the module, fully.qua.li.fied name.

..\bin\resource.d.exe ^
--db16=..\res\ ^
--of=generate2.d ^
--om=project.resources

pause
