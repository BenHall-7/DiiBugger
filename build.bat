
@echo off
chdir wiiu_code
C:\SysGCC\powerpc-eabi\bin\powerpc-eabi-as -o entrypoint2.o entrypoint2.S
C:\ghs\multi534\ccppc.exe -c -Iinclude -o server.o -Ogeneral server.cpp
C:\SysGCC\powerpc-eabi\bin\powerpc-eabi-ld -o server.bin -T server.ld entrypoint2.o server.o
python build_header.py
C:\SysGCC\powerpc-eabi\bin\powerpc-eabi-as -o entrypoint.o entrypoint.S
C:\ghs\multi534\ccppc.exe -c -Iinclude -o installer.o -Ogeneral installer.cpp
C:\SysGCC\powerpc-eabi\bin\powerpc-eabi-ld -o code.bin -T installer.ld entrypoint.o installer.o
copy code.bin C:\xampp\htdocs\debugger\code.bin
cd ..
pause
