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
%define BUILD 61






















main:
	; introduce ourselves!
	call PrintCRLF

	push .greeting1$
	call Print

	push .greeting2$
	call Print


	; start ye olde tests
	call PrintCRLF2
	call Test0100

	call PrintCRLF2
	call Test0200

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
.greeting1$										db 'APIProbe     DOS API Compatibility Tester', 0x0D, 0x0A, '$'
.greeting2$										db 'v 1.0        Copyright 2019 by Mercury0x0D', 0x0D, 0x0A, '$'
.goodbye$										db 'Testing complete.', 0x0D, 0x0A, '$'





; globals...
CRLF$											db 0x0D, 0x0A, '$'
msgTestFailed$									db 'Function testing failed', 0x0D, 0x0A, '$'
msgTestPassed$									db 'Function testing passed', 0x0D, 0x0A, '$'

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
.testing$										db 'Testing interrupt 0x21 AX = 0x0100 - Read char from STDIN with echo', 0x0D, 0x0A, '$'
.msgFailInfo1$									db 'A key was returned when there should have been none.', 0x0D, 0x0A, '$'
.msgFailInfo2$									db 'The key returned was not the one provided.', 0x0D, 0x0A, '$'





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
.testing$										db 'Testing interrupt 0x21 AX = 0x0200 - Write character to STDOUT', 0x0D, 0x0A, '$'
.msgPassInfo1$									db 'Although this function returns nothing officially, multiple DOS implementations', 0x0D, 0x0A, '$'
.msgPassInfo2$									db '(at least MS-DOS 2.10 through 7.00) have been observed to contain the ASCII', 0x0D, 0x0A, '$'
.msgPassInfo3$									db 'code in AL of the character printed, or ASCII code 32 for tabs.', 0x0D, 0x0A, '$'
.msgPassChar$									db 'This DOS successfully exhibited this behaviour for regular characters.', 0x0D, 0x0A, '$'
.msgPassTab$									db 'This DOS successfully exhibited this behaviour for tab characters.', 0x0D, 0x0A, '$'
.msgFailChar$									db 'This DOS failed to exhibit this behaviour for regular characters.', 0x0D, 0x0A, '$'
.msgFailTab$									db 'This DOS failed to exhibit this behaviour for tab characters.', 0x0D, 0x0A, '$'





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
.testing$										db 'Testing interrupt 0x21 AX = 0x1800 - Reserved', 0x0D, 0x0A, '$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.', 0x0D, 0x0A, '$'





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
.testing$										db 'Testing interrupt 0x21 AX = 0x1D00 - Reserved', 0x0D, 0x0A, '$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.', 0x0D, 0x0A, '$'





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
.testing$										db 'Testing interrupt 0x21 AX = 0x1E00 - Reserved', 0x0D, 0x0A, '$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.', 0x0D, 0x0A, '$'





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
.testing$										db 'Testing interrupt 0x21 AX = 0x2000 - Reserved', 0x0D, 0x0A, '$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.', 0x0D, 0x0A, '$'





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
.testing$										db 'Testing interrupt 0x21 AX = 0x6100 - Reserved for network use', 0x0D, 0x0A, '$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.', 0x0D, 0x0A, '$'





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
.testing$										db 'Testing interrupt 0x21 AX = 0x6B00 - Reserved', 0x0D, 0x0A, '$'
.msgFailInfo1$									db 'This function should return immediately, but one or more registers were changed.', 0x0D, 0x0A, '$'





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
