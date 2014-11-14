
:: --fb16: list of files whose content will be encoded as hex strings 
:: --fb64: list of files whose content will be encoded as base64 strings 
:: --fz85: list of files whose content will be encoded as z85 strings 
:: --of: the output filename.d
:: --om: the module, fully.qua.li.fied name.

..\bin\resource.d.exe ^
--fraw=..\res\res_utf8_1.txt;..\res\res_utf8_2.txt ^
--fb16=..\res\res_ansi_1.txt;..\res\res_ansi_2.txt ^
--fb64=..\res\res_img1.png;..\res\res_img2.png ^
--fz85=..\res\res_rnd1.dat ^
--of=generate1.d ^
--om=project.resources

pause
