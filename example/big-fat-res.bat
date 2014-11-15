
:: test for huge resources. main() is added for testing compilation.
:: currently can be compiled but not linked. (48 MB obj file crashes optlink)

..\bin\resource.d.exe ^
-v ^
-m ^
--of=big_fat_res.d ^
--om=big.fat.res ^
--itms=^
..\bin\resource.d.exe%%resource_1%%z85;^
..\bin\resource.d.exe%%resource_2%%base64;^
..\bin\resource.d.exe%%resource_3%%base16;^
..\bin\resource.d.exe%%resource_4%%z85;^
..\bin\resource.d.exe%%resource_5%%base64;^
..\bin\resource.d.exe%%resource_6%%base16;^
..\bin\resource.d.exe%%resource_7%%z85;^
..\bin\resource.d.exe%%resource_8%%base64;^
..\bin\resource.d.exe%%resource_9%%base16;^
..\bin\resource.d.exe%%resource_10%%z85;^
..\bin\resource.d.exe%%resource_11%%base64;^
..\bin\resource.d.exe%%resource_12%%base16;^
..\bin\resource.d.exe%%resource_13%%z85;^
..\bin\resource.d.exe%%resource_14%%base64;^
..\bin\resource.d.exe%%resource_15%%base16;^
..\bin\resource.d.exe%%resource_16%%z85;^
..\bin\resource.d.exe%%resource_17%%base64;^
..\bin\resource.d.exe%%resource_18%%base16;^
..\bin\resource.d.exe%%resource_19%%z85;^
..\bin\resource.d.exe%%resource_20%%base64;^
..\bin\resource.d.exe%%resource_21%%base16;^
..\bin\resource.d.exe%%resource_22%%z85;^
..\bin\resource.d.exe%%resource_23%%base64;^
..\bin\resource.d.exe%%resource_24%%base16;^
..\bin\resource.d.exe%%resource_25%%z85;^
..\bin\resource.d.exe%%resource_26%%base64;^
..\bin\resource.d.exe%%resource_27%%base16;^
..\bin\resource.d.exe%%resource_28%%z85;^
..\bin\resource.d.exe%%resource_29%%base64;^
..\bin\resource.d.exe%%resource_30%%base16

pause
