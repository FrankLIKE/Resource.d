
:: --itms: list of fully described items.
:: --of: the output filename.d
:: --om: the module, fully.qua.li.fied name.

..\bin\resource.d.exe ^
--of=generate3.d ^
--om=project.resources ^
--itms=^
..\res\res_ansi_1.txt%%resource_1%%z85;^
..\res\res_ansi_2.txt%%resource_2%%base64

pause
