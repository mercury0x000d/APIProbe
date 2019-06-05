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
	;	EDX - Result
	;		true - the regions are identical
	;		false - the regions are different

	push bp
	mov bp, sp


	mov esi, [bp + 8]
	mov edi, [bp + 12]
	mov ecx, [bp + 16]

	; set the result to possibly be changed if necessary later
	mov edx, false

	cmp ecx, 0
	je .Exit

	repe cmpsb
	jnz .Exit

	mov edx, true


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


	mov esi, [bp + 8]
	mov edi, [bp + 12]
	mov ecx, [bp + 16]

	; to copy at top speed, we will break the copy operation into two parts
	; first, we'll see how many multiples of 16 need transferred, and do those in 16-byte chunks

	; divide by 8
	shr ecx, 3

	; make sure the loop doesn't get executed if the counter is zero
	cmp ecx, 0
	je .ChunkLoopDone

	; do the copy
	.ChunkLoop:
		; read 8 bytes in
		mov eax, [esi]
		add esi, 4
		mov ebx, [esi]
		add esi, 4

		; write them out
		mov [edi], eax
		add edi, 4
		mov [edi], ebx
		add edi, 4
	loop .ChunkLoop
	.ChunkLoopDone:

	; now restore the transfer amount
	mov ecx, [bp + 16]
	; see how many bytes we have remaining
	and ecx, 0x00000007

	; make sure the loop doesn't get executed if the counter is zero
	cmp ecx, 0
	je .Exit

	; and do the copy
	.ByteLoop:
		lodsb
		mov byte [edi], al
		inc edi	
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


	mov esi, [bp + 8]
	mov ecx, [bp + 12]
	mov ebx, [bp + 16]

	mov edi, esi
	add edi, ecx

	.FillLoop:
		cmp esi, edi
		je .Exit
		mov byte [esi], bl
		inc esi
	jmp .FillLoop


	.Exit:
	mov sp, bp
	pop bp
ret 6
