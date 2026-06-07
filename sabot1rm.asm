
	; Fill whole Tile screen 0 with $01; no params
	MACRO	DEFRT01
		DEFB	$01
	ENDM
	; Fill whole Tile screen 0 with $02; no params
	MACRO	DEFRT02
		DEFB	$02
	ENDM
	MACRO	DEFRT03 tile,wid,hei,addr
		DEFB	$03, tile,wid,hei
		DEFW	addr
	ENDM
	; Fill to right; params: 4 bytes (count, filler, address)
	MACRO	DEFRT04 count,tile,addr
		DEFB	$04, count,tile
		DEFW	addr
	ENDM
	; Fill whole Tile screen 0 with $FF; no params
	MACRO	DEFRT05
		DEFB	$05
	ENDM
	MACRO	DEFRT06 tile,count,addr
		DEFB	$06, tile,count
		DEFW	addr
	ENDM
	MACRO	DEFRT07 tile,count,addr
		DEFB	$07, tile,count
		DEFW	addr
	ENDM
	MACRO	DEFRT08 tile,count,addr
		DEFB	$08, tile,count
		DEFW	addr
	ENDM
	MACRO	DEFRT09 tile,count,addr
		DEFB	$09, tile,count
		DEFW	addr
	ENDM
	MACRO	DEFRT0A wid,hei,addr
		DEFB	$0A, wid,hei
		DEFW	addr
	ENDM
	MACRO	DEFRT0B addr
		DEFB	$0B
		DEFW	addr
	ENDM
	; Fill to right with $FF; params: 3 bytes (count, address)
	MACRO	DEFRT0C count,addr
		DEFB	$0C, count
		DEFW	addr
	ENDM
	; Fill whole Tile screen 0 with $0D; no params
	MACRO	DEFRT0D
		DEFB	$0D
	ENDM
	; Put one tile at the given address; params: 3 bytes (tile, address)
	MACRO	DEFRT0E tile,addr
		DEFB	$0E, tile
		DEFW	addr
	ENDM
	; Token $10..$20: Copy block of tiles using table TBLOK2
	MACRO	DEFRTBK bnum,addr
		DEFB	$10+bnum
		DEFW	addr
	ENDM
	; Vertical line, token $21..$30, count 2..17
	MACRO	DEFRTVT count,tile,addr
		DEFB	$1F+count, tile
		DEFW	addr
	ENDM
	; Tokens #40..#7F: Copy block of tiles; params: 4 bytes (width, height, address)
	; source = lower bits of token
	MACRO	DEFRTBL bnum,wid,hei,addr
		DEFB	$40+bnum, wid,hei
		DEFW	addr
	ENDM
	; Tokens #80..#B0: Copy block of tiles N times; params: 4 bytes (width, count, address)
	; source = lower bits of token 0..49
	MACRO	DEFRTBN bnum,wid,count,addr
		DEFB	$80+bnum, wid,count
		DEFW	addr
	ENDM

; Room 791E (room with pier)
L791E:	DEFW	LB446	; Room procedure
	DEFW	LC64C	; Initialization
	DEFW	0	; Room to Left
	DEFW	L79C6	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0D				; Fill entire screen with $0D
	DEFRT0A 7,10, TLSCR0+233	; Rectangle 7x10 tiles with $FF at 6679
	DEFRT04 23, $F5, TLSCR0+480	; Fill horz 23 tiles with $F5 at 6770
	DEFRT04 23, $0B, TLSCR5+360	; Fill horz 23 tiles with $0B at 70EE
	DEFRT03 $0C, 23,3, TLSCR5+390	; Rectangle 23x3 tiles with $0C at 710C
	DEFRT04 19, $F6, TLSCR0+218	; Fill horz 19 tiles with $F6 at 666A
	DEFRTVT 8, $0C, TLSCR0+249	; Fill vert 8 tiles with $0C at 6689
	DEFRTVT 8, $0C, TLSCR0+254	; Fill vert 8 tiles with $0C at 668E
	DEFRTVT 8, $0C, TLSCR0+259	; Fill vert 8 tiles with $0C at 6693
	DEFRTVT 12, $F2, TLSCR0+91	; Fill vert 12 tiles with $F2 at 65EB
	DEFRTBK	13, TLSCR0+129		; Block 4x3 tiles from 7194 to 6611
	DEFRTBK	13, TLSCR0+133		; Block 4x3 tiles from 7194 to 6615
	DEFRTBK	13, TLSCR0+137		; Block 4x3 tiles from 7194 to 6619
	DEFRTBK	13, TLSCR0+141		; Block 4x3 tiles from 7194 to 661D
	DEFRTBK	13, TLSCR0+145		; Block 4x3 tiles from 7194 to 6621
	DEFRTVT 3, $12, TLSCR0+149	; Fill vert 3 tiles with $12 at 6625
	DEFB	$00	; End of sequence

; Room 79C6 (next to room with pier)
L79C6:	DEFW	LB452	; Room procedure
	DEFW	LB42E	; Initialization
	DEFW	L791E	; Room to Left
	DEFW	L7A17	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0D				; Fill entire screen with $0D
	DEFRT0A 30,10, TLSCR0+210	; Rectangle 30x10 tiles with $FF at 6662
	DEFRT03 $02, 21,6, TLSCR0+309	; Rectangle 21x6 tiles with $02 at 66C5
	DEFRT04 21, $03, TLSCR0+279	; Fill horz 21 tiles with $03 at 66A7
	DEFRTBN	0, 2, 9, TLSCR0+220	; Block 2 tiles from 71B9 to 666C copy 9 times
	DEFRT03 $00, 8,6, TLSCR0+52	; Rectangle 8x6 tiles with $00 at 65C4
	DEFRT0C 10, TLSCR0+20		; Fill horz 10 tiles with $FF at 65A4
	DEFRTBK	2, TLSCR5+114		; Block 2x4 tiles from 71BB to 6FF8
	DEFRT0B TLSCR5+51		; Put tile 2A at 6FB9
	DEFRTVT 5, $2B, TLSCR5+81	; Fill vert 5 tiles with $2B at 6FD7
	DEFRTBK	12, TLSCR5+439		; Block 6x2 tiles from 7188 to 713D
	DEFRT0E $F1, TLSCR0+220	; Put tile F1 at 666C
	DEFRT0E $F0, TLSCR0+221	; Put tile F0 at 666D
	DEFB	$00	; End of sequence

; Room 7A17
L7A17:	DEFW	LB483	; Room procedure
	DEFW	LA142	; Initialization
	DEFW	L79C6	; Room to Left
	DEFW	L7B90	; Room to Right
	DEFW	L8238	; Room to Up
	DEFW	0	; Room to Down
	DEFRT02				; Fill entire screen with $02
	DEFRT08 $FF, 6, TLSCR0+317	; Triangle with FF, count=6 at 66CD
	DEFRT0C 18, TLSCR0+480		; Fill horz 18 tiles with $FF at 6770
	DEFRT0A 12,8, TLSCR0+288	; Rectangle 12x8 tiles with $FF at 66B0
	DEFRT03 $00, 4,6, TLSCR0+30	; Rectangle 4x6 tiles with $00 at 65AE
	DEFRT0C 11, TLSCR0+240		; Fill horz 11 tiles with $FF at 6680
	DEFRT0C 5, TLSCR0+210		; Fill horz 5 tiles with $FF at 6662
	DEFRTVT 5, $2B, TLSCR5+64	; Fill vert 5 tiles with $2B at 6FC6
	DEFRT0B TLSCR5+34		; Put tile 2A at 6FA8
	DEFRT0C 5, TLSCR0+0		; Fill horz 5 tiles with $FF at 6590
	DEFRT0C 12, TLSCR0+10		; Fill horz 12 tiles with $FF at 659A
	DEFRTBN	0, 2, 8, TLSCR0+8	; Block 2 tiles from 71B9 to 6598 copy 8 times
	DEFRTBK	5, TLSCR5+281		; Block 4x7 tiles from 798E to 709F
	DEFRTBK	5, TLSCR5+194		; Block 4x7 tiles from 798E to 7048
	DEFRTBK	5, TLSCR5+165		; Block 4x7 tiles from 798E to 702B
	DEFB	$00	; End of sequence

; Room 7A75
L7A75:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L7BD2	; Room to Up
	DEFW	L7A9E	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT04 18, $03, TLSCR0+127	; Fill horz 18 tiles with $03 at 660F
	DEFRT03 $02, 18,5, TLSCR0+157	; Rectangle 18x5 tiles with $02 at 662D
	DEFRTBN	0, 2, 17, TLSCR0+8	; Block 2 tiles from 71B9 to 6598 copy 17 times
	DEFRT0E $F1, TLSCR0+308	; Put tile F1 at 66C4
	DEFRT0E $F0, TLSCR0+309	; Put tile F0 at 66C5
	DEFB	$00	; End of sequence

; Room 7A9E
L7A9E:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L7ACD	; Room to Right
	DEFW	L7A75	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT04 28, $03, TLSCR0+242	; Fill horz 28 tiles with $03 at 6682
	DEFRT03 $02, 28,6, TLSCR0+272	; Rectangle 28x6 tiles with $02 at 66A0
	DEFRTBN	0, 2, 15, TLSCR0+8	; Block 2 tiles from 71B9 to 6598 copy 15 times
	DEFRTBK	12, TLSCR5+399		; Block 6x2 tiles from 7188 to 7115
	DEFRTBK	12, TLSCR5+410		; Block 6x2 tiles from 7188 to 7120
	DEFB	$00	; End of sequence

; Room 7ACD
L7ACD:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L7A9E	; Room to Left
	DEFW	L7AF8	; Room to Right
	DEFW	L7B56	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 30,6, TLSCR0+240	; Rectangle 30x6 tiles with $02 at 6680
	DEFRT04 26, $03, TLSCR0+214	; Fill horz 26 tiles with $03 at 6666
	DEFRT04 4, $03, TLSCR0+240	; Fill horz 4 tiles with $03 at 6680
	DEFRT04 10, $02, TLSCR0+420	; Fill horz 10 tiles with $02 at 6734
	DEFRTBN	0, 2, 14, TLSCR0+18	; Block 2 tiles from 71B9 to 65A2 copy 14 times
	DEFB	$00	; End of sequence

; Room 7AF8
L7AF8:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L7ACD	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L7C6D	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 28,8, TLSCR0+240	; Rectangle 28x8 tiles with $02 at 6680
	DEFRT04 13, $03, TLSCR0+246	; Fill horz 13 tiles with $03 at 6686
	DEFRTBN	0, 2, 15, TLSCR0+8	; Block 2 tiles from 71B9 to 6598 copy 15 times
	DEFRT04 6, $03, TLSCR0+210	; Fill horz 6 tiles with $03 at 6662
	DEFRT0C 9, TLSCR0+259		; Fill horz 9 tiles with $FF at 6693
	DEFRT04 9, $03, TLSCR0+289	; Fill horz 9 tiles with $03 at 66B1
	DEFRTBK	12, TLSCR5+438		; Block 6x2 tiles from 7188 to 713C
	DEFRT0C 2, TLSCR0+420		; Fill horz 2 tiles with $FF at 6734
	DEFRT0C 14, TLSCR0+450		; Fill horz 14 tiles with $FF at 6752
	DEFRT0E $FE, TLSCR0+499	; Put tile FE at 6783
	DEFRT0E $FE, TLSCR0+506	; Put tile FE at 678A
	DEFRTBL	3, 1,2, TLSCR0+454	; Block 1x2 tiles from 7B4F to 6756
	DEFRTBL	3, 1,2, TLSCR0+462	; Block 1x2 tiles from 7B4F to 675E
	DEFB	$00	; End of sequence

; Room 7B56
L7B56:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L7D5A	; Room to Up
	DEFW	L7ACD	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 8,6, TLSCR0+152	; Rectangle 8x6 tiles with $02 at 6628
	DEFRT03 $02, 10,5, TLSCR0+163	; Rectangle 10x5 tiles with $02 at 6633
	DEFRT04 8, $03, TLSCR0+122	; Fill horz 8 tiles with $03 at 660A
	DEFRT04 10, $03, TLSCR0+133	; Fill horz 10 tiles with $03 at 6615
	DEFRTBN	0, 2, 11, TLSCR0+4	; Block 2 tiles from 71B9 to 6594 copy 11 times
	DEFRTBN	0, 2, 17, TLSCR0+18	; Block 2 tiles from 71B9 to 65A2 copy 17 times
	DEFRTBN	2, 2, 1, TLSCR0+318	; Block 2 tiles from 7984 to 66CE copy 1 times
	DEFB	$00	; End of sequence

; Room 7B90
L7B90:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L7A17	; Room to Left
	DEFW	L7BD2	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT01				; Fill entire screen with $01
	DEFRT03 $02, 5,9, TLSCR0+0	; Rectangle 5x9 tiles with $02 at 6590
	DEFRT0C 6, TLSCR0+2		; Fill horz 6 tiles with $FF at 6592
	DEFRT0B TLSCR5+35		; Put tile 2A at 6FA9
	DEFRTVT 7, $2B, TLSCR5+65	; Fill vert 7 tiles with $2B at 6FC7
	DEFRT0A 15,8, TLSCR0+270	; Rectangle 15x8 tiles with $FF at 669E
	DEFRT0A 15,3, TLSCR0+435	; Rectangle 15x3 tiles with $FF at 6743
	DEFRT07 $FF, 4, TLSCR0+315	; Triangle with FF, count=4 at 66CB
	DEFRTBK	6, TLSCR5+226		; Block 4x7 tiles from 79AA to 7068
	DEFRTBK	6, TLSCR5+164		; Block 4x7 tiles from 79AA to 702A
	DEFB	$00	; End of sequence

; Room 7BD2
L7BD2:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L7B90	; Room to Left
	DEFW	L7D5A	; Room to Right
	DEFW	L8162	; Room to Up
	DEFW	L7A75	; Room to Down
	DEFRT01				; Fill entire screen with $01
	DEFRT0A 20,3, TLSCR0+420	; Rectangle 20x3 tiles with $FF at 6734
	DEFRT0C 10, TLSCR0+500		; Fill horz 10 tiles with $FF at 6784
	DEFRT0E $FF, TLSCR0+470	; Put tile FF at 6766
	DEFRTBK	7, TLSCR5+303		; Block 3x4 tiles from 7C0C to 70B5
	DEFRTBK	8, TLSCR5+414		; Block 3x3 tiles from 7C18 to 7124
	DEFRTBN	6, 2, 14, TLSCR0+14	; Block 2 tiles from 7C2A to 659E copy 14 times
	DEFRTBL	2, 2,3, TLSCR0+428	; Block 2x3 tiles from 7984 to 673C
	DEFB	$00	; End of sequence

; Room 7C2E
L7C2E:	DEFW	LB458	; Room procedure
	DEFW	LA1A6	; Initialization
	DEFW	L7D5A	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L7DA9	; Room to Up
	DEFW	L7C6D	; Room to Down
	DEFRT01				; Fill entire screen with $01
	DEFRT0A 30,4, TLSCR0+390	; Rectangle 30x4 tiles with $FF at 6716
	DEFRT0A 5,6, TLSCR0+0	; Rectangle 5x6 tiles with $FF at 6590
	DEFRT0A 3,13, TLSCR0+27	; Rectangle 3x13 tiles with $FF at 65AB
	DEFRT0B TLSCR5+181		; Put tile 2A at 703B
	DEFRTVT 6, $2B, TLSCR5+211	; Fill vert 6 tiles with $2B at 7059
	DEFRTBN	6, 2, 13, TLSCR0+5	; Block 2 tiles from 7C2A to 6595 copy 13 times
	DEFRTBL	2, 2,4, TLSCR0+398	; Block 2x4 tiles from 7984 to 671E
	DEFRTBL	2, 2,4, TLSCR0+410	; Block 2x4 tiles from 7984 to 672A
	DEFB	$00	; End of sequence

; Room 7C6D
L7C6D:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L7FC4	; Room to Right
	DEFW	L7C2E	; Room to Up
	DEFW	L7AF8	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRTBN	0, 2, 17, TLSCR0+8	; Block 2 tiles from 71B9 to 6598 copy 17 times
	DEFRT03 $02, 14,6, TLSCR0+256	; Rectangle 14x6 tiles with $02 at 6690
	DEFRT04 9, $03, TLSCR0+226	; Fill horz 9 tiles with $03 at 6672
	DEFRT04 5, $03, TLSCR0+265	; Fill horz 5 tiles with $03 at 6699
	DEFRTBN	0, 2, 14, TLSCR0+20	; Block 2 tiles from 71B9 to 65A4 copy 14 times
	DEFB	$00	; End of sequence

; Room 7C9C
L7C9C:	DEFW	LC6A5	; Room procedure
	DEFW	L791B	; Initialization
	DEFW	L947C	; Room to Left
	DEFW	L93DF	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT04 30, $03, TLSCR0+210	; Fill horz 30 tiles with $03 at 6662
	DEFRT03 $02, 30,7, TLSCR0+240	; Rectangle 30x7 tiles with $02 at 6680
	DEFRT03 $22, 4,2, TLSCR0+283	; Rectangle 4x2 tiles with $22 at 66AB
	DEFRT03 $21, 30,2, TLSCR0+390	; Rectangle 30x2 tiles with $21 at 6716
	DEFRTBL	11, 6,7, TLSCR5+252	; Block 6x7 tiles from 7D0D to 7082
	DEFRTBL	10, 5,1, TLSCR0+451	; Block 5x1 tiles from 7D08 to 6753
	DEFRTBL	10, 5,1, TLSCR0+466	; Block 5x1 tiles from 7D08 to 6762
	DEFRTBL	9, 5,7, TLSCR0+247	; Block 5x7 tiles from 7CE5 to 6687
	DEFRTBL	12, 5,7, TLSCR0+258	; Block 5x7 tiles from 7D37 to 6692
	DEFB	$00	; End of sequence

; Room 7D5A
L7D5A:	DEFW	LB483	; Room procedure
	DEFW	LA14A	; Initialization
	DEFW	L7BD2	; Room to Left
	DEFW	L7C2E	; Room to Right
	DEFW	L7F85	; Room to Up (extra room)
	DEFW	L7B56	; Room to Down
	DEFRT01				; Fill entire screen with $01
	DEFRT0A 30,6, TLSCR0+0	; Rectangle 30x6 tiles with $FF at 6590
	DEFRTBN	6, 2, 16, TLSCR0+11	; Block 2 tiles from 7C2A to 659B copy 16 times
;REMOVED DEFRT04 2, $EA, TLSCR0+161	; Fill horz 2 tiles with $EA at 6631
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0A 6,3, TLSCR0+414	; Rectangle 6x3 tiles with $FF at 672E
	DEFRT08 $FF, 2, TLSCR0+443	; Triangle with FF, count=2 at 674B
	DEFRTBN	2, 2, 1, TLSCR0+484	; Block 2 tiles from 7984 to 6774 copy 1 times
	DEFRTBN	2, 2, 1, TLSCR0+498	; Block 2 tiles from 7984 to 6782 copy 1 times
	DEFRT0B TLSCR5+208		; Put tile 2A at 7056
	DEFRTVT 6, $2B, TLSCR5+238	; Fill vert 6 tiles with $2B at 7074
	DEFRTBK	5, TLSCR5+291		; Block 4x7 tiles from 798E to 70A9
	DEFB	$00	; End of sequence

; Room 7DA9
L7DA9:	DEFW	L7918	; Room procedure
	DEFW	LA0E8	; Initialization
	DEFW	0	; Room to Left
	DEFW	L7E8C	; Room to Right
	DEFW	L7E05	; Room to Up
	DEFW	L7C2E	; Room to Down
	DEFRT01				; Fill entire screen with $01
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0C 30, TLSCR0+0		; Fill horz 30 tiles with $FF at 6590
	DEFRT0A 3,3, TLSCR0+30	; Rectangle 3x3 tiles with $FF at 65AE
	DEFRTVT 12, $EB, TLSCR0+121	; Fill vert 12 tiles with $EB at 6609
	DEFRTBK	7, TLSCR5+362		; Block 3x4 tiles from 7C0C to 70F0
	DEFRTBN	7, 2, 1, TLSCR0+485	; Block 2 tiles from 7C2C to 6775 copy 1 times
	DEFRTBN	8, 2, 16, TLSCR0+9	; Block 2 tiles from 7C9A to 6599 copy 16 times
	DEFRTBN	8, 2, 16, TLSCR0+12	; Block 2 tiles from 7C9A to 659C copy 16 times
	DEFRTBN	8, 2, 16, TLSCR0+15	; Block 2 tiles from 7C9A to 659F copy 16 times
	DEFRTBK	8, TLSCR5+412		; Block 3x3 tiles from 7C18 to 7122
	DEFRTBK	7, TLSCR5+379		; Block 3x4 tiles from 7C0C to 7101
	DEFRTBK	7, TLSCR5+384		; Block 3x4 tiles from 7C0C to 7106
	DEFB	$00	; End of sequence

; Room 7E05
L7E05:	DEFW	LB452	; Room procedure
	DEFW	LA35C	; Initialization
	DEFW	0	; Room to Left
	DEFW	L80A7	; Room to Right
	DEFW	L83ED	; Room to Up
	DEFW	L7DA9	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTBN	7, 2, 1, TLSCR0+489	; Block 2 tiles from 7C2C to 6779 copy 1 times
	DEFRTBN	7, 2, 1, TLSCR0+492	; Block 2 tiles from 7C2C to 677C copy 1 times
	DEFRTBN	7, 2, 1, TLSCR0+495	; Block 2 tiles from 7C2C to 677F copy 1 times
	DEFRTBN	1, 2, 16, TLSCR0+9	; Block 2 tiles from 7348 to 6599 copy 16 times
	DEFRTVT 12, $EB, TLSCR0+121	; Fill vert 12 tiles with $EB at 6609
	DEFRTBK	0, TLSCR5+303		; Block 3x3 tiles from 7C21 to 70B5
	DEFRTBK	0, TLSCR5+392		; Block 3x3 tiles from 7C21 to 710E
	DEFRTBK	0, TLSCR5+395		; Block 3x3 tiles from 7C21 to 7111
	DEFRTBK	7, TLSCR5+381		; Block 3x4 tiles from 7C0C to 7103
	DEFRTBK	3, TLSCR5+409		; Block 4x3 tiles from 7E7B to 711F
	DEFRTBK	15, TLSCR5+446		; Block 3x1 tiles from 7E87 to 7144
	DEFRTBK	9, TLSCR5+475		; Block 2x1 tiles from 7E8A to 7161
	DEFRTBK	9, TLSCR5+478		; Block 2x1 tiles from 7E8A to 7164
	DEFRT0C 5, TLSCR0+0		; Fill horz 5 tiles with $FF at 6590
	DEFRT0A 3,3, TLSCR0+30	; Rectangle 3x3 tiles with $FF at 65AE
	DEFB	$00	; End of sequence

; Room 7E8C
L7E8C:	DEFW	L7918	; Room procedure
	DEFW	LA0ED	; Initialization
	DEFW	L7DA9	; Room to Left
	DEFW	L7EF2	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L7F48	; Room to Down
	DEFRT01				; Fill entire screen with $01
	DEFRT0C 30, TLSCR0+0		; Fill horz 30 tiles with $FF at 6590
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTBN	7, 2, 1, TLSCR0+482	; Block 2 tiles from 7C2C to 6772 copy 1 times
	DEFRTBN	7, 2, 1, TLSCR0+500	; Block 2 tiles from 7C2C to 6784 copy 1 times
	DEFRTBK	8, TLSCR5+390		; Block 3x3 tiles from 7C18 to 710C
	DEFRTBK	7, TLSCR5+364		; Block 3x4 tiles from 7C0C to 70F2
	DEFRTBK	3, TLSCR5+395		; Block 4x3 tiles from 7E7B to 7111
	DEFRTBK	3, TLSCR5+399		; Block 4x3 tiles from 7E7B to 7115
	DEFRTBK	3, TLSCR5+312		; Block 4x3 tiles from 7E7B to 70BE
	DEFRTBK	1, TLSCR5+308		; Block 3x3 tiles from 71A0 to 70BA
	DEFRTBK	1, TLSCR5+405		; Block 3x3 tiles from 71A0 to 711B
	DEFRTBK	8, TLSCR5+412		; Block 3x3 tiles from 7C18 to 7122
	DEFRTBK	7, TLSCR5+384		; Block 3x4 tiles from 7C0C to 7106
	DEFB	$00	; End of sequence

; Room 7EF2
L7EF2:	DEFW	LB47A	; Room procedure
	DEFW	LA154	; Initialization
	DEFW	L7E8C	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT01				; Fill entire screen with $01
	DEFRT0C 30, TLSCR0+0		; Fill horz 30 tiles with $FF at 6590
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTVT 15, $EB, TLSCR0+58	; Fill vert 15 tiles with $EB at 65CA
	DEFRTBK	3, TLSCR5+221		; Block 4x3 tiles from 7E7B to 7063
	DEFRTBK	3, TLSCR5+308		; Block 4x3 tiles from 7E7B to 70BA
	DEFRTBK	3, TLSCR5+401		; Block 4x3 tiles from 7E7B to 7117
	DEFRTBK	1, TLSCR5+314		; Block 3x3 tiles from 71A0 to 70C0
	DEFRTBK	1, TLSCR5+392		; Block 3x3 tiles from 71A0 to 710E
	DEFRTBK	1, TLSCR5+396		; Block 3x3 tiles from 71A0 to 7112
	DEFRTBK	1, TLSCR5+406		; Block 3x3 tiles from 71A0 to 711C
	DEFRTBK	1, TLSCR5+413		; Block 3x3 tiles from 71A0 to 7123
	DEFB	$00	; End of sequence

; Room 7F48
L7F48:	DEFW	LB483	; Room procedure
	DEFW	LA14F	; Initialization
	DEFW	0	; Room to Left
	DEFW	L7F9C	; Room to Right
	DEFW	L7E8C	; Room to Up
	DEFW	L7FC4	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $01, 8,12, TLSCR0+34	; Rectangle 8x12 tiles with $01 at 65B2
	DEFRT03 $01, 18,7, TLSCR0+222	; Rectangle 18x7 tiles with $01 at 666E
	DEFRT04 4, $01, TLSCR0+398	; Fill horz 4 tiles with $01 at 671E
	DEFRT07 $01, 5, TLSCR0+72	; Triangle with 01, count=5 at 65D8
	DEFRTBN	8, 2, 13, TLSCR0+2	; Block 2 tiles from 7C9A to 6592 copy 13 times
	DEFRTBN	8, 2, 14, TLSCR0+20	; Block 2 tiles from 7C9A to 65A4 copy 14 times
L7F7A:	DEFRT0E $E4, TLSCR0+206		; Put tile $E4 at 665E
	DEFRTBK	8, TLSCR5+345		; Block 3x3 tiles from 7C18 to 70DF
	DEFRTBL	3, 1,3, TLSCR0+434	; Block 1x3 tiles from 7B4F to 6742
	DEFRTBL	3, 1,3, TLSCR0+443	; Block 1x3 tiles from 7B4F to 674B
	DEFRTBL	2, 2,3, TLSCR0+430	; Block 2x3 tiles from 7984 to 673E
	DEFB	$00	; End of sequence

; Room 7F9C
L7F9C:	DEFW	LB458	; Room procedure
	DEFW	LA1B5	; Initialization
	DEFW	L7F48	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8008	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $01, 27,7, TLSCR0+210	; Rectangle 27x7 tiles with $01 at 6662
	DEFRT0E $E4, TLSCR0+182		; Put tile $E4 at 6646
	DEFRTBL	2, 2,3, TLSCR0+424	; Block 2x3 tiles from 7984 to 6738
	DEFRTBL	2, 2,3, TLSCR0+440	; Block 2x3 tiles from 7984 to 6748
	DEFB	$00	; End of sequence

; Room 7FC4
L7FC4:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L7C6D	; Room to Left
	DEFW	L8008	; Room to Right
	DEFW	L7F48	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 13,6, TLSCR0+240	; Rectangle 13x6 tiles with $02 at 6680
	DEFRT04 4, $03, TLSCR0+240	; Fill horz 4 tiles with $03 at 6680
	DEFRT04 9, $03, TLSCR0+214	; Fill horz 9 tiles with $03 at 6666
	DEFRTBN	0, 2, 14, TLSCR0+10	; Block 2 tiles from 71B9 to 659A copy 14 times
	DEFRTVT 17, $FD, TLSCR0+14	; Fill vert 17 tiles with $FD at 659E
	DEFRT04 14, $03, TLSCR0+166	; Fill horz 14 tiles with $03 at 6636
	DEFRT03 $02, 14,5, TLSCR0+196	; Rectangle 14x5 tiles with $02 at 6654
	DEFRTBL	3, 1,6, TLSCR0+353	; Block 1x6 tiles from 7B4F to 66F1
	DEFRTBL	4, 1,5, TLSCR0+23	; Block 1x5 tiles from 7B51 to 65A7
	DEFB	$00	; End of sequence

; Room 8008
L8008:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L7FC4	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L7F9C	; Room to Up
	DEFW	L8076	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT04 13, $03, TLSCR0+150	; Fill horz 13 tiles with $03 at 6626
	DEFRT04 11, $03, TLSCR0+166	; Fill horz 11 tiles with $03 at 6636
	DEFRT03 $02, 13,5, TLSCR0+180	; Rectangle 13x5 tiles with $02 at 6644
	DEFRT03 $02, 11,6, TLSCR0+196	; Rectangle 11x6 tiles with $02 at 6654
	DEFRT04 10, $02, TLSCR0+333	; Fill horz 10 tiles with $02 at 66DD
	DEFRTBN	0, 2, 12, TLSCR0+4	; Block 2 tiles from 71B9 to 6594 copy 12 times
	DEFRTBN	0, 2, 12, TLSCR0+20	; Block 2 tiles from 71B9 to 65A4 copy 12 times
	DEFRTBL	2, 2,5, TLSCR0+367	; Block 2x5 tiles from 7984 to 66FF
	DEFRTBL	2, 2,5, TLSCR0+380	; Block 2x5 tiles from 7984 to 670C
	DEFRTBL	3, 1,5, TLSCR0+370	; Block 1x5 tiles from 7B4F to 6702
	DEFRTBL	3, 1,5, TLSCR0+378	; Block 1x5 tiles from 7B4F to 670A
	DEFRTBL	3, 1,5, TLSCR0+385	; Block 1x5 tiles from 7B4F to 6711
	DEFRTBL	4, 1,5, TLSCR0+18	; Block 1x5 tiles from 7B51 to 65A2
	DEFRTBL	4, 1,5, TLSCR0+25	; Block 1x5 tiles from 7B51 to 65A9
	DEFRTVT 17, $FD, TLSCR0+14	; Fill vert 17 tiles with $FD at 659E
	DEFB	$00	; End of sequence

; Room 8076
L8076:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L8008	; Room to Up
	DEFW	L8384	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRTVT 17, $FD, TLSCR0+10	; Fill vert 17 tiles with $FD at 659A
	DEFRTVT 17, $FD, TLSCR0+14	; Fill vert 17 tiles with $FD at 659E
	DEFRTVT 17, $FD, TLSCR0+18	; Fill vert 17 tiles with $FD at 65A2
	DEFRTVT 17, $FD, TLSCR0+25	; Fill vert 17 tiles with $FD at 65A9
	DEFRTBN	0, 2, 17, TLSCR0+7	; Block 2 tiles from 71B9 to 6597 copy 17 times
	DEFRTBN	0, 2, 17, TLSCR0+20	; Block 2 tiles from 71B9 to 65A4 copy 17 times
	DEFB	$00	; End of sequence

; Room 80A7
L80A7:	DEFW	LB458	; Room procedure
	DEFW	LA1CB	; Initialization
	DEFW	L7E05	; Room to Left
	DEFW	L80F6	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 30, TLSCR0+0		; Fill horz 30 tiles with $FF at 6590
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTBK	7, TLSCR5+362		; Block 3x4 tiles from 7C0C to 70F0
	DEFRTBK	0, TLSCR5+397		; Block 3x3 tiles from 7C21 to 7113
	DEFRTBK	1, TLSCR5+401		; Block 3x3 tiles from 71A0 to 7117
	DEFRTBK	3, TLSCR5+406		; Block 4x3 tiles from 7E7B to 711C
	DEFRTBK	0, TLSCR5+317		; Block 3x3 tiles from 7C21 to 70C3
	DEFRTBK	0, TLSCR5+323		; Block 3x3 tiles from 7C21 to 70C9
	DEFRTBK	0, TLSCR5+412		; Block 3x3 tiles from 7C21 to 7122
	DEFRTBK	0, TLSCR5+415		; Block 3x3 tiles from 7C21 to 7125
	DEFB	$00	; End of sequence

; Room 80F6
L80F6:	DEFW	LB452	; Room procedure
	DEFW	LA38E	; Initialization
	DEFW	L80A7	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0A 2,16, TLSCR0+28	; Rectangle 2x16 tiles with $FF at 65AC
	DEFRTBK	2, TLSCR5+363		; Block 2x4 tiles from 71BB to 70F1
	DEFRTBK	0, TLSCR5+308		; Block 3x3 tiles from 7C21 to 70BA
	DEFRTBK	0, TLSCR5+396		; Block 3x3 tiles from 7C21 to 7112
	DEFRTBK	0, TLSCR5+399		; Block 3x3 tiles from 7C21 to 7115
	DEFRTBK	0, TLSCR5+233		; Block 3x3 tiles from 7C21 to 706F
	DEFRTBK	0, TLSCR5+321		; Block 3x3 tiles from 7C21 to 70C7
	DEFRTBK	0, TLSCR5+325		; Block 3x3 tiles from 7C21 to 70CB
	DEFRTBK	0, TLSCR5+409		; Block 3x3 tiles from 7C21 to 711F
	DEFRTBK	0, TLSCR5+412		; Block 3x3 tiles from 7C21 to 7122
	DEFRTBK	0, TLSCR5+415		; Block 3x3 tiles from 7C21 to 7125
	DEFRTBK	3, TLSCR5+404		; Block 4x3 tiles from 7E7B to 711A
	DEFRTBK	9, TLSCR5+463		; Block 2x1 tiles from 7E8A to 7155
	DEFB	$00	; End of sequence

; Room 8162
L8162:	DEFW	LB458	; Room procedure
	DEFW	LA1C0	; Initialization
	DEFW	L81E5	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L8321	; Room to Up
	DEFW	L7BD2	; Room to Down
	DEFRT03 $01, 28,8, TLSCR0+240	; Rectangle 28x8 tiles with $01 at 6680
	DEFRT0C 28, TLSCR0+210		; Fill horz 28 tiles with $FF at 6662
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0C 13, TLSCR0+0		; Fill horz 13 tiles with $FF at 6590
	DEFRT0C 7, TLSCR0+23		; Fill horz 7 tiles with $FF at 65A7
	DEFRTBN	13, 2, 15, TLSCR0+58	; Block 2 tiles from 81E3 to 65CA copy 15 times
	DEFRTBN	1, 2, 7, TLSCR0+16	; Block 2 tiles from 7348 to 65A0 copy 7 times
	DEFRTBK	2, TLSCR5+97		; Block 2x4 tiles from 71BB to 6FE7
	DEFRTBK	7, TLSCR5+361		; Block 3x4 tiles from 7C0C to 70EF
	DEFRTBK	8, TLSCR5+394		; Block 3x3 tiles from 7C18 to 7110
	DEFRTBK	8, TLSCR5+407		; Block 3x3 tiles from 7C18 to 711D
	DEFRTBK	7, TLSCR5+382		; Block 3x4 tiles from 7C0C to 7104
	DEFRTBK	8, TLSCR5+415		; Block 3x3 tiles from 7C18 to 7125
	DEFRT0B TLSCR5+34		; Put tile 2A at 6FA8
	DEFRTVT 5, $2B, TLSCR5+64	; Fill vert 5 tiles with $2B at 6FC6
	DEFRT0B TLSCR5+41		; Put tile 2A at 6FAF
	DEFRTVT 5, $2B, TLSCR5+71	; Fill vert 5 tiles with $2B at 6FCD
	DEFRT0B TLSCR5+54		; Put tile 2A at 6FBC
	DEFRTVT 5, $2B, TLSCR5+84	; Fill vert 5 tiles with $2B at 6FDA
	DEFRTBN	7, 2, 1, TLSCR0+494	; Block 2 tiles from 7C2C to 677E copy 1 times
	DEFB	$00	; End of sequence

; Room 81E5
L81E5:	DEFW	LB452	; Room procedure
	DEFW	LA353	; Initialization
	DEFW	L8238	; Room to Left
	DEFW	L8162	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0A 30,9, TLSCR0+240	; Rectangle 30x9 tiles with $FF at 6680
	DEFRT03 $01, 28,7, TLSCR0+272	; Rectangle 28x7 tiles with $01 at 66A0
	DEFRT04 5, $00, TLSCR0+240	; Fill horz 5 tiles with $00 at 6680
	DEFRT0C 6, TLSCR0+270		; Fill horz 6 tiles with $FF at 669E
	DEFRT0C 12, TLSCR0+0		; Fill horz 12 tiles with $FF at 6590
	DEFRT0C 11, TLSCR0+19		; Fill horz 11 tiles with $FF at 65A3
	DEFRT06 $FF, 2, TLSCR0+30	; Triangle with FF, count=2 at 65AE
	DEFRT0B TLSCR5+38		; Put tile 2A at 6FAC
	DEFRT0B TLSCR5+50		; Put tile 2A at 6FB8
	DEFRTVT 6, $2B, TLSCR5+68	; Fill vert 6 tiles with $2B at 6FCA
	DEFRTVT 5, $2B, TLSCR5+80	; Fill vert 5 tiles with $2B at 6FD6
	DEFRT04 10, $01, TLSCR0+260	; Fill horz 10 tiles with $01 at 6694
	DEFRT04 24, $01, TLSCR0+276	; Fill horz 24 tiles with $01 at 66A4
	DEFRT0C 11, TLSCR0+229		; Fill horz 11 tiles with $FF at 6675
	DEFB	$00	; End of sequence

; Room 8238
L8238:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L81E5	; Room to Right
	DEFW	L8279	; Room to Up
	DEFW	L7A17	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 28,6, TLSCR0+92	; Rectangle 28x6 tiles with $00 at 65EC
	DEFRT04 14, $00, TLSCR0+272	; Fill horz 14 tiles with $00 at 66A0
	DEFRTBN	0, 2, 17, TLSCR0+8	; Block 2 tiles from 71B9 to 6598 copy 17 times
	DEFRTBN	1, 2, 7, TLSCR0+98	; Block 2 tiles from 7348 to 65F2 copy 7 times
	DEFRTBL	2, 2,1, TLSCR0+308	; Block 2x1 tiles from 7984 to 66C4
	DEFRT0B TLSCR5+94		; Put tile 2A at 6FE4
	DEFRT0B TLSCR5+114		; Put tile 2A at 6FF8
	DEFRTVT 6, $2B, TLSCR5+124	; Fill vert 6 tiles with $2B at 7002
	DEFRTVT 5, $2B, TLSCR5+144	; Fill vert 5 tiles with $2B at 7016
	DEFB	$00	; End of sequence

; Room 8279
L8279:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L82DD	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8238	; Room to Down
	DEFRTBN	13, 2, 17, TLSCR0+0	; Block 2 tiles from 81E3 to 6590 copy 17 times
	DEFRT07 $FF, 4, TLSCR0+302	; Triangle with FF, count=4 at 66BE
	DEFRT0C 15, TLSCR0+420		; Fill horz 15 tiles with $FF at 6734
	DEFRT0C 21, TLSCR0+450		; Fill horz 21 tiles with $FF at 6752
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTBK	0, TLSCR5+287		; Block 3x3 tiles from 7C21 to 70A5
	DEFRTBK	0, TLSCR5+321		; Block 3x3 tiles from 7C21 to 70C7
	DEFRTBK	0, TLSCR5+341		; Block 3x3 tiles from 7C21 to 70DB
	DEFRTBK	0, TLSCR5+375		; Block 3x3 tiles from 7C21 to 70FD
	DEFRTBK	0, TLSCR5+378		; Block 3x3 tiles from 7C21 to 7100
	DEFRTBK	0, TLSCR5+411		; Block 3x3 tiles from 7C21 to 7121
	DEFRTBK	0, TLSCR5+414		; Block 3x3 tiles from 7C21 to 7124
	DEFRTBL	2, 2,3, TLSCR0+428	; Block 2x3 tiles from 7984 to 673C
	DEFRT0E $00, TLSCR0+302	; Put tile 00 at 66BE
	DEFB	$00	; End of sequence

; Room 82DD
L82DD:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8279	; Room to Left
	DEFW	L8321	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L81E5	; Room to Down
	DEFRT0C 13, TLSCR0+480		; Fill horz 13 tiles with $FF at 6770
	DEFRT0C 7, TLSCR0+456		; Fill horz 7 tiles with $FF at 6758
	DEFRT0C 6, TLSCR0+468		; Fill horz 6 tiles with $FF at 6764
	DEFRT0C 12, TLSCR0+498		; Fill horz 12 tiles with $FF at 6782
	DEFRTBK	0, TLSCR5+390		; Block 3x3 tiles from 7C21 to 710C
	DEFRTBK	0, TLSCR5+393		; Block 3x3 tiles from 7C21 to 710F
	DEFRTBK	0, TLSCR5+367		; Block 3x3 tiles from 7C21 to 70F5
	DEFRTBK	1, TLSCR5+380		; Block 3x3 tiles from 71A0 to 7102
	DEFRTBK	3, TLSCR5+415		; Block 4x3 tiles from 7E7B to 7125
	DEFB	$00	; End of sequence

; Room 8321
L8321:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L82DD	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L844E	; Room to Up
	DEFW	L8162	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTBL	2, 2,1, TLSCR0+496	; Block 2x1 tiles from 7984 to 6780
	DEFRT0A 3,4, TLSCR0+27	; Rectangle 3x4 tiles with $FF at 65AB
	DEFRTVT 12, $EB, TLSCR0+148	; Fill vert 12 tiles with $EB at 6624
	DEFRTBK	3, TLSCR5+392		; Block 4x3 tiles from 7E7B to 710E
	DEFRTBK	3, TLSCR5+304		; Block 4x3 tiles from 7E7B to 70B6
	DEFRTBK	1, TLSCR5+397		; Block 3x3 tiles from 71A0 to 7113
	DEFRTBK	0, TLSCR5+402		; Block 3x3 tiles from 7C21 to 7118
	DEFRTBK	1, TLSCR5+409		; Block 3x3 tiles from 71A0 to 711F
	DEFRTBK	1, TLSCR5+414		; Block 3x3 tiles from 71A0 to 7124
	DEFRTBK	9, TLSCR5+473		; Block 2x1 tiles from 7E8A to 715F
	DEFRTBK	3, TLSCR5+321		; Block 4x3 tiles from 7E7B to 70C7
	DEFRTBN	1, 2, 16, TLSCR0+16	; Block 2 tiles from 7348 to 65A0 copy 16 times
	DEFB	$00	; End of sequence

; Room 8384
L8384:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L8076	; Room to Up
	DEFW	L9376	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 15,7, TLSCR0+152	; Rectangle 15x7 tiles with $02 at 6628
	DEFRT04 15, $03, TLSCR0+122	; Fill horz 15 tiles with $03 at 660A
	DEFRT03 $02, 6,7, TLSCR0+172	; Rectangle 6x7 tiles with $02 at 663C
	DEFRT04 6, $03, TLSCR0+142	; Fill horz 6 tiles with $03 at 661E
	DEFRTBN	0, 2, 12, TLSCR0+7	; Block 2 tiles from 71B9 to 6597 copy 12 times
	DEFRTBN	0, 2, 17, TLSCR0+20	; Block 2 tiles from 71B9 to 65A4 copy 17 times
	DEFRTBL	2, 2,5, TLSCR0+364	; Block 2x5 tiles from 7984 to 66FC
	DEFRTBL	2, 2,1, TLSCR0+380	; Block 2x1 tiles from 7984 to 670C
	DEFRTVT 17, $FD, TLSCR0+18	; Fill vert 17 tiles with $FD at 65A2
	DEFRTBL	5, 1,4, TLSCR0+10	; Block 1x4 tiles from 7B52 to 659A
	DEFRTBL	5, 1,4, TLSCR0+14	; Block 1x4 tiles from 7B52 to 659E
	DEFRTBL	5, 1,4, TLSCR0+25	; Block 1x4 tiles from 7B52 to 65A9
	DEFRTBL	3, 1,5, TLSCR0+370	; Block 1x5 tiles from 7B4F to 6702
	DEFRTBL	3, 1,5, TLSCR0+385	; Block 1x5 tiles from 7B4F to 6711
	DEFB	$00	; End of sequence

; Room 83ED
L83ED:	DEFW	LB452	; Room procedure
	DEFW	LA361	; Initialization
	DEFW	0	; Room to Left
	DEFW	L920A	; Room to Right
	DEFW	L913F	; Room to Up
	DEFW	L7E05	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTBN	1, 2, 16, TLSCR0+9	; Block 2 tiles from 7348 to 6599 copy 16 times
	DEFRTBL	2, 2,1, TLSCR0+489	; Block 2x1 tiles from 7984 to 6779
	DEFRT0A 3,4, TLSCR0+0	; Rectangle 3x4 tiles with $FF at 6590
	DEFRT0C 2, TLSCR0+3		; Fill horz 2 tiles with $FF at 6593
	DEFRTVT 12, $EB, TLSCR0+121	; Fill vert 12 tiles with $EB at 6609
	DEFRTBK	7, TLSCR5+364		; Block 3x4 tiles from 7C0C to 70F2
	DEFRTBK	1, TLSCR5+392		; Block 3x3 tiles from 71A0 to 710E
	DEFRTBK	9, TLSCR5+456		; Block 2x1 tiles from 7E8A to 714E
	DEFRTBK	3, TLSCR5+318		; Block 4x3 tiles from 7E7B to 70C4
	DEFRTBK	3, TLSCR5+405		; Block 4x3 tiles from 7E7B to 711B
	DEFRTBK	7, TLSCR5+384		; Block 3x4 tiles from 7C0C to 7106
	DEFRTBK	3, TLSCR5+411		; Block 4x3 tiles from 7E7B to 7121
	DEFB	$00	; End of sequence

; Room 844E
L844E:	DEFW	LB452	; Room procedure
	DEFW	LA37F	; Initialization
	DEFW	L84A8	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8321	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0C 6, TLSCR0+450		; Fill horz 6 tiles with $FF at 6752
	DEFRT0A 3,4, TLSCR0+27	; Rectangle 3x4 tiles with $FF at 65AB
	DEFRTVT 12, $EB, TLSCR0+148	; Fill vert 12 tiles with $EB at 6624
	DEFRTBL	2, 2,1, TLSCR0+496	; Block 2x1 tiles from 7984 to 6780
	DEFRTBK	1, TLSCR5+362		; Block 3x3 tiles from 71A0 to 70F0
	DEFRTBK	1, TLSCR5+396		; Block 3x3 tiles from 71A0 to 7112
	DEFRTBK	0, TLSCR5+312		; Barrel 3x3 tiles at 70BE
	DEFRTBK	0, TLSCR5+400		; Barrel 3x3 tiles at 7116
	DEFRTBK	0, TLSCR5+403		; Barrel 3x3 tiles at 7119
	DEFRTBK	3, TLSCR5+409		; Block 4x3 tiles from 7E7B to 711F
	DEFRTBL	14, 3,4, TLSCR5+385	; Block 3x4 tiles from 849C to 7107
	DEFB	$00	; End of sequence

; Room 84A8
L84A8:	DEFW	LB41F	; Room procedure
	DEFW	LF973	; Initialization
	DEFW	L84EE	; Room to Left
	DEFW	L844E	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L82DD	; Room to Down
	DEFRT0A 13,2, TLSCR0+450	; Rectangle 13x2 tiles with $FF at 6752
	DEFRT0A 12,2, TLSCR0+468	; Rectangle 12x2 tiles with $FF at 6764
	DEFRT0C 3, TLSCR0+44		; Fill horz 3 tiles with $FF at 65BC
	DEFRT0C 13, TLSCR0+10		; Fill horz 13 tiles with $FF at 659A
	DEFRTBK	0, TLSCR5+362		; Barrel 3x3 tiles at 70F0
	DEFRTBK	0, TLSCR5+273		; Barrel 3x3 tiles at 7097
	DEFRTBK	3, TLSCR5+382		; Block 4x3 tiles from 7E7B to 7104
	DEFRTBL	15, 5,3, TLSCR5+364	; Block 5x3 tiles from 84DF to 70F2
	DEFRTBL	48, 3,6, TLSCR0+74	; Crane block 3x6 tiles from F98F to 65DA
	DEFB	$00	; End of sequence

; Room 84EE
L84EE:	DEFW	L7918	; Room procedure
	DEFW	LA10B	; Initialization
	DEFW	0	; Room to Left
	DEFW	L84A8	; Room to Right
	DEFW	L8526	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0A 2,15, TLSCR0+0	; Rectangle 2x15 tiles with $FF at 6590
	DEFRT0A 30,2, TLSCR0+450	; Rectangle 30x2 tiles with $FF at 6752
	DEFRTBN	1, 2, 15, TLSCR0+8	; Block 2 tiles from 7348 to 6598 copy 15 times
	DEFRTBK	0, TLSCR5+362		; Barrel 3x3 tiles at 70F0
	DEFRTBK	0, TLSCR5+365		; Barrel 3x3 tiles at 70F3
	DEFRTBK	0, TLSCR5+199		; Barrel 3x3 tiles at 704D
	DEFRTBK	0, TLSCR5+288		; Barrel 3x3 tiles at 70A6
	DEFRTBK	0, TLSCR5+291		; Barrel 3x3 tiles at 70A9
	DEFRTBK	0, TLSCR5+376		; Barrel 3x3 tiles at 70FE
	DEFRTBK	0, TLSCR5+379		; Barrel 3x3 tiles at 7101
	DEFRTBK	0, TLSCR5+382		; Barrel 3x3 tiles at 7104
	DEFB	$00	; End of sequence

; Room 8526
L8526:	DEFW	LB483	; Room procedure
	DEFW	LA179	; Initialization
	DEFW	0	; Room to Left
	DEFW	L858F	; Room to Right
	DEFW	L8608	; Room to Up
	DEFW	L84EE	; Room to Down
	DEFRTBN	13, 2, 16, TLSCR0+0	; Block 2 tiles from 81E3 to 6590 copy 16 times
	DEFRTBN	1, 2, 16, TLSCR0+8	; Block 2 tiles from 7348 to 6598 copy 16 times
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTBL	2, 2,1, TLSCR0+488	; Block 2x1 tiles from 7984 to 6778
	DEFRTBK	0, TLSCR5+302		; Barrel 3x3 tiles at 70B4
	DEFRTBK	0, TLSCR5+393		; Barrel 3x3 tiles at 710F
	DEFRTBK	0, TLSCR5+416		; Barrel 3x3 tiles at 7126
	DEFRTBL	16, 2,2, TLSCR5+434	; Block 2x2 tiles from 8577 to 7138
	DEFRTBL	14, 3,4, TLSCR5+378	; Block 3x4 tiles from 849C to 7100
	DEFRTBL	16, 2,2, TLSCR5+440	; Block 2x2 tiles from 8577 to 713E
	DEFRTBL	16, 2,2, TLSCR5+443	; Block 2x2 tiles from 8577 to 7141
	DEFRT0C 6, TLSCR0+15		; Fill horz 6 tiles with $FF at 659F
	DEFB	$00	; End of sequence

; Room 858F
L858F:	DEFW	L7918	; Room procedure
	DEFW	LA106	; Initialization
	DEFW	L8526	; Room to Left
	DEFW	L85BD	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTBL	17, 5,4, TLSCR5+364	; Block 5x4 tiles from 857B to 70F2
	DEFRTBL	17, 5,4, TLSCR5+371	; Block 5x4 tiles from 857B to 70F9
	DEFRTBK	9, TLSCR5+456		; Block 2x1 tiles from 7E8A to 714E
	DEFRTBK	1, TLSCR5+408		; Block 3x3 tiles from 71A0 to 711E
	DEFB	$00	; End of sequence

; Room 85BD
L85BD:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L858F	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L8689	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0A 3,4, TLSCR0+27	; Rectangle 3x4 tiles with $FF at 65AB
	DEFRTVT 12, $EB, TLSCR0+148	; Fill vert 12 tiles with $EB at 6624
	DEFRTBN	1, 2, 16, TLSCR0+13	; Block 2 tiles from 7348 to 659D copy 16 times
	DEFRTBK	0, TLSCR5+126		; Barrel 3x3 tiles at 7004
	DEFRTBK	0, TLSCR5+215		; Barrel 3x3 tiles at 705D
	DEFRTBK	0, TLSCR5+218		; Barrel 3x3 tiles at 7060
	DEFRTBK	0, TLSCR5+303		; Barrel 3x3 tiles at 70B5
	DEFRTBK	0, TLSCR5+306		; Barrel 3x3 tiles at 70B8
	DEFRTBK	0, TLSCR5+309		; Barrel 3x3 tiles at 70BB
	DEFRTBK	0, TLSCR5+392		; Barrel 3x3 tiles at 710E
	DEFRTBK	0, TLSCR5+395		; Barrel 3x3 tiles at 7111
	DEFRTBK	0, TLSCR5+398		; Barrel 3x3 tiles at 7114
	DEFRTBK	0, TLSCR5+407		; Barrel 3x3 tiles at 711D
	DEFRTBK	0, TLSCR5+411		; Barrel 3x3 tiles at 7121
	DEFRTBK	0, TLSCR5+414		; Barrel 3x3 tiles at 7124
	DEFRTBK	0, TLSCR5+401		; Barrel 3x3 tiles at 7117
	DEFB	$00	; End of sequence

; Room 8608
L8608:	DEFW	LB452	; Room procedure
	DEFW	LA37A	; Initialization
	DEFW	0	; Room to Left
	DEFW	L86FD	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8526	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0C 28, TLSCR0+242		; Fill horz 28 tiles with $FF at 6682
	DEFRT0C 12, TLSCR0+228		; Fill horz 12 tiles with $FF at 6674
	DEFRTBN	13, 2, 16, TLSCR0+0	; Block 2 tiles from 81E3 to 6590 copy 16 times
	DEFRT0C 14, TLSCR0+2		; Fill horz 14 tiles with $FF at 6592
	DEFRTBN	13, 2, 7, TLSCR0+298	; Block 2 tiles from 81E3 to 66BA copy 7 times
	DEFRTBL	2, 2,1, TLSCR0+488	; Block 2x1 tiles from 7984 to 6778
	DEFRTBK	1, TLSCR5+62		; Block 3x3 tiles from 71A0 to 6FC4
	DEFRTBK	3, TLSCR5+152		; Block 4x3 tiles from 7E7B to 701E
	DEFRTBK	1, TLSCR5+158		; Block 3x3 tiles from 71A0 to 7024
	DEFRTBK	0, TLSCR5+162		; Barrel 3x3 tiles at 7028
	DEFRTBK	8, TLSCR5+139		; Block 3x3 tiles from 7C18 to 7011
	DEFRTBK	7, TLSCR5+113		; Block 3x4 tiles from 7C0C to 6FF7
	DEFRTBK	8, TLSCR5+402		; Block 3x3 tiles from 7C18 to 7118
	DEFRTBK	0, TLSCR5+303		; Barrel 3x3 tiles at 70B5
	DEFRTBK	0, TLSCR5+392		; Barrel 3x3 tiles at 710E
	DEFRTBK	0, TLSCR5+395		; Barrel 3x3 tiles at 7111
	DEFRTBK	0, TLSCR5+318		; Barrel 3x3 tiles at 70C4
	DEFRTBK	0, TLSCR5+322		; Barrel 3x3 tiles at 70C8
	DEFRTBK	0, TLSCR5+325		; Barrel 3x3 tiles at 70CB
	DEFRTBK	0, TLSCR5+406		; Barrel 3x3 tiles at 711C
	DEFRTBK	0, TLSCR5+409		; Barrel 3x3 tiles at 711F
	DEFRTBK	0, TLSCR5+412		; Barrel 3x3 tiles at 7122
	DEFRTBK	0, TLSCR5+415		; Barrel 3x3 tiles at 7125
	DEFB	$00	; End of sequence

; Room 8689
L8689:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L86FD	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L85BD	; Room to Down
	DEFRT0C 57, TLSCR0+300		; Fill horz 57 tiles with $FF at 66BC
	DEFRT0A 3,17, TLSCR0+27	; Rectangle 3x17 tiles with $FF at 65AB
	DEFRTBL	2, 2,2, TLSCR0+313	; Block 2x2 tiles from 7984 to 66C9
	DEFRTBN	1, 2, 5, TLSCR0+373	; Block 2 tiles from 7348 to 6705 copy 5 times
	DEFRTBK	8, TLSCR5+225		; Block 3x3 tiles from 7C18 to 7067
	DEFRTBL	18, 4,2, TLSCR5+155	; Block 4x2 tiles from 86F5 to 7021
	DEFRTBK	3, TLSCR5+213		; Block 4x3 tiles from 7E7B to 705B
	DEFRTBK	1, TLSCR5+218		; Block 3x3 tiles from 71A0 to 7060
	DEFRTBK	15, TLSCR5+272		; Block 3x1 tiles from 7E87 to 7096
	DEFRTBL	15, 5,3, TLSCR5+51	; Block 5x3 tiles from 84DF to 6FB9
	DEFRTBK	1, TLSCR5+140		; Block 3x3 tiles from 71A0 to 7012
	DEFRTBK	3, TLSCR5+143		; Block 4x3 tiles from 7E7B to 7015
	DEFRTBK	3, TLSCR5+229		; Block 4x3 tiles from 7E7B to 706B
	DEFRTBK	3, TLSCR5+233		; Block 4x3 tiles from 7E7B to 706F
	DEFB	$00	; End of sequence

; Room 86FD
L86FD:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8608	; Room to Left
	DEFW	L8689	; Room to Right
	DEFW	L8739	; Room to Up
	DEFW	0	; Room to Down
	DEFRT06 $FF, 4, TLSCR0+390	; Triangle with FF, count=4 at 6716
	DEFRT0C 65, TLSCR0+300		; Fill horz 65 tiles with $FF at 66BC
	DEFRT07 $FF, 2, TLSCR0+247	; Triangle with FF, count=2 at 6687
	DEFRT0A 7,3, TLSCR0+210	; Rectangle 7x3 tiles with $FF at 6662
	DEFRTBN	1, 2, 7, TLSCR0+3	; Block 2 tiles from 7348 to 6593 copy 7 times
	DEFRTBK	6, TLSCR5+96		; Block 4x7 tiles from 79AA to 6FE6
	DEFRTBK	0, TLSCR5+136		; Barrel 3x3 tiles at 700E
	DEFRTBK	0, TLSCR5+224		; Barrel 3x3 tiles at 7066
	DEFRTBK	0, TLSCR5+227		; Barrel 3x3 tiles at 7069
	DEFRTBK	0, TLSCR5+233		; Barrel 3x3 tiles at 706F
	DEFB	$00	; End of sequence

; Room 8739
L8739:	DEFW	L7918	; Room procedure
	DEFW	LA101	; Initialization
	DEFW	L8799	; Room to Left
	DEFW	L8802	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L86FD	; Room to Down
	DEFRTVT 9, $3A, TLSCR0+4	; Fill vert 9 tiles with $3A at 6594
	DEFRTVT 9, $3A, TLSCR0+14	; Fill vert 9 tiles with $3A at 659E
	DEFRTVT 9, $3A, TLSCR0+17	; Fill vert 9 tiles with $3A at 65A1
	DEFRTVT 5, $3A, TLSCR0+24	; Fill vert 5 tiles with $3A at 65A8
	DEFRT0C 120, TLSCR0+270		; Fill horz 120 tiles with $FF at 669E
	DEFRTBL	2, 2,4, TLSCR0+273	; Block 2x4 tiles from 7984 to 66A1
	DEFRTBN	1, 2, 4, TLSCR0+393	; Block 2 tiles from 7348 to 6719 copy 4 times
	DEFRTBK	2, TLSCR5+168		; Block 2x4 tiles from 71BB to 702E
	DEFRTBK	8, TLSCR5+190		; Block 3x3 tiles from 7C18 to 7044
	DEFRTBK	7, TLSCR5+157		; Block 3x4 tiles from 7C0C to 7023
	DEFRTBK	7, TLSCR5+173		; Block 3x4 tiles from 7C0C to 7033
	DEFB	$00	; End of sequence

; Room 8799
L8799:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L8739	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRTVT 15, $3A, TLSCR0+8	; Fill vert 15 tiles with $3A at 6598
	DEFRTVT 11, $3A, TLSCR0+13	; Fill vert 11 tiles with $3A at 659D
	DEFRTVT 9, $3A, TLSCR0+17	; Fill vert 9 tiles with $3A at 65A1
	DEFRTVT 9, $3A, TLSCR0+20	; Fill vert 9 tiles with $3A at 65A4
	DEFRTVT 9, $3A, TLSCR0+23	; Fill vert 9 tiles with $3A at 65A7
	DEFRTVT 9, $3A, TLSCR0+27	; Fill vert 9 tiles with $3A at 65AB
	DEFRTBN	13, 2, 15, TLSCR0+0	; Block 2 tiles from 81E3 to 6590 copy 15 times
	DEFRT0A 16,2, TLSCR0+450	; Rectangle 16x2 tiles with $FF at 6752
	DEFRT0A 14,4, TLSCR0+286	; Rectangle 14x4 tiles with $FF at 66AE
	DEFRT08 $FF, 6, TLSCR0+285	; Triangle with FF, count=6 at 66AD
	DEFRT06 $FF, 4, TLSCR0+406	; Triangle with FF, count=4 at 6726
	DEFRT04 8, $FA, TLSCR0+62	; Fill horz 8 tiles with $FA at 65CE
	DEFRTBK	1, TLSCR5+242		; Block 3x3 tiles from 71A0 to 7078
	DEFRTBL	19, 4,4, TLSCR5+332	; Block 4x4 tiles from 8789 to 70D2
	DEFRTBK	5, TLSCR5+249		; Block 4x7 tiles from 798E to 707F
	DEFRTBK	5, TLSCR5+162		; Block 4x7 tiles from 798E to 7028
	DEFB	$00	; End of sequence

; Room 8802
L8802:	DEFW	LB452	; Room procedure
	DEFW	LA375	; Initialization
	DEFW	L8739	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L8834	; Room to Up
	DEFW	0	; Room to Down
	DEFRTVT 9, $3A, TLSCR0+13	; Fill vert 9 tiles with $3A at 659D
	DEFRTVT 8, $3A, TLSCR0+18	; Fill vert 8 tiles with $3A at 65A2
	DEFRT0A 3,17, TLSCR0+27	; Rectangle 3x17 tiles with $FF at 65AB
	DEFRT0C 132, TLSCR0+258		; Fill horz 132 tiles with $FF at 6692
	DEFRTBK	0, TLSCR5+188		; Barrel 3x3 tiles at 7042
	DEFRTBK	0, TLSCR5+192		; Barrel 3x3 tiles at 7046
	DEFRTBK	0, TLSCR5+169		; Barrel 3x3 tiles at 702F
	DEFRTBN	1, 2, 8, TLSCR0+23	; Block 2 tiles from 7348 to 65A7 copy 8 times
	DEFB	$00	; End of sequence

; Room 8834
L8834:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L889F	; Room to Left
	DEFW	L890E	; Room to Right
	DEFW	L8A81	; Room to Up
	DEFW	L8802	; Room to Down
	DEFRTVT 11, $3A, TLSCR0+92	; Fill vert 11 tiles with $3A at 65EC
	DEFRTVT 14, $3A, TLSCR0+7	; Fill vert 14 tiles with $3A at 6597
	DEFRTVT 16, $3A, TLSCR0+13	; Fill vert 16 tiles with $3A at 659D
	DEFRTVT 17, $3A, TLSCR0+18	; Fill vert 17 tiles with $3A at 65A2
	DEFRT0C 10, TLSCR0+500		; Fill horz 10 tiles with $FF at 6784
	DEFRTBN	1, 2, 16, TLSCR0+23	; Block 2 tiles from 7348 to 65A7 copy 16 times
	DEFRT0E $3A, TLSCR0+460	; Put tile 3A at 675C
	DEFRTBK	10, TLSCR0+323		; Block 2x1 tiles from 889D to 66D3
	DEFRTBL	2, 2,1, TLSCR0+503	; Block 2x1 tiles from 7984 to 6787
	DEFRT04 7, $FA, TLSCR0+490	; Fill horz 7 tiles with $FA at 677A
	DEFRTBL	20, 1,2, TLSCR0+462	; Block 1x2 tiles from 8898 to 675E
	DEFRT04 12, $FA, TLSCR0+420	; Fill horz 12 tiles with $FA at 6734
	DEFRT04 4, $FA, TLSCR0+240	; Fill horz 4 tiles with $FA at 6680
	DEFRT04 4, $FA, TLSCR0+336	; Fill horz 4 tiles with $FA at 66E0
	DEFRT04 6, $FA, TLSCR0+317	; Fill horz 6 tiles with $FA at 66CD
	DEFRTVT 3, $28, TLSCR5+2	; Fill vert 3 tiles with $28 at 6F88
	DEFB	$00	; End of sequence

; Room 889F
L889F:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8953	; Room to Left
	DEFW	L8834	; Room to Right
	DEFW	L89B9	; Room to Up
	DEFW	L8739	; Room to Down
	DEFRTVT 17, $3A, TLSCR0+4	; Fill vert 17 tiles with $3A at 6594
	DEFRTVT 17, $3A, TLSCR0+24	; Fill vert 17 tiles with $3A at 65A8
	DEFRTVT 12, $3A, TLSCR0+12	; Fill vert 12 tiles with $3A at 659C
	DEFRTVT 6, $3A, TLSCR0+15	; Fill vert 6 tiles with $3A at 659F
	DEFRTVT 6, $3A, TLSCR0+19	; Fill vert 6 tiles with $3A at 65A3
	DEFRTVT 4, $3A, TLSCR0+404	; Fill vert 4 tiles with $3A at 6724
	DEFRTVT 6, $3A, TLSCR0+347	; Fill vert 6 tiles with $3A at 66EB
	DEFRT04 7, $63, TLSCR0+195	; Fill horz 7 tiles with $63 at 6653
	DEFRTVT 7, $3A, TLSCR0+137	; Fill vert 7 tiles with $3A at 6619
	DEFRT0E $63, TLSCR0+197	; Put tile 63 at 6655
	DEFRT04 4, $FA, TLSCR0+274	; Fill horz 4 tiles with $FA at 66A2
	DEFRT04 10, $FA, TLSCR0+330	; Fill horz 10 tiles with $FA at 66DA
	DEFRT04 3, $FA, TLSCR0+372	; Fill horz 3 tiles with $FA at 6704
L88EB:	DEFRT04 11, $FA, TLSCR0+463	; Fill horz 11 tiles with $FA at 675F
	DEFRT04 6, $FA, TLSCR0+264	; Fill horz 6 tiles with $FA at 6698
	DEFRT04 3, $FA, TLSCR0+447	; Fill horz 3 tiles with $FA at 674F
	DEFRT04 6, $FA, TLSCR0+474	; Fill horz 6 tiles with $FA at 676A
	DEFRTBL	21, 1,1, TLSCR0+276	; Block 1x1 tiles from 8899 to 66A4
	DEFRTBL	20, 1,4, TLSCR0+306	; Block 1x4 tiles from 8898 to 66C2
	DEFB	$00	; End of sequence

; Room 890E
L890E:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8834	; Room to Left
	DEFW	L8BF0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRTVT 16, $3A, TLSCR0+9	; Fill vert 16 tiles with $3A at 6599
	DEFRTVT 16, $3A, TLSCR0+17	; Fill vert 16 tiles with $3A at 65A1
	DEFRTVT 7, $3A, TLSCR0+294	; Fill vert 7 tiles with $3A at 66B6
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTBK	8, TLSCR5+396		; Block 3x3 tiles from 7C18 to 7112
	DEFRT04 5, $63, TLSCR0+137	; Fill horz 5 tiles with $63 at 6619
	DEFRT04 3, $FA, TLSCR0+286	; Fill horz 3 tiles with $FA at 66AE
	DEFRT04 7, $FA, TLSCR0+263	; Fill horz 7 tiles with $FA at 6697
	DEFRT04 9, $FA, TLSCR0+244	; Fill horz 9 tiles with $FA at 6684
	DEFRTVT 7, $F9, TLSCR0+99	; Fill vert 7 tiles with $F9 at 65F3
	DEFRT0E $F8, TLSCR0+249	; Put tile F8 at 6689
	DEFB	$00	; End of sequence

; Room 8953
L8953:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L889F	; Room to Right
	DEFW	L89B9	; Room to Up
	DEFW	L8799	; Room to Down
	DEFRTVT 17, $3A, TLSCR0+8	; Fill vert 17 tiles with $3A at 6598
	DEFRTVT 16, $3A, TLSCR0+13	; Fill vert 16 tiles with $3A at 659D
	DEFRTVT 5, $3A, TLSCR0+16	; Fill vert 5 tiles with $3A at 65A0
	DEFRTVT 9, $3A, TLSCR0+19	; Fill vert 9 tiles with $3A at 65A3
	DEFRTVT 17, $3A, TLSCR0+27	; Fill vert 17 tiles with $3A at 65AB
	DEFRTVT 7, $3A, TLSCR0+317	; Fill vert 7 tiles with $3A at 66CD
	DEFRTVT 7, $3A, TLSCR0+320	; Fill vert 7 tiles with $3A at 66D0
	DEFRTVT 2, $3A, TLSCR0+473	; Fill vert 2 tiles with $3A at 6769
	DEFRTBN	13, 2, 17, TLSCR0+0	; Block 2 tiles from 81E3 to 6590 copy 17 times
	DEFRTBN	1, 2, 9, TLSCR0+5	; Block 2 tiles from 7348 to 6595 copy 9 times
	DEFRT04 5, $63, TLSCR0+163	; Fill horz 5 tiles with $63 at 6633
	DEFRT04 7, $FA, TLSCR0+272	; Fill horz 7 tiles with $FA at 66A0
	DEFRT04 8, $FA, TLSCR0+452	; Fill horz 8 tiles with $FA at 6754
	DEFRT04 3, $FA, TLSCR0+492	; Fill horz 3 tiles with $FA at 677C
	DEFRT04 5, $FA, TLSCR0+286	; Fill horz 5 tiles with $FA at 66AE
	DEFRT04 6, $FA, TLSCR0+439	; Fill horz 6 tiles with $FA at 6747
L89B3:	DEFRT04 23, $FA, TLSCR0+337	; Fill horz 23 tiles with $FA at 66E1
	DEFB	$00	; End of sequence

; Room 89B9
L89B9:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L8A2D	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8953	; Room to Down
	DEFRT0E $3A, TLSCR0+294	; Put tile 3A at 66B6
	DEFRT0E $3A, TLSCR0+410	; Put tile 3A at 672A
	DEFRTVT 8, $3A, TLSCR0+283	; Fill vert 8 tiles with $3A at 66AB
	DEFRTVT 8, $3A, TLSCR0+297	; Fill vert 8 tiles with $3A at 66B9
	DEFRTVT 2, $3A, TLSCR0+466	; Fill vert 2 tiles with $3A at 6762
	DEFRTVT 2, $3A, TLSCR0+469	; Fill vert 2 tiles with $3A at 6765
	DEFRT06 $FF, 11, TLSCR0+0	; Triangle with FF, count=11 at 6590
	DEFRT0C 19, TLSCR0+11		; Fill horz 19 tiles with $FF at 659B
	DEFRTBN	13, 2, 8, TLSCR0+270	; Block 2 tiles from 81E3 to 669E copy 8 times
	DEFRTBN	1, 2, 11, TLSCR0+155	; Block 2 tiles from 7348 to 662B copy 11 times
	DEFRTBK	10, TLSCR0+485		; Block 2x1 tiles from 889D to 6775
L8A00:	DEFRT04 11, $FA, TLSCR0+487	; Fill horz 11 tiles with $FA at 6777
	DEFRT04 4, $FA, TLSCR0+251	; Fill horz 4 tiles with $FA at 668B
	DEFRT04 5, $FA, TLSCR0+436	; Fill horz 5 tiles with $FA at 6744
	DEFRT04 8, $FA, TLSCR0+262	; Fill horz 8 tiles with $FA at 6696
	DEFRTBL	20, 1,4, TLSCR0+352	; Block 1x4 tiles from 8898 to 66F0
	DEFRTBL	20, 1,3, TLSCR0+324	; Block 1x3 tiles from 8898 to 66D4
	DEFRT04 2, $FA, TLSCR0+352	; Fill horz 2 tiles with $FA at 66F0
	DEFRT04 3, $FA, TLSCR0+379	; Fill horz 3 tiles with $FA at 670B
	DEFB	$00	; End of sequence

; Room 8A2D
L8A2D:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L89B9	; Room to Left
	DEFW	L8A81	; Room to Right
	DEFW	L8B25	; Room to Up
	DEFW	L889F	; Room to Down
	DEFRTVT 8, $3A, TLSCR0+274	; Fill vert 8 tiles with $3A at 66A2
	DEFRTVT 8, $3A, TLSCR0+285	; Fill vert 8 tiles with $3A at 66AD
	DEFRTVT 8, $3A, TLSCR0+289	; Fill vert 8 tiles with $3A at 66B1
	DEFRTVT 5, $3A, TLSCR0+372	; Fill vert 5 tiles with $3A at 6704
	DEFRT0C 3, TLSCR0+0		; Fill horz 3 tiles with $FF at 6590
L8A52:	DEFRT04 15, $FA, TLSCR0+240	; Fill horz 15 tiles with $FA at 6680
	DEFRT04 5, $FA, TLSCR0+255	; Fill horz 5 tiles with $FA at 668F
	DEFRTBN	1, 2, 8, TLSCR0+17	; Block 2 tiles from 7348 to 65A1 copy 8 times
	DEFRT04 8, $FA, TLSCR0+453	; Fill horz 8 tiles with $FA at 6755
	DEFRT04 5, $FA, TLSCR0+338	; Fill horz 5 tiles with $FA at 66E2
	DEFRT04 4, $FA, TLSCR0+502	; Fill horz 4 tiles with $FA at 6786
	DEFRTBL	21, 1,3, TLSCR0+339	; Block 1x3 tiles from 8899 to 66E3
	DEFRTBL	20, 1,3, TLSCR0+429	; Block 1x3 tiles from 8898 to 673D
	DEFB	$00	; End of sequence

; Room 8A81
L8A81:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8A2D	; Room to Left
	DEFW	L8AF4	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8834	; Room to Down
	DEFRTVT 6, $3A, TLSCR0+337	; Fill vert 6 tiles with $3A at 66E1
	DEFRTVT 12, $3A, TLSCR0+163	; Fill vert 12 tiles with $3A at 6633
	DEFRTVT 5, $3A, TLSCR0+378	; Fill vert 5 tiles with $3A at 670A
	DEFRT09 $FF, 4, TLSCR0+23	; Triangle with FF, count=4 at 65A7
	DEFRT06 $FF, 4, TLSCR0+24	; Triangle with FF, count=4 at 65A8
	DEFRTBN	1, 2, 14, TLSCR0+113	; Block 2 tiles from 7348 to 6601 copy 14 times
	DEFRTBK	10, TLSCR0+353		; Block 2x1 tiles from 889D to 66F1
	DEFRTBK	10, TLSCR0+443		; Block 2x1 tiles from 889D to 674B
	DEFRT04 5, $FA, TLSCR0+445	; Fill horz 5 tiles with $FA at 674D
	DEFRT04 6, $FA, TLSCR0+347	; Fill horz 6 tiles with $FA at 66EB
	DEFRT04 3, $FA, TLSCR0+305	; Fill horz 3 tiles with $FA at 66C1
	DEFRTVT 4, $28, TLSCR5+392	; Fill vert 4 tiles with $28 at 710E
	DEFRT04 11, $FA, TLSCR0+40	; Fill horz 11 tiles with $FA at 65B8
	DEFRTBL	20, 1,5, TLSCR0+13	; Block 1x5 tiles from 8898 to 659D
	DEFRT04 3, $FA, TLSCR0+367	; Fill horz 3 tiles with $FA at 66FF
	DEFRT04 6, $FA, TLSCR0+399	; Fill horz 6 tiles with $FA at 671F
	DEFRTBL	21, 1,4, TLSCR0+398	; Block 1x4 tiles from 8899 to 671E
	DEFRTBL	20, 1,2, TLSCR0+338	; Block 1x2 tiles from 8898 to 66E2
	DEFB	$00	; End of sequence

; Room 8AF4
L8AF4:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8A81	; Room to Left
	DEFW	L8C5A	; Room to Right
	DEFW	L8BAB	; Room to Up
	DEFW	L890E	; Room to Down
	DEFRTVT 8, $3A, TLSCR0+279	; Fill vert 8 tiles with $3A at 66A7
	DEFRTVT 8, $3A, TLSCR0+287	; Fill vert 8 tiles with $3A at 66AF
	DEFRT04 11, $FA, TLSCR0+420	; Fill horz 11 tiles with $FA at 6734
	DEFRT04 19, $FA, TLSCR0+248	; Fill horz 19 tiles with $FA at 6688
	DEFRTBN	1, 2, 8, TLSCR0+20	; Block 2 tiles from 7348 to 65A4 copy 8 times
	DEFRTVT 6, $F9, TLSCR0+254	; Fill vert 6 tiles with $F9 at 668E
	DEFRT0E $F8, TLSCR0+254	; Put tile F8 at 668E
	DEFB	$00	; End of sequence

; Room 8B25
L8B25:	DEFW	LB483	; Room procedure
	DEFW	LA174	; Initialization
	DEFW	0	; Room to Left
	DEFW	L8B71	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8A2D	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0C 72, TLSCR0+0		; Fill horz 72 tiles with $FF at 6590
	DEFRTBN	1, 2, 14, TLSCR0+77	; Block 2 tiles from 7348 to 65DD copy 14 times
	DEFRTBL	2, 2,1, TLSCR0+497	; Block 2x1 tiles from 7984 to 6781
	DEFRTBK	4, TLSCR5+369		; Block 4x4 tiles from 71A9 to 70F7
	DEFRTBK	4, TLSCR5+367		; Block 4x4 tiles from 71A9 to 70F5
	DEFRTBK	4, TLSCR5+362		; Block 4x4 tiles from 71A9 to 70F0
	DEFRTBK	4, TLSCR5+385		; Block 4x4 tiles from 71A9 to 7107
	DEFRT06 $FF, 11, TLSCR0+90	; Triangle with FF, count=11 at 65EA
	DEFRT0A 3,4, TLSCR0+360	; Rectangle 3x4 tiles with $FF at 66F8
	DEFB	$00	; End of sequence

; Room 8B71
L8B71:	DEFW	L7918	; Room procedure
	DEFW	LA0FC	; Initialization
	DEFW	L8B25	; Room to Left
	DEFW	L8BAB	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0C 60, TLSCR0+0		; Fill horz 60 tiles with $FF at 6590
	DEFRTBK	4, TLSCR5+361		; Block 4x4 tiles from 71A9 to 70EF
	DEFRTBK	4, TLSCR5+367		; Block 4x4 tiles from 71A9 to 70F5
	DEFRTBK	4, TLSCR5+373		; Block 4x4 tiles from 71A9 to 70FB
	DEFRTBK	4, TLSCR5+378		; Block 4x4 tiles from 71A9 to 7100
	DEFRTBK	4, TLSCR5+385		; Block 4x4 tiles from 71A9 to 7107
	DEFB	$00	; End of sequence

; Room 8BAB
L8BAB:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8B71	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8AF4	; Room to Down
	DEFRT0C 60, TLSCR0+0		; Fill horz 60 tiles with $FF at 6590
	DEFRT0A 2,14, TLSCR0+88	; Rectangle 2x14 tiles with $FF at 65E8
	DEFRT0C 9, TLSCR0+480		; Fill horz 9 tiles with $FF at 6770
	DEFRT0C 16, TLSCR0+494		; Fill horz 16 tiles with $FF at 677E
	DEFRTBN	1, 2, 14, TLSCR0+80	; Block 2 tiles from 7348 to 65E0 copy 14 times
	DEFRTBK	10, TLSCR0+500		; Block 2x1 tiles from 889D to 6784
	DEFRTBK	1, TLSCR5+405		; Block 3x3 tiles from 71A0 to 711B
	DEFRTBK	4, TLSCR5+364		; Block 4x4 tiles from 71A9 to 70F2
	DEFRTBK	4, TLSCR5+384		; Block 4x4 tiles from 71A9 to 7106
	DEFB	$00	; End of sequence

; Room 8BF0
L8BF0:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L890E	; Room to Left
	DEFW	L8CC8	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L9005	; Room to Down
	DEFRTVT 16, $3A, TLSCR0+3	; Fill vert 16 tiles with $3A at 6593
	DEFRTVT 8, $3A, TLSCR0+8	; Fill vert 8 tiles with $3A at 6598
	DEFRTVT 8, $3A, TLSCR0+12	; Fill vert 8 tiles with $3A at 659C
	DEFRTVT 8, $3A, TLSCR0+16	; Fill vert 8 tiles with $3A at 65A0
	DEFRTVT 8, $3A, TLSCR0+19	; Fill vert 8 tiles with $3A at 65A3
	DEFRTVT 8, $3A, TLSCR0+23	; Fill vert 8 tiles with $3A at 65A7
	DEFRTVT 8, $3A, TLSCR0+27	; Fill vert 8 tiles with $3A at 65AB
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0A 4,7, TLSCR0+296	; Rectangle 4x7 tiles with $FF at 66B8
	DEFRT0C 23, TLSCR0+247		; Fill horz 23 tiles with $FF at 6687
	DEFRTBN	1, 2, 7, TLSCR0+288	; Block 2 tiles from 7348 to 66B0 copy 7 times
	DEFRTBL	2, 2,1, TLSCR0+498	; Block 2x1 tiles from 7984 to 6782
	DEFRT04 4, $FA, TLSCR0+240	; Fill horz 4 tiles with $FA at 6680
	DEFRT0E $F9, TLSCR0+5	; Put tile F9 at 6595
	DEFRT04 6, $63, TLSCR0+161	; Fill horz 6 tiles with $63 at 6631
	DEFRT0B TLSCR5+279		; Put tile 2A at 709D
	DEFRTVT 6, $2B, TLSCR5+309	; Fill vert 6 tiles with $2B at 70BB
	DEFRT0E $FF, TLSCR0+249		; Put tile $FF at 6689
	DEFB	$00	; End of sequence

; Room 8C5A
L8C5A:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8AF4	; Room to Left
	DEFW	L8D18	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8BF0	; Room to Down
	DEFRTVT 5, $3A, TLSCR0+333	; Fill vert 5 tiles with $3A at 66DD
	DEFRTVT 13, $3A, TLSCR0+98	; Fill vert 13 tiles with $3A at 65F2
	DEFRTVT 15, $3A, TLSCR0+72	; Fill vert 15 tiles with $3A at 65D8
	DEFRTVT 7, $3A, TLSCR0+316	; Fill vert 7 tiles with $3A at 66CC
	DEFRTVT 7, $3A, TLSCR0+319	; Fill vert 7 tiles with $3A at 66CF
	DEFRTVT 13, $3A, TLSCR0+143	; Fill vert 13 tiles with $3A at 661F
	DEFRTVT 13, $3A, TLSCR0+147	; Fill vert 13 tiles with $3A at 6623
	DEFRT09 $FF, 3, TLSCR0+22	; Triangle with FF, count=3 at 65A6
	DEFRT0A 7,4, TLSCR0+23	; Rectangle 7x4 tiles with $FF at 65A7
	DEFRT04 10, $FA, TLSCR0+35	; Fill horz 10 tiles with $FA at 65B3
	DEFRTBL	20, 1,3, TLSCR0+8	; Block 1x3 tiles from 8898 to 6598
	DEFRTVT 3, $F9, TLSCR0+395	; Fill vert 3 tiles with $F9 at 671B
	DEFRT04 7, $FA, TLSCR0+483	; Fill horz 7 tiles with $FA at 6773
	DEFRT0E $F8, TLSCR0+485	; Put tile F8 at 6775
L8CAE:	DEFRT04 10, $FA, TLSCR0+301	; Fill horz 10 tiles with $FA at 66BD
	DEFRT04 4, $FA, TLSCR0+341	; Fill horz 4 tiles with $FA at 66E5
	DEFRT04 4, $FA, TLSCR0+286	; Fill horz 4 tiles with $FA at 66AE
	DEFRT04 3, $FA, TLSCR0+351	; Fill horz 3 tiles with $FA at 66EF
	DEFRT04 5, $FA, TLSCR0+415	; Fill horz 5 tiles with $FA at 672F
	DEFB	$00	; End of sequence

; Room 8CC8
L8CC8:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8BF0	; Room to Left
	DEFW	L8E9C	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRTVT 12, $3A, TLSCR0+6	; Fill vert 12 tiles with $3A at 6596
	DEFRTVT 16, $3A, TLSCR0+14	; Fill vert 16 tiles with $3A at 659E
	DEFRTVT 16, $3A, TLSCR0+19	; Fill vert 16 tiles with $3A at 65A3
	DEFRTVT 16, $3A, TLSCR0+26	; Fill vert 16 tiles with $3A at 65AA
	DEFRT07 $FF, 7, TLSCR0+273	; Triangle with FF, count=7 at 66A1
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT0A 3,8, TLSCR0+240	; Rectangle 3x8 tiles with $FF at 6680
	DEFRT04 6, $63, TLSCR0+101	; Fill horz 6 tiles with $63 at 65F5
	DEFRT04 10, $FA, TLSCR0+258	; Fill horz 10 tiles with $FA at 6692
	DEFRTBK	6, TLSCR5+277		; Block 4x7 tiles from 79AA to 709B
	DEFRTBK	6, TLSCR5+184		; Block 4x7 tiles from 79AA to 703E
	DEFRTBK	6, TLSCR5+122		; Block 4x7 tiles from 79AA to 7000
	DEFB	$00	; End of sequence

; Room 8D18
L8D18:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8C5A	; Room to Left
	DEFW	L8EE1	; Room to Right
	DEFW	L8D5C	; Room to Up
	DEFW	L8CC8	; Room to Down
	DEFRTVT 3, $3A, TLSCR0+426	; Fill vert 3 tiles with $3A at 673A
	DEFRTVT 3, $3A, TLSCR0+434	; Fill vert 3 tiles with $3A at 6742
	DEFRTVT 3, $3A, TLSCR0+446	; Fill vert 3 tiles with $3A at 674E
	DEFRTVT 17, $3A, TLSCR0+19	; Fill vert 17 tiles with $3A at 65A3
	DEFRT0A 10,4, TLSCR0+0	; Rectangle 10x4 tiles with $FF at 6590
	DEFRTBN	1, 2, 13, TLSCR0+10	; Block 2 tiles from 7348 to 659A copy 13 times
L8D45:	DEFRT04 18, $FA, TLSCR0+390	; Fill horz 18 tiles with $FA at 6716
	DEFRT04 6, $FA, TLSCR0+414	; Fill horz 6 tiles with $FA at 672E
	DEFRT04 5, $63, TLSCR0+228	; Fill horz 5 tiles with $63 at 6674
	DEFRTBK	2, TLSCR5+283		; Block 2x4 tiles from 71BB to 70A1
	DEFB	$00	; End of sequence

; Room 8D5C
L8D5C:	DEFW	LB483	; Room procedure
	DEFW	LA1A1	; Initialization
	DEFW	L8DCA	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8D18	; Room to Down
	DEFRT01				; Fill entire screen with $01
	DEFRT0C 62, TLSCR0+0		; Fill horz 62 tiles with $FF at 6590
	DEFRT0A 2,4, TLSCR0+90	; Rectangle 2x4 tiles with $FF at 65EA
	DEFRT0C 4, TLSCR0+210		; Fill horz 4 tiles with $FF at 6662
	DEFRT09 $FF, 7, TLSCR0+84	; Triangle with FF, count=7 at 65E4
	DEFRT0A 5,12, TLSCR0+85	; Rectangle 5x12 tiles with $FF at 65E5
	DEFRT0C 65, TLSCR0+445		; Fill horz 65 tiles with $FF at 674D
	DEFRTBL	2, 2,2, TLSCR0+460	; Block 2x2 tiles from 7984 to 675C
	DEFRTBK	1, TLSCR5+364		; Block 3x3 tiles from 71A0 to 70F2
	DEFRTBK	1, TLSCR5+285		; Block 3x3 tiles from 71A0 to 70A3
	DEFRTBK	1, TLSCR5+289		; Block 3x3 tiles from 71A0 to 70A7
	DEFRTBK	1, TLSCR5+374		; Block 3x3 tiles from 71A0 to 70FC
	DEFRTBK	1, TLSCR5+377		; Block 3x3 tiles from 71A0 to 70FF
	DEFRTBK	1, TLSCR5+381		; Block 3x3 tiles from 71A0 to 7103
L8DBB:	DEFRT0E $FF, TLSCR0+212		; Put tile $FF at 6664
	DEFRT0B TLSCR5+242		; Put tile 2A at 7078
	DEFRTVT 6, $2B, TLSCR5+272	; Fill vert 6 tiles with $2B at 7096
	DEFB	$00	; End of sequence

; Room 8DCA (helicopter)
L8DCA:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L8D5C	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT01				; Fill entire screen with $01
	DEFRT0C 63, TLSCR0+0		; Fill horz 63 tiles with $FF at 6590
	DEFRT0A 2,13, TLSCR0+90	; Rectangle 2x13 tiles with $FF at 65EA
	DEFRT0C 37, TLSCR0+473		; Fill horz 37 tiles with $FF at 6769
	DEFRT04 10, $91, TLSCR0+458	; Fill horz 10 tiles with $91 at 675A
	DEFRT04 23, $01, TLSCR0+3	; Fill horz 23 tiles with $01 at 6593
	DEFRT04 27, $E2, TLSCR0+31	; Fill horz 27 tiles with $E2 at 65AF
	DEFRT0E $FF, TLSCR0+86	; Put tile FF at 65E6
	DEFRT0A 3,6, TLSCR0+87	; Rectangle 3x6 tiles with $FF at 65E7
	DEFRT0B TLSCR5+267		; Put tile 2A at 7091
	DEFRTVT 6, $2B, TLSCR5+297	; Fill vert 6 tiles with $2B at 70AF
	DEFRTBL	22, 4,7, TLSCR5+221	; Block 4x7 tiles from 8E47 to 7063
	DEFRTBL	26, 2,6, TLSCR0+249	; Block 2x6 tiles from 8E6C to 6689
	DEFRTBL	25, 5,1, TLSCR0+430	; Block 5x1 tiles from 8E67 to 673E
	DEFRTBL	23, 1,2, TLSCR0+374	; Block 1x2 tiles from 8E63 to 6706
	DEFRTBL	27, 3,8, TLSCR0+225	; Block 3x8 tiles from 8E78 to 6671
	DEFRT04 17, $D4, TLSCR0+156	; Fill horz 17 tiles with $D4 at 662C
	DEFRTBL	24, 1,2, TLSCR0+164	; Block 1x2 tiles from 8E65 to 6634
	DEFRTBL	28, 3,4, TLSCR0+198	; Block 3x4 tiles from 8E90 to 6656
	DEFRT03 $1B, 4,4, TLSCR0+251	; Rectangle 4x4 tiles with $1B at 668B
	DEFB	$00	; End of sequence

; Room 8E9C
L8E9C:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8CC8	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L8EE1	; Room to Up
	DEFW	L8F20	; Room to Down
	DEFRTVT 16, $3A, TLSCR0+1	; Fill vert 16 tiles with $3A at 6591
	DEFRTVT 16, $3A, TLSCR0+9	; Fill vert 16 tiles with $3A at 6599
	DEFRTVT 16, $3A, TLSCR0+12	; Fill vert 16 tiles with $3A at 659C
	DEFRTVT 6, $3A, TLSCR0+305	; Fill vert 6 tiles with $3A at 66C1
	DEFRTVT 7, $3A, TLSCR0+319	; Fill vert 7 tiles with $3A at 66CF
	DEFRTVT 7, $3A, TLSCR0+323	; Fill vert 7 tiles with $3A at 66D3
	DEFRT0C 14, TLSCR0+480		; Fill horz 14 tiles with $FF at 6770
	DEFRT04 8, $FA, TLSCR0+273	; Fill horz 8 tiles with $FA at 66A1
	DEFRT04 6, $FA, TLSCR0+289	; Fill horz 6 tiles with $FA at 66B1
	DEFRT04 4, $FA, TLSCR0+437	; Fill horz 4 tiles with $FA at 6745
	DEFRT0A 2,17, TLSCR0+28	; Rectangle 2x17 tiles with $FF at 65AC
	DEFB	$00	; End of sequence

; Room 8EE1
L8EE1:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8D18	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L8E9C	; Room to Down
	DEFRTVT 3, $3A, TLSCR0+421	; Fill vert 3 tiles with $3A at 6735
	DEFRTVT 15, $3A, TLSCR0+69	; Fill vert 15 tiles with $3A at 65D5
	DEFRT0E $3A, TLSCR0+492	; Put tile 3A at 677C
	DEFRT0E $FF, TLSCR0+3	; Put tile FF at 6593
	DEFRT0A 26,2, TLSCR0+4	; Rectangle 26x2 tiles with $FF at 6594
	DEFRT0A 2,15, TLSCR0+88	; Rectangle 2x15 tiles with $FF at 65E8
	DEFRT09 $FF, 7, TLSCR0+87	; Triangle with FF, count=7 at 65E7
	DEFRT04 4, $FA, TLSCR0+390	; Fill horz 4 tiles with $FA at 6716
	DEFRT04 7, $FA, TLSCR0+459	; Fill horz 7 tiles with $FA at 675B
	DEFRT04 4, $63, TLSCR0+336	; Fill horz 4 tiles with $63 at 66E0
	DEFB	$00	; End of sequence

; Room 8F20
L8F20:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L8FBD	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L8E9C	; Room to Up
	DEFW	L8F84	; Room to Down
	DEFRT0C 14, TLSCR0+0		; Fill horz 14 tiles with $FF at 6590
L8F31:	DEFRT0E $FF, TLSCR0+6		; Put tile $FF at 6596
	DEFRT0B TLSCR5+36		; Put tile 2A at 6FAA
	DEFRT0B TLSCR5+41		; Put tile 2A at 6FAF
	DEFRTVT 7, $2B, TLSCR5+66	; Fill vert 7 tiles with $2B at 6FC8
	DEFRTVT 7, $2B, TLSCR5+71	; Fill vert 7 tiles with $2B at 6FCD
	DEFRT0A 2,9, TLSCR0+28	; Rectangle 2x9 tiles with $FF at 65AC
	DEFRT0A 30,8, TLSCR0+270	; Rectangle 30x8 tiles with $FF at 669E
	DEFRTBL	2, 2,2, TLSCR0+474	; Block 2x2 tiles from 7984 to 676A
	DEFRT03 $00, 8,6, TLSCR0+290	; Rectangle 8x6 tiles with $00 at 66B2
	DEFRT09 $00, 5, TLSCR0+289	; Triangle with 00, count=5 at 66B1
	DEFRTBK	6, TLSCR5+257		; Block 4x7 tiles from 79AA to 7087
	DEFRTBK	6, TLSCR5+164		; Block 4x7 tiles from 79AA to 702A
	DEFRTVT 14, $3A, TLSCR0+19	; Fill vert 14 tiles with $3A at 65A3
	DEFRTVT 15, $3A, TLSCR0+23	; Fill vert 15 tiles with $3A at 65A7
	DEFRT04 5, $FA, TLSCR0+263	; Fill horz 5 tiles with $FA at 6697
	DEFB	$00	; End of sequence

; Room 8F84
L8F84:	DEFW	L7918	; Room procedure
	DEFW	LA0F7	; Initialization
	DEFW	L9053	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L8F20	; Room to Up
	DEFW	L91BA	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 28,8, TLSCR0+150	; Rectangle 28x8 tiles with $00 at 6626
	DEFRT08 $00, 4, TLSCR0+53	; Triangle with 00, count=4 at 65C5
	DEFRT03 $00, 2,3, TLSCR0+86	; Rectangle 2x3 tiles with $00 at 65E6
	DEFRT0E $00, TLSCR0+56	; Put tile 00 at 65C8
	DEFRTBK	2, TLSCR5+284		; Block 2x4 tiles from 71BB to 70A2
	DEFRTBN	1, 2, 13, TLSCR0+24	; Block 2 tiles from 7348 to 65A8 copy 13 times
	DEFRTBL	2, 2,4, TLSCR0+410	; Block 2x4 tiles from 7984 to 672A
	DEFB	$00	; End of sequence

; Room 8FBD
L8FBD:	DEFW	LB483	; Room procedure
	DEFW	LA16A	; Initialization
	DEFW	L9005	; Room to Left
	DEFW	L8F20	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L9053	; Room to Down
	DEFRT0A 30,8, TLSCR0+270	; Rectangle 30x8 tiles with $FF at 669E
	DEFRT03 $39, 7,7, TLSCR0+309	; Rectangle 7x7 tiles with $39 at 66C5
	DEFRT04 5, $38, TLSCR0+280	; Fill horz 5 tiles with $38 at 66A8
	DEFRT0C 6, TLSCR0+0		; Fill horz 6 tiles with $FF at 6590
	DEFRT0C 4, TLSCR0+26		; Fill horz 4 tiles with $FF at 65AA
	DEFRT0B TLSCR5+31		; Put tile 2A at 6FA5
	DEFRT0B TLSCR5+57		; Put tile 2A at 6FBF
	DEFRTVT 7, $2B, TLSCR5+61	; Fill vert 7 tiles with $2B at 6FC3
	DEFRTVT 7, $2B, TLSCR5+87	; Fill vert 7 tiles with $2B at 6FDD
	DEFRTBK	2, TLSCR5+153		; Block 2x4 tiles from 71BB to 701F
	DEFRTBK	2, TLSCR5+171		; Block 2x4 tiles from 71BB to 7031
	DEFB	$00	; End of sequence

; Room 9005
L9005:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L92A7	; Room to Left
	DEFW	L8FBD	; Room to Right
	DEFW	L8BF0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 30, TLSCR0+0		; Fill horz 30 tiles with $FF at 6590
	DEFRTBK	2, TLSCR5+173		; Block 2x4 tiles from 71BB to 7033
	DEFRTBN	1, 2, 8, TLSCR0+48	; Block 2 tiles from 7348 to 65C0 copy 8 times
	DEFRTBL	2, 2,1, TLSCR0+18	; Block 2x1 tiles from 7984 to 65A2
	DEFRT0B TLSCR5+43		; Put tile 2A at 6FB1
	DEFRTVT 7, $2B, TLSCR5+73	; Fill vert 7 tiles with $2B at 6FCF
	DEFRT0A 19,5, TLSCR0+281	; Rectangle 19x5 tiles with $FF at 66A9
	DEFRT0C 79, TLSCR0+431		; Fill horz 79 tiles with $FF at 673F
	DEFRT08 $FF, 5, TLSCR0+310	; Triangle with FF, count=5 at 66C6
	DEFRTBK	5, TLSCR5+245		; Block 4x7 tiles from 798E to 707B
	DEFRTBK	5, TLSCR5+158		; Block 4x7 tiles from 798E to 7024
	DEFB	$00	; End of sequence

; Room 9053
L9053:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L909F	; Room to Left
	DEFW	L8F84	; Room to Right
	DEFW	L8FBD	; Room to Up
	DEFW	L90DB	; Room to Down
	DEFRT0A 30,9, TLSCR0+0	; Rectangle 30x9 tiles with $FF at 6590
	DEFRT03 $00, 10,4, TLSCR0+170	; Rectangle 10x4 tiles with $00 at 663A
	DEFRT0C 39, TLSCR0+471		; Fill horz 39 tiles with $FF at 6767
	DEFRT0C 4, TLSCR0+416		; Fill horz 4 tiles with $FF at 6730
	DEFRT0C 6, TLSCR0+444		; Fill horz 6 tiles with $FF at 674C
	DEFRTBK	2, TLSCR5+363		; Block 2x4 tiles from 71BB to 70F1
	DEFRTBK	2, TLSCR5+351		; Block 2x4 tiles from 71BB to 70E5
	DEFRT03 $39, 7,8, TLSCR0+9	; Rectangle 7x8 tiles with $39 at 6599
	DEFRT03 $39, 4,7, TLSCR0+279	; Rectangle 4x7 tiles with $39 at 66A7
	DEFRT04 4, $38, TLSCR0+489	; Fill horz 4 tiles with $38 at 6779
	DEFRT04 4, $38, TLSCR0+249	; Fill horz 4 tiles with $38 at 6689
	DEFB	$00	; End of sequence

; Room 909F
L909F:	DEFW	LB47A	; Room procedure
	DEFW	LA15F	; Initialization
	DEFW	L92EF	; Room to Left
	DEFW	L9053	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 30, TLSCR0+0		; Fill horz 30 tiles with $FF at 6590
	DEFRT09 $FF, 8, TLSCR0+59	; Triangle with FF, count=8 at 65CB
	DEFRT0A 5,9, TLSCR0+210	; Rectangle 5x9 tiles with $FF at 6662
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRT07 $FF, 8, TLSCR0+245	; Triangle with FF, count=8 at 6685
	DEFRTBK	6, TLSCR5+280		; Block 4x7 tiles from 79AA to 709E
	DEFRTBK	6, TLSCR5+187		; Block 4x7 tiles from 79AA to 7041
	DEFRTBK	6, TLSCR5+94		; Block 4x7 tiles from 79AA to 6FE4
	DEFB	$00	; End of sequence

; Room 90DB
L90DB:	DEFW	LB452	; Room procedure
	DEFW	LA370	; Initialization
	DEFW	L913F	; Room to Left
	DEFW	L91BA	; Room to Right
	DEFW	L9053	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 22,6, TLSCR0+68	; Rectangle 22x6 tiles with $00 at 65D4
	DEFRT04 12, $00, TLSCR0+48	; Fill horz 12 tiles with $00 at 65C0
	DEFRT06 $00, 7, TLSCR0+258	; Triangle with 00, count=7 at 6692
	DEFRT03 $00, 18,6, TLSCR0+270	; Rectangle 18x6 tiles with $00 at 669E
	DEFRT04 4, $39, TLSCR0+9	; Fill horz 4 tiles with $39 at 6599
	DEFRT04 4, $38, TLSCR0+39	; Fill horz 4 tiles with $38 at 65B7
	DEFRTBK	8, TLSCR5+367		; Block 3x3 tiles from 7C18 to 70F5
	DEFRTBK	8, TLSCR5+371		; Block 3x3 tiles from 7C18 to 70F9
	DEFRT0B TLSCR5+271		; Put tile 2A at 7095
	DEFRTVT 5, $2B, TLSCR5+301	; Fill vert 5 tiles with $2B at 70B3
	DEFRT0B TLSCR5+286		; Put tile 2A at 70A4
	DEFRTVT 5, $2B, TLSCR5+316	; Fill vert 5 tiles with $2B at 70C2
	DEFRTBK	5, TLSCR5+258		; Block 4x7 tiles from 798E to 7088
	DEFRTBK	5, TLSCR5+171		; Block 4x7 tiles from 798E to 7031
	DEFRTBK	5, TLSCR5+142		; Block 4x7 tiles from 798E to 7014
	DEFB	$00	; End of sequence

; Room 913F
L913F:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L90DB	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L83ED	; Room to Down
	DEFRT09 $FF, 9, TLSCR0+29	; Triangle with FF, count=9 at 65AD
	DEFRT0C 39, TLSCR0+471		; Fill horz 39 tiles with $FF at 6767
	DEFRT0C 5, TLSCR0+0		; Fill horz 5 tiles with $FF at 6590
	DEFRT0A 3,3, TLSCR0+30	; Rectangle 3x3 tiles with $FF at 65AE
	DEFRTVT 12, $EB, TLSCR0+121	; Fill vert 12 tiles with $EB at 6609
	DEFRTBL	2, 2,1, TLSCR0+489	; Block 2x1 tiles from 7984 to 6779
	DEFRTBK	1, TLSCR5+392		; Block 3x3 tiles from 71A0 to 710E
	DEFRTBK	8, TLSCR5+395		; Block 3x3 tiles from 7C18 to 7111
	DEFRTBK	9, TLSCR5+456		; Block 2x1 tiles from 7E8A to 714E
	DEFRTBK	7, TLSCR5+376		; Block 3x4 tiles from 7C0C to 70FE
	DEFRTBK	15, TLSCR5+436		; Block 3x1 tiles from 7E87 to 713A
	DEFRTBK	15, TLSCR5+464		; Block 3x1 tiles from 7E87 to 7156
	DEFRTBK	9, TLSCR5+433		; Block 2x1 tiles from 7E8A to 7137
	DEFRTBK	9, TLSCR5+462		; Block 2x1 tiles from 7E8A to 7154
	DEFRTBK	9, TLSCR5+468		; Block 2x1 tiles from 7E8A to 715A
	DEFRTBK	9, TLSCR5+442		; Block 2x1 tiles from 7E8A to 7140
	DEFRTBK	9, TLSCR5+445		; Block 2x1 tiles from 7E8A to 7143
	DEFB	$00	; End of sequence

; Room 91BA
L91BA:	DEFW	LB452	; Room procedure
	DEFW	LA36B	; Initialization
	DEFW	L90DB	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L8F84	; Room to Up
	DEFW	L924E	; Room to Down
	DEFRT0C 4, TLSCR0+0		; Fill horz 4 tiles with $FF at 6590
	DEFRT0B TLSCR5+31		; Put tile 2A at 6FA5
	DEFRTVT 7, $2B, TLSCR5+61	; Fill vert 7 tiles with $2B at 6FC3
	DEFRT0A 4,3, TLSCR0+270	; Rectangle 4x3 tiles with $FF at 669E
	DEFRT0C 152, TLSCR0+358		; Fill horz 152 tiles with $FF at 66F6
	DEFRTBN	13, 2, 11, TLSCR0+28	; Block 2 tiles from 81E3 to 65AC copy 11 times
	DEFRT07 $FF, 2, TLSCR0+304	; Triangle with FF, count=2 at 66C0
	DEFRTBN	1, 2, 12, TLSCR0+20	; Block 2 tiles from 7348 to 65A4 copy 12 times
	DEFRTBL	2, 2,5, TLSCR0+380	; Block 2x5 tiles from 7984 to 670C
	DEFRTBK	8, TLSCR5+277		; Block 3x3 tiles from 7C18 to 709B
	DEFRTBK	0, TLSCR5+281		; Barrel 3x3 tiles at 709F
	DEFRTBK	0, TLSCR5+284		; Barrel 3x3 tiles at 70A2
	DEFRTBK	0, TLSCR5+295		; Barrel 3x3 tiles at 70AD
	DEFB	$00	; End of sequence

; Room 920A
L920A:	DEFW	L7918	; Room procedure
	DEFW	LA0F2	; Initialization
	DEFW	L83ED	; Room to Left
	DEFW	L924E	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTBK	7, TLSCR5+363		; Block 3x4 tiles from 7C0C to 70F1
	DEFRTBK	1, TLSCR5+397		; Block 3x3 tiles from 71A0 to 7113
	DEFRTBK	0, TLSCR5+401		; Barrel 3x3 tiles at 7117
	DEFRTBK	0, TLSCR5+404		; Barrel 3x3 tiles at 711A
	DEFRTBK	0, TLSCR5+312		; Barrel 3x3 tiles at 70BE
	DEFRTBK	0, TLSCR5+315		; Barrel 3x3 tiles at 70C1
	DEFRTBK	0, TLSCR5+416		; Barrel 3x3 tiles at 7126
	DEFRTBK	3, TLSCR5+318		; Block 4x3 tiles from 7E7B to 70C4
	DEFRTBK	3, TLSCR5+405		; Block 4x3 tiles from 7E7B to 711B
	DEFRTBK	3, TLSCR5+410		; Block 4x3 tiles from 7E7B to 7120
	DEFB	$00	; End of sequence

; Room 924E
L924E:	DEFW	LB452	; Room procedure
	DEFW	LA366	; Initialization
	DEFW	L920A	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L91BA	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 16, TLSCR0+14		; Fill horz 16 tiles with $FF at 659E
	DEFRTBN	13, 2, 14, TLSCR0+58	; Block 2 tiles from 81E3 to 65CA copy 14 times
	DEFRT0C 32, TLSCR0+478		; Fill horz 32 tiles with $FF at 676E
	DEFRTBN	1, 2, 15, TLSCR0+50	; Block 2 tiles from 7348 to 65C2 copy 15 times
	DEFRTBL	0, 2,1, TLSCR0+20	; Block 2x1 tiles from 71B9 to 65A4
	DEFRTBK	1, TLSCR5+406		; Block 3x3 tiles from 71A0 to 711C
	DEFRTBK	1, TLSCR5+325		; Block 3x3 tiles from 71A0 to 70CB
	DEFRTBK	3, TLSCR5+414		; Block 4x3 tiles from 7E7B to 7124
	DEFRTBK	0, TLSCR5+215		; Barrel 3x3 tiles at 705D
	DEFRTBK	0, TLSCR5+303		; Barrel 3x3 tiles at 70B5
	DEFRTBK	0, TLSCR5+307		; Barrel 3x3 tiles at 70B9
	DEFRTBK	0, TLSCR5+310		; Barrel 3x3 tiles at 70BC
	DEFRTBK	0, TLSCR5+392		; Barrel 3x3 tiles at 710E
	DEFRTBK	0, TLSCR5+395		; Barrel 3x3 tiles at 7111
	DEFRTBK	0, TLSCR5+398		; Barrel 3x3 tiles at 7114
	DEFRTBK	0, TLSCR5+402		; Barrel 3x3 tiles at 7118
	DEFB	$00	; End of sequence

; Room 92A7
L92A7:	DEFW	LB483	; Room procedure
	DEFW	LA16F	; Initialization
	DEFW	0	; Room to Left
	DEFW	L9005	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 32, TLSCR0+0		; Fill horz 32 tiles with $FF at 6590
	DEFRTBN	13, 2, 13, TLSCR0+60	; Block 2 tiles from 81E3 to 65CC copy 13 times
	DEFRT0C 60, TLSCR0+450		; Fill horz 60 tiles with $FF at 6752
	DEFRTBK	4, TLSCR5+331		; Block 4x4 tiles from 71A9 to 70D1
	DEFRTBK	4, TLSCR5+347		; Block 4x4 tiles from 71A9 to 70E1
	DEFRTBK	2, TLSCR5+336		; Block 2x4 tiles from 71BB to 70D6
	DEFRTBK	2, TLSCR5+338		; Block 2x4 tiles from 71BB to 70D8
	DEFRTBK	2, TLSCR5+341		; Block 2x4 tiles from 71BB to 70DB
	DEFRTBK	2, TLSCR5+344		; Block 2x4 tiles from 71BB to 70DE
	DEFB	$00	; End of sequence

; Room 92EF
L92EF:	DEFW	L7918	; Room procedure
	DEFW	L791B	; Initialization
	DEFW	0	; Room to Left
	DEFW	L909F	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 26,6, TLSCR0+34	; Rectangle 26x6 tiles with $00 at 65B2
	DEFRT03 $02, 22,6, TLSCR0+334	; Rectangle 22x6 tiles with $02 at 66DE
	DEFRT03 $CC, 6,4, TLSCR0+396	; Rectangle 6x4 tiles with $CC at 671C
	DEFRT04 7, $D1, TLSCR0+424	; Fill horz 7 tiles with $D1 at 6738
	DEFRT0E $D0, TLSCR0+429	; Put tile D0 at 673D
	DEFRT04 12, $CD, TLSCR0+402	; Fill horz 12 tiles with $CD at 6722
	DEFRTBK	14, TLSCR0+404		; Block 1x4 tiles from 9372 to 6724
	DEFRTBK	14, TLSCR0+406		; Block 1x4 tiles from 9372 to 6726
	DEFRTBK	14, TLSCR0+408		; Block 1x4 tiles from 9372 to 6728
	DEFRTBK	14, TLSCR0+410		; Block 1x4 tiles from 9372 to 672A
	DEFRTBK	14, TLSCR0+412		; Block 1x4 tiles from 9372 to 672C
	DEFRTBK	14, TLSCR0+414		; Block 1x4 tiles from 9372 to 672E
	DEFRTBK	4, TLSCR5+91		; Block 4x4 tiles from 71A9 to 6FE1
	DEFRTBK	2, TLSCR5+96		; Block 2x4 tiles from 71BB to 6FE6
	DEFRTBK	2, TLSCR5+99		; Block 2x4 tiles from 71BB to 6FE9
	DEFRTBK	2, TLSCR5+102		; Block 2x4 tiles from 71BB to 6FEC
	DEFRTBK	2, TLSCR5+105		; Block 2x4 tiles from 71BB to 6FEF
	DEFRTBK	2, TLSCR5+108		; Block 2x4 tiles from 71BB to 6FF2
	DEFB	$00	; End of sequence

; Room 9376
L9376:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L93DF	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L8384	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 12,6, TLSCR0+240	; Rectangle 12x6 tiles with $02 at 6680
	DEFRT03 $02, 11,6, TLSCR0+256	; Rectangle 11x6 tiles with $02 at 6690
	DEFRT04 12, $03, TLSCR0+210	; Fill horz 12 tiles with $03 at 6662
	DEFRT04 11, $03, TLSCR0+226	; Fill horz 11 tiles with $03 at 6672
	DEFRT03 $0C, 11,2, TLSCR5+376	; Rectangle 11x2 tiles with $0C at 70FE
	DEFRT04 11, $0B, TLSCR5+346	; Fill horz 11 tiles with $0B at 70E0
	DEFRTBN	0, 2, 14, TLSCR0+4	; Block 2 tiles from 71B9 to 6594 copy 14 times
	DEFRTBN	0, 2, 14, TLSCR0+20	; Block 2 tiles from 71B9 to 65A4 copy 14 times
	DEFRTBK	12, TLSCR5+365		; Block 6x2 tiles from 7188 to 70F3
	DEFRTVT 7, $FD, TLSCR0+10	; Fill vert 7 tiles with $FD at 659A
	DEFRTVT 7, $FD, TLSCR0+18	; Fill vert 7 tiles with $FD at 65A2
	DEFRTVT 7, $FD, TLSCR0+25	; Fill vert 7 tiles with $FD at 65A9
	DEFRTBL	3, 1,3, TLSCR0+422	; Block 1x3 tiles from 7B4F to 6736
	DEFRTBL	3, 1,3, TLSCR0+426	; Block 1x3 tiles from 7B4F to 673A
	DEFRTBL	3, 1,3, TLSCR0+430	; Block 1x3 tiles from 7B4F to 673E
	DEFB	$00	; End of sequence

; Room 93DF
L93DF:	DEFW	LB41F	; Room procedure
	DEFW	LC671	; Initialization
	DEFW	L7C9C	; Room to Left
	DEFW	L9376	; Room to Right
	DEFW	L9431	; Room to Up
	DEFW	0	; Room to Down
	DEFRT02				; Fill entire screen with $02
	DEFRT03 $21, 5,2, TLSCR0+390	; Rectangle 5x2 tiles with $21 at 6716
	DEFRT04 4, $03, TLSCR0+236	; Fill horz 4 tiles with $03 at 667C
	DEFRT0C 153, TLSCR0+0		; Fill horz 153 tiles with $FF at 6590
	DEFRT0C 16, TLSCR0+166		; Fill horz 16 tiles with $FF at 6636
	DEFRT0C 4, TLSCR0+206		; Fill horz 4 tiles with $FF at 665E
	DEFRT0C 17, TLSCR0+395		; Fill horz 17 tiles with $FF at 671B
	DEFRT0C 86, TLSCR0+424		; Fill horz 86 tiles with $FF at 6738
	DEFRTBN	0, 2, 13, TLSCR0+6	; Block 2 tiles from 71B9 to 6596 copy 13 times
	DEFRTVT 5, $FD, TLSCR0+14	; Fill vert 5 tiles with $FD at 659E
	DEFRTVT 6, $FD, TLSCR0+23	; Fill vert 6 tiles with $FD at 65A7
	DEFRTBL	3, 1,4, TLSCR0+404	; Block 1x4 tiles from 7B4F to 6724
	DEFRTBL	3, 1,3, TLSCR0+443	; Block 1x3 tiles from 7B4F to 674B
	DEFB	$00	; End of sequence

; Room 9431
L9431:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L9451	; Room to Up
	DEFW	L93DF	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRTBN	0, 2, 17, TLSCR0+6	; Block 2 tiles from 71B9 to 6596 copy 17 times
	DEFRTVT 17, $FD, TLSCR0+14	; Fill vert 17 tiles with $FD at 659E
	DEFRTVT 17, $FD, TLSCR0+23	; Fill vert 17 tiles with $FD at 65A7
	DEFB	$00	; End of sequence

; Room 9451
L9451:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L9431	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRTBL	2, 2,4, TLSCR0+396	; Block 2x4 tiles from 7984 to 671C
	DEFRTVT 17, $FD, TLSCR0+14	; Fill vert 17 tiles with $FD at 659E
	DEFRTVT 17, $FD, TLSCR0+23	; Fill vert 17 tiles with $FD at 65A7
	DEFRT03 $02, 24,6, TLSCR0+213	; Rectangle 24x6 tiles with $02 at 6665
	DEFRT04 24, $03, TLSCR0+183	; Fill horz 24 tiles with $03 at 6647
	DEFB	$00	; End of sequence

; Room 947C
L947C:	DEFW	LB41F	; Room procedure
	DEFW	LC671	; Initialization
	DEFW	L94AB	; Room to Left
	DEFW	L7C9C	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 21,7, TLSCR0+150	; Rectangle 21x7 tiles with $02 at 6626
	DEFRT03 $02, 7,6, TLSCR0+233	; Rectangle 7x6 tiles with $02 at 6679
	DEFRTVT 8, $02, TLSCR0+171	; Fill vert 8 tiles with $02 at 663B
	DEFRTVT 7, $02, TLSCR0+202	; Fill vert 7 tiles with $02 at 665A
	DEFRT04 8, $21, TLSCR0+412	; Fill horz 8 tiles with $21 at 672C
	DEFRT04 7, $21, TLSCR0+443	; Fill horz 7 tiles with $21 at 674B
	DEFB	$00	; End of sequence

; Room 94AB
L94AB:	DEFW	L7918	; Room procedure
	DEFW	LA0DF	; Initialization
	DEFW	L95D6	; Room to Left
	DEFW	L947C	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 30,7, TLSCR0+150	; Rectangle 30x7 tiles with $00 at 6626
	DEFRT03 $02, 2,7, TLSCR0+178	; Rectangle 2x7 tiles with $02 at 6642
	DEFRT0B TLSCR5+177		; Put tile 2A at 7037
	DEFRTVT 6, $2B, TLSCR5+207	; Fill vert 6 tiles with $2B at 7055
	DEFB	$00	; End of sequence

; Room 94CF
L94CF:	DEFW	L7918	; Room procedure
	DEFW	LA11A	; Initialization
	DEFW	L9552	; Room to Left
	DEFW	L9A9A	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 60, TLSCR0+450		; Fill horz 60 tiles with $FF at 6752
	DEFRT03 $0D, 18,7, TLSCR0+240	; Rectangle 18x7 tiles with $0D at 6680
	DEFRT03 $A3, 27,2, TLSCR0+0	; Rectangle 27x2 tiles with $A3 at 6590
	DEFRT0E $9C, TLSCR0+27	; Put tile 9C at 65AB
	DEFRT0E $9B, TLSCR0+57	; Put tile 9B at 65C9
	DEFRT03 $BF, 18,6, TLSCR0+60	; Rectangle 18x6 tiles with $BF at 65CC
	DEFRTBK	2, TLSCR5+354		; Block 2x4 tiles from 71BB to 70E8
	DEFRT04 18, $BA, TLSCR0+60	; Fill horz 18 tiles with $BA at 65CC
	DEFRT04 18, $B3, TLSCR0+210	; Fill horz 18 tiles with $B3 at 6662
	DEFRTBL	29, 1,6, TLSCR0+61	; Block 1x6 tiles from 9528 to 65CD
	DEFRTBL	30, 1,6, TLSCR0+68	; Block 1x6 tiles from 952E to 65D4
	DEFRTBL	31, 2,6, TLSCR0+74	; Block 2x6 tiles from 9534 to 65DA
	DEFRTBL	32, 3,6, TLSCR0+78	; Block 3x6 tiles from 9540 to 65DE
	DEFB	$00	; End of sequence

; Room 9552
L9552:	DEFW	LB483	; Room procedure
	DEFW	LA197	; Initialization
	DEFW	L9A5A	; Room to Left
	DEFW	L94CF	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 60, TLSCR0+450		; Fill horz 60 tiles with $FF at 6752
	DEFRT03 $0D, 18,7, TLSCR0+252	; Rectangle 18x7 tiles with $0D at 668C
	DEFRT03 $A3, 27,2, TLSCR0+3	; Rectangle 27x2 tiles with $A3 at 6593
	DEFRT0E $9E, TLSCR0+2	; Put tile 9E at 6592
	DEFRT0E $9D, TLSCR0+32	; Put tile 9D at 65B0
	DEFRT03 $BF, 18,6, TLSCR0+72	; Rectangle 18x6 tiles with $BF at 65D8
	DEFRTBK	2, TLSCR5+343		; Block 2x4 tiles from 71BB to 70DD
	DEFRTBK	2, TLSCR5+349		; Block 2x4 tiles from 71BB to 70E3
	DEFRT04 18, $BA, TLSCR0+72	; Fill horz 18 tiles with $BA at 65D8
	DEFRT04 18, $B3, TLSCR0+222	; Fill horz 18 tiles with $B3 at 666E
	DEFRTBL	29, 1,6, TLSCR0+88	; Block 1x6 tiles from 9528 to 65E8
	DEFRTBL	33, 1,6, TLSCR0+81	; Block 1x6 tiles from 95B2 to 65E1
	DEFRTBL	34, 2,6, TLSCR0+74	; Block 2x6 tiles from 95B8 to 65DA
	DEFRTBL	35, 3,6, TLSCR0+69	; Block 3x6 tiles from 95C4 to 65D5
	DEFB	$00	; End of sequence

; Room 95D6
L95D6:	DEFW	LB483	; Room procedure
	DEFW	LA183	; Initialization
	DEFW	L95F8	; Room to Left
	DEFW	L94AB	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 150, TLSCR0+0		; Fill horz 150 tiles with $FF at 6590
	DEFRT0A 16,5, TLSCR0+374	; Rectangle 16x5 tiles with $FF at 6706
	DEFRT04 7, $00, TLSCR0+374	; Fill horz 7 tiles with $00 at 6706
	DEFRT04 16, $FA, TLSCR0+390	; Fill horz 16 tiles with $FA at 6716
	DEFB	$00	; End of sequence

; Room 95F8
L95F8:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L95D6	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L9634	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 23,8, TLSCR0+157	; Rectangle 23x8 tiles with $00 at 662D
	DEFRT06 $FF, 3, TLSCR0+157	; Triangle with FF, count=3 at 662D
	DEFRT04 12, $FA, TLSCR0+408	; Fill horz 12 tiles with $FA at 6728
	DEFRT04 10, $00, TLSCR0+440	; Fill horz 10 tiles with $00 at 6748
	DEFRT04 22, $00, TLSCR0+458	; Fill horz 22 tiles with $00 at 675A
	DEFRT04 24, $00, TLSCR0+486	; Fill horz 24 tiles with $00 at 6776
	DEFRTBN	1, 2, 12, TLSCR0+164	; Block 2 tiles from 7348 to 6634 copy 12 times
	DEFRTBK	10, TLSCR0+404		; Block 2x1 tiles from 889D to 6724
	DEFB	$00	; End of sequence

; Room 9634
L9634:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L968A	; Room to Right
	DEFW	L95F8	; Room to Up
	DEFW	L990D	; Room to Down
	DEFRT0A 4,13, TLSCR0+0	; Rectangle 4x13 tiles with $FF at 6590
	DEFRT0A 24,4, TLSCR0+396	; Rectangle 24x4 tiles with $FF at 671C
	DEFRT07 $FF, 5, TLSCR0+244	; Triangle with FF, count=5 at 6684
	DEFRT0E $00, TLSCR0+244	; Put tile 00 at 6684
	DEFRT09 $FF, 3, TLSCR0+395	; Triangle with FF, count=3 at 671B
	DEFRTBL	36, 2,2, TLSCR0+450	; Block 2x2 tiles from 9686 to 6752
	DEFRTBN	1, 2, 13, TLSCR0+14	; Block 2 tiles from 7348 to 659E copy 13 times
	DEFRT04 12, $00, TLSCR0+408	; Fill horz 12 tiles with $00 at 6728
	DEFRT04 12, $00, TLSCR0+466	; Fill horz 12 tiles with $00 at 6762
	DEFRT04 16, $00, TLSCR0+492	; Fill horz 16 tiles with $00 at 677C
	DEFRTBN	1, 2, 2, TLSCR0+475	; Block 2 tiles from 7348 to 676B copy 2 times
	DEFRTBK	10, TLSCR0+445		; Block 2x1 tiles from 889D to 674D
	DEFB	$00	; End of sequence

; Room 968A
L968A:	DEFW	LB483	; Room procedure
	DEFW	LA188	; Initialization
	DEFW	L9634	; Room to Left
	DEFW	L96CC	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L9715	; Room to Down
	DEFRT0A 16,5, TLSCR0+14	; Rectangle 16x5 tiles with $FF at 659E
	DEFRTVT 12, $3A, TLSCR0+176	; Fill vert 12 tiles with $3A at 6640
	DEFRT0A 11,2, TLSCR0+450	; Rectangle 11x2 tiles with $FF at 6752
	DEFRT0C 16, TLSCR0+420		; Fill horz 16 tiles with $FF at 6734
	DEFRT04 9, $FA, TLSCR0+436	; Fill horz 9 tiles with $FA at 6744
	DEFRT04 6, $FA, TLSCR0+474	; Fill horz 6 tiles with $FA at 676A
	DEFRTBK	2, TLSCR5+304		; Block 2x4 tiles from 71BB to 70B6
	DEFRTBN	1, 2, 2, TLSCR0+462	; Block 2 tiles from 7348 to 675E copy 2 times
	DEFRTBK	10, TLSCR0+432		; Block 2x1 tiles from 889D to 6740
	DEFB	$00	; End of sequence

; Room 96CC
L96CC:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L968A	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L96F3	; Room to Down
	DEFRT0C 150, TLSCR0+0		; Fill horz 150 tiles with $FF at 6590
	DEFRT0A 15,12, TLSCR0+165	; Rectangle 15x12 tiles with $FF at 6635
	DEFRT09 $FF, 9, TLSCR0+164	; Triangle with FF, count=9 at 6634
	DEFRTVT 12, $3A, TLSCR0+151	; Fill vert 12 tiles with $3A at 6627
	DEFRT04 4, $FA, TLSCR0+450	; Fill horz 4 tiles with $FA at 6752
	DEFB	$00	; End of sequence

; Room 96F3
L96F3:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L9715	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L976E	; Room to Down
	DEFRT0A 15,17, TLSCR0+15	; Rectangle 15x17 tiles with $FF at 659F
	DEFRTVT 17, $3A, TLSCR0+1	; Fill vert 17 tiles with $3A at 6591
	DEFRTVT 10, $3A, TLSCR0+216	; Fill vert 10 tiles with $3A at 6668
	DEFRT04 9, $FA, TLSCR0+240	; Fill horz 9 tiles with $FA at 6680
	DEFB	$00	; End of sequence

; Room 9715
L9715:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L96F3	; Room to Right
	DEFW	L968A	; Room to Up
	DEFW	L9739	; Room to Down
	DEFRT0A 11,17, TLSCR0+0	; Rectangle 11x17 tiles with $FF at 6590
	DEFRTBN	1, 2, 17, TLSCR0+12	; Block 2 tiles from 7348 to 659C copy 17 times
	DEFRTVT 17, $3A, TLSCR0+26	; Fill vert 17 tiles with $3A at 65AA
	DEFRT04 8, $FA, TLSCR0+262	; Fill horz 8 tiles with $FA at 6696
	DEFB	$00	; End of sequence

; Room 9739
L9739:	DEFW	LB452	; Room procedure
	DEFW	LA384	; Initialization
	DEFW	L99A6	; Room to Left
	DEFW	L976E	; Room to Right
	DEFW	L9715	; Room to Up
	DEFW	L97A6	; Room to Down
	DEFRT0A 11,10, TLSCR0+0	; Rectangle 11x10 tiles with $FF at 6590
	DEFRT08 $00, 6, TLSCR0+130	; Triangle with 00, count=6 at 6612
	DEFRT0C 34, TLSCR0+476		; Fill horz 34 tiles with $FF at 676C
L9755:	DEFRT0E $E4, TLSCR0+272		; Put tile $E4 at 66A0
	DEFRTVT 15, $3A, TLSCR0+26	; Fill vert 15 tiles with $3A at 65AA
	DEFRTBK	10, TLSCR0+486		; Block 2x1 tiles from 889D to 6776
	DEFRTBN	1, 2, 16, TLSCR0+12	; Block 2 tiles from 7348 to 659C copy 16 times
	DEFB	$00	; End of sequence

; Room 976E
L976E:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L9739	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 15,8, TLSCR0+0	; Rectangle 15x8 tiles with $00 at 6590
	DEFRT03 $00, 7,7, TLSCR0+240	; Rectangle 7x7 tiles with $00 at 6680
	DEFRT04 6, $00, TLSCR0+247	; Fill horz 6 tiles with $00 at 6687
	DEFRT04 4, $00, TLSCR0+277	; Fill horz 4 tiles with $00 at 66A5
	DEFRT04 2, $00, TLSCR0+307	; Fill horz 2 tiles with $00 at 66C3
	DEFRTVT 15, $3A, TLSCR0+1	; Fill vert 15 tiles with $3A at 6591
	DEFRTVT 15, $3A, TLSCR0+6	; Fill vert 15 tiles with $3A at 6596
	DEFRT0E $FA, TLSCR0+336	; Put tile FA at 66E0
	DEFB	$00	; End of sequence

; Room 97A6
L97A6:	DEFW	LB483	; Room procedure
	DEFW	LB368	; Initialization
	DEFW	L9876	; Room to Left
	DEFW	L97F8	; Room to Right
	DEFW	L9739	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0A 9,7, TLSCR0+240	; Rectangle 9x7 tiles with $FF at 6680
	DEFRT0C 60, TLSCR0+450		; Fill horz 60 tiles with $FF at 6752
	DEFRT07 $FF, 6, TLSCR0+279	; Triangle with FF, count=6 at 66A7
	DEFRTBN	1, 2, 8, TLSCR0+6	; Block 2 tiles from 7348 to 6596 copy 8 times
	DEFRT0A 4,8, TLSCR0+26	; Rectangle 4x8 tiles with $FF at 65AA
L97CF:	DEFRT0E $00, TLSCR0+417	; Put tile 00 at 6731
	DEFRT0B TLSCR5+267		; Put tile 2A at 7091
	DEFRTVT 6, $2B, TLSCR5+297	; Fill vert 6 tiles with $2B at 70AF
	DEFRTBK	6, TLSCR5+252		; Block 4x7 tiles from 79AA to 7082
	DEFRTBK	6, TLSCR5+159		; Block 4x7 tiles from 79AA to 7025
	DEFRTBK	6, TLSCR5+128		; Block 4x7 tiles from 79AA to 7006
	DEFRT03 $02, 2,7, TLSCR0+268	; Rectangle 2x7 tiles with $02 at 669C
	DEFB	$00	; End of sequence

; Room 97F8
L97F8:	DEFW	L7918	; Room procedure
	DEFW	LA115	; Initialization
	DEFW	L97A6	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L982B	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 28,7, TLSCR0+240	; Rectangle 28x7 tiles with $02 at 6680
	DEFRT03 $02, 16,4, TLSCR0+126	; Rectangle 16x4 tiles with $02 at 660E
	DEFRT08 $02, 3, TLSCR0+155	; Triangle with 02, count=3 at 662B
	DEFRT07 $02, 3, TLSCR0+172	; Triangle with 02, count=3 at 663C
	DEFRTBN	0, 2, 9, TLSCR0+265	; Block 2 tiles from 71B9 to 6699 copy 9 times
	DEFRTBL	2, 2,1, TLSCR0+475	; Block 2x1 tiles from 7984 to 676B
	DEFB	$00	; End of sequence

; Room 982B
L982B:	DEFW	LB41F	; Room procedure
	DEFW	LC681	; Initialization
	DEFW	L7C9C	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L97F8	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 19,6, TLSCR0+39	; Rectangle 19x6 tiles with $02 at 65B7
	DEFRT03 $02, 19,6, TLSCR0+210	; Rectangle 19x6 tiles with $02 at 6662
	DEFRT08 $02, 5, TLSCR0+68	; Triangle with 02, count=5 at 65D4
	DEFRT06 $02, 5, TLSCR0+229	; Triangle with 02, count=5 at 6675
	DEFRT04 18, $21, TLSCR0+390	; Fill horz 18 tiles with $21 at 6716
	DEFRT04 17, $21, TLSCR0+420	; Fill horz 17 tiles with $21 at 6734
	DEFRTBN	0, 2, 7, TLSCR0+25	; Block 2 tiles from 71B9 to 65A9 copy 7 times
	DEFRTBK	5, TLSCR5+256		; Block 4x7 tiles from 798E to 7086
	DEFRTBK	5, TLSCR5+169		; Block 4x7 tiles from 798E to 702F
	DEFRTBK	5, TLSCR5+111		; Block 4x7 tiles from 798E to 6FF5
	DEFB	$00	; End of sequence

; Room 9876
L9876:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L98C0	; Room to Left
	DEFW	L97A6	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 10,7, TLSCR0+240	; Rectangle 10x7 tiles with $00 at 6680
	DEFRT03 $00, 14,7, TLSCR0+158	; Rectangle 14x7 tiles with $00 at 662E
	DEFRT03 $00, 10,7, TLSCR0+50	; Rectangle 10x7 tiles with $00 at 65C2
	DEFRT08 $00, 2, TLSCR0+187	; Triangle with 00, count=2 at 664B
	DEFRT08 $00, 3, TLSCR0+79	; Triangle with 00, count=3 at 65DF
	DEFRT06 $00, 2, TLSCR0+370	; Triangle with 00, count=2 at 6702
	DEFRT06 $00, 3, TLSCR0+262	; Triangle with 00, count=3 at 6696
	DEFRTBK	5, TLSCR5+249		; Block 4x7 tiles from 798E to 707F
	DEFRTBK	5, TLSCR5+171		; Block 4x7 tiles from 798E to 7031
	DEFRTBK	5, TLSCR5+142		; Block 4x7 tiles from 798E to 7014
	DEFB	$00	; End of sequence

; Room 98C0 (thick door)
L98C0:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L9A9A	; Room to Left
	DEFW	L9876	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 240, TLSCR0+0		; Fill horz 240 tiles with $FF at 6590
	DEFRT0C 60, TLSCR0+450		; Fill horz 60 tiles with $FF at 6752
	DEFRTBK	3, TLSCR5+361		; Block 4x3 tiles from 7E7B to 70EF
	DEFRTBK	1, TLSCR5+274		; Block 3x3 tiles from 71A0 to 7098
	DEFRTBK	1, TLSCR5+366		; Block 3x3 tiles from 71A0 to 70F4
	DEFRTBL	38, 1,5, TLSCR0+283	; Block 1x5 tiles from 9903 to 66AB
	DEFRTBL	39, 1,5, TLSCR0+286	; Block 1x5 tiles from 9908 to 66AE
	DEFRTBN	37, 2, 7, TLSCR0+254	; Block 2 tiles from 9901 to 668E copy 7 times
	DEFB	$00	; End of sequence

; Room 990D
L990D:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L9634	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0A 20,17, TLSCR0+10	; Rectangle 20x17 tiles with $FF at 659A
	DEFRT03 $00, 17,12, TLSCR0+11	; Rectangle 17x12 tiles with $00 at 659B
	DEFRT03 $00, 8,4, TLSCR0+380	; Rectangle 8x4 tiles with $00 at 670C
	DEFRT09 $00, 3, TLSCR0+379	; Triangle with 00, count=3 at 670B
	DEFRTBN	1, 2, 16, TLSCR0+25	; Block 2 tiles from 7348 to 65A9 copy 16 times
	DEFRTBK	6, TLSCR5+287		; Block 4x7 tiles from 79AA to 70A5
	DEFRTBK	6, TLSCR5+256		; Block 4x7 tiles from 79AA to 7086
	DEFRT03 $0D, 2,17, TLSCR0+4	; Rectangle 2x17 tiles with $0D at 6594
	DEFRTVT 7, $2B, TLSCR5+160	; Fill vert 7 tiles with $2B at 7026
	DEFRTBK	16, TLSCR0+34		; Block 3x1 tiles from 9997 to 65B2
	DEFRTBK	16, TLSCR0+154		; Block 3x1 tiles from 9997 to 662A
	DEFRTBK	16, TLSCR0+304		; Block 3x1 tiles from 9997 to 66C0
	DEFRTBK	16, TLSCR0+424		; Block 3x1 tiles from 9997 to 6738
	DEFRTBL	40, 4,3, TLSCR0+60	; Block 4x3 tiles from 999A to 65CC
	DEFRTBL	40, 4,3, TLSCR0+150	; Block 4x3 tiles from 999A to 6626
	DEFRTBL	40, 4,3, TLSCR0+240	; Block 4x3 tiles from 999A to 6680
	DEFRTBL	40, 4,3, TLSCR0+330	; Block 4x3 tiles from 999A to 66DA
	DEFRTBL	40, 4,3, TLSCR0+420	; Block 4x3 tiles from 999A to 6734
	DEFRTBL	41, 4,2, TLSCR0+0	; Block 4x2 tiles from 999E to 6590
	DEFB	$00	; End of sequence

; Room 99A6
L99A6:	DEFW	L7918	; Room procedure
	DEFW	LA110	; Initialization
	DEFW	0	; Room to Left
	DEFW	L9739	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 30, TLSCR0+480		; Fill horz 30 tiles with $FF at 6770
	DEFRTVT 14, $FF, TLSCR0+70	; Fill vert 14 tiles with $FF at 65D6
	DEFRTVT 7, $2B, TLSCR5+280	; Fill vert 7 tiles with $2B at 709E
	DEFRT0A 20,2, TLSCR0+10	; Rectangle 20x2 tiles with $FF at 659A
	DEFRT0A 3,8, TLSCR0+87	; Rectangle 3x8 tiles with $FF at 65E7
	DEFRT0E $00, TLSCR0+297	; Put tile 00 at 66B9
	DEFRTBK	2, TLSCR5+379		; Block 2x4 tiles from 71BB to 7101
	DEFRT03 $0D, 2,16, TLSCR0+4	; Rectangle 2x16 tiles with $0D at 6594
	DEFRTBL	40, 4,3, TLSCR0+60	; Block 4x3 tiles from 999A to 65CC
	DEFRTBL	40, 4,3, TLSCR0+150	; Block 4x3 tiles from 999A to 6626
	DEFRTBL	40, 4,3, TLSCR0+240	; Block 4x3 tiles from 999A to 6680
	DEFRTBL	40, 4,3, TLSCR0+330	; Block 4x3 tiles from 999A to 66DA
	DEFRTBL	40, 4,2, TLSCR0+420	; Block 4x2 tiles from 999A to 6734
	DEFRTBK	16, TLSCR0+94		; Block 3x1 tiles from 9997 to 65EE
	DEFRTBK	16, TLSCR0+184		; Block 3x1 tiles from 9997 to 6648
	DEFRTBK	16, TLSCR0+304		; Block 3x1 tiles from 9997 to 66C0
	DEFRTBL	41, 4,2, TLSCR0+0	; Block 4x2 tiles from 999E to 6590
	DEFB	$00	; End of sequence

; Room 9A1E
L9A1E:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L7C9C	; Room to Right
	DEFW	L9A5A	; Room to Up
	DEFW	0	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 6,8, TLSCR0+2	; Rectangle 6x8 tiles with $02 at 6592
	DEFRT03 $02, 8,6, TLSCR0+68	; Rectangle 8x6 tiles with $02 at 65D4
	DEFRT09 $02, 6, TLSCR0+255	; Triangle with 02, count=6 at 668F
	DEFRT03 $02, 14,6, TLSCR0+226	; Rectangle 14x6 tiles with $02 at 6672
	DEFRT07 $02, 4, TLSCR0+106	; Triangle with 02, count=4 at 65FA
	DEFRTBN	0, 2, 8, TLSCR0+4	; Block 2 tiles from 71B9 to 6594 copy 8 times
	DEFRT04 15, $21, TLSCR0+405	; Fill horz 15 tiles with $21 at 6725
	DEFRT04 14, $21, TLSCR0+436	; Fill horz 14 tiles with $21 at 6744
	DEFB	$00	; End of sequence

; Room 9A5A
L9A5A:	DEFW	LB452	; Room procedure
	DEFW	LA389	; Initialization
	DEFW	0	; Room to Left
	DEFW	L9552	; Room to Right
	DEFW	L9B51	; Room to Up
	DEFW	L9A1E	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 28,11, TLSCR0+2	; Rectangle 28x11 tiles with $00 at 6592
	DEFRT03 $00, 7,4, TLSCR0+353	; Rectangle 7x4 tiles with $00 at 66F1
	DEFRT09 $00, 3, TLSCR0+352	; Triangle with 00, count=3 at 66F0
	DEFRT03 $02, 6,2, TLSCR0+452	; Rectangle 6x2 tiles with $02 at 6754
	DEFRT04 4, $02, TLSCR0+423	; Fill horz 4 tiles with $02 at 6737
	DEFRTBN	0, 2, 5, TLSCR0+364	; Block 2 tiles from 71B9 to 66FC copy 5 times
	DEFRTBL	2, 2,1, TLSCR0+334	; Block 2x1 tiles from 7984 to 66DE
	DEFRTBN	1, 2, 11, TLSCR0+9	; Block 2 tiles from 7348 to 6599 copy 11 times
	DEFB	$00	; End of sequence

; Room 9A9A
L9A9A:	DEFW	LB483	; Room procedure
	DEFW	LA192	; Initialization
	DEFW	L94CF	; Room to Left
	DEFW	L98C0	; Room to Right
	DEFW	L9ADC	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 10, TLSCR0+1		; Fill horz 10 tiles with $FF at 6591
	DEFRT0C 60, TLSCR0+450		; Fill horz 60 tiles with $FF at 6752
	DEFRT0A 4,8, TLSCR0+26	; Rectangle 4x8 tiles with $FF at 65AA
	DEFRT0B TLSCR5+266		; Put tile 2A at 7090
	DEFRTVT 6, $2B, TLSCR5+296	; Fill vert 6 tiles with $2B at 70AE
	DEFRTBN	1, 2, 15, TLSCR0+21	; Block 2 tiles from 7348 to 65A5 copy 15 times
	DEFRTBK	4, TLSCR5+334		; Block 4x4 tiles from 71A9 to 70D4
	DEFRTBK	4, TLSCR5+341		; Block 4x4 tiles from 71A9 to 70DB
	DEFRTBK	4, TLSCR5+346		; Block 4x4 tiles from 71A9 to 70E0
	DEFB	$00	; End of sequence

; Room 9ADC
L9ADC:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L9B19	; Room to Up
	DEFW	L9A9A	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 24,8, TLSCR0+2	; Rectangle 24x8 tiles with $00 at 6592
	DEFRT03 $00, 15,7, TLSCR0+251	; Rectangle 15x7 tiles with $00 at 668B
	DEFRT09 $00, 6, TLSCR0+250	; Triangle with 00, count=6 at 668A
	DEFRTBN	1, 2, 17, TLSCR0+21	; Block 2 tiles from 7348 to 65A5 copy 17 times
	DEFRTVT 15, $3A, TLSCR0+16	; Fill vert 15 tiles with $3A at 65A0
	DEFRT0C 13, TLSCR0+224		; Fill horz 13 tiles with $FF at 6670
	DEFRT04 13, $27, TLSCR5+224	; Fill horz 13 tiles with $27 at 7066
	DEFRTBK	10, TLSCR0+471		; Block 2x1 tiles from 889D to 6767
	DEFB	$00	; End of sequence

; Room 9B19
L9B19:	DEFW	L7918	; Room procedure
	DEFW	LA133	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L9BE7	; Room to Up
	DEFW	L9ADC	; Room to Down
	DEFRT0A 2,17, TLSCR0+0	; Rectangle 2x17 tiles with $FF at 6590
	DEFRT0A 4,17, TLSCR0+26	; Rectangle 4x17 tiles with $FF at 65AA
	DEFRTBN	1, 2, 17, TLSCR0+21	; Block 2 tiles from 7348 to 65A5 copy 17 times
	DEFRTVT 17, $3A, TLSCR0+16	; Fill vert 17 tiles with $3A at 65A0
	DEFRT04 26, $FA, TLSCR0+361	; Fill horz 26 tiles with $FA at 66F9
	DEFRTBK	1, TLSCR5+272		; Block 3x3 tiles from 71A0 to 7096
	DEFRTBK	10, TLSCR0+381		; Block 2x1 tiles from 889D to 670D
	DEFB	$00	; End of sequence

; Room 9B51
L9B51:	DEFW	L7918	; Room procedure
	DEFW	LA11F	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L9B9D	; Room to Up
	DEFW	L9A5A	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 26,14, TLSCR0+2	; Rectangle 26x14 tiles with $00 at 6592
	DEFRTVT 7, $00, TLSCR0+239	; Fill vert 7 tiles with $00 at 667F
	DEFRTVT 7, $2B, TLSCR5+238	; Fill vert 7 tiles with $2B at 7074
	DEFRTBN	1, 2, 2, TLSCR0+459	; Block 2 tiles from 7348 to 675B copy 2 times
	DEFRTBN	1, 2, 14, TLSCR0+21	; Block 2 tiles from 7348 to 65A5 copy 14 times
	DEFRTBK	10, TLSCR0+429		; Block 2x1 tiles from 889D to 673D
	DEFRTBK	0, TLSCR5+335		; Barrel 3x3 tiles at 70D5
	DEFRTBL	19, 4,4, TLSCR5+302	; Block 4x4 tiles from 8789 to 70B4
	DEFRTBL	19, 4,4, TLSCR5+314	; Block 4x4 tiles from 8789 to 70C0
	DEFRTBK	1, TLSCR5+355		; Block 3x3 tiles from 71A0 to 70E9
	DEFB	$00	; End of sequence

; Room 9B9D
L9B9D:	DEFW	LB458	; Room procedure
	DEFW	LA1D6	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L9F3A	; Room to Up
	DEFW	L9B51	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 26,7, TLSCR0+272	; Rectangle 26x7 tiles with $00 at 66A0
	DEFRT03 $00, 24,8, TLSCR0+4	; Rectangle 24x8 tiles with $00 at 6594
	DEFRTBK	10, TLSCR0+501		; Block 2x1 tiles from 889D to 6785
	DEFRTBK	10, TLSCR0+250		; Block 2x1 tiles from 889D to 668A
	DEFRTBN	1, 2, 7, TLSCR0+280	; Block 2 tiles from 7348 to 66A8 copy 7 times
	DEFRTBN	1, 2, 8, TLSCR0+22	; Block 2 tiles from 7348 to 65A6 copy 8 times
	DEFRTBK	1, TLSCR5+414		; Block 3x3 tiles from 71A0 to 7124
	DEFRTBK	0, TLSCR5+303		; Barrel 3x3 tiles at 70B5
	DEFRTBK	0, TLSCR5+393		; Barrel 3x3 tiles at 710F
	DEFRTBK	0, TLSCR5+396		; Barrel 3x3 tiles at 7112
	DEFRTBK	0, TLSCR5+403		; Barrel 3x3 tiles at 7119
	DEFB	$00	; End of sequence

; Room 9BE7
L9BE7:	DEFW	LB483	; Room procedure
	DEFW	LA19C	; Initialization
	DEFW	0	; Room to Left
	DEFW	L9DF5	; Room to Right
	DEFW	L9E73	; Room to Up
	DEFW	L9B19	; Room to Down
	DEFRT0A 2,12, TLSCR0+150	; Rectangle 2x12 tiles with $FF at 6626
	DEFRT0A 9,5, TLSCR0+6	; Rectangle 9x5 tiles with $FF at 6596
	DEFRT08 $FF, 5, TLSCR0+5	; Triangle with FF, count=5 at 6595
	DEFRT06 $FF, 9, TLSCR0+152	; Triangle with FF, count=9 at 6628
	DEFRT0C 4, TLSCR0+26		; Fill horz 4 tiles with $FF at 65AA
	DEFRT0A 4,4, TLSCR0+416	; Rectangle 4x4 tiles with $FF at 6730
	DEFRTVT 17, $3A, TLSCR0+16	; Fill vert 17 tiles with $3A at 65A0
	DEFRTBN	1, 2, 13, TLSCR0+18	; Block 2 tiles from 7348 to 65A2 copy 13 times
	DEFRTBN	1, 2, 3, TLSCR0+441	; Block 2 tiles from 7348 to 6749 copy 3 times
	DEFRT04 26, $FA, TLSCR0+391	; Fill horz 26 tiles with $FA at 6717
	DEFRTBK	10, TLSCR0+411		; Block 2x1 tiles from 889D to 672B
	DEFRTVT 4, $F9, TLSCR0+277	; Fill vert 4 tiles with $F9 at 66A5
	DEFB	$00	; End of sequence

; Room 9DF5
L9DF5:	DEFW	L7918	; Room procedure
	DEFW	LA138	; Initialization
	DEFW	L9BE7	; Room to Left
	DEFW	0	; Room to Right
	DEFW	L9E22	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 7, TLSCR0+0		; Fill horz 7 tiles with $FF at 6590
	DEFRT0A 2,12, TLSCR0+28	; Rectangle 2x12 tiles with $FF at 65AC
	DEFRT0C 122, TLSCR0+388		; Fill horz 122 tiles with $FF at 6714
	DEFRTBN	1, 2, 13, TLSCR0+20	; Block 2 tiles from 7348 to 65A4 copy 13 times
	DEFRT0B TLSCR5+33		; Put tile 2A at 6FA7
	DEFRTVT 11, $2B, TLSCR5+63	; Fill vert 11 tiles with $2B at 6FC5
	DEFB	$00	; End of sequence

; Room 9E22
L9E22:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L9DF5	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $00, 20,2, TLSCR0+458	; Rectangle 20x2 tiles with $00 at 675A
	DEFRT03 $02, 26,12, TLSCR0+32	; Rectangle 26x12 tiles with $02 at 65B0
	DEFRT09 $FF, 5, TLSCR0+57	; Triangle with FF, count=5 at 65C9
	DEFRTBN	1, 2, 3, TLSCR0+440	; Block 2 tiles from 7348 to 6748 copy 3 times
	DEFRTBK	10, TLSCR0+410		; Block 2x1 tiles from 889D to 672A
	DEFRTBK	2, TLSCR5+287		; Block 2x4 tiles from 71BB to 70A5
	DEFRTBK	1, TLSCR5+305		; Block 3x3 tiles from 71A0 to 70B7
	DEFRTBK	1, TLSCR5+311		; Block 3x3 tiles from 71A0 to 70BD
	DEFRTBK	1, TLSCR5+324		; Block 3x3 tiles from 71A0 to 70CA
	DEFRTBL	14, 3,4, TLSCR5+272	; Block 3x4 tiles from 849C to 7096
	DEFB	$00	; End of sequence

; Room 9E73
L9E73:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L9EB8	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L9BE7	; Room to Down
	DEFRT0C 120, TLSCR0+0		; Fill horz 120 tiles with $FF at 6590
	DEFRT0A 6,13, TLSCR0+144	; Rectangle 6x13 tiles with $FF at 6620
	DEFRT0A 6,6, TLSCR0+340	; Rectangle 6x6 tiles with $FF at 66E4
	DEFRT08 $FF, 4, TLSCR0+399	; Triangle with FF, count=4 at 671F
	DEFRT04 12, $FA, TLSCR0+330	; Fill horz 12 tiles with $FA at 66DA
	DEFRTVT 13, $3A, TLSCR0+136	; Fill vert 13 tiles with $3A at 6618
	DEFRTVT 7, $3A, TLSCR0+124	; Fill vert 7 tiles with $3A at 660C
	DEFRT04 10, $FA, TLSCR0+345	; Fill horz 10 tiles with $FA at 66E9
	DEFRTBN	1, 2, 13, TLSCR0+138	; Block 2 tiles from 7348 to 661A copy 13 times
	DEFRTBK	10, TLSCR0+348		; Block 2x1 tiles from 889D to 66EC
	DEFB	$00	; End of sequence

; Room 9EB8
L9EB8:	DEFW	L7918	; Room procedure
	DEFW	LA12E	; Initialization
	DEFW	L9ED9	; Room to Left
	DEFW	L9E73	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 120, TLSCR0+0		; Fill horz 120 tiles with $FF at 6590
	DEFRT04 30, $FA, TLSCR0+330	; Fill horz 30 tiles with $FA at 66DA
	DEFRTVT 7, $28, TLSCR5+125	; Fill vert 7 tiles with $28 at 7003
	DEFRTVT 7, $28, TLSCR5+141	; Fill vert 7 tiles with $28 at 7013
	DEFB	$00	; End of sequence

; Room 9ED9
L9ED9:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L9EFA	; Room to Left
	DEFW	L9EB8	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0C 120, TLSCR0+0		; Fill horz 120 tiles with $FF at 6590
	DEFRT04 30, $FA, TLSCR0+330	; Fill horz 30 tiles with $FA at 66DA
	DEFRTVT 7, $28, TLSCR5+127	; Fill vert 7 tiles with $28 at 7005
	DEFRTVT 7, $28, TLSCR5+139	; Fill vert 7 tiles with $28 at 7011
	DEFB	$00	; End of sequence

; Room 9EFA
L9EFA:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L9ED9	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L9F3A	; Room to Down
	DEFRT0C 125, TLSCR0+0		; Fill horz 125 tiles with $FF at 6590
	DEFRT0A 5,12, TLSCR0+150	; Rectangle 5x12 tiles with $FF at 6626
	DEFRT0A 20,5, TLSCR0+369	; Rectangle 20x5 tiles with $FF at 6701
	DEFRT0C 19, TLSCR0+335		; Fill horz 19 tiles with $FF at 66DF
	DEFRT04 6, $FA, TLSCR0+354	; Fill horz 6 tiles with $FA at 66F2
	DEFRTVT 7, $3A, TLSCR0+134	; Fill vert 7 tiles with $3A at 6616
	DEFRTVT 7, $28, TLSCR5+145	; Fill vert 7 tiles with $28 at 7017
	DEFRTBN	1, 2, 13, TLSCR0+126	; Block 2 tiles from 7348 to 660E copy 13 times
	DEFRTBK	10, TLSCR0+336		; Block 2x1 tiles from 889D to 66E0
	DEFB	$00	; End of sequence

; Room 9F3A
L9F3A:	DEFW	L7918	; Room procedure
	DEFW	LA124	; Initialization
	DEFW	0	; Room to Left
	DEFW	L9F7E	; Room to Right
	DEFW	L9EFA	; Room to Up
	DEFW	L9B9D	; Room to Down
	DEFRT0A 5,15, TLSCR0+0	; Rectangle 5x15 tiles with $FF at 6590
	DEFRT0C 60, TLSCR0+450		; Fill horz 60 tiles with $FF at 6752
	DEFRT0A 20,2, TLSCR0+9	; Rectangle 20x2 tiles with $FF at 6599
	DEFRTBN	1, 2, 15, TLSCR0+6	; Block 2 tiles from 7348 to 6596 copy 15 times
	DEFRTBK	2, TLSCR5+349		; Block 2x4 tiles from 71BB to 70E3
	DEFRTVT 13, $3A, TLSCR0+74	; Fill vert 13 tiles with $3A at 65DA
	DEFRTVT 13, $3A, TLSCR0+85	; Fill vert 13 tiles with $3A at 65E5
	DEFRTBK	10, TLSCR0+472		; Block 2x1 tiles from 889D to 6768
	DEFRTBL	1, 2,1, TLSCR0+502	; Block 2x1 tiles from 7348 to 6786
	DEFB	$00	; End of sequence

; Room 9F7E
L9F7E:	DEFW	L7918	; Room procedure
	DEFW	LA129	; Initialization
	DEFW	L9F3A	; Room to Left
	DEFW	LA022	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0A 2,2, TLSCR0+450	; Rectangle 2x2 tiles with $FF at 6752
	DEFRT03 $A3, 27,2, TLSCR0+453	; Rectangle 27x2 tiles with $A3 at 6755
	DEFRTBL	43, 1,2, TLSCR0+452	; Block 1x2 tiles from A008 to 6754
	DEFRT03 $F5, 26,10, TLSCR5+154	; Rectangle 26x10 tiles with $F5 at 7020
	DEFRT0A 2,2, TLSCR5+154	; Rectangle 2x2 tiles with $FF at 7020
	DEFRTBL	42, 2,2, TLSCR0+154	; Block 2x2 tiles from A004 to 662A
	DEFRTBK	11, TLSCR5+246		; Block 4x4 tiles from A00A to 707C
	DEFRTBK	11, TLSCR5+250		; Block 4x4 tiles from A00A to 7080
	DEFRTBK	11, TLSCR5+254		; Block 4x4 tiles from A00A to 7084
	DEFRTBK	11, TLSCR5+258		; Block 4x4 tiles from A00A to 7088
	DEFRTBK	11, TLSCR5+262		; Block 4x4 tiles from A00A to 708C
	DEFRTBK	11, TLSCR5+266		; Block 4x4 tiles from A00A to 7090
	DEFRT03 $1B, 24,4, TLSCR0+246	; Rectangle 24x4 tiles with $1B at 6686
	DEFRT03 $A3, 24,2, TLSCR0+96	; Rectangle 24x2 tiles with $A3 at 65F0
	DEFRTBL	43, 1,2, TLSCR0+95	; Block 1x2 tiles from A008 to 65EF
	DEFRT0E $98, TLSCR0+67	; Put tile 98 at 65D3
	DEFRT04 22, $0D, TLSCR0+68	; Fill horz 22 tiles with $0D at 65D4
	DEFRTBL	44, 4,2, TLSCR0+22	; Block 4x2 tiles from A01A to 65A6
	DEFRT03 $0D, 4,2, TLSCR0+26	; Rectangle 4x2 tiles with $0D at 65AA
	DEFB	$00	; End of sequence

; Room A022
LA022:	DEFW	LB41F	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	L9F7E	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT03 $A3, 27,2, TLSCR0+450	; Rectangle 27x2 tiles with $A3 at 6752
	DEFRT03 $F5, 26,10, TLSCR5+150	; Rectangle 26x10 tiles with $F5 at 701C
	DEFRT0A 2,2, TLSCR5+174	; Rectangle 2x2 tiles with $FF at 7034
	DEFRTBL	45, 2,2, TLSCR0+174	; Block 2x2 tiles from A0A7 to 663E
	DEFRTBK	11, TLSCR5+240		; Block 4x4 tiles from A00A to 7076
	DEFRTBK	11, TLSCR5+244		; Block 4x4 tiles from A00A to 707A
	DEFRTBK	11, TLSCR5+248		; Block 4x4 tiles from A00A to 707E
	DEFRTBK	11, TLSCR5+252		; Block 4x4 tiles from A00A to 7082
	DEFRTBK	11, TLSCR5+256		; Block 4x4 tiles from A00A to 7086
	DEFRTBK	11, TLSCR5+260		; Block 4x4 tiles from A00A to 708A
	DEFRT03 $1B, 24,4, TLSCR0+240	; Rectangle 24x4 tiles with $1B at 6680
	DEFRT03 $A3, 24,2, TLSCR0+90	; Rectangle 24x2 tiles with $A3 at 65EA
	DEFRTBL	46, 1,2, TLSCR0+114	; Block 1x2 tiles from A0AB to 6602
	DEFRT0E $94, TLSCR0+82	; Put tile 94 at 65E2
	DEFRT04 22, $0D, TLSCR0+60	; Fill horz 22 tiles with $0D at 65CC
	DEFRTBL	47, 4,2, TLSCR0+4	; Block 4x2 tiles from A0AD to 6594
	DEFRT03 $0D, 4,2, TLSCR0+0	; Rectangle 4x2 tiles with $0D at 6590
	DEFRTVT 8, $FF, TLSCR0+235	; Fill vert 8 tiles with $FF at 667B
	DEFRTBL	46, 1,2, TLSCR0+477	; Block 1x2 tiles from A0AB to 676D
	DEFB	$00	; End of sequence

; Room B513: Initial Room
LB513:	DEFW	LB446	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	L791E	; Room to Right
	DEFW	0	; Room to Up
	DEFW	0	; Room to Down
	DEFRT0D				; Fill entire screen with $0D
	DEFRT04 30, $F5, TLSCR0+480	; Fill horz 30 tiles with $F5 at 6770
	DEFRT04 30, $0B, TLSCR5+360	; Fill horz 30 tiles with $0B at 70EE
	DEFRT03 $0C, 30,3, TLSCR5+390	; Rectangle 30x3 tiles with $0C at 710C
	DEFB	$00	; End of sequence

; Room 7F85: Extra room between rooms 8162 and 7DA9
L7F85:	DEFW	LB937	; Room procedure
	DEFW	LB422	; Initialization
	DEFW	0	; Room to Left
	DEFW	0	; Room to Right
	DEFW	0	; Room to Up
	DEFW	L7D5A	; Room to Down
	DEFRT05				; Fill entire screen with $FF
	DEFRT03 $02, 22,15, TLSCR0+4	; Rectangle 22x15 tiles with $02 at 6594
	DEFRT03 $02, 4,11, TLSCR0+146	; Rectangle 4x11 tiles with $02 at 6622
	DEFRTVT 11, $EB, TLSCR0+148	; Fill vert 11 tiles with $EB at 6624
	DEFRTBK 12, TLSCR5+394		; Block 6x2 tiles from 7188 - pile
	DEFRTBK 12, TLSCR5+404		; Block 6x2 tiles from 7188 - pile
	DEFRTBK 12, TLSCR5+410		; Block 6x2 tiles from 7188 - pile
	DEFRTBN 2, 2, 2, TLSCR0+461	; Block 2 tiles from 7984 copy 2 times
	DEFB	$00	; End of sequence

;----------------------------------------------------------------------------
