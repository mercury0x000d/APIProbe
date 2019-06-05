; APIProbe     DOS API Compatibility Tester
; v 1.0        Copyright 2019 by Mercury0x0D

; screen.asm is a part of APIProbe

; APIProbe is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
; version.

; APIProbe is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

; You should have received a copy of the GNU General Public License along with APIProbe. If not, see <http://www.gnu.org/licenses/>.

; See the included file <GPL License.txt> for the complete text of the GPL License by which this program is covered.





bits 16





Print:
	; Prints the string specified
	;
	;  input:
	;	String address
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	mov ah, 0x09
	mov dx, word [bp + 4]
	int 0x21


	mov sp, bp
	pop bp
ret 2





PrintCRLF:
	; Prints a blank line
	push bp
	mov bp, sp


	mov ah, 0x09
	mov dx, CRLF$
	int 0x21


	mov sp, bp
	pop bp
ret





PrintCRLF2:
	; Prints two blank lines
	push bp
	mov bp, sp


	mov ah, 0x09
	mov dx, CRLF$
	int 0x21

	mov ah, 0x09
	mov dx, CRLF$
	int 0x21


	mov sp, bp
	pop bp
ret





PrintRegs:
	; Quick register dump routine for real mode
	;
	;  input:
	;   n/a
	;
	;  output:
	;   n/a

	push bp
	mov bp, sp


	; push all once to save the registers
	pusha
	pushf

	; pusha once more for printing
	pusha

	; get di
	pop ax

	; convert it to a string
	mov bx, .output2$
	add bx, 15
	push bx
	push ax
	call ConvertWordToHexString16


	; get si
	pop ax

	; convert it to a string
	mov bx, .output2$
	add bx, 4
	push bx
	push ax
	call ConvertWordToHexString16


	; get bp
	pop ax

	; convert it to a string
	mov bx, .output2$
	add bx, 37
	push bx
	push ax
	call ConvertWordToHexString16


	; get sp
	pop ax

	; convert it to a string
	mov bx, .output2$
	add bx, 26
	push bx
	push ax
	call ConvertWordToHexString16


	; get bx
	pop ax

	; convert it to a string
	mov bx, .output1$
	add bx, 15
	push bx
	push ax
	call ConvertWordToHexString16


	; get dx
	pop ax

	; convert it to a string
	mov bx, .output1$
	add bx, 37
	push bx
	push ax
	call ConvertWordToHexString16


	; get cx
	pop ax

	; convert it to a string
	mov bx, .output1$
	add bx, 26
	push bx
	push ax
	call ConvertWordToHexString16


	; get ax
	pop ax

	; convert it to a string
	mov bx, .output1$
	add bx, 4
	push bx
	push ax
	call ConvertWordToHexString16

	mov dx, .output1$
	mov ah, 0x09
	int 0x21

	mov dx, .output2$
	mov ah, 0x09
	int 0x21

	popf
	popa


	mov sp, bp
	pop bp
ret
.output1$										db ' AX 0000    BX 0000    CX 0000    DX 0000 $'
.output2$										db ' SI 0000    DI 0000    SP 0000    BP 0000 $'
