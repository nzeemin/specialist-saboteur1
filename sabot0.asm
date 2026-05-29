;----------------------------------------------------------------------------

	EXPORT KeyLineEx
	EXPORT KeyLine0
	EXPORT JoystickP	; F200DULR
	EXPORT dzx0
	EXPORT SABOTCOD0_END

;----------------------------------------------------------------------------

	OUTPUT "sabot0.bin"
	ORG	0h

	di
	ld sp,$9000

; Move encoded block from SABOTCOD0_END to FF00h-LZSIZE1, LZSIZE1 bytes
	ld BC,SABOTCOD0_END+LZSIZE1	; source end addr
	ld DE,08F00h			; destination end addr
	ld HL,LZSIZE1			; size
	inc H
Init_1:			; Copy backwards
	dec BC
	ld A,(BC)
	dec DE
	ld (DE),A
	dec L
	jp nz,Init_1
	dec H
	jp nz,Init_1
; now DE = 08F00h - LZSIZE1 = compressed block start address
; Decompress the code and sprites from C000h-LZSIZE1 to SABOTCOD0_END
	;ld DE,08F00h-LZSIZE1		; source addr
	ld BC,SABOTCOD0_END		; destination addr
	call dzx0

; Start SABOTCOD1
	jp	SABOTCOD0_END

;----------------------------------------------------------------------------

KeyLineEx:	DB 11111111b
KeyLine0:	DB 11111111b
;KeyLine1:	DB 11111111b
;KeyLine5:	DB 11111111b
;KeyLine6:	DB 11111111b
;KeyLine7:	DB 11111111b
JoystickP:	DB 11111111b

;----------------------------------------------------------------------------

; ZX0 decompressor code by Ivan Gorodetsky
; https://github.com/ivagorRetrocomp/DeZX/blob/main/ZX0/8080/OLD_V1/dzx0_CLASSIC.asm
; input:	de=compressed data start
;		bc=uncompressed destination start
;NOTE: FORWARD decompression only
dzx0:
		ld hl,0FFFFh
		push HL
		inc HL
		ld A,080h
dzx0_literals:
		call dzx0_elias
		call dzx0_ldir
		jp c,dzx0_new_offset
		call dzx0_elias
dzx0_copy:
		ex DE,HL
		ex (SP),HL
		push HL
		add HL,BC
		ex DE,HL
		call dzx0_ldir
		ex DE,HL
		pop HL
		ex (SP),HL
		ex DE,HL
		jp NC,dzx0_literals
dzx0_new_offset:
		call dzx0_elias
		ld H,A
		pop AF
		xor A
		sub L
		ret z
		push HL
		rra
		ld H,A
		ld A,(DE)
		rra
		ld L,A
		inc de
		ex (SP),HL
		ld A,H
		ld HL,1
		call nc,dzx0_elias_backtrack
		inc HL
		jp dzx0_copy
dzx0_elias:
		inc L
dzx0_elias_loop:
		add A,A
		jp NZ,dzx0_elias_skip
		ld A,(de)
		inc DE
		rla
dzx0_elias_skip:
		ret C
dzx0_elias_backtrack:
		add HL,HL
		add A,A
		jp NC,dzx0_elias_loop
		jp dzx0_elias

dzx0_ldir:
		push AF
dzx0_ldir1:
		ld A,(DE)
		ld (BC),A
		inc DE
		inc BC
		dec HL
		ld A,H
		or L
		jp nz,dzx0_ldir1
		pop AF
		add A,A
		ret

;----------------------------------------------------------------------------

	DEFS 4
	DEFM "SABOTEUR 1 SPECIALIST NZEEMIN "
	INCLUDE "version.inc"

;----------------------------------------------------------------------------

	ALIGN 256
SABOTCOD0_END
	OUTEND
	END