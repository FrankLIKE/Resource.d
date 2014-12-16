
:: test for huge resources. main() is added to test the compilation.
:: produces a 47Mb obj, seems to be the top limit for optlink.

..\bin\resource.d.exe ^
-v ^
-m ^
--of=big_fat_res.d ^
--om=big.fat.res ^
--itms=^
..\bin\resource.d.exe%%resource_1%%""%%z85;^
..\bin\resource.d.exe%%resource_2%%""%%base64;^
..\bin\resource.d.exe%%resource_3%%""%%base16;^
..\bin\resource.d.exe%%resource_4%%""%%z85;^
..\bin\resource.d.exe%%resource_5%%""%%base64;^
..\bin\resource.d.exe%%resource_6%%""%%base16;^
..\bin\resource.d.exe%%resource_7%%""%%z85;^
..\bin\resource.d.exe%%resource_8%%""%%base64;^
..\bin\resource.d.exe%%resource_9%%""%%base16;^
..\bin\resource.d.exe%%resource_10%%""%%z85;^
..\bin\resource.d.exe%%resource_11%%""%%base64;^
..\bin\resource.d.exe%%resource_12%%""%%base16;^
..\bin\resource.d.exe%%resource_13%%""%%z85;^
..\bin\resource.d.exe%%resource_14%%""%%base64;^
..\bin\resource.d.exe%%resource_15%%""%%base16;^
..\bin\resource.d.exe%%resource_16%%""%%z85;^
..\bin\resource.d.exe%%resource_17%%""%%base64;^
..\bin\resource.d.exe%%resource_18%%""%%base16;^
..\bin\resource.d.exe%%resource_19%%""%%z85;^
..\bin\resource.d.exe%%resource_20%%""%%base64;^
..\bin\resource.d.exe%%resource_21%%""%%base16;^
..\bin\resource.d.exe%%resource_22%%""%%z85;^
..\bin\resource.d.exe%%resource_23%%""%%base64;^
..\bin\resource.d.exe%%resource_24%%""%%base16;^
..\bin\resource.d.exe%%resource_25%%""%%z85;^
..\bin\resource.d.exe%%resource_26%%""%%base64;^
..\bin\resource.d.exe%%resource_27%%""%%base16;^
..\bin\resource.d.exe%%resource_28%%""%%z85;^
..\bin\resource.d.exe%%resource_29%%""%%base64;^
..\bin\resource.d.exe%%resource_30%%""%%base16;^
..\bin\resource.d.exe%%resource_31%%""%%z85;^
..\bin\resource.d.exe%%resource_32%%""%%base64;^
..\bin\resource.d.exe%%resource_33%%""%%base16;^
..\bin\resource.d.exe%%resource_34%%""%%z85;^
..\bin\resource.d.exe%%resource_35%%""%%base64;^
..\bin\resource.d.exe%%resource_36%%""%%base16;^
..\bin\resource.d.exe%%resource_37%%""%%z85;^
..\bin\resource.d.exe%%resource_38%%""%%base64;^
..\bin\resource.d.exe%%resource_39%%""%%base16;^
..\bin\resource.d.exe%%resource_40%%""%%z85;^
..\bin\resource.d.exe%%resource_41%%""%%base64;^
..\bin\resource.d.exe%%resource_42%%""%%base16;^
..\bin\resource.d.exe%%resource_43%%""%%z85;^
..\bin\resource.d.exe%%resource_44%%""%%base64;^
..\bin\resource.d.exe%%resource_45%%""%%base16;^
..\bin\resource.d.exe%%resource_46%%""%%z85;^
..\bin\resource.d.exe%%resource_47%%""%%base64;^
..\bin\resource.d.exe%%resource_48%%""%%base16;^
..\bin\resource.d.exe%%resource_49%%""%%z85;^
..\bin\resource.d.exe%%resource_50%%""%%base64;^
..\bin\resource.d.exe%%resource_51%%""%%base16;^
..\bin\resource.d.exe%%resource_52%%""%%z85;^
..\bin\resource.d.exe%%resource_53%%""%%base64;^
..\bin\resource.d.exe%%resource_54%%""%%base16;^
..\bin\resource.d.exe%%resource_55%%""%%z85;^
..\bin\resource.d.exe%%resource_56%%""%%base64;^
..\bin\resource.d.exe%%resource_57%%""%%base16;^
..\bin\resource.d.exe%%resource_58%%""%%z85;^
..\bin\resource.d.exe%%resource_59%%""%%base64;^
..\bin\resource.d.exe%%resource_60%%""%%base16;^
..\bin\resource.d.exe%%resource_61%%""%%z85;^
..\bin\resource.d.exe%%resource_62%%""%%base64;^
..\bin\resource.d.exe%%resource_63%%""%%base16;^
..\bin\resource.d.exe%%resource_64%%""%%z85;^
..\bin\resource.d.exe%%resource_65%%""%%base64;^
..\bin\resource.d.exe%%resource_66%%""%%base16;^
..\bin\resource.d.exe%%resource_61%%""%%z85;^
..\bin\resource.d.exe%%resource_62%%""%%base64;^
..\bin\resource.d.exe%%resource_63%%""%%base16;^
..\bin\resource.d.exe%%resource_65%%""%%z85;^
..\bin\resource.d.exe%%resource_66%%""%%base64;^
..\bin\resource.d.exe%%resource_67%%""%%base16;

pause
