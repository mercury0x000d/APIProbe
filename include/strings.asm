; APIProbe     DOS API Compatibility Tester
; v 1.0        Copyright 2019 by Mercury0x0D

; strings.asm is a part of APIProbe

; APIProbe is free software: you can rdistribute it and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
; version.

; APIProbe is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

; You should have received a copy of the GNU General Public License along with APIProbe. If not, see <http://www.gnu.org/licenses/>.

; See the included file <GPL License.txt> for the complete text of the GPL License by which this program is covered.





; globals
section .data
kHexDigits										db '0123456789ABCDEF'





bits 16





section .text
ConvertByteToHexString16:
	; Translates the byte value specified to a hexadecimal number in a zero-padded 2 byte string in real mode
	;
	;  input:
	;	Numeric byte value
	;	String address
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	mov si, [bp + 4]
	mov di, [bp + 6]

	; handle digit 1
	mov cx, 0x00F0
	and cx, si
	shr cx, 4
	add cx, kHexDigits
	mov si, cx
	mov al, [si]
	mov byte[di], al
	inc di

	mov si, [bp + 4]

	; handle digit 2
	mov cx, 0x000F
	and cx, si
	add cx, kHexDigits
	mov si, cx
	mov al, [si]
	mov byte[di], al

	mov sp, bp
	pop bp
ret 4





section .text
ConvertWordToHexString16:
	; Translates the word value specified to a hexadecimal number in a zero-padded 4 byte string in real mode
	;
	;  input:
	;	Numeric word value
	;	String address
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	mov si, [bp + 4]
	mov di, [bp + 6]


	; handle digit 1
	mov cx, 0xF000
	and cx, si
	shr cx, 12
	add cx, kHexDigits
	mov si, cx
	mov al, [si]
	mov byte[di], al
	inc di

	mov si, [bp + 4]

	; handle digit 2
	mov cx, 0x0F00
	and cx, si
	shr cx, 8
	add cx, kHexDigits
	mov si, cx
	mov al, [si]
	mov byte[di], al
	inc di

	mov si, [bp + 4]

	; handle digit 3
	mov cx, 0x00F0
	and cx, si
	shr cx, 4
	add cx, kHexDigits
	mov si, cx
	mov al, [si]
	mov byte[di], al
	inc di
	
	mov si, [bp + 4]
	
	; handle digit 4
	mov cx, 0x000F
	and cx, si
	add cx, kHexDigits
	mov si, cx
	mov al, [si]
	mov byte[di], al
	inc di

	mov sp, bp
	pop bp
ret 4





section .text
ConvertNumberBinaryToString:
	; Translates the value specified to a binary number in a zero-padded 32 byte string
	; Note: No length checking is done on this string; make sure it's long enough to hold the converted number!
	; Note: No terminating null is put on the end of the string - do that yourself.
	;
	;  input:
	;	Numeric value
	;	String address
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	mov ax, [bp + 4]
	mov si, [bp + 6]

	; clear the string to all zeroes
	pusha
	push 48
	push 32
	push si
	call MemFill
	popa

	; add to the buffer since we start from the right (max possible length - 1)
	add si, 31

	; set the divisor
	mov bx, 2
	.DecodeLoop:
		mov dx, 0													; clear dx so we don't mess up the division
		div bx														; divide ax by 10
		add dx, 48													; add 48 to the remainder to give us an ASCII character for this number
		mov [si], dl
		dec si														; move to the next position in the buffer
		cmp ax, 0
		jz .Exit													; if ax=0, end of the procedure
		jmp .DecodeLoop												; else repeat
	.Exit:

	mov sp, bp
	pop bp
ret 4





section .text
ConvertNumberDecimalToString:
	; Translates the value specified to a decimal number in a zero-padded 10 byte string
	; Note: No length checking is done on this string; make sure it's long enough to hold the converted number!
	; Note: No terminating null is put on the end of the string - do that yourself.
	;
	;  input:
	;	Numeric value
	;	String address
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	mov ax, [bp + 4]
	mov si, [bp + 6]

	; clear the string to all zeroes
	pusha
	push 48
	push 10
	push si
	call MemFill
	popa

	; add to the buffer since we start from the right (max possible length - 1)
	add si, 9
	
	; set the divisor
	mov bx, 10
	.DecodeLoop:
		mov dx, 0													; clear dx so we don't mess up the division
		div bx														; divide ax by 10
		add dx, 48													; add 48 to the remainder to give us an ASCII character for this number
		mov [si], dl
		dec si														; move to the next position in the buffer
		cmp ax, 0
		jz .Exit													; if ax=0, end of the procedure
		jmp .DecodeLoop												; else repeat
	.Exit:

	mov sp, bp
	pop bp
ret 4





section .text
ConvertNumberHexToString:
	; Translates the value specified to a hexadecimal number in a zero-padded 4 byte string
	; Note: No length checking is done on this string; make sure it's long enough to hold the converted number!
	; Note: No terminating null is put on the end of the string - do that yourself.
	;
	;  input:
	;	Numeric value
	;	String address
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	mov si, [bp + 4]
	mov di, [bp + 6]

	mov bx, 0xF000
	and bx, si
	shr bx, 12
	add bx, kHexDigits
	mov al, [bx]
	mov byte[di], al
	inc di

	mov bx, 0x0F00
	and bx, si
	shr bx, 8
	add bx, kHexDigits
	mov al, [bx]
	mov byte[di], al
	inc di

	mov bx, 0x00F0
	and bx, si
	shr bx, 4
	add bx, kHexDigits
	mov al, [bx]
	mov byte[di], al
	inc di

	mov bx, 0x000F
	and bx, si
	add bx, kHexDigits
	mov al, [bx]
	mov byte[di], al
	inc di

	mov sp, bp
	pop bp
ret 4





section .text
ConvertNumberOctalToString:
	; Translates the value specified to an octal number in a zero-padded 11 byte string
	; Note: No length checking is done on this string; make sure it's long enough to hold the converted number!
	; Note: No terminating null is put on the end of the string - do that yourself.
	;
	;  input:
	;	Numeric value
	;	String address
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	mov ax, [bp + 4]
	mov si, [bp + 6]

	; clear the string to all zeroes
	pusha
	push 48
	push 11
	push si
	call MemFill
	popa

	; add to the buffer since we start from the right (max possible length - 1)
	add si, 10
	
	; set the divisor
	mov bx, 8
	.DecodeLoop:
		mov dx, 0													; clear dx so we don't mess up the division
		div bx														; divide ax by 10
		add dx, 48													; add 48 to the remainder to give us an ASCII character for this number
		mov [si], dl
		dec si														; move to the next position in the buffer
		cmp ax, 0
		jz .Exit													; if ax=0, end of the procedure
	jmp .DecodeLoop													; else repeat


	.Exit:
	mov sp, bp
	pop bp
ret 4





section .text
ConvertStringBinaryToNumber:
	; Returns the numeric value from the binary string specified
	;
	;  input:
	;	String address
	;
	;  output:
	;	ax - Numeric value

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 6
	%define strLen								word [bp - 2]
	%define accumulator							word [bp - 4]
	%define magnitude							word [bp - 6]


	; get the string length
	push word [bp + 4]
	call StringLength
	mov strLen, ax

	; leave if the string is longer than 32 characters
	cmp strLen, 32
	jg .Error

	; leave if the string is zero characters
	cmp strLen, 0
	je .Error

	; init the vars
	mov accumulator, 0
	mov magnitude, 1

	; loop to process all the characters of the string
	mov cx, strLen
	.DecodeLoop:

		; get the last character of the string
		mov si, word [bp + 4]
		add si, cx
		dec si
		mov ax, 0x00000000
		mov al, byte [si]


		; set BL appropriately if the character is 0 - 1
		cmp al, 48
		jb .Done

		cmp al, 49
		ja .Done

		mov bl, 48


		; calculate the actual value of the nibble we got
		sub al, bl

		; multiply the value by the current magnitude and add to the accumulator
		mov bx, magnitude
		mov dx, 0x00000000
		mul bx
		add accumulator, ax

		; multiply magnitude by the base of this numbering system
		shl magnitude, 1

	loop .DecodeLoop
	jmp .Done


	.Error:
	mov accumulator, 0


	.Done:
	mov ax, accumulator

	mov sp, bp
	pop bp
ret 2





section .text
ConvertStringDecimalToNumber:
	; Returns the numeric value from the decimal string specified
	;
	;  input:
	;	String address
	;
	;  output:
	;	ax - Numeric value

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 6
	%define strLen								word [bp - 2]
	%define accumulator							word [bp - 4]
	%define magnitude							word [bp - 6]


	; get the string length
	push word [bp + 4]
	call StringLength
	mov strLen, ax

	; leave if the string is longer than 10 characters
	cmp strLen, 10
	jg .Error

	; leave if the string is zero characters
	cmp strLen, 0
	je .Error

	; init the vars
	mov accumulator, 0
	mov magnitude, 1

	; loop to process all the characters of the string
	mov cx, strLen
	.DecodeLoop:

		; get the last character of the string
		mov si, word [bp + 4]
		add si, cx
		dec si
		mov ax, 0x00000000
		mov al, byte [si]


		; set BL appropriately if the character is 0 - 9
		cmp al, 48
		jb .Done

		cmp al, 57
		ja .Done

		mov bl, 48


		; calculate the actual value of the nibble we got
		sub al, bl

		; multiply the value by the current magnitude and add to the accumulator
		mov bx, magnitude
		mov dx, 0x00000000
		mul bx
		add accumulator, ax

		; multiply magnitude by the base of this numbering system
		mov ax, magnitude
		shl magnitude, 3
		add magnitude, ax
		add magnitude, ax

	loop .DecodeLoop
	jmp .Done


	.Error:
	mov accumulator, 0


	.Done:
	mov ax, accumulator

	mov sp, bp
	pop bp
ret 2





section .text
ConvertStringHexToNumber:
	; Returns the numeric value from the hexadecimal string specified
	;
	;  input:
	;	String address
	;
	;  output:
	;	ax - Numeric value

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 6
	%define strLen								word [bp - 2]
	%define accumulator							word [bp - 4]
	%define magnitude							word [bp - 6]


	; get the string length
	push word [bp + 4]
	call StringLength
	mov strLen, ax

	; leave if the string is longer than 8 characters
	cmp strLen, 8
	jg .Error

	; leave if the string is zero characters
	cmp strLen, 0
	je .Error

	; init the vars
	mov accumulator, 0
	mov magnitude, 1

	; loop to process all the characters of the string
	mov cx, strLen
	.DecodeLoop:

		; get the last character of the string
		mov si, word [bp + 4]
		add si, cx
		dec si
		mov ax, 0x00000000
		mov al, byte [si]


		; set BL appropriately if the character is 0 - 9
		cmp al, 48
		jb .UppercaseTest

		cmp al, 57
		ja .UppercaseTest

		mov bl, 48
		jmp .ProcessDigit


		.UppercaseTest:
		; set BL appropriately if the character is A - F
		cmp al, 65
		jb .LowercaseTest

		cmp al, 70
		ja .LowercaseTest

		mov bl, 55
		jmp .ProcessDigit


		.LowercaseTest:
		; set BL appropriately if the character is a - f
		cmp al, 97
		jb .Done

		cmp al, 102
		ja .Done

		mov bl, 87


		.ProcessDigit:
		; calculate the actual value of the nibble we got
		sub al, bl

		; multiply the value by the current magnitude and add to the accumulator
		mov bx, magnitude
		mov dx, 0x00000000
		mul bx
		add accumulator, ax

		; multiply magnitude by the base of this numbering system
		shl magnitude, 4

	loop .DecodeLoop
	jmp .Done


	.Error:
	mov accumulator, 0

	
	.Done:
	mov ax, accumulator

	mov sp, bp
	pop bp
ret 2





section .text
ConvertStringOctalToNumber:
	; Returns the numeric value from the octal string specified
	;
	;  input:
	;	String address
	;
	;  output:
	;	ax - Numeric value

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 6
	%define strLen								word [bp - 2]
	%define accumulator							word [bp - 4]
	%define magnitude							word [bp - 6]


	; get the string length
	push word [bp + 4]
	call StringLength
	mov strLen, ax

	; leave if the string is longer than 11 characters
	cmp strLen, 11
	jg .Error

	; leave if the string is zero characters
	cmp strLen, 0
	je .Error

	; init the vars
	mov accumulator, 0
	mov magnitude, 1

	; loop to process all the characters of the string
	mov cx, strLen
	.DecodeLoop:

		; get the last character of the string
		mov si, word [bp + 4]
		add si, cx
		dec si
		mov ax, 0x00000000
		mov al, byte [si]


		; set BL appropriately if the character is 0 - 8
		cmp al, 48
		jb .Done

		cmp al, 56
		ja .Done

		mov bl, 48


		; calculate the actual value of the nibble we got
		sub al, bl

		; multiply the value by the current magnitude and add to the accumulator
		mov bx, magnitude
		mov dx, 0x00000000
		mul bx
		add accumulator, ax

		; multiply magnitude by the base of this numbering system
		shl magnitude, 3

	loop .DecodeLoop
	jmp .Done


	.Error:
	mov accumulator, 0

	
	.Done:
	mov ax, accumulator

	mov sp, bp
	pop bp
ret 2





section .text
StringCaseLower:
	; Converts a string to lower case
	;
	;  input:
	;	String address
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	mov bx, word [bp + 4]

	.StringLoop:
		mov byte al, [bx]

		cmp al, 0x00
		je .StringLoopDone

		cmp al, 65
		jb .NotInRange

		cmp al, 90
		ja .NotInRange

		; if we get here, it was in range, so we drop it to lower case
		add al, 32
		mov [bx], al

		.NotInRange:
		inc bx
	jmp .StringLoop
	.StringLoopDone:

	mov sp, bp
	pop bp
ret 2





section .text
StringCaseUpper:
	; Converts a string to upper case
	;
	;  input:
	;	String address
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	mov bx, word [bp + 4]

	.StringLoop:
		mov byte al, [bx]

		cmp al, 0x00
		je .StringLoopDone

		cmp al, 97
		jb .NotInRange

		cmp al, 122
		ja .NotInRange

		; if we get here, it was in range, so we raise it to upper case
		sub al, 32
		mov [bx], al

		.NotInRange:
		inc bx
	jmp .StringLoop
	.StringLoopDone:

	mov sp, bp
	pop bp
ret 2





section .text
StringCharAppend:
	; Appends a character onto the end of the string specified
	;
	;  input:
	;	String address
	;	ASCII code of character to add
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	; get the length of the string passed
	push word [bp + 4]
	call StringLength
	mov di, ax
	add di, word [bp + 4]

	; write the ASCII character
	mov ax, word [bp + 6]
	stosb

	; write a null to terminate the string
	mov al, 0
	stosb

	mov sp, bp
	pop bp
ret 4





section .text
StringCharDelete:
	; Deletes the character at the location specified from the string
	;
	;  input:
	;	String address
	;	Character position to remove
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	mov bx, word [bp + 4]
	mov dx, word [bp + 6]

	; test for null string for efficiency
	mov al, byte [bx]
	cmp al, 0x00
	je .StringTrimDone

	; calculate source string position
	add bx, dx

	; calculate the destination position
	mov dx, bx
	dec dx

	.StringShiftLoop:
		; load a char from the source position
		push bx
		mov al, [bx]
		mov bx, dx
		mov [bx], al
		pop bx

		; test if this is the end of the string
		cmp al, 0x00
		je .StringTrimDone

		; that wasn't the end, so we increment the pointers and do the next character
		inc dx
		inc bx
	jmp .StringShiftLoop
	.StringTrimDone:

	mov sp, bp
	pop bp
ret 4





section .text
StringCharPrepend:
	; Prepends a character onto the beginning of the string specified
	;
	;  input:
	;	String address
	;	ASCII code of character to add
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	; get the length of the string passed
	push word [bp + 4]
	call StringLength
	mov cx, ax
	
	; set up our string loop addresses
	mov si, word [bp + 4]
	add si, cx
	mov di, si
	inc di
; CHECK THIS LINE BELOW FOR A POSSIBLE BUG!; CHECK THIS LINE BELOW FOR A POSSIBLE BUG!; CHECK THIS LINE BELOW FOR A POSSIBLE BUG!
	; loop to shift bytes down by the number of characters being inserted, plus one to allow for the null
	mov cx, word [bp - 2]
	inc cx
	pushf
	std
	.ShiftLoop:
		lodsb
		stosb
	loop .ShiftLoop
	popf

	; write the ASCII character
	mov ax, word [bp + 6]
	stosb


	mov sp, bp
	pop bp
ret 4





section .text
StringFill:
	; Fills the entire string specified with the character specified
	;
	;  input:
	;	String address
	;	Fill character
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	mov bx, word [bp + 4]
	mov dx, word [bp + 6]

	.StringLoop:
		mov al, byte [bx]

		cmp al, 0x00
		je .StringLoopDone

		mov byte [bx], dl

		inc bx
	jmp .StringLoop
	.StringLoopDone:


	mov sp, bp
	pop bp
ret 4





section .text
StringInsert:
	; Inserts a string into another string at the location specified
	;
	;  input:
	;	Address of main string
	;	Address of string to be inserted
	;	Position after which to insert the string
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 4
	%define mainLength							word [bp - 2]
	%define insertLength						word [bp - 4]


	; get the length of the main string
	push word [bp + 4]
	call StringLength
	mov mainLength, ax


	; check insert position; writing AT the end of the string is okay, PAST it is not
	mov bx, word [bp + 8]

	cmp bx, mainLength
	jbe .CheckOK
	; if we get here the insert position is invalid, so we exit
	jmp .Exit
	.CheckOK:

	; get the length of the insert string
	push word [bp + 6]
	call StringLength
	mov insertLength, ax


	; load up some registers for speed
	mov bx, word [bp + 4]
	mov dx, word [bp + 6]
	mov cx, word [bp + 8]


	; set up a value to use later to check if the loop is over
	mov dx, bx
	add dx, cx

	; calculate address of the first byte in the section of chars to be shifted down
	mov ax, mainLength
	add bx, ax

	; calculate the address of the last byte of the resulting string
	mov di, bx
	add di, insertLength

	.StringShiftLoop:
		; copy a byte from source to destination
		mov al, [bx]
		mov [di], al

		; test if we have reached the insert position
		cmp dx, di
		je .StringTrimDone

		; that wasn't the end, so we increment the pointers and do the next character
		dec di
		dec bx
	jmp .StringShiftLoop

	; now that we've made room for it, we can proceed to write the insert string into the main string

	.StringTrimDone:
	; calculate the write address based on the location specified
	mov bx, word [bp + 4]
	add bx, cx

	; get the address of the insert string
	mov dx, word [bp + 6]

	.StringWriteLoop:
		; get a byte from the insert string
		push bx
		mov bx, dx
		mov al, byte [bx]
		pop bx
		
		; see if it's null
		cmp al, 0x00
		
		; if so, jump out of the loop - we're done!
		je .Exit

		; if we get here, it's not the end yet
		mov byte [bx], al

		; increment the pointers and start over
		inc dx
		inc bx
	jmp .StringWriteLoop


	.Exit:
	mov sp, bp
	pop bp
ret 6





section .text
StringLength:
	; Returns the length of the string specified
	;
	;  input:
	;	String starting address
	;
	;  output:
	;	ax - String length

	push bp
	mov bp, sp


	mov di, word [bp + 4]

	; set up the string scan
	mov cx, 0xFFFF
	mov si, di
	mov al, 0
	repne scasb
	sub di, si
	dec di

	; put the result into ax and exit
	mov ax, di


	mov sp, bp
	pop bp
ret 2





section .text
StringPadLeft:
	; Pads the left side of the string specified with the character specified until it is the length specified
	;
	;  input:
	;	String address
	;	Padding character
	;	Length to which the string will be extended
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 2
	%define strLen								word [bp - 2]


	; get the length of the string
	push word [bp + 4]
	call StringLength
	mov strLen, ax

	; exit if the string specified is already greater than the length given
	mov ax, word [bp + 8]
	mov bx, strLen
	cmp bx, ax
	jae .Exit

	; calculate number of characters we need to add into ax and save it for later
	sub ax, strLen
	push ax

	; calculate source and dest addresses
	mov si, word [bp + 4]
	add si, strLen
	mov di, si
	add di, ax

	; loop to shift bytes down by the number of characters being inserted, plus one to allow for the null
	mov cx, strLen
	inc cx
	pushf
	std

	.ShiftLoop:
		lodsb
		stosb
	loop .ShiftLoop
	popf

	; MemFill the characters onto the beginning of the string
	pop ax
	push word [bp + 6]
	push ax
	push word [bp + 4]
	call MemFill


	.Exit:
	mov sp, bp
	pop bp
ret 6





section .text
StringPadRight:
	; Pads the right side of the string specified with the character specified until it is the length specified
	;
	;  input:
	;	String address
	;	Padding character
	;	Length to which string will be extended
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	; allocate local variables
	sub sp, 2
	%define strLen								word [bp - 2]


	; get the length of the string
	push word [bp + 4]
	call StringLength
	mov strLen, ax

	; exit if the string specified is already greater than the length given
	mov ax, word [bp + 8]
	mov bx, strLen
	cmp bx, ax
	jae .Exit

	; calculate number of characters we need to add into ax
	sub ax, strLen

	; calculate write address and save for later
	mov bx, word [bp + 4]
	add bx, strLen
	push bx

	; MemFill the characters onto the end of the string
	push word [bp + 6]
	push ax
	push bx
	call MemFill

	; write the null terminator
	pop bx
	add bx, word [bp + 8]
	mov byte [bx], 0


	.Exit:
	mov sp, bp
	pop bp
ret 6





section .text
StringReplaceChars:
	; Replaces all occurrances of the specified character with another character specified
	;
	;  input:
	;	String address
	;	Character to be replaced
	;	Replacement character
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	mov bx, word [bp + 4]
	mov cx, word [bp + 6]
	mov dx, word [bp + 8]

	.StringLoop:
		mov al, byte [bx]

		cmp al, 0x00
		je .StringLoopDone

		cmp al, cl
		jne .NoMatch

		; if we get here, it was in range, so replace it
		mov [bx], dl

		.NoMatch:
		inc bx
	jmp .StringLoop
	.StringLoopDone:


	mov sp, bp
	pop bp
ret 6





section .text
StringReplaceCharsInRange:
	; Replaces any character within the range of ASCII codes specified with the specified character
	;
	;  input:
	;	String address
	;	Start of ASCII range
	;	End of ASCII range
	;	Replacement character
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	mov bx, word [bp + 4]
	mov ax, word [bp + 6]
	mov cx, word [bp + 8]
	mov dx, word [bp + 10]

	mov ch, al

	; see if the range numbers are backwards and swap them if necessary
	cmp ch, cl
	jl .StringLoop
	xchg ch, cl

	.StringLoop:
		mov al, byte [bx]

		cmp al, 0x00
		je .Exit

		cmp al, ch
		jb .NotInRange

		cmp al, cl
		ja .NotInRange

		; if we get here, it was in range, so replace it
		mov [bx], dl

		.NotInRange:
		inc bx
	jmp .StringLoop


	.Exit:
	mov sp, bp
	pop bp
ret 8





section .text
StringSearchChar:
	; Returns the position in the string specified of the character code specified
	;
	;  input:
	;	Address of string to be scanned
	;	ASCII value of byte for which to search
	;
	;  output:
	;	ax - Position of match, or zero if no match

	push bp
	mov bp, sp


	; allocate local variables
	sub sp, 2
	%define stringLen							word [bp - 2]


	; get length of the main string
	push word [bp + 4]
	call StringLength
	mov cx, ax


	; exit if the string was null, save ax if not
	cmp cx, 0
	je .Exit
	mov stringLen, cx


	; load up for the search
	mov di, word [bp + 4]
	mov ax, word [bp + 6]


	; use the (insert echo here) MAGIC OF ASSEMBLY to search for the byte
	repnz scasb


	; if the zero flag is set, a match was found
	; if it's clear, no match was found and cx will already be 0, so we can simply exit
	jnz .Exit


	; a match was found, so update the position
	sub stringLen, cx
	mov ax, stringLen


	.Exit:
	mov sp, bp
	pop bp
ret 4





section .text
StringSearchCharList:
	; Returns the position in the string specified of the first match from a list of characters
	;
	;  input:
	;	Address of string to be scanned
	;	Address of character list string
	;
	;  output:
	;	ax - Position of match, or zero if no match

	push bp
	mov bp, sp


	; allocate local variables
	sub sp, 6
	%define mainStrLen							word [bp - 2]
	%define listStrLen							word [bp - 4]
	%define returnValue							word [bp - 6]


	; init return value to an absurdly high number 
	mov returnValue, 0xFFFF

	; get length of the main string
	push word [bp + 4]
	call StringLength

	; exit if the string was null, save ax if not
	cmp ax, 0
	je .Exit
	mov mainStrLen, ax

	; get length of the list string
	push word [bp + 6]
	call StringLength

	; exit if the string was null, save ax if not
	cmp ax, 0
	je .Exit
	mov listStrLen, ax

	; this loop cycles through all characters of the list string
	mov cx, listStrLen
	mov si, word [bp + 6]
	.scanLoop:

		; get a byte from the list string
		mov al, byte [si]

		; preserve cx
		mov bx, cx

		; scan the main string for this character
		mov cx, mainStrLen
		mov di, word [bp + 4]
		repne scasb

		; if the zero flag is clear, there was a match
		jnz .NextIteration
		
			; subtract the starting address of the string from di
			; this makes it now refer to the character within the string instead of the byte address
			sub di, word [bp + 4]

			; compare to see if this value is lower (e.g. "nearer") than the last one
			mov ax, returnValue
			cmp di, ax
			jnb .NextIteration

			; it was closer, so save this value
			mov returnValue, di

		.NextIteration:
		; do the next pass through the loop
		mov cx, bx
		inc si
	loop .scanLoop


	.Exit:
	; see if the return value is still 0xFFFF and make it zero if so
	cmp returnValue, 0xFFFF
	jne .NoAdjust
	mov returnValue, 0


	.NoAdjust:
	mov ax, returnValue


	mov sp, bp
	pop bp
ret 4





section .text
StringTokenBinary:
	; Finds the first occurrance of the ^ character and replaces it with a binary number, truncated to the length specified
	;
	;  input:
	;	String address
	;	Dword value to be added to the string
	;	Number trim value
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 37
	%define tokenPosition						word [bp - 2]
	%define bufferAddress						word [bp - 4]
	; 33 byte string buffer for number-to-string conversion output is at [bp - 37]


	; get the length of the formatting string, exit if it's null
	push word [bp + 4]
	call StringLength
	cmp ax, 0
	je .Done


	; find the location of the first token character
	push word 0x005E
	push word [bp + 4]
	call StringSearchChar
	mov tokenPosition, ax


	; if the token location is 0, then no token was found... so we exit
	cmp tokenPosition, 0
	je .Done


	; calculate the address of our string buffer
	mov ax, bp
	sub ax, 37
	mov bufferAddress, ax


	; zero the string buffer
	push 0
	push 33
	push bufferAddress
	call MemFill


	; convert the number passed to a string
	push bufferAddress
	push word [bp + 6]
	call ConvertNumberBinaryToString


	; trim leading zeroes if necessary
	cmp word [bp + 8], 0
	jne .NoTrimLeading
		push word 0x0030
		push bufferAddress
		call StringTrimLeft

		; see if the string length is zero and add a single zero back if so
		mov bx, bufferAddress
		mov al, byte [bx]
		cmp al, 0
		jne .SkipAddZero
			mov bx, bufferAddress
			mov byte [bx], 0x30
			inc bx
			mov byte [bx], 0x00
		.SkipAddZero:
		jmp .NoTruncate
	.NoTrimLeading:


	; if the trim value is less than the maximum possible length of the string, then truncate as directed
	cmp word [bp + 8], 32
	jae .NoTruncate
		push word [bp + 8]
		push bufferAddress
		call StringTruncateLeft
	.NoTruncate:


	; delete the token itself
	push tokenPosition
	push word [bp + 4]
	call StringCharDelete


	; insert the string we created into the output string
	dec tokenPosition
	push tokenPosition
	push bufferAddress
	push word [bp + 4]
	call StringInsert


	.Done:
	mov sp, bp
	pop bp
ret 6





section .text
StringTokenDecimal:
	; Finds the first occurrance of the ^ character and replaces it with a decimal number, truncated to the length specified
	;
	;  input:
	;	String address
	;	Dword value to be added to the string
	;	Number trim value
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 15
	%define tokenPosition						word [bp - 2]
	%define bufferAddress						word [bp - 4]
	; 11 byte string buffer for number-to-string conversion output is at [bp - 15]


	; get the length of the formatting string, exit if it's null
	push word [bp + 4]
	call StringLength
	cmp ax, 0
	je .Done


	; find the location of the first token character
	push word 0x005E
	push word [bp + 4]
	call StringSearchChar
	mov tokenPosition, ax


	; if the token location is 0, then no token was found... so we exit
	cmp tokenPosition, 0
	je .Done


	; calculate the address of our string buffer
	mov ax, bp
	sub ax, 15
	mov bufferAddress, ax


	; zero the string buffer
	push 0
	push 11
	push bufferAddress
	call MemFill


	; convert the number passed to a string
	push bufferAddress
	push word [bp + 6]
	call ConvertNumberDecimalToString


	; trim leading zeroes if necessary
	cmp word [bp + 8], 0
	jne .NoTrimLeading
		push word 0x0030
		push bufferAddress
		call StringTrimLeft

		; see if the string length is zero and add a single zero back if so
		mov bx, bufferAddress
		mov al, byte [bx]
		cmp al, 0
		jne .SkipAddZero
			mov bx, bufferAddress
			mov byte [bx], 0x30
			inc bx
			mov byte [bx], 0x00
		.SkipAddZero:
		jmp .NoTruncate
	.NoTrimLeading:


	; if the trim value is less than the maximum possible length of the string, then truncate as directed
	cmp word [bp + 8], 10
	jae .NoTruncate
		push word [bp + 8]
		push bufferAddress
		call StringTruncateLeft
	.NoTruncate:


	; delete the token itself
	push tokenPosition
	push word [bp + 4]
	call StringCharDelete


	; insert the string we created into the output string
	dec tokenPosition
	push tokenPosition
	push bufferAddress
	push word [bp + 4]
	call StringInsert


	.Done:
	mov sp, bp
	pop bp
ret 6





section .text
StringTokenHexadecimal:
	; Finds the first occurrance of the ^ character and replaces it with a hexadecimal number, truncated to the length specified
	;
	;  input:
	;	String address
	;	Dword value to be added to the string
	;	Number trim value
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 13
	%define tokenPosition						word [bp - 2]
	%define bufferAddress						word [bp - 4]
	; 9 byte string buffer for number-to-string conversion output is at [bp - 13]


	; get the length of the formatting string, exit if it's null
	push word [bp + 4]
	call StringLength
	cmp ax, 0
	je .Done


	; find the location of the first token character
	push word 0x005E
	push word [bp + 4]
	call StringSearchChar
	mov tokenPosition, ax


	; if the token location is 0, then no token was found... so we exit
	cmp tokenPosition, 0
	je .Done


	; calculate the address of our string buffer
	mov ax, bp
	sub ax, 13
	mov bufferAddress, ax


	; zero the string buffer
	push 0
	push 9
	push bufferAddress
	call MemFill


	; convert the number passed to a string
	push bufferAddress
	push word [bp + 6]
	call ConvertNumberHexToString


	; trim leading zeroes if necessary
	cmp word [bp + 8], 0
	jne .NoTrimLeading
		push dword 0x0030
		push bufferAddress
		call StringTrimLeft

		; see if the string length is zero and add a single zero back if so
		mov bx, bufferAddress
		mov al, byte [bx]
		cmp al, 0
		jne .SkipAddZero
			mov bx, bufferAddress
			mov byte [bx], 0x30
			inc bx
			mov byte [bx], 0x00
		.SkipAddZero:
		jmp .NoTruncate
	.NoTrimLeading:


	; if the trim value is less than the maximum possible length of the string, then truncate as directed
	cmp word [bp + 8], 16
	jae .NoTruncate
		push word [bp + 8]
		push bufferAddress
		call StringTruncateLeft
	.NoTruncate:


	; delete the token itself
	push tokenPosition
	push word [bp + 4]
	call StringCharDelete


	; insert the string we created into the output string
	dec tokenPosition
	push tokenPosition
	push bufferAddress
	push word [bp + 4]
	call StringInsert


	.Done:
	mov sp, bp
	pop bp
ret 6





section .text
StringTokenOctal:
	; Finds the first occurrance of the ^ character and replaces it with an octal number, truncated to the length specified
	;
	;  input:
	;	String address
	;	DWord value to be added to the string
	;	Number trim value
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 16
	%define tokenPosition						word [bp - 2]
	%define bufferAddress						word [bp - 4]
	; 12 byte string buffer for number-to-string conversion output is at [bp - 16]


	; get the length of the formatting string, exit if it's null
	push word [bp + 4]
	call StringLength
	cmp ax, 0
	je .Done


	; find the location of the first token character
	push word 0x005E
	push word [bp + 4]
	call StringSearchChar
	mov tokenPosition, ax


	; if the token location is 0, then no token was found... so we exit
	cmp tokenPosition, 0
	je .Done


	; calculate the address of our string buffer
	mov ax, bp
	sub ax, 16
	mov bufferAddress, ax


	; zero the string buffer
	push 0
	push 12
	push bufferAddress
	call MemFill


	; convert the number passed to a string
	push bufferAddress
	push word [bp + 6]
	call ConvertNumberOctalToString


	; trim leading zeroes if necessary
	cmp word [bp + 8], 0
	jne .NoTrimLeading
		push word 0x0030
		push bufferAddress
		call StringTrimLeft

		; see if the string length is zero and add a single zero back if so
		mov bx, bufferAddress
		mov al, byte [bx]
		cmp al, 0
		jne .SkipAddZero
			mov bx, bufferAddress
			mov byte [bx], 0x30
			inc bx
			mov byte [bx], 0x00
		.SkipAddZero:
		jmp .NoTruncate
	.NoTrimLeading:


	; if the trim value is less than the maximum possible length of the string, then truncate as directed
	cmp word [bp + 8], 11
	jae .NoTruncate
		push word [bp + 8]
		push bufferAddress
		call StringTruncateLeft
	.NoTruncate:


	; delete the token itself
	push tokenPosition
	push word [bp + 4]
	call StringCharDelete


	; insert the string we created into the output string
	dec tokenPosition
	push tokenPosition
	push bufferAddress
	push word [bp + 4]
	call StringInsert


	.Done:
	mov sp, bp
	pop bp
ret 6





section .text
StringTokenString:
	; Finds the first occurrance of the ^ character and replaces it with the string specified, truncated to the length specified
	;
	;  input:
	;	String address
	;	Address of string to be added
	;	String trim value
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 2
	%define tokenPosition						word [bp - 2]


	; get the length of the formatting string, exit if it's null
	push word [bp + 4]
	call StringLength
	cmp ax, 0
	je .Done


	; find the location of the first token character
	push word 0x005E
	push word [bp + 4]
	call StringSearchChar
	mov tokenPosition, ax


	; if the token location is 0, then no token was found... so we exit
	cmp tokenPosition, 0
	je .Done


	; if the trim value is less than the maximum possible length of the string, then truncate as directed
	cmp word [bp + 8], 0
	je .NoTruncate
		push word [bp + 8]
		push word [bp + 6]
		call StringTruncateLeft
	.NoTruncate:


	; delete the token itself
	push tokenPosition
	push word [bp + 4]
	call StringCharDelete


	; insert the string we created into the output string
	dec tokenPosition
	push tokenPosition
	push word [bp + 6]
	push word [bp + 4]
	call StringInsert


	.Done:
	mov sp, bp
	pop bp
ret 6





section .text
StringTrimLeft:
	; Trims any occurrances of the character specified off the left side of the string
	;
	;  input:
	;	String address
	;	ASCII code of the character to be trimmed
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	mov bx, word [bp + 4]
	mov cx, word [bp + 6]

	; save the string address for later
	mov dx, bx

	; see from where we have to start shifting
	.StringLoop:
		mov byte al, byte [bx]

		cmp al, cl
		jne .StartShifting

		; if this was the last byte of the string, then exit the loop
		cmp al, 0x00
		je .Done

		inc bx
	jmp .StringLoop

	.StartShifting:
	; if we get here, the current character wasn't a match, so we can start shifting the characters

	; but first, a test... if bx = dx then there's no shifting necessary and we can exit right away
	cmp bx, dx
	je .Done

	.StringShiftLoop:
		; load a char from the source position
		push bx
		mov al, byte [bx]
		mov bx, dx
		mov [bx], al
		pop bx

		; test if this is the end of the string
		cmp al, 0x00
		je .Done

		; that wasn't the end, so we increment the pointers and do the next character
		inc dx
		inc bx
	jmp .StringShiftLoop


	.Done:
	mov sp, bp
	pop bp
ret 4





section .text
StringTrimRight:
	; Trims any occurrances of the character specified off the right side of the string
	;
	;  input:
	;	string address
	;	ASCII code of the character to be trimmed
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp


	mov bx, word [bp + 4]
	mov cx, word [bp + 6]

	; get the length of the string and use it to adjust the starting pointer of the string
	push bx
	call StringLength
	mov bx, word [bp + 4]
	add bx, ax
	dec bx

	mov cx, word [bp + 6]

	.StringLoop:
		mov al, byte [bx]

		cmp al, 0x00
		je .Done

		cmp al, cl
		jne .Truncate
		dec bx
	jmp .StringLoop

	.Truncate:
	; adjust the pointer to the position after the last char of the string and insert the null byte
	inc bx
	mov byte [bx], 0


	.Done:
	mov sp, bp
	pop bp
ret 4





section .text
StringTruncateLeft:
	; Truncates the string to the length specified by trimming characters off the beginning
	;
	;  input:
	;	String address
	;	Length to which the string will be shortened
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 2
	%define strLength							word [bp - 2]


	; get the length of the string
	push word [bp + 4]
	call StringLength
	mov strLength, ax

	; exit if the string specified is shorter than the length given
	mov ax, word [bp + 6]
	mov bx, strLength
	cmp ax, bx
	jae .Exit

	; MemCopy the part of the string to be preserved
	; get the source address 
	mov si, word [bp + 4]
	add si, bx
	sub si, ax

	inc ax
	push ax
	push word [bp + 4]
	push si
	call MemCopy


	.Exit:
	mov sp, bp
	pop bp
ret 4





section .text
StringTruncateRight:
	; Truncates the string to the length specified by trimming characters off the end
	;
	;  input:
	;   String address
	;   Length to which the string will be shortened
	;
	;  output:
	;   n/a

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 2
	%define strLength							word [bp - 2]


	; get the length of the string
	push word [bp + 4]
	call StringLength
	mov strLength, ax

	; exit if the string specified is shorter than the length given
	mov ax, word [bp + 6]
	mov bx, strLength
	cmp ax, bx
	jae .Exit

	; add the new length of the string to it's starting address to get our write address
	mov di, word [bp + 4]
	add di, ax

	; and write a null to truncate the string
	mov ax, 0
	stosb


	.Exit:
	mov sp, bp
	pop bp
ret 4





section .text
StringWordCount:
	; Counts the words in the string specified when viewed as a sentence separated by the byte specified
	;
	;  input:
	;	String address
	;	List of characters to be used as separators (cannot include nulls)
	;
	;  output:
	;	ax - Word count

	push bp
	mov bp, sp


	; allocate local variables
	sub sp, 9
	%define mainStrLen							word [bp - 2]
	%define listStrLen							word [bp - 4]
	%define wordCount							word [bp - 6]
	%define lastType							byte [bp - 7]
	%define currentByteTemp						word [bp - 9]


	; get ax ready for writing to the return value in case we have to exit immdiately
	mov ax, 0

	; get length of the main string
	push word [bp + 4]
	call StringLength

	; exit if the string was null, save ax if not
	cmp ax, 0
	je .Exit
	mov mainStrLen, ax

	; get length of the list string
	push word [bp + 6]
	call StringLength

	; exit if the string was null, save ax if not
	cmp ax, 0
	je .Exit
	mov listStrLen, ax

	; set up loop value
	mov cx, mainStrLen

	; set up local variables here
	mov lastType, 0
	mov currentByteTemp, 0
	mov wordCount, 0
	mov si, word [bp + 4]

	; loop to process the characters
	.WordLoop:
		; copy a byte from the string into al
		lodsb

		; save important stuff
		push si
		push cx

		; see if this byte is in the list of seperators
		push word [bp + 6]
		mov byte [bp - 7], al
		mov ax, bp
		sub ax, 7
		push ax
		call StringSearchCharList

		; restore important stuff
		pop cx
		pop si

		; see if a match was found
		cmp ax, 0
		je .NotASeperator
			; make a note that this character was a separator
			mov lastType, 2
			jmp .NextIteration

		.NotASeperator:

			; if the last character wasn't a separator, increment wordCount
			mov bl, lastType

			cmp bl, 1
			je .SkipIncrement
				inc wordCount
			.SkipIncrement:

			; make a note that this character was not a separator
			mov lastType, 1

		.NextIteration:

	loop .WordLoop

	; get ax ready for writing the return value
	mov ax, wordCount


	.Exit:
	mov sp, bp
	pop bp
ret 4





section .text
StringWordGet:
	; Returns the word specified from the string specified when separated by the byte specified
	;
	;  input:
	;	String address
	;	List of characters to be used as separators (cannot include nulls)
	;	Word number which to return
	;	Address of string to hold the word requested
	;
	;  output:
	;	n/a

	push bp
	mov bp, sp

	; allocate local variables
	sub sp, 9
	%define mainStrLen							word [bp - 2]
	%define listStrLen							word [bp - 4]
	%define wordCount							word [bp - 6]
	%define lastType							byte [bp - 7]
	%define currentByteTemp						word [bp - 9]


	; get ax ready for writing to the return value in case we have to exit immdiately
	mov ax, 0

	; get length of the main string
	push word [bp + 4]
	call StringLength

	; exit if the string was null, save ax if not
	cmp ax, 0
	je .Exit
	mov mainStrLen, ax

	; get length of the list string
	push word [bp + 6]
	call StringLength

	; exit if the string was null, save ax if not
	cmp ax, 0
	je .Exit
	mov listStrLen, ax

	; set up our loop value
	mov cx, mainStrLen

	; set up local variables here
	mov lastType, 0
	mov currentByteTemp, 0
	mov wordCount, 0
	mov si, word [bp + 4]

	; clear out the temp word string
	mov di, word [bp + 10]
	mov al, 0
	stosb

	; loop to process the characters
	.WordLoop:
		; copy a byte from the string into al
		lodsb

		; save important stuff
		push si
		push ax
		push cx

		; see if this byte is in the list of seperators
		push word [bp + 6]
		mov byte [bp - 7], al
		mov ax, bp
		sub ax, 7
		push ax
		call StringSearchCharList
		mov dx, ax

		; restore important stuff
		pop cx
		pop ax
		pop si

		; see if a match was found
		cmp dx, 0
		je .NotASeperator
			; see if we have the requested word and exit if so
			mov ax, word [bp + 8]
			mov bx, wordCount
			cmp ax, bx
			je .WordFound

			; clear out wordReturned$
			mov di, word [bp + 10]
			mov al, 0
			stosb

			; make a note that this character was a separator
			mov lastType, 2
			jmp .NextIteration

		.NotASeperator:

			; if the last character wasn't a separator, increment wordCount
			mov bl, lastType

			cmp bl, 1
			je .SkipIncrement
				inc wordCount
			.SkipIncrement:

			; make a note that this character was not a separator
			mov lastType, 1

			; add this character to wordReturned$
			pusha
			push ax
			push word [bp + 10]
			call StringCharAppend
			popa


		.NextIteration:

	loop .WordLoop


	.WordFound:
	; get ax ready for writing the return value
	mov ax, wordCount


	.Exit:
	mov sp, bp
	pop bp
ret 8
