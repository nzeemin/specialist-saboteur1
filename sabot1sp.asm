
; Sprite Dog 1
L71F2:	DEFB	$FF,$00,$FF,$01
	DEFB	$02,$03,$04,$05
	DEFB	$06,$07,$08,$09
; Sprite Dog 2
L71FE:	DEFB	$FF,$FF,$0A,$0B
	DEFB	$0C,$0D,$0E,$0F
	DEFB	$10,$11,$12,$13
; Sprite Dog 3
L720A:	DEFB	$FF,$14,$15,$16
	DEFB	$17,$18,$19,$1A
	DEFB	$1B,$1C,$1D,$1E
; Sprite Dog 4
L7216:	DEFB	$FF,$1F,$20,$FF
	DEFB	$21,$22,$23,$24
	DEFB	$25,$26,$27,$FF

; Sprite Dog dead
L9C9C:	DEFB	$FF,$FF,$FF,$FF
	DEFB	$FF,$FF,$FF,$FF
	DEFB	$5D,$5E,$5F,$60

; Sprite Ninja/Guard dead, 6x7 tiles
LA0B5:	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$ED,$EC,$EB,$FF
	DEFB $F3,$F2,$F1,$F0,$EF,$EE

; Boat sprite for initial room
LB5A7:	DEFB $FF
LB5A8:	DEFB $67,$68,$6A,$6A,$6A,$6A,$6A,$6B

; Empty sprite
LC0E6:	DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

; Ninja/Guard sprites
; Most of Ninja sprites are also Guard sprites,
; A775 procedure and A787 table used to translate Ninja tiles into Guard tiles.
; Sprite Ninja/Guard walking 1
LD3DE:	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$4F,$50,$51,$FF
	DEFB $FF,$FF,$52,$53,$54,$FF
	DEFB $FF,$FF,$55,$56,$57,$FF
	DEFB $FF,$FF,$58,$59,$FF,$FF
	DEFB $FF,$5A,$5B,$5C,$FF,$FF
; Sprite Ninja/Guard walking 2
LD408:	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$4F,$50,$51,$FF
	DEFB $FF,$FF,$52,$53,$54,$FF
	DEFB $FF,$FF,$55,$5E,$5F,$FF
	DEFB $FF,$FF,$60,$61,$62,$FF
	DEFB $FF,$FF,$63,$64,$FF,$FF
; Sprite Ninja/Guard walking 3
LD432:	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$4F,$50,$51,$FF
	DEFB $FF,$FF,$52,$53,$54,$FF
	DEFB $FF,$FF,$5D,$65,$66,$FF
	DEFB $FF,$FF,$67,$68,$69,$FF
	DEFB $FF,$6A,$6B,$6C,$FF,$FF
; Sprite Ninja/Guard walking 4
LD45C:	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$4F,$50,$51,$FF
	DEFB $FF,$FF,$52,$53,$54,$FF
	DEFB $FF,$FF,$5D,$6D,$57,$FF
	DEFB $FF,$6F,$70,$71,$72,$FF
	DEFB $FF,$73,$74,$FF,$75,$FF
; Sprite Ninja/Guard standing
LD486:	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$F4,$F5,$FF,$FF
	DEFB $FF,$02,$03,$F6,$FF,$FF
	DEFB $FF,$05,$06,$07,$08,$FF
	DEFB $FF,$0A,$0B,$0C,$0D,$FF
	DEFB $FF,$FF,$0E,$0F,$10,$FF
	DEFB $FF,$FF,$11,$FF,$12,$FF
; Sprite Ninja/Guard jumping
LD4B0:	DEFB $FF,$FF,$13,$14,$FF,$FF
	DEFB $FF,$15,$16,$17,$FF,$FF
	DEFB $FF,$18,$19,$1A,$FF,$FF
	DEFB $FF,$1B,$1C,$1D,$FF,$FF
	DEFB $FF,$FF,$1E,$1F,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
; Sprite Ninja/Guard jump-kick
LD4DA:	DEFB $FF,$FF,$20,$21,$FF,$FF
	DEFB $4D,$22,$23,$FF,$FF,$FF
	DEFB $4E,$24,$25,$26,$27,$2C
	DEFB $FF,$28,$29,$2A,$2B,$FF
	DEFB $FF,$FF,$2D,$2E,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
; Sprite Ninja/Guard punching
LD504:	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$00,$01,$FF,$FF
	DEFB $FF,$FF,$2F,$30,$31,$FF
	DEFB $FF,$FF,$32,$33,$34,$FF
	DEFB $FF,$FF,$35,$0C,$0D,$FF
	DEFB $FF,$FF,$0E,$0F,$10,$FF
	DEFB $FF,$FF,$11,$FF,$12,$FF
; Sprite Ninja on ladder
LD52E:	DEFB $FF,$FF,$40,$FF,$FF,$FF
	DEFB $FF,$FF,$41,$42,$FF,$FF
	DEFB $FF,$FF,$43,$44,$FF,$FF
	DEFB $FF,$FF,$45,$46,$FF,$FF
	DEFB $FF,$FF,$47,$48,$FF,$FF
	DEFB $FF,$FF,$49,$4A,$FF,$FF
	DEFB $FF,$FF,$4B,$4C,$FF,$FF
; Sprite Ninja sitting
LD558:	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$36,$FF,$FF
	DEFB $FF,$FF,$37,$38,$39,$FF
	DEFB $FF,$FF,$3A,$3B,$3C,$FF
	DEFB $FF,$FF,$3D,$3E,$3F,$FF
; Sprite Ninja falling
LD582:	DEFB $FF,$FF,$6E,$7C,$FF,$FF
	DEFB $FF,$FF,$7D,$7E,$FF,$FF
	DEFB $FF,$FF,$7F,$80,$FF,$FF
	DEFB $FF,$FF,$81,$82,$FF,$FF
	DEFB $FF,$FF,$76,$77,$FF,$FF
	DEFB $FF,$FF,$78,$79,$FF,$FF
	DEFB $FF,$FF,$7A,$7B,$FF,$FF
; Sprite Ninja jumping 3
LD5AC:	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$8D,$8E,$FF,$FF
	DEFB $FF,$8F,$90,$91,$92,$FF
	DEFB $FF,$93,$94,$95,$96,$FF
	DEFB $FF,$97,$98,$99,$9A,$FF
	DEFB $FF,$9B,$9C,$9D,$FF,$FF
	DEFB $FF,$9E,$FF,$FF,$FF,$FF
; Sprite Ninja jumping 4
LD5D6:	DEFB $FF,$FF,$84,$88,$FF,$FF
	DEFB $FF,$8C,$85,$89,$FF,$FF
	DEFB $FF,$83,$86,$8A,$FF,$FF
	DEFB $FF,$FF,$87,$8B,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
	DEFB $FF,$FF,$FF,$FF,$FF,$FF
