; APIProbe     DOS API Compatibility Tester
; v 1.0        Copyright 2019 by Mercury0x0D

; memory.asm is a part of APIProbe

; APIProbe is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
; version.

; APIProbe is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

; You should have received a copy of the GNU General Public License along with APIProbe. If not, see <http://www.gnu.org/licenses/>.

; See the included file <GPL License.txt> for the complete text of the GPL License by which this program is covered.





bits 16





section .text
MemCompare:
	; Compares two regions in memory of a specified length for equality
	;
	;  input:
	;	Region 1 address
	;	Region 2 address
	;	Comparison length
	;
	;  output:
	;	DX - Result
	;		true - the regions are identical
	;		false - the regions are different

	push bp
	mov bp, sp


	mov si, [bp + 4]
	mov di, [bp + 6]
	mov cx, [bp + 8]

	; set the result to possibly be changed if necessary later
	mov dx, false

	cmp cx, 0
	je .Exit

	repe cmpsb
	jnz .Exit

	mov dx, true


	.Exit:
	mov sp, bp
	pop bp
ret 6





section .text
MemCopy:
	; Copies the specified number of bytes from one address to another in a "left to right" manner (e.g. lowest address to highest)
	;
	;  input:
	;	Source address
	;	Destination address
	;	Transfer length
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	mov si, [bp + 4]
	mov di, [bp + 6]
	mov cx, [bp + 8]

	; to copy at top speed, we will break the copy operation into two parts
	; first, we'll see how many multiples of 16 need transferred, and do those in 16-byte chunks

	; divide by 8
	shr cx, 3

	; make sure the loop doesn't get executed if the counter is zero
	cmp cx, 0
	je .ChunkLoopDone

	; do the copy
	.ChunkLoop:
		; read 8 bytes in
		mov eax, [si]
		add si, 4
		mov ebx, [si]
		add si, 4

		; write them out
		mov [di], eax
		add di, 4
		mov [di], ebx
		add di, 4
	loop .ChunkLoop
	.ChunkLoopDone:

	; now restore the transfer amount
	mov cx, [bp + 8]
	; see how many bytes we have remaining
	and cx, 0x00000007

	; make sure the loop doesn't get executed if the counter is zero
	cmp cx, 0
	je .Exit

	; and do the copy
	.ByteLoop:
		lodsb
		mov byte [di], al
		inc di	
	loop .ByteLoop


	.Exit:
	mov sp, bp
	pop bp
ret 6





section .text
MemFill:
	; Fills the range of memory given with the byte value specified
	;
	;  input:
	;	Address
	;	Length
	;	Byte value
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	mov si, [bp + 4]
	mov cx, [bp + 6]
	mov bx, [bp + 8]

	mov di, si
	add di, cx

	.FillLoop:
		cmp si, di
		je .Exit
		mov byte [si], bl
		inc si
	jmp .FillLoop


	.Exit:
	mov sp, bp
	pop bp
ret 6
