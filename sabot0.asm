;----------------------------------------------------------------------------

	EXPORT dzx0
	EXPORT INPUTB
	EXPORT ReadInput
	EXPORT SABOTCOD0_END

;----------------------------------------------------------------------------

	;OUTPUT "sabot0.bin"
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
;
; Start SABOTCOD1
	jp	SABOTCOD0_END

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

INPUTB:	DEFB $00	; Input bits: 000FUDLR

; Game controls
;   7   6   5   4   3   2   1   0
;               Fr  Up  Dn  Lt  Rt
; Read Input, store to INPUTB and return in A
ReadInput:
	;PUSH HL
	ld  a, $91	; Программируем ППИ КР580ВВ55А
	ld  ($ff03),a	; Порты A и C - на ввод, порт B - на вывод
;
	ld  a,$fb
	ld  ($ff01),a	; Отправляем 0 в строку матрицы с нужными клавишами
	ld  a,($ff02)	; Встречаем 0 слева: R/L Home Up Dn
	cpl
	and $03		; Up/Down
	rla
	rla		; bits 3/2 = Up/Dn
	ld  b,a
	ld  a,($ff00)	; Встречаем 0 в справа: Tab AR2 Sp Lt ПВ Rt ПС ВК
	cpl
	ld  c,a
	rra
	rra
	rra		; A = Tab AR2 Sp Lt ПВ
	and $12		; Left + Tab
	or  b
	ld b,a
	ld a,c
	rra
	rra		; A = Tab AR2 Sp Lt ПВ Rt
	and $1		; Right
	or B
	ld b,a
	ld a,c
	and $A1		; check Tab / Sp / VK
	jp z,.aaa
	ld A,$10	; Fire
.aaa:	or B
	LD (INPUTB),A	; store input bits
	;POP HL
	RET

;----------------------------------------------------------------------------

	ALIGN 16
	DEFM "SABOTEUR 1 SPECIALIST NZEEMIN"
	DEFS 2
	INCLUDE "version.inc"

;----------------------------------------------------------------------------

	ALIGN 16
SABOTCOD0_END
	OUTEND
	END