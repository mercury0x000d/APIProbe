; APIProbe     DOS API Compatibility Tester
; v 1.0        Copyright 2019 by Mercury0x0D

; main.asm is a part of APIProbe

; APIProbe is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
; version.

; APIProbe is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

; You should have received a copy of the GNU General Public License along with APIProbe. If not, see <http://www.gnu.org/licenses/>.

; See the included file <GPL License.txt> for the complete text of the GPL License by which this program is covered.





[map all APIProbe.map]
bits 16
org 0x0100





; defines...
%define true									1
%define false									0
%define BUILD 95





section .text
main:
	; introduce ourselves!
	call PrintCRLF

	push .greeting1$
	call Print

	push 80
	push temp$
	push .greeting2$
	call MemCopy

	push word 3
	push BUILD
	push temp$
	call StringTokenDecimal

	push temp$
	call Print



	; start ye olde tests
	call PrintCRLF2
	call Test0100

	call PrintCRLF2
	call Test0200

	call PrintCRLF2
	call Test0300

	call PrintCRLF2
	call Test0400

	call PrintCRLF2
	call Test0500

;	call PrintCRLF2
;	call Test1800
;
;	call PrintCRLF2
;	call Test1D00
;
;	call PrintCRLF2
;	call Test1E00
;
;	call PrintCRLF2
;	call Test2000
;
	call PrintCRLF2
	call Test3000

;	call PrintCRLF2
;	call Test6100
;
;	call PrintCRLF2
;	call Test6B00


	.Exit:
	; testing is all done!
	call PrintCRLF

	push .goodbye$
	call Print
ret

section .data
.greeting1$										db 'APIProbe     DOS API Compatibility Tester$'
.greeting2$										db '1.0.^      Copyright 2019 by Mercury0x0D$', 0
.goodbye$										db 'Testing complete.$'





; globals...
section .bss
temp$											resb 80

section .data
CRLF$											db 0x0D, 0x0A, '$'
msgTestFailed$									db 'Function testing failed$'
msgTestPassed$									db 'Function testing passed$'
msgDOSMayIntervene$								db 'You may see DOS intervene here if this device is unavailable.$'
msgFunctionNotCounted$							db 'This function is not counted towards the compatibility totals.$'

traitMSDOS110									dw 0x0000
traitMSDOS111									dw 0x0000
traitMSDOS114									dw 0x0000
traitMSDOS124									dw 0x0000
traitMSDOS125									dw 0x0000
traitMSDOS200									dw 0x0000
traitMSDOS205									dw 0x0000
traitMSDOS210									dw 0x0000
traitMSDOS211									dw 0x0000
traitMSDOS220									dw 0x0000
traitMSDOS225									dw 0x0000
traitMSDOS300									dw 0x0000
traitMSDOS310									dw 0x0000
traitMSDOS320									dw 0x0000
traitMSDOS321									dw 0x0000
traitMSDOS322									dw 0x0000
traitMSDOS325									dw 0x0000
traitMSDOS330									dw 0x0000
traitMSDOS330A									dw 0x0000
traitMSDOS331									dw 0x0000
traitMSDOS400Multi								dw 0x0000	; (Multitasking)
traitMSDOS400									dw 0x0000
traitMSDOS401									dw 0x0000
traitMSDOS401A									dw 0x0000
traitMSDOS500									dw 0x0000
traitMSDOS500A									dw 0x0000
traitMSDOS550									dw 0x0000	; (NTVDM)
traitMSDOS600									dw 0x0000
traitMSDOS620									dw 0x0000
traitMSDOS621									dw 0x0000
traitMSDOS622									dw 0x0000
traitMSDOS700									dw 0x0000	; (Windows 95)
traitMSDOS710									dw 0x0000	; (Windows 95)
traitMSDOS800									dw 0x0000	; (windows ME)

traitNWDOS										dw 0x0000	; (Novell DOS 7)

traitFreeDOS									dw 0x0000



; includes follow
%include "include/memory.asm"
%include "include/screen.asm"
%include "include/strings.asm"










section .text
KeyboardBufferClear:
	; Clears the keyboard buffer

	; save the current data segment
	push ds

	; clear the buffer by setting the start pointer equal to the end pointer
	mov ax, 0
	mov ds, ax
	mov bx, 0x041C
	mov ax, word [bx]
	mov bx, 0x041A
	mov [bx], ax

	; restore the data segment
	pop ds
ret




section .text
KeyboardBufferInsert:
	; Inserts a character into the keyboard buffer
	;
	;  input:
	;	Character to be inserted
	;
	;  output:
	;	al - Status

	push bp
	mov bp, sp


	mov ah, 0x05
	mov cx, word [bp + 4]
	int 0x16


	mov sp, bp
	pop bp
ret 2





section .text
Test0100:
	push bp
	mov bp, sp


	push .testing$
	call Print

	; clear the buffer
	call KeyboardBufferClear

	; push an "A" into the keyboard buffer
	push 65
	call KeyboardBufferInsert

	; see if we get a key back - this time we should get an "A"
	mov ax, 0x0100
	int 0x21

	cmp al, 65
	je .Check2
		; if we get here, it wasn't an "A" we got back...
		call PrintCRLF
		push msgTestFailed$
		call Print

		push .msgFailInfo2$
		call Print 

		jmp .Exit

	.Check2:
	; push a "B" into the keyboard buffer
	push 66
	call KeyboardBufferInsert

	; now we should get a "B" back
	mov ax, 0x0100
	int 0x21

	cmp al, 66
	je .Passed
		; if we get here, IT'S THE WRONG KEY, JOHNNY!
		call PrintCRLF
		push msgTestFailed$
		call Print

		push .msgFailInfo2$
		call Print 

		jmp .Exit

	.Passed:
	call PrintCRLF
	push msgTestPassed$
	call Print
	call TraitAll


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x0100 - Read char from STDIN with echo$'
.msgFailInfo1$									db 'A key was returned when there should have been none.$'
.msgFailInfo2$									db 'The key returned was not the one provided.$'





section .text
Test0200:
	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 4
	%define behaviourFlagA						word [bp - 2]
	%define behaviourFlagB						word [bp - 4]


	; assume behavioural success
	mov behaviourFlagA, true
	mov behaviourFlagB, true

	push .testing$
	call Print

	; clear the buffer
	call KeyboardBufferClear

	; write an "A"
	; to the display
	mov ax, 0x0200
	mov dl, 65
	int 0x21

	cmp al, 65
	je .Check2
		; if we get here, al does not contain the code of the last character written
		mov behaviourFlagA, false

	.Check2:
	; clear the buffer
	call KeyboardBufferClear

	; write a tab
	; in a way most fab
	mov ax, 0x0200
	mov dl, 9
	int 0x21

	cmp al, 32
	je .Check3
		; if we get here, al does not contain the code of the last character written
		mov behaviourFlagB, false


	.Check3:
	; clear the buffer
	call KeyboardBufferClear

	; let's write a "B"
	; where the user can see
	mov ax, 0x0200
	mov dl, 66
	int 0x21

	cmp al, 66
	je .Results
		; if we get here, al does not contain the code of the last character written
		mov behaviourFlagA, false

	.Results:
	; let's see how we did!
	call PrintCRLF

	push .msgPassInfo1$
	call Print 

	push .msgPassInfo2$
	call Print

	push .msgPassInfo3$
	call Print

	; now that the rambling is out of the way, show custom results for characters and tabs
	cmp behaviourFlagA, true
	jne .FailCharacters

		; if we get here, the proper behaviour was observed for characters
		push .msgPassChar$
		call Print

		inc word [traitMSDOS210]
		inc word [traitMSDOS211]
		inc word [traitMSDOS220]
		inc word [traitMSDOS225]
		call TraitMSDOS3
		inc word [traitMSDOS400Multi]
		call TraitMSDOS4
		call TraitMSDOS5
		call TraitMSDOS6
		inc word [traitMSDOS700]
		inc word [traitFreeDOS]
		jmp .CheckTabs

	.FailCharacters:
	push .msgFailChar$
	call Print

	call TraitMSDOS1
	inc word [traitMSDOS200]
	inc word [traitMSDOS205]

	.CheckTabs:
	cmp behaviourFlagB, true
	jne .FailTabs

		; if we get here, the proper behaviour was observed for tabs
		push .msgPassTab$
		call Print
		inc word [traitMSDOS210]
		inc word [traitMSDOS211]
		inc word [traitMSDOS220]
		inc word [traitMSDOS225]
		call TraitMSDOS3
		inc word [traitMSDOS400Multi]
		call TraitMSDOS4
		call TraitMSDOS5
		call TraitMSDOS6
		inc word [traitMSDOS700]
		jmp .Exit

	.FailTabs:
	push .msgFailTab$
	call Print

	call TraitMSDOS1
	inc word [traitMSDOS200]
	inc word [traitMSDOS205]
	inc word [traitFreeDOS]


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x0200 - Write character to STDOUT$'
.msgPassInfo1$									db 'Although this function returns nothing officially, multiple DOS implementations$'
.msgPassInfo2$									db '(at least MS-DOS 2.10 through 7.00) have been observed to contain the ASCII$'
.msgPassInfo3$									db 'code in AL of the character printed, or ASCII code 32 for tabs.$'
.msgPassChar$									db 'This DOS successfully exhibited this behaviour for regular characters.$'
.msgPassTab$									db 'This DOS successfully exhibited this behaviour for tab characters.$'
.msgFailChar$									db 'This DOS failed to exhibit this behaviour for regular characters.$'
.msgFailTab$									db 'This DOS failed to exhibit this behaviour for tab characters.$'





section .text
Test0300:
	push bp
	mov bp, sp


	push .testing$
	call Print

	push msgDOSMayIntervene$
	call Print

	push msgFunctionNotCounted$
	call Print

	; try the function
	mov ax, 0x0300
	int 0x21


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x0300 - Read character from STDAUX$'
.msgInfo1$										db 'This function attempts to read from the AUX device - usually the serial port.$'





section .text
Test0400:
	push bp
	mov bp, sp


	push .testing$
	call Print

	push msgDOSMayIntervene$
	call Print

	push msgFunctionNotCounted$
	call Print

	; try the function
	mov ax, 0x0400
	int 0x21


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x0400 - Write character to STDAUX$'
.msgInfo1$										db 'This function attempts to write to the AUX device - usually the serial port.$'





section .text
Test0500:
	push bp
	mov bp, sp


	push .testing$
	call Print

	push msgDOSMayIntervene$
	call Print

	push msgFunctionNotCounted$
	call Print

	; try the function
	mov ax, 0x0500
	int 0x21


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x0500 - Write character to STDPRN$'
.msgInfo1$										db 'This function attempts to write to the PRN device - usually the parallel port.$'





section .text
Test1800:
	push bp
	mov bp, sp


	push .testing$
	call Print

	; this should return with all registers unchanged
	mov ax, 0x1800
	pusha
	int 0x21

	; save registers again
	pusha

	; see if any registers except SP were changed
	call TestRegisterSetsMatch
	cmp al, true
	jne .Fail

	; if we get here, they matched
	push msgTestPassed$
	call Print
	jmp .Exit

	.Fail:
	push msgTestFailed$
	call Print

	push .msgFailInfo1$
	call Print


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x1800 - Reserved$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.$'





section .text
Test1D00:
	push bp
	mov bp, sp


	push .testing$
	call Print

	; this should return with all registers unchanged
	mov ax, 0x1D00
	pusha
	int 0x21

	; save registers again
	pusha

	; see if any registers except SP were changed
	call TestRegisterSetsMatch
	cmp al, true
	jne .Fail

	; if we get here, they matched
	push msgTestPassed$
	call Print
	jmp .Exit

	.Fail:
	push msgTestFailed$
	call Print

	push .msgFailInfo1$
	call Print


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x1D00 - Reserved$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.$'





section .text
Test1E00:
	push bp
	mov bp, sp


	push .testing$
	call Print

	; this should return with all registers unchanged
	mov ax, 0x1E00
	pusha
	int 0x21

	; save registers again
	pusha

	; see if any registers except SP were changed
	call TestRegisterSetsMatch
	cmp al, true
	jne .Fail

	; if we get here, they matched
	push msgTestPassed$
	call Print
	jmp .Exit

	.Fail:
	push msgTestFailed$
	call Print

	push .msgFailInfo1$
	call Print


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x1E00 - Reserved$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.$'





section .text
Test2000:
	push bp
	mov bp, sp


	push .testing$
	call Print

	; this should return with all registers unchanged
	mov ax, 0x2000
	pusha
	int 0x21

	; save registers again
	pusha

	; see if any registers except SP were changed
	call TestRegisterSetsMatch
	cmp al, true
	jne .Fail

	; if we get here, they matched
	push msgTestPassed$
	call Print
	jmp .Exit

	.Fail:
	push msgTestFailed$
	call Print

	push .msgFailInfo1$
	call Print


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x2000 - Reserved$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.$'





section .text
Test3000:
	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 4
	%define versionMajor						word [bp - 2]
	%define versionMinor						word [bp - 4]


	push .testing$
	call Print

	; get DOS version
	mov ax, 0x3000
	int 0x21

	; save the version for later
	mov cx, 0
	mov cl, al
	mov versionMajor, cx
	mov cl, ah
	mov versionMinor, cx


	; determine who the OEM is
	cmp bh, 0x00
	jne .Not00
		push .OEM00
		jmp .PrintOEM
	.Not00:

	cmp bh, 0x01
	jne .Not01
		push .OEM01
		jmp .PrintOEM
	.Not01:

	cmp bh, 0x02
	jne .Not02
		push .OEM02
		jmp .PrintOEM
	.Not02:

	cmp bh, 0x04
	jne .Not04
		push .OEM04
		jmp .PrintOEM
	.Not04:

	cmp bh, 0x05
	jne .Not05
		push .OEM05
		jmp .PrintOEM
	.Not05:

	cmp bh, 0x06
	jne .Not06
		push .OEM06
		jmp .PrintOEM
	.Not06:

	cmp bh, 0x07
	jne .Not07
		push .OEM07
		jmp .PrintOEM
	.Not07:

	cmp bh, 0x08
	jne .Not08
		push .OEM08
		jmp .PrintOEM
	.Not08:

	cmp bh, 0x09
	jne .Not09
		push .OEM09
		jmp .PrintOEM
	.Not09:

	cmp bh, 0x0A
	jne .Not0A
		push .OEM0A
		jmp .PrintOEM
	.Not0A:

	cmp bh, 0x0B
	jne .Not0B
		push .OEM0B
		jmp .PrintOEM
	.Not0B:

	cmp bh, 0x0C
	jne .Not0C
		push .OEM0C
		jmp .PrintOEM
	.Not0C:

	cmp bh, 0x0D
	jne .Not0D
		push .OEM0D
		jmp .PrintOEM
	.Not0D:

	cmp bh, 0x0E
	jne .Not0E
		push .OEM0E
		jmp .PrintOEM
	.Not0E:

	cmp bh, 0x0F
	jne .Not0F
		push .OEM0F
		jmp .PrintOEM
	.Not0F:

	cmp bh, 0x10
	jne .Not10
		push .OEM10
		jmp .PrintOEM
	.Not10:

	cmp bh, 0x16
	jne .Not16
		push .OEM16
		jmp .PrintOEM
	.Not16:

	cmp bh, 0x17
	jne .Not17
		push .OEM17
		jmp .PrintOEM
	.Not17:

	cmp bh, 0x23
	jne .Not23
		push .OEM23
		jmp .PrintOEM
	.Not23:

	cmp bh, 0x28
	jne .Not28
		push .OEM28
		jmp .PrintOEM
	.Not28:

	cmp bh, 0x29
	jne .Not29
		push .OEM29
		jmp .PrintOEM
	.Not29:

	cmp bh, 0x33
	jne .Not33
		push .OEM33
		jmp .PrintOEM
	.Not33:

	cmp bh, 0x34
	jne .Not34
		push .OEM34
		jmp .PrintOEM
	.Not34:

	cmp bh, 0x35
	jne .Not35
		push .OEM35
		jmp .PrintOEM
	.Not35:

	cmp bh, 0x4D
	jne .Not4D
		push .OEM4D
		jmp .PrintOEM
	.Not4D:

	cmp bh, 0x5E
	jne .Not5E
		push .OEM5E
		jmp .PrintOEM
	.Not5E:

	cmp bh, 0x66
	jne .Not66
		push .OEM66
		jmp .PrintOEM
	.Not66:

	cmp bh, 0x88
	jne .Not88
		push .OEM88
		jmp .PrintOEM
	.Not88:

	cmp bh, 0x99
	jne .Not99
		push .OEM99
		jmp .PrintOEM
	.Not99:

	cmp bh, 0xCD
	jne .NotCD
		push .OEMCD
		jmp .PrintOEM
	.NotCD:

	cmp bh, 0xED
	jne .NotED
		push .OEMED
		jmp .PrintOEM
	.NotED:

	cmp bh, 0xEE
	jne .NotEE
		push .OEMEE
		jmp .PrintOEM
	.NotEE:

	cmp bh, 0xEF
	jne .NotEF
		push .OEMEF
		jmp .PrintOEM
	.NotEF:

	cmp bh, 0xFD
	jne .NotFD
		push .OEMFD
		jmp .PrintOEM
	.NotFD:

	cmp bh, 0xFF
	jne .NotFF
		push .OEMFF
		jmp .PrintOEM
	.NotFF:

	; if we get here, there's an undefined OEM afoot!
	push .OEMUndefined

	.PrintOEM:
	push .msgOutput1$
	call PrintNoCRLF

	call Print


	; print version number
	push 80
	push temp$
	push .msgOutput2$
	call MemCopy

	push word 0
	push versionMajor
	push temp$
	call StringTokenDecimal

	push word 2
	push versionMinor
	push temp$
	call StringTokenDecimal

	push temp$
	call Print


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x3000 - Get DOS version$'
.msgOutput1$									db 'Reported OEM is $'
.msgOutput2$									db 'Reported version is ^.^$', 0
.OEM00											db 'IBM$'
.OEM01											db 'Compaq$'
.OEM02											db 'MS Packaged Product$'
.OEM04											db 'AT&T$'
.OEM05											db 'ZDS (Zenith Electronics)$'
.OEM06											db 'Hewlett Packard$'
.OEM07											db 'Zenith Data Systems (ZDS, Groupe Bull), for DOS 5.0+$'
.OEM08											db 'Tandon$'
.OEM09											db 'AST Europe Limited$'
.OEM0A											db 'Asem$'
.OEM0B											db 'Hantarex$'
.OEM0C											db 'SystemsLine$'
.OEM0D											db 'Packard Bell$'
.OEM0E											db 'Intercomp$'
.OEM0F											db 'Unibit$'
.OEM10											db 'Unidata$'
.OEM16											db 'DEC$'
.OEM17											db 'Olivetti DOS$'
.OEM23											db 'Olivetti$'
.OEM28											db 'Texas Instruments$'
.OEM29											db 'Toshiba$'
.OEM33											db 'Novell$'
.OEM34											db 'MS Multimedia Systems$'
.OEM35											db 'MS Multimedia Systems$'
.OEM4D											db 'Hewlett-Packard$'
.OEM5E											db 'RxDOS$'
.OEM66											db 'PTS-DOS$'
.OEM88											db 'Night Kernel$'
.OEM99											db 'General Software Embedded DOS$'
.OEMCD											db 'Paragon Technology Systems Corporation (Source DOS S/DOS 1.0+)$'
.OEMED											db 'OpenDOS/DR-DOS$'
.OEMEE											db 'DR DOS$'
.OEMEF											db 'Novell DOS$'
.OEMFD											db 'FreeDOS$'
.OEMFF											db 'Microsoft, Phoenix (listed as undefined by Microsoft)$'
.OEMUndefined									db 'Undefined'





section .text
Test6100:
	push bp
	mov bp, sp


	push .testing$
	call Print

	; this should return with all registers unchanged
	mov ax, 0x6100
	pusha
	int 0x21

	; save registers again
	pusha

	; see if any registers except SP were changed
	call TestRegisterSetsMatch
	cmp al, true
	jne .Fail

	; if we get here, they matched
	push msgTestPassed$
	call Print
	jmp .Exit

	.Fail:
	push msgTestFailed$
	call Print

	push .msgFailInfo1$
	call Print


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x6100 - Reserved for network use$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.$'





section .text
Test6B00:
	push bp
	mov bp, sp


	push .testing$
	call Print

	; this should return with all registers unchanged
	mov ax, 0x6B00
	pusha
	int 0x21

	; save registers again
	pusha

	; see if any registers except SP were changed
	call TestRegisterSetsMatch
	cmp al, true
	jne .Fail

	; if we get here, they matched
	push msgTestPassed$
	call Print
	jmp .Exit

	.Fail:
	push msgTestFailed$
	call Print

	push .msgFailInfo1$
	call Print


	.Exit:
	mov sp, bp
	pop bp
ret

section .data
.testing$										db 'Testing interrupt 0x21 AX = 0x6B00 - Reserved$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.$'





section .text
TestRegisterSetsMatch:
	; Checks the two sets of registers already pushed to the stack Inserts a character into the keyboard buffer
	;
	;  input:
	;	Two sets of registers pushed to the stack with PUSHA
	;
	;  output:
	;	al - Status
	;		True - the register sets match
	;		False - the register sets do not match

	push bp
	mov bp, sp


	mov ax, word [bp + 4]
	mov bx, word [bp + 20]
	cmp ax, bx
	jne .Fail

	mov ax, word [bp + 6]
	mov bx, word [bp + 22]
	cmp ax, bx
	jne .Fail

	mov ax, word [bp + 8]
	mov bx, word [bp + 24]
	cmp ax, bx
	jne .Fail

	mov ax, word [bp + 12]
	mov bx, word [bp + 28]
	cmp ax, bx
	jne .Fail

	mov ax, word [bp + 14]
	mov bx, word [bp + 30]
	cmp ax, bx
	jne .Fail

	mov ax, word [bp + 16]
	mov bx, word [bp + 32]
	cmp ax, bx
	jne .Fail

	mov ax, word [bp + 18]
	mov bx, word [bp + 34]
	cmp ax, bx
	jne .Fail

	; if we get here, we have a match!
	mov al, true
	jmp .Exit

	.Fail:
	mov al, false


	.Exit:
	mov sp, bp
	pop bp
ret 32





section .text
TraitAll:
	; Adds one to all trait counters
	;
	;  input:
	;	n/a
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	inc word [traitMSDOS110]
	inc word [traitMSDOS111]
	inc word [traitMSDOS114]
	inc word [traitMSDOS124]
	inc word [traitMSDOS125]
	inc word [traitMSDOS200]
	inc word [traitMSDOS205]
	inc word [traitMSDOS210]
	inc word [traitMSDOS211]
	inc word [traitMSDOS220]
	inc word [traitMSDOS225]
	inc word [traitMSDOS300]
	inc word [traitMSDOS310]
	inc word [traitMSDOS320]
	inc word [traitMSDOS321]
	inc word [traitMSDOS322]
	inc word [traitMSDOS325]
	inc word [traitMSDOS330]
	inc word [traitMSDOS330A]
	inc word [traitMSDOS331]
	inc word [traitMSDOS400Multi]
	inc word [traitMSDOS400]
	inc word [traitMSDOS401]
	inc word [traitMSDOS401A]
	inc word [traitMSDOS500]
	inc word [traitMSDOS500A]
	inc word [traitMSDOS550]
	inc word [traitMSDOS600]
	inc word [traitMSDOS620]
	inc word [traitMSDOS621]
	inc word [traitMSDOS622]
	inc word [traitMSDOS700]
	inc word [traitMSDOS710]
	inc word [traitMSDOS800]
	inc word [traitNWDOS]
	inc word [traitFreeDOS]


	.Exit:
	mov sp, bp
	pop bp
ret





section .text
TraitMSDOS1:
	; Adds one to all trait counters for MS-DOS 1.xx
	;
	;  input:
	;	n/a
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	inc word [traitMSDOS110]
	inc word [traitMSDOS111]
	inc word [traitMSDOS114]
	inc word [traitMSDOS124]
	inc word [traitMSDOS125]


	.Exit:
	mov sp, bp
	pop bp
ret





section .text
TraitMSDOS2:
	; Adds one to all trait counters for MS-DOS 2.xx
	;
	;  input:
	;	n/a
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	inc word [traitMSDOS200]
	inc word [traitMSDOS205]
	inc word [traitMSDOS210]
	inc word [traitMSDOS211]
	inc word [traitMSDOS220]
	inc word [traitMSDOS225]


	.Exit:
	mov sp, bp
	pop bp
ret





section .text
TraitMSDOS3:
	; Adds one to all trait counters for MS-DOS 3.xx
	;
	;  input:
	;	n/a
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	inc word [traitMSDOS300]
	inc word [traitMSDOS310]
	inc word [traitMSDOS320]
	inc word [traitMSDOS321]
	inc word [traitMSDOS322]
	inc word [traitMSDOS325]
	inc word [traitMSDOS330]
	inc word [traitMSDOS330A]
	inc word [traitMSDOS331]


	.Exit:
	mov sp, bp
	pop bp
ret





section .text
TraitMSDOS4:
	; Adds one to all trait counters for MS-DOS 4.xx (but not MS-DOS 4.0 Multitasking)
	;
	;  input:
	;	n/a
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	inc word [traitMSDOS400]
	inc word [traitMSDOS401]
	inc word [traitMSDOS401A]


	.Exit:
	mov sp, bp
	pop bp
ret





section .text
TraitMSDOS5:
	; Adds one to all trait counters for MS-DOS 5.xx
	;
	;  input:
	;	n/a
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	inc word [traitMSDOS500]
	inc word [traitMSDOS500A]
	inc word [traitMSDOS550]


	.Exit:
	mov sp, bp
	pop bp
ret





section .text
TraitMSDOS6:
	; Adds one to all trait counters for MS-DOS 6.xx
	;
	;  input:
	;	n/a
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	inc word [traitMSDOS600]
	inc word [traitMSDOS620]
	inc word [traitMSDOS621]
	inc word [traitMSDOS622]


	.Exit:
	mov sp, bp
	pop bp
ret





section .text
TraitMSDOS7:
	; Adds one to all trait counters for MS-DOS 7.xx
	;
	;  input:
	;	n/a
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	inc word [traitMSDOS700]
	inc word [traitMSDOS710]


	.Exit:
	mov sp, bp
	pop bp
ret
