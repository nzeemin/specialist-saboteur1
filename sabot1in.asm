
; Game screen frames/indicators ZX0 encoded sequence
LAD65:
	DEFB $25,$00,$01,$19,$94,$02,$03,$0B,$6F,$04,$C0,$55,$56,$3A,$05,$06
	DEFB $FE,$25,$07,$06,$3F,$E1,$F6,$6E,$08,$40,$29,$03,$59,$21,$03,$0E
	DEFB $0F,$0F,$10,$03,$2F,$05,$80,$1E,$95,$8B,$11,$12,$92,$C0,$3C,$03
	DEFB $16,$FE,$66,$03,$13,$14,$BC,$15,$80,$BB,$09,$FE,$D7,$C0,$9F,$D6
	DEFB $CC,$8C,$04,$0A,$E9,$C0,$0C,$5F,$E1,$DB,$D6,$0D,$00,$00,$80

; Tiles for game screen frames/indicators, 9 bytes each
LAE02:	DEFB color_red, $30,$08,$04,$05,$02,$8D,$70,$1C
	DEFB color_red, $22,$22,$14,$E7,$3C,$24,$44,$00
	DEFB color_red, $00,$10,$21,$22,$A4,$64,$A8,$30
	DEFB color_red, $10,$50,$3C,$08,$08,$6A,$9C,$08
	DEFB color_red, $10,$48,$39,$0E,$08,$78,$17,$10
	DEFB color_red, $0A,$9C,$68,$04,$03,$4C,$38,$14
	DEFB color_red, $00,$11,$22,$62,$BF,$44,$44,$42
	DEFB color_red, $00,$24,$22,$22,$A7,$66,$5A,$89
	DEFB color_red, $10,$78,$27,$20,$C0,$2E,$70,$10
	DEFB color_red, $00,$00,$00,$00,$00,$00,$00,$00
	DEFB color_red, $08,$0E,$08,$36,$43,$02,$04,$18
	DEFB color_blue,$00,$00,$00,$00,$00,$00,$00,$00
	DEFB color_red, $50,$72,$54,$CE,$25,$28,$28,$08
	DEFB color_red, $10,$3C,$92,$61,$A0,$18,$04,$04
	DEFB color_cyan,$7F,$80,$80,$87,$88,$88,$88,$88
	DEFB color_cyan,$FF,$00,$00,$FF,$00,$00,$00,$00
	DEFB color_cyan,$FE,$01,$01,$E1,$11,$11,$11,$11
	DEFB color_cyan,$88,$88,$88,$88,$88,$88,$88,$88
	DEFB color_cyan,$11,$11,$11,$11,$11,$11,$11,$11
	DEFB color_cyan,$88,$88,$88,$88,$87,$80,$80,$7F
	DEFB color_cyan,$00,$00,$00,$00,$FF,$00,$00,$FF
	DEFB color_cyan,$11,$11,$11,$11,$E1,$01,$01,$FE
	DEFB color_cyan,$00,$00,$00,$00,$00,$00,$00,$00
