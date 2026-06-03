;----------------------------------------------------------------------------

	INCLUDE "sabot0.inc"

;----------------------------------------------------------------------------

	OUTPUT "sabot1.bin"
	ORG	SABOTCOD0_END

	JP	LF9E7

;------------------------------------------------------------------------------

CHELTH EQU 1	; Cheat code for no damage
CVERT  EQU 0	; Cheat code for short route to Helicopter
;CBOMB EQU 0	; Cheat code for carrying BOMB
CSHORT EQU 0	; Cheat code for small map used to test main features

SCRTOP EQU $9820	; Game screen start address
SCRGME EQU SCRTOP+$0108	; Game screen inside the frame start address
SCRIND EQU SCRTOP+8*19	; Screen address for first indicators line

;----------------------------------------------------------------------------
; Variables

INPUTB:	DEFB $00	; Input bits: 000FUDLR

ROOM:	DEFW L791E	; Current Room address
NJASPR:	DEFW LA0B5	; Ninja sprite address

; Current Guard data
GARDPOS: DEFW 0		; Current Guard position in tilemap
GARDX:	DEFB 0		; Current Guard X position
GARDY:	DEFB 0		; Current Guard Y position

; Current Dog data, 9 bytes
DOGPOS:	DEFW $018E	; Dog position in tilemap
DOGDIR:	DEFB $00	; Dog direction
DOGX:	DEFB $08	; Dog X position
DOGST:	DEFB $00	; Dog state: 0 = run, 1 = changing direction, >= $42 is dead
DOGLTL:	DEFB $07	; Dog's left limit
DOGRTL:	DEFB $17	; Dog's right limit
DOGDIX:	DEFB $00	; Dog changing direction: 0 = right to left, 1 = left to right
DOGY:	DEFB $06	; Dog Y position

L71D4:	DEFB $F3	; Dog flag ??
L71D5:	DEFB $01	; Dog sprite number 0/1/2

NJAPOS:	DEFW 0		; Ninja position in tilemap: Y * 30 + X
NJADIR:	DEFB $00	; Ninja direction: 0 = left, 1 = right
NJAY:	DEFB 0		; Ninja Y within the room, 0 at the top
NJAX:	DEFB 0		; Ninja X within the room
NJAWLK:	DEFB $00	; Ninja walking phase
NJAFAL:	DEFB $00	; Ninja falling count, to decrease Energy on hit

MVTCN:	DEFB $07	; Counter used in movement handlers
DOGNOL:	DEFB $00	; Dog's flag: 1 = ignore left/right limit
L7345:	DEFB $14	; Dog ??

GARDST:	DEFB $0A	; Guard walking phase $00..$03 or other state: $09 = Guard dead; ...
GARDDIR: DEFB $01	; Guard direction

NRJ:	DEFB $13	; Energy $04..$13
NRJLO:	DEFB $01	; Energy lower, running bit

LA39E:	DEFB $00	; ?? 0 / 1

; Three objects, 8. bytes each
; 1st object - object thrown by Ninja
LA39F:	DEFB $00	; Thrown object tile
LA3A0:	DEFW 0		; Thrown object position
LA3A2:	DEFB $00
LA3A3:	DEFB $03
LA3A4:	DEFB 0		; Thrown object Y
LA3A5:	DEFB 0		; Thrown object X
; 2nd object - knife thrown by Guard
LA3A6:	DEFB $00
LA3A7:	DEFB $45,$01,$05,$05
LA3AB:	DEFB $0A,$19
; 3rd object - Turett
LA3AD:	DEFB $00
LA3AE:	DEFB $69,$00,$06,$06
LA382:	DEFB $03	; Turret Y
LA3B3:	DEFB $0F	; Turret X

GARDCN:	DEFB $01	; ?? Guard counter

LB2FD:	DEFB $C3	; Counter for Ninja/Guard head tile change

LB4DD:	DEFB $32	; Turret counter 50..0

LB595:	DEFB $00

TIMECN:	DEFB $15	; Time fast counter 50..0
LB5C5:	DEFB $01	; Ninja standing counter
TIMODE:	DEFB $00	; Time mode: $00 = time ticking; $01 = Time stopped; $02 = BOMB ticking mode

LB84A:	DEFW LD2F7+4	; Object address + 4, in table LD256
LB84C:	DEFB $00	; Object tile
LB84D:	DEFW $0000	; Object procedure address
LB84F:	DEFB $00	; NEAR item
LB850:	DEFB $C8	; HELD tile

LE388:	DEFM " 10"	; level bonus string
LE38B:	DEFB $0A	; level bonus value

;----------------------------------------------------------------------------

; Table of four addresses of Ninja/Guard walking sprites
L733B:	DEFW LD3DE	; Sprite Ninja/Guard walking 1
	DEFW LD408	; Sprite Ninja/Guard walking 2
	DEFW LD432	; Sprite Ninja/Guard walking 3
	DEFW LD45C	; Sprite Ninja/Guard walking 4

; Table of items: addresses for NEAR/HELD items
LB5B0:	DEFW LA7AD	; #0 Nothing
	DEFW LA819	; #1 Shuriken
	DEFW LA885	; #2 Knife
	DEFW LA8F1	; #3 ??
	DEFW LA95D	; #4 Brick
	DEFW LA9C9	; #5 Pipe
	DEFW LAA35	; #6 Granade
	DEFW LAAA1	; #7 Disk
	DEFW LAB0D	; #8 Bomb
	DEFW LAB79	; #9 Console

; Table used to translate Ninja tiles to Guard tiles, 19 records
LA787:	DEFB $50,$C7,$51,$DC,$54,$DD,$EA,$DE
	DEFB $13,$DF,$15,$E0,$16,$E1,$00,$E2
	DEFB $01,$E3,$03,$E4,$04,$E5,$4D,$E6
	DEFB $22,$E7,$2F,$E8,$30,$E9,$F4,$E2
	DEFB $F5,$E3,$E4,$E4,$F6,$E5

; Table of 35 records, 2 bytes each, see B851
LD210:	DEFB $04,$CE,$09,$63,$09,$63,$09,$63,$09,$63
	DEFB $09,$63,$09,$63,$09,$D4,$05,$D0,$05,$D0
	DEFB $05,$D0,$06,$D2,$08,$D6,$02,$CA,$03,$CC
	DEFB $05,$D0,$05,$D0,$05,$D0,$03,$CC,$02,$CA
	DEFB $02,$CA,$03,$CC,$02,$CA,$06,$D2,$02,$CA
	DEFB $06,$D2,$02,$CA,$03,$CC,$03,$CC,$03,$CC
	DEFB $04,$CE,$04,$CE,$04,$CE,$04,$CE,$04,$CE

	ALIGN 256
; Mirror table
MIRROR:	DEFB	$00,$80,$40,$C0,$20,$A0,$60,$E0,$10,$90,$50,$D0,$30,$B0,$70,$F0
	DEFB	$08,$88,$48,$C8,$28,$A8,$68,$E8,$18,$98,$58,$D8,$38,$B8,$78,$F8
	DEFB	$04,$84,$44,$C4,$24,$A4,$64,$E4,$14,$94,$54,$D4,$34,$B4,$74,$F4
	DEFB	$0C,$8C,$4C,$CC,$2C,$AC,$6C,$EC,$1C,$9C,$5C,$DC,$3C,$BC,$7C,$FC
	DEFB	$02,$82,$42,$C2,$22,$A2,$62,$E2,$12,$92,$52,$D2,$32,$B2,$72,$F2
	DEFB	$0A,$8A,$4A,$CA,$2A,$AA,$6A,$EA,$1A,$9A,$5A,$DA,$3A,$BA,$7A,$FA
	DEFB	$06,$86,$46,$C6,$26,$A6,$66,$E6,$16,$96,$56,$D6,$36,$B6,$76,$F6
	DEFB	$0E,$8E,$4E,$CE,$2E,$AE,$6E,$EE,$1E,$9E,$5E,$DE,$3E,$BE,$7E,$FE
	DEFB	$01,$81,$41,$C1,$21,$A1,$61,$E1,$11,$91,$51,$D1,$31,$B1,$71,$F1
	DEFB	$09,$89,$49,$C9,$29,$A9,$69,$E9,$19,$99,$59,$D9,$39,$B9,$79,$F9
	DEFB	$05,$85,$45,$C5,$25,$A5,$65,$E5,$15,$95,$55,$D5,$35,$B5,$75,$F5
	DEFB	$0D,$8D,$4D,$CD,$2D,$AD,$6D,$ED,$1D,$9D,$5D,$DD,$3D,$BD,$7D,$FD
	DEFB	$03,$83,$43,$C3,$23,$A3,$63,$E3,$13,$93,$53,$D3,$33,$B3,$73,$F3
	DEFB	$0B,$8B,$4B,$CB,$2B,$AB,$6B,$EB,$1B,$9B,$5B,$DB,$3B,$BB,$7B,$FB
	DEFB	$07,$87,$47,$C7,$27,$A7,$67,$E7,$17,$97,$57,$D7,$37,$B7,$77,$F7
	DEFB	$0F,$8F,$4F,$CF,$2F,$AF,$6F,$EF,$1F,$9F,$5F,$DF,$3F,$BF,$7F,$FF
	; Make sure the Mirror table properly aligned, so lower byte is 0
	ASSERT (MIRROR AND $FF) == 0
;
; Screen addresses for every 17 rows, used for Explosion drawing
LBAB3:	DEFW SCRGME+$00,SCRGME+$08,SCRGME+$10,SCRGME+$18
	DEFW SCRGME+$20,SCRGME+$28,SCRGME+$30,SCRGME+$38
	DEFW SCRGME+$40,SCRGME+$48,SCRGME+$50,SCRGME+$58
	DEFW SCRGME+$60,SCRGME+$68,SCRGME+$70,SCRGME+$78
	DEFW SCRGME+$80
	; Make sure the LBAB3 table properly aligned, so lower byte is 0
	ASSERT (LBAB3 AND $FF) == 0

; Table of game screen rows addresses, 10 rows, for auto-gun drawings
LA747:	DEFW SCRGME+$15,SCRGME+$1D,SCRGME+$25,SCRGME+$2D
	DEFW SCRGME+$35,SCRGME+$3D,SCRGME+$45,SCRGME+$4D
	DEFW SCRGME+$55,SCRGME+$5D

; Guards data, 24 records, 6 bytes each
; +$04: Guard state, initially $0A
; +$05: Guard direction
LA1E1:	DEFB $9D,$00,$07,$05,$0A,$01	; Room 94AB guard
LA1E7:	DEFB $18,$01,$0A,$09,$0A,$00	; Room 7DA9 guard
LA1ED:	DEFB $14,$01,$06,$09,$0A,$00	; Room 7E8C guard
LA1F3:	DEFB $13,$01,$05,$09,$0A,$00	; Room 920A guard
LA1F9:	DEFB $C8,$00,$14,$06,$0A,$00	; Room 8F84 guard
LA1FF:	DEFB $20,$01,$12,$09,$0A,$01	; Room 8B71 guard
LA205:	DEFB $50,$00,$14,$02,$0A,$01	; Room 8739 guard
LA20B:	DEFB $1E,$01,$10,$09,$0A,$00	; Room 858F guard
LA211:	DEFB $01,$01,$11,$08,$0A,$01	; Room 84EE guard
LA217:	DEFB $18,$01,$0A,$09,$0A,$00	; UNUSED, see A13D
LA21D:	DEFB $22,$01,$14,$09,$0A,$01	; Room 99A6 guard
LA223:	DEFB $F9,$00,$09,$08,$0A,$00	; Room 97F8 guard
LA229:	DEFB $02,$01,$12,$08,$0A,$01	; Room 94CF guard
LA22F:	DEFB $DF,$00,$0D,$07,$0A,$01	; Room 9B51 guard
LA235:	DEFB $F7,$00,$07,$08,$0A,$01	; Room 9F3A guard
LA23B:	DEFB $F8,$00,$08,$08,$0A,$00	; Room 9F7E guard
LA241:	DEFB $86,$00,$0E,$04,$0A,$01	; Room 9EB8 guard
LA247:	DEFB $A2,$00,$0C,$05,$0A,$00	; Room 9B19 guard
LA24D:	DEFB $BB,$00,$07,$06,$0A,$00	; Room 9DF5 guard
LA253:	DEFB $C2,$00,$0E,$06,$0A,$00	; Room 7C2E guard
LA259:	DEFB $D4,$00,$02,$07,$0A,$00	; Room 7F9C guard
LA25F:	DEFB $0B,$00,$0B,$00,$0A,$01	; Room 8162 guard
LA265:	DEFB $20,$01,$12,$09,$0A,$01	; Room 80A7 guard
LA26B:	DEFB $30,$00,$12,$01,$0A,$01	; Room 9B9D guard

; Guard data for rooms 7C9C/92EF
LC66B:	DEFB $0E,$00,$0E,$00,$04,$00

; Dogs data, 19 records, 10 bytes each
; +$00/$01: Dog position in tilemap
; +$02: Dog direction
; +$03: Dog X position
; +$05: Dog left limit
; +$06: Dog right limit
; +$08: Dog Y position
LA271:	DEFB $3C,$01,$00,$10,$00,$03,$16,$00,$03,$01	; Room 7C2E dog
LA27B:	DEFB $5E,$01,$01,$14,$00,$03,$16,$01,$04,$01	; Room 7F9C dog
LA285:	DEFB $A5,$00,$00,$0F,$00,$05,$0F,$00,$FE,$01	; Room 81E5 dog
LA28F:	DEFB $7A,$00,$01,$02,$00,$00,$18,$01,$FD,$01	; Room 8162 dog
LA299:	DEFB $8F,$01,$01,$09,$00,$03,$18,$01,$06,$01	; Room 7EF2 dog
LA2A3:	DEFB $8A,$01,$01,$04,$00,$02,$1A,$01,$06,$01	; Room 7E05 dog
LA2AD:	DEFB $9A,$01,$00,$14,$01,$03,$15,$01,$06,$01	; Room 80A7 dog
LA2B7:	DEFB $92,$01,$00,$0C,$00,$05,$19,$00,$06,$01	; Room 83ED dog
LA2C1:	DEFB $8C,$01,$01,$06,$01,$01,$17,$00,$06,$01	; Room 80F6 dog
LA2CB:	DEFB $90,$01,$00,$0A,$00,$04,$17,$00,$06,$01	; Room 924E dog
LA2D5:	DEFB $1B,$01,$01,$0D,$00,$06,$18,$01,$02,$01	; Room 91BA dog
LA2DF:	DEFB $76,$01,$01,$0E,$00,$00,$0F,$01,$05,$01	; Room 90DB dog
LA2E9:	DEFB $97,$01,$01,$11,$00,$0D,$1A,$01,$06,$01	; Room 909F dog
LA2F3:	DEFB $BC,$00,$00,$08,$00,$01,$0E,$00,$FF,$01	; Room 8802 dog
LA2FD:	DEFB $A4,$00,$00,$0E,$00,$02,$0E,$00,$FE,$01	; Room 8608 dog
LA307:	DEFB $8E,$01,$00,$08,$00,$07,$17,$00,$06,$01	; Room 844E dog
LA311:	DEFB $8D,$01,$01,$07,$00,$03,$15,$01,$06,$01	; Room 9739 dog
LA31B:	DEFB $F6,$00,$00,$06,$00,$02,$0F,$00,$01,$01	; Room 9A5A dog
LA325:	DEFB $8C,$01,$01,$06,$00,$04,$18,$01,$06,$01	; Room 9B9D dog

L71D6:	DEFB $7A,$00,$00,$02,$00,$01,$16,$00,$FD,$01	; Room 79C6 dog data

; Turrets data, 12 records, 3 bytes each
LA32F:	DEFB $C4,$00,$0E	; Room 7A17 turret
LA332:	DEFB $27,$00,$07	; Room 7F48/9A9A turret
LA335:	DEFB $11,$00,$0F	; Room 8FBD turret
LA338:	DEFB $2B,$00,$0A	; Room 7EF2/909F/92A7 turret
LA33B:	DEFB $4B,$00,$0D	; Room 8B25/8D5C turret
LA33E:	DEFB $2F,$00,$0F	; Room 7A17/8526 turret
LA341:	DEFB $32,$00,$12	; UNUSED, see A17E
LA344:	DEFB $9D,$00,$05	; Room 95D6 turret
LA347:	DEFB $A6,$00,$0E	; Room 968A turret
LA34A:	DEFB $0A,$01,$18	; Room 97A6 turret
LA34D:	DEFB $3F,$00,$01	; Room 9552 turret
LA350:	DEFB $A3,$00,$0B	; Room 9BE7 turret

; Table of Guard data addresses, 24 records
LAC72:	DEFW LA26B,LA265,LA25F,LA259
	DEFW LA253,LA217,LA24D,LA247
	DEFW LA241,LA23B,LA235,LA22F
	DEFW LA229,LA223,LA21D,LA211
	DEFW LA20B,LA205,LA1FF,LA1F9
	DEFW LA1F3,LA1ED,LA1E7,LA1E1

; Table of Dog data addresses, 20 records
LACA2:	DEFW LA31B,LA311,LA307,LA2FD
	DEFW LA2F3,LA2DF,LA2D5,LA2CB
	DEFW LA2C1,LA2B7,LA2A3,LA285
	DEFW LA325,LA2AD,LA28F,LA27B
	DEFW LA271,LA2E9,LA299,L71D6

; Table of objects, 35 records, 7 bytes each
; +$00/$01: Object tile address
; +$03: Object tile unique, to identify the object
; +$04: Object item, for NEAR indicator
; +$05: Object tile as object type
; +$05/$06: Object procedure, or $0000
LD256:	DEFW TLSCR0+2418	; Object 00: Brick
	DEFB $58,$04,$CE
	DEFW 0
	DEFW TLSCR0+212	; Object: Console in room 80F6
	DEFB $7C,$09,$63
	DEFW LB320	; Object procedure: flip trigger "D": set/remove wall in room 9739
	DEFW TLSCR0+212	; Object: Console in room 99A6
	DEFB $7D,$09,$63
	DEFW LB32A	; Object procedure: flip trigger "E": set/remove wall in room 97A6
	DEFW TLSCR0+212	; Object: Console in room 92A7
	DEFB $7E,$09,$63
	DEFW LB348	; Object procedure: flip trigger "A": set/remove wall in room 7F48
	DEFW TLSCR0+212	; Object: Console in room 92EF
	DEFB $7F,$09,$63
	DEFW LB334	; Object procedure: flip trigger "C": set/remove wall in room 8D5C
	DEFW TLSCR0+212	; Object: Console in room 9005
	DEFB $80,$09,$63
	DEFW LB33E	; Object procedure: flip trigger "B": set/remove wall in room 8F20
	DEFW TLSCR0+2642	; Object ?? 06
	DEFB $1F,$09,$63
LD285:	DEFW LB8D0	; Object procedure "Update Ninja on tilemap"
LD287:	DEFW TLSCR0+217	; Object ?? 07 Diskette
	DEFB $9C,$09,$D4
	DEFW 0
	DEFW TLSCR0+11	; Object ?? 08
	DEFB $9A,$05,$D0
	DEFW 0
	DEFW TLSCR0+448	; Object ?? 09
	DEFB $38,$05,$D0
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 10
	DEFB $81,$05,$D0
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 11
	DEFB $65,$06,$D2
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 12
	DEFB $66,$08,$D6
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 13
	DEFB $67,$02,$CA
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 14
	DEFB $68,$03,$CC
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 15
	DEFB $69,$05,$D0
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 16
	DEFB $6A,$05,$D0
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 17
	DEFB $6B,$05,$D0
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 18
	DEFB $6C,$03,$CC
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 19
	DEFB $6D,$02,$CA
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 20
	DEFB $6D,$02,$CA
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 21
	DEFB $6E,$03,$CC
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 22
	DEFB $6F,$02,$CA
	DEFW 0
LD2F7:	DEFW TLSCR0+212	; Object 23: Granade
	DEFB $70,$06,$D2
	DEFW 0
	DEFW TLSCR0+212	; Object 24: Knife
	DEFB $71,$02,$CA
	DEFW 0
	DEFW TLSCR0+212	; Object 25: Granade
	DEFB $72,$06,$D2
	DEFW 0
	DEFW TLSCR0+212	; Object 26: Knife
	DEFB $73,$02,$CA
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 27
	DEFB $74,$03,$CC
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 28
	DEFB $75,$03,$CC
	DEFW 0
	DEFW TLSCR0+212	; Object ?? 29
	DEFB $76,$03,$CC
	DEFW 0
	DEFW TLSCR0+212	; Object 30: Brick
	DEFB $77,$04,$CE
	DEFW 0
	DEFW TLSCR0+212	; Object 31: Brick
	DEFB $78,$04,$CE
	DEFW 0
	DEFW TLSCR0+212	; Object 32: Brick
	DEFB $79,$04,$CE
	DEFW 0
	DEFW TLSCR0+212	; Object 33: Brick
	DEFB $7A,$04,$CE
	DEFW 0
	DEFW TLSCR0+212	; Object 34: Brick
	DEFB $7B,$04,$CE
	DEFW 0

; Table of objects, 29 records, 5 bytes each
; +$00/$01: room address
; +$02/$03: address in Tile screen 0
; +$04: tile byte
LD34D:	DEFW L9ED9, TLSCR0+335	; Object ?? 00
	DEFB $81
	DEFW L9E22, TLSCR0+396	; Object ?? 01
	DEFB $65
LD357:	DEFW L9E22, TLSCR0+414	; BOMB, placement depends on Level
	DEFB $66
	DEFW L990D, TLSCR0+503	; Object ?? 03
	DEFB $67
	DEFW L8D5C, TLSCR0+471	; Object ?? 04
	DEFB $68
	DEFW L8EE1, TLSCR0+462	; Object ?? 05
	DEFB $69
	DEFW L889F, TLSCR0+332	; Object ?? 06
	DEFB $6A
	DEFW L890E, TLSCR0+265	; Object ?? 07
	DEFB $6B
	DEFW L8CC8, TLSCR0+498	; Object ?? 08
	DEFB $6C
	DEFW L8739, TLSCR0+282	; Object ?? 09
	DEFB $6D
	DEFW L8799, TLSCR0+455	; Object ?? 10
	DEFB $6E
	DEFW L913F, TLSCR0+498	; Object ?? 11
	DEFB $6F
	DEFW L8321, TLSCR0+487	; Object ?? 12
	DEFB $70
	DEFW L8162, TLSCR0+498	; Object ?? 13
	DEFB $71
	DEFW L7EF2, TLSCR0+504	; Object ?? 14
	DEFB $72
	DEFW L7F48, TLSCR0+436	; Object ?? 15
	DEFB $73
	DEFW L7C6D, TLSCR0+439	; Object ?? 16
	DEFB $74
	DEFW L7A9E, TLSCR0+461	; Object ?? 17
	DEFB $75
	DEFW L7A9E, TLSCR0+471	; Object ?? 18
	DEFB $76
	DEFW L7A9E, TLSCR0+473	; Object ?? 19
	DEFB $77
	DEFW L7AF8, TLSCR0+501	; Object ?? 20
	DEFB $78
	DEFW L7AF8, TLSCR0+502	; Object ?? 21
	DEFB $79
	DEFW L9376, TLSCR0+427	; Object ?? 22
	DEFB $7A
	DEFW L79C6, TLSCR0+501	; Object ?? 23
	DEFB $7B
	DEFW L80F6, TLSCR0+483	; Console in room 80F6
	DEFB $7C
	DEFW L99A6, TLSCR0+499	; Console in room 99A6
	DEFB $7D
	DEFW L92A7, TLSCR0+461	; Console in room 92A7, see D26B
	DEFB $7E
	DEFW L92EF, TLSCR0+216	; Console in room 92EF
	DEFB $7F
	DEFW L9005, TLSCR0+293	; Console in room 9005
	DEFB $80

; ?? Dog rooms/flags ?? 20 records, 3 bytes each
LDE84:	DEFW L79C6
	DEFB $00
	DEFW L7C2E
	DEFB $00
	DEFW L7F9C
	DEFB $01
	DEFW L81E5
	DEFB $00
	DEFW L8162
	DEFB $01
	DEFW L7EF2
	DEFB $01
	DEFW L7E05
	DEFB $01
	DEFW L80A7
	DEFB $00
	DEFW L83ED
	DEFB $00
	DEFW L80F6
	DEFB $00
	DEFW L924E
	DEFB $00
	DEFW L91BA
	DEFB $01
	DEFW L90DB
	DEFB $01
	DEFW L909F
	DEFB $00
	DEFW L8802
	DEFB $00
	DEFW L8608
	DEFB $00
	DEFW L844E
	DEFB $00
	DEFW L9739
	DEFB $01
	DEFW L9A5A
	DEFB $00
	DEFW L9B9D
	DEFB $01

; Level descriptions and data addresses
LE217:	DEFM "EXTREMELY EASY"
	DEFW LE38C
	DEFM "  VERY  EASY  "
	DEFW LE3A0
	DEFM "     EASY     "
	DEFW LE3B4
	DEFM "SLIGHTLY  EASY"
	DEFW LE3C8
	DEFM "   MODERATE   "
	DEFW LE3DC
	DEFM "SLIGHTLY  HARD"
	DEFW LE3F0
	DEFM "     HARD     "
	DEFW LE404
	DEFM "  VERY HARD   "
	DEFW LE418
	DEFM "EXTREMELY HARD"
	DEFW LE42C

; Levels data
; +$00: Guard counter value
; +$01: Dog counter value
; +$02: Turret counter value
; +$03/$04: two digits for TIME value
; +$05/$06: two digits for BOMB timer
; +$07: tile for wall in room 97A6
; +$08: token for wall in room 9739
; +$09: token for wall in room 7F48
; +$0A: token for wall in room 8D5C
; +$0B: token for wall in room 8F20
; +$0C: 3-char string for level bonus
; +$0F: level bonus value
; +$10/$11: room for BOMB placement
; +$12/$13: address in Tile screen 0 for BOMB placement
; Level 1 "EXTREMELY EASY"
LE38C:	DEFB $14,$19,$32
	DEFM "9999"
	DEFB $00,$0E,$0E,$0E,$0E
	DEFM " 10"
	DEFB $0A
	DEFW L9E22
	DEFW TLSCR0+414
; Level 2 "VERY EASY"
LE3A0:	DEFB $12,$0F,$2D
	DEFM "9995"
	DEFB $00,$0E,$0E,$0E,$0E
	DEFM " 20"
	DEFB $14
	DEFW L9E22
	DEFW TLSCR0+414
; Level 3 "EASY"
LE3B4	DEFB $10,$0C,$28
	DEFM "9590"
	DEFB $00,$26,$0E,$0E,$0E
	DEFM " 30"
	DEFB $1E
	DEFW L924E
	DEFW TLSCR0+504
; Level 4 "SLIGHTLY EASY"
LE3C8	DEFB $0E,$0A,$23
	DEFM "9080"
	DEFB $FF,$0E,$0E,$0E,$28
	DEFM " 50"
	DEFB $32
	DEFW L8608
	DEFW TLSCR0+503
; Level 5 "MODERATE"
LE3DC	DEFB $0C,$09,$1E
	DEFM "9070"
	DEFB $FF,$0E,$0E,$26,$0E
	DEFM " 70"
	DEFB $46
	DEFW L8689
	DEFW TLSCR0+322
; Level 6 "SLIGHTLY HARD"
LE3F0	DEFB $0A,$07,$19
	DEFM "8560"
	DEFB $FF,$26,$0E,$26,$0E
	DEFM "100"
	DEFB $64
	DEFW L8BAB
	DEFW TLSCR0+496
; Level 7 "HARD"
LE404	DEFB $08,$06,$14
	DEFM "8550"
	DEFB $FF,$26,$27,$26,$0E
	DEFM "130"
	DEFB $82
	DEFW L8D5C
	DEFW TLSCR0+455
; Level 8 "VERY HARD"
LE418	DEFB $05,$05,$0F
	DEFM "8050"
	DEFB $FF,$26,$27,$26,$28
	DEFM "170"
	DEFB $AA
	DEFW L8279
	DEFW TLSCR0+467
; Level 9 "EXTREMELY HARD"
LE42C:	DEFB $02,$03,$0A
	DEFM "7040"
	DEFB $FF,$26,$27,$26,$28
	DEFM "250"
	DEFB $FA
	DEFW L8608
	DEFW TLSCR0+503

;----------------------------------------------------------------------------

; Indicator messages
LAD4A:	DEFM "PAY : $ "
LAD52:	DEFM "00000"	; Pay value text
LAD57:	DEFM "99"	; Indicator time value
LAD59:	DEFM "HELDTIMENEAR"

LB061:	DEFM "00  $"

; String 18 spaces
LDEE6:	DEFM "                  "

; String 10 spaces
;LB0E8:	DEFM "          "

LB0F2:	DEFM "EXCELLENT WORK."
LB101:	DEFM "YOU ARE ONE OF"
LB10F:	DEFM " OUR TEN BEST"
LB11C:	DEFM "NINJA SABOTEURS."
LB12C:	DEFM "ENTER YOUR NAME..."

LBD2F:	DEFM "BOMB"

; Game over two-line messages
LBEEF:	DEFM "     SEPUKU    "
LBEFE:	DEFM "  MISSION ABORTED   "
LBF12:	DEFM "     ESCAPE    "
LBF21:	DEFM " MISSION SUCCESSFUL "
LBF35:	DEFM "    TIME OUT   "
LBF44:	DEFM " MISSION TERMINATED "
LBF58:	DEFM " SABOTEUR DEAD "
LBF67:	DEFM "  MISSION FAILURE   "

LC062:	DEFM "DISK RETRIEVED"
LC070:	DEFM "DISK "
LC075:	DEFM "BONUS: $05000"
LC087:	DEFM "TOTAL PAY : $"

TITLE:	DEFM "SABOTEUR 1"

; Menu text block
MENUTXT:
	DEFB VERSZ
VERSION:
	INCLUDE "version.inc"
VERSZ = $ - VERSION
	DEFB $00,$00,$00
	DEFB 7
LC082:	DEFM "LEVEL "
LEVED:	DEFM "1"	; Current Level digit
	DEFB $00,$00
	DEFB 13
	DEFM "START MISSION"
	DEFB $00,$00
	DEFB 11
	DEFM "INFORMATION"
	DEFB $FF

LE204:	DEFB 12
	DEFM "YOUR MISSION"
	DEFB 9
	DEFM "  WILL BE"
	DEFB $FF

; Information screen text block
SINFO:	DEFB 13
	DEFM "ORIGINAL GAME"
	DEFB 4
	DEFM "1985"
	DEFB 14
	DEFM "CLIVE TOWNSEND"
	DEFB $00
	DEFB 15
	DEFM "SPECIALIST PORT"
	DEFB 4
	DEFM "2026"
	DEFB 7
	DEFM "NZEEMIN"
	DEFB $00
	DEFB $00
	DEFB 9
	DEFM "CONTROLS:"
	DEFB $00
	DEFB 13
	DEFM "CURSOR ARROWS"
	DEFB 15
	DEFM "FIRE: TAB SP VK"
	;DEFB 16
	;DEFM "SUICIDE: US + SS"
	DEFB $FF

;----------------------------------------------------------------------------

; LDIR command replacement, but for B as counter (BC in full LDIR)
LDIR_B:
.loop:	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	dec b
	jp nz,.loop
	ret
; LDDR command replacement, but for B as counter (BC in full LDDR)
LDDR_B:
.loop:	ld a,(hl)
	ld (de),a
	dec hl
	dec de
	dec b
	jp nz,.loop
	ret

;----------------------------------------------------------------------------

; Show title picture (two ninjas)
L6289: 	LD HL,L62DB	; Encoded picture data address
 	LD DE,TLSCR0	; Tile screens address, used as a buffer
L628F: 	LD A,(HL)	; Load next byte of picture data
 	CP $02		; check for control byte $02 - end of sequence
 	JP Z,L62A9 	; => Copy the buffer to screen
 	INC HL		; move to next source byte
 	or a		; check for repeater marker
 	JP Z,L62A1 	; => repeat byte N times
 	CP $FF		; check for block marker
 	JP Z,L62A1 	; => repeat byte N times
 	LD (DE),A	; Store regular byte into tile screen
 	INC DE		; next buffer address
 	JP L628F	; Loop back to process next byte
L62A1: 	LD B,(HL)	; get repeat count
L62A2: 	LD (DE),A	; store repeated byte in buffer
 	INC DE		; next buffer address
	dec b
 	jp nz,L62A2	; repeat B times
 	INC HL		; move to next source byte
 	JP L628F	; continue processing
;
; Buffer is ready, copy to screen
L62A9: 	LD HL,SCRTOP+$00108 ; Start of screen
 	LD DE,TLSCR0	; Tile screens address
 	LD C,$0C	; Number of columns = 12
L62B1: 	PUSH HL		; save screen address
 	LD B,$18	; Number of rows = 24
L62B4: 	PUSH HL		; save screen address
 	PUSH BC		; save counters
 	LD B,$08	; 8 lines
L62B8: 	LD A,(DE)	; get picture byte
 	OR (HL)		; bitwise OR with screen pixels
 	LD (HL),A	; put to the screen
 	INC DE		; next address in the buffer
 	inc l		; next line
	dec b
 	jp nz,L62B8	; Repeat 8 times
 	POP BC		; restore counters
 	POP HL		; restore screen address
 	PUSH DE		; save address in picture buffer
 	LD DE,$0008	; -8
 	ADD HL,DE	; move HL to next tile row
 	POP DE		; restore address in picture buffer
	dec b
 	jp nz,L62B4	; continue loop for rows
 	POP HL		; restore screen address
 	inc h		; next column
 	DEC C		; decrement column counter
 	JP NZ,L62B1	; continue loop for columns
 	RET

; Room token #00: Barrel, 3x3 tiles 7C21; params: 2 bytes (address)
LB38F:	;POP HL
	INC HL
	LD A,(HL)
	INC HL
	PUSH HL
	LD H,(HL)
	LD L,A
	LD DE,L7C21	; Tile block address
	LD C,$03
LB39B:	LD B,$03
LB39D:	LD A,(DE)
	LD (HL),A
	INC DE
	INC HL
	dec b
	jp nz,LB39D
	PUSH DE
	LD DE,$001B
	ADD HL,DE
	POP DE
	DEC C
	JP NZ,LB39B
	JP LB702	; => Proceed to the next room token

; Room token #0B: Put one tile $2A at the given address; params: 2 bytes (address)
RTOK0B:	POP HL		; Restore token sequence address
	INC HL		; Skip token byte
	ld C,$2A	; tile $2A
	jp L7351	; => get address and do fill
;
; Room token #0E: Put one tile at the given address; params: 3 bytes (tile, address)
RTOK0E:	POP HL		; Restore token sequence address
	INC HL		; Skip token byte
	LD C,(HL)	; get tile byte
	INC HL
L7351:	LD A,(HL)	; get address low byte
	INC HL
	PUSH HL
	LD H,(HL)	; get address high byte
	LD L,A
	LD (HL),C	; put tile into tilemap
	JP LB702	; => Proceed to the next room token

; Room token #21..#30: Fill to down N tiles; params: 3 bytes (filler, address);
; count/height = token lower bits plus one
; A = token byte
RTOK2X:	INC HL		; Skip token byte
	and $1F		; 1..16
	inc A		; 2..17 = count/height
	ld B,A		; count
	ld DE,30	; shift = 30
	JP L7388	; => get tile and offset, do fill

; Room token #0C: Fill to right with $FF; params: 3 bytes (count, address)
RTOK0C:	LD DE,$0001	; Move right
	POP HL		; Restore token sequence address
	INC HL		; Skip token byte
	LD B,(HL)	; get count byte
	INC HL
	ld C,$FF
	jp L738A	; => get address and do fill
;
; Room token #04: Fill to right; params: 4 bytes (count, filler, address)
RTOK04:	LD DE,$0001	; Move right
	;JP L7384
L7384:	POP HL		; Restore token sequence address
	INC HL		; Skip token byte
	LD B,(HL)	; get count byte
	INC HL
L7388:	LD C,(HL)	; get tile byte
	INC HL
L738A:	LD A,(HL)	; get address low byte
	INC HL
	PUSH HL
	LD H,(HL)	; get address high byte
	LD L,A
L738F:	LD (HL),C
	ADD HL,DE
	dec b
	jp nz,L738F
	JP LB702	; => Proceed to the next room token

; Room token #06: Fill triangle from wide top
RTOK06:	LD A,$23	; A = "INC HL" command
;
L73A6:	LD (L73BB),A	; set the command
	POP HL		; Restore token sequence address
	INC HL		; Skip token byte
	LD D,(HL)	; get filler tile
	INC HL
	LD B,(HL)	; get count
	INC HL
	LD A,(HL)	; get address low byte
	INC HL
	PUSH HL
	LD H,(HL)	; get address high byte
	LD L,A
	LD A,D
	LD DE,30	; +30
L73B8:	PUSH HL
	LD C,B
L73BA:	LD (HL),A
L73BB:	INC HL		; !!MUT-CMD!! "INC HL" or "DEC HL" - move to next column
	DEC C
	JP NZ,L73BA
	POP HL
	ADD HL,DE	; next row
	dec b
	jp nz,L73B8
	JP LB702	; => Proceed to the next room token

; Room token #07: Fill triangle from wide bottom; params: 4 bytes (filler, count, address)
RTOK07:	LD A,$23	; A = "INC HL" command
;
L73C7:	LD (L73DE),A	; set the command
	POP HL		; Restore token sequence address
	INC HL		; Skip token byte
	LD D,(HL)	; get filler tile
	INC HL
	LD B,(HL)	; get count
	INC HL
	LD A,(HL)	; get address low byte
	INC HL
	PUSH HL
	LD H,(HL)	; get address high byte
	LD L,A
	LD A,D
	LD DE,30	; +30
	LD C,$01
L73DB:	PUSH HL
	PUSH BC
L73DD:	LD (HL),A
L73DE:	INC HL		; !!MUT-CMD!! "INC HL" or "DEC HL" - move right/left
	DEC C
	JP NZ,L73DD
	POP BC
	INC C
	POP HL
	ADD HL,DE	; next row
	dec b
	jp nz,L73DB
	JP LB702	; => Proceed to the next room token

; Room token #08: Fill triangle from wide bottom; params: 4 bytes (filler, count, address)
RTOK08:	LD A,$2B	; A = "DEC HL" command
	JP L73C7

; Room token #09: Fill triangle from wide top; params: 4 bytes (filler, count, address)
RTOK09:	LD A,$2B	; A = "DEC HL" command
	JP L73A6

; Room token #05: Fill entire screen with $FF; no params
RTOK05:	POP HL		; Restore token sequence address
	ld A,$FF	; tile byte $FF
	jp L73F6	; => Fill entire screen
;
; Room token #0D: Fill entire screen, use token as filler; no params
RTOKFI:	POP HL		; Restore token sequence address
	LD A,(HL)	; get token byte as tile byte
	;jp L73F6	; and fill entire screen
L73F6:	PUSH HL
	LD HL,TLSCR0	; Tile screen 0 start address
	call FillTilemap1 ; Fill TLSCR0 with tile A
	JP LB702	; => Proceed to the next room token

; Room token #05: UNUSED Copy block of tiles; params: 6 bytes (width, height, srcaddr, address)
L7406:	POP HL		; Restore token sequence address
	INC HL		; Skip token byte
	LD B,(HL)	; get width byte
	INC HL
	LD C,(HL)	; get height byte
	INC HL
	LD E,(HL)	; get source address low byte
	INC HL
	LD D,(HL)	; get source address high byte
	INC HL
L7410:	LD A,(HL)	; get address low byte
	INC HL
	PUSH HL
	LD H,(HL)	; get address high byte
	LD L,A
L7415:	PUSH BC
	PUSH HL
L7417:	LD A,(DE)
	LD (HL),A
	INC HL
	INC DE
	dec b
	jp nz,L7417	; continue loop by columns
	POP HL
	PUSH DE
	LD DE,$001E	; 30
	ADD HL,DE
	POP DE
	POP BC
	DEC C
	JP NZ,L7415	; continue loop by rows
	JP LB702	; => Proceed to the next room token

; Room token #0C: Copy block of tiles N times; params: 6 bytes (srcaddr, width, count, address)
; L742B:	POP HL		; Restore token sequence address
; 	INC HL		; Skip token byte
; 	LD E,(HL)	; get source address low byte
; 	INC HL
; 	LD D,(HL)	; get source address high byte
; 	INC HL
; 	LD C,(HL)	; get width byte
; 	INC HL
; 	LD B,(HL)	; get height byte
; 	INC HL
; 	LD A,(HL)	; get address low byte
; 	INC HL
; 	PUSH HL
; 	LD H,(HL)	; get address high byte
; 	LD L,A
; L743A:	PUSH HL
; 	PUSH BC
; 	PUSH DE
; L743D:	LD A,(DE)
; 	LD (HL),A
; 	INC HL
; 	INC DE
; 	DEC C
; 	JP NZ,L743D	; continue loop by columns
; 	POP DE
; 	POP BC
; 	POP HL
; 	PUSH DE
; 	LD DE,$001E	; 30
; 	ADD HL,DE
; 	POP DE
; 	dec b
; 	jp nz,L743A	; continue loop by rows
; 	JP LB702	; => Proceed to the next room token

; Room token #0F: Fill rectangle with $FF; params: 4 bytes (width, height, address)
RTOK0A:	POP HL		; Restore token sequence address
	INC HL		; Skip token byte
	ld D,$FF	; tile byte
	jp L7456	; => get params and fill rectangle

; Room token #03: Fill rectangle; params: 5 bytes (filler, width, height, address)
RTOK03:	POP HL		; Restore token sequence address
	INC HL		; Skip token byte
	LD D,(HL)
	INC HL
L7456:	LD C,(HL)
	INC HL
	LD B,(HL)
	INC HL
	LD A,(HL)
	INC HL
	PUSH HL
	LD H,(HL)
	LD L,A
	LD A,D
	LD DE,30	; +30
L7463:	PUSH HL
	PUSH BC
L7465:	LD (HL),A
	INC HL
	DEC C
	JP NZ,L7465
	POP BC
	POP HL
	ADD HL,DE
	dec b
	jp nz,L7463
	JP LB702	; => Proceed to the next room token

;------------------------------------------------------------------------------

; Initial Energy fill
L7472:	ld de,SCRIND+$0610 ; screen address
	ld a,$FF	; filler
	ld b,15
L7481:	push de
	ld c,16
L7485:	ld (de),a	; put to screen
	inc e		; line down
	dec c
	jp nz,L7485
	pop de
	inc d		; go right
	dec b
	jp nz,L7481
	LD A,$13
L7492:	LD (NRJ),A	; set Energy = MAX
	LD A,$01
L7497:	LD (NRJLO),A
	RET

; Decreasing Energy
L749E:	ld hl,SCRIND+$0110 ; screen address for line start + 1
	LD A,(NRJ)	; get Energy
	ld d,a
	ld e,$00
	add hl,de	; HL = screen address
	LD B,16
	LD A,(NRJLO)
	LD C,A
L74B2:	LD A,C
	XOR (HL)
	LD (HL),A
	inc l		; line down
	dec b
	jp nz,L74B2
	LD A,(NRJLO)
	rlca
	LD (NRJLO),A
	RET NC
	LD HL,NRJ	; Energy address
	DEC (HL)	; Decrease Energy
	RET

; Draw NEAR/HELD item
; Input: A = item number, HL = screen address
DRITEM:	push hl		; save screen address
	LD H,$00
	LD L,A
	ADD HL,HL
	LD DE,LB5B0	; address for Table of items
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
	pop hl		; restore screen address
	LD C,24		; 24 lines
.l10:	push hl
	LD B,4		; 4 in line
.l20:	LD A,(DE)
	LD (HL),A	; put to screen
	INC DE
	inc h		; one to right
	dec b
	jp nz,.l20
	pop hl
	inc l		; line down
	DEC C
	JP NZ,.l10
	RET

;----------------------------------------------------------------------------

; Process a dog
L9C44:	LD HL,DOGY	; dog Y position address
	LD A,(NJAY)	; get Ninja Y
	SUB (HL)
	CP $07
	JP NC,L9C80
	LD HL,L7345
	XOR A
	CP (HL)
	JP NZ,L9C5A
L9C56:	LD (HL),$19	; !!MUT-ARG!! Dog counter value
	JP L9C80
L9C5A:	DEC (HL)
	CP (HL)
	JP NZ,L9C80
	LD A,(DOGDIR)	; get Dog direction
	or a		; left?
	JP NZ,L9C71	; right =>
	LD A,(NJAX)	; get Ninja X
	INC A
	LD HL,DOGX	; Dog X position address
	CP (HL)
	JP C,L9C80
	JP L9C7B
L9C71:	LD A,(NJAX)	; get Ninja X
	INC A
	LD HL,DOGX	; Dog X position address
	CP (HL)
	JP NC,L9C80
L9C7B:	LD A,$01
	LD (DOGNOL),A	; set "Dog ignore left/right limit" flag
L9C80:	LD A,(DOGDIR)	; !!MUT-ARG!! get Dog direction
	LD (DOGDIR),A
	LD HL,DOGDIR
	LD (L9C80+1),HL
	CALL L9D5C	; Set update flags for Dog
	LD A,(DOGST)
	CP $42
	JP C,L9CA8
	LD HL,L9C9C	; Sprite Dog dead
	JP L9D31	; => Set Dog sprite = HL, Draw Dog in tilemap

; Part of Dog processing
L9CA8:	or a		; Dog state = 0 ?
	JP NZ,L9D8B
	LD HL,(DOGPOS)	; get Dog position in tilemap
	LD DE,TLSCR2+33	; Tile screen 2 + 33: for right direction
	LD A,(DOGDIR)	; get Dog direction
	or a		; right?
	jp nz,L9CBD	; right =>
	LD DE,TLSCR2+30	; Tile screen 2 + 30: for left direction
L9CBD:	ADD HL,DE	; now HL = Dog position in Ninja tile screen
	LD A,(HL)	; get tile from Ninja tile screen
	INC A		; $FF?
	LD B,$05
	CALL NZ,NRJDEC	; not $FF => Dog bites, decrease Energy by 5
	LD A,(DOGDIR)	; get Dog direction
	or a		; left?
	JP Z,L9CF1	; left =>

; Dog runs right
L9CCC:	LD HL,(DOGPOS)	; get Dog position in tilemap
	INC HL		; one tile right
	LD (DOGPOS),HL	; update Dog position in tilemap
	LD HL,DOGX	; Dog X position address
	INC (HL)	; one tile right
	LD A,(DOGNOL)
	CP $01
	JP Z,L9CE4
	LD A,(DOGRTL)	; get Dog's right limit
	CP (HL)
	JP NZ,L9D14
L9CE4:	XOR A
	LD (DOGNOL),A
	LD (DOGDIX),A
	INC A
	LD (DOGST),A	; ?? = 1
	JP L9D14

; Dog runs left
L9CF1:	LD HL,(DOGPOS)	; get Dog position in tilemap
	DEC HL		; one tile left
	LD (DOGPOS),HL	; update Dog position in tilemap
	LD HL,DOGX	; Dog X position address
	DEC (HL)	; one tile left
	LD A,(DOGNOL)
	CP $01
	JP Z,L9D09
	LD A,(DOGLTL)	; get Dog's left limit
	CP (HL)
	JP NZ,L9D14
L9D09:	XOR A
	LD (DOGNOL),A
	INC A
	LD (DOGDIX),A
	LD (DOGST),A	; ?? = 1
L9D14:	LD HL,L71D5
	INC (HL)
	LD A,$03
	CP (HL)
	JP NZ,L9D1F
	LD (HL),$00
L9D1F:	LD A,(HL)
	LD HL,L71F2	; Sprite Dog 1
	or a		; = 0 ?
	JP Z,L9D31	; => Set Dog sprite = HL, Draw Dog in tilemap
	LD HL,L71FE	; Sprite Dog 2
	CP $01
	JP Z,L9D31	; => Set Dog sprite = HL, Draw Dog in tilemap
	LD HL,L720A	; Sprite Dog 3

; Set Dog sprite = HL, Draw Dog in tilemap
L9D31:	LD (L9D3B+1),HL	; set Dog sprite = HL

; Draw Dog in tilemap
L9D34:	LD HL,(DOGPOS)
	LD DE,TLSCR3	; Tile screen 3 start address
	ADD HL,DE
L9D3B:	LD DE,L71FE	; !!MUT-ARG!! current Dog sprite address
	LD B,$03	; 3 rows
	LD A,(DOGDIR)	; get Dog direction
	or a		; left?
	JP Z,L9D75	; left => draw Dog facing left

; Draw Dog facing right in tilemap
L9D47:	LD C,$04	; 4 columns
L9D49:	LD A,(DE)
	LD (HL),A
	INC HL
	INC DE
	DEC C
	JP NZ,L9D49
	PUSH DE
	LD DE,$001A	; 26
	ADD HL,DE	; next row
	POP DE
	dec b
	jp nz,L9D47
L9D58:	CALL L9D5C	;Set update flags for Dog, 4x3 tiles
	RET

; Set update flags for Dog, 4x3 tiles
L9D5C:	LD C,$03	; 3 rows
	LD HL,(DOGPOS)
	LD DE,TLSCR1	; Tile screen 1 start address
	ADD HL,DE
	LD A,$01	; "need to update" flag
	LD DE,$001A	; 26
L9D6A:	LD B,$04	; 4 columns
L9D6C:	LD (HL),A	; set the flag
	INC HL		; next column
	dec b
	jp nz,L9D6C
	ADD HL,DE	; next row
	DEC C
	JP NZ,L9D6A	; continue loop by rows
	RET

; Draw Dog facing left in tilemap
L9D75:	INC HL
	INC HL
	INC HL
L9D78:	LD C,$04	; 4 rows
L9D7A:	LD A,(DE)
	LD (HL),A
	DEC HL
	INC DE
	DEC C
	JP NZ,L9D7A
	PUSH DE
	LD DE,$0022	; 34
	ADD HL,DE
	POP DE
	dec b
	jp nz,L9D78
	JP L9D58	; => Set update flags for Dog, and RET

; ?? something about Dog
L9D8B:	LD HL,L7216	; Sprite Dog 4
	LD (L9D3B+1),HL
	LD A,(DOGDIX)
	or a
	JP Z,L9DB3
	LD A,(DOGDIR)	; get Dog direction
	or a		; left?
	JP Z,L9DA6	; left =>
	DEC A
	LD (DOGST),A
	JP L9D34
L9DA6:	INC A
	LD (L71D4),A
	LD HL,L71D4
	LD (L9C80+1),HL
	JP L9D34
L9DB3:	LD A,(DOGDIR)	; get Dog direction
	or a		; left?
	JP Z,L9DC7	; left =>
	DEC A
	LD (L71D4),A
	LD HL,L71D4
	LD (L9C80+1),HL
	JP L9D34
L9DC7:	LD (DOGST),A
	JP L9D34

; Initialize a dog
; HL = dog data address
L9DCD:	LD DE,DOGPOS	; current dog data address
L9DD0:	LD (LB673+1),HL	; save current Dog data address
	ld b,$09	; 9 = size of Dog data
	call LDIR_B	; Copy Dog data
	RET

; Decrease Energy by B
NRJDEC:	RET		; !!MUT-CMD!! $C5 PUSH BC or $C9 RET
  IF CHELTH == 0	; Cheat code for no damage
	CALL L749E	; Decrease Energy
  ELSE
	DISPLAY "CHELTH cheat is ON"
	NOP
	NOP
	NOP
  ENDIF
	POP BC
	LD A,(NRJ)	; get Energy
	CP $04		; Energy = MIN ?
	JP NZ,L9DF1
	LD A,(NRJLO)	; get Energy lower
	CP $01
	JP NZ,L9DF1
L9DEC:	JP LBEAA	; !!MUT-CMD!! Energy is out => Saboteur dead
L9DF1:	dec b
	jp nz,NRJDEC	; continue loop by B
	RET

; Room 94AB initialization
LA0DF:	LD HL,LA1E1	; Guard data address
;
; Initialize a guard, then Standard room initialization
LA0E2:	CALL LB40A	; Initialize a guard
	JP LB422	; Standard room initialization

; Room 7DA9 initialization
LA0E8:	LD HL,LA1E7	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 7E8C initialization
LA0ED:	LD HL,LA1ED	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 920A initialization
LA0F2:	LD HL,LA1F3	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 8F84 initialization
LA0F7:	LD HL,LA1F9	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 8B71 initialization
LA0FC:	LD HL,LA1FF	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 8739 initialization
LA101:	LD HL,LA205	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 858F initialization
LA106:	LD HL,LA20B	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 84EE initialization
LA10B:	LD HL,LA211	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 99A6 initialization
LA110:	LD HL,LA21D	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 97F8 initialization
LA115:	LD HL,LA223	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 94CF initialization
LA11A:	LD HL,LA229	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 9B51 initialization
LA11F:	LD HL,LA22F	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 9F3A initialization
LA124:	LD HL,LA235	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 9F7E initialization
LA129:	LD HL,LA23B	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 9EB8 initialization
LA12E:	LD HL,LA241	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 9B19 initialization
LA133:	LD HL,LA247	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 9DF5 initialization
LA138:	LD HL,LA24D	; Guard data address
	JP LA0E2	; Initialize a guard, then Standard room initialization

; Room 7A17 initialization
LA142:	LD HL,LA33E	; Turret data address

; Initialize a turret, then Standard room initialization
LA145:	CALL LB461	; Initialize a turret
	JP LA0E5	; Standard room initialization

; Room 7D5A initialization
LA14A:	LD HL,LA32F	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 7F48 initialization
LA14F:	LD HL,LA332	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 7EF2 initialization
LA154:	LD HL,LA299	; Dog data address
	CALL L9DCD	; Initialize a dog
	LD HL,LA338	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 909F initialization
LA15F:	LD HL,LA2E9	; Dog data address
	CALL L9DCD	; Initialize a dog
	LD HL,LA338	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 8FBD initialization
LA16A:	LD HL,LA335	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 92A7 initialization
LA16F:	LD HL,LA338	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 8B25 initialization
LA174:	LD HL,LA33B	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 8526 initialization
LA179:	LD HL,LA33E	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 95D6 initialization
LA183:	LD HL,LA344	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 968A initialization
LA188:	LD HL,LA347	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Finish Room 97A6 initialization
LA18D:	LD HL,LA34A	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 9A9A initialization
LA192:	LD HL,LA332	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 9552 initialization
LA197:	LD HL,LA34D	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 9BE7 initialization
LA19C:	LD HL,LA350	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 8D5C initialization
LA1A1:	LD HL,LA33B	; Turret data address
	JP LA145	; Initialize a turret, then Standard room initialization

; Room 7C2E initialization
LA1A6:	LD HL,LA271	; Dog data address
	CALL L9DCD	; Initialize a dog
	LD HL,LA253	; Guard data address

; Finish room initialization
LA1AF:	CALL LB40A	; Initialize a guard
	JP LB422	; Standard room initialization

; Room 7F9C initialization
LA1B5:	LD HL,LA27B	; Dog data address
	CALL L9DCD	; Initialize a dog
	LD HL,LA259	; Guard data address
	JP LA1AF	; Initialize a guard, then Standard room initialization

; Room 8162 initialization
LA1C0:	LD HL,LA28F	; Dog data address
	CALL L9DCD	; Initialize a dog
	LD HL,LA25F	; Guard data address
	JP LA1AF	; Initialize a guard, then Standard room initialization

; Room 80A7 initialization
LA1CB:	LD HL,LA2AD	; Dog data address
	CALL L9DCD	; Initialize a dog
	LD HL,LA265	; Guard data address
	JP LA1AF	; Initialize a guard, then Standard room initialization

; Room 9B9D initialization
LA1D6:	LD HL,LA325	; Dog data address
	CALL L9DCD	; Initialize a dog
	LD HL,LA26B	; Guard data address
	JP LA1AF	; Initialize a guard, then Standard room initialization

; Room 81E5 initialization
LA353:	LD HL,LA285	; Dog data address
; Initialize a dog, then Standard room initialization
LA356:	CALL L9DCD	; Initialize a dog
	JP LB422	; Standard room initialization

; Room 7E05 initialization
LA35C:	LD HL,LA2A3	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Room 83ED initialization
LA361:	LD HL,LA2B7	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Room 924E initialization
LA366:	LD HL,LA2CB	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Room 91BA initialization
LA36B:	LD HL,LA2D5	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Room 90DB initialization
LA370:	LD HL,LA2DF	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Room 8802 initialization
LA375:	LD HL,LA2F3	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Room 8608 initialization
LA37A:	LD HL,LA2FD	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Room 844E initialization
LA37F:	LD HL,LA307	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Room 9739 initialization
LA384:	LD HL,LA311	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Room 9A5A initialization
LA389:	LD HL,LA31B	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Room 80F6 initialization
LA38E:	LD HL,LA2C1	; Dog data address
	JP LA356	; Initialize a dog, then Standard room initialization

; Ninja and Guard in 12 tiles by X
LA3B5:	LD A,(NJAY)	; get Ninja Y
	LD HL,GARDY	; Guard Y position address
	CP (HL)		; compare Ninja Y to Guard Y
	RET NZ
	POP HL
LA3BE:	LD A,$14	; !!MUT-ARG!! ??
	LD (GARDCN),A	; set Guard counter
	LD A,$0B
	LD (GARDST),A	; set Guard state = $0B = auto-gun
	LD HL,LD504	; Sprite Ninja/Guard punching
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap

; Ninja and Guard in 9 tiles by X
LA3D1:	LD A,(NJAY)	; get Ninja Y
	LD HL,GARDY	; Guard Y position address
	CP (HL)		; compare Ninja Y to Guard Y
	RET NZ
	LD A,(LA3A6)
	or a		; Object #2 active?
	RET NZ		; yes => return
	POP HL
	LD A,$14
	LD (GARDST),A	; set Guard state = $14 = throw knife
	LD HL,LD504	; Sprite Ninja/Guard punching
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap

; Ninja and Guard in 3 tiles by X
LA3EE:	LD A,(NJAY)	; get Ninja Y
	LD HL,GARDY	; Guard Y position address
	CP (HL)		; compare Ninja Y to Guard Y
	RET NZ
	LD HL,(GARDPOS)	; get Guard position in tilemap
	LD DE,TLSCR0+2	; Tile screen 0 + 2
	ADD HL,DE	; now HL in Back tile screen
	LD A,$64
	CP (HL)
	RET C
	INC HL
	CP (HL)
	RET C
	POP HL
	LD A,$05
	LD (GARDST),A	; set Guard state = $05 jump
	LD A,$02
	LD (GARDCN),A	; set Guard counter = 2
	LD HL,LD4B0	; Sprite Ninja/Guard jumping
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap

; Ninja and Guard are very close by X
LA418:	LD A,(NJAY)	; get Ninja Y
	LD HL,GARDY	; Guard Y position address
	CP (HL)		; compare Ninja Y to Guard Y
	RET NZ
	POP HL
	LD A,$08
	LD (GARDST),A	; set Guard state = $08 punch
	LD A,$03
	LD (GARDCN),A	; set Guard counter = 3
	LD HL,LD504	; Sprite Ninja/Guard punching
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap

; Process a Guard
LA434:	CALL UPGARD	; Set update flags for Guard, 6x7 tiles
	LD HL,GARDST	; Guard state address
	LD A,(HL)	; get Guard state
	cp $15		; < $15 ?
	jp nc,LA614
	add a,a		; * 2
	ld l,a
	ld h,0
	ld de,GuardStateTbl
	add hl,de
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
GuardStateTbl:
	dw	LA614	; $00  walk 0
	dw	LA614	; $01  walk 1
	dw	LA614	; $02  walk 2
	dw	LA614	; $03  walk 3
	dw	LA614	; $04
	dw	LA5AE	; $05  jump
	dw	LA5CB	; $06  jump-kick
	dw	LA600	; $07  back to standing
	dw	LA57E	; $08  punch
	dw	LA571	; $09  dead
	dw	LA533	; $0A  standing
	dw	LA440	; $0B  auto-gun
	dw	LA614	; $0C
	dw	LA614	; $0D
	dw	LA614	; $0E
	dw	LA614	; $0F
	dw	LA614	; $10
	dw	LA614	; $11
	dw	LA614	; $12
	dw	LA614	; $13
	dw	LA4EB	; $14  throw knife

; Guard state = $0B = auto-gun
LA440:	LD HL,GARDCN	; Guard counter address
	DEC (HL)	; decrease Guard counter
	LD A,(HL)	; get Guard counter
	CP $06
	JP NC,LA6FF	; => Draw Guard on tilemap
	ld a,$0B
	ld ($ff03),A	; sound on
	LD A,(GARDY)	; get Guard Y
	ADD A,A		; Guard Y * 2
	ld e,a
	ld d,0
	ld hl,LA747	; table of game screen rows addresses
	add hl,de	; now HL = address in the table
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a		; now HL = address on the screen
	LD A,(GARDX)	; get Guard X
	add a,h
	ld h,a
	LD DE,$003C	; +60 = two rows
	LD A,(GARDX)	; get Guard X
	INC A
	PUSH HL		; save screen address
	LD HL,(GARDPOS)	; get Current Guard position in tilemap
	ADD HL,DE	; +60
	EX DE,HL	; now DE = Guard position + two rows
	POP HL		; restore screen address
	LD B,A
	ld a,$25	; "dec h" instruction
	LD (LA4D0),A	; set the instruction
	LD A,$1B	; "DEC DE" instruction
	LD (LA4D1),A	; set the instruction
	LD A,(GARDDIR)	; get Guard direction
	or a		; left?
	JP Z,LA4A2	; yes =>
	LD A,$1A	; 26
	SUB B
	LD B,A
	INC DE
	INC DE
	INC DE
	INC DE
	INC DE		; +5
	inc h
	inc h
	inc h
	inc h
	inc h		; +5
	ld a,$24	; "inc h" instruction
	LD (LA4D0),A	; set the instruction
	LD A,$13	; "INC DE" instruction
	LD (LA4D1),A	; set the instruction
LA4A2:	PUSH HL		; save screen address
	LD HL,TLSCR0	; Tile screen 0 start address
	ADD HL,DE
	LD A,$64
	CP (HL)		; check background tile
	JP C,LA4CD
	LD HL,TLSCR5	; Tile screen 5 start address
	ADD HL,DE
	LD A,(HL)	; check front tile
	INC A		; $FF ?
	JP NZ,LA4C0
	LD HL,TLSCR1	; Tile screen 1 start address
	ADD HL,DE
	LD (HL),$01	; set "need update" marker
	POP HL		; restore screen address
	PUSH HL
	LD A,$CC
	XOR (HL)
	LD (HL),A
LA4C0:	LD HL,TLSCR2	; Tile screen 2 start address
	ADD HL,DE
	LD A,(HL)
	INC A		; $FF ?
	JP Z,LA4CF	; yes =>
	LD B,$04	; Ninja hit
	CALL NRJDEC	; Decrease Energy by B
LA4CD:	LD B,$01
LA4CF:	POP HL		; restore screen address
LA4D0:	dec h		; !!MUT-CMD!! "dec h" or "inc h" instruction
LA4D1:	DEC DE		; !!MUT-CMD!! "DEC DE" or "INC DE" instruction
	dec b
	jp nz,LA4A2
	xor a
	ld ($ff03),A	; sound off
	LD A,(GARDCN)	; get Guard counter
	or a		; 0 ?
	JP NZ,LA6FF	; no => Draw Guard on tilemap
	LD A,$04
	LD (GARDST),A	; set Guard state = $04
	JP LA6FF	; => Draw Guard on tilemap

; Guard state = $14 = throwing a knife
LA4EB:	ld hl,GARDST	; Guard state address
	LD (HL),$04	; set Guard state = $04
	LD HL,LD486	; Sprite Ninja/Guard standing
	LD (LA70E+1),HL	; set Guard sprite
	LD HL,(GARDPOS)	; get Guard position in tilemap
	LD DE,$003C	; 60
	LD B,$00
	LD C,$03
	LD A,(GARDDIR)	; get Guard direction
	or a		; left?
	JP Z,LA50B	; left =>
	LD C,$05
	LD B,$05
	LD DE,$0041	; 65
LA50B:	ADD HL,DE
	LD (LA3A7),HL	; set 2nd object position
	LD A,(GARDX)	; get Guard X
	ADD A,B
	ld hl,LA3A6	; 2nd object address
	ld (hl),$CA	; IX+$00
	inc hl
	inc hl
	inc hl		; IX+$03
	ld (hl),c
	inc hl		; IX+$04
	ld (hl),c
	inc hl
	inc hl		; IX+$06
	ld (hl),a
	dec hl		; IX+$05
	LD A,(GARDY)	; get Guard Y
	ADD A,$02	; Guard Y + 2
	ld (hl),a
	JP LA6FF	; => Draw Guard on tilemap

; Guard state = $0A - Standing
LA533:	LD HL,LD486	; Sprite Ninja/Guard standing
	LD (LA70E+1),HL	; set Guard sprite
	LD HL,NJAY	; Ninja Y address
	LD A,(GARDY)	; get Guard Y
	ADD A,$03	; Guard Y + 3
	CP (HL)		; compare with Ninja Y
	JP C,LA6FF	; Guard above Ninja => Draw Guard on tilemap
	LD A,(LA39E)
	DEC A
	JP Z,LA565
	LD A,(GARDDIR)	; get Guard direction: 0 / 1
	DEC A		; $FF left / 0 right
	LD A,(GARDX)	; get Guard X
	LD HL,NJAX	; Ninja X address
	JP Z,LA55F	; right =>
	ADD A,$02	; for left, Guard X + 2
	CP (HL)		; compare with Ninja X
	JP C,LA6FF	; Guard still behind Ninja => Draw Guard on tilemap
	JP LA565
LA55F:	SUB $03		; for right, Guard X - 3
	CP (HL)		; compare with Ninja X
	JP NC,LA6FF	; Guard not reached Ninja => Draw Guard on tilemap
LA565:	LD A,$04	; state $04
	LD (GARDST),A	; set Guard state = $04
	JP LA6FF	; => Draw Guard on tilemap

; Guard state = $09 - Guard is dead
LA571:	LD HL,LA0B5	; Sprite Ninja dead
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap

; Guard state = $08 - Punching
LA57E:	LD HL,GARDCN	; Guard counter address
	DEC (HL)	; decrease Guard counter
	JP NZ,LA6FF	; => Draw Guard on tilemap
	ld hl,GARDST	; Guard state address
	LD (HL),$03	; set Guard state = walking state 3
	LD HL,(GARDPOS)
	LD DE,TLSCR2+64	; Tile screen 2 + 64
	LD A,(GARDDIR)	; get Guard direction
	or a
	jp nz,LA599	; right =>
	LD DE,TLSCR2+61	; Tile screen 2 + 61
LA599:	ADD HL,DE
	LD A,(HL)
	INC A
	LD B,$06
	CALL NZ,LFA31	; => Decrease Energy by B + Sound
	LD HL,LD486	; Sprite Ninja/Guard standing
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap

; Guard state = $05 - jump
LA5AE:	LD HL,GARDCN	; Guard counter address
	DEC (HL)	; decrease Guard counter
	JP NZ,LA6FF	; => Draw Guard on tilemap
	LD A,$03
	LD (GARDCN),A	; set Guard counter = 3
	ld hl,GARDST	; Guard state address
	LD (HL),$06	; set Guard state = $06: jump-kick
	LD HL,LD4DA	; Sprite Ninja/Guard jump-kick
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap

; Guard state = $06 - jump-kick
LA5CB:	LD HL,GARDCN	; Guard counter address
	DEC (HL)	; decrease Guard counter
	JP NZ,LA6FF	; => Draw Guard on tilemap
	LD A,$01
	LD (GARDCN),A	; set Guard counter = 1
	ld hl,GARDST	; Guard state address
	LD (HL),$07	; set Guard state = $07: back to standing
	LD HL,LD4B0	; Sprite Ninja/Guard jumping
	LD (LA70E+1),HL	; set Guard sprite
	LD HL,(GARDPOS)	; get Guard position in tilemap
	LD DE,TLSCR2+65	; Tile screen 2 + 65
	LD A,(GARDDIR)	; get Guard direction
	or a
	jp nz,LA5F1	; right =>
	LD DE,TLSCR2+60	; Tile screen 2 + 60
LA5F1:	ADD HL,DE	; now HL = address in Ninja tile screen
	LD A,(HL)	; get tile from Ninja screen
	INC A		; $FF ?
	LD B,$0A	; 10 damage
	CALL NZ,LFA31	; not $FF => Decrease Energy by 10 + Sound
	JP LA6FF	; => Draw Guard on tilemap

; Guard state = $07 - back to standing
LA600:	LD HL,GARDCN	; Guard counter address
	DEC (HL)	; decrease Guard counter
	JP NZ,LA6FF	; counter not zero => Draw Guard on tilemap
	ld hl,GARDST	; Guard state address
	LD (HL),$03	; set Guard state = walking phase 3
	LD HL,LD486	; Sprite Ninja/Guard standing
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap

; Guard state is none of the above
LA614:	LD HL,NJAX	; Ninja X address
	LD A,(GARDX)	; get Guard X
	SUB (HL)	; compare to Ninja X
	JP NZ,LA635	; not equal =>
	CALL LA418
	LD HL,GARDST	; Guard state address
	LD A,$0A
	CP (HL)		; Guard state = $0A standing ?
	JP Z,LA6FF	; Guard state is $0A => Draw Guard on tilemap
	LD A,$04
	LD (HL),A	; set Guard state = $04
	LD HL,LD486	; Sprite Ninja/Guard standing
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap

; Guard X != Ninja X
LA635:	JP C,LA68C	; Guard X < Ninja X =>

; Ninja X < Guard X
LA637:	LD B,A		; save value "Guard X - Ninja X"
	LD A,(GARDDIR)	; get Guard direction
	or a		; left?
	JP Z,LA65B	; left =>
	LD A,(GARDST)	; get Guard state
	CP $04		; Guard state = $04 ?
	JP Z,LA654	; yes =>
	LD A,$04
	LD (GARDST),A	; set Guard state = $04
	LD HL,LD486	; Sprite Ninja/Guard standing
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap
LA654:	XOR A
	LD (GARDDIR),A	; set Guard direction = left
	JP LA6FF	; => Draw Guard on tilemap
LA65B:	LD A,B		; restore value "Guard X - Ninja X"
	CP $03		; 3
	CALL Z,LA3EE
	CP $01		; 1
	CALL Z,LA418
	CP $09		; 9
	CALL Z,LA3D1
	CP $0C		; 12
	CALL Z,LA3B5
	LD A,(GARDST)	; get Guard state
	CP $04		; Guard state = $04 ?
	JP NZ,LA67F	; no =>
	LD A,$03	; walking phase 3
	LD (GARDST),A	; set Guard state = $03 walk 3
	JP LA6FF	; => Draw Guard on tilemap
LA67F:	LD HL,GARDX	; Guard X address
	DEC (HL)	; decrease Guard X - move one tile left
	XOR A
	LD (GARDDIR),A	; set Guard direction = left
	LD DE,$FFFF
	JP LA6DE

; Guard X < Ninja X
LA68C:	LD B,A
	LD A,(GARDDIR)	; get Guard direction
	or a
	jp nz,LA6AF	; right =>
	LD A,(GARDST)	; get Guard state
	CP $04		; Guard state = $04 ?
	JP Z,LA6A8
	LD A,$04
	LD (GARDST),A	; set Guard state = $04
	LD HL,LD486	; Sprite Ninja/Guard standing
	LD (LA70E+1),HL	; set Guard sprite
	JP LA6FF	; => Draw Guard on tilemap
LA6A8:	LD A,$01
	LD (GARDDIR),A	; set Guard direction = right
	JP LA6FF	; => Draw Guard on tilemap
LA6AF:	LD A,B
	CP $FD		; -3
	CALL Z,LA3EE
	CP $FF		; -1
	CALL Z,LA418
	CP $F7		; -9
	CALL Z,LA3D1
	CP $F4		; -12
	CALL Z,LA3B5
	LD A,(GARDST)	; get Guard state
	CP $04		; Guard state = $04 ?
	JP NZ,LA6D2
	LD A,$03
	LD (GARDST),A	; set Guard state = $03 walk 3
	JP LA6FF	; => Draw Guard on tilemap
LA6D2:	LD HL,GARDX	; Guard X address
	INC (HL)	; increase Guard X - move one tile right
	LD A,$01
	LD (GARDDIR),A	; set Guard direction = right
	LD DE,$0001
LA6DE:	LD HL,(GARDPOS)	; get Guard position in tilemap
	ADD HL,DE
	LD (GARDPOS),HL	; update Guard position in tilemap
	LD A,(GARDST)	; get Guard state
	INC A		; next walking phase
	AND $03		; 0..3
	LD (GARDST),A	; set Guard state = $03 walk 0..3
	ADD A,A		; * 2
	LD L,A
	LD H,$00
	LD DE,L733B	; Table of four Ninja/Guard walking sprites
	ADD HL,DE
	LD DE,LA70E+1	; Guard sprite address
	LD A,(HL)
	LD (DE),A
	INC HL
	INC DE
	LD A,(HL)
	LD (DE),A

; Draw Guard on tilemap
LA6FF:	ld hl,(GARDPOS)	; get Guard position in tilemap
	ex de,hl
	LD A,(GARDDIR)	; get Guard direction
	or a		; left?
	JP NZ,LA728	; right =>
	LD HL,TLSCR4+5	; Tile screen 4 start address + 5
	ADD HL,DE
LA70E:	LD DE,LD432	; !!MUT-ARG!! current Ninja/Guard sprite address
	LD B,$07	; 7 rows
LA713:	LD C,$06	; 6 rows
LA715:	LD A,(DE)
	CALL LA775	; Translate Ninja tile A into Guard tile
	LD (HL),A
	DEC HL
	INC DE
	DEC C
	JP NZ,LA715
	PUSH DE
	LD DE,$0024	; 36
	ADD HL,DE	; next row
	POP DE
	dec b
	jp nz,LA713	; continue loop by rows
	RET
LA728:	LD HL,TLSCR4	; Tile screen 4 start address
	ADD HL,DE
	ex de,hl
	ld hl,(LA70E+1)	; get Guard sprite address
	ex de,hl
	LD B,$07	; 7 rows
LA732:	LD C,$06	; 6 rows
LA734:	LD A,(DE)	; get tile
	CALL LA775	; Translate Ninja tile A into Guard tile
	LD (HL),A
	INC HL
	INC DE
	DEC C
	JP NZ,LA734
	PUSH DE
	LD DE,$0018	; 24
	ADD HL,DE	; next row
	POP DE
	dec b
	jp nz,LA732	; continue loop by rows
	RET

; Set update flags for Ninja, 6x7 tiles
UPNJA:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	jp LA763
;
; Set update flags for Guard, 6x7 tiles
UPGARD:	ld hl,(GARDPOS)	; get Current Guard position in tilemap
LA763:	ld DE,TLSCR1+2	; Tile screen 1 start address + 2
	ADD HL,DE	; now HL in update flags tilemap
	LD A,$01	; "need to update" flag
; 1st row: __XX__
	ld (HL),A	; set the flag
	inc HL
	ld (HL),A	; set the flag
	ld DE,27
	add HL,DE	; next row
; other rows: XXXXXX
	LD DE,24
	LD B,$06	; 6 rows
LA76A:	LD C,$06	; 6 columns
LA76C:	LD (HL),A	; set the flag
	INC HL		; next column
	DEC C
	JP NZ,LA76C	; continue loop by columns
	ADD HL,DE	; next row
	dec b
	jp nz,LA76A	; continue loop by rows
	RET

; Translate Ninja tile A into Guard tile, using A787 table
LA775:	push hl
	push bc
	LD HL,LA787	; Translate table address
	LD B,$13	; 19 records
LA77B:	CP (HL)		; found the tile?
	INC HL
	JP NZ,LA782
	LD A,(HL)	; get the new tile
	pop bc
	pop hl
	RET
LA782:	INC HL
	dec b
	jp nz,LA77B	; continue the loop
	pop bc
	pop hl
	RET

;----------------------------------------------------------------------------

; Explosion image, 3x3 tiles
LABE5:	DEFB $04,$66,$06,$03,$4B,$E3,$C3,$43
	DEFB $48,$08,$18,$18,$39,$BB,$FF,$FF
	DEFB $01,$04,$60,$C0,$86,$1C,$F8,$F1
LABFD:	DEFB $03,$7F,$1F,$03,$43,$C7,$0F,$AF
	DEFB $88,$01,$81,$01,$65,$E7,$EF,$E0
	DEFB $E0,$C8,$82,$86,$84,$C4,$E1,$F0
	DEFB $0F,$9E,$BC,$30,$61,$C3,$83,$10
	DEFB $7D,$38,$38,$30,$10,$11,$10,$50
	DEFB $F1,$F9,$38,$1C,$06,$03,$10,$41

; Data block at AC2D
;LAC2D:	DEFB $00,$00,$00,$00,$00,$00,$00,$00
;	DEFB $00,$00,$00,$00,$00,$00,$00,$00
;	DEFB $00,$00,$00,$00,$00,$00,$00

; Reset Guard data and Dog data
LAC44:	LD HL,LAC72	; address for Table of Guard data addresses
	LD B,$18	; 24
LAC49:	LD E,(HL)
	INC HL
	LD D,(HL)	; now DE = Guard data address
	INC HL
	PUSH HL
	LD HL,$0004
	ADD HL,DE
	LD (HL),$0A	; set initial Guard energy = 10
	POP HL
	dec b
	jp nz,LAC49
	LD HL,LACA2	; address for Table of Dog data addresses
	LD B,$14	; 20
LAC5C:	LD E,(HL)
	INC HL
	LD D,(HL)
	INC HL
	PUSH HL
	LD HL,$0004
	ADD HL,DE
	LD A,$41
	CP (HL)
	JP NC,LAC6E
	LD A,(HL)
	SUB $42
	LD (HL),A
LAC6E:	POP HL
	dec b
	jp nz,LAC5C
	RET

; Draw game screen frames and indicator text
LACCA:	LD HL,SCRTOP	; Screen start address
	LD DE,LAD65	; Game screen frames/indicators RLE encoded sequence
LACD5:	LD A,(DE)
	PUSH DE
	LD C,$01
	CP $FF
	JP Z,LAD1D
	CP $17
	JP C,LACE8
	SUB $14
	LD C,A
	POP DE
	INC DE
	LD A,(DE)
	PUSH DE
LACE8:	PUSH HL
	LD H,$00
	LD L,A
	PUSH HL
	POP DE
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL	; * 8
	ADD HL,DE	; * 9
	LD DE,LAE02	; Indicator tiles address
	ADD HL,DE
	POP DE
LACF7:	LD B,$08
	PUSH HL
	PUSH DE
LACFB:	LD A,(HL)
	LD (DE),A
	INC HL
	inc e		; next line
	dec b
	jp nz,LACFB
	LD A,(HL)
	POP DE
	inc d
	ld a,d
	cp (high SCRTOP)+32
	jp nz,.l10
	ld d,high SCRTOP ; line start
	ld a,e
	add $8		; +8 lines down
	ld e,a
.l10:	POP HL
	DEC C
	JP NZ,LACF7
	EX DE,HL
	POP DE
	INC DE
	JP LACD5
LAD1D:
	POP DE
	LD HL,LAD4A	; Indicator messages address
	CALL PRSTRS	; Print string "PAY : $ XXXXX"
	DEFW SCRIND+$0700
	DEFB $0D
	CALL PRSTRS	; Print string "99"
	DEFW SCRIND+$1708
	DEFB 2
	CALL PRSTRS	; Print string "HELD"
	DEFW SCRIND+$0118
	DEFB 4
	CALL PRSTRS	; Print string "TIME"
	DEFW SCRIND+$1618
	DEFB 4
	CALL PRSTRS	; Print string "NEAR"
	DEFW SCRIND+$1B18
	DEFB 4
	RET

; Print text block
; DE = screen address
; HL = block start
PRSTRB:
.l50:	ld a,(hl)
	inc hl
	or a
	jp z,.l60	; => next line
	cp $FF
	ret z		; => end of text
	ld c,a		; string length
	push de
	call PRSTR	; Print string
	pop de
.l60:	ld a,e
	add 8		; 8 lines lower
	ld e,a
	jp .l50

; Print string on the screen, two arguments after the CALL statement
; 1st word = screen address, 2nd byte = length
; HL = string address
PRSTRS:
	ex (SP),HL	; HL = return address, (SP) = string address
	ld E,(HL)	; screen address low
	inc HL
	ld D,(HL)	; screen address high
	inc HL
	ld C,(HL)	; get string length
	inc HL
	ex (SP),HL	; store return address, HL = string address
; Print string with standard font
; C  = Length
; HL = string address
; DE = screen address
PRSTR:	LD A,(HL)	; get symbol byte
	PUSH HL
	LD H,$00
	LD L,A
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL	; * 8
	PUSH DE
LAEDA:	ld de,FONT-256	; !!MUT-ARG!! font address
	ADD HL,DE
	POP DE
	PUSH DE
	LD B,$08
LAEE2:	LD A,(HL)
	LD (DE),A
	INC HL
	inc e		; next screen line
	dec b
	jp nz,LAEE2
	POP DE
	POP HL
	inc d		; one column right
	INC HL
	DEC C
	JP NZ,PRSTR
	RET

; Routine at AEF0
;LAEF0:

;LAF7E:

;LAF84:

;LAF9C:
;LAFAA:

;LAFBE:

; Print table of records
;LB005:

; Routine at B040
;LB040:

;------------------------------------------------------------------------------

; Tile buffer
LB13E:	DEFB $FE,$82,$A2,$00,$FE,$FF,$FF,$7E	; Pixel bytes
LB146:	DEFB $32	; Attribute byte
LB147:	DEFB $30	; Background attribute byte

; Draw tile map on the screen
DRALL:	xor a
	ld h,a
	ld l,a
	LD HL,TLSCR1	; Tile screen 1 start address
	LD DE,SCRGME	; screen address where game screen starts
	LD B,17		; 17 rows
; Loop by rows
LB16D:	LD C,30		; 30 columns
; Loop by columns
LB16F:	xor A
	CP (HL)		; Check "need update" flag in Tile screen 1
	jp nz,DRTILE	; non zero => tile rendering
LB2A9:	inc d		; Next address in screen
	inc HL		; Next address in Tile screen 1
	dec C		; Decrease columns counter
	jp nz,LB16F	; Continue loop by columns
; Next tile row
	ld A,E
	add $08		; +8 lines down
	ld E,A
	ld D,high SCRGME ; line start
	dec B		; Decrease rows counter
	jp nz,LB16D	; Continue loop by rows
	RET		; exit DRALL procedure
;
; Tile rendering
DRTILE:	ld (HL),A	; clear the flag
	PUSH HL		; save address in Tile screen 1
	PUSH BC		; save row/column counter
	PUSH DE		; save screen address
;
; Process Tile screen 0 - background tile
; HL = address in Tile screen 1
LB177:	ld de,TLSCR0-TLSCR1
	add hl,de	; now HL = address in Tile screen 0
	ld a,(hl)	; get tile from Tile screen 0
	CP $FF		; $FF - "earth" background?
	jp z,DRTILE_FF	; yes => special case for $FF
LB184:	ex DE,HL	; now DE = address in Tile screen 0
	LD H,$00
	LD L,A
	PUSH HL
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL
	POP BC
	add HL,BC	; * 9
	ld BC,LF700	; Background tiles start address
	add HL,BC	; now HL = tile data address
	LD BC,LB13E	; Tile buffer address
LB199:
    REPT 8		; loop fully unrolled
	LD A,(HL)	; get byte from tile data
	LD (BC),A	; store the byte to tile buffer
	INC HL		; move to next byte in tile data
	INC BC		; move to next byte in tile buffer
    ENDR
	LD A,(HL)	; get byte from tile data
	LD (BC),A	; store the byte to tile buffer
	INC BC		; move to next byte in tile buffer
	LD (BC),A	; save attribute byte once more
;
; Process Tile screen 2 tile - Ninja
; DE = address in Tile screen 0
LB1A3:	ld hl,TLSCR2-TLSCR0
	add hl,de	; now HL = address in Tile screen 2
	ld a,(hl)	; get tile from Tile screen 2
	ld DE,510
	add HL,DE	; now HL = address in Tile screen 3
	ld (LB1FC+1),HL	; save address for Tile screen 3 tile processing
	add HL,DE	; now HL = address in Tile screen 4
	ld (LB230+1),HL	; save address for Tile screen 4 tile processing
	add HL,DE	; now HL = address in Tile screen 5
	ld (LB263+1),HL	; save address for Tile screen 5 tile processing
;
	CP $FF		; $FF - transparent?
	JP Z,LB1F9	; $FF => skip Ninja tile drawing
	LD L,A
	CP $C8
	JP C,LB1D5
	CP $F4
	JP NC,LB1D5
	LD H,$02
	CP $DA
	JP NC,LB1CC
	LD H,$05
	CP $D8
	JP NC,LB1CC
	LD H,$07
	LD A,(LB146)	; get attribute byte from the tile buffer
	AND $38
	CP $20
	JP C,LB1CC
	LD H,$01
LB1CC:	LD A,(LB146)	; get attribute byte from the tile buffer
	AND $F8
	OR H
	LD (LB146),A	; set attribute byte
LB1D5:	LD H,$00
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL	; * 16
	LD DE,LE700	; Ninja tiles base address
	ADD HL,DE	; now HL = tile data address
	LD B,$08	; 8 bytes
	LD DE,LB13E	; Tile buffer address
	ld a,(NJADIR)
	or a
	jp z,DRNJA_LT
; Draw Ninja tile, direction right - no mirror
LB1E4:	LD A,(DE)	; get byte from tile buffer
	LD C,A
	LD A,(HL)	; get byte from tile data (mask)
	AND C		; AND with byte from the buffer - apply the mask
	LD C,A
	inc hl
	LD A,(HL)	; get byte from tile data (pixels)
	OR C		; OR with the byte from buffer - apply pixels
	LD (DE),A
	inc hl
	INC DE
	dec b
	jp nz,LB1E4	; loop for all 8 bytes
	jp LB1F9
; Draw Ninja tile, direction left - mirror tiles
DRNJA_LT:
	LD A,(DE)	; get byte from tile buffer
	LD C,A
	LD A,(HL)	; get byte from tile data (mask)
	ld ($ + 4),a	; Mirror byte if needed
	ld a,(MIRROR)	; fast mirroring
	AND C		; AND with byte from the buffer - apply the mask
	LD C,A
	inc hl
	LD A,(HL)	; get byte from tile data (pixels)
	ld ($ + 4),a	; Mirror byte if needed
	ld a,(MIRROR)	; fast mirroring
	OR C		; OR with the byte from buffer - apply pixels
	LD (DE),A
	inc hl
	INC DE
	dec b
	jp nz,DRNJA_LT	; loop for all 8 bytes
;
LB1F9:	JP LB1FC	; !!MUT-ARG!!

; Process Tile screen 3 tile - Dog
LB1FC:	ld hl,TLSCR3	; !!MUT-ARG!! get address in Tile Screen 3
	ld a,(hl)	; get tile from Tile screen 3
	CP $FF		; $FF - transparent?
	JP Z,LB230	; $FF => skip Dog tile drawing
	LD H,$00
	LD L,A
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL	; * 16
	LD DE,LF0F0	; Dog tiles base address
	ADD HL,DE	; now HL = tile data address
	LD B,$08
	LD DE,LB13E	; Tile buffer address
	ld a,(DOGDIR)
	or a
	jp z,DRDOG_LT
; Draw Dog tile, direction right - no mirror
LB218:	LD A,(DE)	; get byte from tile buffer
	LD C,A
	LD A,(HL)
	AND C
	LD C,A
	inc hl
	LD A,(HL)
	OR C
	LD (DE),A
	inc hl
	INC DE
	dec b
	jp nz,LB218
	jp LB230
; Draw Dog tile, direction left - mirror tiles
DRDOG_LT:
	LD A,(DE)	; get byte from tile buffer
	LD C,A
	LD A,(HL)
	ld  ($ + 4), a	; Mirror byte if needed
	ld  a, (MIRROR)	; fast mirroring
	AND C
	LD C,A
	inc hl
	LD A,(HL)
	ld  ($ + 4), a	; Mirror byte if needed
	ld  a, (MIRROR)	; fast mirroring
	OR C
	inc hl
	LD (DE),A
	INC DE
	dec b
	jp nz,DRDOG_LT
;
; Process Tile screen 4 tile - Guard
LB230:	ld hl,TLSCR4	; !!MUT-ARG!! address in Tile Screen 4
	LD A,(HL)	; get tile from the tilemap
	CP $FF		; $FF - transparent?
	JP Z,LB263	; $FF => skip Guard tile drawing
	LD H,$00
	LD L,A
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL	; * 16
	LD DE,LE700	; tiles base address
	ADD HL,DE	; now HL = tile data address
	LD B,$08
	LD DE,LB13E	; Tile buffer address
	ld a,(GARDDIR)
	or a
	jp z,DRGARD_LT
; Draw Guard tile, direction right - no mirror
LB24B:	LD A,(DE)	; get byte from tile buffer
	LD C,A
	LD A,(HL)	; get byte from tile data (mask)
	AND C		; AND with byte from buffer - masking
	LD C,A
	inc hl
	LD A,(HL)	; get byte from tile data (pixels)
	OR C		; OR with byte from buffer
	LD (DE),A	; save result byte to tile buffer
	inc hl
	INC DE
	dec b
	jp nz,LB24B	; loop for all 8 bytes
	jp LB263
; Draw Guard tile, direction left - mirror tiles
DRGARD_LT:
	LD A,(DE)	; get byte from tile buffer
	LD C,A
	LD A,(HL)	; get byte from tile data (mask)
	ld  ($ + 4), a	; Mirror byte if needed
	ld  a, (MIRROR)	; fast mirroring
	AND C		; AND with byte from buffer - masking
	LD C,A
	inc hl
	LD A,(HL)	; get byte from tile data (pixels)
	ld  ($ + 4), a	; Mirror byte if needed
	ld  a, (MIRROR)	; fast mirroring
	OR C		; OR with byte from buffer
	LD (DE),A	; save result byte to tile buffer
	inc hl
	INC DE
	dec b
	jp nz,DRGARD_LT	; loop for all 8 bytes
;
; Process Tile screen 5 tile - front
LB263:	ld hl,TLSCR5	; !!MUT-ARG!! address in Tile Screen 5
	LD A,(HL)	; get tile from the tilemap
	CP $FF		; $FF - transparent?
	JP Z,LB293	; $FF => skip front tile drawing
	LD H,$00
	LD L,A
	LD A,(LB147)	; get Background tile attribute
	LD (LB146),A	; set it as current tile attribute
	ld d,h
	ld e,l
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL	; * 16
	ADD HL,DE	; * 17
	LD DE,LD600	; Front tiles base address
	ADD HL,DE	; now HL = address of tile data
	LD B,$08
	LD DE,LB13E	; Tile buffer address
LB284:	LD A,(DE)	; get byte from buffer
	AND (HL)	; AND with mask byte
	INC HL		; move to next byte in tile data
	OR (HL)		; OR with pixel byte
	LD (DE),A	; store result back to tile buffer
	INC HL		; move to next byte in tile data
	INC DE		; move to next buffer byte
	dec b
	jp nz,LB284	; loop for all 8 bytes
	LD A,(HL)	; get attribute byte from the tile data
	CP $FF		; $FF?
	JP Z,LB293	; $FF => skip
	LD (DE),A	; set as current attribute

; Draw prepared tile on the screen
LB293:	;ld a,(LB146)	; get attribute byte
;	and $0E		; 0/2/4/6/8/10/12/14 = index in DRTILE_T
;	ld l,a
;	ld h,$00
;	ld de,DRTILE_T	; Table of DRTILE strategies
;	add hl,de	; now HL = address in the table
;	LD A,(HL)	; get address low byte
;	INC HL
;	LD H,(HL)	; get address high byte
;	LD L,A		; now HL = room token procedure address
	POP DE		; restore screen address
	PUSH DE		; store screen address again
;	JP (HL)
	LD HL,LB13E	; Tile buffer address
  REPT 7
	LD A,(hl)	; get byte from the buffer
	LD (de),A	; put byte on the screen
	inc hl
	inc e		; next line
  ENDR
	LD a,(hl)	; get byte from the buffer
	LD (de),a	; put byte on the screen
;
; DRTILE finalization
LB2A6:	POP DE		; restore screen address
	POP BC		; restore row/column counter
	POP HL		; restore address in Tile screen 1
	jp LB2A9	; => loop iteration end

; Draw tile $FF
DRTILE_FF:
	pop hl		; get screen address
	push hl
	ld de,$2000
	ld (hl),d	; inversed $DF
	inc l		; next line
	ld (hl),$04	; inversed $FB
	inc l
	ld (hl),d	; inversed $DF
	inc l
	ld (hl),e	; inversed $FF
	inc l
	ld (hl),$08	; inversed $F7
	inc l
	ld (hl),e	; inversed $FF
	inc l
	ld (hl),d	; inversed $DF
	inc l
	ld (hl),e	; inversed $FF
	jp LB2A6

;------------------------------------------------------------------------------

; Object procedure: flip trigger "D": set/remove wall in room 9739
LB320:	LD HL,L9755
	ld B,$28	; value for XOR, to switch token $0E/$26
	jp LB34B	; XOR and => Change Console color in NEAR
; Object procedure: flip trigger "E": set/remove wall in room 97A6
LB32A:	ld HL,L97CF+1
	ld B,$FF	; value for XOR, to switch tile $00/$FF
	jp LB34B	; XOR and => Change Console color in NEAR
; Object procedure: flip trigger "C": set/remove wall in room 8D5C
LB334:	ld HL,L8DBB
	ld B,$28	; value for XOR, to switch token $0E/$26
	jp LB34B	; XOR and => Change Console color in NEAR
; Object procedure: flip trigger "B": set/remove wall in room 8F20
LB33E:	ld HL,L8F31
	ld B,$26	; value for XOR, to switch token $0E/$28
	jp LB34B	; XOR and => Change Console color in NEAR
; Object procedure: flip trigger "A": set/remove wall in room 7F48
LB348:	ld HL,L7F7A
	ld B,$29	; value for XOR, to switch token $0E/$27
;
LB34B:	ld A,(HL)
	xor B
	ld (HL),A
; Change Console color in NEAR, so we see that console action worked
LB350:	ld HL,SCRIND+$1B00 ; NEAR screen address
	ld c,4		; 4 columns
.l10:	ld b,24		; 24 lines
	push hl
.l20:	ld a,(hl)
	xor $FF
	ld (hl),a
	dec l		; next line
	dec b
	jp nz,.l20
	pop hl
	inc h		; next column
	dec c
	JP NZ,.l10
LB365:	JP LB8D0	; => Update Ninja on tilemap

; Room 97A6 initialization
LB368:	LD A,(L97CF+1)	; get trigger "E" value
	LD (TLSCR0+357),A	; Tile screen 0 + 357
	JP LA18D	; => Finish Room 97A6 initialization

; Play melody ??; HL = melody address
LB371:	;DI
	LD C,$C8
LB374:	LD A,(HL)
	AND $07
	LD B,A
	INC HL
LB379:	LD A,$0B
	ld ($ff03),A
	PUSH BC
	LD A,(HL)
	AND $3F
	LD B,A
LB382:	dec b
	jp nz,LB382
	POP BC
	XOR A
	ld ($ff03),A
	dec b
	jp nz,LB379
	INC HL
	DEC C
	JP NZ,LB374
	RET

;LB3AF:	DEFS $01

; Routine at B3B0
LF913:			; redirect
LB3B0:	;LD HL,LC681
	;LD (L982B+2),HL	; set Room 982B initialization, NO NEED
	;LD HL,LB673+1	; current dog data address, NO NEED
	;LD (L9DD0+1),HL
	LD HL,LC6A5
	LD (L7C9C),HL
	LD HL,LC671
	LD (L947C+2),HL
	LD (L93DF+2),HL
	;NOTE: Mirror table preparation was here
	JP LB5C7

; Initialize a guard
; HL = Guard data address, see A1E1
LB40A:	LD DE,GARDPOS	; address to store guard data
	LD (LB695+1),HL	; Save Guard data address
	ld b,$04
	call LDIR_B
	LD A,(HL)
	LD (GARDST),A	; set Guard state
	INC HL
	LD A,(HL)	; get Guard direction from Guard data
	LD (GARDDIR),A	; set Guard direction
	RET

; Rooms 7C9C/92EF initialization
L791B: ; redirect
LB425:	LD HL,LC66B	; Guard data address
	CALL LB40A	; Initialize a guard
	JP LB724	; => Finish room initialization

; Room 79C6 initialization
LB42E:	LD HL,L71D6	; Dog data address
	CALL L9DCD	; Initialize a dog
	JP LB724	; => Finish room initialization

; Room B513 procedure (initial Room)
LB446:	CALL LB4FA	; Processing in the initial room
	JP LB937	; Standard room procedure

; Room procedure (for 19 rooms with a guard)
L7918: ; redirect
LB44C:	CALL LA434	; Process a guard
	JP LB937	; Standard room procedure

; Room procedure (for 18 rooms with a dog)
LB452:	CALL L9C44	; Process a dog
	JP LB937	; Standard room procedure

; Room procedure (for 5 rooms with a guard and a dog)
LB458:	CALL L9C44	; Process a dog
	CALL LA434	; Process a guard
	JP LB937	; Standard room procedure

; Turret initialization
; HL = turret data address
LB461:	LD E,(HL)	; get Turret offset low byte
	INC HL
	LD D,(HL)	; get Turret offset high byte
	PUSH HL		; save offset
	LD HL,TLSCR1	; Tile screen 1 start address
	ADD HL,DE
	LD (LB4CB+1),HL	; set Turret address on Tile Screen 1
	LD DE,$07F8
	ADD HL,DE
	LD (LB48D+1),HL	; set Turret address on Tile Screen 5
	POP HL		; restore offset
	INC HL
	LD A,(HL)
	LD (LB4D3+1),A
	RET

; Room procedure (for 2 rooms with a turret and a dog)
LB47A:	CALL L9C44	; Process a dog
	;CALL LB489	; Process turret
	;JP LB937	; Standard room procedure
; Room procedure (for 14 rooms with a turret)
LB483:	CALL LB489	; Process turret
	JP LB937	; Standard room procedure

; Process turret
LB489:	LD A,(LB4DD)	; get Turret counter
	DEC A		; decrease counter
LB48D:	LD HL,TLSCR5+47	; !!MUT-ARG!! Turret address on Tile Screen 5
	JP NZ,LB4C6
	LD A,(HL)
	PUSH HL
	LD DE,-TLSCR5
	ADD HL,DE
	SUB $26
	ld (LA3AD+3),a
	ld (LA3AD+4),a
	LD (LA3AE),HL
	ld a,$DA
	LD (LA3AD),a
	LD DE,$FFE2	; -30
	LD B,$00
LB4B0:	XOR A
	CP H
	JP Z,LB4B8
LB4B4:	ADD HL,DE
	INC B
	JP LB4B0
LB4B8:	LD A,$1E	; 30
	CP L
	JP C,LB4B4
	ld a,l
	LD (LA3AD+6),a	; Turret X
	ld a,b
	LD (LA3AD+5),a	; Turret Y
LB4C3:	LD A,$32	; !!MUT-ARG!! ??
	POP HL
LB4C6:	LD (LB4DD),A	; update Turret counter
	LD A,$01
LB4CB:	LD (TLSCR1+47),A	; !!MUT-ARG!! set "need update" mark for Turret on Tile Screen 1
	LD (HL),$2D
	LD A,(NJAX)	; get Ninja X
LB4D3:	LD B,$0F	; !!MUT-ARG!! Turret counter value
	CP B
	RET Z
	DEC (HL)
	CP B
	RET M
	INC (HL)
	INC (HL)
	RET

; Increase PAY value, the value is byte after the CALL statement
INCPAYS:
	ex (SP),HL	; get return address
	ld B,(HL)
	inc HL
	ex (SP),HL	; store return address back to stack
; Increase PAY value by B * 100
INCPAY:	LD HL,LAD52+2	; PAY value 3rd digit address
	LD A,$3A	; ':' = '9' + 1
LB4E3:	INC (HL)
	CP (HL)
	JP NZ,LB4ED
	LD (HL),$30	; '0'
	DEC HL		; previous digit
	JP LB4E3
LB4ED:	dec b
	jp nz,INCPAY
	LD HL,LAD52	; Pay value text address
	LD C,5		; five digits
	LD DE,SCRIND+$0F00 ; Screen address
	JP PRSTR	; => Print string, and RET

; Processing in initial room / room with pier - moving waves
LB4FA:	LD B,$06
	LD HL,LD600+187
LB4FF:	LD A,(HL)
	rra
	ld a,(hl)
	rra
	ld (hl),a
	INC HL
	dec b
	jp nz,LB4FF
	LD HL,TLSCR1+360
	LD B,30
	LD A,$01	; "need update" mark
LB50E:	LD (HL),A
	INC HL
	dec b
	jp nz,LB50E
	RET

; Movement handler for initial room (B8CE handler)
LB532:	LD HL,(NJAPOS)
	INC HL		; increase Ninja position in tilemap
	LD (NJAPOS),HL
	LD HL,NJAX	; Ninja X address
	INC (HL)
LB53D:	LD DE,TLSCR5+349
	LD HL,LB5A7	; Boat sprite address
	ld b,$09
	call LDIR_B	; copy Boat sprite
	LD HL,$F807	; -2041
	ADD HL,DE
	LD (HL),$01
	LD DE,$FFF8	; -8
	ADD HL,DE
	LD (HL),$01
	LD HL,(LB53D+1)
	INC HL
	LD (LB53D+1),HL
	LD A,(LB5A8)
	XOR $01
	LD (LB5A8),A
	LD B,5
	ld A,$0B
	ld ($ff03),A	; sound on
LB56B:	dec b
	jp nz,LB56B	; delay
	xor 1
	ld ($ff03),A	; sound off
	LD HL,MVTCN	; counter address
	DEC (HL)	; decrease counter
	JP NZ,LB8D0	; => Update Ninja on tilemap
	LD HL,NJAX	; Ninja X address
	INC (HL)	; Moving right one tile
	LD HL,(NJAPOS)
	INC HL		; increase Ninja position in tilemap
	LD (NJAPOS),HL
	LD HL,TLSCR5+349
	LD (HL),$FF
	LD DE,LD5AC	; Sprite Ninja jumping 3
	LD HL,LC4F6	; Movement handler address
	LD A,$04
	LD (MVTCN),A	; set counter = 4
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Routine at B596
LB596:	LD B,14
LB598:	JP LF9A1

;LB59B:	DEFB $FE,$0E,$2D

; Routine at B59E - Sound ??
LB59E:	DEC C
	JP NZ,LB59E
	XOR A
	;OUT ($FE),A
	dec b
	jp nz,LB598
	RET

; Fill 510*2 bytes of tilemap HL with filler A
FillTilemap2:
	ld b,17*2	; 17 rows * 2
	ld DE,510*2
	add HL,DE	; HL = end of tilemap block
	jp FillTilemap0
; Fill 510 bytes of tilemap HL with $FF
FillTilemapFF:
	ld A,$FF
; Fill 510 bytes of tilemap HL with filler A
FillTilemap1:
	ld b,17		; 17 rows
	ld DE,510
	add HL,DE	; HL = end of tilemap block
; HL = end of block to fill, B = number of rows, A = filler
FillTilemap0:
	ex de,hl	; now DE = end of block
	ld hl,$0000
	add hl,sp	; now HL = current SP
	ld (FillTilemap_fin+1),hl ; save SP to restore at the end
	ex de,hl	; now HL = end of tilemap block
	ld D,A
	ld E,A
	di
	ld SP,HL
.loop:
    REPT 15
	push DE
    ENDR
	dec b
	jp nz,.loop
FillTilemap_fin:
	ld sp,$0000	; !!MUT-ARG!! restore SP
	ei
	ret

; Routine at B5C7
LB5C7:	CALL LAC44	; Reset Guard data and Dog data
	;LD (LBC0D+1),SP	; NO NEED
	LD HL,LB7CA+1
	LD (LE343+2),HL
	;LD HL,LBC3B
	;LD (LDFD1+1),HL	; NO NEED
	LD A,$C5	; command = $C5 PUSH BC
	LD (NRJDEC),A	; set command = PUSH BC = enable Energy decrease
	LD HL,LBEAA
	LD (L9DEC+1),HL
	LD HL,LB8D0	; Object procedure address for "Update Ninja on tilemap"
	LD (LD285),HL	; set Object procedure for object #6 in Table of objects D256
	;LD (LB365+1),HL	; NO NEED
	LD A,$30	; '0'
	LD HL,LAD52	; Pay value text address
	LD B,$03
LB5F5:	LD (HL),A
	INC HL
	dec b
	jp nz,LB5F5
	CALL LACCA	; Draw game screen frames and indicator text
	XOR A
	;LD ($5C48),A	; set BORDCR = 0
	LD (TIMODE),A	; set Time mode = time ticking
	LD (LB850),A	; clear HELD tile
	LD (LD486+8),A	; set tile in Ninja sprite
	ld ($ff03),A	; sound off
	;ld (BorderColor),a
	INC A
	LD (LD486+9),A	; set head tile for Ninja/Guard standing sprite
	LD (NJADIR),A	; set Ninja direction = 1 = right
	LD (LB84F),A	; set NEAR item = 1
	LD HL,TLSCR5+330
	LD (LB53D+1),HL
	;LD HL,LB5B0	; address for Table of items
	;LD (L74D3+1),HL	; NOT NEEDED: the only place we set it
	CALL LB851	; Set initial data in Table of Objects
	LD HL,$0000
	LD (LB673+1),HL	; set current Dog data address = no dog
	LD (LB695+1),HL	; set current Guard data address = no guard
	LD A,$04
	LD (LC66B+4),A
	LD (LD486+15),A
	LD A,$FA
	LD (LB2FD),A
	LD A,$C8
	;LD A,$D2 ;DEBUG Granade
	LD (LBD79+1),A
	CALL L7472
	;DI
	LD HL,LB513	; Initial room address
	LD (ROOM),HL	; set Current Room address
	LD HL,LB532	; movement handler for initial room
	LD (LB8CD+1),HL	; set movement handler address
	LD HL,LD558	; Sprite Ninja sitting
	LD (NJASPR),HL	; set Ninja sprite address
	LD A,$01
	LD (NJAX),A	; set Ninja X = 1
	LD A,$05
	LD (NJAY),A	; set Ninja Y = 5
	LD HL,$0097
	LD (NJAPOS),HL	; set Ninja position in tilemap: Y * 30 + X
	LD A,$13
	LD (MVTCN),A	; set counter = 19
  IF CVERT != 0		; Cheat code for short route to Helicopter
  	DISPLAY "CVERT cheat is ON"
	ld a,$D4	; diskette
	ld (LBD79+1),a	; -> HELD
	ld hl,L8D5C
	ld (L791E+6),hl	; Right from room 791E -> room 9F7E
  ENDIF
  IF CSHORT != 0		; Cheat code for small map
	DISPLAY "CSHORT cheat is ON"
	; L791E: pier room Right -> L8D18 (skip mid-map)
	ld hl,L8D18
	ld (L791E+6),hl
	; L8D18: Left -> nowhere, Right -> L9DF5
	ld hl,0
	ld (L8D18+4),hl
	ld hl,L9DF5
	ld (L8D18+6),hl
	; L9DF5: Left -> L8D18, Right -> LA022
	ld hl,L8D18
	ld (L9DF5+4),hl
	ld hl,LA022
	ld (L9DF5+6),hl
	; LA022: Left -> L9DF5
	ld hl,L9DF5
	ld (LA022+4),hl
  ENDIF

; Current Room changed, entering the new Room
LB66A:	LD A,(L71D4)
LB66D:	LD ($0000),A	; !!MUT-ARG!! address for current Dog flag
	LD HL,DOGPOS
LB673:	LD DE,$0000	; !!MUT-ARG!! current Dog data address
	ld a,e
	or d		; DE = $0000 ?
	jp z,LB67B	; yes => don't copy current Dog's data
	ld b,$09
	call LDIR_B
LB67B:	LD HL,LB263	; For first drawing entering the room, skip Dog and Guard tiles drawing
	LD (LB1F9+1),HL
	CALL LDE68	; Find record for the current room in DE84 table
	or a
	JP NZ,LB68B	; found =>
	LD HL,$0000
LB68B:	LD A,(HL)	; get flag
	LD (L71D4),A
	LD (LB66D+1),HL
	LD HL,GARDPOS
LB695:	LD DE,$0000	; !!MUT-ARG!! current Guard data address
	ld a,e
	or d		; DE = $0000 ?
	jp z,LB6A6	; yes => don't copy current Guard's data
	ld b,$04
	call LDIR_B
	LD A,(GARDST)	; get Guard state
	LD (DE),A
	INC DE
	LD A,(GARDDIR)	; get Guard direction
	LD (DE),A
LB6A6:	xor a
	ld l,a
	ld h,a
	LD (LB673+1),HL	; set current Dog data address = $0000 no dog
	LD (LB695+1),HL	; set current Guard data address = $0000 no guard
	LD (LBAB2),A
	LD HL,LA39F
	LD B,$03
	LD DE,$0007
LB6BB:	LD (HL),A
	ADD HL,DE
	dec b
	jp nz,LB6BB
; Fill Tile screen 0 with A = $00
	LD HL,TLSCR0	; Tile screen 0 start address
	call FillTilemap1 ; Fill TLSCR0 with $00
	INC A		; A = $01
	LD (GARDCN),A	; set Guard counter = 1
; Fill Tile screen 4 and Tile screen 5 with $FF
	LD HL,TLSCR4	; Tile screen 4 start address
	ld A,$FF	; filler
	call FillTilemap2 ; Fill TLSCR4/TLSCR5 with $FF = transparent tile
; Set Room variables
	LD HL,(ROOM)	; get Current Room address
	ld A,(HL)	; room procedure low
	INC HL
	ld D,(HL)	; room procedure high
	INC HL
	ld E,A
	ex DE,HL
	ld (LB936+1),HL	; store room procedure address
	ex DE,HL
	LD A,(HL)	; get Room init address low byte
	INC HL
	LD D,(HL)	; get Room init address high byte
	LD E,A
	ex DE,HL
	LD (LB6F1+1),HL	; set Room init address
	LD HL,$0009
	ADD HL,DE	; now HL = room sequence start address

LB6EE:	LD A,(HL)	; get next token
	or A		; End of sequence?
LB6F1:	JP Z,LF973	; !!MUT-ARG!! yes => run Room initialization code
	cp $10
	jp c,LB6F4	; => process token #00..#10
	cp $21
	jp c,RTOK1X	; => process token #11..#20
	cp $40
	jp c,RTOK2X	; => process token #21..#30
	cp $80
	jp c,RTOK40	; => process token #40..#7F
	jp RTOK80	; => process token #80..#BF
; Process token #00..#0F
LB6F4:	PUSH HL		; Save address in the room sequence
	LD L,A
	LD H,$00
	ADD HL,HL	; * 2
	LD DE,LB706	; Table of Room tokens
	ADD HL,DE	; now HL = address in the table
	LD A,(HL)	; get address low byte
	INC HL
	LD H,(HL)	; get address high byte
	LD L,A		; now HL = room token procedure address
	JP (HL)		; => run token procedure

; Proceed to the next room token
LB702:	POP HL		; Restore address in the room sequence
	INC HL		; to next token
	JP LB6EE	; => continue room sequence processing

; Table of Room tokens
LB706:	DEFW 0		; #00: End of sequence
	DEFW RTOKFI	; #01: Fill whole Tile screen 0 with $01; no params
	DEFW RTOKFI	; #02: Fill whole Tile screen 0 with $02; no params
	DEFW RTOK03	; #03: Fill rectangle; params: 5 bytes (filler, width, height, address)
	DEFW RTOK04	; #04: Fill to right; params: 4 bytes (count, filler, address)
	DEFW RTOK05	; #05: Fill whole Tile screen 0 with $FF; no params
	DEFW RTOK06	; #06: Fill triangle from wide top; params: 4 bytes (filler, count, address)
	DEFW RTOK07	; #07: Fill triangle from wide bottom; params: 4 bytes (filler, count, address)
	DEFW RTOK08	; #08: Fill triangle from wide bottom; params: 4 bytes (filler, count, address)
	DEFW RTOK09	; #09: Fill triangle from wide top; params: 4 bytes (filler, count, address)
	DEFW RTOK0A	; #0A: Fill rectangle with $FF; params: 4 bytes (width, height, address)
	DEFW RTOK0B	; #0B: Put one tile $2A at the given address; params: 2 bytes (address)
	DEFW RTOK0C	; #0C: Fill to right with $FF; params: 3 bytes (count, address)
	DEFW RTOKFI	; #0D: Fill whole Tile screen 0 with $0D; no params
	DEFW RTOK0E	; #0E: Put one tile at the given address; params: 3 bytes (tile, address)
	DEFW 0		; #0F: UNUSED
; Tokens #10..#20: Copy block of tiles using table TBLOK2, see RTOK1X
	;DEFW RTOK1X	; #10: Put 3x3 barrel block $7C21; params: 2 bytes (address)
; Tokens #21..#30: Fill to down N tiles; params: 3 bytes (filler, address); count/height in token lower bits
; Tokens #40..#7F: Copy block of tiles; params: 4 bytes (width, height, address); source = lower bits of token
; Tokens #80..#B0: Copy block of tiles N times; params: 4 bytes (width, count, address); source = lower bits of token

; Room token #10..#20: Copy block of tiles using table TBLOK2
; A = token, HL = token sequence address
RTOK1X:	inc HL		; skip token byte
	push HL		; save token sequence address
	sub $10		; 0..16
	add A,A
	add A,A		; * 4
	ld E,A
	ld D,0
	ld HL,TBLOK2	; table address
	add HL,DE
	ld E,(HL)	; get source address low
	inc HL
	ld D,(HL)	; get source address high
	inc HL
	ld B,(HL)	; get width
	inc HL
	ld C,(HL)	; get height
	pop HL		; HL = token sequence address
	ld A,(HL)	; get address low
	inc HL
	push HL		; save token sequence address
	ld H,(HL)	; get address high
	ld L,A
	jp L7415	; => Copy block of tiles

; Tokens #40..#7F: Copy block of tiles; params: 4 bytes (width, height, address); source = lower bits of token
; HL = token sequence address; A = token
RTOK40:	inc HL		; skip token byte
	and $3F		; 0..63 = source index
	add a,a		; * 2
	push HL		; save token sequence address
	ld E,A
	ld D,0
	ld HL,TBLOCK	; table address
	add HL,DE
	ld E,(HL)	; get source address low
	inc HL
	ld D,(HL)	; get source address high
	pop HL		; HL = token sequence address
	ld B,(HL)	; get width byte
	inc HL
	ld C,(HL)	; get height byte
	inc HL
	jp L7410	; => get address, and Copy block of tiles

; Tokens #80..#BF: Copy block of tiles N times; params: 4 bytes (width, count, address); source = lower bits of token
; HL = token sequence address; A = token
RTOK80:	inc HL
	and $3F		; 0..63 = source index
	add a,a		; * 2
	push HL		; save token sequence address
	ld E,A
	ld D,0
	ld HL,TBLOCK	; table address
	add HL,DE
	ld E,(HL)	; get source address low
	inc HL
	ld D,(HL)	; get source address high
	pop HL		; HL = token sequence address
	ld B,(HL)	; get width byte
	inc HL
	ld C,(HL)	; get count/height
	inc HL
	LD A,(HL)	; get address low byte
	INC HL
	PUSH HL
	LD H,(HL)	; get address high byte
	LD L,A		; HL = target address
; Copy block of tiles N times
.looph:	push DE
	push HL
	push BC
.loopw:	ld A,(DE)
	ld (HL),A
	inc DE
	inc HL
	dec B
	jp nz,.loopw	; loop by width
	pop BC
	pop HL
	ld DE,30
	add HL,DE	; next row
	pop DE
	dec C
	jp nz,.looph	; loop by height
	jp LB702	; => Proceed to the next room token

; Finish room initialization
; Called to finish room initialization from room initialization procedure
LA0E5:			; redirect - Standard room initialization
LB422:			; redirect - Standard room initialization (for 60 rooms)
LB724:
	LD HL,TLSCR1	; Tile screen 1 start address
	ld A,$01	; Filler = $01 = "need update" mark
	call FillTilemap1 ; Fill TLSCR1 with $01
	LD HL,TLSCR2	; Tile screen 2 start address
	ld A,$FF	; filler
	call FillTilemap2 ; Fill TLSCR2/TLSCR3 with $FF = transparent tile
;
	CALL DRALL	; Draw tile map on the screen
;
	LD HL,LD34D	; Table of objects address
	LD B,29		; 29 objects
LB753:	PUSH HL		; save address in Table of objects
	LD A,(ROOM)	; get Current Room address, low byte
	CP (HL)
	JP NZ,LB768
	INC HL
	LD A,(ROOM+1)	; get Current Room address, high byte
	CP (HL)
	JP NZ,LB768
	INC HL
	LD E,(HL)	; get address in Tile screen 0, low byte
	INC HL
	LD D,(HL)	; get address in Tile screen 0, high byte
	INC HL
	LD A,(HL)	; get tile byte
	LD (DE),A	; set tile byte in Tile screen 0
LB768:	POP HL		; restore address in Table of objects
	LD DE,$0005
	ADD HL,DE	; next object
	dec b
	jp nz,LB753	; continue loop by objects
	LD A,(GARDST)	; get Guard state
	CP $09		; Guard dead?
	JP Z,LB77B	; yes => skip
	LD A,$0A
	LD (GARDST),A	; set Guard state = $0A standing

; Game loop start
LB77B:	EI
	;XOR A
	;LD ($5C08),A	; clear LASTK
	;RST $38
	;DI
	;LD A,($5C08)	; get LASTK
	LD A,(TIMODE)	; get Time mode
	CP $01		; time stopped?
	JP Z,LB7AF	; yes =>
; Decrease Time, check if Time is out
LB78B:	LD HL,TIMECN	; address for Time fast counter
	DEC (HL)	; decrease the counter
	JP NZ,LB7AF	; not zero => skip Time decrease
	LD (HL),$28	; reset fast counter to 50
	LD HL,LAD57+1	; address for Time lower digit
	DEC (HL)	; Decrease Time lower digit
	LD A,$2F
	CP (HL)
	JP NZ,LB7A4
	LD (HL),$39	; '9'
	DEC HL		; go to higher digit
	DEC (HL)	; decrease Time higher digit
	CP (HL)
	JP Z,LBE71	; time is out =>
LB7A4:	LD HL,LAD57	; Indicator Time value address
	CALL PRSTRS	; Print string
	DEFW SCRIND+$1708; screen address for timer value
	DEFB 2		; Two digits
; Check for BOMB
LB7AF:	LD A,(LD287+4)	; check Object #7 in Table of objects D256
	CP $D6		; BOMB tile in the place of Diskette?
	JP NZ,LB7ED	; no => skip
; BOMB ticking mode
LB7B6:	LD HL,TIMODE	; Time mode address
	LD A,$02
	CP (HL)		; already in BOMB ticking mode?
	JP Z,LB7ED
	LD (HL),A	; set Time mode = BOMB ticking mode
	LD HL,LBD2F	; "BOMB"
	CALL PRSTRS	; Print string "BOMB"
	DEFW SCRIND+$1618 ; screen address under timer value
	DEFB 4
LB7CA:	LD HL,$3939	; !!MUT-ARG!! "99" bomb timer initial value
	LD (LAD57),HL	; set Indicator Time value
	LD A,$01
	LD (TIMECN),A
; Highlight the time indicator
	ld hl,SCRIND+$1618 ; screen address
	ld c,4
.l10:	ld b,8
	push hl
.l20:	ld a,(hl)
	xor $FF
	ld (hl),a
	dec l		; down line
	dec b
	jp nz,.l20
	pop hl
	inc h		; next column
	dec c
	jp nz,.l10
;
	CALL INCPAYS	; Increase PAY value by 5000
	DEFB 50		; 50 hundred
LB7ED:
;NOTE: No need to clear "need to update" flags - we clear them inside DRALL
;	LD HL,TLSCR1	; Tile screen 1 start address
;	xor a		; "no need to update" value
;	call FillTilemap ; Fill TLSCR1 with $00
	CALL UPNJA	; Set update flags for Ninja, 6x7 tiles
	LD HL,TLSCR2	; Tile screen 2 start address
	call FillTilemapFF ; Fill TLSCR2 with $FF = transparent tile
	XOR A
	LD (LB84C),A	; clear Object tile
	LD C,A
	LD B,$23	; 35 = number of records in D256
	LD DE,LD256	; Table address

; Loop through the table
LB814:	LD A,(DE)	; get byte +$00
	LD L,A
	INC DE
	LD A,(DE)	; get byte +$01
	LD H,A
	INC DE
	PUSH DE		; save address in the table
	ex de,hl
	ld hl,(NJAPOS)
	ADD HL,DE	; add Ninja position in tilemap
	POP DE		; restore address in the table
	LD A,(DE)	; get byte +$02
	INC DE
	CP (HL)
	JP NZ,LB889
	LD A,(DE)	; get byte +$03
	LD C,A
	LD B,$03
	LD HL,LB84C	; address to store Object tile and Object procedure address
	INC DE
	ex de,hl
	ld (LB84A),hl	; store Object address + 4
	ex de,hl
LB833:	LD A,(DE)	; get byte +$04/$05/$06
	LD (HL),A
	INC HL
	INC DE
	dec b
	jp nz,LB833
	JP LB891

; Increase Energy a bit
LB83C:	LD A,(NRJLO)	; get Energy lower
	rrca
	LD (NRJLO),A	; set Energy lower
	RET NC
	LD HL,NRJ	; Energy address
	INC (HL)	; increase Energy
	RET

; Set initial data in Table of Objects
LB851:	LD B,35		; 35 objects
	ld de,LD256+3	; = (address for Table of Objects) + 3
	LD HL,LD210	; address for table with initial data
LB85D:	LD A,(HL)
	ld (de),a	; set byte +$03 in the record
	INC HL
	inc de
	LD A,(HL)
	ld (de),A	; set byte +$04 in the record
	INC HL
	push hl
	ld hl,$0006	; shift to next record (size of record = 7)
	add hl,de	; next record
	ex de,hl
	pop hl
	dec b
	jp nz,LB85D	; continue the loop
	RET

; Routine at B889
LB889:	INC DE
	INC DE
	INC DE
	INC DE
	DEC B
	JP NZ,LB814	; continue the loop through the table
;
LB891:	LD HL,LB84F	; NEAR item address
	LD A,C
	CP (HL)
	JP Z,LB8B0
	LD (HL),A
	ld hl,SCRIND+$1B00 ; NEAR screen address
	CALL DRITEM	; Draw NEAR/HELD item
LB8B0:	LD HL,LB850	; HELD tile address
	LD A,(LBD79+1)
	CP (HL)
	JP Z,LB8C9
	LD (HL),A
	or a		; = 0 ?
	JP Z,LB8C2
	SUB $C6
	rra	; SRL A
LB8C2:	ld hl,SCRIND+$0100 ; HELD screen address
	CALL DRITEM	; Draw NEAR/HELD item
LB8C9:	XOR A
	LD (LA39E),A
LB8CD:	JP LBEB3	; !!MUT-ARG!! => run handler

; Update Ninja on tilemap, clear Dog+Guard screen, execute room procedure
LB8D0:	CALL UPNJA	; Set update flags for Ninja, 6x7 tiles
;
; Draw Ninja on tilemap
LB8E0:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD A,(NJADIR)	; get Ninja direction
	or a		; left?
	JP NZ,LB907
	LD DE,TLSCR2+5
	ADD HL,DE
	ex de,hl
	ld hl,(NJASPR)	; get Ninja sprite address
	ex de,hl
	LD B,$07
LB8F4:	LD C,$06
LB8F6:	LD A,(DE)
	LD (HL),A
	DEC HL
	INC DE
	DEC C
	JP NZ,LB8F6
	PUSH DE
	LD DE,$0024
	ADD HL,DE
	POP DE
	dec b
	jp nz,LB8F4
	JP LB922
LB907:	LD DE,TLSCR2	; Tile screen 2 start address
	ADD HL,DE
	ex de,hl
	ld hl,(NJASPR)	; get Ninja sprite address
	ex de,hl
	LD B,$07
LB911:	LD C,$06
LB913:	LD A,(DE)
	LD (HL),A
	INC HL
	INC DE
	DEC C
	JP NZ,LB913
	PUSH DE
	LD DE,$0018
	ADD HL,DE
	POP DE
	dec b
	jp nz,LB911
; Clear Dog screen + Guard screen
LB922:	LD HL,TLSCR3	; Tile screen 3 start address
	ld A,$FF
	call FillTilemap2 ; Fill TLSCR3/TLSCR4 with $FF = transparent tile
; Execute room procedure
LB936:	JP LB937	; !!MUT-ARG!! room procedure address

; Standard room procedure (for 63 rooms)
LB41F: ;redirect
LB937:
; Slow down updating some tiles if Guard not on the screen
	ld A,(LB695+2)	; get Guard data higher byte
	or A
	jp nz,LB937_2	; have Guard => skip
	ld HL,TLSCR1+15*30 ; mark row 15
	ld B,30
	ld A,1		; "need update" mark
.loop:	ld (HL),A
	inc HL
	dec B
	jp nz,.loop
LB937_2:
; Loop by three objects in LA39F table
	ld hl,LA39F	; Three objects start address
	LD B,3
LB93D:	PUSH BC		; save loop counter
	ld a,(hl)	; have an object here?
	or a
	JP Z,LBA21	; no => skip to end of loop
	push hl		; save object address
	call LB94D	; process this object
	pop hl		; restore object address
LBA21:	POP BC		; restore loop counter
	LD DE,$0007
	add hl,de	; next object record
	DEC B
	JP NZ,LB93D	; continue loop by objects
;
; Decrement Explosion counter first, so the last frame still marks dirty
	ld HL,LBAB2	; Explosion counter address
	ld A,(HL)
	or A
	jp z,LBA2A_skip	; no explosion => skip
	dec (HL)	; decrement counter
; Fill "need update" marks for Explosion
LBA2A:	LD HL,TLSCR1+165	; !!MUT-ARG!!
LBA2D:	LD B,$03	; !!MUT-ARG!! height, rows
LBA2F:	LD C,$03	; !!MUT-ARG!! width, columns
	PUSH HL
LBA32:	LD (HL),$01
	INC HL
	DEC C
	JP NZ,LBA32
	POP HL
	PUSH DE
	LD DE,$001E	; +30
	ADD HL,DE
	POP DE
	dec b
	jp nz,LBA2F
LBA2A_skip:
;
	CALL DRALL	; Draw tile map on the screen
;
	LD HL,LB1FC	; Restore drawing of Dog and Guard tiles
	LD (LB1F9+1),HL
	LD HL,LBAB2	; Explosion counter address
	XOR A
	CP (HL)
	jp z,LB77B	; no Explosion => Game loop start
	call LBA52	; Draw Explosion image and make some noise
	jp LB77B	; => Game loop start

; Process this object
; HL = object address in LA39F table
LB94D:	CALL LBBAE_HL	; set "need update" mark for object
	LD B,$02
	ld (LBA15+1),hl	; store object address
	ld (LBAD8+1),hl	; store object address for LBAD5
	inc hl		; IX+$01
	ld (LB98D+1),hl
	ld (LB994+1),hl
	inc hl
	inc hl		; IX+$03
	ld (LB94F+1),hl
	inc hl
	inc hl		; IX+$05 = object Y address
	ld (LB952+1),hl
	ld (LB99A+1),hl
	inc hl		; IX+$06 = object X address
	ld (LB969+1),hl
	ld (LB9A7+1),hl
LB94F:	LD A,(LA39F+3)	; !!MUT-ARG!!
LB952:	ld hl,LA39F+5	; !!MUT-ARG!! object Y address
	LD DE,$0000	; offset = 0
	CP $03
	JP NC,LB95F
	LD DE,$FFE2	; offset = -30
	dec (hl)	; decrement object Y (IX+$05)
LB95F:	CP $06
	JP C,LB969
	LD DE,$001E	; offset = +30
	inc (hl)	; increment object Y (IX+$05)
LB969:	ld hl,LA39F+6	; !!MUT-ARG!! object X address
	CP $01
	JP Z,LB98D
	CP $04
	JP Z,LB98D
	CP $07
	JP Z,LB98D
	DEC DE
	dec (hl)	; decrement object X (IX+$06)
	CP $03
	JP Z,LB98D
	or a		; = 0 ?
	JP Z,LB98D
	CP $06
	JP Z,LB98D
	INC DE
	INC DE		; offset += 2
	inc (hl)	; increment object X (IX+$06)
	inc (hl)
LB98D:	ld hl,(LA39F+1)	; !!MUT-ARG!! get object position (IX+$01)
	ADD HL,DE
LB994:	ld (LA39F+1),hl	; !!MUT-ARG!! update object position (IX+$01)
LB99A:	LD A,(LA39F+5)	; !!MUT-ARG!! get object Y (IX+$05)
	CP $FF		; Y = -1 ?
	JP Z,LBBA7
	CP $11		; Y = 17 ?
	JP Z,LBBA7
LB9A7:	LD A,(LA39F+6)	; !!MUT-ARG!! get object X (IX+$06)
	CP $1E		; X = 30 ?
	JP Z,LBBA7
	CP $FF		; X = -1 ?
	JP Z,LBBA7
	PUSH HL		; save object position
	LD DE,TLSCR0	; Tile screen 0 start address
	ADD HL,DE
	LD A,$64
	CP (HL)		; compare background tile to $64
	POP HL
	JP C,LBAD5
	PUSH HL
	LD DE,TLSCR3	; Tile screen 3 start address
	ADD HL,DE	; now HL = address in Tile screen 3
	LD A,(HL)	; get tile from Dog screen
	POP HL
	INC A		; = $FF ?
	jp nz,LB9CA	; no => Dog hit by the object
LB9DA:	PUSH HL
	LD DE,TLSCR4	; Tile screen 4 start address
	ADD HL,DE
	LD A,(HL)	; get tile from Guard screen
	POP HL
	INC A		; $FF?
	jp nz,LB9E4	; no => Guard hit by the object
LB9F9:	PUSH HL
	ld hl,(LB94F+1)
	inc hl
	ld (LB94F+1),hl
	POP HL
	DEC B
	JP NZ,LB94F
;
	LD DE,TLSCR2	; Tile screen 2 start address
	ADD HL,DE
	LD A,(HL)	; get tile from Ninja screen
	CP $C8
	jp c,LBA0C	; => Ninja hit by the object
LBA14:	ex de,hl
LBA15:	ld hl,LA39F	; !!MUT-ARG!! restore object address
	ld a,(hl)
	ld (de),a	; put object tile on Tile screen 2
	XOR $01		; flip object tile
	ld (hl),a
	call LBBAE_HL	; set "need update" mark for object
	ret
; Dog hit by the object
LB9CA:	LD A,(DOGST)
	CP $42
	JP NC,LBAD5
	ADD A,$42
	LD (DOGST),A
	JP LBAD5
; Guard hit by the object
LB9E4:	LD A,(GARDST)	; get Guard state
	CP $09		; Guard state = $09 dead ?
	JP Z,LBAD5	; already dead =>
	LD A,$09
	LD (GARDST),A	; set Guard state = $09 dead
	push HL
	CALL INCPAYS	; Increase PAY value by 100 - Guard killed by weapon
	DEFB 1		; 1 hundred
	pop HL
	JP LBAD5	; => delete the object
; Ninja hit by the object
LBA0C:	push HL
	LD B,20		; Ninja hit by the object
	CALL NRJDEC	; Decrease Energy by B = 20
	pop HL
	;JP LBAD5	; => delete the object
;
; This object should be deleted, Granade explode
; HL = object address in LA39F table
LBAD5:	CALL LFA28	; Sound
LBAD8:	ld hl,LA39F	; !!MUT-ARG!! restore object address
	ld (LBBA8+1),hl	; save object address for object deletion
	LD A,(ROOM)	; get current room address low byte
	CP L8DCA AND $FF	; current room address low byte = $CA ?
	JP NZ,LBAE4	; no =>
	LD A,(ROOM+1)
	CP L8DCA SHR 8	; current room address high byte = $8D ?
	JP Z,LBBA7	; room 8DCA (room with helicopter) => delete the object
;
LBAE4:	ld a,(hl)	; get object tile
	and $FE
	CP $D2		; $D2/$D3 ? Granade
	JP NZ,LBBA7	; no => delete the object
; Granade; HL = object address = LA39F
LBAF0:	LD HL,LBAB2	; Explosion counter address
	XOR A
	CP (HL)		; have Explosion already?
	JP NZ,LBBA7	; yes => delete the object
	LD (HL),10	; set Explosion counter
	ld hl,(LA39F+1)	; get object offset
	LD DE,TLSCR1-31	; + Tile screen 1 - 31
	ADD HL,DE
	LD (LBA2A+1),HL	; set Tile screen 1 address
	LD A,(LA39F+5)	; get object Y
	ADD A,A		; * 2
	ld l,a
	ld H,LBAB3 SHR 8	; table of screen addresses for 17 rows
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a		; now HL = screen address of the row beginning
	ld a,(LA39F+6)	; get object X
	add a,h
	ld h,a		; now HL = screen address
	LD (LBA57+1),HL	; set screen address
	LD B,3		; height, rows, initial
	LD C,3		; width, columns, initial
	ld hl,LABE5	; Explosion image address
	ld (LBA5A+1),hl	; set Explosion image address
	LD HL,(LBA2A+1)
	LD DE,$0000	; offset for screen address
	LD A,(LA39F+5)	; get object Y
	CP $10		; bottom row?
	JP NZ,LBB59
	DEC B		; decrease height
LBB59:	or a		; top row?
	JP NZ,LBB6A
	DEC B		; decrease height
	LD DE,$001E	; 30
	ADD HL,DE
	ex de,hl
	ld hl,LABFD
	ld (LBA5A+1),hl	; set Explosion image address
	ex de,hl
	LD DE,$FFF8	; offset for screen address = one row down
LBB6A:	LD A,(LBA5A+6)
	CP $1D		; right limit?
	JP NZ,LBB72
	DEC C		; decrease width
LBB72:	or a		; left limit?
	JP NZ,LBB7C
	DEC C		; decrease width
	INC HL
	inc d		; tune screen address offset, one column right
	push hl
	ld hl,LBA5A+1
	inc (hl)	; inc Explosion image address
	pop hl
LBB7C:	LD A,B
	LD (LBA2D+1),A	; set height
	LD (LBA5D+1),A
	LD A,C
	LD (LBA2F+1),A	; set width
	LD (LBA5F+1),A
	LD (LBA2A+1),HL	; address in Tile screen 1
	LD HL,(LBA57+1)	; get screen address
	ADD HL,DE
	LD (LBA57+1),HL	; set screen address
; Delete the object
LBBA7:	XOR A
LBBA8:	ld (LA39F),a	; !!MUT-ARG!! set object empty
	ret

; Draw Explosion image and make some noise
LBA52:	ld A,$0B
	ld ($ff03),A	; Sound on
LBA57:	LD HL,$C0D0	; !!MUT-ARG!! address on the screen
LBA5A:	LD DE,LABE5	; !!MUT-ARG!! Explosion image address
LBA5D:	LD B,3		; !!MUT-ARG!! height 1..3
LBA5F:	LD C,3		; !!MUT-ARG!! width 1..3
	PUSH HL
	PUSH DE
LBA63:	PUSH HL
	PUSH BC
	LD B,8
LBA67:	LD A,(DE)	; get pixels
	LD (HL),A	; put to screen
	INC DE
	dec l 		; line down
	dec b
	jp nz,LBA67
	POP BC
	POP HL
	inc h		; next column
	DEC C
	JP NZ,LBA63
	POP DE
	LD HL,$0018	; 24
	ADD HL,DE
	EX DE,HL
	POP HL		; restore screen address
	ld a,l
	sub 8		; 8 lines down
	ld l,a
	dec b
	jp nz,LBA5F
;NOTE: Screen attributes change removed
	xor a
	ld ($ff03),A	; Sound off
	ret

LBAB2:	DEFB $00	; ??

; Set "need update" mark for object HL
LBBAE_HL:
	push hl
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld hl,TLSCR1	; Tile screen 1 start address
	add hl,de
	ld (hl),$01	; set "need update" mark
	pop hl
	RET

; Movement handler: Ninja punching
LBBD4:	call ReadInput
	and $10		; BIT 4,A	; check FIRE bit
	JP NZ,LB8D0	; => Update Ninja on tilemap
	JP LC226	; => Ninja standing

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

WaitAnyInput:
	call ReadInput
	and $1F		; mask for 5 bits
	ret nz
	jp WaitAnyInput

WaitNoInput:
	call ReadInput
	and $1F		; mask for 5 bits
	ret z
	jp WaitNoInput

; Clear the whole screen
ClearScreen:
	ld hl,$9000
	ld bc,$3000
	xor a
.l10:	ld (hl),a
	inc hl
	dec c
	jp nz,.l10
	dec b
	jp nz,.l10
	ret

; Entry point
LBC13:	;LD HL,LE5DC	; Melody start address
	;LD (LE440+2),HL	; set melody current address
;
	call ClearScreen
;
	;LD C,$00
LBC28:	;PUSH HL
	;LD B,$04
LBC2B:	;LD (HL),$AA
	;INC H
	;LD (HL),$55
	;INC H
	;DJNZ LBC2B
	;POP HL
	;INC HL
	;DEC C
	;JP NZ,LBC28
; Show the title picture
LBC38:	CALL L6289	; Show title picture (two ninjas)
; Entry point
LBC3B:	;CALL LAEF0
	;LD HL,LAD52
	;LD B,$03
LBC43:	;LD (HL),$30
	;INC HL
	;DJNZ LBC43
	;LD HL,LB0E8	; address of string 10 spaces
	;LD B,$0A
LBC4D:	;LD (HL),$20
	;INC HL
	;DJNZ LBC4D
	JP LDF37

; Movement handler: Ninja standing
LBC55:
; Increase Energy if needed
	LD HL,LB5C5	; Ninja standing counter address
	DEC (HL)	; decrease counter
	JP NZ,LBC76
	LD (HL),$02	; reload the counter
	LD A,(NRJ)	; get Energy
	CP $13		; energy at MAX?
	JP NZ,LBC6B
	LD A,(NRJLO)	; get Energy lower
	CP $01
	JP Z,LBC76
LBC6B:	CALL LB83C	; Increase Energy a bit
	LD B,$01
	CALL NRJDEC	; Decrease Energy by B
	CALL LB83C	; Increase Energy a bit

; Move the head (idle animation)
LBC76:	LD HL,LB2FD	; address for head movement counter
	INC (HL)	; increase counter
	JP NZ,LBC98	; not zero => skip head animation
	LD (HL),$BE	; reset counter (how often head moves)
LBC7E:	LD A,(LD486+8)
	XOR $F4		; toggle tile
	LD (LD486+8),A	; set head tile
	LD A,(LD486+9)
	XOR $F4		; toggle between $01 and $F5 tiles
	LD (LD486+9),A	; set head tile for Ninja/Guard standing sprite
	LD A,(LD486+15)
	XOR $F2		; toggle tile
	LD (LD486+15),A	; update the tile
	JP LBC9D
LBC98:	LD A,$D2
	CP (HL)
	JP Z,LBC7E

; Check for suicide key combination
LBC9D:	ld a,(KeyLineEx)
	and $60		; bits for US + SS
	jp nz,LBCB6	; not pressed => skip suicide
	LD HL,LBEEF	; "SEPUKU" / "MISSION ABORTED"
	LD (LBEB3+1),HL	; set two-line Game Over message
	JP LBE5A	; => Ninja sit, and then fall and DIE
LBCB6:	CALL LC5A3	; Check for falling
	JP Z,LC643	; => Ninja falling
	LD HL,LB595
	XOR A
	CP (HL)
	JP Z,LBCC4
	DEC (HL)
LBCC4:	call ReadInput
	and $10		; BIT 4,A	; check FIRE bit
	JP Z,LBDDD

; FIRE pressed, ninja standing
LBCCC:	LD HL,LB595	; action cooldown counter
	XOR A
	CP (HL)		; check if counter is 0
	JP NZ,LBDB2	; not zero =>
	LD (HL),$05	; reset cooldown (5 ticks until next action)
	LD A,(LB84C)	; get Object tile
	CP $63		; Object tile = $63 Console ?
	JP Z,LBD33	; yes => execute the object procedure
	LD B,A
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+217	; Tile screen 0 + 217
	ADD HL,DE
	LD A,$9C
	CP (HL)
	JP NZ,LBCF3
	LD A,(TIMODE)	; get Time mode
	CP $02		; BOMB ticking mode?
	JP Z,LBD37	; yes =>
	JP LBCF7
LBCF3:	XOR A
	CP B		; Object tile = nothing?
	JP Z,LBD37	; nothing =>
LBCF7:	LD A,(LB850)	; get HELD tile
	ex de,hl
	ld hl,(LB84A)	; get Object address + 4
	ex de,hl
	LD (DE),A	; set Object tile
	DEC DE
	or a		; held nothing?
	JP Z,LBD08	; nothing =>
	SUB $C6
	rra	; SRL A
LBD08:	LD (DE),A
	LD A,$09
	LD (LD287+3),A	; set ?? in Object #7 in Table of objects D256
	LD A,B
	LD (LBD79+1),A
	CP $D4
	JP NZ,LB8D0	; => Update Ninja on tilemap
	LD HL,TIMODE	; Time mode address
	XOR A		; 0 = time ticking
	CP (HL)
	JP NZ,LB8D0	; => Update Ninja on tilemap
	LD (HL),$01	; set Time mode = time stopped
	;LD HL,$0190
	;CALL LB371	; Play melody
	CALL INCPAYS	; Increase PAY value by 5000
	DEFB 50		; 50 hundred
	JP LB8D0	; => Update Ninja on tilemap

; Routine at BD33
LBD33:	LD HL,(LB84D)	; get object procedure address
	JP (HL)		; execute the object procedure

; Fire pressed, Ninja standing, no object nearby
LBD37:	LD HL,LA39F
	XOR A
	CP (HL)
	JP NZ,LBDB2
	LD A,(LB850)	; get HELD tile
	or a		; nothing?
	JP Z,LBDB2
	CP $D4
	JP Z,LBDB2
	CP $D6		; BOMB?
	JP Z,LBDB2
	LD (HL),A
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,$003D	; 61
	ADD HL,DE
	LD A,(NJAX)	; get Ninja X
	INC A
	LD B,A
	LD A,(NJADIR)	; get Ninja direction
	DEC A
	JP NZ,LBD6A
	INC B
	INC B
	INC B
	INC HL
	INC HL
	INC HL
LBD6A:	LD A,B
	LD (LA3A5),A
	LD (LA3A0),HL
	LD A,(NJAY)	; get Ninja Y
	ADD A,$02
	LD (LA3A4),A
LBD79:	LD A,$C8	; !!MUT-ARG!!
	LD (LA39F),A
	XOR A
	LD (LBD79+1),A
	LD B,$03
	LD A,(NJADIR)	; get Ninja direction
	or a		; left?
	JP Z,LBD8D	; left =>
	INC B
	INC B
LBD8D:	LD A,B
	LD (LA3A3),A
	LD A,(INPUTB)	; get Input bits
	and $08		; BIT 3,A	; check UP bit
	JP Z,LBD9B
	DEC B
	DEC B
	DEC B
LBD9B:	LD A,(INPUTB)	; get Input bits
	and $04		; BIT 2,A	; check DOWN bit
	JP Z,LBDA2
	INC B
	INC B
	INC B
LBDA2:	LD A,B
	LD (LA3A2),A
	CALL LF9F9
	LD DE,LD504	; Sprite Ninja/Guard punching
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; ?? Ninja action?
LBDB2:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR4+34	; Tile screen 4 + 34 for right
	LD A,(NJADIR)	; get Ninja direction
	or a
	jp nz,LBDC2	; right =>
	LD DE,TLSCR4+31	; Tile screen 4 + 31 for left
LBDC2:	ADD HL,DE	; now HL = address in Guard tilemap
	LD A,(HL)	; get tile
	INC A		; empty tile?
	JP Z,LBDD4	; empty =>
	LD A,$09
	LD (GARDST),A	; set Guard state = $09 dead
	CALL LB596	; Noise sound
	CALL INCPAYS	; Increase PAY value by 500 - Guard killed by punch/kick
	DEFB 5		; 5 hundreds
LBDD4:	LD HL,LBBD4	; Movement handler: Ninja punching
	LD DE,LD504	; Sprite Ninja/Guard punching
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Routine at BDDD
LBDDD:	LD A,(INPUTB)	; get Input bits
	and $08		; BIT 3,A	; check UP bit
	JP Z,LBFBA
	ld de,TLSCR0+30
	ld hl,(NJAPOS)	; get Ninja position in tilemap
	ex de,hl	; now DE = Ninja position
	ADD HL,DE
	LD A,$DA
	CP (HL)
	JP NZ,LBF7B
	LD A,$0B
	LD (MVTCN),A	; set counter = 11
	LD HL,TLSCR0+44
	LD (LBE0D+1),HL
	LD (LBE1C+1),HL
	LD HL,TLSCR1+302
	LD (LBA2A+1),HL
	LD HL,LBE0D	; Movement handler: opening roof
	LD DE,LD486	; Sprite Ninja/Guard standing
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Movement handler: opening the roof in the helicopter room
LBE0D:	LD HL,TLSCR0	; !!MUT-ARG!!
	LD A,$01
	LD (HL),A
	DEC HL
	LD (LBE0D+1),HL
	LD DE,$01FF	; 511
	ADD HL,DE
	LD (HL),A
LBE1C:	LD HL,TLSCR0+55	; !!MUT-ARG!!
	LD (HL),A
	INC HL
	LD (LBE1C+1),HL
	LD DE,$01FD	; 509
	ADD HL,DE
	LD (HL),A
	LD HL,MVTCN	; counter address
	DEC (HL)	; decrease counter
	JP NZ,LB8D0	; => Update Ninja on tilemap
	LD (HL),34	; set the counter for Helicopter moving up
	LD HL,TLSCR0+458	; = (Tile screen 0) + 15 rows + 8
	LD DE,TLSCR1+458
	LD B,10
LBE3A:	LD (HL),A	; set background tile = $01
	LD (DE),A	; set "need update" flag
	INC DE
	INC HL
	dec b
	jp nz,LBE3A
	LD HL,272
	LD (NJAPOS),HL	; set Ninja position in tilemap
	LD HL,TLSCR1+210
	LD DE,TLSCR1+211
	ld b,209	; 210 - 1 = 7 rows
	call LDIR_B
	LD HL,LC094	; Movement handler: helicopter moving up
	LD DE,LC0E6	; Empty sprite
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Ninja sit, and then fall and DIE
LBE5A:	LD HL,LBE63	; Movement handler: Ninja dead
	LD DE,LD558	; Sprite Ninja sitting
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Movement handler: Ninja dead
LBE63:	LD A,$C9	; command = $C9 RET
	LD (NRJDEC),A	; set command = RET = disable Energy decrease
	LD HL,LBEB3	; Movement handler: Game Over
	LD DE,LA0B5	; Sprite Ninja dead
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Time is out
LBE71:	LD A,(TIMODE)	; get Time mode
	CP $02		; BOMB ticking mode?
	JP Z,LBE80	; yes =>
	LD HL,LBF35	; "TIME OUT" / "MISSION TERMINATED"
	LD (LBEB3+1),HL	; set two-line Game Over message
	JP LBE63	; => Ninja dead

; BOMB time is out, BOMB explodes
LBE80:	LD B,$06
	;LD IX,$0000
LBE86:	LD C,$00
LBE88:	LD HL,$E821 ;TODO
	;LD A,(IX+$00)
	;OUT ($FE),A
	;INC IX
	PUSH BC
	LD C,$11	; 17
LBE95:	LD B,$1E	; 30
LBE97:	INC (HL)
	INC HL
	dec b
	jp nz,LBE97
	INC HL
	INC HL
	DEC C
	JP NZ,LBE95
	POP BC
	DEC C
	JP NZ,LBE88
	dec b
	jp nz,LBE86
	xor a
	ld ($ff03),A	; Sound off
	PUSH HL

; Saboteur is dead
LBEAA:	POP HL
	LD HL,LBF58	; "SABOTEUR DEAD" / "MISSION FAILURE"
	LD (LBEB3+1),HL	; set two-line Game Over message
	JP LBE63	; => Ninja dead

; Movement handler: Game Over
LBEB3:	LD HL,LBEEF	; !!MUT-ARG!! two-line message address
	CALL PRSTRS	; Print string 1st line
	DEFW SCRTOP+$0820 ; screen address
	DEFB $0F
	CALL PRSTRS	; Print string 2nd line
	DEFW SCRTOP+$0630 ; screen address
	DEFB $14
;
	CALL LF9B9	; Pause, then wait for any key pressed
	;NOP
	;NOP
LBEDF:	NOP		; !!MUT-CMD!!
	NOP
	;NOP
	;NOP
	;NOP
;	LD A,$0A	; "LD A,(BC)" instruction code
;	LD (LBEDF),A
	;JP LBC0D	; => Title picture and music, then go to Main menu
	JP LF9E7

; Routine at BF7B
LBF7B:	LD HL,TLSCR0+2	; Tile screen 0 + 2
	ADD HL,DE
	LD A,$64
	CP (HL)
	JP C,LB8D0	; => Object procedure
	INC HL
	CP (HL)
	JP C,LB8D0	; => Update Ninja on tilemap
	LD A,$03
	LD (MVTCN),A	; set counter = 3
	LD A,(NJADIR)	; get Ninja direction
	or a		; left?
	LD A,(INPUTB)	; get Input bits
	JP Z,LBFA0
	rrca		; BIT 0,A	; check RIGHT bit
	call c,LC4E8	; yes =>
	JP LBFA5
LBFA0:	and $02		; BIT 1,A	; check LEFT bit
	CALL NZ,LC4E8	; yes =>
LBFA5:	LD HL,LC339	; Movement handler: Ninja jumping
	LD A,$02
	LD (MVTCN),A	; set counter = 2
	LD DE,LD4B0	; Sprite Ninja/Guard jumping

; Set movement handler = HL, set Ninja sprite = DE
LBFB0:	LD (LB8CD+1),HL
	ex de,hl
	ld (NJASPR),hl	; set Ninja sprite address = DE
	JP LB8D0	; => Update Ninja on tilemap

; Routine at BFBA
LBFBA:	LD A,(INPUTB)	; get Input bits
	and $04		; BIT 2,A	; check DOWN bit
	JP Z,LC13D
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+212
	ADD HL,DE
	CALL LC392
	JP Z,LC12E	; => Ninja on ladder
; Entry point
LBFCC:	LD HL,LC22F	; Movement handler: Ninja sitting
	LD DE,LD558	; Sprite Ninja sitting
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Escaped; clear screen, show final messages, then Game Over
LBFD5:	CALL INCPAYS	; Increase PAY value by 1000 - Escape by Helicopter
	DEFB 10		; 10 hundred
	LD A,(LBD79+1)
	CP $D4
	JP NZ,LC04A
	CALL INCPAYS	; Increase PAY value by 5000
	DEFB 50
;
	call ClearScreen
;
	LD HL,LC062	; Messages address
	CALL PRSTRS	; Print string "DISK RETRIEVED"
	DEFW SCRTOP+$0928 ; Screen address
	DEFB $0E
	CALL PRSTRS	; Print string "DISK BONUS: $05000"
	DEFW SCRTOP+$0858
	DEFB $12
	CALL PRSTRS	; Print string "LEVEL N"
	DEFW SCRTOP+$0568
	DEFB 7
	CALL PRSTRS	; Print string "TOTAL PAY : $"
	DEFW SCRTOP+$0298
	DEFB $0D
	LD HL,LC075	; Messages address
	CALL PRSTRS	; Print string "BONUS: $05000"
	DEFW SCRTOP+$0D68
	DEFB $0D
	LD HL,LE388	; level bonus string
	CALL PRSTRS	; Print string
	DEFW SCRTOP+$1568
	DEFB 3
	LD A,(LE38B)
	LD B,A
	CALL INCPAY	; Increase PAY value by B * 100
	LD A,$14	; "INC D" instruction code
	LD (LBEDF),A
LC04A:	LD A,(TIMODE)	; get Time mode
	CP $02		; BOMB ticking mode?
	JP NZ,LC056	; no =>
	CALL INCPAYS	; Increase PAY value by 10000 - Escape with Disk and Bomb
	DEFB 100	; 100 hundred
LC056:	LD HL,LBF12	; "ESCAPE" / "MISSION SUCCESSFUL"
	LD (LBEB3+1),HL	; set two-line Game Over message
	JP LBEB3	; => Game Over

; Movement handler: helicopter moving up
; Scrolling block of 17x15 tiles, scroll 4 lines up
LC094:	LD HL,MVTCN	; counter address
	DEC (HL)	; decrease counter
	JP Z,LBFD5	; zero => Escaped; final messages, then Game Over
	ld a,$0B
	ld ($ff03),A	; sound on
	ld HL,SCRGME+$0604
	ld DE,SCRGME+$0600
; Scroll 17 columns x 120 lines, 4 lines up
	ld B,15*8
.loop2:
	PUSH HL
	PUSH DE
	ld C,17
.loop:	ld a,(hl)
	ld (de),a
	inc H		; one column right
	inc D		; one column right
	dec C
	jp nz,.loop
	POP DE
	POP HL
	inc E		; one line down
	inc L		; one line down
	dec B
	jp nz,.loop2
	xor A
	ld ($ff03),A	; sound off
	JP LB8D0	; => Update Ninja on tilemap

; Ninja on ladder
LC12E:	LD HL,LC3D9	; Movement handler for Ninja on ladder
	LD (LB8CD+1),HL
	LD HL,LD52E	; Sprite Ninja on ladder
	LD (NJASPR),HL	; set Ninja sprite address
	JP LC498	; => Move down one tile

; Routine at C13D
LC13D:	LD A,(INPUTB)	; get Input bits
	and $02		; BIT 1,A	; check LEFT bit
	JP Z,LC154
	LD HL,NJADIR	; Ninja direction address
	XOR A
	CP (HL)		; left?
	JP Z,LC14B
	DEC (HL)
	JP LB8D0	; => Update Ninja on tilemap
; Entry point
LC14B:	LD HL,LC24B	; Movement handler address
	LD DE,LD3DE	; Sprite Ninja/Guard walking 1
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE
LC154:	LD A,(INPUTB)	; get Input bits
	rrca		; BIT 0,A	; check RIGHT bit
	jp nc,LB8D0	; no => Update Ninja on tilemap
	LD HL,NJADIR	; Ninja direction address
	XOR A
	CP (HL)		; left?
	JP NZ,LC162
	INC (HL)
	JP LB8D0	; => Update Ninja on tilemap
; Entry point
LC162:	LD HL,LC1B6	; Movement handler address
	LD (LB8CD+1),HL
	LD HL,LD3DE	; Sprite Ninja/Guard walking 1
	LD (NJASPR),HL	; set Ninja sprite address
; Entry point
	JP LB8D0	; => Update Ninja on tilemap

; Data block at C171
;LC171:	DEFB $3A,$40,$9C,$FE,$00,$CA,$26,$C2
;	DEFB $3A,$40,$9C,$3D,$32,$40,$9C,$2A
;	DEFB $42,$9C,$11,$E2,$FF,$19,$22,$42
;	DEFB $9C,$CD,$DF,$BB,$CB,$5F,$20,$DD
;	DEFB $C3,$26,$C2,$3A,$40,$9C,$FE,$0A
;	DEFB $CA,$26,$C2,$3A,$40,$9C,$3C,$32
;	DEFB $40,$9C,$2A,$42,$9C,$11,$1E,$00
;	DEFB $19,$22,$42,$9C,$CD,$DF,$BB,$CB
;	DEFB $57,$20,$BA,$18,$70

LC1B6:	LD A,(NJAX)	; get Ninja X
	CP $18		; 24 ?
	JP Z,LC2FA	; => Going to room at Right
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+184
	ADD HL,DE
	LD A,$64
	CP (HL)
	JP NC,LC1DA
	LD HL,NJAY	; Ninja Y address
	DEC (HL)	; one row up
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,$FFE2	; -30
	ADD HL,DE
	LD (NJAPOS),HL	; set Ninja position in tilemap
	JP LC20D
LC1DA:	LD DE,$FFE3	; -29
	ADD HL,DE
	LD A,$64
	CP (HL)
	JP NC,LC1EE
	call ReadInput
	rrca		; BIT 0,A	; check RIGHT bit
	jp nc,LC226	; no => Ninja standing
	JP LB8D0	; => Update Ninja on tilemap
LC1EE:	LD DE,$003B	; +59
	ADD HL,DE
	CP (HL)
	JP C,LC20D
	DEC HL
	CP (HL)
	JP C,LC20D
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,$001E	; +30
	ADD HL,DE
	LD (NJAPOS),HL	; set Ninja position in tilemap
	LD HL,NJAY	; Ninja Y address
	INC (HL)	; one row down
	LD A,(HL)
	CP $0A		; at the room bottom?
	JP Z,LC604	; yes => Going to room Down from current
LC20D:	LD HL,NJAX	; Ninja X address
	INC (HL)
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	INC HL		; move one tile to right
	LD (NJAPOS),HL	; set Ninja position in tilemap
	CALL LC5A3	; Check for falling
	JP Z,LC643	; => Ninja falling
	call ReadInput
	rrca		; BIT 0,A	; check RIGHT bit
	jp c,LC2BB	; yes =>

; Switch Ninja to standing
LBDAF:			; (redirect) Ninja standing
LC5A0:			; (redirect)
LC226:	LD HL,LBC55	; Movement handler: Ninja standing
	LD DE,LD486	; Sprite Ninja/Guard standing
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Movement handler (B8CE handler): Ninja sitting
LC22F:	call ReadInput
	and $04		; BIT 2,A	; check DOWN bit
	JP NZ,LC239	; still pressed =>
	JP LC226	; DOWN key released => stand up
LC239:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR5+182
	ADD HL,DE
	LD A,$0C
	CP (HL)
	LD B,$02
	CALL Z,NRJDEC	; => Decrease Energy by B
	JP LB8D0	; => Object procedure

; Movement handler: Ninja walking
LC24B:	LD A,(NJAX)	; get Ninja X
	or a		; at very left?
	JP Z,LC319	; => Going to room at Left
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+181	; Tile screen 0 + 181
	ADD HL,DE
	LD A,$64
	CP (HL)
	JP NC,LC26F
	LD HL,NJAY	; Ninja Y address
	DEC (HL)	; moving one row up
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,$FFE2	; -30
	ADD HL,DE	; one row up
	LD (NJAPOS),HL	; set Ninja position in tilemap
	JP LC2A2
LC26F:	LD DE,$FFE1	; -31
	ADD HL,DE
	LD A,$64
	CP (HL)
	JP NC,LC283
	call ReadInput
	and $02		; BIT 1,A	; check LEFT bit
	JP Z,LC226	; => Ninja standing
	JP LB8D0	; => Update Ninja on tilemap
LC283:	LD DE,$003D	; +61
	ADD HL,DE
	CP (HL)
	JP C,LC2A2
	INC HL
	CP (HL)
	JP C,LC2A2
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,$001E	; +30
	ADD HL,DE
	LD (NJAPOS),HL	; set Ninja position in tilemap
	LD HL,NJAY	; Ninja Y address
	INC (HL)	; moving one row down
	LD A,(HL)
	CP $0A		; at room bottom?
	JP Z,LC604	; => Going to room Down from current
LC2A2:	LD HL,NJAX	; Ninja X address
	DEC (HL)	; moving one tile left
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	DEC HL		; moving one tile left
	LD (NJAPOS),HL	; set Ninja position in tilemap
	CALL LC5A3	; Check for falling
	JP Z,LC643	; => Ninja falling
	call ReadInput
	and $02		; BIT 1,A	; check LEFT bit
	JP Z,LC226	; => Ninja standing

; LEFT or RIGHT key pressed
LC2BB:	ld a,(INPUTB)
	and $08		; BIT 3,A	; check for UP bit
	LD A,$07
	LD (MVTCN),A	; set counter = 7
	CALL NZ,LC4E8
	LD A,(NJAWLK)
	INC A		; next walking phase
	AND $03		; 0..3
	LD (NJAWLK),A
	ADD A,A		; * 2
	LD L,A
	LD A,$00
	LD (LA39E),A
	JP NZ,LC2E8
	INC A
	LD (LA39E),A
	LD B,49		; should be odd number
	ld A,$0B
LC2E2:	ld ($ff03),A	; sound of steps
	xor 1
	dec b
	jp nz,LC2E2
LC2E8:	LD H,$00
	LD DE,L733B	; Table of four Ninja/Guard walking sprites
	ADD HL,DE
	LD DE,NJASPR	; address for Ninja sprite address
	LD A,(HL)
	LD (DE),A
	INC HL
	INC DE
	LD A,(HL)
	LD (DE),A
	JP LB8D0	; => Object procedure

; Going to room at Right
LC2FA:	XOR A
	LD (NJAX),A	; set Ninja X = 0
	LD DE,$FFE8	; -24
	LD HL,(NJAPOS)
	ADD HL,DE	; update Ninja position in tilemap
	LD (NJAPOS),HL
	LD HL,(ROOM)	; get Current Room address
	LD DE,$0006	; offset in Room description
	ADD HL,DE
	LD A,(HL)	; get Room Right address low byte
	INC HL
	LD H,(HL)	; get Room Right address high byte
	LD L,A
	LD (ROOM),HL	; set Current Room address
	JP LB66A	; => Current Room changed

; Going to room at Left
LC319:	LD A,$18
	LD (NJAX),A	; set Ninja X = 24
	LD DE,$0018	; +24
	LD HL,(NJAPOS)
	ADD HL,DE	; update Ninja position in tilemap
	LD (NJAPOS),HL
	LD HL,(ROOM)	; get Current Room address
	LD DE,$0004	; offset in Room description
	ADD HL,DE
	LD A,(HL)	; get Room Left address low byte
	INC HL
	LD H,(HL)	; get Room Left address high byte
	LD L,A
	LD (ROOM),HL	; set Current Room address
	JP LB66A	; => Current Room changed

; Movement handler (B8CE handler): Ninja jumping
LC339:	LD HL,MVTCN	; counter address
	DEC (HL)	; decrease counter
	JP NZ,LB8D0	; => Update Ninja on tilemap
	LD A,(NJADIR)	; get Ninja direction
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+2	; Tile screen 0 + 2
	ADD HL,DE
	or a		; direction = left ?
	JP NZ,LC361	; no =>
	LD A,(HL)
	CP $0C
	JP Z,LC3BB
	CP $0A
	JP Z,LC3BB
	CP $08
	JP Z,LC3BB
	CP $09
	JP Z,LC3BB
	JP LC368
LC361:	INC HL
	CALL LC392
	JP Z,LC3CF
	DEC HL
LC368:	CALL LC392
	JP Z,LC3C6	; => Ninja on ladder
	LD DE,TLSCR0+60
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD A,(NJADIR)	; get Ninja direction
	or a		; left ?
	JP Z,LC37D
	LD DE,TLSCR0+65
LC37D:	ADD HL,DE
	LD A,$64
	CP (HL)
	JP C,LC4D0
	LD HL,LC4A7	; Movement handler
	LD DE,LD4DA	; Sprite Ninja/Guard jump-kick
	LD A,$03
	LD (MVTCN),A	; set counter = 3
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Check if tile is a ladder
LC392:	LD A,(HL)
	LD B,$01
	CP $05
	JP Z,LC3B7
	CP $06
	JP Z,LC3B7
	CP $07
	JP Z,LC3B7
	CP $F6
	JP Z,LC3B7
	CP $F1
	JP Z,LC3B7
	CP $EF
	JP Z,LC3B7
	CP $ED
	JP Z,LC3B7
	CP $0C
	JP Z,LC3B7
	LD B,$00
LC3B7:	LD A,$01
	CP B
	RET

; Move LEFT one tile
LC3BB:	LD HL,NJAX	; Ninja X address
	DEC (HL)	; one tile to left
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	DEC HL		; move one tile left
; Entry point
LC3C3:	LD (NJAPOS),HL	; set Ninja position in tilemap
; Ninja on ladder now
LC3C6:	LD HL,LC3D9	; Movement handler for Ninja on ladder
	LD DE,LD52E	; Sprite Ninja on ladder
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Move RIGHT one tile
LC3CF:	LD HL,NJAX	; Ninja X address
	INC (HL)	; one tile to right
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	INC HL		; move one tile right
	JP LC3C3	; => Set Ninja position in tilemap; Ninja on ladder

; Movement handler (B8CE handler): Ninja on ladder
LC3D9:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+183	; Tile screen 0 + 183
	ADD HL,DE
	LD A,$0C
	CP (HL)		; ladder?
	JP Z,LC3EC	; yes => Read and process Input
	DEC HL
	CALL LC392
	JP NZ,LC226	; not ladder => Ninja standing

; Read and process Input
LC3EC:	call ReadInput
	rrca		; BIT 0,A	; check RIGHT bit
	jp nc,LC40E	; no =>

; Pressed RIGHT
LC3F3:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+184	; Tile screen 0 + 184
	ADD HL,DE
	LD A,$64
	CP (HL)
	JP C,LC42C
	LD DE,$001E	; +30
	ADD HL,DE
	CP (HL)
	JP NC,LC42C
	LD A,$01
	LD (NJADIR),A	; set Ninja direction = 1 = right
	JP LC162

; Check if LEFT pressed
LC40E:			; A = INPUTB shifted right by 1
	rrca		; BIT 1,A	; check LEFT bit
	jp nc,LC42C

; Pressed LEFT
LC412:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+181	; Tile screen 0 + 181
	ADD HL,DE
	LD A,$64
	CP (HL)
	JP C,LC42C
	LD DE,$001E	; +30
	ADD HL,DE
	CP (HL)
	JP NC,LC42C
	XOR A
	LD (NJADIR),A	; set Ninja direction = 0 = left
	JP LC14B

; Check if UP pressed
LC42C:	LD A,(INPUTB)	; get Input bits
	and $08		; BIT 3,A	; check UP bit
	JP Z,LC477

; Pressed UP
LC433:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+183
	ADD HL,DE
	LD A,$0C
	CP (HL)
	JP Z,LC447
	DEC HL
	CALL LC392
	JP Z,LC447
	JP LB8D0	; => Update Ninja on tilemap
LC447:	LD A,(NJAY)	; get Ninja Y
	or a		; top row?
	JP Z,LC623	; yes => Going to room Up from current
	LD DE,$FF2E	; -210 = 7 rows higher
	ADD HL,DE
	LD A,$EA
	CP (HL)
	JP Z,LB8D0	; => Update Ninja on tilemap
	LD A,$FF
	CP (HL)
	JP Z,LB8D0	; => Update Ninja on tilemap
	LD HL,NJAY	; Ninja Y address
	DEC (HL)	; one row up
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,$FFE2	; -30
; Entry point
LC467:	ADD HL,DE
	LD (NJAPOS),HL	; set Ninja position in tilemap
	LD A,(NJADIR)	; get Ninja direction
	INC A		; invert direction
	AND $01
	LD (NJADIR),A	; set Ninja direction
	JP LB8D0	; => Update Ninja on tilemap

; Check if DOWN pressed
LC477:	ld a,(INPUTB)	; get Input bits
	and $04		; BIT 2,A	; check DOWN bit
	JP Z,LB8D0	; => Update Ninja on tilemap

; Pressed DOWN
LC47B:	LD A,(NJAY)	; get Ninja Y
	CP $0A
	JP Z,LC604	; => Going to room Down from current
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+213
	ADD HL,DE
	LD A,$0C
	CP (HL)
	JP Z,LC498	; => Move down one tile
	DEC HL
	CALL LC392
	JP Z,LC498	; => Move down one tile
	JP LB8D0	; => Update Ninja on tilemap

; Move DOWN one tile
LC498:	LD HL,NJAY	; Ninja Y address
	INC (HL)	; one tile down
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,$001E	; +30
	JP LC467	; => set Ninja position = HL, invert direction, Object procedure

; Routine at C4A4
LC4A4:	LD A,(NJADIR)	;get Ninja direction

; ?? Movement handler
LC4A7:	LD HL,MVTCN	; counter address
	DEC (HL)	; decrease counter
	JP NZ,LB8D0	; => Update Ninja on tilemap
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR4+65	; value for right dir = Tile screen 4 + 65
	LD A,(NJADIR)	; get Ninja direction
	or a
	jp nz,LC4BE	; right =>
	LD DE,TLSCR4+60	; value for left dir = Tile screen 4 + 60
LC4BE:	ADD HL,DE
	LD A,(HL)
	INC A		; = $FF ?
	JP Z,LC4D0
	LD A,$09
	LD (GARDST),A	; set Guard state = $09 dead
	CALL LB596	; Noise sound
	CALL INCPAY	; Increase PAY value by 500 - Guard killed by punch/kick
	DEFB 5		; 5 hundred
; Entry point
LC4D0:	LD HL,LC4DE	; Movement handler address
	LD DE,LD4B0	; Sprite Ninja/Guard jumping
	LD A,$01
	LD (MVTCN),A	; set counter = 1
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; ?? Movement handler
LC4DE:	LD HL,MVTCN	; counter address
	DEC (HL)	; decrease counter
	JP NZ,LB8D0	; => Update Ninja on tilemap
	JP LC226	; => Ninja standing

; Routine at C4E8
LC4E8:	CALL LC57B	; Check for ??
	RET NZ
	POP HL
	LD HL,LC4F6	; Movement handler address
	LD DE,LD5AC	; Sprite Ninja jumping 3
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Movement handler (used in initial room)
LC4F6:	CALL LC57B	; Check for ??
	JP Z,LC504
	LD B,3
	CALL NRJDEC	; Decrease Energy by B
	JP LC226	; => Ninja standing
LC504:	LD HL,LC50D	; Movement handler address
	LD DE,LD5D6	; Sprite Ninja jumping 4
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Movement handler ??
LC50D:	LD A,(NJADIR)	; get Ninja direction
	or a		; left?
	LD HL,NJAX	; Ninja X address
	LD A,(HL)
	JP NZ,LC56C
	or a
	JP Z,LC319	; => Going to room at Left
	DEC (HL)
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	DEC HL
	LD (NJAPOS),HL	; set Ninja position in tilemap
LC525:	CALL LC57B	; Check for ??
	JP NZ,LC533
	LD HL,MVTCN	; counter address
	DEC (HL)	; decrease counter
	JP NZ,LB8D0
	JP LC538
LC533:	LD B,$04
	CALL NRJDEC	; Decrease Energy by B
LC538:	LD DE,TLSCR0+122
	LD B,$03
LC53D:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	ADD HL,DE
	LD A,$64
	CP (HL)
	JP NC,LC558
LC546:	LD HL,NJAY	; Ninja Y address
	DEC (HL)
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	PUSH DE
	LD DE,$FFE2	; -30
	ADD HL,DE
	POP DE
	LD (NJAPOS),HL	; set Ninja position in tilemap
	JP LC53D
LC558:	INC HL
	CP (HL)
	JP C,LC546
	LD HL,$001E	; +30
	ADD HL,DE
	EX DE,HL
	dec b
	jp nz,LC53D
	LD HL,LC5A0	; Movement handler: switch Ninja to standing
	LD DE,LD5AC	; Sprite Ninja jumping 3
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE
LC56C:	CP $18
	JP Z,LC2FA	; => Going to room at Right
	INC (HL)
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	INC HL
	LD (NJAPOS),HL	; set Ninja position in tilemap
	JP LC525

; Routine at C57B
LC57B:	LD A,(NJADIR)	; get Ninja direction
	LD L,A
	ADD A,A
	ADD A,A
	ADD A,L		; * 5
	ld e,a
	ld d,$00
	ld hl,(NJAPOS)	; get Ninja position in tilemap
	ADD HL,DE
	LD DE,TLSCR0	; Tile screen 0 start address
	ADD HL,DE
	LD BC,$0400
	LD DE,$001E	; +30
	LD A,$64
LC596:	CP (HL)
	JP NC,LC59A
	INC C
LC59A:	ADD HL,DE
	dec b
	jp nz,LC596
	XOR A
	CP C		; now Z=0: falling, Z=1: not falling
	RET

; Check for falling
LC5A3:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,$00D3
	ADD HL,DE
	LD DE,TLSCR0	; Tile screen 0 start address
	ADD HL,DE
	LD A,(NJADIR)	; get Ninja direction
	LD D,$00	; left?
	LD E,A
	ADD HL,DE
	LD B,$03
	LD C,$00
	LD A,$64
LC5BB:	CP (HL)
	JP NC,LC5C0
	LD C,$01
LC5C0:	INC HL
	dec b
	jp nz,LC5BB
	XOR A
	CP C
	RET

; Movement handler: Ninja falling down
LC5C6:	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,30	; +30
	ADD HL,DE	; one row lower
	LD (NJAPOS),HL	; set Ninja position in tilemap
	LD HL,NJAFAL	; falling counter address
	INC (HL)	; increase falling counter
	LD HL,NJAY	; Ninja Y address
	INC (HL)	; increase Ninja Y
	LD A,(HL)	; get Ninja Y
	CP $0A		; at room bottom?
	JP Z,LC604	; => Going to room Down from current
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,TLSCR0+212	; + Tile screen 0 + 7 rows + 2
	ADD HL,DE
	LD A,$64
	CP (HL)
	JP C,LC5EE
	INC HL
	CP (HL)
	JP NC,LB8D0	; => Update Ninja on tilemap

; Ninja hit somehting after falling
LC5EE:	LD A,$01
	LD (LA39E),A
	LD HL,NJAFAL	; falling counter address
	LD B,(HL)	; get counter value
	LD (HL),$00	; clear falling counter
	CALL NRJDEC	; Decrease Energy by B
	LD B,7
	CALL LB59E	; Noise sound
	JP LBFCC	; => Ninja sitting now

; Going to room Down from current
LC604:	XOR A
	LD (NJAY),A	; set Ninja Y = 0
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,$FED4	; -300
	ADD HL,DE	; 10 rows higher
	LD (NJAPOS),HL	; set Ninja position in tilemap
	LD HL,(ROOM)	; get Current Room address
	LD DE,$000A	; offset in room description
	ADD HL,DE	; now HL = room address + 10
	LD A,(HL)	; get Room Down address low byte
	INC HL
	LD H,(HL)	; get Room Down address high byte
	LD L,A
	LD (ROOM),HL	; set Current Room address
	JP LB66A	; => Current Room changed

; Going to room Up from current
LC623:	LD A,$0A
	LD (NJAY),A	; set Ninja Y = 10
	LD HL,(NJAPOS)	; get Ninja position in tilemap
	LD DE,$012C	; +300
	ADD HL,DE	; 10 rows lower
	LD (NJAPOS),HL	; set Ninja position in tilemap
	LD HL,(ROOM)	; get Current Room address
	LD DE,$0008	; offset in room description
	ADD HL,DE	; now HL = room address + 8
	LD A,(HL)	; get Room Up address low byte
	INC HL
	LD H,(HL)	; get Room Up address high byte
	LD L,A
	LD (ROOM),HL	; set Current Room address
	JP LB66A	; => Current Room changed

; Ninja falling
LC643:	LD HL,LC5C6	; Movement handler address: Ninja falling
	LD DE,LD582	; Sprite Ninja falling
	JP LBFB0	; Set movement handler = HL, Ninja sprite = DE

; Room 791E (room with pier) initialization
LC64C:	LD HL,LC65A
	LD DE,TLSCR0+220	; = Tile screen 0 + 220
	ld b,$11	; 17
	call LDIR_B	; copy bytes to Background
	JP LB724	; => Finish room initialization

; Room 93DF/947C (room right from Train) initialization
LC671:	LD HL,L947C	; room 947C at left of Train 1
	LD (L7C9C+4),HL	; set "room to left" for room 7C9C
	LD HL,L93DF	; room 93DF at right of Train 1
	LD (L7C9C+6),HL	; set "room to right" for room 7C9C
	LD A,$6C	; tile for "1" sign
	JP LC68F

; Room 982B initialization
LC681:	LD HL,L9A1E	; room 9A1E at left of Train 2
	LD (L7C9C+4),HL	; set "room to left" for room 7C9C
	LD HL,L982B	; room 982B at right of Train 2
	LD (L7C9C+6),HL	; set "room to right" for room 7C9C
	LD A,$75	; tile for "2" sign

; Fill 3x3 block with tile for "1"/"2" sign
LC68F:	LD HL,L7D0D+19
	LD DE,$0003
	LD C,$03
LC697:	LD B,$03
LC699:	LD (HL),A
	INC HL
	INC A
	dec b
	jp nz,LC699
	ADD HL,DE
	DEC C
	JP NZ,LC697
	JP LB724	; => Finish room initialization

; Room 7C9C procedure (tunnel Train)
LC6A5:	LD A,(NJAX)	; get Ninja X
	CP $0C
	JP NZ,LB937	; => Standard room procedure
	LD A,$4B
	LD (MVTCN),A	; set counter = 75
	ex de,hl
	ld hl,(NJAPOS)	; get Ninja position in tilemap
	ex de,hl
	LD A,(NJAX)	; get Ninja X
	INC A
	LD B,A
	INC DE
	LD HL,LC70C	; Movement handler: Train moving right
	LD A,(NJADIR)	; get Ninja direction
	or a		; left?
	JP NZ,LC6CD	; right =>
	LD HL,LC6E2	; Movement handler: Train moving left
	DEC B
	DEC B
	DEC DE
	DEC DE
LC6CD:	LD A,B
	LD (NJAX),A	; set Ninja X
	LD (LB8CD+1),HL	; set Movement handler
	ex de,hl
	ld (NJAPOS),hl	; set Ninja position in tilemap
	ld hl,LD486	; Sprite Ninja/Guard standing
	ld (NJASPR),hl	; set Ninja sprite
	JP LB937	; => Standard room procedure

; Movement handler (B8CE handler): Train moving left
LC6E2:	LD B,$02
LC6E4:	LD DE,TLSCR0+479
	LD HL,TLSCR0+478
	PUSH BC
	ld b,$001D
	LD A,(DE)
	push af
	call LDDR_B
	pop af
	LD (DE),A
	POP BC
	dec b
	jp nz,LC6E4
; Entry point
LC6F5:	LD HL,TLSCR1+450
	LD DE,TLSCR1+451
	LD (HL),$01
	ld b,$1D
	call LDIR_B
	LD HL,MVTCN	; counter address
	DEC (HL)	; decrease counter
	JP Z,LC226	; => Ninja standing
	JP LB8D0	; => Update Ninja on tilemap

; Movement handler (B8CE handler): Train moving right
LC70C:	LD B,$02
LC70E:	LD DE,TLSCR0+450
	LD HL,TLSCR0+451
	PUSH BC
	LD b,$1D
	LD A,(DE)
	push af
	call LDIR_B
	pop af
	LD (DE),A
	POP BC
	dec b
	jp nz,LC70E
	JP LC6F5

;----------------------------------------------------------------------------

; Find record for the current room in DE84 table
LDE68:	LD B,$14	; 20 records
	LD HL,LDE84
LDE6D:	LD A,(ROOM)	; get Current Room address low byte
	CP (HL)
	INC HL
	JP NZ,LDE7E
	LD A,(ROOM+1)	; get Current Room address high byte
	CP (HL)
	INC HL
	JP NZ,LDE7F
	LD A,$01
	RET
LDE7E:	INC HL
LDE7F:	INC HL
	dec b
	jp nz,LDE6D
	XOR A
	RET

; Clear strings on the screen
; Clears 16 strings, 18 characters each; used to clear table of scores, menu etc.
LDEC1:	LD B,18
	LD DE,SCRTOP+$0D18
LDEC6:	PUSH DE
	PUSH BC
	LD C,18
	LD HL,LDEE6	; String 18 spaces
	CALL PRSTR	; Print string
	POP BC
	POP DE
	LD HL,$0008	; +8 lines down
	ADD HL,DE
	EX DE,HL
	dec b
	jp nz,LDEC6
	RET

; Prepare for Menu
LDF37:	;LD A,$01	; blue
	;ld (BorderColor),a
	xor a
	ld ($ff03),A	; sound off
	;LD ($5C09),A	; set REPDEL = 1
	;LD ($5C0A),A	; set REPPER = 1
	;LD A,$08
	;LD ($5C48),A	; set BORDCR = $08
	;CALL LE04D	; Clear key buffer playing melody
	;LD DE,$00D4
LDF4C:	;PUSH DE
	;CALL LE440	; Play next note in melody
	;CALL LDFD4	; Clear LASTK and do RST $38 once
	;POP DE
	;;LD A,($5C08)	; get LASTK
	;or a
	;JP NZ,LDF60	; key pressed => Main menu
	;DEC DE
	;LD A,D
	;OR E
	;JP NZ,LDF4C

; Main menu
LDF60:	ei
	CALL LDEC1	; Clear strings on the screen
	LD HL,TITLE	; Menu messages address
	CALL PRSTRS	; Print title string
	DEFW SCRTOP+$0D10
	DEFB 10
	LD HL,MENUTXT
	ld DE,SCRTOP+$0F20
	call PRSTRB	; Print text block
	;CALL LE04D	; Clear key buffer playing melody
	CALL LDFDB	; Highlight Menu item
	LD DE,$00D4
LDF97:	PUSH DE
	;CALL LE440	; Play next note in melody
	;CALL LDFD4	; Clear LASTK and do RST $38 once
	POP DE
	call WaitNoInput
	ld a,(MenuItem)
	or a
	jp z, MENUL
	dec a
	jp z, MENUS
	jp MENUI
; Menu item "LEVEL"
MENUL:	ld hl,SCRTOP+$0F4A
	ld (LDFDB+1),hl
	call LDFDB	; Highlight Menu item
.l00:	call ReadInput
	rrca		; Right?
	jp nc,.l10
	ld a,(LEVED)
	inc a
	cp $39+1
	jp nc,.l00
	ld (LEVED),a
	jp LDF60
.l10:	rrca		; Left?
	jp nc,.l20
	ld a,(LEVED)
	dec a
	cp $30		; '0'
	jp z,.l00
	ld (LEVED),a
	jp LDF60
.l20:	rrca		; Down?
	jp nc,.l30	; no =>
	call LDFE6	; Unhighlight Menu item
	ld a,1
	ld (MenuItem),a
	call WaitNoInput
	jp MENUS
.l30:	rrca		; Up - do nothing
	rrca
	;TODO: check Fire
	jp .l00
; Menu item "START MISSION"
MENUS:	ld hl,SCRTOP+$0F62
	ld (LDFDB+1),hl
	call LDFDB	; Highlight Menu item
.l00:	call ReadInput
	rrca		; Right - do nothing
	rrca		; Left - do nothing
	rrca		; Down ?
	jp nc,.l10	; no =>
	call LDFE6	; Unhighlight Menu item
	ld a,2
	ld (MenuItem),a
	jp MENUI
.l10:	rrca		; Up ?
	jp nc,.l20	; no =>
	call LDFE6	; Unhighlight Menu item
	xor a
	ld (MenuItem),a
	jp MENUL
.l20:	rrca		; Fire ?
	jp nc,.l00	; =>
	call WaitNoInput
	jp LE2A7	; => Start Mission
; Menu item "INFORMATION"
MENUI:	ld hl,SCRTOP+$0F7B
	ld (LDFDB+1),hl
	call LDFDB	; Highlight Menu item
.l00:	call ReadInput
	rrca		; Right - do nothing
	rrca		; Left - do nothing
	rrca		; Down - do nothing
	rrca		; Up ?
	jp nc,.l10	; no =>
	call LDFE6	; Unhighlight Menu item
	ld a,1
	ld (MenuItem),a
	call WaitNoInput
	jp MENUS
.l10:	rrca		; Fire ?
	jp nc,.l00	; =>
	call LDFE6	; Unhighlight Menu item
; Show Information page
	CALL LDEC1	; Clear strings on the screen
	LD HL,SINFO
	LD DE,SCRTOP+$0F20
	call PRSTRB	; Print text block
	call WaitNoInput
	call WaitAnyInput
	jp LDF60

MenuItem: DEFB 1	; 0 = LEVEL, 1 = START, 2 = INFO

LDFA8:
; Entry point
LDFCC:	;DEC DE
	;LD A,D
	;OR E
	;JP NZ,LDF97
	;jp LDF97	; continue menu loop
;LDFD1:	JP LBC3B

; Clear LASTK and do RST $38 once
LDFD4:	;XOR A
	;LD ($5C08),A	; clear LASTK
	;RST $38
	;NOP
	;RET

; Highlight Menu item
LDFDB:	LD HL,$CD8E
	LD B,$0D
LDFE0:	LD (HL),$55
	inc h
	dec b
	jp nz,LDFE0
	RET

; Unhighlight Menu item
LDFE6:	LD HL,(LDFDB+1)
	LD B,$0D
LDFEB:	LD (HL),$00
	inc h
	dec b
	jp nz,LDFEB
	RET

; Clear key buffer playing melody
LE04D:	;CALL LE440	; Play next note in melody
	;CALL LDFD4	; Clear LASTK and do RST $38 once
	;LD A,($5C08)	; get LASTK
	;CP $00
	;RET Z
	;JP LE04D

; Start Mission
LE2A7:	CALL LDFE6	; Unhighlight Menu item
	CALL LDEC1	; Clear strings on the screen
;NOTE: "ENTER SKILL LEVEL" - moved to Menu
	LD HL,LE204	; "YOUR MISSION" / "WILL BE"
	ld DE,SCRTOP+$0F30
	CALL PRSTRB	; Print text block
	LD A,(LEVED)	; get Skill level
	SUB $31
	LD L,A
	LD H,$00
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL	; * 16
	LD DE,LE217	; Levels data base address
	ADD HL,DE
	CALL PRSTRS	; Print string - level description
	DEFW SCRTOP+$0E48
	DEFB 14
	LD A,(HL)
	INC HL
	LD H,(HL)
	LD L,A
	LD A,(HL)
	LD (LA3BE+1),A	; set Guard counter value
	INC HL
	LD A,(HL)
	LD (L9C56+1),A	; set Dog counter value
	INC HL
	LD A,(HL)
	LD (LB4C3+1),A	; set Turret counter value
	INC HL
	LD E,(HL)
	INC HL
	LD D,(HL)
	ex de,hl
	ld (LAD57),hl	; set Indicator Time value
	ex de,hl
	INC HL
	LD E,(HL)
	INC HL
	LD D,(HL)
LE343:	ex de,hl
	ld (LB7CA+1),hl	; set Time value for BOMB
	ex de,hl
	INC HL
	LD A,(HL)
	LD (L97CF+1),A	; set flag for wall in room 97A6
	INC HL
	LD A,(HL)
	LD (L9755+1),A	; set count for wall in room 9739
	INC HL
	LD A,(HL)
	LD (L7F7A+1),A	; set count for wall in room 7F48
	INC HL
	LD A,(HL)
	LD (L8DBB+1),A	; set count for wall in room 8D5C
	INC HL
	LD A,(HL)
	LD (L8F31+1),A	; set count for wall in room 8F20
	INC HL
	ld b,$04
	LD DE,LE388
	call LDIR_B
	ld b,$04
	LD DE,LD357	; address for BOMB in Table of objects D34D
	call LDIR_B	; Copy last 4 bytes: BOMB placement
	LD DE,$0019
;
; Wait for any key pressed, or time passed
	ld bc,$1800
.l10:	push bc
	call ReadInput
	pop bc
	and $1F		; mask for 5 bits
	jp nz,LE374
	dec c
	jp nz,.l10
	dec b
	jp nz,.l10
;
LE374:
	call ClearScreen
	RET

; Play next note in melody
LE440:	;LD IX,$E51C
	;LD A,(IX+$01)
	;CP $FF
	;JP Z,LE487
	;CP $FE
	;JP Z,LE477
	;CP $FD
	;JP Z,LE46F
	;LD L,(IX+$00)
	;LD H,A
	;LD E,(IX+$02)
	;LD D,(IX+$03)
	;PUSH IX
	;;CALL $03B5	; BEEPER
	;NOP
	;POP IX
	;LD DE,$0004
LE468:	;ADD IX,DE
	;LD (LE440+2),IX
	RET
LE46F:	;LD DE,LE4AE
	;LD HL,LE496
	;JP LE47E
LE477:	;LD HL,LE49A
	;LD E,(HL)
	;INC HL
	;LD D,(HL)
	;INC HL
LE47E:	;ld (LE440+2),hl
	;ex de,hl
	;ld (LE477+1),hl
	;JP LE440
LE487:	;LD BC,$4E20
LE48A:	;DEC BC
	;LD A,B
	;OR C
	;JP NZ,LE48A
	;LD DE,$0002
	;JP LE468

; Table for melodies
;LE494:	DEFW LE4AE
;LE496:	DEFW LE4AE
;	DEFW LE508
;LE49A:	DEFW LE53A
;	DEFW LE508
;	DEFW LE56C
;	DEFW LE4AE
;	DEFW LE4AE
;	DEFW LE508
;	DEFW LE53A
;	DEFW LE508
;	DEFW LE56C
;	DEFW LE5CA

; Melodies
;LE4AE:	DEFB $9A,$08,$19,$00	; Melody
;	DEFB $9A,$08,$19,$00
;	DEFB $9A,$08,$31,$00
;	DEFB $8C,$03,$75,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $8C,$03,$75,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $8C,$03,$75,$00
;	DEFB $3E,$04,$62,$00
;	DEFB $C6,$04,$57,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $9A,$08,$31,$00
;	DEFB $8C,$03,$75,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $8C,$03,$75,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $8C,$03,$75,$00
;	DEFB $3E,$04,$31,$00
;	DEFB $C6,$04,$2C,$00
;	DEFB $B3,$05,$25,$00
;	DEFB $6A,$06,$21,$00
;	DEFB $00,$FE
;LE508:	DEFB $9A,$08,$19,$00	; Melody
;	DEFB $9A,$08,$19,$00
;	DEFB $9A,$08,$31,$00
;	DEFB $CA,$02,$93,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $CA,$02,$93,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $CA,$02,$93,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $CA,$02,$93,$00
;	DEFB $26,$03,$83,$00
;	DEFB $8C,$03,$75,$00
;	DEFB $00,$FE
;LE53A:	DEFB $9A,$08,$19,$00	; Melody
;	DEFB $9A,$08,$19,$00
;	DEFB $9A,$08,$31,$00
;	DEFB $CA,$02,$93,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $CA,$02,$93,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $CA,$02,$93,$00
;	DEFB $26,$03,$41,$00
;	DEFB $8C,$03,$3A,$00
;	DEFB $3E,$04,$31,$00
;	DEFB $C6,$04,$2C,$00
;	DEFB $00,$FE
;LE56C:	DEFB $9A,$08,$19,$00	; Melody
;	DEFB $9A,$08,$19,$00
;	DEFB $9A,$08,$31,$00
;	DEFB $CA,$02,$93,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $CA,$02,$93,$00
;	DEFB $9A,$08,$19,$00
;	DEFB $CA,$02,$93,$00
;	DEFB $54,$02,$57,$00
;	DEFB $79,$02,$52,$00
;	DEFB $CA,$02,$49,$00
;	DEFB $26,$03,$41,$00
;	DEFB $54,$02,$57,$00
;	DEFB $C4,$03,$37,$00
;	DEFB $3E,$04,$31,$00
;	DEFB $C4,$03,$37,$00
;	DEFB $57,$03,$3E,$00
;	DEFB $C4,$03,$37,$00
;	DEFB $3E,$04,$31,$00
;	DEFB $C6,$04,$2C,$00
;	DEFB $B3,$05,$25,$00
;	DEFB $6A,$06,$21,$00
;	DEFB $A6,$07,$1C,$00
;	DEFB $00,$FE
;LE5CA:	DEFB $9A,$08,$31,$00	; Melody
;	DEFB $00,$FF,$00,$FF
;	DEFB $00,$FF,$00,$FF
;	DEFB $00,$FF,$00,$FF
;	DEFB $00,$FF
;LE5DC:	DEFB $00,$FD	; Melody end/restart

;----------------------------------------------------------------------------

; Room 84A8 initialization
LF973:	LD HL,TLSCR0+74	; tile screen address
	LD DE,LF98F	; block address
	LD C,$06	; 6 rows
LF97B:	LD B,$03	; 3 columns
LF97D:	LD A,(DE)
	LD (HL),A
	INC HL
	INC DE
	dec b
	jp nz,LF97D
	PUSH DE
	LD DE,$001B
	ADD HL,DE
	POP DE
	DEC C
	JP NZ,LF97B
	JP LB422

; Noise sound
; B = how long
LF9A1:	ld a,b
	rla
	rla
	rla
	ld b,a
	LD HL,SABOTCOD0_END	; address where to get delay values
	ld A,$0B
LF9AC:	ld ($ff03),A
	xor 1
	LD C,(HL)	; get delay
	INC HL
LF9B3:	DEC C		; delay
	JP NZ,LF9B3
	dec b
	jp nz,LF9AC
	xor a
	ld ($ff03),A	; sound off
	RET

; Pause, then wait for any key pressed
LF9B9:	LD DE,$4000
LF9BC:	DEC DE
	LD B,$05
LF9BF:	dec b
	jp nz,LF9BF
	LD A,D
	OR E
	JP NZ,LF9BC
;
	call WaitNoInput
	jp WaitAnyInput

; Routine at F9E4
;LF9E4:	CALL TLSCR0	; Prepare screen, show anti-piracy message, and wait for any key

; Start point after loading
LF9E7:	ld SP,$9000
	;LD A,$21
	;LD (LAEDA+1),A
	;LD A,$C6
	;LD (LAEDA+2),A
	CALL LBC13
LF9F4:	jp LF913
	;JP LF9F4

; Routine at F9F9
LF9F9:	LD HL,$00B4
	LD B,$01
	CALL LFA11
	LD HL,LBDAF	; Switch Ninja to standing
	RET
;	LD HL,$018F
;	LD B,$10
;	CALL LFA11
;	LD A,(DOGST)
;	RET

; Routine at FA11
LFA11:	LD A,$10
	;OUT ($FE),A
	LD A,B
LFA16:	DEC A
	JP NZ,LFA16
	INC B
	XOR A
	;OUT ($FE),A
	LD A,L
	AND $F8
	;OUT ($FE),A
	DEC HL
	LD A,H
	OR L
	JP NZ,LFA11
	RET

; Routine at FA28
LFA28:	LD B,$01
	jp LF9A1	; Noise sound

; Decrease Energy by B + Sound
LFA31:	CALL NRJDEC	; Decrease Energy by B
	LD B,$01
	jp LF9A1	; Noise sound

;----------------------------------------------------------------------------

; Game frame with indicators + tiles, 157 + 207 = 364 bytes
	INCLUDE "sabot1in.asm"

; Items, 1080 bytes
	INCLUDE "sabot1it.asm"

; Rooms
Sabot1RoomsBegin:
	INCLUDE "sabot1rm.asm"
	INCLUDE "sabot1rb.asm"
Sabot1RoomsEnd:
Sabot1RoomsSize EQU Sabot1RoomsEnd - Sabot1RoomsBegin
	DISPLAY "Rooms size: ", /A, Sabot1RoomsSize

;----------------------------------------------------------------------------

; Front tiles, 124 tiles, 17 bytes each
	INCLUDE "sabot1t1.asm"
Sabot1Tiles1End:	; Gap of $07DD bytes starts here

; Title picture (two ninjas), RLE encoded, 693 bytes
	INCLUDE "sabot1mp.asm"

; Sprites, 729 bytes
	INCLUDE "sabot1sp.asm"
; Font, 472 bytes
	INCLUDE "sabot1ft.asm"

	DEFS 119 ;FILLER

Sabot1Tiles1B:
Sabot1Tiles1Gap EQU Sabot1Tiles1B - Sabot1Tiles1End
	ASSERT Sabot1Tiles1Gap == 2013	; Make sure second part of tiles properly aligned
	INCLUDE "sabot1t1b.asm"
	INCLUDE "sabot1t2.asm"
	DEFS 360
	INCLUDE "sabot1t3.asm"

;----------------------------------------------------------------------------

; Tile screen 0 30x17 tiles, 510 bytes - background
TLSCR0:	DEFS	510
; Tile screen 1 30x17 tiles, 510 bytes - update flags
TLSCR1:	DEFS	510
; Tile screen 2 30x17 tiles, 510 bytes - Ninja screen
TLSCR2:	DEFS	510
; Tile screen 3 30x17 tiles, 510 bytes - Dog screen
TLSCR3:	DEFS	510
; Tile screen 4 30x17 tiles, 510 bytes - Guard screen
TLSCR4:	DEFS	510
; Tile screen 5 30x17 tiles, 510 bytes - front
TLSCR5:	DEFS	510

;----------------------------------------------------------------------------
Sabot1End:
	DISPLAY "Top address: ", /A, Sabot1End
	OUTEND
	END