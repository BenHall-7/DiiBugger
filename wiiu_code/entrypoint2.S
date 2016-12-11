
.include "asm_setup.S"

#Define a macro so we don't have to repeat the same
#code in every single function we're patching
.macro patch name, stackOffs, realOffs, returnOffs
    mr r5, r31
    bl Patch_\name      #Call our own implementation
    cmpwi r3, -1        #Is it a patched file?
    bne return_\name    #If yes, return

    mr r3, r29          #Otherwise, restore
    mr r4, r30          #a few registers
    addi r5, r1, \stackOffs
    ba \name + \realOffs    #And call the real function

return_\name:
    ba \name + \returnOffs
.endm

#FS functions are always at the same address, so we
#can simply define constants for their addresses
#This is not possible with SAVE functions
.set FSGetStat, 0x01070810
.set FSOpenFile, 0x0106F9C4
.set FSReadFile, 0x0106FB50
.set FSWriteFile, 0x0106FC70
.set FSCloseFile, 0x0106FAD0
.set FSSetPosFile, 0x0106FF78
.set FSReadFileWithPos, 0x0106FBDC
.set FSGetStatFile, 0x0106FFE8

_start:
	b _main__FiPPc
	b GetStat
    b OpenFile
    b ReadFile
    b CloseFile
    b SetPosFile
    b GetStatFile
    b OpenSaveFile
    b WriteFile
    b ReadFileWithPos

GetStat:
    mr r29, r3  #The patched instruction
    patch FSGetStat, 8, 0x28, 0x5C

OpenFile:
    mr r30, r4
    patch FSOpenFile, 8, 0x2C, 0x64

ReadFile:
    mr r30, r4
    patch FSReadFile, 0xC, 0x34, 0x78

WriteFile:
    mr r30, r4
    patch FSWriteFile, 0xC, 0x34, 0x78

CloseFile:
    mr r29, r3
    patch FSCloseFile, 8, 0x30, 0x60

SetPosFile:
    mr r29, r3
    patch FSSetPosFile, 8, 0x28, 0x5C

ReadFileWithPos:
    mr r30, r4
    patch FSReadFileWithPos, 0x10, 0x38, 0x80

GetStatFile:
    mr r29, r3
    patch FSGetStatFile, 8, 0x28, 0x5C

OpenSaveFile:
    mr r22, r3          #The
    mflr r0             #patched
    stw r0, 0x54(r1)    #instructions
    mr r29, r9

    bl Patch_SAVEOpenFile
    mtlr r3     #Patch_SAVEOpenFile returns the address
                #where execution should be continued
    li r3, 0    #Return OK
    blr
