;	map(0x0000, 0x07ff).ram().share("rambase");
;	map(0x0c00, 0x0c0f).ram().w(m_palette, FUNC(palette_device::write8)).share("palette");
;	map(0x1000, 0x13ff).ram().share("videoram");
;	map(0x1400, 0x17ff).ram().share("colorram");
;	map(0x1800, 0x1bff).rw(FUNC(btime_state::btime_mirrorvideoram_r), FUNC(btime_state::btime_mirrorvideoram_w));
;	map(0x1c00, 0x1fff).rw(FUNC(btime_state::btime_mirrorcolorram_r), FUNC(btime_state::btime_mirrorcolorram_w));
;	map(0x4000, 0x4000).portr("P1").nopw();
;	map(0x4001, 0x4001).portr("P2");
;	map(0x4002, 0x4002).portr("SYSTEM").w(FUNC(btime_state::btime_video_control_w));
;	map(0x4003, 0x4003).portr("DSW1").w(m_soundlatch, FUNC(generic_latch_8_device::write));
;	map(0x4004, 0x4004).portr("DSW2").w(FUNC(btime_state::bnj_scroll1_w));
;	map(0xb000, 0xffff).rom();
	
;	PORT_START("P1")
;	PORT_BIT( 0x01, IP_ACTIVE_LOW, IPT_JOYSTICK_RIGHT ) PORT_4WAY
;	PORT_BIT( 0x02, IP_ACTIVE_LOW, IPT_JOYSTICK_LEFT ) PORT_4WAY
;	PORT_BIT( 0x04, IP_ACTIVE_LOW, IPT_JOYSTICK_UP ) PORT_4WAY
;	PORT_BIT( 0x08, IP_ACTIVE_LOW, IPT_JOYSTICK_DOWN ) PORT_4WAY
;	PORT_BIT( 0x10, IP_ACTIVE_LOW, IPT_BUTTON1 )
;	PORT_BIT( 0x20, IP_ACTIVE_LOW, IPT_UNKNOWN )
;	PORT_BIT( 0x40, IP_ACTIVE_LOW, IPT_UNUSED )
;	PORT_BIT( 0x80, IP_ACTIVE_LOW, IPT_UNUSED )
;
;	PORT_START("P2")
;	PORT_BIT( 0x01, IP_ACTIVE_LOW, IPT_JOYSTICK_RIGHT ) PORT_4WAY PORT_COCKTAIL
;	PORT_BIT( 0x02, IP_ACTIVE_LOW, IPT_JOYSTICK_LEFT ) PORT_4WAY PORT_COCKTAIL
;	PORT_BIT( 0x04, IP_ACTIVE_LOW, IPT_JOYSTICK_UP ) PORT_4WAY PORT_COCKTAIL
;	PORT_BIT( 0x08, IP_ACTIVE_LOW, IPT_JOYSTICK_DOWN ) PORT_4WAY PORT_COCKTAIL
;	PORT_BIT( 0x10, IP_ACTIVE_LOW, IPT_BUTTON1 ) PORT_COCKTAIL
;	PORT_BIT( 0x20, IP_ACTIVE_LOW, IPT_UNKNOWN )
;	PORT_BIT( 0x40, IP_ACTIVE_LOW, IPT_UNUSED )
;	PORT_BIT( 0x80, IP_ACTIVE_LOW, IPT_UNUSED )
;
;	PORT_START("SYSTEM")
;	PORT_BIT( 0x01, IP_ACTIVE_LOW, IPT_START1 )
;	PORT_BIT( 0x02, IP_ACTIVE_LOW, IPT_START2 )
;	PORT_BIT( 0x04, IP_ACTIVE_LOW, IPT_TILT )
;	PORT_BIT( 0x08, IP_ACTIVE_LOW, IPT_UNKNOWN )
;	PORT_BIT( 0x10, IP_ACTIVE_LOW, IPT_UNUSED )
;	PORT_BIT( 0x20, IP_ACTIVE_LOW, IPT_UNUSED )
;	PORT_BIT( 0x40, IP_ACTIVE_HIGH, IPT_COIN1 ) PORT_CHANGED_MEMBER(DEVICE_SELF, btime_state,coin_inserted_irq_hi, 0)
;	PORT_BIT( 0x80, IP_ACTIVE_HIGH, IPT_COIN2 ) PORT_CHANGED_MEMBER(DEVICE_SELF, btime_state,coin_inserted_irq_hi, 0)
;
;	PORT_START("DSW1") // At location 15D on sound PCB
;	PORT_DIPNAME( 0x03, 0x03, DEF_STR( Coin_A ) )     PORT_DIPLOCATION("SW1:1,2")
;	PORT_DIPSETTING(    0x00, DEF_STR( 2C_1C ) )
;	PORT_DIPSETTING(    0x03, DEF_STR( 1C_1C ) )
;	PORT_DIPSETTING(    0x02, DEF_STR( 1C_2C ) )
;	PORT_DIPSETTING(    0x01, DEF_STR( 1C_3C ) )
;	PORT_DIPNAME( 0x0c, 0x0c, DEF_STR( Coin_B ) )     PORT_DIPLOCATION("SW1:3,4")
;	PORT_DIPSETTING(    0x00, DEF_STR( 2C_1C ) )
;	PORT_DIPSETTING(    0x0c, DEF_STR( 1C_1C ) )
;	PORT_DIPSETTING(    0x08, DEF_STR( 1C_2C ) )
;	PORT_DIPSETTING(    0x04, DEF_STR( 1C_3C ) )
;	PORT_DIPNAME( 0x10, 0x10, "Leave Off" )           PORT_DIPLOCATION("SW1:5") // Must be OFF. No test mode in ROM
;	PORT_DIPSETTING(    0x10, DEF_STR( Off ) )                                  // so this locks up the game at boot-up if on
;	PORT_DIPSETTING(    0x00, DEF_STR( On ) )
;	PORT_DIPUNUSED_DIPLOC( 0x20, IP_ACTIVE_LOW, "SW1:6" )
;	PORT_DIPNAME( 0x40, 0x00, DEF_STR( Cabinet ) )    PORT_DIPLOCATION("SW1:7")
;	PORT_DIPSETTING(    0x00, DEF_STR( Upright ) )
;	PORT_DIPSETTING(    0x40, DEF_STR( Cocktail ) )
;//  PORT_DIPNAME( 0x80, 0x00, "Screen" )              PORT_DIPLOCATION("SW1:8") // Manual states this is Screen Invert
;//  PORT_DIPSETTING(    0x00, "Normal" )
;//  PORT_DIPSETTING(    0x80, "Invert" )
;	PORT_BIT( 0x80, IP_ACTIVE_HIGH, IPT_CUSTOM  ) PORT_VBLANK("screen")  // Schematics show this is connected to DIP SW2.8
;
;	PORT_START("DSW2") // At location 14D on sound PCB
;	PORT_DIPNAME( 0x01, 0x01, DEF_STR( Lives ) )      PORT_DIPLOCATION("SW2:1")
;	PORT_DIPSETTING(    0x01, "3" )
;	PORT_DIPSETTING(    0x00, "5" )
;	PORT_DIPNAME( 0x06, 0x02, DEF_STR( Bonus_Life ) ) PORT_DIPLOCATION("SW2:2,3")
;	PORT_DIPSETTING(    0x06, "10000" )
;	PORT_DIPSETTING(    0x04, "15000" )
;	PORT_DIPSETTING(    0x02, "20000"  )
;	PORT_DIPSETTING(    0x00, "30000"  )
;	PORT_DIPNAME( 0x08, 0x08, "Enemies" )             PORT_DIPLOCATION("SW2:4")
;	PORT_DIPSETTING(    0x08, "4" )
;	PORT_DIPSETTING(    0x00, "6" )
;	PORT_DIPNAME( 0x10, 0x00, "End of Level Pepper" ) PORT_DIPLOCATION("SW2:5")
;	PORT_DIPSETTING(    0x10, DEF_STR( No ) )
;	PORT_DIPSETTING(    0x00, DEF_STR( Yes ) )
;	PORT_DIPUNUSED_DIPLOC( 0x20, 0x20, "SW2:6" )  // should be OFF according to the manual
;	PORT_DIPUNUSED_DIPLOC( 0x40, 0x40, "SW2:7" )  // should be OFF according to the manual
;	PORT_DIPUNUSED_DIPLOC( 0x80, 0x80, "SW2:8" )  // should be OFF according to the manual

C000: 4C 3C CF jmp $cf3c
C003: 4C 0F C0 jmp $c00f
C006: 85 F5    sta dummy_write_00f5
C008: EA       nop
C009: 4C 03 B0 jmp $b003
C00C: 85 F5    sta dummy_write_00f5
C00E: EA       nop
C00F: 78       sei
C010: D8       cld
C011: A2 FF    ldx #$ff
C013: 9A       txs
C014: AD 03 40 lda $4003
C017: 29 10    and #$10
C019: F0 EE    beq $c009
C01B: A9 00    lda #$00
C01D: 85 01    sta $01
C01F: 85 F9    sta $f9
C021: 8D 00 40 sta $4000
C024: 20 32 C3 jsr $c332
C027: 20 1D C3 jsr $c31d
C02A: A9 01    lda #$01
C02C: 85 01    sta $01
C02E: A9 00    lda #$00
C030: 85 1A    sta $1a
C032: 20 0D C7 jsr $c70d
C035: 85 F7    sta $f7
C037: EA       nop
C038: A9 FE    lda #$fe
C03A: 8D 05 50 sta $5005
C03D: A9 00    lda #$00
C03F: 8D 02 40 sta $4002
C042: 85 1B    sta $1b
C044: 85 20    sta $20
C046: A9 00    lda #$00
C048: 85 1C    sta $1c
C04A: 20 16 C4 jsr $c416
C04D: A2 FF    ldx #$ff
C04F: 20 2C CA jsr $ca2c
C052: 20 D9 C3 jsr $c3d9
C055: A2 FF    ldx #$ff
C057: 20 2C CA jsr $ca2c
C05A: 20 78 C4 jsr $c478
C05D: A2 3F    ldx #$3f
C05F: 20 2C CA jsr $ca2c
C062: 20 61 C5 jsr $c561
C065: 85 F5    sta dummy_write_00f5
C067: EA       nop
C068: 20 0D C7 jsr $c70d
C06B: 20 48 C7 jsr $c748
C06E: A9 01    lda #$01
C070: 85 1C    sta $1c
C072: 85 F5    sta dummy_write_00f5
C074: EA       nop
C075: 20 67 C7 jsr $c767
C078: 85 F5    sta dummy_write_00f5
C07A: EA       nop
C07B: AD 03 40 lda $4003
C07E: 10 FB    bpl $c07b
C080: 58       cli
C081: EA       nop
C082: EA       nop
C083: EA       nop
C084: EA       nop
C085: 78       sei
C086: 20 45 D0 jsr $d045
C089: 20 6E D0 jsr $d06e
C08C: E6 13    inc timer1_0013
C08E: A5 13    lda timer1_0013
C090: 29 3F    and #$3f
C092: D0 03    bne $c097
C094: 85 F5    sta dummy_write_00f5
C096: EA       nop
C097: E6 14    inc timer1_0014
C099: D0 03    bne $c09e
C09B: E6 15    inc $15
C09D: EA       nop
C09E: E6 16    inc $16
C0A0: AD 00 40 lda $4000
C0A3: 6D 01 40 adc $4001
C0A6: 65 16    adc $16
C0A8: 85 16    sta $16
C0AA: 85 F5    sta dummy_write_00f5
C0AC: EA       nop
C0AD: AD 03 40 lda $4003
C0B0: 30 FB    bmi $c0ad
C0B2: 20 E6 C8 jsr $c8e6
C0B5: 20 7B D1 jsr $d17b
C0B8: 20 96 D7 jsr $d796
C0BB: 20 98 D8 jsr $d898
C0BE: A5 1B    lda $1b
C0C0: F0 0C    beq $c0ce
C0C2: 20 28 DB jsr $db28
C0C5: 20 BB DB jsr $dbbb
C0C8: 20 77 DC jsr $dc77
C0CB: 85 F5    sta dummy_write_00f5
C0CD: EA       nop
C0CE: 20 65 DD jsr $dd65
C0D1: 20 8D EA jsr $ea8d
C0D4: 20 DF E6 jsr $e6df
C0D7: 20 41 E1 jsr $e141
C0DA: 20 90 E1 jsr $e190
C0DD: 20 35 E8 jsr $e835
C0E0: 20 60 E7 jsr $e760
C0E3: 20 6C E8 jsr $e86c
C0E6: A6 1F    ldx current_player_001f
C0E8: B5 2B    lda player_pepper_002b, x
C0EA: D0 2D    bne $c119
C0EC: A5 13    lda timer1_0013
C0EE: 29 3F    and #$3f
C0F0: D0 19    bne $c10b
C0F2: A2 FC    ldx #$fc
C0F4: A0 C0    ldy #$c0
C0F6: 20 BC C9 jsr $c9bc
C0F9: 4C 19 C1 jmp $c119
C0FC: 3A       
C0FD: 10 00    
C0FF: 00       
C100: 00       
C101: FF 3A 10 
C104: 51 52    
C106: 53 FF    
C108: 85 F6    
C10A: EA       
C10B: C9 0F    cmp #$0f
C10D: D0 0A    bne $c119
C10F: A2 02    ldx #$02
C111: A0 C1    ldy #$c1
C113: 20 BC C9 jsr $c9bc
C116: 85 F6    sta $f6
C118: EA       nop
C119: A5 C6    lda $c6
C11B: D0 0D    bne $c12a
C11D: A5 C5    lda $c5
C11F: F0 03    beq $c124
C121: 4C 75 C0 jmp $c075
C124: 4C 7B C0 jmp $c07b
C127: 85 F7    sta $f7
C129: EA       nop
C12A: A9 00    lda #$00
C12C: 85 C6    sta $c6
C12E: C9 1B    cmp #$1b
C130: D0 0B    bne $c13d
C132: A2 3F    ldx #$3f
C134: 20 2C CA jsr $ca2c
C137: 4C 38 C0 jmp $c038
C13A: 85 F7    sta $f7
C13C: 6E 20 A3 ror $a320
C13F: C8       iny
C140: 20 E3 CB jsr $cbe3
C143: A5 21    lda $21
C145: D0 17    bne $c15e
C147: A5 29    lda player_lives_0029
C149: 30 0D    bmi $c158
C14B: A9 01    lda #$01
C14D: 85 20    sta $20
C14F: 08       php
C150: 52       kil
C151: C2 4C    nop #$4c
C153: 75 C0    adc $c0, x
C155: 85 F5    sta dummy_write_00f5
C157: 6E 4C F1 ror $f14c
C15A: C1 85    cmp ($85, x)
C15C: F7 6E    isb $6e, x
C15E: A6 1F    ldx current_player_001f
C160: D0 4D    bne $c1af
C162: A5 29    lda player_lives_0029
C164: 25 2A    and $2a
C166: 30 41    bmi $c1a9
C168: A5 2A    lda $2a
C16A: 10 0D    bpl $c179
C16C: 20 6D C2 jsr $c26d
C16F: A9 01    lda #$01
C171: 85 20    sta $20
C173: 4C 75 C0 jmp $c075
C176: 85 F7    sta $f7
C178: EA       nop
C179: A5 29    lda player_lives_0029
C17B: 10 09    bpl $c186
C17D: 20 95 C2 jsr $c295
C180: 20 A3 C8 jsr $c8a3
C183: 85 F7    sta $f7
C185: 6E 20 03 ror $0320
C188: C3 A9    dcp ($a9, x)
C18A: 01 85    ora ($85, x)
C18C: 1F C1 20 slo $20c1, x
C18F: CD 03 40 cmp $4003
C192: 29 40    and #$40
C194: F0 0D    beq $c1a3
C196: A9 00    lda #$00
C198: 8D 05 50 sta $5005
C19B: A9 01    lda #$01
C19D: 8D 02 40 sta $4002
C1A0: 85 F7    sta $f7
C1A2: EA       nop
C1A3: 20 81 C2 jsr $c281
C1A6: 4C 75 C0 jmp $c075
C1A9: 4C F1 C1 jmp $c1f1
C1AC: 85 F7    sta $f7
C1AE: 6E A5 2A ror $2aa5
C1B1: 25 29    and player_lives_0029
C1B3: 30 3C    bmi $c1f1
C1B5: A5 29    lda player_lives_0029
C1B7: 10 0D    bpl $c1c6
C1B9: A9 01    lda #$01
C1BB: 85 20    sta $20
C1BD: 08       php
C1BE: 81 C2    sta ($c2, x)
C1C0: 4C 75 C0 jmp $c075
C1C3: 85 F7    sta $f7
C1C5: 6E A5 2A ror $2aa5
C1C8: 10 09    bpl $c1d3
C1CA: 20 AD C2 jsr $c2ad
C1CD: 20 A3 C8 jsr $c8a3
C1D0: 85 F7    sta $f7
C1D2: EA       nop
C1D3: 20 03 C3 jsr $c303
C1D6: A9 00    lda #$00
C1D8: 85 1F    sta current_player_001f
C1DA: A9 01    lda #$01
C1DC: 85 20    sta $20
C1DE: 4D FE 8D eor $8dfe
C1E1: 05 50    ora $50
C1E3: A9 00    lda #$00
C1E5: 8D 02 40 sta $4002
C1E8: 20 6D C2 jsr $c26d
C1EB: 4C 75 C0 jmp $c075
C1EE: 85 F7    sta $f7
C1F0: EA       nop
C1F1: 20 C5 C2 jsr $c2c5
C1F4: 20 A3 C8 jsr $c8a3
C1F7: A9 FE    lda #$fe
C1F9: 8D 05 50 sta $5005
C1FC: 4D 00 8D eor $8d00
C1FF: 02       kil
C200: 40       rti
C201: A9 00    lda #$00
C203: 85 CB    sta $cb
C205: A5 2D    lda $2d
C207: 85 CC    sta $cc
C209: A5 2E    lda $2e
C20B: 85 CD    sta $cd
C20D: A5 2F    lda $2f
C20F: 85 CE    sta $ce
C211: 20 F3 EF jsr $eff3
C214: 20 A3 C8 jsr $c8a3
C217: AD 03 40 lda $4003
C21A: 29 40    and #$40
C21C: F0 0D    beq $c22b
C21E: A9 00    lda #$00
C220: 8D 05 50 sta $5005
C223: A9 01    lda #$01
C225: 8D 02 40 sta $4002
C228: 85 F7    sta $f7
C22A: EA       nop
C22B: A9 01    lda #$01
C22D: 85 CB    sta $cb
C22F: A5 30    lda $30
C231: 85 CC    sta $cc
C233: A5 31    lda $31
C235: 85 CD    sta $cd
C237: A5 32    lda $32
C239: 85 CE    sta $ce
C23B: 20 F3 EF jsr $eff3
C23E: A2 00    ldx #$00
C240: 86 1B    stx $1b
C242: A5 1D    lda $1d
C244: 05 1E    ora $1e
C246: F0 05    beq $c24d
C248: E6 1A    inc $1a
C24A: 85 F7    sta $f7
C24C: EA       nop
C24D: 4C 38 C0 jmp $c038
C250: 85 F7    sta $f7
C252: EA       nop
C253: A2 E8    ldx #$e8
C255: A0 C2    ldy #$c2
C257: 20 BC C9 jsr $c9bc
C25A: 85 F5    sta dummy_write_00f5
C25C: EA       nop
C25D: A9 03    lda #$03
C25F: 20 5D EA jsr $ea5d
C262: 85 F5    sta dummy_write_00f5
C264: EA       nop
C265: A2 1F    ldx #$1f
C267: 20 2C CA jsr $ca2c
C26A: 60       rts
C26B: 85 F7    sta $f7
C26D: EA       nop
C26E: A2 D2    ldx #$d2
C270: A0 C2    ldy #$c2
C272: 20 BC C9 jsr $c9bc
C275: A2 E8    ldx #$e8
C277: A0 C2    ldy #$c2
C279: 20 BC C9 jsr $c9bc
C27C: 4C 5D C2 jmp $c25d
C27F: 85 F7    sta $f7
C281: EA       nop
C282: A2 DD    ldx #$dd
C284: A0 C2    ldy #$c2
C286: 20 BC C9 jsr $c9bc
C289: A2 E8    ldx #$e8
C28B: A0 C2    ldy #$c2
C28D: 20 BC C9 jsr $c9bc
C290: 4C 5D C2 jmp $c25d
C293: 85 F7    sta $f7
C295: EA       nop
C296: E6 C8    inc $c8
C298: A2 D2    ldx #$d2
C29A: A0 C2    ldy #$c2
C29C: 20 BC C9 jsr $c9bc
C29F: E6 C8    inc $c8
C2A1: A2 F5    ldx #dummy_write_00f5
C2A3: A0 C2    ldy #$c2
C2A5: 20 BC C9 jsr $c9bc
C2A8: 4C 65 C2 jmp $c265
C2AB: 85 F7    sta $f7
C2AD: EA       nop
C2AE: E6 C8    inc $c8
C2B0: A2 DD    ldx #$dd
C2B2: A0 C2    ldy #$c2
C2B4: 20 BC C9 jsr $c9bc
C2B7: E6 C8    inc $c8
C2B9: A2 F5    ldx #dummy_write_00f5
C2BB: A0 C2    ldy #$c2
C2BD: 20 BC C9 jsr $c9bc
C2C0: 4C 65 C2 jmp $c265
C2C3: 85 F7    sta $f7
C2C5: EA       nop
C2C6: E6 C8    inc $c8
C2C8: A2 F5    ldx #dummy_write_00f5
C2CA: A0 C2    ldy #$c2
C2CC: 20 BC C9 jsr $c9bc
C2CF: 4C 65 C2 jmp $c265
C2D2: CD 11 1A
C2D5: 16 0B   
C2D7: 23 0F   
C2D9: 1C 00 02
C2DC: FF CD 11
C2DF: 1A      
C2E0: 16 0B   
C2E2: 23 0F   
C2E4: 1C 00 03
C2E7: FF 0C 12
C2EA: 11 0B   
C2EC: 17 0F   
C2EE: 00      
C2EF: 1C 0F 0B
C2F2: 0E 23 FF
C2F5: 0C 12 11
C2F8: 0B 17   
C2FA: 0F 00 19
C2FD: 20 0F 1C
C300: FF 85 F7
C303: EA       nop
C304: A0 00    ldy #$00
C306: 85 F7    sta $f7
C308: EA       nop
C309: B9 00 02 lda $0200, y
C30C: AA       tax
C30D: B9 00 03 lda $0300, y
C310: 99 00 02 sta $0200, y
C313: 8A       txa
C314: 99 00 03 sta $0300, y
C317: 64 D0    nop $d0
C319: EF 60 85 isb $8560
C31C: F6 6E    inc $6e, x
C31E: A9 00    lda #$00
C320: 8D 05 50 sta $5005
C323: 85 25    sta $25
C325: C5 03    cmp $03
C327: 40       rti
C328: A9 80    lda #$80
C32A: 85 27    sta $27
C32C: C5 00    cmp $00
C32E: 40       rti
C32F: 28       plp
C330: 85 F6    sta $f6
C332: EA       nop
C333: 85 F6    sta $f6
C335: 6E A9 00 ror $00a9
C338: 85 03    sta $03
C33A: A9 10    lda #$10
C33C: 85 04    sta $04
C33E: 4A       lsr a
C33F: 10 85    bpl $c2c6
C341: F6 EA    inc $ea, x
C343: A0 00    ldy #$00
C345: 85 F6    sta $f6
C347: 6E A9 00 ror $00a9
C34A: 91 03    sta ($03), y
C34C: 64 D0    nop $d0
C34E: F9 E6 04 sbc $04e6, y
C351: CA       dex
C352: D0 EF    bne $c343
C354: 85 F6    sta $f6
C356: 6E 95 01 ror $0195
C359: E8       inx
C35A: E0 E1    cpx #$e1
C35C: D0 F9    bne $c357
C35E: A2 00    ldx #$00
C360: 85 F6    sta $f6
C362: EA       nop
C363: 9D 00 02 sta $0200, x
C366: D5 00    cmp $00, x
C368: 03 E8    slo ($e8, x)
C36A: D0 F7    bne $c363
C36C: A9 02    lda #$02
C36E: 85 35    sta $35
C370: A9 80    lda #$80
C372: 85 34    sta $34
C374: 4D 00 85 eor $8500
C377: 33 A2    rla ($a2), y
C379: 23 85    rla ($85, x)
C37B: F6 6E    inc $6e, x
C37D: BD B3 C3 lda $c3b3, x
C380: 95 36    sta $36, x
C382: CA       dex
C383: 10 F8    bpl $c37d
C385: 85 F6    sta $f6
C387: 6E A0 00 ror $00a0
C38A: 85 F6    sta $f6
C38C: 6E A2 00 ror $00a2
C38F: 85 F6    sta $f6
C391: EA       nop
C392: BD A3 C3 lda $c3a3, x
C395: 99 00 0C sta $0c00, y
C398: C8       iny
C399: E8       inx
C39A: E0 10    cpx #$10
C39C: D0 F4    bne $c392
C39E: C0 20    cpy #$20
C3A0: D0 EB    bne $c38d
C3A2: 60       rts
C3A3: FF 00 D0 isb $d000, x
C3A6: C0 F8    cpy #$f8
C3A8: C7 E1    dcp $e1
C3AA: D4 FF    nop $ff, x
C3AC: 52       kil
C3AD: 07 3F    slo $3f
C3AF: 00       brk
C3B0: F8       sed
C3B1: C0 38    cpy #$38
C3B3: 00       brk
C3B4: 80 02    nop #$02
C3B6: 00       brk
C3B7: 01 01    ora ($01, x)
C3B9: 00       brk
C3BA: 94 00    sty $00, x
C3BC: 50 65    bvc $c423
C3BE: 00       brk
C3BF: 50 48    bvc $c409
C3C1: 00       brk
C3C2: FF FF FF isb $ffff, x
C3C5: 15 0F    ora $0f, x
C3C7: 18       clc
C3C8: 12       kil
C3C9: CD 13 11 cmp $1113
C3CC: 19 18 12 ora $1218, y
C3CF: CD 15 15 cmp $1515
C3D2: CD 12 FF cmp $ff12
C3D5: FF FF 85 isb $85ff, x
C3D8: F5 EA    sbc $ea, x
C3DA: 20 A3 C8 jsr $c8a3
C3DD: 20 E3 CB jsr $cbe3
C3E0: A2 0F    ldx #$0f
C3E2: A0 CE    ldy #$ce
C3E4: 20 BC C9 jsr $c9bc
C3E7: A2 29    ldx #$29
C3E9: A0 CE    ldy #$ce
C3EB: 20 BC C9 jsr $c9bc
C3EE: A2 BE    ldx #$be
C3F0: A0 CE    ldy #$ce
C3F2: 20 BC C9 jsr $c9bc
C3F5: A6 5B    ldx $5b
C3F7: E8       inx
C3F8: 8E D5 12 stx $12d5
C3FB: A5 5A    lda $5a
C3FD: 29 F0    and #$f0
C3FF: 4A       lsr a
C400: 4A       lsr a
C401: 4A       lsr a
C402: 4A       lsr a
C403: AA       tax
C404: E8       inx
C405: 8E D6 12 stx $12d6
C408: A2 01    ldx #$01
C40A: 8E D7 12 stx $12d7
C40D: 8E D8 12 stx $12d8
C410: 8E D9 12 stx $12d9
C413: 60       rts
C414: 85 F5    sta dummy_write_00f5
C416: EA       nop
C417: 20 A3 C8 jsr $c8a3
C41A: 20 E3 CB jsr $cbe3
C41D: A2 0F    ldx #$0f
C41F: A0 CE    ldy #$ce
C421: 20 BC C9 jsr $c9bc
C424: A2 EF    ldx #$ef
C426: A0 CE    ldy #$ce
C428: 20 BC C9 jsr $c9bc
C42B: A9 C9    lda #$c9
C42D: 85 03    sta $03
C42F: A9 11    lda #$11
C431: 85 04    sta $04
C433: A2 12    ldx #$12
C435: 85 F5    sta dummy_write_00f5
C437: EA       nop
C438: A0 00    ldy #$00
C43A: B5 36    lda $36, x
C43C: 91 03    sta ($03), y
C43E: C8       iny
C43F: B5 37    lda $37, x
C441: 91 03    sta ($03), y
C443: C8       iny
C444: B5 38    lda $38, x
C446: 91 03    sta ($03), y
C448: 18       clc
C449: A5 03    lda $03
C44B: 69 40    adc #$40
C44D: 85 03    sta $03
C44F: A5 04    lda $04
C451: 69 00    adc #$00
C453: 85 04    sta $04
C455: E8       inx
C456: E8       inx
C457: E8       inx
C458: E0 21    cpx #$21
C45A: 90 DC    bcc $c438
C45C: A2 03    ldx #$03
C45E: 20 4E C9 jsr $c94e
C461: A2 04    ldx #$04
C463: 20 4E C9 jsr $c94e
C466: A2 05    ldx #$05
C468: 20 4E C9 jsr $c94e
C46B: A2 06    ldx #$06
C46D: 20 4E C9 jsr $c94e
C470: A2 07    ldx #$07
C472: 20 4E C9 jsr $c94e
C475: 60       rts
C476: 85 F5    sta dummy_write_00f5
C478: EA       nop
C479: A9 FF    lda #$ff
C47B: 85 19    sta $19
C47D: 85 F5    sta dummy_write_00f5
C47F: EA       nop
C480: A9 01    lda #$01
C482: 85 1C    sta $1c
C484: 20 48 C7 jsr $c748
C487: 20 67 C7 jsr $c767
C48A: A0 01    ldy #$01
C48C: 84 68    sty $68
C48E: C8       iny
C48F: 84 69    sty $69
C491: C8       iny
C492: 84 6A    sty $6a
C494: A9 90    lda #$90
C496: 8D 02 18 sta $1802
C499: A9 4D    lda #$4d
C49B: 8D 03 18 sta $1803
C49E: A9 60    lda #$60
C4A0: 8D 06 18 sta $1806
C4A3: A9 3D    lda #$3d
C4A5: 8D 07 18 sta $1807
C4A8: A9 30    lda #$30
C4AA: 8D 0A 18 sta $180a
C4AD: A9 3D    lda #$3d
C4AF: 8D 0B 18 sta $180b
C4B2: A9 40    lda #$40
C4B4: 85 A9    sta $a9
C4B6: 85 AA    sta $aa
C4B8: 85 AB    sta $ab
C4BA: 85 B0    sta $b0
C4BC: A9 04    lda #$04
C4BE: 85 A8    sta game_speed_00a8
C4C0: 85 BA    sta $ba
C4C2: A9 18    lda #$18
C4C4: 8D 1E 18 sta $181e
C4C7: A9 1D    lda #$1d
C4C9: 8D 1F 18 sta $181f
C4CC: 20 65 DD jsr $dd65
C4CF: 85 F5    sta dummy_write_00f5
C4D1: EA       nop
C4D2: A2 01    ldx #$01
C4D4: 20 2C CA jsr $ca2c
C4D7: E6 13    inc timer1_0013
C4D9: A2 07    ldx #$07
C4DB: 20 C3 D3 jsr $d3c3
C4DE: F0 04    beq $c4e4
C4E0: 60       rts
C4E1: 85 F5    sta dummy_write_00f5
C4E3: EA       nop
C4E4: A2 07    ldx #$07
C4E6: 20 69 D2 jsr $d269
C4E9: 20 98 D8 jsr $d898
C4EC: 20 8D EA jsr $ea8d
C4EF: 20 90 E1 jsr $e190
C4F2: A5 19    lda $19
C4F4: D0 06    bne $c4fc
C4F6: 4C D2 C4 jmp $c4d2
C4F9: 85 F5    sta dummy_write_00f5
C4FB: EA       nop
C4FC: A2 0F    ldx #$0f
C4FE: A0 C5    ldy #$c5
C500: 20 BC C9 jsr $c9bc
C503: A2 FF    ldx #$ff
C505: 20 2C CA jsr $ca2c
C508: A9 00    lda #$00
C50A: 85 19    sta $19
C50C: A4 80    ldy $80
C50E: C4 86    cpy $86
C510: 11 3B    ora ($3b), y
C512: 40       rti
C513: 60       rts
C514: 36 3D    
C516: 42       
C517: 00       
C518: 32       
C519: 3D 35 61 
C51C: 62       
C51D: FE 86 15 
C520: 00       
C521: 00       
C522: 00       
C523: 00       
C524: 00       
C525: 00       
C526: 00       
C527: 00       
C528: 00       
C529: 00       
C52A: 00       
C52B: 00       
C52C: FE CE 10 
C52F: 3B 40 60 
C532: 3E 37 31 
C535: 39 3A 33 
C538: 61 62    
C53A: FE CE 14 
C53D: 00       
C53E: 00       
C53F: 00       
C540: 00       
C541: 00       
C542: 00       
C543: 00       
C544: 00       
C545: 00       
C546: 00       
C547: 00       
C548: FE 56 11 
C54B: 3B 40 60 
C54E: 33 35    
C550: 35 61    
C552: 62       
C553: FE 56 15 
C556: 00       
C557: 00       
C558: 00       
C559: 00       
C55A: 00       
C55B: 00       
C55C: 00       
C55D: 00       
C55E: FF 85 F5 
C561: EA       nop
C562: 20 48 C7 jsr $c748
C565: 20 67 C7 jsr $c767
C568: A0 01    ldy #$01
C56A: 84 68    sty $68
C56C: C0 69    cpy #$69
C56E: 64       nop
C56F: 84       sty $6a
C571: 84 6B    sty $6b
C573: C8       iny
C574: 84 6C    sty $6c
C576: C0 6D    cpy #$6d
C578: A9 1D    lda #$1d
C57A: 8D 03 18 sta $1803
C57D: C5 07    cmp $07
C57F: 18       clc
C580: 8D 0B 18 sta $180b
C583: 8D 0F 18 sta $180f
C586: C5 13    cmp timer1_0013
C588: 18       clc
C589: 8D 17 18 sta $1817
C58C: C5 1F    cmp current_player_001f
C58E: 18       clc
C58F: 4D 40 85 eor $8540
C592: A9 85    lda #$85
C594: AA       tax
C595: C1 AB    cmp ($ab, x)
C597: C1 AC    cmp ($ac, x)
C599: 85 AD    sta $ad
C59B: 85 AE    sta $ae
C59D: 4D 89 8D eor $8d89
C5A0: 02       kil
C5A1: 18       clc
C5A2: A9 59    lda #$59
C5A4: 8D 06 18 sta $1806
C5A7: 4D 60 8D eor $8d60
C5AA: 0A       asl a
C5AB: 18       clc
C5AC: 4D 90 8D eor $8d90
C5AE  sta $180e                                           8D 0E 18
C5B1  lda #$97                                            A9 97
C5B3  sta $1812                                           8D 12 18
C5B6  eor $8d30                                           4D 30 8D
C5B9  asl $18, x                                          16 18
C5BB  lda #$18                                            A9 18
C5BD  sta $181e                                           8D 1E 18
C5C0  lda #$01                                            A9 01
C5C2  sta $13                                             85 13
C5C4  cmp ($14, x)                                        C1 14
C5C6  php                                                 08
C5C7  adc $dd                                             65 DD
C5C9  sta dummy_write_00f5                                             85 F5
C5CB  nop                                                 EA
C5CC  ldx #$01                                            A2 01

C5AF: 0E 18 A9 asl $a918
C5B2: 97 8D    sax $8d, y
C5B4: 12       kil
C5B5: 18       clc
C5B6: 4D 30 8D eor $8d30
C5B9: 16 18    asl $18, x
C5BB: A9 18    lda #$18
C5BD: 8D 1E 18 sta $181e
C5C0: A9 01    lda #$01
C5C2: 85 13    sta timer1_0013
C5C4: C1 14    cmp ($14, x)
C5C6: 08       php
C5C7: 65 DD    adc $dd

C5C9: 85 F5    sta dummy_write_00f5
C5CB: EA       nop
C5CC: A2 01    ldx #$01
C5CE: 20 2C CA jsr $ca2c
C5D1: E6 13    inc timer1_0013
C5D3: D0 03    bne $c5d8
C5D5: E6 14    inc timer1_0014
C5D7: 6E A2 07 ror $07a2
C5DA: 20 C3 D3 jsr $d3c3
C5DD: F0 1B    beq $c5fa
C5DF: A5 14    lda timer1_0014
C5E1: C9 04    cmp #$04
C5E3: 90 3C    bcc $c621
C5E5: A2 30    ldx #$30
C5E7: A0 C6    ldy #$c6
C5E9: 20 BC C9 jsr $c9bc
C5EC: A2 FF    ldx #$ff
C5EE: 20 2C CA jsr $ca2c
C5F1: A2 40    ldx #$40
C5F3: 20 2C CA jsr $ca2c
C5F6: 60       rts
C5F7: 85 F5    sta dummy_write_00f5
C5F9: EA       nop
C5FA: A5 6E    lda $6e
C5FC: 10 23    bpl $c621
C5FE: A2 07    ldx #$07
C600: 20 69 D2 jsr $d269
C603: AD 1E 18 lda $181e
C606: C9 22    cmp #$22
C608: F0 0B    beq $c615
C60A: C9 4A    cmp #$4a
C60C: F0 07    beq $c615
C60E: C9 82    cmp #$82
C610: D0 0F    bne $c621
C612: 85 F5    sta dummy_write_00f5
C614: EA       nop
C615: 20 AD D1 jsr $d1ad
C618: EE 1E 18 inc $181e
C61B: EE 1E 18 inc $181e
C61E: 85 F5    sta dummy_write_00f5
C620: EA       nop
C621: 20 96 D7 jsr $d796
C624: 20 98 D8 jsr $d898
C627: 20 DF E6 jsr $e6df
C62A: 20 90 E1 jsr $e190
C62D: 4C CC C5 jmp $c5cc
C630: C7 10    
C632: 32       
C633: 3D 3C 64 
C636: 42       
C637: 00       
C638: 45 2F    
C63A: 41 42    
C63C: 33 00    
C63E: 3E 33 3E 
C641: 3E 33 40 
C644: 41 FE    
C646: C7 14    
C648: 00       
C649: 00       
C64A: 00       
C64B: 00       
C64C: 00       
C64D: 00       
C64E: 00       
C64F: 00       
C650: 00       
C651: 00       
C652: 00       
C653: 00       
C654: 00       
C655: 00       
C656: 00       
C657: 00       
C658: 00       
C659: 00       
C65A: 00       
C65B: FE 04 11 
C65E: 47 3D    
C660: 43 00    
C662: 41 42    
C664: 2F 40 42 
C667: 00       
C668: 45 37    
C66A: 42       
C66B: 36 00    
C66D: 3D 3C 3A 
C670: 47 00    
C672: 34 37    
C674: 44 33    
C676: FE 04 15 
C679: 00       
C67A: 00       
C67B: 00       
C67C: 00       
C67D: 00       
C67E: 00       
C67F: 00       
C680: 00       
C681: 00       
C682: 00       
C683: 00       
C684: 00       
C685: 00       
C686: 00       
C687: 00       
C688: 00       
C689: 00       
C68A: 00       
C68B: 00       
C68C: 00       
C68D: 00       
C68E: 00       
C68F: 00       
C690: 00       
C691: FE 42 11 
C694: 33 2F    
C696: 40       
C697: 3C 00 33 
C69A: 46 42    
C69C: 40       
C69D: 2F 00 3E 
C6A0: 33 3E    
C6A2: 3E 33 40 
C6A5: 41 00    
C6A7: 63 00    
C6A9: 30 3D    
C6AB: 3C 43 41 
C6AE: 33 41    
C6B0: FE 42 15 
C6B3: 00       
C6B4: 00       
C6B5: 00       
C6B6: 00       
C6B7: 00       
C6B8: 00       
C6B9: 00       
C6BA: 00       
C6BB: 00       
C6BC: 00       
C6BD: 00       
C6BE: 00       
C6BF: 00       
C6C0: 00       
C6C1: 00       
C6C2: 00       
C6C3: 00       
C6C4: 00       
C6C5: 00       
C6C6: 00       
C6C7: 00       
C6C8: 00       
C6C9: 00       
C6CA: 00       
C6CB: 00       
C6CC: 00       
C6CD: 00       
C6CE: 00       
C6CF: FE 83 11 
C6D2: 31 3A    
C6D4: 2F 37 3B 
C6D7: 00       
C6D8: 31 3D    
C6DA: 3C 33 41 
C6DD: 4A       
C6DE: 31 3D    
C6E0: 34 34    
C6E2: 33 33    
C6E4: 41 00    
C6E6: 63 00    
C6E8: 34 40    
C6EA: 37 33    
C6EC: 41 FE    
C6EE: 83 15    
C6F0: 00
C6F1: 00
C6F2: 00
C6F3: 00
C6F4: 00
C6F5: 00
C6F6: 00
C6F7: 00
C6F8: 00
C6F9: 00
C6FA: 00
C6FB: 00
C6FC: 00
C6FD: 00
C6FE: 00
C6FF: 00
C700: 00
C701: 00
C702: 00
C703: 00
C704: 00
C705: 00
C706: 00
C707: 00
C708: 00
C709: 00
C70A: FF 85 F5

C70D: 6E AD 04 ror $04ad
C710: 40       rti
C711: 49 FF    eor #$ff
C713: A8       tay
C714: A2 02    ldx #$02
C716: 29 01    and #$01
C718: F0 05    beq $c71f
C71A: A2 04    ldx #$04
C71C: 85 F5    sta dummy_write_00f5
C71E: 6E 86 29 ror $2986
C721: 86 2A    stx $2a
C723: 98       tya
C724: 4A       lsr a
C725: 29 03    and #$03
C727: AA       tax
C728: BD 3E C7 lda $c73e, x
C72B: 85 5A    sta $5a
C72D: C1 5C    cmp ($5c, x)
C72F: C1 5E    cmp ($5e, x)
C731: BD 42 C7 lda $c742, x
C734: 85 5B    sta $5b
C736: C1 5D    cmp ($5d, x)
C738: 85 5F    sta $5f
C73A: 20 C3 EB jsr $ebc3
C73D: 60       rts
C73E: 00       brk
C73F: 50 00    bvc $c741
C741: 00       brk
C742: 01 01    ora ($01, x)
C744: 02       kil
C745: 03 85    slo ($85, x)
C747: F7 EA    isb $ea, x
C749: A9 01    lda #$01
C74B: 85 61    sta $61
C74D: C1 62    cmp ($62, x)
C74F: 4D 04 20 eor $2004
C752: 5D EA A9 eor $a9ea, x
C755: 00       brk
C756: 85 65    sta $65
C758: 85 66    sta $66
C75A: 85 1F    sta current_player_001f
C75C: 08       php
C75D: 0F CC 20 slo $20cc
C760: 03 C3    slo ($c3, x)
C762: C6 61    dec $61
C764: 28       plp
C765: 85 F5    sta dummy_write_00f5
C767: 6E 20 A3 ror $a320
C76A: C8       iny
C76B: A5 20    lda $20
C76D: D0 2C    bne $c79b
C76F: A9 04    lda #$04
C771: 20 5D EA jsr $ea5d
C774: AD 04 40 lda $4004
C777: 29 10    and #$10
C779: D0 12    bne $c78d
C77B: A5 1B    lda $1b
C77D: F0 0E    beq $c78d
C77F: A6 1F    ldx current_player_001f
C781: B5 2B    lda player_pepper_002b, x
C783: 18       clc
C784: F8       sed
C785: 69 01    adc #$01
C787: 95 2B    sta player_pepper_002b, x
C789: D8       cld
C78A: 85 F6    sta $f6
C78C: 6E A6 1F ror $1fa6
C78F: F6 61    inc $61, x
C791: A9 00    lda #$00
C793: 95 65    sta $65, x
C795: 08       php
C796: 0F CC 85 slo $85cc
C799: F5 EA    sbc $ea, x
C79B: A9 00    lda #$00
C79D: 85 20    sta $20
C79F: 08       php
C7A0: 64 CC    nop $cc
C7A2: A6 1F    ldx current_player_001f
C7A4: B4 61    ldy $61, x
C7A6: 88       dey
C7A7: 85 F5    sta dummy_write_00f5
C7A9: EA       nop
C7AA: C0 06    cpy #$06
C7AC: 90 0B    bcc $c7b9
C7AE: 98       tya
C7AF: 38       sec
C7B0: E9 06    sbc #$06
C7B2: A8       tay
C7B3: 4C AA C7 jmp $c7aa
C7B6: 85 F5    sta dummy_write_00f5
C7B8: EA       nop
C7B9: 84 63    sty $63
C7BB: B4 61    ldy $61, x
C7BD: 88       dey
C7BE: C0 06    cpy #$06
C7C0: 90 05    bcc $c7c7
C7C2: A0 05    ldy #$05
C7C4: 85 F5    sta dummy_write_00f5
C7C6: 6E 84 64 ror $6484
C7C9: A4 63    ldy $63
C7CB: B9 EF CD lda $cdef, y
C7CE: 8D 1C 18 sta $181c
C7D1: B9 F7 CD lda $cdf7, y
C7D4: 8D 1D 18 sta $181d
C7D7: 5D FF CD eor $cdff, x
C7DA: 8D 1E 18 sta $181e
C7DD: 5D 07 CE eor $ce07, x
C7E0: 8D 1F 18 sta $181f
C7E3: A2 07    ldx #$07
C7E5: A9 FF    lda #$ff
C7E7: 85 F5    sta dummy_write_00f5
C7E9: EA       nop
C7EA: 95 68    sta $68, x
C7EC: 66 10    ror $10
C7EE: FB A2 07 isb $07a2, y
C7F1: A9 01    lda #$01
C7F3: 85 F5    sta dummy_write_00f5
C7F5: 6E 95 99 ror $9995
C7F8: CA       dex
C7F9: 10 FB    bpl $c7f6
C7FB: A2 07    ldx #$07
C7FD: A9 04    lda #$04
C7FF: 85 F5    sta dummy_write_00f5
C801: EA       nop
C802: 95 A1    sta $a1, x
C804: CA       dex
C805: 10 FB    bpl $c802
C807: A2 07    ldx #$07
C809: A9 00    lda #$00
C80B: 85 F5    sta dummy_write_00f5
C80D: EA       nop
C80E: 95 A9    sta $a9, x
C810: CA       dex
C811: 10 FB    bpl $c80e
C813: 85 6F    sta game_state_006f
C815: A9 03    lda #$03
C817: 85 A8    sta game_speed_00a8
C819: A9 00    lda #$00
C81B: 85 C5    sta $c5
C81D: 85 C4    sta $c4
C81F: 20 89 DA jsr $da89
C822: 20 C6 C8 jsr $c8c6
C825: A5 21    lda $21
C827: F0 0B    beq $c834
C829: A5 1F    lda current_player_001f
C82B: 49 01    eor #$01
C82D: AA       tax
C82E: 20 4E C9 jsr $c94e
C831: 85 F5    sta dummy_write_00f5
C833: EA       nop
C834: A6 1F    ldx current_player_001f
C836: 20 4E C9 jsr $c94e
C839: A2 02    ldx #$02
C83B: 20 4E C9 jsr $c94e
C83E: 20 54 CA jsr $ca54
C841: 20 94 CA jsr $ca94
C844: A6 1F    ldx current_player_001f
C846: 20 C4 CA jsr $cac4
C849: 20 1E CB jsr $cb1e
C84C: A9 3E    lda #$3e
C84E: 85 13    sta timer1_0013
C850: A5 1B    lda $1b
C852: F0 04    beq $c858
C854: 60       rts
C855: 85 F5    sta dummy_write_00f5
C857: EA       nop
C858: A9 01    lda #$01
C85A: 85 68    sta $68
C85C: A9 02    lda #$02
C85E: 85 69    sta $69
C860: A9 03    lda #$03
C862: 85 6A    sta $6a
C864: A9 90    lda #$90
C866: 8D 02 18 sta $1802
C869: A9 4D    lda #$4d
C86B: 8D 03 18 sta $1803
C86E: A9 60    lda #$60
C870: 8D 06 18 sta $1806
C873: A9 3D    lda #$3d
C875: 8D 07 18 sta $1807
C878: A9 30    lda #$30
C87A: 8D 0A 18 sta $180a
C87D: A9 3D    lda #$3d
C87F: 8D 0B 18 sta $180b
C882: A9 80    lda #$80
C884: 85 A9    sta $a9
C886: 85 AA    sta $aa
C888: 85 AB    sta $ab
C88A: A9 40    lda #$40
C88C: 85 B0    sta $b0
C88E: A9 18    lda #$18
C890: 8D 1E 18 sta $181e
C893: A9 1D    lda #$1d
C895: 8D 1F 18 sta $181f
C898: A9 FF    lda #$ff
C89A: 85 A1    sta $a1
C89C: 85 A2    sta $a2
C89E: 85 A3    sta $a3
C8A0: 60       rts
C8A1: 85 F6    sta $f6
C8A3: EA       nop
C8A4: A0 00    ldy #$00
C8A6: 84 03    sty $03
C8A8: A9 10    lda #$10
C8AA: 85 04    sta $04
C8AC: 85 F6    sta $f6
C8AE: EA       nop
C8AF: A9 00    lda #$00
C8B1: 91 03    sta ($03), y
C8B3: C8       iny
C8B4: D0 F9    bne $c8af
C8B6: E6 04    inc $04
C8B8: A5 04    lda $04
C8BA: C9 18    cmp #$18
C8BC: D0 F1    bne $c8af
C8BE: A2 01    ldx #$01
C8C0: 20 2C CA jsr $ca2c
C8C3: 60       rts
C8C4: 85 F5    sta dummy_write_00f5
C8C6: EA       nop
C8C7: A2 35    ldx #$35
C8C9: A0 C9    ldy #$c9
C8CB: 20 BC C9 jsr $c9bc
C8CE: A2 29    ldx #$29
C8D0: A0 C9    ldy #$c9
C8D2: 20 BC C9 jsr $c9bc
C8D5: A5 21    lda $21
C8D7: F0 0A    beq $c8e3
C8D9: A2 40    ldx #$40
C8DB: A0 C9    ldy #$c9
C8DD: 20 BC C9 jsr $c9bc
C8E0: 85 F5    sta dummy_write_00f5
C8E2: EA       nop
C8E3: 60       rts
C8E4: 85 F5    sta dummy_write_00f5
C8E6: EA       nop
C8E7: A5 21    lda $21
C8E9: F0 3D    beq $c928
C8EB: A5 13    lda timer1_0013
C8ED: 29 3F    and #$3f
C8EF: D0 1A    bne $c90b
C8F1: A5 1F    lda current_player_001f
C8F3: D0 0B    bne $c900
C8F5: A2 2F    ldx #$2f
C8F7: A0 C9    ldy #$c9
C8F9: 20 BC C9 jsr $c9bc
C8FC: 60       rts
C8FD: 85 F5    sta dummy_write_00f5
C8FF: EA       nop
C900: A2 46    ldx #$46
C902: A0 C9    ldy #$c9
C904: 20 BC C9 jsr $c9bc
C907: 60       rts
C908: 85 F5    sta dummy_write_00f5
C90A: EA       nop
C90B: C9 0F    cmp #$0f
C90D: D0 19    bne $c928
C90F: A5 1F    lda current_player_001f
C911: D0 0B    bne $c91e
C913: A2 29    ldx #$29
C915: A0 C9    ldy #$c9
C917: 20 BC C9 jsr $c9bc
C91A: 60       rts
C91B: 85 F5    sta dummy_write_00f5
C91D: 6E A2 40 ror $40a2
C920: A0 C9    ldy #$c9
C922: 20 BC C9 jsr $c9bc
C925: 85 F5    sta dummy_write_00f5
C927: 6E 60 24 ror $2460
C92A: 10 26    bpl $c952
C92C: 43 3E    sre ($3e, x)
C92E: FF 24 10 isb $1024, x
C931: 00       brk
C932: 00       brk
C933: 00       brk
C934: FF 29 10 isb $1029, x
C937: 36 37    rol $37, x
C939: 49 41    eor #$41
C93B: 31 3D    and ($3d), y
C93D: 40       rti
C93E: 33 FF    rla ($ff), y
C940: 34 10    nop $10, x
C942: 27 43    rla $43
C944: 3E FF 34 rol $34ff, x
C947: 10 00    bpl $c949
C949: 00       brk
C94A: 00       brk
C94B: FF 85 F5 isb $f585, x
C94E: 6E 86 03 ror $0386
C951: 8A       txa
C952: 0A       asl a
C953: A8       tay
C954: 18       clc
C955: 65 03    adc $03
C957: AA       tax
C958: 85 F5    sta dummy_write_00f5
C95A: EA       nop
C95B: B9 A0 C9 lda $c9a0, y
C95E: 85 03    sta $03
C960: B9 A1 C9 lda $c9a1, y
C963: 85 04    sta $04
C965: 48       pha
C966: 05 85    ora $85
C968: F5 EA    sbc $ea, x
C96A: B5 2D    lda $2d, x
C96C: 29 0F    and #$0f
C96E: 85 05    sta $05
C970: E6 05    inc $05
C972: A5 05    lda $05
C974: 91 03    sta ($03), y
C976: 44 B5    nop $b5
C978: 2D 4A 4A and $4a4a
C97B: 4A       lsr a
C97C: 4A       lsr a
C97D: 85 05    sta $05
C97F: EA       nop
C980: 05 A5    ora $a5
C982: 05 91    ora $91
C984: 03 6C    slo ($6c, x)
C986: 88       dey
C987: 10 E1    bpl $c96a
C989: C8       iny
C98A: 85 F5    sta dummy_write_00f5
C98C: 6E B1 03 ror $03b1
C98F: C9 01    cmp #$01
C991: D0 0C    bne $c99f
C993: A9 00    lda #$00
C995: 91 03    sta ($03), y
C997: 64 C0    nop $c0
C999: 05 D0    ora $d0
C99B: F1 85    sbc ($85), y
C99D: F5 6E    sbc $6e, x
C99F: 60       rts
C9A0: 42       kil
C9A1: 10 52    bpl $c9f5
C9A3: 10 4A    bpl $c9ef
C9A5: 10 CD    bpl $c974
C9A7: 11 0D    ora ($0d), y
C9A9: 12       kil
C9AA: 4D 12 8D eor $8d12
C9AD: 12       kil
C9AE: CD 12 92 cmp $9212
C9B1: 12       kil
C9B2: D2       kil
C9B3: 12       kil
C9B4: 12       kil
C9B5: 13 52    slo ($52), y
C9B7: 13 92    slo ($92), y
C9B9: 13 85    slo ($85), y
C9BB: F6 6E    inc $6e, x
C9BD: 86 03    stx $03
C9BF: C0 04    cpy #$04
C9C1: 85 F6    sta $f6
C9C3: EA       nop
C9C4: A0 00    ldy #$00
C9C6: 84 08    sty $08
C9C8: B1 03    lda ($03), y
C9CA: 85 05    sta $05
C9CC: 64 B1    nop $b1
C9CE: 03 85    slo ($85, x)
C9D0: 06 85    asl $85
C9D2: F6 EA    inc $ea, x
C9D4: C8       iny
C9D5: B1 03    lda ($03), y
C9D7: C9 FF    cmp #$ff
C9D9: F0 4A    beq $ca25
C9DB: C9 FE    cmp #$fe
C9DD: F0 1D    beq $c9fc
C9DF: C9 FD    cmp #$fd
C9E1: F0 2C    beq $ca0f
C9E3: 84 07    sty $07
C9E5: C8       iny
C9E6: 08       php
C9E7: 91 05    sta ($05), y
C9E9: E6 08    inc $08
C9EB: A4 07    ldy $07
C9ED: A5 C8    lda $c8
C9EF: F0 E3    beq $c9d4
C9F1: A2 0A    ldx #$0a
C9F3: 20 2C CA jsr $ca2c
C9F6: 4C D4 C9 jmp $c9d4
C9F9: 85 F6    sta $f6
C9FB: EA       nop
C9FC: C8       iny
C9FD: 18       clc
C9FE: 98       tya
C9FF: 65 03    adc $03
CA01: 85 03    sta $03
CA03: A5 04    lda $04
CA05: 69 00    adc #$00
CA07: 85 04    sta $04
CA09: 4C C4 C9 jmp $c9c4
CA0C: 85 F6    sta $f6
CA0E: EA       nop
CA0F: 18       clc
CA10: A5 05    lda $05
CA12: 69 20    adc #$20
CA14: 85 05    sta $05
CA16: A5 06    lda $06
CA18: 69 00    adc #$00
CA1A: 85 06    sta $06
CA1C: A9 00    lda #$00
CA1E: 85 08    sta $08
CA20: F0 B2    beq $c9d4
CA22: 85 F6    sta $f6
CA24: EA       nop
CA25: A9 00    lda #$00
CA27: 85 C8    sta $c8
CA29: 60       rts
CA2A: 85 F6    sta $f6
CA2C: EA       nop
CA2D: AD 03 40 lda $4003
CA30: 10 FB    bpl $ca2d
CA32: 58       cli
CA33: EA       nop
CA34: EA       nop
CA35: EA       nop
CA36: EA       nop
CA37: 78       sei
CA38: 20 45 D0 jsr $d045
CA3B: A5 1A    lda $1a
CA3D: F0 0A    beq $ca49
CA3F: 8A       txa
CA40: 48       pha
CA41: 20 6E D0 jsr $d06e
CA44: 68       pla
CA45: AA       tax
CA46: 85 F6    sta $f6
CA48: EA       nop
CA49: AD 03 40 lda $4003
CA4C: 30 FB    bmi $ca49
CA4E: CA       dex
CA4F: D0 DC    bne $ca2d
CA51: 60       rts
CA52: 85 F5    sta dummy_write_00f5
CA54: EA       nop
CA55: A6 1F    ldx current_player_001f
CA57: 38       sec
CA58: A9 5C    lda #$5c
CA5A: F5 29    sbc player_lives_0029, x
CA5C: 85 F3    sta $f3
CA5E: A9 18    lda #$18
CA60: 85 F4    sta $f4
CA62: B5 29    lda player_lives_0029, x
CA64: C9 09    cmp #$09
CA66: B0 16    bcs $ca7e
CA68: A0 10    ldy #$10
CA6A: A9 00    lda #$00
CA6C: 99 4C 18 sta $184c, y
CA6F: 88       dey
CA70: D0 FA    bne $ca6c
CA72: B4 29    ldy player_lives_0029, x
CA74: F0 07    beq $ca7d
CA76: A9 C8    lda #$c8
CA78: 91 F3    sta ($f3), y
CA7A: 88       dey
CA7B: D0 FB    bne $ca78
CA7D: 60       rts
CA7E: A0 09    ldy #$09
CA80: A9 53    lda #$53
CA82: 85 F3    sta $f3
CA84: 4C 76 CA jmp $ca76
CA87: F6 EA    inc $ea, x
CA89: 91 F3    sta ($f3), y
CA8B: 88       dey
CA8C: D0 FB    bne $ca89
CA8E: 85 F7    sta $f7
CA90: EA       nop
CA91: 60       rts
CA92: 85 F5    sta dummy_write_00f5
CA94: EA       nop
CA95: 98       tya
CA96: 48       pha
CA97: A0 51    ldy #$51
CA99: 8C 3A 10 sty $103a
CA9C: C8       iny
CA9D: 8C 3B 10 sty $103b
CAA0: C8       iny
CAA1: 8C 3C 10 sty $103c
CAA4: A6 1F    ldx current_player_001f
CAA6: B5 2B    lda player_pepper_002b, x
CAA8: 4A       lsr a
CAA9: 4A       lsr a
CAAA: 4A       lsr a
CAAB: 4A       lsr a
CAAC: A8       tay
CAAD: F0 04    beq $cab3
CAAF: C8       iny
CAB0: 85 F5    sta dummy_write_00f5
CAB2: EA       nop
CAB3: 8C 5B 10 sty $105b
CAB6: B5 2B    lda player_pepper_002b, x
CAB8: 29 0F    and #$0f
CABA: A8       tay
CABB: C8       iny
CABC: 8C 5C 10 sty $105c
CABF: 68       pla
CAC0: A8       tay
CAC1: 60       rts
CAC2: 85 F5    sta dummy_write_00f5
CAC4: EA       nop
CAC5: B5 61    lda $61, x
CAC7: 85 03    sta $03
CAC9: AD 1A CB lda $cb1a
CACC: 85 04    sta $04
CACE: AD 1B CB lda $cb1b
CAD1: 85 05    sta $05
CAD3: A9 04    lda #$04
CAD5: 85 06    sta $06
CAD7: A0 80    ldy #$80
CAD9: 85 F5    sta dummy_write_00f5
CADB: EA       nop
CADC: A6 03    ldx $03
CADE: E0 0A    cpx #$0a
CAE0: 90 0D    bcc $caef
CAE2: A5 03    lda $03
CAE4: E9 0A    sbc #$0a
CAE6: 85 03    sta $03
CAE8: A9 C6    lda #$c6
CAEA: D0 1F    bne $cb0b
CAEC: 85 F5    sta dummy_write_00f5
CAEE: EA       nop
CAEF: E0 05    cpx #$05
CAF1: 90 0D    bcc $cb00
CAF3: A5 03    lda $03
CAF5: E9 05    sbc #$05
CAF7: 85 03    sta $03
CAF9: A9 C5    lda #$c5
CAFB: D0 0E    bne $cb0b
CAFD: 85 F5    sta dummy_write_00f5
CAFF: EA       nop
CB00: E0 01    cpx #$01
CB02: 90 15    bcc $cb19
CB04: C6 03    dec $03
CB06: 4D C4 85 eor $85c4
CB09: F5 EA    sbc $ea, x
CB0B: 91 04    sta ($04), y
CB0D: 54 38    nop $38, x
CB0F: E9 20    sbc #$20
CB11: A8       tay
CB12: C6 06    dec $06
CB14: 10 C6    bpl $cadc
CB16: 85 F5    sta dummy_write_00f5
CB18: EA       nop
CB19: 60       rts
CB1A: 1D 13 85 ora $8513, x
CB1D: F5 6E    sbc $6e, x
CB1F: 20 E3 CB jsr $cbe3
CB22: A5 63    lda $63
CB24: 0A       asl a
CB25: A8       tay
CB26: B9 D7 CD lda $cdd7, y
CB29: 85 03    sta $03
CB2B: B9 D8 CD lda $cdd8, y
CB2E: 85 04    sta $04
CB30: A9 10    lda #$10
CB32: 85 05    sta $05
CB34: 4D 04 85 eor $8504
CB37: 06 A2    asl $a2
CB39: 68       pla
CB3A: A0 00    ldy #$00
CB3C: 85 F5    sta dummy_write_00f5
CB3E: 6E B1 03 ror $03b1
CB41: 29 F0    and #$f0
CB43: 11 05    ora ($05), y
CB45: 91 05    sta ($05), y
CB47: EA       nop
CB48: 05 B1    ora $b1
CB4A: 03 0A    slo ($0a, x)
CB4C: 0A       asl a
CB4D: 0A       asl a
CB4E: 0A       asl a
CB4F: 11 05    ora ($05), y
CB51: 91 05    sta ($05), y
CB53: E6 05    inc $05
CB55: EA       nop
CB56: 03 70    slo ($70, x)
CB58: 05 E6    ora $e6
CB5A: 04 85    nop $85
CB5C: F5 6E    sbc $6e, x
CB5E: CA       dex
CB5F: A5 05    lda $05
CB61: 29 07    and #$07
CB63: D0 DA    bne $cb3f
CB65: 18       clc
CB66: A5 05    lda $05
CB68: 69 7F    adc #$7f
CB6A: 85 05    sta $05
CB6C: C9 06    cmp #$06
CB6E: 69 00    adc #$00
CB70: 85 06    sta $06
CB72: 85 F5    sta dummy_write_00f5
CB74: 6E B1 03 ror $03b1
CB77: 29 F0    and #$f0
CB79: 11 05    ora ($05), y
CB7B: 91 05    sta ($05), y
CB7D: E2 05    nop #$05
CB7F: 59 03 0A eor $0a03, y
CB82: 0A       asl a
CB83: 0A       asl a
CB84: 0A       asl a
CB85: 11 05    ora ($05), y
CB87: 91 05    sta ($05), y
CB89: C6 05    dec $05
CB8B: E6 03    inc $03
CB8D: 70 05    bvs $cb94
CB8F: E6 04    inc $04
CB91: 85 F5    sta dummy_write_00f5
CB93: EA       nop
CB94: CA       dex
CB95: A5 05    lda $05
CB97: 29 07    and #$07
CB99: C9 07    cmp #$07
CB9B: D0 D8    bne $cb75
CB9D: 38       sec
CB9E: A5 05    lda $05
CBA0: E9 77    sbc #$77
CBA2: 85 05    sta $05
CBA4: C9 06    cmp #$06
CBA6: E9 00    sbc #$00
CBA8: 85 06    sta $06
CBAA: E0 00    cpx #$00
CBAC: D0 91    bne $cb3f
CBAE: A5 63    lda $63
CBB0: 29 0F    and #$0f
CBB2: 85 F3    sta $f3
CBB4: 46 48    lsr $48
CBB6: CD 03 40 cmp $4003
CBB9: 29 40    and #$40
CBBB: F0 07    beq $cbc4
CBBD: A5 1F    lda current_player_001f
CBBF: D0 13    bne $cbd4
CBC1: 85 F5    sta dummy_write_00f5
CBC3: EA       nop
CBC4: A6 F3    ldx $f3
CBC6: BD D9 CB lda $cbd9, x
CBC9: 09 10    ora #$10
CBCB: 8D 04 40 sta $4004
CBCE: 2C AA 60 bit $60aa
CBD1: 85 F5    sta dummy_write_00f5
CBD3: EA       nop
CBD4: A5 F3    lda $f3
CBD6: 4C C9 CB jmp $cbc9
CBD9: 03 00    slo ($00, x)
CBDB: 01 02    ora ($02, x)
CBDD: 07 04    slo $04
CBDF: 05 06    ora $06
CBE1: 85 F5    sta dummy_write_00f5
CBE3: EA       nop
CBE4: A0 00    ldy #$00
CBE6: A9 04    lda #$04
CBE8: 85 04    sta $04
CBEA: A9 00    lda #$00
CBEC: 85 03    sta $03
CBEE: C1 F5    cmp (dummy_write_00f5, x)
CBF0: EA       nop
CBF1: B1 03    lda ($03), y
CBF3: 29 0F    and #$0f
CBF5: 91 03    sta ($03), y
CBF7: 64 D0    nop $d0
CBF9: F7 E6    isb $e6, x
CBFB: 04 CA    nop $ca
CBFD: 04 E0    nop $e0
CBFF: 08       php
CC00: D0 EF    bne $cbf1
CC02: A9 00    lda #$00
CC04: 8D 04 40 sta $4004
CC07: A2 01    ldx #$01
CC09: 20 2C CA jsr $ca2c
CC0C: 60       rts
CC0D: 85 F5    sta dummy_write_00f5
CC0F: EA       nop
CC10: A6 1F    ldx current_player_001f
CC12: B4 61    ldy $61, x
CC14: 88       dey
CC15: 85 F5    sta dummy_write_00f5
CC17: EA       nop
CC18: C0 06    cpy #$06
CC1A: 90 0B    bcc $cc27
CC1C: 98       tya
CC1D: 38       sec
CC1E: E9 06    sbc #$06
CC20: A8       tay
CC21: 4C 18 CC jmp $cc18
CC24: 85 F5    sta dummy_write_00f5
CC26: EA       nop
CC27: 98       tya
CC28: 0A       asl a
CC29: A8       tay
CC2A: B9 E3 CD lda $cde3, y
CC2D: 85 03    sta $03
CC2F: B9 E4 CD lda $cde4, y
CC32: 85 04    sta $04
CC34: A0 00    ldy #$00
CC36: A2 00    ldx #$00
CC38: 85 F5    sta dummy_write_00f5
CC3A: EA       nop
CC3B: B1 03    lda ($03), y
CC3D: C9 FF    cmp #$ff
CC3F: F0 18    beq $cc59
CC41: 9D 02 02 sta $0202, x
CC44: C8       iny
CC45: E8       inx
CC46: 8A       txa
CC47: 29 03    and #$03
CC49: C9 03    cmp #$03
CC4B: D0 EE    bne $cc3b
CC4D: E8       inx
CC4E: A9 00    lda #$00
CC50: 9D 02 02 sta $0202, x
CC53: 4C 3B CC jmp $cc3b
CC56: 85 F5    sta dummy_write_00f5
CC58: EA       nop
CC59: A9 00    lda #$00
CC5B: 9D 02 02 sta $0202, x
CC5E: E8       inx
CC5F: D0 F8    bne $cc59
CC61: 60       rts
CC62: 85 F7    sta $f7
CC64: EA       nop
CC65: A9 02    lda #$02
CC67: 85 0B    sta $0b
CC69: A9 02    lda #$02
CC6B: 85 0C    sta $0c
CC6D: A9 00    lda #$00
CC6F: 85 0D    sta $0d
CC71: 85 F7    sta $f7
CC73: EA       nop
CC74: A4 0D    ldy $0d
CC76: B1 0B    lda ($0b), y
CC78: F0 1C    beq $cc96
CC7A: 85 03    sta $03
CC7C: C8       iny
CC7D: B1 0B    lda ($0b), y
CC7F: 85 04    sta $04
CC81: C8       iny
CC82: B1 0B    lda ($0b), y
CC84: 85 05    sta $05
CC86: 20 99 CC jsr $cc99
CC89: A5 0D    lda $0d
CC8B: 18       clc
CC8C: 69 04    adc #$04
CC8E: 85 0D    sta $0d
CC90: 4C 74 CC jmp $cc74
CC93: 85 F7    sta $f7
CC95: EA       nop
CC96: 60       rts
CC97: 85 F5    sta dummy_write_00f5
CC99: EA       nop
CC9A: A9 00    lda #$00
CC9C: 85 0E    sta $0e
CC9E: F0 12    beq $ccb2
CCA0: 85 F5    sta dummy_write_00f5
CCA2: EA       nop
CCA3: A9 00    lda #$00
CCA5: 85 0E    sta $0e
CCA7: A5 05    lda $05
CCA9: 29 F8    and #$f8
CCAB: D0 05    bne $ccb2
CCAD: E6 0E    inc $0e
CCAF: 85 F5    sta dummy_write_00f5
CCB1: EA       nop
CCB2: 98       tya
CCB3: 48       pha
CCB4: A5 03    lda $03
CCB6: 29 0F    and #$0f
CCB8: 0A       asl a
CCB9: AA       tax
CCBA: BD B7 CD lda $cdb7, x
CCBD: 85 07    sta $07
CCBF: A5 05    lda $05
CCC1: 29 07    and #$07
CCC3: 0A       asl a
CCC4: 0A       asl a
CCC5: 18       clc
CCC6: 65 07    adc $07
CCC8: 85 07    sta $07
CCCA: BD B8 CD lda $cdb8, x
CCCD: 85 08    sta $08
CCCF: A5 04    lda $04
CCD1: 49 FF    eor #$ff
CCD3: 85 04    sta $04
CCD5: 46 04    lsr $04
CCD7: 46 04    lsr $04
CCD9: 46 04    lsr $04
CCDB: A9 00    lda #$00
CCDD: 85 06    sta $06
CCDF: A5 05    lda $05
CCE1: 29 F8    and #$f8
CCE3: 85 05    sta $05
CCE5: 06 05    asl $05
CCE7: 26 06    rol $06
CCE9: 06 05    asl $05
CCEB: 26 06    rol $06
CCED: 18       clc
CCEE: A5 05    lda $05
CCF0: 65 04    adc $04
CCF2: 85 05    sta $05
CCF4: A5 06    lda $06
CCF6: 69 10    adc #$10
CCF8: 85 06    sta $06
CCFA: A5 03    lda $03
CCFC: 29 0F    and #$0f
CCFE: C9 0F    cmp #$0f
CD00: F0 35    beq $cd37
CD02: A0 00    ldy #$00
CD04: A5 07    lda $07
CD06: AA       tax
CD07: 20 95 CD jsr $cd95
CD0A: A4 0E    ldy $0e
CD0C: D0 0C    bne $cd1a
CD0E: A0 20    ldy #$20
CD10: 18       clc
CD11: 69 1D    adc #$1d
CD13: AA       tax
CD14: 20 95 CD jsr $cd95
CD17: 85 F5    sta dummy_write_00f5
CD19: EA       nop
CD1A: 18       clc
CD1B: A5 06    lda $06
CD1D: 69 04    adc #$04
CD1F: 85 06    sta $06
CD21: A0 00    ldy #$00
CD23: A5 08    lda $08
CD25: 20 AA CD jsr $cdaa
CD28: A4 0E    ldy $0e
CD2A: D0 64    bne $cd90
CD2C: A0 20    ldy #$20
CD2E: 20 AA CD jsr $cdaa
CD31: 4C 90 CD jmp $cd90
CD34: 85 F5    sta dummy_write_00f5
CD36: 6E 38 A5 ror $a538
CD39: 05 E9    ora $e9
CD3B: 21 85    and ($85, x)
CD3D: 05 C9    ora $c9
CD3F: 06 E9    asl $e9
CD41: 00       brk
CD42: 85 06    sta $06
CD44: 48       pha
CD45: 00       brk
CD46: A5 07    lda $07
CD48: 91 05    sta ($05), y
CD4A: AA       tax
CD4B: E8       inx
CD4C: E8       inx
CD4D: 8A       txa
CD4E: A0 05    ldy #$05
CD50: 91 05    sta ($05), y
CD52: E6 07    inc $07
CD54: C9 07    cmp #$07
CD56: A0 21    ldy #$21
CD58: 91 05    sta ($05), y
CD5A: C8       iny
CD5B: 91 05    sta ($05), y
CD5D: 64 91    nop $91
CD5F: 05 C8    ora $c8
CD61: 91 05    sta ($05), y
CD63: 18       clc
CD64: A5 06    lda $06
CD66: 69 04    adc #$04
CD68: 85 06    sta $06
CD6A: A0 21    ldy #$21
CD6C: A9 00    lda #$00
CD6E: 91 05    sta ($05), y
CD70: C8       iny
CD71: 91 05    sta ($05), y
CD73: C8       iny
CD74: 91 05    sta ($05), y
CD76: 64 91    nop $91
CD78: 05 38    ora $38
CD7A: A5 06    lda $06
CD7C: E9 04    sbc #$04
CD7E: 85 06    sta $06
CD80: 18       clc
CD81: A5 05    lda $05
CD83: 69 21    adc #$21
CD85: 85 05    sta $05
CD87: C9 06    cmp #$06
CD89: 69 00    adc #$00
CD8B: 85 06    sta $06
CD8D: C1 F5    cmp (dummy_write_00f5, x)
CD8F: 6E 68 A8 ror $a868
CD92: 60       rts
CD93: 85 F7    sta $f7
CD95: 6E 91 05 ror $0591
CD98: C8       iny
CD99: E8       inx
CD9A: 8A       txa
CD9B: 91 05    sta ($05), y
CD9D: 64 E8    nop $e8
CD9F: 8A       txa
CDA0: 91 05    sta ($05), y
CDA2: C8       iny
CDA3: E8       inx
CDA4: 8A       txa
CDA5: 91 05    sta ($05), y
CDA7: 28       plp
CDA8: 85 F7    sta $f7
CDAA: EA       nop
CDAB: 91 05    sta ($05), y
CDAD: 64 91    nop $91
CDAF: 05 C8    ora $c8
CDB1: 91 05    sta ($05), y
CDB3: C8       iny
CDB4: 91 05    sta ($05), y
CDB6: 28       plp
CDB7: 00       brk
CDB8: 00       brk
CDB9: 00       brk
CDBA: 02       kil
CDBB: 40       rti
CDBC: 02       kil
CDBD: 80 02    nop #$02
CDBF: C0 02    cpy #$02
CDC1: 00       brk
CDC2: 03 40    slo ($40, x)
CDC4: 03 00    slo ($00, x)
CDC6: 00       brk
CDC7: 00       brk
CDC8: 00       brk
CDC9: 00       brk
CDCA: 00       brk
CDCB: 00       brk
CDCC: 00       brk
CDCD: 00       brk
CDCE: 00       brk
CDCF: 00       brk
CDD0: 00       brk
CDD1: 00       brk
CDD2: 00       brk
CDD3: 00       brk
CDD4: 00       brk
CDD5: C9 00    cmp #$00
CDD7: 81 ED    sta ($ed, x)
CDD9: 51 EE    eor ($ee), y
CDDB: B9 EE 21 lda $21ee, y
CDDE: EF E9 ED isb $ede9
CDE1: 89 EF    nop #$ef
CDE3: D7 EB    dcp $eb, x
CDE5: 4B EC    asr #$ec
CDE7: 88       dey
CDE8: EC D1 EC cpx $ecd1
CDEB: 14 EC    nop $ec, x
CDED: 3E ED 01 rol $01ed, x
CDF0: 01 01    ora ($01, x)
CDF2: 01 01    ora ($01, x)
CDF4: 01 01    ora ($01, x)
CDF6: 01 47    ora ($47, x)
CDF8: 47 47    sre $47
CDFA: 47 47    sre $47
CDFC: 47 47    sre $47
CDFE: 47 78    sre $78
CE00: 78       sei
CE01: 78       sei
CE02: 78       sei
CE03: 48       pha
CE04: 78       sei
CE05: 78       sei
CE06: 78       sei
CE07: AD BD CD lda $cdbd
CE0A: 8D CD AD sta $adcd
CE0D: AD AD AA lda $aaad
CE10: 10 30    bpl $ce42
CE12: 43 40    sre ($40, x)
CE14: 35 33    and $33, x
CE16: 40       rti
CE17: 00       brk
CE18: 42       kil
CE19: 37 3B    rla $3b, x
CE1B: 33 FE    rla ($fe), y
CE1D: EB 10    sbc #$10
CE1F: 4D 4E 4F eor $4f4e
CE22: 50 00    bvc $ce24
CE24: 26 2E    rol $2e
CE26: 2D 27 FF and $ff27
CE29: 2C 11 CC bit $cc11
CE2C: 1D 0D 19 ora $190d, x
CE2F: 1C 0F CC nop $cc0f, x
CE32: FE 65 11 inc $1165, x
CE35: 00       brk
CE36: 01 02    ora ($02, x)
CE38: 03 00    slo ($00, x)
CE3A: 00       brk
CE3B: 40       rti
CE3C: 41 42    eor ($42, x)
CE3E: 43 00    sre ($00, x)
CE40: 00       brk
CE41: 80 81    nop #$81
CE43: 82 83    nop #$83
CE45: FE 65 15 inc $1565, x
CE48: 02       kil
CE49: 02       kil
CE4A: 02       kil
CE4B: 02       kil
CE4C: 00       brk
CE4D: 00       brk
CE4E: 03 03    slo ($03, x)
CE50: 03 03    slo ($03, x)
CE52: 00       brk
CE53: 00       brk
CE54: 02       kil
CE55: 02       kil
CE56: 02       kil
CE57: 02       kil
CE58: FE A5 11 inc $11a5, x
CE5B: C0 C1    cpy #$c1
CE5D: C2 C3    nop #$c3
CE5F: 00       brk
CE60: 00       brk
CE61: 00       brk
CE62: 01 02    ora ($02, x)
CE64: 03 00    slo ($00, x)
CE66: 00       brk
CE67: 40       rti
CE68: 41 42    eor ($42, x)
CE6A: 43 FE    sre ($fe, x)
CE6C: A5 15    lda $15
CE6E: 02       kil
CE6F: 02       kil
CE70: 02       kil
CE71: 02       kil
CE72: 00       brk
CE73: 00       brk
CE74: 03 03    slo ($03, x)
CE76: 03 03    slo ($03, x)
CE78: 00       brk
CE79: 00       brk
CE7A: 02       kil
CE7B: 02       kil
CE7C: 02       kil
CE7D: 02       kil
CE7E: FE E5 11 inc $11e5, x
CE81: BC BD 00 ldy $00bd, x
CE84: 00       brk
CE85: C0 C1    cpy #$c1
CE87: 00       brk
CE88: 00       brk
CE89: B8       clv
CE8A: B9 FE 05 lda $05fe, y
CE8D: 12       kil
CE8E: BE BF 00 ldx $00bf, y
CE91: 00       brk
CE92: C2 C3    nop #$c3
CE94: 00       brk
CE95: 00       brk
CE96: BA       tsx
CE97: BB FE 25 las $25fe, y
CE9A: 12       kil
CE9B: DC DD 00 nop $00dd, x
CE9E: 00       brk
CE9F: E0 E1    cpx #$e1
CEA1: 00       brk
CEA2: 00       brk
CEA3: B4 B5    ldy $b5, x
CEA5: FE 96 11 inc $1196, x
CEA8: 06 01    asl $01
CEAA: 00       brk
CEAB: 1A       nop
CEAC: 1E 1D FE asl $fe1d, x
CEAF: 10 12    bpl $cec3
CEB1: CC 0C 19 cpy $190c
CEB4: 18       clc
CEB5: 1F 1D 00 slo $001d, x
CEB8: 02       kil
CEB9: 00       brk
CEBA: 51 52    eor ($52), y
CEBC: 53 FF    sre ($ff), y
CEBE: C3 12    dcp ($12, x)
CEC0: 0C 19 18 nop $1819
CEC3: 1F 1D 00 slo $001d, x
CEC6: 00       brk
CEC7: 00       brk
CEC8: 10 19    bpl $cee3
CECA: 1C 00 0F nop $0f00, x
CECD: 20 0F 1C jsr $1c0f
CED0: 23 00    rla ($00, x)
CED2: 00       brk
CED3: 00       brk
CED4: 00       brk
CED5: 00       brk
CED6: 00       brk
CED7: 1A       nop
CED8: 1E 1D FE asl $fe1d, x
CEDB: A8       tay
CEDC: 12       kil
CEDD: 1C 1D FE nop $fe1d, x
CEE0: C8       iny
CEE1: 12       kil
CEE2: 1E 1F FE asl $fe1f, x
CEE5: A8       tay
CEE6: 16 01    asl $01, x
CEE8: 01 FE    ora ($fe, x)
CEEA: C8       iny
CEEB: 16 01    asl $01, x
CEED: 01 FF    ora ($ff, x)
CEEF: 67 11    rra $11
CEF1: 0C 0F 1D nop $1d0f
CEF4: 1E 00 10 asl $1000, x
CEF7: 13 20    slo ($20), y
CEF9: 0F 00 1A slo $1a00
CEFC: 16 0B    asl $0b, x
CEFE: 23 0F    rla ($0f, x)
CF00: 1C 1D FE nop $fe1d, x
CF03: C7 11    dcp $11
CF05: 02       kil
CF06: FE D4 11 inc $11d4, x
CF09: 1A       nop
CF0A: 1E 1D FE asl $fe1d, x
CF0D: 07 12    slo $12
CF0F: 03 FE    slo ($fe, x)
CF11: 14 12    nop $12, x
CF13: 1A       nop
CF14: 1E 1D FE asl $fe1d, x
CF17: 47 12    sre $12
CF19: 04 FE    nop $fe
CF1B: 54 12    nop $12, x
CF1D: 1A       nop
CF1E: 1E 1D FE asl $fe1d, x
CF21: 87 12    sax $12
CF23: 05 FE    ora $fe
CF25: 94 12    sty $12, x
CF27: 1A       nop
CF28: 1E 1D FE asl $fe1d, x
CF2B: C7 12    dcp $12
CF2D: 06 FE    asl $fe
CF2F: D4 12    nop $12, x
CF31: 1A       nop
CF32: 1E 1D FF asl $ff1d, x
CF35: 68       pla
CF36: 4C 00 B0 jmp $b000
CF39: 85 F5    sta dummy_write_00f5
CF3B: EA       nop
CF3C: 48       pha
CF3D: CD 03 40 cmp $4003
CF40: 29 10    and #$10
CF42: F0 F1    beq $cf35
CF44: 8A       txa
CF45: 48       pha
CF46: 54 48    nop $48, x
CF48: EA       nop
CF49: D8       cld
CF4A: A5 01    lda $01
CF4C: F0 40    beq $cf8e
CF4E: AD 04 40 lda $4004
CF51: 49 FF    eor #$ff
CF53: 29 E0    and #$e0
CF55: 85 02    sta $02
CF57: 26 4A    rol $4a
CF59: 4A       lsr a
CF5A: 4A       lsr a
CF5B: 4A       lsr a
CF5C: A8       tay
CF5D: 20 34 D0 jsr $d034
CF60: AD 02 40 lda $4002
CF63: 29 C0    and #$c0
CF65: F0 27    beq $cf8e
CF67: 85 26    sta $26
CF69: 20 34 D0 jsr $d034
CF6C: AD 02 40 lda $4002
CF6F: 25 26    and $26
CF71: F0 1B    beq $cf8e
CF73: 20 34 D0 jsr $d034
CF76: AD 02 40 lda $4002
CF79: 25 26    and $26
CF7B: F0 11    beq $cf8e
CF7D: 20 34 D0 jsr $d034
CF80: AD 02 40 lda $4002
CF83: 25 26    and $26
CF85: F0 07    beq $cf8e
CF87: A9 01    lda #$01
CF89: 85 F9    sta $f9
CF8B: 85 F6    sta $f6
CF8D: 6E 8D 00 ror $008d
CF90: 40       rti
CF91: 68       pla
CF92: A8       tay
CF93: 68       pla
CF94: AA       tax
CF95: 68       pla
CF96: 40       rti
CF97: 85 F6    sta $f6
CF99: EA       nop
CF9A: E6 1E    inc $1e
CF9C: 4D 1B 8D eor $8d1b
CF9F: 03 40    slo ($40, x)
CFA1: A5 02    lda $02
CFA3: C9 80    cmp #$80
CFA5: F0 31    beq $cfd8
CFA7: A2 00    ldx #$00
CFA9: AD 03 40 lda $4003
CFAC: 49 FF    eor #$ff
CFAE: 29 0F    and #$0f
CFB0: 06 26    asl $26
CFB2: 90 05    bcc $cfb9
CFB4: 4A       lsr a
CFB5: 4A       lsr a
CFB6: 85 F5    sta dummy_write_00f5
CFB8: EA       nop
CFB9: 29 03    and #$03
CFBB: F0 46    beq $d003
CFBD: E8       inx
CFBE: C9 01    cmp #$01
CFC0: F0 41    beq $d003
CFC2: E8       inx
CFC3: C9 02    cmp #$02
CFC5: F0 31    beq $cff8
CFC7: E8       inx
CFC8: 85 F5    sta dummy_write_00f5
CFCA: EA       nop
CFCB: A5 1E    lda $1e
CFCD: C9 02    cmp #$02
CFCF: B0 1F    bcs $cff0
CFD1: 85 F5    sta dummy_write_00f5
CFD3: EA       nop
CFD4: 60       rts
CFD5: 85 F5    sta dummy_write_00f5
CFD7: 6E A2 05 ror $05a2
CFDA: A5 26    lda $26
CFDC: C9 80    cmp #$80
CFDE: F0 23    beq $d003
CFE0: E8       inx
CFE1: C9 40    cmp #$40
CFE3: F0 1E    beq $d003
CFE5: E8       inx
CFE6: C9 C0    cmp #$c0
CFE8: F0 19    beq $d003
CFEA: 4C D4 CF jmp $cfd4
CFED: 85 F5    sta dummy_write_00f5
CFEF: 6E C6 1E ror $1ec6
CFF2: 4C 03 D0 jmp $d003
CFF5: 85 F5    sta dummy_write_00f5
CFF7: 6E A5 02 ror $02a5
CFFA: C9 60    cmp #$60
CFFC: D0 05    bne $d003
CFFE: A2 04    ldx #$04
D000: 85 F5    sta dummy_write_00f5
D002: EA       nop
D003: A5 1D    lda $1d
D005: F8       sed
D006: 18       clc
D007: 7D 5C D0 adc $d05c, x
D00A: D9 64 D0 cmp $d064, y
D00D: 90 06    bcc $d015
D00F: B9 64 D0 lda $d064, y
D012: 85 F5    sta dummy_write_00f5
D014: EA       nop
D015: 85 1D    sta $1d
D017: D8       cld
D018: C6 1E    dec $1e
D01A: A5 1B    lda $1b
D01C: D0 11    bne $d02f
D01E: 8D 00 40 sta $4000
D021: A9 01    lda #$01
D023: 85 1A    sta $1a
D025: A2 FF    ldx #$ff
D027: 9A       txs
D028: EA       nop
D029: 4C 38 C0 jmp $c038
D02C: 85 F6    sta $f6
D02E: EA       nop
D02F: 4C D4 CF jmp $cfd4
D032: 85 F5    sta dummy_write_00f5
D034: EA       nop
D035: A2 E7    ldx #$e7
D037: 85 F5    sta dummy_write_00f5
D039: EA       nop
D03A: A5 FF    lda $ff
D03C: A5 FF    lda $ff
D03E: EA       nop
D03F: CA       dex
D040: D0 F8    bne $d03a
D042: 60       rts
D043: 85 F6    sta $f6
D045: EA       nop
D046: A5 F9    lda $f9
D048: F0 11    beq $d05b
D04A: AD 02 40 lda $4002
D04D: 29 C0    and #$c0
D04F: D0 0A    bne $d05b
D051: A9 00    lda #$00
D053: 85 F9    sta $f9
D055: 20 99 CF jsr $cf99
D058: 85 F6    sta $f6
D05A: EA       nop
D05B: 60       rts
D05C: 01 02    ora ($02, x)
D05E: 03 01    slo ($01, x)
D060: 06 08    asl $08
D062: 03 01    slo ($01, x)
D064: 09 09    ora #$09
D066: 09 09    ora #$09
D068: 09 09    ora #$09
D06A: 09 09    ora #$09
D06C: 85 F5    sta dummy_write_00f5
D06E: EA       nop
D06F: A5 1A    lda $1a
D071: F0 1E    beq $d091
D073: A5 1C    lda $1c
D075: D0 09    bne $d080
D077: 20 11 D1 jsr $d111
D07A: 20 3F D1 jsr $d13f
D07D: 85 F5    sta dummy_write_00f5
D07F: EA       nop
D080: AD 02 40 lda $4002
D083: 29 01    and #$01
D085: F0 0E    beq $d095
D087: AD 02 40 lda $4002
D08A: 29 02    and #$02
D08C: F0 32    beq $d0c0
D08E: 85 F5    sta dummy_write_00f5
D090: EA       nop
D091: 60       rts
D092: 85 F5    sta dummy_write_00f5
D094: EA       nop
D095: 20 6E D1 jsr $d16e
D098: A9 00    lda #$00
D09A: 85 21    sta $21
D09C: 85 20    sta $20
D09E: 85 1C    sta $1c
D0A0: A9 01    lda #$01
D0A2: 85 1B    sta $1b
D0A4: A9 00    lda #$00
D0A6: 85 1A    sta $1a
D0A8: 20 A3 C8 jsr $c8a3
D0AB: 20 E3 CB jsr $cbe3
D0AE: A2 E8    ldx #$e8
D0B0: A0 C2    ldy #$c2
D0B2: 20 BC C9 jsr $c9bc
D0B5: A2 1F    ldx #$1f
D0B7: 20 2C CA jsr $ca2c
D0BA: 4C FD D0 jmp $d0fd
D0BD: 85 F5    sta dummy_write_00f5
D0BF: EA       nop
D0C0: A5 1D    lda $1d
D0C2: C9 02    cmp #$02
D0C4: B0 03    bcs $d0c9
D0C6: 4C 91 D0 jmp $d091
D0C9: 20 6E D1 jsr $d16e
D0CC: 20 6E D1 jsr $d16e
D0CF: A9 01    lda #$01
D0D1: 85 21    sta $21
D0D3: A9 00    lda #$00
D0D5: 85 20    sta $20
D0D7: 85 1C    sta $1c
D0D9: A9 01    lda #$01
D0DB: 85 1B    sta $1b
D0DD: A9 00    lda #$00
D0DF: 85 1A    sta $1a
D0E1: 20 A3 C8 jsr $c8a3
D0E4: 20 E3 CB jsr $cbe3
D0E7: A2 D2    ldx #$d2
D0E9: A0 C2    ldy #$c2
D0EB: 20 BC C9 jsr $c9bc
D0EE: A2 E8    ldx #$e8
D0F0: A0 C2    ldy #$c2
D0F2: 20 BC C9 jsr $c9bc
D0F5: A2 1F    ldx #$1f
D0F7: 20 2C CA jsr $ca2c
D0FA: 85 F5    sta dummy_write_00f5
D0FC: EA       nop
D0FD: A2 05    ldx #$05
D0FF: A9 00    lda #$00
D101: 85 F5    sta dummy_write_00f5
D103: EA       nop
D104: 95 2D    sta $2d, x
D106: 66 10    ror $10
D108: FB A2 FF isb $ffa2, y
D10B: 9A       txs
D10C: 4C 68 C0 jmp $c068
D10F: 85 F5    sta dummy_write_00f5
D111: EA       nop
D112: AD 67 13 lda $1367
D115: CD 55 D1 cmp $d155
D118: F0 3A    beq $d154
D11A: A0 00    ldy #$00
D11C: 85 F5    sta dummy_write_00f5
D11E: 6E B9 55 ror $55b9
D121: D1 99    cmp ($99), y
D123: 67 13    rra timer1_0013
D125: 64 C0    nop $c0
D127: 11 D0    ora ($d0), y
D129: F5 85    sbc $85, x
D12B: F5 6E    sbc $6e, x
D12D: A0 00    ldy #$00
D12F: 85 F5    sta dummy_write_00f5
D131: EA       nop
D132: B9 66 D1 lda $d166, y
D135: 99 AB 13 sta $13ab, y
D138: C8       iny
D139: C0 06    cpy #$06
D13B: D0 F5    bne $d132
D13D: 85 F5    sta dummy_write_00f5
D13F: 6E A5 1D ror $1da5
D142: 4A       lsr a
D143: 4A       lsr a
D144: 4A       lsr a
D145: 4A       lsr a
D146: AA       tax
D147: E8       inx
D148: A5 1D    lda $1d
D14A: 29 0F    and #$0f
D14C: AA       tax
D14D: E8       inx
D14E: 8E B3 13 stx $13b3
D151: 85 F5    sta dummy_write_00f5
D153: EA       nop
D154: 60       rts
D155: 1A       nop
D156: 1F 1D 12 slo $121d, x
D159: 00       brk
D15A: 1D 1E 0B ora $0b1e, x
D15D: 1C 1E 00 nop $001e, x
D160: 0C 1F 1E nop $1e1f
D163: 1E 19 18 asl $1819, x
D166: 0D 1C 0F ora $0f1c
D169: 0E 13 1E asl $1e13
D16C: 85 F5    sta dummy_write_00f5
D16E: 6E F8 38 ror $38f8
D171: A5 1D    lda $1d
D173: E9 01    sbc #$01
D175: 85 1D    sta $1d
D177: 74 60    nop $60, x
D179: 85 F5    sta dummy_write_00f5
D17B: EA       nop
D17C: A5 6F    lda game_state_006f
D17E: 10 04    bpl $d184
D180: 85 F5    sta dummy_write_00f5
D182: EA       nop
D183: 60       rts
D184: A5 1B    lda $1b
D186: D0 03    bne $d18b
D188: 4C 36 D2 jmp $d236
D18B: A6 1F    ldx current_player_001f
D18D: A4 1F    ldy current_player_001f
D18F: AD 03 40 lda $4003
D192: 29 40    and #$40
D194: D0 02    bne $d198
D196: A0 00    ldy #$00
D198: B9 00 40 lda $4000, y
D19B: 49 FF    eor #$ff
D19D: 29 10    and #$10
D19F: F0 40    beq $d1e1
D1A1: A5 B9    lda $b9
D1A3: D0 43    bne $d1e8
D1A5: B5 2B    lda player_pepper_002b, x
D1A7: F0 2D    beq $d1d6
D1A9: 85 B9    sta $b9
D1AB: 85 F5    sta dummy_write_00f5
D1AD: 6E A9 00 ror $00a9
D1B0: 85 6E    sta $6e
D1B2: A9 05    lda #$05
D1B4: 85 A0    sta $a0
D1B6: C9 BA    cmp #$ba
D1B8: AA       tax
D1B9: 18       clc
D1BA: BD 4D D2 lda $d24d, x
D1BD: 6D 1E 18 adc $181e
D1C0: 8D 1A 18 sta $181a
D1C3: 18       clc
D1C4: BD 4E D2 lda $d24e, x
D1C7: 6D 1F 18 adc $181f
D1CA: 8D 1B 18 sta $181b
D1CD: 4D 0D 20 eor $200d
D1D0: 5D EA 60 eor $60ea, x
D1D3: 85 F5    sta dummy_write_00f5
D1D5: 6E A9 0E ror $0ea9
D1D8: 20 5D EA jsr $ea5d
D1DB: 4C E8 D1 jmp $d1e8
D1DE: 85 F5    sta dummy_write_00f5
D1E0: EA       nop
D1E1: A9 00    lda #$00
D1E3: 85 B9    sta $b9
D1E5: C1 F5    cmp (dummy_write_00f5, x)
D1E7: 6E B9 00 ror $00b9
D1EA: 40       rti
D1EB: 49 FF    eor #$ff
D1ED: 29 0F    and #$0f
D1EF: A8       tay
D1F0: B9 57 D2 lda $d257, y
D1F3: A8       tay
D1F4: C5 BB    cmp $bb
D1F6: F0 09    beq $d201
D1F8: 0A       asl a
D1F9: 0A       asl a
D1FA: 0A       asl a
D1FB: 0A       asl a
D1FC: 85 B0    sta $b0
D1FE: C1 F5    cmp (dummy_write_00f5, x)
D200: EA       nop
D201: 84 BB    sty $bb
D203: 98       tya
D204: F0 05    beq $d20b
D206: 84 BA    sty $ba
D208: 85 F5    sta dummy_write_00f5
D20A: EA       nop
D20B: A5 BB    lda $bb
D20D: F0 0A    beq $d219
D20F: A2 07    ldx #$07
D211: 20 C3 D3 jsr $d3c3
D214: D0 1C    bne $d232
D216: 85 F5    sta dummy_write_00f5
D218: EA       nop
D219: A2 07    ldx #$07
D21B: 20 69 D2 jsr $d269
D21E: A5 B0    lda $b0
D220: 29 F0    and #$f0
D222: F0 0E    beq $d232
D224: A0 06    ldy #$06
D226: C9 60    cmp #$60
D228: B0 01    bcs $d22b
D22A: C8       iny
D22B: 98       tya
D22C: 20 5D EA jsr $ea5d
D22F: 85 F5    sta dummy_write_00f5
D231: EA       nop
D232: 60       rts
D233: 85 F5    sta dummy_write_00f5
D235: EA       nop
D236: A2 07    ldx #$07
D238: 20 C3 D3 jsr $d3c3
D23B: F0 0A    beq $d247
D23D: A9 47    lda #$47
D23F: 8D 1D 18 sta $181d
D242: E6 C6    inc $c6
D244: 85 F5    sta dummy_write_00f5
D246: EA       nop
D247: A2 07    ldx #$07
D249: 20 69 D2 jsr $d269
D24C: 60       rts
D24D: 00       brk
D24E: 10 F0    bpl $d240
D250: 00       brk
D251: 10 00    bpl $d253
D253: 00       brk
D254: F0 00    beq $d256
D256: 10 00    bpl $d258
D258: 02       kil
D259: 04 00    nop $00
D25B: 06 00    asl $00
D25D: 00       brk
D25E: 00       brk
D25F: 08       php
D260: 00       brk
D261: 00       brk
D262: 00       brk
D263: 00       brk
D264: 00       brk
D265: 00       brk
D266: 00       brk
D267: 85 F5    sta dummy_write_00f5
D269: EA       nop
D26A: B5 68    lda $68, x
D26C: 10 01    bpl $d26f
D26E: 60       rts
D26F: A5 13    lda timer1_0013
D271: 35 91    and $91, x
D273: D0 01    bne $d276
D275: 60       rts
D276: D6 99    dec $99, x
D278: F0 01    beq $d27b
D27A: 60       rts
D27B: B5 A1    lda $a1, x
D27D: 95 99    sta $99, x
D27F: B5 A9    lda $a9, x
D281: 29 0F    and #$0f
D283: 85 03    sta $03
D285: B5 A9    lda $a9, x
D287: 4A       lsr a
D288: 4A       lsr a
D289: 4A       lsr a
D28A: F0 0B    beq $d297
D28C: 18       clc
D28D: 65 03    adc $03
D28F: 85 03    sta $03
D291: 4C AC D2 jmp $d2ac
D294: 85 F5    sta dummy_write_00f5
D296: EA       nop
D297: E0 07    cpx #$07
D299: D0 11    bne $d2ac
D29B: A0 00    ldy #$00
D29D: A5 BA    lda $ba
D29F: C9 06    cmp #$06
D2A1: D0 04    bne $d2a7
D2A3: C8       iny
D2A4: 85 F5    sta dummy_write_00f5
D2A6: EA       nop
D2A7: 84 03    sty $03
D2A9: 85 F5    sta dummy_write_00f5
D2AB: EA       nop
D2AC: 8A       txa
D2AD: 0A       asl a
D2AE: 0A       asl a
D2AF: 85 09    sta $09
D2B1: B5 68    lda $68, x
D2B3: 29 07    and #$07
D2B5: 0A       asl a
D2B6: A8       tay
D2B7: B9 4B D3 lda $d34b, y
D2BA: 85 05    sta $05
D2BC: B9 4C D3 lda $d34c, y
D2BF: 85 06    sta $06
D2C1: A4 03    ldy $03
D2C3: B1 05    lda ($05), y
D2C5: C9 FF    cmp #$ff
D2C7: F0 4B    beq $d314
D2C9: A4 09    ldy $09
D2CB: 99 01 18 sta $1801, y
D2CE: B5 A9    lda $a9, x
D2D0: 4A       lsr a
D2D1: 4A       lsr a
D2D2: 4A       lsr a
D2D3: 4A       lsr a
D2D4: 29 02    and #$02
D2D6: 09 01    ora #$01
D2D8: 99 00 18 sta $1800, y
D2DB: B5 A9    lda $a9, x
D2DD: 29 F0    and #$f0
D2DF: F0 69    beq $d34a
D2E1: F6 A9    inc $a9, x
D2E3: B5 A9    lda $a9, x
D2E5: 29 F3    and #$f3
D2E7: 95 A9    sta $a9, x
D2E9: 86 08    stx $08
D2EB: A4 09    ldy $09
D2ED: 4A       lsr a
D2EE: 4A       lsr a
D2EF: 4A       lsr a
D2F0: 4A       lsr a
D2F1: AA       tax
D2F2: 18       clc
D2F3: BD B7 D3 lda $d3b7, x
D2F6: 79 02 18 adc $1802, y
D2F9: 99 02 18 sta $1802, y
D2FC: 18       clc
D2FD: BD B8 D3 lda $d3b8, x
D300: 79 03 18 adc $1803, y
D303: C9 1D    cmp #$1d
D305: B0 02    bcs $d309
D307: A9 1D    lda #$1d
D309: 99 03 18 sta $1803, y
D30C: CA       dex
D30D: 08       php
D30E: 4C 4A D3 jmp $d34a
D311: 85 F5    sta dummy_write_00f5
D313: EA       nop
D314: A4 09    ldy $09
D316: B5 A9    lda $a9, x
D318: 30 0D    bmi $d327
D31A: B9 03 18 lda $1803, y
D31D: 85 0B    sta $0b
D31F: EA       nop
D320: 0B 4C    anc #$4c
D322: 31 D3    and ($d3), y
D324: 85 F5    sta dummy_write_00f5
D326: 6E B9 03 ror $03b9
D329: 18       clc
D32A: 85 0B    sta $0b
D32C: E2 0B    nop #$0b
D32E: C1 F5    cmp (dummy_write_00f5, x)
D330: EA       nop
D331: A5 0B    lda $0b
D333: 99 03 18 sta $1803, y
D336: C1 F5    cmp (dummy_write_00f5, x)
D338: EA       nop
D339: B5 A9    lda $a9, x
D33B: 29 F0    and #$f0
D33D: F0 0B    beq $d34a
D33F: F6 A9    inc $a9, x
D341: B5 A9    lda $a9, x
D343: 29 F3    and #$f3
D345: 95 A9    sta $a9, x
D347: C1 F5    cmp (dummy_write_00f5, x)
D349: EA       nop
D34A: 60       rts
D34B: 5B D3 6F sre $6fd3, y
D34E: D3 83    dcp ($83), y
D350: D3 97    dcp ($97), y
D352: D3 AE    dcp ($ae), y
D354: D3 B1    dcp ($b1), y
D356: D3 B4    dcp ($b4), y
D358: D3 B7    dcp ($b7), y
D35A: D3 47    dcp ($47), y
D35C: 48       pha
D35D: 47 48    sre $48
D35F: 40       rti
D360: 41 42    eor ($42, x)
D362: 41 40    eor ($40, x)
D364: 41 42    eor ($42, x)
D366: 41 45    eor ($45, x)
D368: FF 46 FF isb $ff46, x
D36B: 43 FF    sre ($ff, x)
D36D: 44 FF    nop $ff
D36F: 00       brk
D370: 00       brk
D371: 00       brk
D372: 00       brk
D373: 58       cli
D374: 59 58 59 eor $5958, y
D377: 58       cli
D378: 59 58 59 eor $5958, y
D37B: 5C FF 5D nop $5dff, x
D37E: FF 5A FF isb $ff5a, x
D381: 5B FF 00 sre $00ff, y
D384: 00       brk
D385: 00       brk
D386: 00       brk
D387: 64 65    nop $65
D389: 64 65    nop $65
D38B: 64 65    nop $65
D38D: 64 65    nop $65
D38F: 68       pla
D390: FF 69 FF isb $ff69, x
D393: 66 FF    ror $ff
D395: 67 FF    rra $ff
D397: 00       brk
D398: 00       brk
D399: 00       brk
D39A: 00       brk
D39B: 70 71    bvs $d40e
D39D: 70 71    bvs $d410
D39F: 70 71    bvs $d412
D3A1: 70 71    bvs $d414
D3A3: 74 FF    nop $ff, x
D3A5: 75 FF    adc $ff, x
D3A7: 72       kil
D3A8: FF 73 FF isb $ff73, x
D3AB: 85 F5    sta dummy_write_00f5
D3AD: 6E 85 F5 ror $f585
D3B0: EA       nop
D3B1: 85 F5    sta dummy_write_00f5
D3B3: EA       nop
D3B4: 85 F5    sta dummy_write_00f5
D3B6: 6E 00 00 ror $0000
D3B9: FE 00 02 inc $0200, x
D3BC: 00       brk
D3BD: 00       brk
D3BE: FD 00 03 sbc $0300, x
D3C1: 85 F5    sta dummy_write_00f5
D3C3: EA       nop
D3C4: B5 A9    lda $a9, x
D3C6: 4A       lsr a
D3C7: 4A       lsr a
D3C8: 4A       lsr a
D3C9: 4A       lsr a
D3CA: A8       tay
D3CB: B9 E8 D3 lda $d3e8, y
D3CE: 85 05    sta $05
D3D0: B9 E9 D3 lda $d3e9, y
D3D3: 85 06    sta $06
D3D5: 46 0A    lsr $0a
D3D7: 0A       asl a
D3D8: A8       tay
D3D9: B9 02 18 lda $1802, y
D3DC: 85 03    sta $03
D3DE: 5D 03 18 eor $1803, x
D3E1: 85 04    sta $04
D3E3: E6 67    inc $67
D3E5: AC 05 00 ldy $0005
D3E8: F5 D3    sbc $d3, x
D3EA: FD D3 2E sbc $2ed3, x
D3ED: D4 5F    nop $5f, x
D3EF: D4 AD    nop $ad, x
D3F1: D4 85    nop $85, x
D3F3: F5 6E    sbc $6e, x
D3F5: A9 00    lda #$00
D3F7: 85 67    sta $67
D3F9: 60       rts
D3FA: 85 F5    sta dummy_write_00f5
D3FC: 6E A5 03 ror $03a5
D3FF: C9 16    cmp #$16
D401: B0 0A    bcs $d40d
D403: A9 17    lda #$17
D405: 99 02 18 sta $1802, y
D408: D0 20    bne $d42a
D40A: 85 F5    sta dummy_write_00f5
D40C: EA       nop
D40D: 20 00 D5 jsr $d500
D410: D0 18    bne $d42a
D412: 20 88 D5 jsr $d588
D415: D0 13    bne $d42a
D417: A5 04    lda $04
D419: 38       sec
D41A: E9 01    sbc #$01
D41C: 29 F0    and #$f0
D41E: 09 0D    ora #$0d
D420: 99 03 18 sta $1803, y
D423: A9 00    lda #$00
D425: 85 67    sta $67
D427: 85 F5    sta dummy_write_00f5
D429: EA       nop
D42A: 60       rts
D42B: 85 F5    sta dummy_write_00f5
D42D: EA       nop
D42E: A5 03    lda $03
D430: C9 D8    cmp #$d8
D432: 90 0A    bcc $d43e
D434: A9 D8    lda #$d8
D436: 99 02 18 sta $1802, y
D439: D0 20    bne $d45b
D43B: 85 F5    sta dummy_write_00f5
D43D: EA       nop
D43E: 20 00 D5 jsr $d500
D441: D0 18    bne $d45b
D443: 20 AB D5 jsr $d5ab
D446: D0 13    bne $d45b
D448: A5 04    lda $04
D44A: 38       sec
D44B: E9 01    sbc #$01
D44D: 29 F0    and #$f0
D44F: 09 0D    ora #$0d
D451: 99 03 18 sta $1803, y
D454: A9 00    lda #$00
D456: 85 67    sta $67
D458: 85 F5    sta dummy_write_00f5
D45A: EA       nop
D45B: 60       rts
D45C: 85 F5    sta dummy_write_00f5
D45E: EA       nop
D45F: A5 04    lda $04
D461: C9 1D    cmp #$1d
D463: B0 0A    bcs $d46f
D465: A9 1D    lda #$1d
D467: 99 03 18 sta $1803, y
D46A: D0 34    bne $d4a0
D46C: 85 F5    sta dummy_write_00f5
D46E: EA       nop
D46F: 20 23 D5 jsr $d523
D472: D0 2C    bne $d4a0
D474: 20 1E D6 jsr $d61e
D477: D0 27    bne $d4a0
D479: 8A       txa
D47A: 48       pha
D47B: A5 08    lda $08
D47D: 29 F8    and #$f8
D47F: 48       pha
D480: AD 03 40 lda $4003
D483: 29 40    and #$40
D485: F0 1D    beq $d4a4
D487: 68       pla
D488: A6 1F    ldx current_player_001f
D48A: 85 F5    sta dummy_write_00f5
D48C: EA       nop
D48D: 18       clc
D48E: 7D FA D4 adc $d4fa, x
D491: 99 02 18 sta $1802, y
D494: 68       pla
D495: AA       tax
D496: 85 F5    sta dummy_write_00f5
D498: EA       nop
D499: A9 00    lda #$00
D49B: 85 67    sta $67
D49D: 85 F5    sta dummy_write_00f5
D49F: EA       nop
D4A0: 60       rts
D4A1: 85 F5    sta dummy_write_00f5
D4A3: EA       nop
D4A4: 68       pla
D4A5: A2 00    ldx #$00
D4A7: 4C 8D D4 jmp $d48d
D4AA: 85 F5    sta dummy_write_00f5
D4AC: EA       nop
D4AD: A5 04    lda $04
D4AF: C9 DD    cmp #$dd
D4B1: 90 0A    bcc $d4bd
D4B3: A9 DD    lda #$dd
D4B5: 99 03 18 sta $1803, y
D4B8: D0 36    bne $d4f0
D4BA: 85 F5    sta dummy_write_00f5
D4BC: EA       nop
D4BD: A5 03    lda $03
D4BF: 20 23 D5 jsr $d523
D4C2: D0 2C    bne $d4f0
D4C4: 20 41 D6 jsr $d641
D4C7: D0 27    bne $d4f0
D4C9: 8A       txa
D4CA: 48       pha
D4CB: A5 08    lda $08
D4CD: 29 F8    and #$f8
D4CF: 48       pha
D4D0: AD 03 40 lda $4003
D4D3: 29 40    and #$40
D4D5: F0 1D    beq $d4f4
D4D7: 68       pla
D4D8: A6 1F    ldx current_player_001f
D4DA: 85 F5    sta dummy_write_00f5
D4DC: EA       nop
D4DD: 18       clc
D4DE: 7D FA D4 adc $d4fa, x
D4E1: 99 02 18 sta $1802, y
D4E4: 68       pla
D4E5: AA       tax
D4E6: 85 F5    sta dummy_write_00f5
D4E8: EA       nop
D4E9: A9 00    lda #$00
D4EB: 85 67    sta $67
D4ED: 85 F5    sta dummy_write_00f5
D4EF: EA       nop
D4F0: 60       rts
D4F1: 85 F5    sta dummy_write_00f5
D4F3: EA       nop
D4F4: 68       pla
D4F5: A2 00    ldx #$00
D4F7: 4C DD D4 jmp $d4dd
D4FA: FF 01 FE isb $fe01, x
D4FD: 02       kil
D4FE: 85 F5    sta dummy_write_00f5
D500: EA       nop
D501: A5 04    lda $04
D503: 29 0F    and #$0f
D505: F0 19    beq $d520
D507: C9 0F    cmp #$0f
D509: F0 15    beq $d520
D50B: C9 0E    cmp #$0e
D50D: F0 11    beq $d520
D50F: C9 0D    cmp #$0d
D511: F0 0D    beq $d520
D513: C9 0C    cmp #$0c
D515: F0 09    beq $d520
D517: C9 0B    cmp #$0b
D519: F0 05    beq $d520
D51B: C9 0A    cmp #$0a
D51D: 85 F5    sta dummy_write_00f5
D51F: 6E 60 85 ror $8560
D522: F5 EA    sbc $ea, x
D524: A5 03    lda $03
D526: 85 08    sta $08
D528: AD 03 40 lda $4003
D52B: 29 40    and #$40
D52D: F0 0B    beq $d53a
D52F: A5 1F    lda current_player_001f
D531: F0 07    beq $d53a
D533: C6 08    dec $08
D535: E2 08    nop #$08
D537: C1 F5    cmp (dummy_write_00f5, x)
D539: EA       nop
D53A: E6 08    inc $08
D53C: EA       nop
D53D: 08       php
D53E: EA       nop
D53F: 08       php
D540: A5 08    lda $08
D542: 29 0F    and #$0f
D544: C9 06    cmp #$06
D546: 90 28    bcc $d570
D548: C9 08    cmp #$08
D54A: 90 39    bcc $d585
D54C: C9 0E    cmp #$0e
D54E: B0 33    bcs $d583
D550: 85 F5    sta dummy_write_00f5
D552: EA       nop
D553: A5 08    lda $08
D555: 29 F0    and #$f0
D557: C9 10    cmp #$10
D559: F0 2A    beq $d585
D55B: C9 40    cmp #$40
D55D: F0 26    beq $d585
D55F: C9 70    cmp #$70
D561: F0 22    beq $d585
D563: C9 A0    cmp #$a0
D565: F0 1E    beq $d585
D567: C9 D0    cmp #$d0
D569: F0 1A    beq $d585
D56B: D0 18    bne $d585
D56D: 85 F5    sta dummy_write_00f5
D56F: 6E A5 08 ror $08a5
D572: 29 F0    and #$f0
D574: C9 30    cmp #$30
D576: F0 0D    beq $d585
D578: C9 60    cmp #$60
D57A: F0 09    beq $d585
D57C: C9 90    cmp #$90
D57E: F0 05    beq $d585
D580: C9 C0    cmp #$c0
D582: 85 F5    sta dummy_write_00f5
D584: 6E 60 85 ror $8560
D587: F5 EA    sbc $ea, x
D589: A5 03    lda $03
D58B: 38       sec
D58C: E9 08    sbc #$08
D58E: 4A       lsr a
D58F: 4A       lsr a
D590: 4A       lsr a
D591: 4A       lsr a
D592: 85 12    sta $12
D594: 4D 0F 38 eor $380f
D597: E5 12    sbc $12
D599: 85 12    sta $12
D59B: A5 04    lda $04
D59D: 18       clc
D59E: 69 07    adc #$07
D5A0: 29 F0    and #$f0
D5A2: 18       clc
D5A3: 65 12    adc $12
D5A5: AA       tax
D5A6: 4C CC D5 jmp $d5cc
D5A9: 85 F5    sta dummy_write_00f5
D5AB: EA       nop
D5AC: A5 03    lda $03
D5AE: 18       clc
D5AF: 69 19    adc #$19
D5B1: 4A       lsr a
D5B2: 4A       lsr a
D5B3: 4A       lsr a
D5B4: 4A       lsr a
D5B5: 85 12    sta $12
D5B7: 4D 0F 38 eor $380f
D5BA: E5 12    sbc $12
D5BC: 85 12    sta $12
D5BE: C9 04    cmp #$04
D5C0: 18       clc
D5C1: 69 07    adc #$07
D5C3: 29 F0    and #$f0
D5C5: 18       clc
D5C6: 65 12    adc $12
D5C8: AA       tax
D5C9: 85 F5    sta dummy_write_00f5
D5CB: EA       nop
D5CC: BD 8E D6 lda $d68e, x
D5CF: AA       tax
D5D0: BD 00 04 lda $0400, x
D5D3: 4A       lsr a
D5D4: 4A       lsr a
D5D5: 4A       lsr a
D5D6: 4A       lsr a
D5D7: C9 00    cmp #$00
D5D9: F0 3E    beq $d619
D5DB: C9 05    cmp #$05
D5DD: F0 3A    beq $d619
D5DF: C9 06    cmp #$06
D5E1: F0 36    beq $d619
D5E3: C9 07    cmp #$07
D5E5: F0 32    beq $d619
D5E7: A5 03    lda $03
D5E9: 18       clc
D5EA: 69 05    adc #$05
D5EC: 4A       lsr a
D5ED: 4A       lsr a
D5EE: 4A       lsr a
D5EF: 4A       lsr a
D5F0: 85 12    sta $12
D5F2: A9 0F    lda #$0f
D5F4: 38       sec
D5F5: E5 12    sbc $12
D5F7: 85 12    sta $12
D5F9: A5 04    lda $04
D5FB: 18       clc
D5FC: 69 10    adc #$10
D5FE: 29 F0    and #$f0
D600: 18       clc
D601: 65 12    adc $12
D603: AA       tax
D604: BD 8E D6 lda $d68e, x
D607: AA       tax
D608: BD 00 04 lda $0400, x
D60B: 4A       lsr a
D60C: 4A       lsr a
D60D: 4A       lsr a
D60E: 4A       lsr a
D60F: C9 07    cmp #$07
D611: F0 06    beq $d619
D613: A9 00    lda #$00
D615: 60       rts
D616: 85 F5    sta dummy_write_00f5
D618: EA       nop
D619: A9 FF    lda #$ff
D61B: 60       rts
D61C: 85 F5    sta dummy_write_00f5
D61E: EA       nop
D61F: A5 03    lda $03
D621: 18       clc
D622: 69 07    adc #$07
D624: 4A       lsr a
D625: 4A       lsr a
D626: 4A       lsr a
D627: 4A       lsr a
D628: 85 12    sta $12
D62A: A9 0F    lda #$0f
D62C: 38       sec
D62D: E5 12    sbc $12
D62F: 85 12    sta $12
D631: A5 04    lda $04
D633: 18       clc
D634: 69 11    adc #$11
D636: 29 F0    and #$f0
D638: 18       clc
D639: 65 12    adc $12
D63B: AA       tax
D63C: 4C 62 D6 jmp $d662
D63F: 85 F5    sta dummy_write_00f5
D641: EA       nop
D642: A5 03    lda $03
D644: 18       clc
D645: 69 07    adc #$07
D647: 4A       lsr a
D648: 4A       lsr a
D649: 4A       lsr a
D64A: 4A       lsr a
D64B: 85 12    sta $12
D64D: A9 0F    lda #$0f
D64F: 38       sec
D650: E5 12    sbc $12
D652: 85 12    sta $12
D654: A5 04    lda $04
D656: 18       clc
D657: 69 14    adc #$14
D659: 29 F0    and #$f0
D65B: 18       clc
D65C: 65 12    adc $12
D65E: AA       tax
D65F: 85 F5    sta dummy_write_00f5
D661: EA       nop
D662: BD 8E D6 lda $d68e, x
D665: AA       tax
D666: BD 00 04 lda $0400, x
D669: 4A       lsr a
D66A: 4A       lsr a
D66B: 4A       lsr a
D66C: 4A       lsr a
D66D: C9 00    cmp #$00
D66F: F0 1A    beq $d68b
D671: C9 01    cmp #$01
D673: F0 16    beq $d68b
D675: C9 02    cmp #$02
D677: F0 12    beq $d68b
D679: C9 09    cmp #$09
D67B: F0 0E    beq $d68b
D67D: C9 0A    cmp #$0a
D67F: F0 0A    beq $d68b
D681: C9 0B    cmp #$0b
D683: F0 06    beq $d68b
D685: A9 00    lda #$00
D687: 60       rts
D688: 85 F5    sta dummy_write_00f5
D68A: EA       nop
D68B: A9 FF    lda #$ff
D68D: 60       rts
D68E: 00       brk
D68F: 01 02    ora ($02, x)
D691: 03 04    slo ($04, x)
D693: 05 06    ora $06
D695: 07 87    slo $87
D697: 86 85    stx $85
D699: 84 83    sty $83
D69B: 82 81    nop #$81
D69D: 80 08    nop #$08
D69F: 09 0A    ora #$0a
D6A1: 0B 0C    anc #$0c
D6A3: 0D 0E 0F ora $0f0e
D6A6: 8F 8E 8D sax $8d8e
D6A9: 8C 8B 8A sty $8a8b
D6AC: 89 88    nop #$88
D6AE: 10 11    bpl $d6c1
D6B0: 12       kil
D6B1: 13 14    slo ($14), y
D6B3: 15 16    ora $16, x
D6B5: 17 97    slo $97, x
D6B7: 96 95    stx $95, y
D6B9: 94 93    sty $93, x
D6BB: 92       kil
D6BC: 91 90    sta ($90), y
D6BE: 18       clc
D6BF: 19 1A 1B ora $1b1a, y
D6C2: 1C 1D 1E nop $1e1d, x
D6C5: 1F 9F 9E slo $9e9f, x
D6C8: 9D 9C 9B sta $9b9c, x
D6CB: 9A       txs
D6CC: 99 98 20 sta $2098, y
D6CF: 21 22    and ($22, x)
D6D1: 23 24    rla ($24, x)
D6D3: 25 26    and $26
D6D5: 27 A7    rla $a7
D6D7: A6 A5    ldx $a5
D6D9: A4 A3    ldy $a3
D6DB: A2 A1    ldx #$a1
D6DD: A0 28    ldy #$28
D6DF: 29 2A    and #$2a
D6E1: 2B 2C    anc #$2c
D6E3: 2D 2E 2F and $2f2e
D6E6: AF AE AD lax $adae
D6E9: AC AB AA ldy $aaab
D6EC: A9 A8    lda #$a8
D6EE: 30 31    bmi $d721
D6F0: 32       kil
D6F1: 33 34    rla ($34), y
D6F3: 35 36    and $36, x
D6F5: 37 B7    rla $b7, x
D6F7: B6 B5    ldx $b5, y
D6F9: B4 B3    ldy $b3, x
D6FB: B2       kil
D6FC: B1 B0    lda ($b0), y
D6FE: 38       sec
D6FF: 39 3A 3B and $3b3a, y
D702: 3C 3D 3E nop $3e3d, x
D705: 3F BF BE rla $bebf, x
D708: BD BC BB lda $bbbc, x
D70B: BA       tsx
D70C: B9 B8 40 lda $40b8, y
D70F: 41 42    eor ($42, x)
D711: 43 44    sre ($44, x)
D713: 45 46    eor $46
D715: 47 C7    sre $c7
D717: C6 C5    dec $c5
D719: C4 C3    cpy $c3
D71B: C2 C1    nop #$c1
D71D: C0 48    cpy #$48
D71F: 49 4A    eor #$4a
D721: 4B 4C    asr #$4c
D723: 4D 4E 4F eor $4f4e
D726: CF CE CD dcp $cdce
D729: CC CB CA cpy $cacb
D72C: C9 C8    cmp #$c8
D72E: 50 51    bvc $d781
D730: 52       kil
D731: 53 54    sre ($54), y
D733: 55 56    eor $56, x
D735: 57 D7    sre $d7, x
D737: D6 D5    dec $d5, x
D739: D4 D3    nop $d3, x
D73B: D2       kil
D73C: D1 D0    cmp ($d0), y
D73E: 58       cli
D73F: 59 5A 5B eor $5b5a, y
D742: 5C 5D 5E nop $5e5d, x
D745: 5F DF DE sre $dedf, x
D748: DD DC DB cmp $dbdc, x
D74B: DA       nop
D74C: D9 D8 60 cmp $60d8, y
D74F: 61 62    adc ($62, x)
D751: 63 64    rra ($64, x)
D753: 65 66    adc $66
D755: 67 E7    rra $e7
D757: E6 E5    inc $e5
D759: E4 E3    cpx $e3
D75B: E2 E1    nop #$e1
D75D: E0 68    cpx #$68
D75F: 69 6A    adc #$6a
D761: 6B 6C    arr #$6c
D763: 6D 6E 6F adc $6f6e
D766: EF EE ED isb $edee
D769: EC EB EA cpx $eaeb
D76C: E9 E8    sbc #$e8
D76E: 70 71    bvs $d7e1
D770: 72       kil
D771: 73 74    rra ($74), y
D773: 75 76    adc $76, x
D775: 77 F7    rra $f7, x
D777: F6 F5    inc dummy_write_00f5, x
D779: F4 F3    nop $f3, x
D77B: F2       kil
D77C: F1 F0    sbc ($f0), y
D77E: 78       sei
D77F: 79 7A 7B adc $7b7a, y
D782: 7C 7D 7E nop $7e7d, x
D785: 7F FF FE rra $feff, x
D788: FD FC FB sbc $fbfc, x
D78B: FA       nop
D78C: F9 F8 85 sbc $85f8, y
D78F: F6 EA    inc $ea, x
D791: 4C 38 D8 jmp $d838
D794: 85 F5    sta dummy_write_00f5
D796: 6E A5 6E ror $6ea5
D799: C9 FF    cmp #$ff
D79B: D0 03    bne $d7a0
D79D: 4C 63 D8 jmp $d863
D7A0: 20 72 E6 jsr $e672
D7A3: E6 6E    inc $6e
D7A5: C9 6E    cmp #$6e
D7A7: C9 01    cmp #$01
D7A9: F0 1A    beq $d7c5
D7AB: C9 09    cmp #$09
D7AD: F0 4B    beq $d7fa
D7AF: C9 11    cmp #$11
D7B1: F0 66    beq $d819
D7B3: C9 19    cmp #$19
D7B5: F0 DA    beq $d791
D7B7: C9 22    cmp #$22
D7B9: F0 04    beq $d7bf
D7BB: 60       rts
D7BC: 85 F6    sta $f6
D7BE: 6E 4C 57 ror $574c
D7C1: D8       cld
D7C2: 85 F5    sta dummy_write_00f5
D7C4: 6E A5 BA ror $baa5
D7C7: 4A       lsr a
D7C8: A8       tay
D7C9: B9 64 D8 lda $d864, y
D7CC: 8D 1C 18 sta $181c
D7CF: 5D 6E D8 eor $d86e, x
D7D2: 8D 1D 18 sta $181d
D7D5: 5D 69 D8 eor $d869, x
D7D8: 8D 18 18 sta $1818
D7DB: B9 82 D8 lda $d882, y
D7DE: 8D 19 18 sta $1819
D7E1: A6 1F    ldx current_player_001f
D7E3: B5 2B    lda player_pepper_002b, x
D7E5: 38       sec
D7E6: F8       sed
D7E7: E9 01    sbc #$01
D7E9: 95 2B    sta player_pepper_002b, x
D7EB: D8       cld
D7EC: A5 1B    lda $1b
D7EE: F0 06    beq $d7f6
D7F0: 20 94 CA jsr $ca94
D7F3: 85 F6    sta $f6
D7F5: 6E 60 85 ror $8560
D7F8: F5 EA    sbc $ea, x
D7FA: A5 BA    lda $ba
D7FC: 4A       lsr a
D7FD: A8       tay
D7FE: AD 1D 18 lda $181d
D801: D9 6E D8 cmp $d86e, y
D804: D0 09    bne $d80f
D806: B9 73 D8 lda $d873, y
D809: 8D 1D 18 sta $181d
D80C: 85 F6    sta $f6
D80E: EA       nop
D80F: B9 87 D8 lda $d887, y
D812: 8D 19 18 sta $1819
D815: 60       rts
D816: 85 F5    sta dummy_write_00f5
D818: EA       nop
D819: A5 BA    lda $ba
D81B: 4A       lsr a
D81C: A8       tay
D81D: AD 1D 18 lda $181d
D820: D9 73 D8 cmp $d873, y
D823: D0 09    bne $d82e
D825: B9 78 D8 lda $d878, y
D828: 8D 1D 18 sta $181d
D82B: 85 F6    sta $f6
D82D: EA       nop
D82E: B9 8C D8 lda $d88c, y
D831: 8D 19 18 sta $1819
D834: 60       rts
D835: 85 F5    sta dummy_write_00f5
D837: EA       nop
D838: A5 BA    lda $ba
D83A: 4A       lsr a
D83B: A8       tay
D83C: AD 1D 18 lda $181d
D83F: D9 78 D8 cmp $d878, y
D842: D0 09    bne $d84d
D844: B9 7D D8 lda $d87d, y
D847: 8D 1D 18 sta $181d
D84A: 85 F6    sta $f6
D84C: EA       nop
D84D: B9 91 D8 lda $d891, y
D850: 8D 19 18 sta $1819
D853: 60       rts
D854: 85 F5    sta dummy_write_00f5
D856: EA       nop
D857: A9 FF    lda #$ff
D859: 85 6E    sta $6e
D85B: A9 00    lda #$00
D85D: 8D 18 18 sta $1818
D860: 85 F5    sta dummy_write_00f5
D862: EA       nop
D863: 60       rts
D864: 03 03    slo ($03, x)
D866: 01 01    ora ($01, x)
D868: 01 03    ora ($03, x)
D86A: 03 01    slo ($01, x)
D86C: 01 05    ora ($05, x)
D86E: 49 49    eor #$49
D870: 49 4B    eor #$4b
D872: 4A       lsr a
D873: 41 41    eor ($41, x)
D875: 41 48    eor ($48, x)
D877: 47 49    sre $49
D879: 49 49    eor #$49
D87B: 4B 4A    asr #$4a
D87D: 41 41    eor ($41, x)
D87F: 41 48    eor ($48, x)
D881: 47 20    sre $20
D883: 20 20 24 jsr $2420
D886: 24 21    bit $21
D888: 21 21    and ($21, x)
D88A: 25 25    and $25
D88C: 22       kil
D88D: 22       kil
D88E: 22       kil
D88F: 26 26    rol $26
D891: 23 23    rla ($23, x)
D893: 23 27    rla ($27, x)
D895: 27 85    rla $85
D897: F5 EA    sbc $ea, x
D899: A5 BA    lda $ba
D89B: C9 06    cmp #$06
D89D: F0 50    beq $d8ef
D89F: C9 08    cmp #$08
D8A1: F0 4C    beq $d8ef
D8A3: AD 1E 18 lda $181e
D8A6: 49 FF    eor #$ff
D8A8: 38       sec
D8A9: E9 28    sbc #$28
D8AB: 4A       lsr a
D8AC: 4A       lsr a
D8AD: 4A       lsr a
D8AE: 85 03    sta $03
D8B0: A9 00    lda #$00
D8B2: 85 04    sta $04
D8B4: AD 1F 18 lda $181f
D8B7: 29 F8    and #$f8
D8B9: 18       clc
D8BA: 69 10    adc #$10
D8BC: 0A       asl a
D8BD: 26 04    rol $04
D8BF: 0A       asl a
D8C0: 26 04    rol $04
D8C2: 18       clc
D8C3: 65 03    adc $03
D8C5: 85 05    sta $05
D8C7: 85 03    sta $03
D8C9: A5 04    lda $04
D8CB: 69 10    adc #$10
D8CD: 85 04    sta $04
D8CF: 18       clc
D8D0: 69 04    adc #$04
D8D2: 85 06    sta $06
D8D4: A0 24    ldy #$24
D8D6: B1 05    lda ($05), y
D8D8: 29 03    and #$03
D8DA: F0 13    beq $d8ef
D8DC: A0 04    ldy #$04
D8DE: B1 05    lda ($05), y
D8E0: 29 03    and #$03
D8E2: F0 0B    beq $d8ef
D8E4: B1 03    lda ($03), y
D8E6: 29 1F    and #$1f
D8E8: C9 04    cmp #$04
D8EA: 90 06    bcc $d8f2
D8EC: 85 F5    sta dummy_write_00f5
D8EE: EA       nop
D8EF: 4C 55 DA jmp $da55
D8F2: 85 F5    sta dummy_write_00f5
D8F4: EA       nop
D8F5: A9 08    lda #$08
D8F7: 20 5D EA jsr $ea5d
D8FA: 20 6A DA jsr $da6a
D8FD: A5 BA    lda $ba
D8FF: C9 02    cmp #$02
D901: F0 15    beq $d918
D903: C8       iny
D904: 85 F5    sta dummy_write_00f5
D906: 6E 20 58 ror $5820
D909: DA       nop
D90A: F0 1F    beq $d92b
D90C: C8       iny
D90D: C0 08    cpy #$08
D90F: D0 F6    bne $d907
D911: A0 04    ldy #$04
D913: D0 5F    bne $d974
D915: 85 F5    sta dummy_write_00f5
D917: 6E 88 85 ror $8588
D91A: F5 EA    sbc $ea, x
D91C: 20 58 DA jsr $da58
D91F: F0 2E    beq $d94f
D921: 88       dey
D922: D0 F8    bne $d91c
D924: A0 01    ldy #$01
D926: D0 4C    bne $d974
D928: 85 F5    sta dummy_write_00f5
D92A: EA       nop
D92B: 8A       txa
D92C: D0 0D    bne $d93b
D92E: 85 F5    sta dummy_write_00f5
D930: EA       nop
D931: C8       iny
D932: B1 05    lda ($05), y
D934: 29 03    and #$03
D936: D0 F9    bne $d931
D938: 85 F5    sta dummy_write_00f5
D93A: EA       nop
D93B: A2 04    ldx #$04
D93D: 85 F5    sta dummy_write_00f5
D93F: 6E 88 B1 ror $b188
D942: 03 29    slo ($29, x)
D944: 1C F0 A8 nop $a8f0, x
D947: CA       dex
D948: D0 F6    bne $d940
D94A: F0 28    beq $d974
D94C: 85 F5    sta dummy_write_00f5
D94E: 6E 8A D0 ror $d08a
D951: 0D 85 F5 ora $f585
D954: 6E 88 B1 ror $b188
D957: 05 29    ora player_lives_0029
D959: 03 D0    slo ($d0, x)
D95B: F9 85 F5 sbc $f585, y
D95E: 6E A2 04 ror $04a2
D961: 85 F5    sta dummy_write_00f5
D963: EA       nop
D964: C8       iny
D965: B1 03    lda ($03), y
D967: 29 1C    and #$1c
D969: F0 84    beq $d8ef
D96B: CA       dex
D96C: D0 F6    bne $d964
D96E: 88       dey
D96F: 88       dey
D970: 88       dey
D971: 85 F5    sta dummy_write_00f5
D973: EA       nop
D974: A9 09    lda #$09
D976: 20 5D EA jsr $ea5d
D979: 98       tya
D97A: 18       clc
D97B: 65 03    adc $03
D97D: 85 07    sta $07
D97F: C9 04    cmp #$04
D981: 69 00    adc #$00
D983: 29 03    and #$03
D985: 85 08    sta $08
D987: C9 07    cmp #$07
D989: 29 1F    and #$1f
D98B: 0A       asl a
D98C: 0A       asl a
D98D: 0A       asl a
D98E: 85 09    sta $09
D990: 46 08    lsr $08
D992: 66 07    ror $07
D994: A2 08    ldx #$08
D996: AA       tax
D997: 07 A5    slo $a5
D999: 07 29    slo player_lives_0029
D99B: F8       sed
D99C: 85 07    sta $07
D99E: 4A       lsr a
D99F: 00       brk
D9A0: 85 F5    sta dummy_write_00f5
D9A2: EA       nop
D9A3: BD 02 02 lda $0202, x
D9A6: F0 1E    beq $d9c6
D9A8: BD 03 02 lda $0203, x
D9AB: 49 FF    eor #$ff
D9AD: 29 F8    and #$f8
D9AF: C5 09    cmp $09
D9B1: D0 0C    bne $d9bf
D9B3: BD 04 02 lda $0204, x
D9B6: 29 F8    and #$f8
D9B8: C5 07    cmp $07
D9BA: F0 10    beq $d9cc
D9BC: 85 F5    sta dummy_write_00f5
D9BE: 6E E8 E8 ror $e8e8
D9C1: E8       inx
D9C2: E8       inx
D9C3: 4C A3 D9 jmp $d9a3
D9C6: 4C 31 DA jmp $da31
D9C9: 85 F5    sta dummy_write_00f5
D9CB: EA       nop
D9CC: BD 02 02 lda $0202, x
D9CF: C9 0F    cmp #$0f
D9D1: B0 EC    bcs $d9bf
D9D3: 29 0F    and #$0f
D9D5: 09 10    ora #$10
D9D7: 9D 02 02 sta $0202, x
D9DA: BD 04 02 lda $0204, x
D9DD: 29 FC    and #$fc
D9DF: 09 04    ora #$04
D9E1: 9D 04 02 sta $0204, x
D9E4: 4D 01 9D eor $9d01
D9E7: 05 02    ora $02
D9E9: A0 00    ldy #$00
D9EB: 84 0A    sty $0a
D9ED: C1 F5    cmp (dummy_write_00f5, x)
D9EF: 6E A4 0A ror $0aa4
D9F2: B9 68 00 lda $0068, y
D9F5: 29 A0    and #$a0
D9F7: D0 2D    bne $da26
D9F9: 98       tya
D9FA: 0A       asl a
D9FB: 0A       asl a
D9FC: A8       tay
D9FD: B9 02 18 lda $1802, y
DA00: 18       clc
DA01: 69 08    adc #$08
DA03: DD 03 02 cmp $0203, x
DA06: B0 1E    bcs $da26
DA08: 18       clc
DA09: 69 20    adc #$20
DA0B: DD 03 02 cmp $0203, x
DA0E: 90 16    bcc $da26
DA10: B9 03 18 lda $1803, y
DA13: 29 F8    and #$f8
DA15: 18       clc
DA16: 69 10    adc #$10
DA18: 85 0B    sta $0b
DA1A: BD 04 02 lda $0204, x
DA1D: 29 F8    and #$f8
DA1F: C5 0B    cmp $0b
DA21: F0 13    beq $da36
DA23: 85 F5    sta dummy_write_00f5
DA25: EA       nop
DA26: E6 0A    inc $0a
DA28: A4 0A    ldy $0a
DA2A: C0 06    cpy #$06
DA2C: D0 C2    bne $d9f0
DA2E: 85 F5    sta dummy_write_00f5
DA30: EA       nop
DA31: F0 22    beq $da55
DA33: 85 F5    sta dummy_write_00f5
DA35: EA       nop
DA36: A4 0A    ldy $0a
DA38: B9 68 00 lda $0068, y
DA3B: 29 0F    and #$0f
DA3D: 09 40    ora #$40
DA3F: 99 68 00 sta $0068, y
DA42: 96 B1    stx $b1, y
DA44: FE 05 02 inc $0205, x
DA47: FE 05 02 inc $0205, x
DA4A: A9 12    lda #$12
DA4C: 20 5D EA jsr $ea5d
DA4F: 4C 26 DA jmp $da26
DA52: 85 F5    sta dummy_write_00f5
DA54: EA       nop
DA55: 60       rts
DA56: 85 F5    sta dummy_write_00f5
DA58: EA       nop
DA59: A2 FF    ldx #$ff
DA5B: B1 05    lda ($05), y
DA5D: 29 03    and #$03
DA5F: F0 25    beq $da86
DA61: E8       inx
DA62: B1 03    lda ($03), y
DA64: 29 1C    and #$1c
DA66: F0 1E    beq $da86
DA68: 85 F5    sta dummy_write_00f5
DA6A: EA       nop
DA6B: 84 12    sty $12
DA6D: 18       clc
DA6E: B1 03    lda ($03), y
DA70: 69 04    adc #$04
DA72: 91 03    sta ($03), y
DA74: 18       clc
DA75: 98       tya
DA76: 69 20    adc #$20
DA78: A8       tay
DA79: B1 03    lda ($03), y
DA7B: 69 04    adc #$04
DA7D: 91 03    sta ($03), y
DA7F: A4 12    ldy $12
DA81: A9 FF    lda #$ff
DA83: 85 F5    sta dummy_write_00f5
DA85: EA       nop
DA86: 60       rts
DA87: 85 F5    sta dummy_write_00f5
DA89: EA       nop
DA8A: A0 00    ldy #$00
DA8C: AD 04 40 lda $4004
DA8F: 29 08    and #$08
DA91: D0 05    bne $da98
DA93: A0 06    ldy #$06
DA95: 85 F5    sta dummy_write_00f5
DA97: EA       nop
DA98: 18       clc
DA99: 98       tya
DA9A: 65 64    adc $64
DA9C: AA       tax
DA9D: BD 02 DB lda $db02, x
DAA0: 85 BC    sta $bc
DAA2: BD 0E DB lda $db0e, x
DAA5: 85 BD    sta $bd
DAA7: BD 1A DB lda $db1a, x
DAAA: 85 BE    sta $be
DAAC: A9 00    lda #$00
DAAE: 85 C2    sta $c2
DAB0: 85 C3    sta $c3
DAB2: 85 BF    sta $bf
DAB4: 85 C0    sta $c0
DAB6: 85 C1    sta $c1
DAB8: 85 90    sta $90
DABA: A6 1F    ldx current_player_001f
DABC: B5 61    lda $61, x
DABE: 4A       lsr a
DABF: 4A       lsr a
DAC0: 85 03    sta $03
DAC2: C9 08    cmp #$08
DAC4: 90 02    bcc $dac8
DAC6: A9 07    lda #$07
DAC8: AA       tax
DAC9: BD F0 DA lda $daf0, x
DACC: A0 05    ldy #$05
DACE: 85 F5    sta dummy_write_00f5
DAD0: EA       nop
DAD1: 99 91 00 sta $0091, y
DAD4: 88       dey
DAD5: 10 FA    bpl $dad1
DAD7: BD F9 DA lda $daf9, x
DADA: A0 05    ldy #$05
DADC: 85 F5    sta dummy_write_00f5
DADE: EA       nop
DADF: 99 A1 00 sta $00a1, y
DAE2: 88       dey
DAE3: 10 FA    bpl $dadf
DAE5: AD F4 DA lda $daf4
DAE8: 85 98    sta $98
DAEA: AD FD DA lda $dafd
DAED: 85 A8    sta game_speed_00a8
DAEF: 60       rts
DAF0: 0F 03 07 slo $0703
DAF3: 0F 03 07 slo $0703
DAF6: 0F 03 07 slo $0703
DAF9: 04 03    nop $03
DAFB: 03 03    slo ($03, x)
DAFD: 02       kil
DAFE: 02       kil
DAFF: 02       kil
DB00: 01 01    ora ($01, x)
DB02: 03 03    slo ($03, x)
DB04: 02       kil
DB05: 04 00    nop $00
DB07: 02       kil
DB08: 05 05    ora $05
DB0A: 02       kil
DB0B: 04 00    nop $00
DB0D: 02       kil
DB0E: 00       brk
DB0F: 00       brk
DB10: 03 02    slo ($02, x)
DB12: 02       kil
DB13: 02       kil
DB14: 00       brk
DB15: 00       brk
DB16: 03 02    slo ($02, x)
DB18: 02       kil
DB19: 02       kil
DB1A: 01 01    ora ($01, x)
DB1C: 01 00    ora ($00, x)
DB1E: 04 02    nop $02
DB20: 01 01    ora ($01, x)
DB22: 01 00    ora ($00, x)
DB24: 04 02    nop $02
DB26: 85 F5    sta dummy_write_00f5
DB28: EA       nop
DB29: A5 6F    lda game_state_006f
DB2B: 30 6E    bmi $db9b
DB2D: A5 13    lda timer1_0013
DB2F: 29 1F    and #$1f
DB31: D0 68    bne $db9b
DB33: E6 C2    inc $c2
DB35: CA       dex
DB36: C2 E0    nop #$e0
DB38: 03 D0    slo ($d0, x)
DB3A: 02       kil
DB3B: A2 00    ldx #$00
DB3D: 86 C2    stx $c2
DB3F: D9 BC D5 cmp $d5bc, y
DB42: BF F0 56 lax $56f0, y
DB45: A0 00    ldy #$00
DB47: 85 F5    sta dummy_write_00f5
DB49: EA       nop
DB4A: B9 68 00 lda $0068, y
DB4D: C9 FF    cmp #$ff
DB4F: F0 0B    beq $db5c
DB51: C8       iny
DB52: C0 06    cpy #$06
DB54: D0 F4    bne $db4a
DB56: 4C 9B DB jmp $db9b
DB59: 85 F5    sta dummy_write_00f5
DB5B: EA       nop
DB5C: F6 BF    inc $bf, x
DB5E: 6C 8A 09 jmp ($098a)
DB61: 20 99 68 jsr $6899
DB64: 00       brk
DB65: C0 0A    cpy #$0a
DB67: 4D 01 99 eor $9901
DB6A: 99 00 EA sta $ea00, y
DB6D: C3 C9    dcp ($c9, x)
DB6F: C3 29    dcp ($29, x)
DB71: 03 85    slo ($85, x)
DB73: C3 0D    dcp ($0d, x)
DB75: 01 AA    ora ($aa, x)
DB77: BD 9C DB lda $db9c, x
DB7A: 99 A9 00 sta $00a9, y
DB7D: 54 0A    nop $0a, x
DB7F: 0A       asl a
DB80: A8       tay
DB81: BD 9E DB lda $db9e, x
DB84: 99 02 18 sta $1802, y
DB87: C9 63    cmp #$63
DB89: 0A       asl a
DB8A: 0A       asl a
DB8B: 18       clc
DB8C: 65 C3    adc $c3
DB8E: AA       tax
DB8F: BD A1 DB lda $dba1, x
DB92: 99 03 18 sta $1803, y
DB95: 08       php
DB96: EB DC    sbc #$dc
DB98: 85 F5    sta dummy_write_00f5
DB9A: EA       nop
DB9B: 60       rts
DB9C: 20 40 F0 jsr $f040
DB9F: 00       brk
DBA0: 1D 1D AD ora $ad1d, x
DBA3: AD 1D 1D lda $1d1d
DBA6: 5D 5D 1D eor $1d5d, x
DBA9: 1D 8D AD ora $ad8d, x
DBAC: 1D 1D 8D ora $8d1d, x
DBAF: 8D 1D 1D sta $1d1d
DBB2: CD CD 1D cmp $1dcd
DBB5: 2D 9D 8D and $8d9d
DBB8: 80 85    nop #$85
DBBA: F5 EA    sbc $ea, x
DBBC: A5 6F    lda game_state_006f
DBBE: 30 1C    bmi $dbdc
DBC0: A2 00    ldx #$00
DBC2: 85 F5    sta dummy_write_00f5
DBC4: 6E B5 68 ror $68b5
DBC7: 29 D0    and #$d0
DBC9: D0 09    bne $dbd4
DBCB: B5 68    lda $68, x
DBCD: 29 20    and #$20
DBCF: D0 0F    bne $dbe0
DBD1: 85 F5    sta dummy_write_00f5
DBD3: EA       nop
DBD4: E8       inx
DBD5: E0 06    cpx #$06
DBD7: D0 EC    bne $dbc5
DBD9: 85 F5    sta dummy_write_00f5
DBDB: EA       nop
DBDC: 60       rts
DBDD: 85 F5    sta dummy_write_00f5
DBDF: 6E 86 70 ror $7086
DBE2: B5 A9    lda $a9, x
DBE4: 85 71    sta $71
DBE6: 46 0A    lsr $0a
DBE8: 0A       asl a
DBE9: A8       tay
DBEA: B9 02 18 lda $1802, y
DBED: 85 03    sta $03
DBEF: 5D 03 18 eor $1803, x
DBF2: 85 04    sta $04
DBF4: C9 03    cmp #$03
DBF6: C9 D9    cmp #$d9
DBF8: B0 54    bcs $dc4e
DBFA: C9 18    cmp #$18
DBFC: 90 60    bcc $dc5e
DBFE: 20 B6 E0 jsr $e0b6
DC01: D0 42    bne $dc45
DC03: C9 10    cmp #$10
DC05: F0 13    beq $dc1a
DC07: C9 40    cmp #$40
DC09: F0 0F    beq $dc1a
DC0B: C9 70    cmp #$70
DC0D: F0 0B    beq $dc1a
DC0F: C9 A0    cmp #$a0
DC11: F0 07    beq $dc1a
DC13: C9 D0    cmp #$d0
DC15: D0 2E    bne $dc45
DC17: 85 F5    sta dummy_write_00f5
DC19: EA       nop
DC1A: 20 9D E0 jsr $e09d
DC1D: D0 0D    bne $dc2c
DC1F: 20 7B E0 jsr $e07b
DC22: F0 13    beq $dc37
DC24: 20 8C E0 jsr $e08c
DC27: F0 0E    beq $dc37
DC29: 85 F5    sta dummy_write_00f5
DC2B: EA       nop
DC2C: 20 59 E0 jsr $e059
DC2F: F0 06    beq $dc37
DC31: 4C 6B DC jmp $dc6b
DC34: 85 F5    sta dummy_write_00f5
DC36: EA       nop
DC37: A6 70    ldx $70
DC39: B5 68    lda $68, x
DC3B: 29 0F    and #$0f
DC3D: 95 68    sta $68, x
DC3F: 4C 6B DC jmp $dc6b
DC42: 85 F5    sta dummy_write_00f5
DC44: EA       nop
DC45: A5 03    lda $03
DC47: C9 80    cmp #$80
DC49: B0 13    bcs $dc5e
DC4B: 85 F5    sta dummy_write_00f5
DC4D: EA       nop
DC4E: A6 70    ldx $70
DC50: B5 A9    lda $a9, x
DC52: 29 0F    and #$0f
DC54: 09 20    ora #$20
DC56: 95 A9    sta $a9, x
DC58: 4C 6B DC jmp $dc6b
DC5B: 85 F5    sta dummy_write_00f5
DC5D: EA       nop
DC5E: A6 70    ldx $70
DC60: B5 A9    lda $a9, x
DC62: 29 0F    and #$0f
DC64: 09 40    ora #$40
DC66: 95 A9    sta $a9, x
DC68: 85 F5    sta dummy_write_00f5
DC6A: EA       nop
DC6B: A6 70    ldx $70
DC6D: 20 69 D2 jsr $d269
DC70: A6 70    ldx $70
DC72: 4C D4 DB jmp $dbd4
DC75: 85 F5    sta dummy_write_00f5
DC77: EA       nop
DC78: A5 13    lda timer1_0013
DC7A: 29 3F    and #$3f
DC7C: D0 6A    bne $dce8
DC7E: E6 90    inc $90
DC80: A5 90    lda $90
DC82: C9 14    cmp #$14
DC84: 90 2E    bcc $dcb4
DC86: A9 00    lda #$00
DC88: 85 90    sta $90
DC8A: A2 05    ldx #$05
DC8C: 85 F5    sta dummy_write_00f5
DC8E: EA       nop
DC8F: B5 91    lda $91, x
DC91: 29 10    and #$10
DC93: F0 11    beq $dca6
DC95: B5 A1    lda $a1, x
DC97: C9 02    cmp #$02
DC99: F0 13    beq $dcae
DC9B: D6 A1    dec $a1, x
DC9D: A9 03    lda #$03
DC9F: 95 91    sta $91, x
DCA1: D0 0B    bne $dcae
DCA3: 85 F5    sta dummy_write_00f5
DCA5: EA       nop
DCA6: 38       sec
DCA7: B5 91    lda $91, x
DCA9: 36 91    rol $91, x
DCAB: 85 F5    sta dummy_write_00f5
DCAD: EA       nop
DCAE: CA       dex
DCAF: 10 DE    bpl $dc8f
DCB1: 85 F5    sta dummy_write_00f5
DCB3: EA       nop
DCB4: A0 05    ldy #$05
DCB6: A2 14    ldx #$14
DCB8: 85 F5    sta dummy_write_00f5
DCBA: EA       nop
DCBB: B9 68 00 lda $0068, y
DCBE: 30 09    bmi $dcc9
DCC0: B5 73    lda $73, x
DCC2: F0 11    beq $dcd5
DCC4: D6 73    dec $73, x
DCC6: 85 F5    sta dummy_write_00f5
DCC8: EA       nop
DCC9: 88       dey
DCCA: CA       dex
DCCB: CA       dex
DCCC: CA       dex
DCCD: CA       dex
DCCE: 10 EB    bpl $dcbb
DCD0: 30 16    bmi $dce8
DCD2: 85 F5    sta dummy_write_00f5
DCD4: EA       nop
DCD5: 8A       txa
DCD6: 48       pha
DCD7: 98       tya
DCD8: 48       pha
DCD9: 84 0A    sty $0a
DCDB: 20 EB DC jsr $dceb
DCDE: 68       pla
DCDF: A8       tay
DCE0: 68       pla
DCE1: AA       tax
DCE2: 4C C9 DC jmp $dcc9
DCE5: 85 F5    sta dummy_write_00f5
DCE7: EA       nop
DCE8: 60       rts
DCE9: 85 F5    sta dummy_write_00f5
DCEB: EA       nop
DCEC: A4 0A    ldy $0a
DCEE: B9 68 00 lda $0068, y
DCF1: 29 03    and #$03
DCF3: 0A       asl a
DCF4: A8       tay
DCF5: B9 2A DD lda $dd2a, y
DCF8: 85 03    sta $03
DCFA: B9 2B DD lda $dd2b, y
DCFD: 85 04    sta $04
DCFF: B9 30 DD lda $dd30, y
DD02: 85 05    sta $05
DD04: 5D 31 DD eor $dd31, x
DD07: 85 06    sta $06
DD09: A5 0A    lda $0a
DD0B: 0A       asl a
DD0C: 0A       asl a
DD0D: AA       tax
DD0E: B4 75    ldy $75, x
DD10: B1 03    lda ($03), y
DD12: 95 72    sta $72, x
DD14: 59 05 95 eor $9505, y
DD17: 73 A9    rra ($a9), y
DD19: 00       brk
DD1A: 95 74    sta $74, x
DD1C: FA       nop
DD1D: 75 D8    adc $d8, x
DD1F: 75 B1    adc $b1, x
DD21: 03 10    slo ($10, x)
DD23: 07 A9    slo $a9
DD25: 00       brk
DD26: 95 75    sta $75, x
DD28: 85 F5    sta dummy_write_00f5
DD2A: EA       nop
DD2B: 60       rts
DD2C: 38       sec
DD2D: DD 4D DD cmp $dd4d, x
DD30: 5A       nop
DD31: DD 43 DD cmp $dd43, x
DD34: 54 DD    nop $dd, x
DD36: 5F DD 04 sre $04dd, x
DD39: 03 04    slo ($04, x)
DD3B: 05 04    ora $04
DD3D: 04 05    nop $05
DD3F: 04 04    nop $04
DD41: 04 FF    nop $ff
DD43: 03 03    slo ($03, x)
DD45: 07 05    slo $05
DD47: 03 03    slo ($03, x)
DD49: 05 03    ora $03
DD4B: 03 03    slo ($03, x)
DD4D: 03 03    slo ($03, x)
DD4F: 04 03    nop $03
DD51: 03 04    slo ($04, x)
DD53: FF 03 03 isb $0303, x
DD56: 07 09    slo $09
DD58: 0D 03 05 ora $0503
DD5B: 05 04    ora $04
DD5D: 05 FF    ora $ff
DD5F: 09 17    ora #$17
DD61: 09 13    ora #$13
DD63: 85 F5    sta dummy_write_00f5
DD65: 6E A5 6F ror $6fa5
DD68: 30 19    bmi $dd83
DD6A: A2 05    ldx #$05
DD6C: 86 70    stx $70
DD6E: C1 F5    cmp (dummy_write_00f5, x)
DD70: EA       nop
DD71: A6 70    ldx $70
DD73: B5 68    lda $68, x
DD75: 29 F0    and #$f0
DD77: F0 0E    beq $dd87
DD79: 85 F5    sta dummy_write_00f5
DD7B: EA       nop
DD7C: C6 70    dec $70
DD7E: 10 F1    bpl $dd71
DD80: 85 F5    sta dummy_write_00f5
DD82: EA       nop
DD83: 60       rts
DD84: 85 F5    sta dummy_write_00f5
DD86: 6E 8A 0A ror $0a8a
DD89: 0A       asl a
DD8A: A8       tay
DD8B: B9 02 18 lda $1802, y
DD8E: 85 03    sta $03
DD90: B9 03 18 lda $1803, y
DD93: 85 04    sta $04
DD95: D9 8A F0 cmp $f08a, y
DD98: 0B D6    anc #$d6
DD9A: 8A       txa
DD9B: 85 F5    sta dummy_write_00f5
DD9D: 6E 4C BB ror $bb4c
DDA0: DE 85 F5 dec $f585, x
DDA3: EA       nop
DDA4: 20 9D E0 jsr $e09d
DDA7: D0 F5    bne $dd9e
DDA9: 20 B6 E0 jsr $e0b6
DDAC: D0 F0    bne $dd9e
DDAE: AD 1E 18 lda $181e
DDB1: 85 17    sta $17
DDB3: AD 1F 18 lda $181f
DDB6: 85 18    sta $18
DDB8: A5 70    lda $70
DDBA: 0A       asl a
DDBB: 0A       asl a
DDBC: AA       tax
DDBD: B4 72    ldy $72, x
DDBF: F0 11    beq $ddd2
DDC1: 88       dey
DDC2: F0 14    beq $ddd8
DDC4: 88       dey
DDC5: F0 17    beq $ddde
DDC7: 88       dey
DDC8: F0 1A    beq $dde4
DDCA: 88       dey
DDCB: F0 20    beq $dded
DDCD: D0 44    bne $de13
DDCF: 85 F5    sta dummy_write_00f5
DDD1: EA       nop
DDD2: 4C ED DD jmp $dded
DDD5: 85 F5    sta dummy_write_00f5
DDD7: 6E 4C 13 ror $134c
DDDA: DE 85 F5 dec $f585, x
DDDD: 6E 4C ED ror $ed4c
DDE0: DD 85 F5 cmp $f585, x
DDE3: EA       nop
DDE4: A5 17    lda $17
DDE6: 69 08    adc #$08
DDE8: 85 17    sta $17
DDEA: 85 F5    sta dummy_write_00f5
DDEC: 6E A6 70 ror $70a6
DDEF: B5 A9    lda $a9, x
DDF1: 85 71    sta $71
DDF3: 29 F0    and #$f0
DDF5: C9 20    cmp #$20
DDF7: 85 F5    sta dummy_write_00f5
DDF9: EA       nop
DDFA: F0 23    beq $de1f
DDFC: C9 40    cmp #$40
DDFE: 85 F5    sta dummy_write_00f5
DE00: EA       nop
DE01: F0 31    beq $de34
DE03: C9 60    cmp #$60
DE05: 85 F5    sta dummy_write_00f5
DE07: EA       nop
DE08: F0 3F    beq $de49
DE0A: 85 F5    sta dummy_write_00f5
DE0C: EA       nop
DE0D: 4C 5E DE jmp $de5e
DE10: 85 F5    sta dummy_write_00f5
DE12: EA       nop
DE13: A5 18    lda $18
DE15: 69 08    adc #$08
DE17: 85 18    sta $18
DE19: 4C ED DD jmp $dded
DE1C: 85 F5    sta dummy_write_00f5
DE1E: EA       nop
DE1F: A5 18    lda $18
DE21: 29 F8    and #$f8
DE23: 85 05    sta $05
DE25: A5 04    lda $04
DE27: 29 F8    and #$f8
DE29: C5 05    cmp $05
DE2B: B0 46    bcs $de73
DE2D: F0 4A    beq $de79
DE2F: 90 4E    bcc $de7f
DE31: 85 F5    sta dummy_write_00f5
DE33: EA       nop
DE34: A5 18    lda $18
DE36: 29 F8    and #$f8
DE38: 85 05    sta $05
DE3A: A5 04    lda $04
DE3C: 29 F8    and #$f8
DE3E: C5 05    cmp $05
DE40: B0 43    bcs $de85
DE42: F0 47    beq $de8b
DE44: 90 4B    bcc $de91
DE46: 85 F5    sta dummy_write_00f5
DE48: EA       nop
DE49: A5 17    lda $17
DE4B: 29 F8    and #$f8
DE4D: 85 05    sta $05
DE4F: A5 03    lda $03
DE51: 29 F8    and #$f8
DE53: C5 05    cmp $05
DE55: 90 4C    bcc $dea3
DE57: F0 44    beq $de9d
DE59: B0 3C    bcs $de97
DE5B: 85 F5    sta dummy_write_00f5
DE5D: EA       nop
DE5E: A5 17    lda $17
DE60: 29 F8    and #$f8
DE62: 85 05    sta $05
DE64: A5 03    lda $03
DE66: 29 F8    and #$f8
DE68: C5 05    cmp $05
DE6A: 90 49    bcc $deb5
DE6C: F0 41    beq $deaf
DE6E: B0 39    bcs $dea9
DE70: 85 F5    sta dummy_write_00f5
DE72: EA       nop
DE73: 4C E7 DE jmp $dee7
DE76: 85 F5    sta dummy_write_00f5
DE78: EA       nop
DE79: 4C 01 DF jmp $df01
DE7C: 85 F5    sta dummy_write_00f5
DE7E: EA       nop
DE7F: 4C 1B DF jmp $df1b
DE82: 85 F5    sta dummy_write_00f5
DE84: EA       nop
DE85: 4C 35 DF jmp $df35
DE88: 85 F5    sta dummy_write_00f5
DE8A: EA       nop
DE8B: 4C 55 DF jmp $df55
DE8E: 85 F5    sta dummy_write_00f5
DE90: EA       nop
DE91: 4C 6F DF jmp $df6f
DE94: 85 F5    sta dummy_write_00f5
DE96: EA       nop
DE97: 4C 89 DF jmp $df89
DE9A: 85 F5    sta dummy_write_00f5
DE9C: EA       nop
DE9D: 4C A3 DF jmp $dfa3
DEA0: 85 F5    sta dummy_write_00f5
DEA2: EA       nop
DEA3: 4C BD DF jmp $dfbd
DEA6: 85 F5    sta dummy_write_00f5
DEA8: EA       nop
DEA9: 4C D7 DF jmp $dfd7
DEAC: 85 F5    sta dummy_write_00f5
DEAE: EA       nop
DEAF: 4C F1 DF jmp $dff1
DEB2: 85 F5    sta dummy_write_00f5
DEB4: EA       nop
DEB5: 4C 0B E0 jmp $e00b
DEB8: 85 F5    sta dummy_write_00f5
DEBA: EA       nop
DEBB: A6 70    ldx $70
DEBD: 20 C3 D3 jsr $d3c3
DEC0: D0 0B    bne $decd
DEC2: A6 70    ldx $70
DEC4: 20 69 D2 jsr $d269
DEC7: 4C 7C DD jmp $dd7c
DECA: 85 F5    sta dummy_write_00f5
DECC: EA       nop
DECD: A6 70    ldx $70
DECF: B5 A9    lda $a9, x
DED1: 85 71    sta $71
DED3: 29 F0    and #$f0
DED5: C9 20    cmp #$20
DED7: F0 28    beq $df01
DED9: C9 40    cmp #$40
DEDB: F0 AE    beq $de8b
DEDD: C9 60    cmp #$60
DEDF: F0 BC    beq $de9d
DEE1: 4C F1 DF jmp $dff1
DEE4: 85 F5    sta dummy_write_00f5
DEE6: EA       nop
DEE7: 20 59 E0 jsr $e059
DEEA: F0 63    beq $df4f
DEEC: 20 7B E0 jsr $e07b
DEEF: F0 5E    beq $df4f
DEF1: 20 8C E0 jsr $e08c
DEF4: F0 59    beq $df4f
DEF6: 20 6A E0 jsr $e06a
DEF9: F0 54    beq $df4f
DEFB: 4C 3D E0 jmp $e03d
DEFE: 85 F5    sta dummy_write_00f5
DF00: EA       nop
DF01: 20 7B E0 jsr $e07b
DF04: F0 49    beq $df4f
DF06: 20 59 E0 jsr $e059
DF09: F0 44    beq $df4f
DF0B: 20 6A E0 jsr $e06a
DF0E: F0 3F    beq $df4f
DF10: 20 8C E0 jsr $e08c
DF13: F0 3A    beq $df4f
DF15: 4C 3D E0 jmp $e03d
DF18: 85 F5    sta dummy_write_00f5
DF1A: EA       nop
DF1B: 20 6A E0 jsr $e06a
DF1E: F0 2F    beq $df4f
DF20: 20 7B E0 jsr $e07b
DF23: F0 2A    beq $df4f
DF25: 20 8C E0 jsr $e08c
DF28: F0 25    beq $df4f
DF2A: 20 59 E0 jsr $e059
DF2D: F0 20    beq $df4f
DF2F: 4C 3D E0 jmp $e03d
DF32: 85 F5    sta dummy_write_00f5
DF34: 6E 20 59 ror $5920
DF37: E0 F0    cpx #$f0
DF39: 15 20    ora $20, x
DF3B: 8C E0 F0 sty $f0e0
DF3E: 10 20    bpl $df60
DF40: 6A       ror a
DF41: E0 F0    cpx #$f0
DF43: 0B 20    anc #$20
DF45: 7B E0 F0 rra $f0e0, y
DF48: 06 4C    asl $4c
DF4A: 3D E0 85 and $85e0, x
DF4D: F5 6E    sbc $6e, x
DF4F: 4C 25 E0 jmp $e025
DF52: 85 F5    sta dummy_write_00f5
DF54: 6E 20 8C ror $8c20
DF57: E0 F0    cpx #$f0
DF59: F5 20    sbc $20, x
DF5B: 6A       ror a
DF5C: E0 F0    cpx #$f0
DF5E: F0 20    beq $df80
DF60: 59 E0 F0 eor $f0e0, y
DF63: EB 20    sbc #$20
DF65: 7B E0 F0 rra $f0e0, y
DF68: E6 4C    inc $4c
DF6A: 3D E0 85 and $85e0, x
DF6D: F5 6E    sbc $6e, x
DF6F: 20 6A E0 jsr $e06a
DF72: F0 DB    beq $df4f
DF74: 20 8C E0 jsr $e08c
DF77: F0 D6    beq $df4f
DF79: 20 59 E0 jsr $e059
DF7C: F0 D1    beq $df4f
DF7E: 20 7B E0 jsr $e07b
DF81: F0 CC    beq $df4f
DF83: 4C 3D E0 jmp $e03d
DF86: 85 F5    sta dummy_write_00f5
DF88: EA       nop
DF89: 20 7B E0 jsr $e07b
DF8C: F0 C1    beq $df4f
DF8E: 20 59 E0 jsr $e059
DF91: F0 BC    beq $df4f
DF93: 20 8C E0 jsr $e08c
DF96: F0 B7    beq $df4f
DF98: 20 6A E0 jsr $e06a
DF9B: F0 B2    beq $df4f
DF9D: 4C 3D E0 jmp $e03d
DFA0: 85 F5    sta dummy_write_00f5
DFA2: EA       nop
DFA3: 20 59 E0 jsr $e059
DFA6: F0 7D    beq $e025
DFA8: 20 7B E0 jsr $e07b
DFAB: F0 78    beq $e025
DFAD: 20 8C E0 jsr $e08c
DFB0: F0 73    beq $e025
DFB2: 20 6A E0 jsr $e06a
DFB5: F0 6E    beq $e025
DFB7: 4C 3D E0 jmp $e03d
DFBA: 85 F5    sta dummy_write_00f5
DFBC: 6E 20 8C ror $8c20
DFBF: E0 F0    cpx #$f0
DFC1: 63 20    rra ($20, x)
DFC3: 59 E0 F0 eor $f0e0, y
DFC6: 5E 20 7B lsr $7b20, x
DFC9: E0 F0    cpx #$f0
DFCB: 59 20 6A eor $6a20, y
DFCE: E0 F0    cpx #$f0
DFD0: 54 4C    nop $4c, x
DFD2: 3D E0 85 and $85e0, x
DFD5: F5 6E    sbc $6e, x
DFD7: 20 7B E0 jsr $e07b
DFDA: F0 49    beq $e025
DFDC: 20 6A E0 jsr $e06a
DFDF: F0 44    beq $e025
DFE1: 20 8C E0 jsr $e08c
DFE4: F0 3F    beq $e025
DFE6: 20 59 E0 jsr $e059
DFE9: F0 3A    beq $e025
DFEB: 4C 3D E0 jmp $e03d
DFEE: 85 F5    sta dummy_write_00f5
DFF0: EA       nop
DFF1: 20 6A E0 jsr $e06a
DFF4: F0 2F    beq $e025
DFF6: 20 8C E0 jsr $e08c
DFF9: F0 2A    beq $e025
DFFB: 20 7B E0 jsr $e07b
DFFE: F0 25    beq $e025
E000: 20 59 E0 jsr $e059
E003: F0 20    beq $e025
E005: 4C 3D E0 jmp $e03d
E008: 85 F5    sta dummy_write_00f5
E00A: EA       nop
E00B: 20 8C E0 jsr $e08c
E00E: F0 15    beq $e025
E010: 20 6A E0 jsr $e06a
E013: F0 10    beq $e025
E015: 20 7B E0 jsr $e07b
E018: F0 0B    beq $e025
E01A: 20 59 E0 jsr $e059
E01D: F0 06    beq $e025
E01F: 4C 3D E0 jmp $e03d
E022: 85 F5    sta dummy_write_00f5
E024: EA       nop
E025: A6 70    ldx $70
E027: A9 00    lda #$00
E029: 95 74    sta $74, x
E02B: A9 10    lda #$10
E02D: 95 8A    sta $8a, x
E02F: 85 F5    sta dummy_write_00f5
E031: EA       nop
E032: A6 70    ldx $70
E034: 20 69 D2 jsr $d269
E037: 4C 7B DD jmp $dd7b
E03A: 85 F5    sta dummy_write_00f5
E03C: EA       nop
E03D: A6 70    ldx $70
E03F: B5 68    lda $68, x
E041: 29 03    and #$03
E043: AA       tax
E044: D6 BE    dec $be, x
E046: A6 70    ldx $70
E048: 0A       asl a
E049: 0A       asl a
E04A: A8       tay
E04B: A9 00    lda #$00
E04D: 99 00 18 sta $1800, y
E050: A9 FF    lda #$ff
E052: 95 68    sta $68, x
E054: 4C 7C DD jmp $dd7c
E057: 85 F5    sta dummy_write_00f5
E059: EA       nop
E05A: A6 70    ldx $70
E05C: A5 71    lda $71
E05E: 29 0F    and #$0f
E060: 09 60    ora #$60
E062: 95 A9    sta $a9, x
E064: 20 C3 D3 jsr $d3c3
E067: 60       rts
E068: 85 F5    sta dummy_write_00f5
E06A: EA       nop
E06B: A6 70    ldx $70
E06D: A5 71    lda $71
E06F: 29 0F    and #$0f
E071: 09 80    ora #$80
E073: 95 A9    sta $a9, x
E075: 20 C3 D3 jsr $d3c3
E078: 60       rts
E079: 85 F5    sta dummy_write_00f5
E07B: EA       nop
E07C: A6 70    ldx $70
E07E: A5 71    lda $71
E080: 29 0F    and #$0f
E082: 09 20    ora #$20
E084: 95 A9    sta $a9, x
E086: 20 C3 D3 jsr $d3c3
E089: 60       rts
E08A: 85 F5    sta dummy_write_00f5
E08C: EA       nop
E08D: A6 70    ldx $70
E08F: A5 71    lda $71
E091: 29 0F    and #$0f
E093: 09 40    ora #$40
E095: 95 A9    sta $a9, x
E097: 20 C3 D3 jsr $d3c3
E09A: 60       rts
E09B: 85 F5    sta dummy_write_00f5
E09D: EA       nop
E09E: A5 04    lda $04
E0A0: 29 0F    and #$0f
E0A2: C9 0F    cmp #$0f
E0A4: F0 0D    beq $e0b3
E0A6: C9 0E    cmp #$0e
E0A8: F0 09    beq $e0b3
E0AA: C9 0D    cmp #$0d
E0AC: F0 05    beq $e0b3
E0AE: C9 0C    cmp #$0c
E0B0: 85 F5    sta dummy_write_00f5
E0B2: EA       nop
E0B3: 60       rts
E0B4: 85 F5    sta dummy_write_00f5
E0B6: EA       nop
E0B7: A5 03    lda $03
E0B9: 85 08    sta $08
E0BB: E6 08    inc $08
E0BD: E6 08    inc $08
E0BF: A5 08    lda $08
E0C1: 29 0C    and #$0c
E0C3: F0 1E    beq $e0e3
E0C5: C9 08    cmp #$08
E0C7: D0 2F    bne $e0f8
E0C9: A5 08    lda $08
E0CB: 29 F0    and #$f0
E0CD: C9 10    cmp #$10
E0CF: F0 27    beq $e0f8
E0D1: C9 40    cmp #$40
E0D3: F0 23    beq $e0f8
E0D5: C9 70    cmp #$70
E0D7: F0 1F    beq $e0f8
E0D9: C9 A0    cmp #$a0
E0DB: F0 1B    beq $e0f8
E0DD: C9 D0    cmp #$d0
E0DF: 60       rts
E0E0: 85 F5    sta dummy_write_00f5
E0E2: EA       nop
E0E3: A5 08    lda $08
E0E5: 29 F0    and #$f0
E0E7: C9 30    cmp #$30
E0E9: F0 0D    beq $e0f8
E0EB: C9 60    cmp #$60
E0ED: F0 09    beq $e0f8
E0EF: C9 90    cmp #$90
E0F1: F0 05    beq $e0f8
E0F3: C9 C0    cmp #$c0
E0F5: 85 F5    sta dummy_write_00f5
E0F7: EA       nop
E0F8: 60       rts
E0F9: 85 F5    sta dummy_write_00f5
E0FB: EA       nop
E0FC: 86 11    stx $11
E0FE: 84 12    sty $12
E100: A4 64    ldy $64
E102: B9 88 E1 lda $e188, y
E105: 85 C4    sta $c4
E107: C8       iny
E108: 63 98    rra ($98, x)
E10A: 0A       asl a
E10B: AA       tax
E10C: BD 76 E1 lda $e176, x
E10F: 85 03    sta $03
E111: BD 77 E1 lda $e177, x
E114: 85 04    sta $04
E116: 5D 82 E1 eor $e182, x
E119: AA       tax
E11A: A0 00    ldy #$00
E11C: 91 03    sta ($03), y
E11E: 6C 8A C8 jmp ($c88a)
E121: 91 03    sta ($03), y
E123: A0 20    ldy #$20
E125: E8       inx
E126: 8A       txa
E127: 91 03    sta ($03), y
E129: E8       inx
E12A: 8A       txa
E12B: C8       iny
E12C: 91 03    sta ($03), y
E12E: 4D 00 85 eor $8500
E131: 60       rts
E132: A4 12    ldy $12
E134: A6 11    ldx $11
E136: A9 0B    lda #$0b
E138: 20 5D EA jsr $ea5d
E13B: 85 F5    sta dummy_write_00f5
E13D: 6E 60 85 ror $8560
E140: F5 EA    sbc $ea, x
E142: A5 C4    lda $c4
E144: F0 2F    beq $e175
E146: 20 F2 E8 jsr $e8f2
E149: A5 13    lda timer1_0013
E14B: 29 3F    and #$3f
E14D: D0 26    bne $e175
E14F: C6 C4    dec $c4
E151: D0 22    bne $e175
E153: A5 63    lda $63
E155: 0A       asl a
E156: AA       tax
E157: BD 76 E1 lda $e176, x
E15A: 85 03    sta $03
E15C: DD 77 E1 cmp $e177, x
E15F: 85 04    sta $04
E161: A9 00    lda #$00
E163: A8       tay
E164: 91 03    sta ($03), y
E166: 64 91    nop $91
E168: 03 A0    slo ($a0, x)
E16A: 20 91 03 jsr $0391
E16D: 64 91    nop $91
E16F: 03 85    slo ($85, x)
E171: 60       rts
E172: 85 F5    sta dummy_write_00f5
E174: 6E 60 4F ror $4f60
E177: 11 CF    ora ($cf), y
E179: 11 CF    ora ($cf), y
E17B: 11 8F    ora ($8f), y
E17D: 10 15    bpl $e194
E17F: 11 8F    ora ($8f), y
E181: 11 BC    ora ($bc), y
E183: C0 B8    cpy #$b8
E185: BC C0 B8 ldy $b8c0, x
E188: 07 06    slo $06
E18A: 05 05    ora $05
E18C: 05 05    ora $05
E18E: 85 F5    sta dummy_write_00f5
E190: EA       nop
E191: A9 00    lda #$00
E193: 8D 00 02 sta $0200
E196: C1 F5    cmp (dummy_write_00f5, x)
E198: EA       nop
E199: AC 00 02 ldy $0200
E19C: B9 02 02 lda $0202, y
E19F: D0 04    bne $e1a5
E1A1: 60       rts
E1A2: 85 F5    sta dummy_write_00f5
E1A4: 6E 29 0F ror $0f29
E1A7: 85 03    sta $03
E1A9: B9 03 02 lda $0203, y
E1AC: 85 04    sta $04
E1AE: 5D 04 02 eor $0204, x
E1B1: 85 05    sta $05
E1B3: B9 02 02 lda $0202, y
E1B6: 29 F0    and #$f0
E1B8: 4A       lsr a
E1B9: 4A       lsr a
E1BA: 4A       lsr a
E1BB: AA       tax
E1BC: BD C9 E1 lda $e1c9, x
E1BF: 85 06    sta $06
E1C1: BD CA E1 lda $e1ca, x
E1C4: 85 07    sta $07
E1C6: AC 06 00 ldy $0006
E1C9: 00       brk
E1CA: E2 18    nop #$18
E1CC: E2 36    nop #$36
E1CE: E2 78    nop #$78
E1D0: E2 B0    nop #$b0
E1D2: E2 E8    nop #$e8
E1D4: E2 00    nop #$00
E1D6: E4 EC    cpx $ec
E1D8: E1 EF    sbc ($ef, x)
E1DA: E1 F2    sbc ($f2, x)
E1DC: E1 20    sbc ($20, x)
E1DE: E3 58    isb ($58, x)
E1E0: E3 90    isb ($90, x)
E1E2: E3 C8    isb ($c8, x)
E1E4: E3 57    isb ($57, x)
E1E6: E4 03    cpx $03
E1E8: E2 85    nop #$85
E1EA: F5 EA    sbc $ea, x
E1EC: 85 F5    sta dummy_write_00f5
E1EE: 6E 85 F5 ror $f585
E1F1: EA       nop
E1F2: 00       brk
E1F3: B9 02 02 lda $0202, y
E1F6: 29 0F    and #$0f
E1F8: 09 10    ora #$10
E1FA: 99 02 02 sta $0202, y
E1FD: C1 F5    cmp (dummy_write_00f5, x)
E1FF: 6E 85 F5 ror $f585
E202: EA       nop
E203: 20 BE E5 jsr $e5be
E206: EE 00 02 inc $0200
E209: EE 00 02 inc $0200
E20C: EE 00 02 inc $0200
E20F: EE 00 02 inc $0200
E212: 4C 99 E1 jmp $e199
E215: 85 F5    sta dummy_write_00f5
E217: EA       nop
E218: 20 16 E5 jsr $e516
E21B: D0 13    bne $e230
E21D: 20 6E E5 jsr $e56e
E220: D0 0E    bne $e230
E222: 20 A2 CC jsr $cca2
E225: 98       tya
E226: AA       tax
E227: FE 04 02 inc $0204, x
E22A: 20 6B EB jsr $eb6b
E22D: 85 F5    sta dummy_write_00f5
E22F: EA       nop
E230: 4C 03 E2 jmp $e203
E233: 85 F5    sta dummy_write_00f5
E235: EA       nop
E236: B9 05 02 lda $0205, y
E239: 29 10    and #$10
E23B: D0 1E    bne $e25b
E23D: 38       sec
E23E: A5 05    lda $05
E240: E9 08    sbc #$08
E242: 85 05    sta $05
E244: 99 04 02 sta $0204, y
E247: 20 A9 E4 jsr $e4a9
E24A: B9 05 02 lda $0205, y
E24D: 09 10    ora #$10
E24F: 99 05 02 sta $0205, y
E252: 85 F5    sta dummy_write_00f5
E254: EA       nop
E255: 4C 03 E2 jmp $e203
E258: 85 F5    sta dummy_write_00f5
E25A: EA       nop
E25B: A5 13    lda timer1_0013
E25D: 29 03    and #$03
E25F: D0 F4    bne $e255
E261: B9 05 02 lda $0205, y
E264: 29 0F    and #$0f
E266: 99 05 02 sta $0205, y
E269: B9 02 02 lda $0202, y
E26C: 29 0F    and #$0f
E26E: 09 30    ora #$30
E270: 99 02 02 sta $0202, y
E273: D0 E0    bne $e255
E275: 85 F5    sta dummy_write_00f5
E277: EA       nop
E278: B9 05 02 lda $0205, y
E27B: 29 10    and #$10
E27D: D0 14    bne $e293
E27F: 20 B2 E4 jsr $e4b2
E282: B9 05 02 lda $0205, y
E285: 09 10    ora #$10
E287: 99 05 02 sta $0205, y
E28A: 85 F5    sta dummy_write_00f5
E28C: EA       nop
E28D: 4C 03 E2 jmp $e203
E290: 85 F5    sta dummy_write_00f5
E292: EA       nop
E293: A5 13    lda timer1_0013
E295: 29 03    and #$03
E297: D0 F4    bne $e28d
E299: B9 05 02 lda $0205, y
E29C: 29 0F    and #$0f
E29E: 99 05 02 sta $0205, y
E2A1: B9 02 02 lda $0202, y
E2A4: 29 0F    and #$0f
E2A6: 09 40    ora #$40
E2A8: 99 02 02 sta $0202, y
E2AB: D0 E0    bne $e28d
E2AD: 85 F5    sta dummy_write_00f5
E2AF: EA       nop
E2B0: B9 05 02 lda $0205, y
E2B3: 29 10    and #$10
E2B5: D0 14    bne $e2cb
E2B7: 20 BB E4 jsr $e4bb
E2BA: B9 05 02 lda $0205, y
E2BD: 09 10    ora #$10
E2BF: 99 05 02 sta $0205, y
E2C2: 85 F5    sta dummy_write_00f5
E2C4: EA       nop
E2C5: 4C 03 E2 jmp $e203
E2C8: 85 F5    sta dummy_write_00f5
E2CA: EA       nop
E2CB: A5 13    lda timer1_0013
E2CD: 29 03    and #$03
E2CF: D0 F4    bne $e2c5
E2D1: B9 05 02 lda $0205, y
E2D4: 29 0F    and #$0f
E2D6: 99 05 02 sta $0205, y
E2D9: B9 02 02 lda $0202, y
E2DC: 09 50    ora #$50
E2DE: 29 5F    and #$5f
E2E0: 99 02 02 sta $0202, y
E2E3: D0 E0    bne $e2c5
E2E5: 85 F5    sta dummy_write_00f5
E2E7: EA       nop
E2E8: B9 05 02 lda $0205, y
E2EB: 29 10    and #$10
E2ED: D0 14    bne $e303
E2EF: 20 C4 E4 jsr $e4c4
E2F2: B9 05 02 lda $0205, y
E2F5: 09 10    ora #$10
E2F7: 99 05 02 sta $0205, y
E2FA: 85 F5    sta dummy_write_00f5
E2FC: EA       nop
E2FD: 4C 03 E2 jmp $e203
E300: 85 F5    sta dummy_write_00f5
E302: EA       nop
E303: A5 13    lda timer1_0013
E305: 29 03    and #$03
E307: D0 F4    bne $e2fd
E309: B9 05 02 lda $0205, y
E30C: 29 0F    and #$0f
E30E: 99 05 02 sta $0205, y
E311: B9 02 02 lda $0202, y
E314: 09 60    ora #$60
E316: 29 6F    and #$6f
E318: 99 02 02 sta $0202, y
E31B: D0 E0    bne $e2fd
E31D: 85 F5    sta dummy_write_00f5
E31F: 6E B9 05 ror $05b9
E322: 02       kil
E323: 29 10    and #$10
E325: D0 14    bne $e33b
E327: 20 A9 E4 jsr $e4a9
E32A: B9 05 02 lda $0205, y
E32D: 09 10    ora #$10
E32F: 99 05 02 sta $0205, y
E332: 85 F5    sta dummy_write_00f5
E334: 6E 4C 03 ror $034c
E337: E2 85    nop #$85
E339: F5 EA    sbc $ea, x
E33B: A5 13    lda timer1_0013
E33D: 29 03    and #$03
E33F: D0 F4    bne $e335
E341: B9 05 02 lda $0205, y
E344: 29 0F    and #$0f
E346: 99 05 02 sta $0205, y
E349: B9 02 02 lda $0202, y
E34C: 29 0F    and #$0f
E34E: 09 B0    ora #$b0
E350: 99 02 02 sta $0202, y
E353: D0 E0    bne $e335
E355: 85 F5    sta dummy_write_00f5
E357: 6E B9 05 ror $05b9
E35A: 02       kil
E35B: 29 10    and #$10
E35D: D0 14    bne $e373
E35F: 20 B2 E4 jsr $e4b2
E362: B9 05 02 lda $0205, y
E365: 09 10    ora #$10
E367: 99 05 02 sta $0205, y
E36A: 85 F5    sta dummy_write_00f5
E36C: 6E 4C 03 ror $034c
E36F: E2 85    nop #$85
E371: F5 EA    sbc $ea, x
E373: A5 13    lda timer1_0013
E375: 29 03    and #$03
E377: D0 F4    bne $e36d
E379: B9 05 02 lda $0205, y
E37C: 29 0F    and #$0f
E37E: 99 05 02 sta $0205, y
E381: B9 02 02 lda $0202, y
E384: 09 C0    ora #$c0
E386: 29 CF    and #$cf
E388: 99 02 02 sta $0202, y
E38B: D0 E0    bne $e36d
E38D: 85 F5    sta dummy_write_00f5
E38F: 6E B9 05 ror $05b9
E392: 02       kil
E393: 29 10    and #$10
E395: D0 14    bne $e3ab
E397: 20 BB E4 jsr $e4bb
E39A: B9 05 02 lda $0205, y
E39D: 09 10    ora #$10
E39F: 99 05 02 sta $0205, y
E3A2: 85 F5    sta dummy_write_00f5
E3A4: 6E 4C 03 ror $034c
E3A7: E2 85    nop #$85
E3A9: F5 EA    sbc $ea, x
E3AB: A5 13    lda timer1_0013
E3AD: 29 03    and #$03
E3AF: D0 F4    bne $e3a5
E3B1: B9 05 02 lda $0205, y
E3B4: 29 0F    and #$0f
E3B6: 99 05 02 sta $0205, y
E3B9: B9 02 02 lda $0202, y
E3BC: 09 D0    ora #$d0
E3BE: 29 DF    and #$df
E3C0: 99 02 02 sta $0202, y
E3C3: D0 E0    bne $e3a5
E3C5: 85 F5    sta dummy_write_00f5
E3C7: 6E B9 05 ror $05b9
E3CA: 02       kil
E3CB: 29 10    and #$10
E3CD: D0 14    bne $e3e3
E3CF: 20 C4 E4 jsr $e4c4
E3D2: B9 05 02 lda $0205, y
E3D5: 09 10    ora #$10
E3D7: 99 05 02 sta $0205, y
E3DA: 85 F5    sta dummy_write_00f5
E3DC: 6E 4C 03 ror $034c
E3DF: E2 85    nop #$85
E3E1: F5 EA    sbc $ea, x
E3E3: A5 13    lda timer1_0013
E3E5: 29 03    and #$03
E3E7: D0 F4    bne $e3dd
E3E9: B9 05 02 lda $0205, y
E3EC: 29 0F    and #$0f
E3EE: 99 05 02 sta $0205, y
E3F1: B9 02 02 lda $0202, y
E3F4: 09 E0    ora #$e0
E3F6: 29 EF    and #$ef
E3F8: 99 02 02 sta $0202, y
E3FB: D0 E0    bne $e3dd
E3FD: 85 F5    sta dummy_write_00f5
E3FF: 6E 20 A2 ror $a220
E402: CC 98 AA cpy $aa98
E405: FE 04 02 inc $0204, x
E408: BD 04 02 lda $0204, x
E40B: 29 07    and #$07
E40D: D0 42    bne $e451
E40F: B9 02 02 lda $0202, y
E412: 29 0F    and #$0f
E414: 09 10    ora #$10
E416: 99 02 02 sta $0202, y
E419: B9 05 02 lda $0205, y
E41C: 29 0F    and #$0f
E41E: 99 05 02 sta $0205, y
E421: B9 06 02 lda $0206, y
E424: 29 0F    and #$0f
E426: C9 0F    cmp #$0f
E428: F0 0C    beq $e436
E42A: B9 06 02 lda $0206, y
E42D: 29 F0    and #$f0
E42F: C9 F0    cmp #$f0
E431: D0 1E    bne $e451
E433: 85 F5    sta dummy_write_00f5
E435: EA       nop
E436: A9 00    lda #$00
E438: 99 05 02 sta $0205, y
E43B: B9 02 02 lda $0202, y
E43E: 09 F0    ora #$f0
E440: 99 02 02 sta $0202, y
E443: A9 00    lda #$00
E445: 20 8C E9 jsr $e98c
E448: 20 FA E5 jsr $e5fa
E44B: 20 C8 E7 jsr $e7c8
E44E: 85 F5    sta dummy_write_00f5
E450: EA       nop
E451: 4C 03 E2 jmp $e203
E454: 85 F5    sta dummy_write_00f5
E456: EA       nop
E457: 20 A2 CC jsr $cca2
E45A: 98       tya
E45B: AA       tax
E45C: BD 05 02 lda $0205, x
E45F: 29 0F    and #$0f
E461: 9D 05 02 sta $0205, x
E464: F0 08    beq $e46e
E466: DE 05 02 dec $0205, x
E469: D0 19    bne $e484
E46B: 85 F5    sta dummy_write_00f5
E46D: EA       nop
E46E: B9 02 02 lda $0202, y
E471: 29 0F    and #$0f
E473: 99 02 02 sta $0202, y
E476: A9 00    lda #$00
E478: 20 8C E9 jsr $e98c
E47B: 20 FA E5 jsr $e5fa
E47E: 4C 03 E2 jmp $e203
E481: 85 F5    sta dummy_write_00f5
E483: EA       nop
E484: B9 02 02 lda $0202, y
E487: 29 0F    and #$0f
E489: 09 10    ora #$10
E48B: 99 02 02 sta $0202, y
E48E: B9 04 02 lda $0204, y
E491: 69 02    adc #$02
E493: 99 04 02 sta $0204, y
E496: 4C 03 E2 jmp $e203
E499: 00       brk
E49A: 01 01    ora ($01, x)
E49C: 05 02    ora $02
E49E: 04 03    nop $03
E4A0: 00       brk
E4A1: 01 01    ora ($01, x)
E4A3: 05 02    ora $02
E4A5: 04 03    nop $03
E4A7: 85 F5    sta dummy_write_00f5
E4A9: EA       nop
E4AA: A9 00    lda #$00
E4AC: 85 11    sta $11
E4AE: F0 1C    beq $e4cc
E4B0: 85 F5    sta dummy_write_00f5
E4B2: EA       nop
E4B3: A9 01    lda #$01
E4B5: 85 11    sta $11
E4B7: F0 13    beq $e4cc
E4B9: 85 F5    sta dummy_write_00f5
E4BB: EA       nop
E4BC: A9 02    lda #$02
E4BE: 85 11    sta $11
E4C0: F0 0A    beq $e4cc
E4C2: 85 F5    sta dummy_write_00f5
E4C4: EA       nop
E4C5: A9 03    lda #$03
E4C7: 85 11    sta $11
E4C9: 85 F5    sta dummy_write_00f5
E4CB: EA       nop
E4CC: 98       tya
E4CD: 48       pha
E4CE: A6 11    ldx $11
E4D0: A5 05    lda $05
E4D2: 18       clc
E4D3: 7D 0C E5 adc $e50c, x
E4D6: 85 05    sta $05
E4D8: 20 99 CC jsr $cc99
E4DB: A0 01    ldy #$01
E4DD: A6 11    ldx $11
E4DF: A5 06    lda $06
E4E1: 29 FB    and #$fb
E4E3: 85 06    sta $06
E4E5: B1 05    lda ($05), y
E4E7: 18       clc
E4E8: 7D 10 E5 adc $e510, x
E4EB: 91 05    sta ($05), y
E4ED: C8       iny
E4EE: B1 05    lda ($05), y
E4F0: 18       clc
E4F1: 7D 10 E5 adc $e510, x
E4F4: 91 05    sta ($05), y
E4F6: A0 21    ldy #$21
E4F8: B1 05    lda ($05), y
E4FA: 18       clc
E4FB: 7D 10 E5 adc $e510, x
E4FE: 91 05    sta ($05), y
E500: C8       iny
E501: B1 05    lda ($05), y
E503: 18       clc
E504: 7D 10 E5 adc $e510, x
E507: 91 05    sta ($05), y
E509: 68       pla
E50A: A8       tay
E50B: 60       rts
E50C: 04 03    nop $03
E50E: 02       kil
E50F: 01 04    ora ($04, x)
E511: FC 04 FC nop $fc04, x
E514: 85 F5    sta dummy_write_00f5
E516: 6E A5 05 ror $05a5
E519: 29 07    and #$07
E51B: D0 4C    bne $e569
E51D: B9 07 02 lda $0207, y
E520: C5 04    cmp $04
E522: D0 45    bne $e569
E524: B9 08 02 lda $0208, y
E527: 38       sec
E528: E5 05    sbc $05
E52A: C9 09    cmp #$09
E52C: B0 3B    bcs $e569
E52E: B9 02 02 lda $0202, y
E531: 29 0F    and #$0f
E533: 09 20    ora #$20
E535: 99 02 02 sta $0202, y
E538: B9 06 02 lda $0206, y
E53B: 29 F0    and #$f0
E53D: C9 F0    cmp #$f0
E53F: F0 1D    beq $e55e
E541: B9 06 02 lda $0206, y
E544: 29 0F    and #$0f
E546: C9 0F    cmp #$0f
E548: F0 14    beq $e55e
E54A: B9 06 02 lda $0206, y
E54D: 09 10    ora #$10
E54F: 99 06 02 sta $0206, y
E552: B9 08 02 lda $0208, y
E555: 18       clc
E556: 69 04    adc #$04
E558: 99 08 02 sta $0208, y
E55B: 85 F5    sta dummy_write_00f5
E55D: 6E A9 0A ror $0aa9
E560: 20 5D EA jsr $ea5d
E563: A9 FF    lda #$ff
E565: 60       rts
E566: 85 F5    sta dummy_write_00f5
E568: EA       nop
E569: A9 00    lda #$00
E56B: 60       rts
E56C: 85 F5    sta dummy_write_00f5
E56E: 6E A5 05 ror $05a5
E571: 29 0F    and #$0f
E573: C9 08    cmp #$08
E575: D0 2D    bne $e5a4
E577: A5 04    lda $04
E579: 4A       lsr a
E57A: 4A       lsr a
E57B: 4A       lsr a
E57C: 4A       lsr a
E57D: 85 12    sta $12
E57F: 4D 10 38 eor $3810
E582: E5 12    sbc $12
E584: 85 12    sta $12
E586: C9 05    cmp #$05
E588: 29 F0    and #$f0
E58A: 18       clc
E58B: 65 12    adc $12
E58D: AA       tax
E58E: BD 8E D6 lda $d68e, x
E591: AA       tax
E592: BD 00 04 lda $0400, x
E595: 4A       lsr a
E596: 4A       lsr a
E597: 4A       lsr a
E598: 4A       lsr a
E599: C9 09    cmp #$09
E59B: F0 0D    beq $e5aa
E59D: C9 08    cmp #$08
E59F: F0 09    beq $e5aa
E5A1: 85 F5    sta dummy_write_00f5
E5A3: EA       nop
E5A4: A9 00    lda #$00
E5A6: 60       rts
E5A7: 85 F5    sta dummy_write_00f5
E5A9: EA       nop
E5AA: B9 02 02 lda $0202, y
E5AD: 29 0F    and #$0f
E5AF: 09 A0    ora #$a0
E5B1: 99 02 02 sta $0202, y
E5B4: 4D 0A 20 eor $200a
E5B7: 5D EA A9 eor $a9ea, x
E5BA: FF 60 85 isb $8560, x
E5BD: F5 6E    sbc $6e, x
E5BF: A2 00    ldx #$00
E5C1: 85 F5    sta dummy_write_00f5
E5C3: EA       nop
E5C4: B5 68    lda $68, x
E5C6: 29 E0    and #$e0
E5C8: C9 40    cmp #$40
E5CA: F0 0C    beq $e5d8
E5CC: 85 F5    sta dummy_write_00f5
E5CE: 6E E8 E0 ror $e0e8
E5D1: 06 D0    asl $d0
E5D3: F0 60    beq $e635
E5D5: 85 F5    sta dummy_write_00f5
E5D7: 6E B5 B1 ror $b1b5
E5DA: 85 0D    sta $0d
E5DC: E0 0D    cpx #$0d
E5DE: D0 EF    bne $e5cf
E5E0: 84 0E    sty $0e
E5E2: 38       sec
E5E3: B9 04 02 lda $0204, y
E5E6: E9 0C    sbc #$0c
E5E8: 85 0F    sta $0f
E5EA: 8A       txa
E5EB: 0A       asl a
E5EC: 0A       asl a
E5ED: A8       tay
E5EE: A5 0F    lda $0f
E5F0: 99 03 18 sta $1803, y
E5F3: A4 0E    ldy $0e
E5F5: 4C CF E5 jmp $e5cf
E5F8: 85 F5    sta dummy_write_00f5
E5FA: EA       nop
E5FB: A2 00    ldx #$00
E5FD: 86 C9    stx $c9
E5FF: C1 F5    cmp (dummy_write_00f5, x)
E601: EA       nop
E602: B5 68    lda $68, x
E604: 30 07    bmi $e60d
E606: 29 40    and #$40
E608: D0 2F    bne $e639
E60A: 85 F5    sta dummy_write_00f5
E60C: EA       nop
E60D: E8       inx
E60E: E0 06    cpx #$06
E610: D0 F0    bne $e602
E612: A6 C9    ldx $c9
E614: F0 1F    beq $e635
E616: BD 63 E6 lda $e663, x
E619: 20 8C E9 jsr $e98c
E61C: 98       tya
E61D: 48       pha
E61E: A6 CA    ldx $ca
E620: BC 4F EB ldy $eb4f, x
E623: A6 C9    ldx $c9
E625: BD 69 E6 lda $e669, x
E628: 99 01 18 sta $1801, y
E62B: A9 01    lda #$01
E62D: 99 00 18 sta $1800, y
E630: 68       pla
E631: A8       tay
E632: 85 F5    sta dummy_write_00f5
E634: EA       nop
E635: 60       rts
E636: 85 F5    sta dummy_write_00f5
E638: EA       nop
E639: B5 B1    lda $b1, x
E63B: 85 0D    sta $0d
E63D: C4 0D    cpy $0d
E63F: D0 CC    bne $e60d
E641: E6 C9    inc $c9
E643: 86 CA    stx $ca
E645: B5 68    lda $68, x
E647: 29 0F    and #$0f
E649: 09 20    ora #$20
E64B: 95 68    sta $68, x
E64D: 84 0E    sty $0e
E64F: 29 03    and #$03
E651: A8       tay
E652: B9 4C E7 lda $e74c, y
E655: BC 4F EB ldy $eb4f, x
E658: 99 01 18 sta $1801, y
E65B: A4 0E    ldy $0e
E65D: A9 7F    lda #$7f
E65F: 95 99    sta $99, x
E661: 4C 0D E6 jmp $e60d
E664: 04 05    nop $05
E666: 07 08    slo $08
E668: 09 0A    ora #$0a
E66A: 37 38    rla $38, x
E66C: 39 3A 3B and $3b3a, y
E66F: 3C 85 F5 nop $f585, x
E672: EA       nop
E673: AD 1A 18 lda $181a
E676: 85 03    sta $03
E678: AD 1B 18 lda $181b
E67B: 85 04    sta $04
E67D: A2 00    ldx #$00
E67F: 85 F5    sta dummy_write_00f5
E681: EA       nop
E682: B5 68    lda $68, x
E684: 10 0C    bpl $e692
E686: 85 F5    sta dummy_write_00f5
E688: EA       nop
E689: E8       inx
E68A: E0 06    cpx #$06
E68C: D0 F4    bne $e682
E68E: 60       rts
E68F: 85 F5    sta dummy_write_00f5
E691: EA       nop
E692: 8A       txa
E693: 0A       asl a
E694: 0A       asl a
E695: A8       tay
E696: B9 02 18 lda $1802, y
E699: 18       clc
E69A: 69 0C    adc #$0c
E69C: C5 03    cmp $03
E69E: 90 E9    bcc $e689
E6A0: E9 18    sbc #$18
E6A2: C5 03    cmp $03
E6A4: B0 E3    bcs $e689
E6A6: B9 03 18 lda $1803, y
E6A9: 18       clc
E6AA: 69 0C    adc #$0c
E6AC: C5 04    cmp $04
E6AE: 90 D9    bcc $e689
E6B0: E9 18    sbc #$18
E6B2: C5 04    cmp $04
E6B4: B0 D3    bcs $e689
E6B6: B5 68    lda $68, x
E6B8: 09 10    ora #$10
E6BA: 95 68    sta $68, x
E6BC: A4 1F    ldy current_player_001f
E6BE: B9 61 00 lda $0061, y
E6C1: C9 08    cmp #$08
E6C3: 90 02    bcc $e6c7
E6C5: A9 08    lda #$08
E6C7: A8       tay
E6C8: B9 D4 E6 lda $e6d4, y
E6CB: 95 99    sta $99, x
E6CD: A9 0F    lda #$0f
E6CF: 20 5D EA jsr $ea5d
E6D2: 4C 89 E6 jmp $e689
E6D5: D1 C1    cmp ($c1), y
E6D7: B1 A1    lda ($a1), y
E6D9: 91 81    sta ($81), y
E6DB: 71 61    adc ($61), y
E6DD: 85 F5    sta dummy_write_00f5
E6DF: EA       nop
E6E0: A2 00    ldx #$00
E6E2: 85 F5    sta dummy_write_00f5
E6E4: EA       nop
E6E5: B5 68    lda $68, x
E6E7: 30 07    bmi $e6f0
E6E9: 29 10    and #$10
E6EB: D0 0C    bne $e6f9
E6ED: 85 F5    sta dummy_write_00f5
E6EF: EA       nop
E6F0: E8       inx
E6F1: E0 06    cpx #$06
E6F3: D0 F0    bne $e6e5
E6F5: 60       rts
E6F6: 85 F5    sta dummy_write_00f5
E6F8: EA       nop
E6F9: B5 99    lda $99, x
E6FB: C9 01    cmp #$01
E6FD: F0 39    beq $e738
E6FF: D6 99    dec $99, x
E701: B5 99    lda $99, x
E703: 29 0F    and #$0f
E705: D0 E9    bne $e6f0
E707: B5 99    lda $99, x
E709: 29 10    and #$10
E70B: F0 0F    beq $e71c
E70D: B5 68    lda $68, x
E70F: 29 03    and #$03
E711: A8       tay
E712: B9 4C E7 lda $e74c, y
E715: 85 03    sta $03
E717: 70 10    bvs $e729
E719: 85 F5    sta dummy_write_00f5
E71B: EA       nop
E71C: B5 68    lda $68, x
E71E: 29 03    and #$03
E720: A8       tay
E721: B9 53 E7 lda $e753, y
E724: 85 03    sta $03
E726: C1 F5    cmp (dummy_write_00f5, x)
E728: EA       nop
E729: 8A       txa
E72A: 0A       asl a
E72B: 0A       asl a
E72C: A8       tay
E72D: A5 03    lda $03
E72F: 99 01 18 sta $1801, y
E732: 4C F0 E6 jmp $e6f0
E735: 85 F5    sta dummy_write_00f5
E737: 6E B5 68 ror $68b5
E73A: 29 EF    and #$ef
E73C: 95 68    sta $68, x
E73E: 0D 03 A8 ora $a803
E741: B9 5A E7 lda $e75a, y
E744: 85 03    sta $03
E746: A4 29    ldy player_lives_0029
E748: E7 85    isb $85
E74A: F5 EA    sbc $ea, x
E74C: 00       brk
E74D: 62       kil
E74E: 6E 7A 85 ror $857a
E751: F5 EA    sbc $ea, x
E753: 00       brk
E754: 63 6F    rra ($6f, x)
E756: 7B 85 F5 rra $f585, y
E759: EA       nop
E75A: 00       brk
E75B: 5A       nop
E75C: 66 72    ror $72
E75E: 85 F5    sta dummy_write_00f5
E760: EA       nop
E761: A5 6F    lda game_state_006f
E763: 30 1E    bmi $e783
E765: AD 1E 18 lda $181e
E768: 85 03    sta $03
E76A: AD 1F 18 lda $181f
E76D: 85 04    sta $04
E76F: 4A       lsr a
E770: 00       brk
E771: 85 F5    sta dummy_write_00f5
E773: EA       nop
E774: B5 68    lda $68, x
E776: 10 0F    bpl $e787
E778: 85 F5    sta dummy_write_00f5
E77A: EA       nop
E77B: E8       inx
E77C: E0 06    cpx #$06
E77E: D0 F4    bne $e774
E780: 85 F5    sta dummy_write_00f5
E782: EA       nop
E783: 60       rts
E784: 85 F5    sta dummy_write_00f5
E786: 6E 29 70 ror $7029
E789: D0 F0    bne $e77b
E78B: 8A       txa
E78C: 0A       asl a
E78D: 0A       asl a
E78E: A8       tay
E78F: B9 02 18 lda $1802, y
E792: 18       clc
E793: 69 08    adc #$08
E795: C5 03    cmp $03
E797: 90 E2    bcc $e77b
E799: E9 10    sbc #$10
E79B: C5 03    cmp $03
E79D: B0 DC    bcs $e77b
E79F: B9 03 18 lda $1803, y
E7A2: 18       clc
E7A3: 69 04    adc #$04
E7A5: C5 04    cmp $04
E7A7: 90 D2    bcc $e77b
E7A9: E9 0D    sbc #$0d
E7AB: C5 04    cmp $04
E7AD: B0 CC    bcs $e77b
E7AF: A9 10    lda #$10
E7B1: 20 5D EA jsr $ea5d
E7B4: A5 6F    lda game_state_006f
E7B6: 09 F0    ora #$f0
E7B8: 85 6F    sta game_state_006f
E7BA: A9 FF    lda #$ff
E7BC: 85 A0    sta $a0
E7BE: 4D 00 20 eor $2000
E7C1: 5D EA 4C eor $4cea, x
E7C4: 7B E7 85 rra $85e7, y
E7C7: F5 EA    sbc $ea, x
E7C9: A6 1F    ldx current_player_001f
E7CB: F6 65    inc $65, x
E7CD: C8       iny
E7CE: 63 B5    rra ($b5, x)
E7D0: 65 85    adc $85
E7D2: 05 D9    ora $d9
E7D4: 15 E8    ora $e8, x
E7D6: D0 03    bne $e7db
E7D8: 20 FB E0 jsr $e0fb
E7DB: A5 05    lda $05
E7DD: D9 1B E8 cmp $e81b, y
E7E0: D0 03    bne $e7e5
E7E2: 20 FB E0 jsr $e0fb
E7E5: A5 05    lda $05
E7E7: D9 21 E8 cmp $e821, y
E7EA: D0 03    bne $e7ef
E7EC: 20 FB E0 jsr $e0fb
E7EF: A5 05    lda $05
E7F1: D9 27 E8 cmp $e827, y
E7F4: D0 03    bne $e7f9
E7F6: 20 FB E0 jsr $e0fb
E7F9: A5 05    lda $05
E7FB: D9 2D E8 cmp $e82d, y
E7FE: 90 14    bcc $e814
E800: A5 6F    lda game_state_006f
E802: 29 0F    and #$0f
E804: 09 80    ora #$80
E806: 85 6F    sta game_state_006f
E808: A9 FF    lda #$ff
E80A: 85 A0    sta $a0
E80C: A9 05    lda #$05
E80E: 20 5D EA jsr $ea5d
E811: 85 F5    sta dummy_write_00f5
E813: EA       nop
E814: 60       rts
E815: 04 05    nop $05
E817: 04 06    nop $06
E819: 03 03    slo ($03, x)
E81B: 08       php
E81C: 07 08    slo $08
E81E: 10 06    bpl $e826
E820: 07 0C    slo $0c
E822: 0D 0E 16 ora $160e
E825: 09 0C    ora #$0c
E827: FF FF 0E isb $0eff, x
E82A: 1C FF 0E nop $0eff, x
E82D: 10 10    bpl $e83f
E82F: 12       kil
E830: 20 10 12 jsr $1210
E833: 85 F5    sta dummy_write_00f5
E835: EA       nop
E836: A5 6F    lda game_state_006f
E838: 29 F0    and #$f0
E83A: C9 80    cmp #$80
E83C: D0 2B    bne $e869
E83E: A5 A0    lda $a0
E840: F0 22    beq $e864
E842: C6 A0    dec $a0
E844: A5 A0    lda $a0
E846: 29 0F    and #$0f
E848: D0 1F    bne $e869
E84A: A5 A0    lda $a0
E84C: 29 10    and #$10
E84E: F0 07    beq $e857
E850: A9 47    lda #$47
E852: D0 08    bne $e85c
E854: 85 F5    sta dummy_write_00f5
E856: EA       nop
E857: A9 4C    lda #$4c
E859: 85 F5    sta dummy_write_00f5
E85B: EA       nop
E85C: 8D 1D 18 sta $181d
E85F: D0 08    bne $e869
E861: 85 F5    sta dummy_write_00f5
E863: EA       nop
E864: E6 C5    inc $c5
E866: 85 F5    sta dummy_write_00f5
E868: EA       nop
E869: 60       rts
E86A: 85 F5    sta dummy_write_00f5
E86C: EA       nop
E86D: A5 C6    lda $c6
E86F: 30 46    bmi $e8b7
E871: A5 6F    lda game_state_006f
E873: 29 F0    and #$f0
E875: C9 F0    cmp #$f0
E877: F0 04    beq $e87d
E879: 60       rts
E87A: 85 F5    sta dummy_write_00f5
E87C: EA       nop
E87D: A2 1B    ldx #$1b
E87F: A5 A0    lda $a0
E881: 85 F5    sta dummy_write_00f5
E883: EA       nop
E884: DD B8 E8 cmp $e8b8, x
E887: F0 09    beq $e892
E889: CA       dex
E88A: 10 F8    bpl $e884
E88C: C6 A0    dec $a0
E88E: 60       rts
E88F: 85 F5    sta dummy_write_00f5
E891: EA       nop
E892: BD D4 E8 lda $e8d4, x
E895: 8D 1D 18 sta $181d
E898: C6 A0    dec $a0
E89A: 8A       txa
E89B: D0 0E    bne $e8ab
E89D: A6 1F    ldx current_player_001f
E89F: D6 29    dec player_lives_0029, x
E8A1: A9 FF    lda #$ff
E8A3: 85 C6    sta $c6
E8A5: 4C B7 E8 jmp $e8b7
E8A8: 85 F5    sta dummy_write_00f5
E8AA: EA       nop
E8AB: E0 18    cpx #$18
E8AD: D0 08    bne $e8b7
E8AF: A9 10    lda #$10
E8B1: 20 5D EA jsr $ea5d
E8B4: 85 F5    sta dummy_write_00f5
E8B6: EA       nop
E8B7: 60       rts
E8B8: 01 08    ora ($08, x)
E8BA: 10 18    bpl $e8d4
E8BC: 20 28 30 jsr $3028
E8BF: 38       sec
E8C0: 40       rti
E8C1: 48       pha
E8C2: 50 58    bvc $e91c
E8C4: 60       rts
E8C5: 68       pla
E8C6: 78       sei
E8C7: 80 88    nop #$88
E8C9: 90 98    bcc $e863
E8CB: A0 A8    ldy #$a8
E8CD: B0 B8    bcs $e887
E8CF: C0 C8    cpy #$c8
E8D1: D0 F8    bne $e8cb
E8D3: FE 52 51 inc $5152, x
E8D6: 52       kil
E8D7: 51 52    eor ($52), y
E8D9: 51 52    eor ($52), y
E8DB: 51 52    eor ($52), y
E8DD: 51 52    eor ($52), y
E8DF: 51 52    eor ($52), y
E8E1: 51 52    eor ($52), y
E8E3: 51 52    eor ($52), y
E8E5: 51 52    eor ($52), y
E8E7: 51 52    eor ($52), y
E8E9: 51 52    eor ($52), y
E8EB: 51 50    eor ($50), y
E8ED: 4F 4E 4D sre $4d4e
E8F0: 85 F5    sta dummy_write_00f5
E8F2: EA       nop
E8F3: A5 60    lda $60
E8F5: D0 7A    bne $e971
E8F7: A6 63    ldx $63
E8F9: BD 72 E9 lda $e972, x
E8FC: 85 03    sta $03
E8FE: BD 78 E9 lda $e978, x
E901: 85 04    sta $04
E903: AD 1E 18 lda $181e
E906: 18       clc
E907: 69 08    adc #$08
E909: C5 03    cmp $03
E90B: 90 64    bcc $e971
E90D: E9 10    sbc #$10
E90F: C5 03    cmp $03
E911: B0 5E    bcs $e971
E913: AD 1F 18 lda $181f
E916: 18       clc
E917: 69 08    adc #$08
E919: C5 04    cmp $04
E91B: 90 54    bcc $e971
E91D: E9 10    sbc #$10
E91F: C5 04    cmp $04
E921: B0 4E    bcs $e971
E923: 8A       txa
E924: 0A       asl a
E925: A8       tay
E926: B9 76 E1 lda $e176, y
E929: 85 03    sta $03
E92B: B9 77 E1 lda $e177, y
E92E: 85 04    sta $04
E930: BC 81 E9 ldy $e981, x
E933: B9 7E E9 lda $e97e, y
E936: 85 05    sta $05
E938: A0 00    ldy #$00
E93A: 91 03    sta ($03), y
E93C: 64 E6    nop $e6
E93E: 05 C9    ora $c9
E940: 05 91    ora $91
E942: 03 A9    slo ($a9, x)
E944: 00       brk
E945: A0 20    ldy #$20
E947: 91 03    sta ($03), y
E949: C8       iny
E94A: 91 03    sta ($03), y
E94C: 4D 02 85 eor $8502
E94F: C4 E6    cpy $e6
E951: 60       rts
E952: BC 81 E9 ldy $e981, x
E955: B9 87 E9 lda $e987, y
E958: 20 8C E9 jsr $e98c
E95B: A6 1F    ldx current_player_001f
E95D: B5 2B    lda player_pepper_002b, x
E95F: 18       clc
E960: F8       sed
E961: 69 01    adc #$01
E963: 95 2B    sta player_pepper_002b, x
E965: 74 20    nop $20, x
E967: 94 CA    sty $ca, x
E969: A9 11    lda #$11
E96B: 20 5D EA jsr $ea5d
E96E: 85 F5    sta dummy_write_00f5
E970: EA       nop
E971: 60       rts
E972: 78       sei
E973: 78       sei
E974: 78       sei
E975: 78       sei
E976: 48       pha
E977: 78       sei
E978: 50 70    bvc $e9ea
E97A: 70 20    bvs $e99c
E97C: 40       rti
E97D: 60       rts
E97E: AC B0 B4 ldy $b4b0
E981: 00       brk
E982: 01 02    ora ($02, x)
E984: 00       brk
E985: 01 02    ora ($02, x)
E987: 04 05    nop $05
E989: 06 85    asl $85
E98B: F5 6E    sbc $6e, x
E98D: 85 04    sta $04
E98F: 46 48    lsr $48
E991: 98       tya
E992: 48       pha
E993: A5 1B    lda $1b
E995: D0 06    bne $e99d
E997: 4C 33 EA jmp $ea33
E99A: 85 F5    sta dummy_write_00f5
E99C: 6E A6 1F ror $1fa6
E99F: BC 59 EA ldy $ea59, x
E9A2: A6 04    ldx $04
E9A4: 18       clc
E9A5: F8       sed
E9A6: B9 2D 00 lda $002d, y
E9A9: 7D 38 EA adc $ea38, x
E9AC: 99 2D 00 sta $002d, y
E9AF: 5D 2E 00 eor $002e, x
E9B2: 7D 43 EA adc $ea43, x
E9B5: 99 2E 00 sta $002e, y
E9B8: B9 2F 00 lda $002f, y
E9BB: 7D 4E EA adc $ea4e, x
E9BE: 99 2F 00 sta $002f, y
E9C1: D8       cld
E9C2: A6 1F    ldx current_player_001f
E9C4: 20 4E C9 jsr $c94e
E9C7: A6 1F    ldx current_player_001f
E9C9: BC 59 EA ldy $ea59, x
E9CC: A5 35    lda $35
E9CE: D9 2F 00 cmp $002f, y
E9D1: 90 15    bcc $e9e8
E9D3: D0 2A    bne $e9ff
E9D5: A5 34    lda $34
E9D7: D9 2E 00 cmp $002e, y
E9DA: 90 0C    bcc $e9e8
E9DC: D0 21    bne $e9ff
E9DE: A5 33    lda $33
E9E0: D9 2D 00 cmp $002d, y
E9E3: B0 1A    bcs $e9ff
E9E5: 85 F5    sta dummy_write_00f5
E9E7: 6E B9 2D ror $2db9
E9EA: 00       brk
E9EB: 85 33    sta $33
E9ED: 5D 2E 00 eor $002e, x
E9F0: 85 34    sta $34
E9F2: B9 2F 00 lda $002f, y
E9F5: 85 35    sta $35
E9F7: 4A       lsr a
E9F8: 02       kil
E9F9: 20 4E C9 jsr $c94e
E9FC: 85 F5    sta dummy_write_00f5
E9FE: 6E A6 1F ror $1fa6
EA01: BC 59 EA ldy $ea59, x
EA04: 8A       txa
EA05: 0A       asl a
EA06: AA       tax
EA07: B9 2F 00 lda $002f, y
EA0A: D5 5D    cmp $5d, x
EA0C: 90 25    bcc $ea33
EA0E: B9 2E 00 lda $002e, y
EA11: D5 5C    cmp $5c, x
EA13: 90 1E    bcc $ea33
EA15: 18       clc
EA16: F8       sed
EA17: B5 5C    lda $5c, x
EA19: 65 5A    adc $5a
EA1B: 95 5C    sta $5c, x
EA1D: B5 5D    lda $5d, x
EA1F: 65 5B    adc $5b
EA21: 95 5D    sta $5d, x
EA23: D8       cld
EA24: A6 1F    ldx current_player_001f
EA26: F6 29    inc player_lives_0029, x
EA28: 20 54 CA jsr $ca54
EA2B: A9 02    lda #$02
EA2D: 20 5D EA jsr $ea5d
EA30: 85 F5    sta dummy_write_00f5
EA32: EA       nop
EA33: 68       pla
EA34: A8       tay
EA35: 68       pla
EA36: AA       tax
EA37: 60       rts
EA38: 50 00    bvc $ea3a
EA3A: 00       brk
EA3B: 00       brk
EA3C: 00       brk
EA3D: 00       brk
EA3E: 00       brk
EA3F: 00       brk
EA40: 00       brk
EA41: 00       brk
EA42: 00       brk
EA43: 00       brk
EA44: 01 02    ora ($02, x)
EA46: 03 05    slo ($05, x)
EA48: 10 15    bpl $ea5f
EA4A: 20 40 80 jsr $8040
EA4D: 60       rts
EA4E: 00       brk
EA4F: 00       brk
EA50: 00       brk
EA51: 00       brk
EA52: 00       brk
EA53: 00       brk
EA54: 00       brk
EA55: 00       brk
EA56: 00       brk
EA57: 00       brk
EA58: 01 00    ora ($00, x)
EA5A: 03 85    slo ($85, x)
EA5C: F5 EA    sbc $ea, x
EA5E: 86 C7    stx $c7
EA60: A6 1B    ldx $1b
EA62: F0 0A    beq $ea6e
EA64: AA       tax
EA65: BD 71 EA lda $ea71, x
EA68: 8D 03 40 sta $4003
EA6B: 85 F5    sta dummy_write_00f5
EA6D: EA       nop
EA6E: A6 C7    ldx $c7
EA70: 60       rts
EA71: 00       brk
EA72: 1B 1C 04 slo $041c, y
EA75: 01 02    ora ($02, x)
EA77: 20 21 11 jsr $1121
EA7A: 12       kil
EA7B: 13 14    slo ($14), y
EA7D: 15 16    ora $16, x
EA7F: 17 18    slo $18, x
EA81: 19 1A 1D ora $1d1a, y
EA84: 13 14    slo ($14), y
EA86: 15 16    ora $16, x
EA88: 17 05    slo $05, x
EA8A: 03 85    slo ($85, x)
EA8C: F5 EA    sbc $ea, x
EA8E: A2 05    ldx #$05
EA90: 85 F5    sta dummy_write_00f5
EA92: EA       nop
EA93: B5 68    lda $68, x
EA95: 29 F0    and #$f0
EA97: C9 80    cmp #$80
EA99: F0 0D    beq $eaa8
EA9B: 85 F5    sta dummy_write_00f5
EA9D: EA       nop
EA9E: CA       dex
EA9F: 10 F2    bpl $ea93
EAA1: 85 F5    sta dummy_write_00f5
EAA3: EA       nop
EAA4: 60       rts
EAA5: 85 F5    sta dummy_write_00f5
EAA7: EA       nop
EAA8: B5 99    lda $99, x
EAAA: C9 01    cmp #$01
EAAC: F0 48    beq $eaf6
EAAE: D6 99    dec $99, x
EAB0: B5 99    lda $99, x
EAB2: C9 40    cmp #$40
EAB4: F0 43    beq $eaf9
EAB6: C9 38    cmp #$38
EAB8: F0 53    beq $eb0d
EABA: C9 30    cmp #$30
EABC: F0 63    beq $eb21
EABE: C9 28    cmp #$28
EAC0: F0 23    beq $eae5
EAC2: C9 20    cmp #$20
EAC4: D0 D8    bne $ea9e
EAC6: B5 68    lda $68, x
EAC8: 29 03    and #$03
EACA: A8       tay
EACB: B9 65 EB lda $eb65, y
EACE: 20 8C E9 jsr $e98c
EAD1: B9 62 EB lda $eb62, y
EAD4: BC 4F EB ldy $eb4f, x
EAD7: 99 01 18 sta $1801, y
EADA: A9 01    lda #$01
EADC: 99 00 18 sta $1800, y
EADF: 4C 9E EA jmp $ea9e
EAE2: 85 F5    sta dummy_write_00f5
EAE4: EA       nop
EAE5: B5 68    lda $68, x
EAE7: 29 03    and #$03
EAE9: A8       tay
EAEA: B9 5F EB lda $eb5f, y
EAED: BC 4F EB ldy $eb4f, x
EAF0: 99 01 18 sta $1801, y
EAF3: 4C 9E EA jmp $ea9e
EAF6: 4C 35 EB jmp $eb35
EAF9: B5 68    lda $68, x
EAFB: 29 03    and #$03
EAFD: A8       tay
EAFE: B9 56 EB lda $eb56, y
EB01: BC 4F EB ldy $eb4f, x
EB04: 99 01 18 sta $1801, y
EB07: A4 9E    ldy $9e
EB09: EA       nop
EB0A: 85 F5    sta dummy_write_00f5
EB0C: 6E B5 68 ror $68b5
EB0F: 29 03    and #$03
EB11: A8       tay
EB12: B9 59 EB lda $eb59, y
EB15: BC 4F EB ldy $eb4f, x
EB18: 99 01 18 sta $1801, y
EB1B: 4C 9E EA jmp $ea9e
EB1E: 85 F5    sta dummy_write_00f5
EB20: EA       nop
EB21: B5 68    lda $68, x
EB23: 29 03    and #$03
EB25: A8       tay
EB26: B9 5C EB lda $eb5c, y
EB29: BC 4F EB ldy $eb4f, x
EB2C: 99 01 18 sta $1801, y
EB2F: A4 9E    ldy $9e
EB31: EA       nop
EB32: 85 F5    sta dummy_write_00f5
EB34: 6E 86 03 ror $0386
EB37: D9 68 29 cmp $2968, y
EB3A: 03 AA    slo ($aa, x)
EB3C: D6 BE    dec $be, x
EB3E: CA       dex
EB3F: 03 A9    slo ($a9, x)
EB41: FF 95 68 isb $6895, x
EB44: DC 4F EB nop $eb4f, x
EB47: A9 00    lda #$00
EB49: 99 00 18 sta $1800, y
EB4C: A4 9E    ldy $9e
EB4E: EA       nop
EB4F: 00       brk
EB50: 04 08    nop $08
EB52: 0C 10 14 nop $1410
EB55: 18       clc
EB56: 1C 5E 6A nop $6a5e, x
EB59: 76 5F    ror $5f, x
EB5B: 6B 77    arr #$77
EB5D: 60       rts
EB5E: 6C 78 61 jmp ($6178)
EB61: 6D 79 34 adc $3479
EB64: 35 36    and $36, x
EB66: 01 02    ora ($02, x)
EB68: 03 85    slo ($85, x)
EB6A: F5 EA    sbc $ea, x
EB6C: A2 05    ldx #$05
EB6E: 85 F5    sta dummy_write_00f5
EB70: EA       nop
EB71: B5 68    lda $68, x
EB73: 10 0A    bpl $eb7f
EB75: 85 F5    sta dummy_write_00f5
EB77: 6E CA 10 ror $10ca
EB7A: F6 60    inc $60, x
EB7C: 85 F5    sta dummy_write_00f5
EB7E: 6E BC 4F ror $4fbc
EB81: EB B9    sbc #$b9
EB83: 02       kil
EB84: 18       clc
EB85: 85 03    sta $03
EB87: 5D 03 18 eor $1803, x
EB8A: 85 04    sta $04
EB8C: CC 00 02 cpy $0200
EB8F: B9 03 02 lda $0203, y
EB92: E9 08    sbc #$08
EB94: C5 03    cmp $03
EB96: 90 E0    bcc $eb78
EB98: E9 20    sbc #$20
EB9A: C5 03    cmp $03
EB9C: B0 DA    bcs $eb78
EB9E: B9 04 02 lda $0204, y
EBA1: E9 05    sbc #$05
EBA3: C5 04    cmp $04
EBA5: B0 D1    bcs $eb78
EBA7: 69 0C    adc #$0c
EBA9: C5 04    cmp $04
EBAB: 90 CB    bcc $eb78
EBAD: B5 68    lda $68, x
EBAF: 29 0F    and #$0f
EBB1: 09 80    ora #$80
EBB3: 95 68    sta $68, x
EBB5: 4D 42 95 eor $9542
EBB8: 99 A9 0C sta $0ca9, y
EBBB: 20 5E EA jsr $ea5e
EBBE: 4C 78 EB jmp $eb78
EBC1: 85 F6    sta $f6
EBC3: EA       nop
EBC4: A9 05    lda #$05
EBC6: 85 2B    sta player_pepper_002b
EBC8: 85 2C    sta $2c
EBCA: AD 04 40 lda $4004
EBCD: 29 10    and #$10
EBCF: D0 05    bne $ebd6
EBD1: C6 2B    dec player_pepper_002b
EBD3: 85 F6    sta $f6
EBD5: 6E 60 01 ror $0160
EBD8: D7 48    dcp $48, x
EBDA: 06 D7    asl $d7
EBDC: 68       pla
EBDD: 04 D7    nop $d7
EBDF: 98       tya
EBE0: 02       kil
EBE1: D7 B8    dcp $b8, x
EBE3: 0F D7 E8 slo $e8d7
EBE6: 01 A7    ora ($a7, x)
EBE8: 28       plp
EBE9: 06 A7    asl $a7
EBEB: 78       sei
EBEC: 04 A7    nop $a7
EBEE: 98       tya
EBEF: 02       kil
EBF0: A7 B8    lax $b8
EBF2: 0F A7 E8 slo $e8a7
EBF5: 01 77    ora ($77, x)
EBF7: 28       plp
EBF8: 06 77    asl $77
EBFA: 48       pha
EBFB: 04 77    nop $77
EBFD: 78       sei
EBFE: 02       kil
EBFF: 77 B8    rra $b8, x
EC01: 0F 77 E8 slo $e877
EC04: 01 47    ora ($47, x)
EC06: 28       plp
EC07: 06 47    asl $47
EC09: 48       pha
EC0A: 04 47    nop $47
EC0C: 68       pla
EC0D: 02       kil
EC0E: 47 88    sre $88
EC10: 0F 47 E8 slo $e847
EC13: FF 01 A7 isb $a701, x
EC16: 28       plp
EC17: 05 A7    ora $a7
EC19: 38       sec
EC1A: 06 A7    asl $a7
EC1C: 48       pha
EC1D: 04 A7    nop $a7
EC1F: 58       cli
EC20: 06 A7    asl $a7
EC22: 68       pla
EC23: 04 A7    nop $a7
EC25: 78       sei
EC26: 05 A7    ora $a7
EC28: 88       dey
EC29: 02       kil
EC2A: A7 98    lax $98
EC2C: 0F A7 E8 slo $e8a7
EC2F: 01 77    ora ($77, x)
EC31: 28       plp
EC32: 05 77    ora $77
EC34: 38       sec
EC35: 04 77    nop $77
EC37: 48       pha
EC38: 06 77    asl $77
EC3A: 58       cli
EC3B: 04 77    nop $77
EC3D: 68       pla
EC3E: 05 77    ora $77
EC40: 78       sei
EC41: 06 77    asl $77
EC43: 88       dey
EC44: 02       kil
EC45: 77 98    rra $98, x
EC47: 0F 77 E8 slo $e877
EC4A: FF 01 D7 isb $d701, x
EC4D: 28       plp
EC4E: 06 D7    asl $d7
EC50: 38       sec
EC51: 03 D7    slo ($d7, x)
EC53: 48       pha
EC54: 02       kil
EC55: D7 68    dcp $68, x
EC57: 0F D7 B8 slo $b8d7
EC5A: 01 A7    ora ($a7, x)
EC5C: 28       plp
EC5D: 03 A7    slo ($a7, x)
EC5F: 38       sec
EC60: 06 A7    asl $a7
EC62: 58       cli
EC63: 02       kil
EC64: A7 A8    lax game_speed_00a8
EC66: 0F A7 E8 slo $e8a7
EC69: 01 77    ora ($77, x)
EC6B: 28       plp
EC6C: 03 77    slo ($77, x)
EC6E: 78       sei
EC6F: 06 77    asl $77
EC71: 98       tya
EC72: 02       kil
EC73: 77 A8    rra game_speed_00a8, x
EC75: 0F 77 E8 slo $e877
EC78: 01 47    ora ($47, x)
EC7A: 28       plp
EC7B: 06 47    asl $47
EC7D: 48       pha
EC7E: 03 47    slo ($47, x)
EC80: 58       cli
EC81: 02       kil
EC82: 47 68    sre $68
EC84: 0F 47 B8 slo $b847
EC87: FF 01 D7 isb $d701, x
EC8A: 28       plp
EC8B: 04 D7    nop $d7
EC8D: 48       pha
EC8E: 02       kil
EC8F: D7 58    dcp $58, x
EC91: 0F D7 88 slo $88d7
EC94: 01 D7    ora ($d7, x)
EC96: 98       tya
EC97: 05 D7    ora $d7
EC99: A8       tay
EC9A: 02       kil
EC9B: D7 B8    dcp $b8, x
EC9D: 0F D7 E8 slo $e8d7
ECA0: 01 A7    ora ($a7, x)
ECA2: 28       plp
ECA3: 05 A7    ora $a7
ECA5: 38       sec
ECA6: 02       kil
ECA7: A7 58    lax $58
ECA9: 0F A7 B8 slo $b8a7
ECAC: 01 77    ora ($77, x)
ECAE: 28       plp
ECAF: 04 77    nop $77
ECB1: 38       sec
ECB2: 02       kil
ECB3: 77 58    rra $58, x
ECB5: 0F 77 B8 slo $b877
ECB8: 01 47    ora ($47, x)
ECBA: 28       plp
ECBB: 05 47    ora $47
ECBD: 48       pha
ECBE: 02       kil
ECBF: 47 58    sre $58
ECC1: 0F 47 88 slo $8847
ECC4: 01 47    ora ($47, x)
ECC6: 98       tya
ECC7: 04 47    nop $47
ECC9: A8       tay
ECCA: 02       kil
ECCB: 47 B8    sre $b8
ECCD: 0F 47 E8 slo $e847
ECD0: FF 01 D7 isb $d701, x
ECD3: 28       plp
ECD4: 03 D7    slo ($d7, x)
ECD6: 38       sec
ECD7: 05 D7    ora $d7
ECD9: 48       pha
ECDA: 06 D7    asl $d7
ECDC: 58       cli
ECDD: 04 D7    nop $d7
ECDF: 68       pla
ECE0: 06 D7    asl $d7
ECE2: 78       sei
ECE3: 05 D7    ora $d7
ECE5: 88       dey
ECE6: 02       kil
ECE7: D7 98    dcp $98, x
ECE9: 0F D7 E8 slo $e8d7
ECEC: 01 A7    ora ($a7, x)
ECEE: 28       plp
ECEF: 06 A7    asl $a7
ECF1: 38       sec
ECF2: 05 A7    ora $a7
ECF4: 48       pha
ECF5: 04 A7    nop $a7
ECF7: 58       cli
ECF8: 05 A7    ora $a7
ECFA: 68       pla
ECFB: 03 A7    slo ($a7, x)
ECFD: 78       sei
ECFE: 06 A7    asl $a7
ED00: 88       dey
ED01: 02       kil
ED02: A7 98    lax $98
ED04: 0F A7 E8 slo $e8a7
ED07: 01 77    ora ($77, x)
ED09: 28       plp
ED0A: 05 77    ora $77
ED0C: 38       sec
ED0D: 06 77    asl $77
ED0F: 48       pha
ED10: 05 77    ora $77
ED12: 58       cli
ED13: 04 77    nop $77
ED15: 68       pla
ED16: 03 77    slo ($77, x)
ED18: 78       sei
ED19: 06 77    asl $77
ED1B: 88       dey
ED1C: 02       kil
ED1D: 77 98    rra $98, x
ED1F: 0F 77 E8 slo $e877
ED22: 01 47    ora ($47, x)
ED24: 28       plp
ED25: 03 47    slo ($47, x)
ED27: 38       sec
ED28: 06 47    asl $47
ED2A: 48       pha
ED2B: 04 47    nop $47
ED2D: 58       cli
ED2E: 05 47    ora $47
ED30: 68       pla
ED31: 06 47    asl $47
ED33: 78       sei
ED34: 05 47    ora $47
ED36: 88       dey
ED37: 02       kil
ED38: 47 98    sre $98
ED3A: 0F 47 E8 slo $e847
ED3D: FF 01 D7 isb $d701, x
ED40: 38       sec
ED41: 03 D7    slo ($d7, x)
ED43: 58       cli
ED44: 04 D7    nop $d7
ED46: 78       sei
ED47: 02       kil
ED48: D7 B8    dcp $b8, x
ED4A: 0F D7 E8 slo $e8d7
ED4D: 01 A7    ora ($a7, x)
ED4F: 28       plp
ED50: 03 A7    slo ($a7, x)
ED52: 48       pha
ED53: 04 A7    nop $a7
ED55: 68       pla
ED56: 03 A7    slo ($a7, x)
ED58: 88       dey
ED59: 02       kil
ED5A: A7 A8    lax game_speed_00a8
ED5C: 0F A7 E8 slo $e8a7
ED5F: 01 77    ora ($77, x)
ED61: 38       sec
ED62: 03 77    slo ($77, x)
ED64: 58       cli
ED65: 03 77    slo ($77, x)
ED67: 78       sei
ED68: 04 77    nop $77
ED6A: 98       tya
ED6B: 02       kil
ED6C: 77 B8    rra $b8, x
ED6E: 0F 77 E8 slo $e877
ED71: 01 47    ora ($47, x)
ED73: 28       plp
ED74: 04 47    nop $47
ED76: 48       pha
ED77: 03 47    slo ($47, x)
ED79: 68       pla
ED7A: 02       kil
ED7B: 47 88    sre $88
ED7D: 0F 47 E8 slo $e847
ED80: FF 01 B9 isb $b901, x
ED83: AB 9A    lxa #$9a
ED85: A9 BA    lda #$ba
ED87: 9B 10 05 shs $0510, y
ED8A: 60       rts
ED8B: 56 75    lsr $75, x
ED8D: 50 65    bvc $edf4
ED8F: 06 50    asl $50
ED91: 03 D9    slo ($d9, x)
ED93: C4 73    cpy $73
ED95: C9 DC    cmp #$dc
ED97: 9D 30 00 sta $0030, x
ED9A: 07 3D    slo $3d
ED9C: 8C 37 65 sty $6537
ED9F: 06 50    asl $50
EDA1: 01 B8    ora ($b8, x)
EDA3: C4 05    cpy $05
EDA5: 57 4C    sre $4c, x
EDA7: 9D 30 05 sta $0530, x
EDAA: 67 3D    rra $3d
EDAC: 9C C8 D3 shy $d3c8, x
EDAF: 70 00    bvs $edb1
EDB1: 05 67    ora $67
EDB3: 56 05    lsr $05, x
EDB5: 50 4C    bvc $ee03
EDB7: 8B 10    ane #$10
EDB9: 03 D8    slo ($d8, x)
EDBB: CD 9C C9 cmp $c99c
EDBE: D3 76    dcp ($76), y
EDC0: 50 05    bvc $edc7
EDC2: 60       rts
EDC3: 56 05    lsr $05, x
EDC5: 50 65    bvc $ee2c
EDC7: 76 50    ror $50, x
EDC9: 03 D9    slo ($d9, x)
EDCB: CD 9C C9 cmp $c99c
EDCE: DC 8D 30 nop $308d, x
EDD1: 00       brk
EDD2: 00       brk
EDD3: 00       brk
EDD4: 00       brk
EDD5: 00       brk
EDD6: 00       brk
EDD7: 00       brk
EDD8: 00       brk
EDD9: 00       brk
EDDA: 00       brk
EDDB: 00       brk
EDDC: 00       brk
EDDD: 00       brk
EDDE: 00       brk
EDDF: 00       brk
EDE0: 00       brk
EDE1: 00       brk
EDE2: 00       brk
EDE3: 00       brk
EDE4: 00       brk
EDE5: 00       brk
EDE6: 00       brk
EDE7: 00       brk
EDE8: 00       brk
EDE9: 01 B9    ora ($b9, x)
EDEB: AB 9A    lxa #$9a
EDED: A9 BA    lda #$ba
EDEF: 9B 10 03 shs $0310, y
EDF2: D9 AB 9A cmp $9aab, y
EDF5: A9 BA    lda #$ba
EDF7: 8D 30 01 sta $0130
EDFA: B9 AB 9C lda $9cab, y
EDFD: C9 D3    cmp #$d3
EDFF: 76 50    ror $50, x
EE01: 03 D9    slo ($d9, x)
EE03: AB 9A    lxa #$9a
EE05: A9 B1    lda #$b1
EE07: 76 50    ror $50, x
EE09: 03 D9    slo ($d9, x)
EE0B: AB 9A    lxa #$9a
EE0D: A9 DC    lda #$dc
EE0F: 8D 30 03 sta $0330
EE12: D9 CD 9A cmp $9acd, y
EE15: A9 B1    lda #$b1
EE17: 76 50    ror $50, x
EE19: 03 D9    slo ($d9, x)
EE1B: AB 9A    lxa #$9a
EE1D: A9 D3    lda #$d3
EE1F: 76 50    ror $50, x
EE21: 03 D9    slo ($d9, x)
EE23: AB 9A    lxa #$9a
EE25: A9 D3    lda #$d3
EE27: 76 50    ror $50, x
EE29: 05 60    ora $60
EE2B: 00       brk
EE2C: 00       brk
EE2D: 00       brk
EE2E: 2A       rol a
EE2F: 8D 30 05 sta $0530
EE32: 60       rts
EE33: 00       brk
EE34: 00       brk
EE35: 00       brk
EE36: 65 06    adc $06
EE38: 50 05    bvc $ee3f
EE3A: 60       rts
EE3B: 00       brk
EE3C: 00       brk
EE3D: 00       brk
EE3E: 65 06    adc $06
EE40: 50 03    bvc $ee45
EE42: 40       rti
EE43: 00       brk
EE44: 00       brk
EE45: 00       brk
EE46: 4C 9D 30 jmp $309d
EE49: 00       brk
EE4A: 00       brk
EE4B: 00       brk
EE4C: 00       brk
EE4D: 00       brk
EE4E: 00       brk
EE4F: 00       brk
EE50: 00       brk
EE51: 01 B9    ora ($b9, x)
EE53: AB 9A    lxa #$9a
EE55: A9 BA    lda #$ba
EE57: 9B 10 03 shs $0310, y
EE5A: D8       cld
EE5B: CD 8C 37 cmp $378c
EE5E: 65 76    adc $76
EE60: 50 03    bvc $ee65
EE62: D8       cld
EE63: C4 73    cpy $73
EE65: C8       iny
EE66: DC 8D 30 nop $308d, x
EE69: 05 67    ora $67
EE6B: 3D 8C 37 and $378c, x
EE6E: 4C 8D 30 jmp $308d
EE71: 03 D8    slo ($d8, x)
EE73: CD 8C C8 cmp $c88c
EE76: DC 8D 30 nop $308d, x
EE79: 00       brk
EE7A: 00       brk
EE7B: 00       brk
EE7C: 73 C8    rra ($c8), y
EE7E: B1 00    lda ($00), y
EE80: 00       brk
EE81: 00       brk
EE82: 00       brk
EE83: 1B 8C 37 slo $378c, y
EE86: 00       brk
EE87: 00       brk
EE88: 00       brk
EE89: 00       brk
EE8A: 00       brk
EE8B: 00       brk
EE8C: 73 C8    rra ($c8), y
EE8E: B1 00    lda ($00), y
EE90: 00       brk
EE91: 00       brk
EE92: 00       brk
EE93: 1B 8C C8 slo $c88c, y
EE96: B1 00    lda ($00), y
EE98: 00       brk
EE99: 00       brk
EE9A: 00       brk
EE9B: 00       brk
EE9C: 05 50    ora $50
EE9E: 00       brk
EE9F: 00       brk
EEA0: 00       brk
EEA1: 00       brk
EEA2: 00       brk
EEA3: 00       brk
EEA4: 03 30    slo ($30, x)
EEA6: 00       brk
EEA7: 00       brk
EEA8: 00       brk
EEA9: 00       brk
EEAA: 00       brk
EEAB: 00       brk
EEAC: 00       brk
EEAD: 00       brk
EEAE: 00       brk
EEAF: 00       brk
EEB0: 00       brk
EEB1: 00       brk
EEB2: 00       brk
EEB3: 00       brk
EEB4: 00       brk
EEB5: 00       brk
EEB6: 00       brk
EEB7: 00       brk
EEB8: 00       brk
EEB9: 01 B9    ora ($b9, x)
EEBB: AB 9A    lxa #$9a
EEBD: A9 BA    lda #$ba
EEBF: 9B 10 03 shs $0310, y
EEC2: D9 CD 8A cmp $8acd, y
EEC5: A8       tay
EEC6: BA       tsx
EEC7: 9D 30 03 sta $0330, x
EECA: D9 CD 9C cmp $9ccd, y
EECD: 30 4C    bmi $ef1b
EECF: 9D 30 03 sta $0330, x
EED2: D9 AB 8C cmp $8cab, y
EED5: C9 DC    cmp #$dc
EED7: 9D 30 00 sta $0030, x
EEDA: 00       brk
EEDB: 34 73    nop $73, x
EEDD: C8       iny
EEDE: B1 00    lda ($00), y
EEE0: 00       brk
EEE1: 00       brk
EEE2: 00       brk
EEE3: 3D 8C C9 and $c98c, x
EEE6: D3 00    dcp ($00), y
EEE8: 00       brk
EEE9: 00       brk
EEEA: 00       brk
EEEB: 34 00    nop $00, x
EEED: 00       brk
EEEE: 65 00    adc $00
EEF0: 00       brk
EEF1: 01 B9    ora ($b9, x)
EEF3: C4 00    cpy $00
EEF5: 00       brk
EEF6: 4C 9B 10 jmp $109b
EEF9: 03 D8    slo ($d8, x)
EEFB: C4 00    cpy $00
EEFD: 00       brk
EEFE: 4C 9D 30 jmp $309d
EF01: 03 D8    slo ($d8, x)
EF03: C4 00    cpy $00
EF05: 00       brk
EF06: 4C 8D 30 jmp $308d
EF09: 00       brk
EF0A: 00       brk
EF0B: 3D 9A A9 and $a99a, x
EF0E: D3 00    dcp ($00), y
EF10: 00       brk
EF11: 00       brk
EF12: 00       brk
EF13: 3D 8A A8 and $a88a, x
EF16: D3 00    dcp ($00), y
EF18: 00       brk
EF19: 00       brk
EF1A: 00       brk
EF1B: 00       brk
EF1C: 00       brk
EF1D: 00       brk
EF1E: 00       brk
EF1F: 00       brk
EF20: 00       brk
EF21: 01 B9    ora ($b9, x)
EF23: AB 9A    lxa #$9a
EF25: A9 BA    lda #$ba
EF27: 9B 10 03 shs $0310, y
EF2A: D9 CD 9C cmp $9ccd, y
EF2D: C9 DC    cmp #$dc
EF2F: 9D 30 01 sta $0130, x
EF32: B8       clv
EF33: AB 8A    lxa #$8a
EF35: A8       tay
EF36: BA       tsx
EF37: 8B 10    ane #$10
EF39: 03 D9    slo ($d9, x)
EF3B: CD 9C C9 cmp $c99c
EF3E: DC 9D 30 nop $309d, x
EF41: 01 B8    ora ($b8, x)
EF43: AB 8C    lxa #$8c
EF45: C8       iny
EF46: BA       tsx
EF47: 8B 10    ane #$10
EF49: 03 D9    slo ($d9, x)
EF4B: CD 9C C9 cmp $c99c
EF4E: DC 9D 30 nop $309d, x
EF51: 03 D8    slo ($d8, x)
EF53: AB 8A    lxa #$8a
EF55: A8       tay
EF56: BA       tsx
EF57: 8D 30 03 sta $0330
EF5A: D9 CD 9C cmp $9ccd, y
EF5D: C9 DC    cmp #$dc
EF5F: 9D 30 00 sta $0030, x
EF62: 00       brk
EF63: 00       brk
EF64: 00       brk
EF65: 00       brk
EF66: 00       brk
EF67: 00       brk
EF68: 00       brk
EF69: 00       brk
EF6A: 00       brk
EF6B: 00       brk
EF6C: 00       brk
EF6D: 00       brk
EF6E: 00       brk
EF6F: 00       brk
EF70: 00       brk
EF71: 00       brk
EF72: 00       brk
EF73: 00       brk
EF74: 00       brk
EF75: 00       brk
EF76: 00       brk
EF77: 00       brk
EF78: 00       brk
EF79: 00       brk
EF7A: 00       brk
EF7B: 00       brk
EF7C: 00       brk
EF7D: 00       brk
EF7E: 00       brk
EF7F: 00       brk
EF80: 00       brk
EF81: 00       brk
EF82: 00       brk
EF83: 00       brk
EF84: 00       brk
EF85: 00       brk
EF86: 00       brk
EF87: 00       brk
EF88: 00       brk
EF89: 00       brk
EF8A: 00       brk
EF8B: 1B 9A 10 slo $109a, y
EF8E: 2A       rol a
EF8F: 9B 10 01 shs $0110, y
EF92: B9 C4 71 lda $71c4, y
EF95: A9 D3    lda #$d3
EF97: 00       brk
EF98: 00       brk
EF99: 00       brk
EF9A: 00       brk
EF9B: 3D 8A 17 and $178a, x
EF9E: 2A       rol a
EF9F: 9B 10 01 shs $0110, y
EFA2: B9 C4 73 lda $73c4, y
EFA5: C8       iny
EFA6: D3 00    dcp ($00), y
EFA8: 00       brk
EFA9: 00       brk
EFAA: 00       brk
EFAB: 1B 8C 30 slo $308c, y
EFAE: 4C 9B 10 jmp $109b
EFB1: 01 B9    ora ($b9, x)
EFB3: C4 03    cpy $03
EFB5: C9 D3    cmp #$d3
EFB7: 00       brk
EFB8: 00       brk
EFB9: 00       brk
EFBA: 00       brk
EFBB: 3D 9A 17 and $179a, x
EFBE: 2A       rol a
EFBF: 9B 10 01 shs $0110, y
EFC2: B9 C4 73 lda $73c4, y
EFC5: C8       iny
EFC6: D3 00    dcp ($00), y
EFC8: 00       brk
EFC9: 00       brk
EFCA: 00       brk
EFCB: 1B 8A 17 slo $178a, y
EFCE: 4C 9B 10 jmp $109b
EFD1: 01 B9    ora ($b9, x)
EFD3: C4 03    cpy $03
EFD5: C8       iny
EFD6: D3 00    dcp ($00), y
EFD8: 00       brk
EFD9: 00       brk
EFDA: 00       brk
EFDB: 00       brk
EFDC: 00       brk
EFDD: 00       brk
EFDE: 00       brk
EFDF: 00       brk
EFE0: 00       brk
EFE1: 00       brk
EFE2: 00       brk
EFE3: 00       brk
EFE4: 00       brk
EFE5: 00       brk
EFE6: 00       brk
EFE7: 00       brk
EFE8: 00       brk
EFE9: 00       brk
EFEA: 00       brk
EFEB: 00       brk
EFEC: 00       brk
EFED: 00       brk
EFEE: 00       brk
EFEF: 00       brk
EFF0: 00       brk
EFF1: 85 F5    sta dummy_write_00f5
EFF3: EA       nop
EFF4: A9 00    lda #$00
EFF6: 85 F3    sta $f3
EFF8: 85 F5    sta dummy_write_00f5
EFFA: EA       nop
EFFB: A9 00    lda #$00
EFFD: 85 ED    sta $ed
EFFF: 4D 36 85 eor $8536
F002: E4 A9    cpx $a9
F004: 00       brk
F005: 85 E5    sta $e5
F007: 85 F5    sta dummy_write_00f5
F009: EA       nop
F00A: A0 02    ldy #$02
F00C: 85 F5    sta dummy_write_00f5
F00E: EA       nop
F00F: B1 E4    lda ($e4), y
F011: 99 E7 00 sta $00e7, y
F014: 88       dey
F015: 10 F8    bpl $f00f
F017: A5 E7    lda $e7
F019: C9 FF    cmp #$ff
F01B: D0 04    bne $f021
F01D: 60       rts
F01E: 85 F5    sta dummy_write_00f5
F020: EA       nop
F021: A5 E4    lda $e4
F023: 18       clc
F024: 69 03    adc #$03
F026: 85 E4    sta $e4
F028: A5 E5    lda $e5
F02A: 69 00    adc #$00
F02C: 85 E5    sta $e5
F02E: E6 ED    inc $ed
F030: F8       sed
F031: A5 E7    lda $e7
F033: 38       sec
F034: E5 CC    sbc $cc
F036: A5 E8    lda $e8
F038: E5 CD    sbc $cd
F03A: A5 E9    lda $e9
F03C: E5 CE    sbc $ce
F03E: D8       cld
F03F: B0 C9    bcs $f00a
F041: A6 ED    ldx $ed
F043: BD 7E F0 lda $f07e, x
F046: 18       clc
F047: 69 36    adc #$36
F049: 85 D8    sta $d8
F04B: A9 00    lda #$00
F04D: 85 D9    sta $d9
F04F: A9 02    lda #$02
F051: 85 DA    sta $da
F053: 20 8C F0 jsr $f08c
F056: A2 02    ldx #$02
F058: 85 F5    sta dummy_write_00f5
F05A: EA       nop
F05B: A9 00    lda #$00
F05D: 95 CC    sta $cc, x
F05F: CA       dex
F060: 10 F9    bpl $f05b
F062: A6 ED    ldx $ed
F064: BD 84 F0 lda $f084, x
F067: 18       clc
F068: 69 36    adc #$36
F06A: 85 D8    sta $d8
F06C: A9 00    lda #$00
F06E: 85 D9    sta $d9
F070: A9 02    lda #$02
F072: 85 DA    sta $da
F074: 20 8C F0 jsr $f08c
F077: 20 D1 F0 jsr $f0d1
F07A: 20 E3 CB jsr $cbe3
F07D: 60       rts
F07E: 00       brk
F07F: 00       brk
F080: 03 06    slo ($06, x)
F082: 09 0C    ora #$0c
F084: 00       brk
F085: 12       kil
F086: 15 18    ora $18, x
F088: 1B 1E 85 slo $851e, y
F08B: F5 EA    sbc $ea, x
F08D: A4 DA    ldy $da
F08F: 85 F5    sta dummy_write_00f5
F091: EA       nop
F092: B1 D8    lda ($d8), y
F094: 99 EA 00 sta $00ea, y
F097: 88       dey
F098: 10 F8    bpl $f092
F09A: A5 EA    lda $ea
F09C: C9 FF    cmp #$ff
F09E: D0 04    bne $f0a4
F0A0: 60       rts
F0A1: 85 F5    sta dummy_write_00f5
F0A3: EA       nop
F0A4: A4 DA    ldy $da
F0A6: 85 F5    sta dummy_write_00f5
F0A8: EA       nop
F0A9: B9 CC 00 lda $00cc, y
F0AC: 91 D8    sta ($d8), y
F0AE: 88       dey
F0AF: 10 F8    bpl $f0a9
F0B1: A6 DA    ldx $da
F0B3: 85 F5    sta dummy_write_00f5
F0B5: EA       nop
F0B6: B5 EA    lda $ea, x
F0B8: 95 CC    sta $cc, x
F0BA: CA       dex
F0BB: 10 F9    bpl $f0b6
F0BD: A6 DA    ldx $da
F0BF: E8       inx
F0C0: 8A       txa
F0C1: 18       clc
F0C2: 65 D8    adc $d8
F0C4: 85 D8    sta $d8
F0C6: A5 D9    lda $d9
F0C8: 69 00    adc #$00
F0CA: 85 D9    sta $d9
F0CC: 4C 8D F0 jmp $f08d
F0CF: 85 F5    sta dummy_write_00f5
F0D1: EA       nop
F0D2: 20 A3 C8 jsr $c8a3
F0D5: 20 DC F1 jsr $f1dc
F0D8: 20 F8 F2 jsr $f2f8
F0DB: A9 05    lda #$05
F0DD: 85 DC    sta $dc
F0DF: 85 F5    sta dummy_write_00f5
F0E1: EA       nop
F0E2: A5 DC    lda $dc
F0E4: 18       clc
F0E5: 69 03    adc #$03
F0E7: 85 DD    sta $dd
F0E9: 0A       asl a
F0EA: 18       clc
F0EB: 65 DD    adc $dd
F0ED: AA       tax
F0EE: A5 DC    lda $dc
F0F0: 0A       asl a
F0F1: 18       clc
F0F2: 69 10    adc #$10
F0F4: A8       tay
F0F5: 20 5A C9 jsr $c95a
F0F8: C6 DC    dec $dc
F0FA: 10 E6    bpl $f0e2
F0FC: A9 04    lda #$04
F0FE: 85 DC    sta $dc
F100: 20 B6 F1 jsr $f1b6
F103: A9 00    lda #$00
F105: 85 DE    sta $de
F107: 4D 07 85 eor $8507
F10A: DF A9 06 dcp $06a9, x
F10D: 85 E0    sta $e0
F10F: 4D 00 85 eor $8500
F112: E1 85    sbc ($85, x)
F114: E2 C1    nop #$c1
F116: E3 C1    isb ($c1, x)
F118: F5 EA    sbc $ea, x
F11A: 20 B8 F2 jsr $f2b8
F11D: 20 D1 F2 jsr $f2d1
F120: A5 E2    lda $e2
F122: 29 0F    and #$0f
F124: C9 0F    cmp #$0f
F126: D0 0C    bne $f134
F128: 20 B8 F2 jsr $f2b8
F12B: A9 00    lda #$00
F12D: 8D 03 40 sta $4003
F130: 60       rts
F131: 85 F5    sta dummy_write_00f5
F133: EA       nop
F134: A5 E2    lda $e2
F136: 10 15    bpl $f14d
F138: A5 E3    lda $e3
F13A: 30 11    bmi $f14d
F13C: A9 FF    lda #$ff
F13E: 85 DE    sta $de
F140: A5 E3    lda $e3
F142: 09 80    ora #$80
F144: 85 E3    sta $e3
F146: 4D 00 85 eor $8500
F149: DF 85 F5 dcp $f585, x
F14C: 6E A5 DE ror $dea5
F14F: 05 DF    ora $df
F151: D0 12    bne $f165
F153: A5 E2    lda $e2
F155: 10 07    bpl $f15e
F157: 09 0F    ora #$0f
F159: 85 E2    sta $e2
F15B: 85 F5    sta dummy_write_00f5
F15D: 6E 09 80 ror $8009
F160: 85 E2    sta $e2
F162: 85 F5    sta dummy_write_00f5
F164: 6E 20 2F ror $2f20
F167: F3 20    isb ($20), y
F169: 7C F3 20 nop $20f3, x
F16C: E9 F3    sbc #$f3
F16E: 20 2F F4 jsr $f42f
F171: 20 9C F5 jsr $f59c
F174: A5 E2    lda $e2
F176: 29 20    and #$20
F178: F0 1D    beq $f197
F17A: 20 DC F1 jsr $f1dc
F17D: 20 B6 F1 jsr $f1b6
F180: 20 F8 F2 jsr $f2f8
F183: A5 E2    lda $e2
F185: 49 20    eor #$20
F187: AA       tax
F188: A5 E3    lda $e3
F18A: 29 40    and #$40
F18C: D0 04    bne $f192
F18E: E8       inx
F18F: 85 F5    sta dummy_write_00f5
F191: EA       nop
F192: 86 E2    stx $e2
F194: C1 F5    cmp (dummy_write_00f5, x)
F196: 6E 20 3E ror $3e20
F199: F6 A5    inc $a5, x
F19B: E3 29    isb ($29, x)
F19D: BF 85 E3 lax $e385, y
F1A0: A5 E2    lda $e2
F1A2: 29 0F    and #$0f
F1A4: C9 03    cmp #$03
F1A6: 90 09    bcc $f1b1
F1A8: A5 E3    lda $e3
F1AA: 09 20    ora #$20
F1AC: 85 E3    sta $e3
F1AE: C1 F5    cmp (dummy_write_00f5, x)
F1B0: EA       nop
F1B1: 4C 1A F1 jmp $f11a
F1B4: 85 F5    sta dummy_write_00f5
F1B6: 6E A9 B4 ror $b4a9
F1B9: 8D 02 18 sta $1802
F1BC: 4D 40 8D eor $8d40
F1BF: 03 18    slo ($18, x)
F1C1: A9 47    lda #$47
F1C3: 8D 01 18 sta $1801
F1C6: 4D 01 8D eor $8d01
F1C9: 00       brk
F1CA: 18       clc
F1CB: A9 00    lda #$00
F1CD: 8D 04 18 sta $1804
F1D0: 85 EE    sta $ee
F1D2: 85 EF    sta $ef
F1D4: 4D 17 8D eor $8d17
F1D7: 05 18    ora $18
F1D9: 60       rts
F1DA: 85 F5    sta dummy_write_00f5
F1DC: 6E A9 08 ror $08a9
F1DF: 85 DD    sta $dd
F1E1: 85 F5    sta dummy_write_00f5
F1E3: EA       nop
F1E4: A5 DD    lda $dd
F1E6: 0A       asl a
F1E7: AA       tax
F1E8: BD 12 F2 lda $f212, x
F1EB: 85 D8    sta $d8
F1ED: DD 24 F2 cmp $f224, x
F1F0: 85 DA    sta $da
F1F2: E8       inx
F1F3: BD 12 F2 lda $f212, x
F1F6: 85 D9    sta $d9
F1F8: BD 24 F2 lda $f224, x
F1FB: 85 DB    sta $db
F1FD: CA       dex
F1FE: DD BD 36 cmp $36bd, x
F201: F2       kil
F202: A8       tay
F203: 85 F5    sta dummy_write_00f5
F205: EA       nop
F206: B1 D8    lda ($d8), y
F208: 91 DA    sta ($da), y
F20A: 88       dey
F20B: 10 F9    bpl $f206
F20D: C6 DD    dec $dd
F20F: 10 D3    bpl $f1e4
F211: 60       rts
F212: 3F F2 52
F215: F2      
F216: 65 F2   
F218: 78      
F219: F2      
F21A: 83 F2   
F21C: 92      
F21D: F2      
F21E: 9B F2 A4
F221: F2      
F222: AD F2 A8
F225: 10 08   
F227: 11 68   
F229: 11 C8   
F22B: 11 4B   
F22D: 12      
F22E: D4 18    nop $18, x
F230: 14 1B    nop $1b, x
F232: 34 1B    nop $1b, x
F234: 54 1B    nop $1b, x
F236: 12       kil
F237: 12       kil
F238: 12       kil
F239: 0A       asl a
F23A: 0E 08 08 asl $0808
F23D: 08       php
F23E: 08       php
F23F: 0B 00    anc #$00
F241: 0C 00 0D nop $0d00
F244: 00       brk
F245: 0E 00 0F asl $0f00
F248: 00       brk
F249: 10 00    bpl $f24b
F24B: 11 00    ora ($00), y
F24D: 12       kil
F24E: 00       brk
F24F: 13 00    slo ($00), y
F251: 14 15    nop $15, x
F253: 00       brk
F254: 16 00    asl $00, x
F256: 17 00    slo $00, x
F258: 18       clc
F259: 00       brk
F25A: 19 00 1A ora $1a00, y
F25D: 00       brk
F25E: 1B 00 1C slo $1c00, y
F261: 00       brk
F262: 1D 00 1E ora $1e00, x
F265: 1F 00 20 slo $2000, x
F268: 00       brk
F269: 21 00    and ($00, x)
F26B: 22       kil
F26C: 00       brk
F26D: 23 00    rla ($00, x)
F26F: 24 00    bit $00
F271: CC 00 CD cpy $cd00
F274: 00       brk
F275: CE 00 CF dec $cf00
F278: 1D 1A 0B ora $0b1a, x
F27B: 00       brk
F27C: 1C 1F 0C nop $0c1f, x
F27F: 00       brk
F280: 0F 18 0E slo $0e18
F283: 3C 2F 3B nop $3b2f, x
F286: 33 00    rla ($00), y
F288: 00       brk
F289: 00       brk
F28A: 00       brk
F28B: 00       brk
F28C: 00       brk
F28D: 41 31    eor ($31, x)
F28F: 3D 40 33 and $3340, x
F292: 26 00    rol $00
F294: 27 00    rla $00
F296: 28       plp
F297: 00       brk
F298: 29 00    and #$00
F29A: 2A       rol a
F29B: 3E 00 3E rol $3e00, x
F29E: 00       brk
F29F: 3E 00 3E rol $3e00, x
F2A2: 00       brk
F2A3: 3E 42 00 rol $0042, x
F2A6: 42       kil
F2A7: 00       brk
F2A8: 42       kil
F2A9: 00       brk
F2AA: 42       kil
F2AB: 00       brk
F2AC: 42       kil
F2AD: 41 00    eor ($00, x)
F2AF: 41 00    eor ($00, x)
F2B1: 41 00    eor ($00, x)
F2B3: 41 00    eor ($00, x)
F2B5: 41 85    eor ($85, x)
F2B7: F5 EA    sbc $ea, x
F2B9: AD 03 40 lda $4003
F2BC: 10 FB    bpl $f2b9
F2BE: 85 F5    sta dummy_write_00f5
F2C0: EA       nop
F2C1: AD 03 40 lda $4003
F2C4: 30 FB    bmi $f2c1
F2C6: 58       cli
F2C7: EA       nop
F2C8: EA       nop
F2C9: EA       nop
F2CA: 78       sei
F2CB: 20 45 D0 jsr $d045
F2CE: 60       rts
F2CF: 85 F5    sta dummy_write_00f5
F2D1: EA       nop
F2D2: A5 DE    lda $de
F2D4: 38       sec
F2D5: E9 01    sbc #$01
F2D7: 85 DE    sta $de
F2D9: A5 DF    lda $df
F2DB: E9 00    sbc #$00
F2DD: 85 DF    sta $df
F2DF: C6 E0    dec $e0
F2E1: 10 07    bpl $f2ea
F2E3: A9 04    lda #$04
F2E5: 85 E0    sta $e0
F2E7: 85 F5    sta dummy_write_00f5
F2E9: EA       nop
F2EA: C6 E1    dec $e1
F2EC: 10 07    bpl $f2f5
F2EE: A9 00    lda #$00
F2F0: 85 E1    sta $e1
F2F2: 85 F5    sta dummy_write_00f5
F2F4: EA       nop
F2F5: 60       rts
F2F6: 85 F5    sta dummy_write_00f5
F2F8: EA       nop
F2F9: A9 8B    lda #$8b
F2FB: 85 D8    sta $d8
F2FD: A9 12    lda #$12
F2FF: 85 D9    sta $d9
F301: A2 00    ldx #$00
F303: 85 F5    sta dummy_write_00f5
F305: 6E A0 00 ror $00a0
F308: 85 F5    sta dummy_write_00f5
F30A: EA       nop
F30B: B5 48    lda $48, x
F30D: 91 D8    sta ($d8), y
F30F: 6C E0 0F jmp ($0fe0)
F312: D0 04    bne $f318
F314: 60       rts
F315: 85 F5    sta dummy_write_00f5
F317: 6E C8 C0 ror $c0c8
F31A: 03 D0    slo ($d0, x)
F31C: EE A5 D8 inc $d8a5
F31F: 18       clc
F320: 69 40    adc #$40
F322: 85 D8    sta $d8
F324: C9 D9    cmp #$d9
F326: 69 00    adc #$00
F328: 85 D9    sta $d9
F32A: 4C 06 F3 jmp $f306
F32D: 85 F5    sta dummy_write_00f5
F32F: 6E A5 E0 ror $e0a5
F332: D0 45    bne $f379
F334: A5 E2    lda $e2
F336: 29 10    and #$10
F338: 4A       lsr a
F339: 4A       lsr a
F33A: 4A       lsr a
F33B: 4A       lsr a
F33C: 18       clc
F33D: 69 43    adc #$43
F33F: 8D 01 18 sta $1801
F342: A5 E2    lda $e2
F344: 10 2A    bpl $f370
F346: C6 DC    dec $dc
F348: F0 07    beq $f351
F34A: A9 47    lda #$47
F34C: D0 1C    bne $f36a
F34E: 85 F5    sta dummy_write_00f5
F350: EA       nop
F351: E6 F3    inc $f3
F353: A5 F3    lda $f3
F355: C9 01    cmp #$01
F357: D0 08    bne $f361
F359: A9 1E    lda #$1e
F35B: 8D 03 40 sta $4003
F35E: C1 F5    cmp (dummy_write_00f5, x)
F360: EA       nop
F361: A9 03    lda #$03
F363: 85 DC    sta $dc
F365: 4D 4C 85 eor $854c
F368: F5 EA    sbc $ea, x
F36A: 8D 01 18 sta $1801
F36D: C1 F5    cmp (dummy_write_00f5, x)
F36F: 6E A5 E2 ror $e2a5
F372: 49 10    eor #$10
F374: 85 E2    sta $e2
F376: C1 F5    cmp (dummy_write_00f5, x)
F378: EA       nop
F379: 60       rts
F37A: 85 F5    sta dummy_write_00f5
F37C: 6E AD 02 ror $02ad
F37F: 40       rti
F380: 49 FF    eor #$ff
F382: 29 03    and #$03
F384: F0 08    beq $f38e
F386: BA       tsx
F387: E8       inx
F388: E8       inx
F389: 9A       txs
F38A: 60       rts
F38B: 85 F5    sta dummy_write_00f5
F38D: 6E A5 E0 ror $e0a5
F390: D0 42    bne $f3d4
F392: A5 E2    lda $e2
F394: 29 E0    and #$e0
F396: D0 3C    bne $f3d4
F398: A6 CB    ldx $cb
F39A: AD 03 40 lda $4003
F39D: 29 40    and #$40
F39F: D0 05    bne $f3a6
F3A1: A2 00    ldx #$00
F3A3: 85 F5    sta dummy_write_00f5
F3A5: 6E BD 00 ror $00bd
F3A8: 40       rti
F3A9: 49 FF    eor #$ff
F3AB: 29 0F    and #$0f
F3AD: AA       tax
F3AE: BD D5 F3 lda $f3d5, x
F3B1: C5 EF    cmp $ef
F3B3: F0 1F    beq $f3d4
F3B5: 85 EF    sta $ef
F3B7: 14 65    nop $65, x
F3B9: EE 10 05 inc $0510
F3BC: A9 00    lda #$00
F3BE: 85 F5    sta dummy_write_00f5
F3C0: EA       nop
F3C1: C9 24    cmp #$24
F3C3: 90 05    bcc $f3ca
F3C5: A9 23    lda #$23
F3C7: 85 F5    sta dummy_write_00f5
F3C9: EA       nop
F3CA: 85 EE    sta $ee
F3CC: 4D 15 8D eor $8d15
F3CF: 03 40    slo ($40, x)
F3D1: 85 F5    sta dummy_write_00f5
F3D3: EA       nop
F3D4: 60       rts
F3D5: 00       brk
F3D6: 01 FF    ora ($ff, x)
F3D8: 00       brk
F3D9: F6 00    inc $00, x
F3DB: 00       brk
F3DC: 00       brk
F3DD: 0A       asl a
F3DE: 00       brk
F3DF: 00       brk
F3E0: 00       brk
F3E1: 00       brk
F3E2: 00       brk
F3E3: 00       brk
F3E4: 00       brk
F3E5: 00       brk
F3E6: 00       brk
F3E7: 85 F5    sta dummy_write_00f5
F3E9: EA       nop
F3EA: A5 E2    lda $e2
F3EC: 29 E0    and #$e0
F3EE: D0 32    bne $f422
F3F0: A2 78    ldx #$78
F3F2: A5 EE    lda $ee
F3F4: C9 1E    cmp #$1e
F3F6: B0 11    bcs $f409
F3F8: A2 60    ldx #$60
F3FA: C9 14    cmp #$14
F3FC: B0 0B    bcs $f409
F3FE: A2 48    ldx #$48
F400: C9 0A    cmp #$0a
F402: B0 05    bcs $f409
F404: A2 30    ldx #$30
F406: 85 F5    sta dummy_write_00f5
F408: EA       nop
F409: 8E 03 18 stx $1803
F40C: A5 EE    lda $ee
F40E: 38       sec
F40F: 85 F5    sta dummy_write_00f5
F411: EA       nop
F412: E9 0A    sbc #$0a
F414: B0 FC    bcs $f412
F416: 69 0A    adc #$0a
F418: AA       tax
F419: BD 23 F4 lda $f423, x
F41C: 8D 02 18 sta $1802
F41F: 85 F5    sta dummy_write_00f5
F421: EA       nop
F422: 60       rts
F423: B4 A4    ldy $a4, x
F425: 94 84    sty $84, x
F427: 74 64    nop $64, x
F429: 54 44    nop $44, x
F42B: 34 24    nop $24, x
F42D: 85 F5    sta dummy_write_00f5
F42F: EA       nop
F430: A5 E1    lda $e1
F432: D0 4F    bne $f483
F434: A5 E2    lda $e2
F436: 29 E0    and #$e0
F438: D0 49    bne $f483
F43A: A6 CB    ldx $cb
F43C: AD 03 40 lda $4003
F43F: 29 40    and #$40
F441: D0 05    bne $f448
F443: A2 00    ldx #$00
F445: 85 F5    sta dummy_write_00f5
F447: EA       nop
F448: BD 00 40 lda $4000, x
F44B: 49 FF    eor #$ff
F44D: 29 10    and #$10
F44F: F0 32    beq $f483
F451: A5 E2    lda $e2
F453: 29 03    and #$03
F455: C9 03    cmp #$03
F457: F0 06    beq $f45f
F459: A9 11    lda #$11
F45B: 8D 03 40 sta $4003
F45E: EA       nop
F45F: A5 EE    lda $ee
F461: C9 1E    cmp #$1e
F463: 90 22    bcc $f487
F465: 38       sec
F466: E9 1E    sbc #$1e
F468: 0A       asl a
F469: AA       tax
F46A: BD EB F4 lda $f4eb, x
F46D: 85 D8    sta $d8
F46F: BD EC F4 lda $f4ec, x
F472: 85 D9    sta $d9
F474: A9 3F    lda #$3f
F476: 85 E1    sta $e1
F478: A9 17    lda #$17
F47A: 8D 03 40 sta $4003
F47D: 6C D8 00 jmp ($00d8)
F480: 85 F5    sta dummy_write_00f5
F482: EA       nop
F483: 60       rts
F484: 85 F5    sta dummy_write_00f5
F486: EA       nop
F487: A5 E3    lda $e3
F489: 29 20    and #$20
F48B: D0 F6    bne $f483
F48D: A9 60    lda #$60
F48F: 85 D9    sta $d9
F491: A6 EE    ldx $ee
F493: E0 1A    cpx #$1a
F495: 90 15    bcc $f4ac
F497: E0 1E    cpx #$1e
F499: B0 11    bcs $f4ac
F49B: 8A       txa
F49C: E9 18    sbc #$18
F49E: AA       tax
F49F: A9 50    lda #$50
F4A1: 85 D8    sta $d8
F4A3: A9 66    lda #$66
F4A5: 85 D9    sta $d9
F4A7: D0 0A    bne $f4b3
F4A9: 85 F5    sta dummy_write_00f5
F4AB: EA       nop
F4AC: A9 50    lda #$50
F4AE: 85 D8    sta $d8
F4B0: 85 F5    sta dummy_write_00f5
F4B2: EA       nop
F4B3: A5 D8    lda $d8
F4B5: 18       clc
F4B6: 69 08    adc #$08
F4B8: 85 D8    sta $d8
F4BA: A5 D9    lda $d9
F4BC: 69 00    adc #$00
F4BE: 85 D9    sta $d9
F4C0: CA       dex
F4C1: 10 F0    bpl $f4b3
F4C3: 85 F5    sta dummy_write_00f5
F4C5: EA       nop
F4C6: A9 E0    lda #$e0
F4C8: 85 DA    sta $da
F4CA: A9 62    lda #$62
F4CC: 85 DB    sta $db
F4CE: 20 4B F5 jsr $f54b
F4D1: 20 35 F5 jsr $f535
F4D4: A9 01    lda #$01
F4D6: 8D 04 18 sta $1804
F4D9: 20 71 F5 jsr $f571
F4DC: A9 00    lda #$00
F4DE: A8       tay
F4DF: 91 D8    sta ($d8), y
F4E1: A5 E2    lda $e2
F4E3: 09 40    ora #$40
F4E5: 85 E2    sta $e2
F4E7: 85 F5    sta dummy_write_00f5
F4E9: EA       nop
F4EA: 60       rts
F4EB: FA       nop
F4EC: F4 FA    nop $fa, x
F4EE: F4 16    nop $16, x
F4F0: F5 16    sbc $16, x
F4F2: F5 0C    sbc $0c, x
F4F4: F5 0C    sbc $0c, x
F4F6: F5 85    sbc $85, x
F4F8: F5 EA    sbc $ea, x
F4FA: A5 E3    lda $e3
F4FC: 29 20    and #$20
F4FE: D0 EA    bne $f4ea
F500: A9 F5    lda #dummy_write_00f5
F502: 85 EE    sta $ee
F504: CA       dex
F505: ED 4C 09 sbc $094c
F508: F6 85    inc $85, x
F50A: F5 EA    sbc $ea, x
F50C: A5 E2    lda $e2
F50E: 09 80    ora #$80
F510: 85 E2    sta $e2
F512: 60       rts
F513: 85 F5    sta dummy_write_00f5
F515: 6E A5 E2 ror $e2a5
F518: 29 0F    and #$0f
F51A: F0 16    beq $f532
F51C: C6 E2    dec $e2
F51E: 4D F5 85 eor $85f5
F521: EE A6 ED inc $eda6
F524: 20 08 F6 jsr $f608
F527: A5 E3    lda $e3
F529: 09 40    ora #$40
F52B: 29 DF    and #$df
F52D: 85 E3    sta $e3
F52F: C1 F5    cmp (dummy_write_00f5, x)
F531: EA       nop
F532: 60       rts
F533: 85 F5    sta dummy_write_00f5
F535: 6E AD 02 ror $02ad
F538: 18       clc
F539: 38       sec
F53A: E9 04    sbc #$04
F53C: 8D 06 18 sta $1806
F53F: CD 03 18 cmp $1803
F542: 38       sec
F543: E9 08    sbc #$08
F545: 8D 07 18 sta $1807
F548: 60       rts
F549: 85 F5    sta dummy_write_00f5
F54B: EA       nop
F54C: A2 02    ldx #$02
F54E: 85 F5    sta dummy_write_00f5
F550: EA       nop
F551: A0 07    ldy #$07
F553: 85 F5    sta dummy_write_00f5
F555: 6E B1 D8 ror $d8b1
F558: 91 DA    sta ($da), y
F55A: 88       dey
F55B: 10 F9    bpl $f556
F55D: A5 D9    lda $d9
F55F: 18       clc
F560: 69 20    adc #$20
F562: 85 D9    sta $d9
F564: C9 DB    cmp #$db
F566: 18       clc
F567: 69 20    adc #$20
F569: 85 DB    sta $db
F56B: CA       dex
F56C: 10 E3    bpl $f551
F56E: 60       rts
F56F: 85 F5    sta dummy_write_00f5
F571: EA       nop
F572: AD 07 18 lda $1807
F575: 85 D9    sta $d9
F577: CD 06 18 cmp $1806
F57A: 49 FF    eor #$ff
F57C: 85 D8    sta $d8
F57E: A2 D9    ldx #$d9
F580: 46 D9    lsr $d9
F582: 46 D9    lsr $d9
F584: A2 D9    ldx #$d9
F586: AA       tax
F587: D8       cld
F588: 46 D9    lsr $d9
F58A: 66 D8    ror $d8
F58C: A2 D9    ldx #$d9
F58E: AA       tax
F58F: D8       cld
F590: A5 D9    lda $d9
F592: 18       clc
F593: 69 10    adc #$10
F595: 85 D9    sta $d9
F597: E2 D8    nop #$d8
F599: 60       rts
F59A: 85 F5    sta dummy_write_00f5
F59C: 6E A5 E2 ror $e2a5
F59F: 29 E0    and #$e0
F5A1: C9 40    cmp #$40
F5A3: F0 04    beq $f5a9
F5A5: 60       rts
F5A6: 85 F5    sta dummy_write_00f5
F5A8: EA       nop
F5A9: A9 9B    lda #$9b
F5AB: 85 D8    sta $d8
F5AD: C9 E2    cmp #$e2
F5AF: 29 0F    and #$0f
F5B1: F0 11    beq $f5c4
F5B3: AA       tax
F5B4: 85 F5    sta dummy_write_00f5
F5B6: 6E A5 D8 ror $d8a5
F5B9: 38       sec
F5BA: E9 08    sbc #$08
F5BC: 85 D8    sta $d8
F5BE: 66 D0    ror $d0
F5C0: F6 85    inc $85, x
F5C2: F5 EA    sbc $ea, x
F5C4: A6 ED    ldx $ed
F5C6: BD 00 F6 lda $f600, x
F5C9: 85 D9    sta $d9
F5CB: A5 D8    lda $d8
F5CD: CD 02 18 cmp $1802
F5D0: F0 10    beq $f5e2
F5D2: 90 08    bcc $f5dc
F5D4: EE 02 18 inc $1802
F5D7: 70 09    bvs $f5e2
F5D9: 85 F5    sta dummy_write_00f5
F5DB: EA       nop
F5DC: CE 02 18 dec $1802
F5DF: C1 F5    cmp (dummy_write_00f5, x)
F5E1: EA       nop
F5E2: A5 D9    lda $d9
F5E4: CD 03 18 cmp $1803
F5E7: F0 0D    beq $f5f6
F5E9: EE 03 18 inc $1803
F5EC: C1 F5    cmp (dummy_write_00f5, x)
F5EE: 6E 20 35 ror $3520
F5F1: F5 60    sbc $60, x
F5F3: 85 F5    sta dummy_write_00f5
F5F5: 6E A5 D8 ror $d8a5
F5F8: CD 02 18 cmp $1802
F5FB: F0 0C    beq $f609
F5FD: 4C EF F5 jmp $f5ef
F600: 00       brk
F601: A8       tay
F602: B8       clv
F603: C8       iny
F604: D8       cld
F605: E8       inx
F606: 85 F5    sta dummy_write_00f5
F608: EA       nop
F609: A5 E2    lda $e2
F60B: 09 20    ora #$20
F60D: 29 BF    and #$bf
F60F: 85 E2    sta $e2
F611: BD 84 F0 lda $f084, x
F614: 18       clc
F615: 69 36    adc #$36
F617: 85 D8    sta $d8
F619: A9 00    lda #$00
F61B: 85 D9    sta $d9
F61D: A5 E2    lda $e2
F61F: 29 0F    and #$0f
F621: A8       tay
F622: A5 EE    lda $ee
F624: C9 1A    cmp #$1a
F626: 90 0B    bcc $f633
F628: C9 1E    cmp #$1e
F62A: B0 07    bcs $f633
F62C: 69 B2    adc #$b2
F62E: 30 09    bmi $f639
F630: 85 F5    sta dummy_write_00f5
F632: EA       nop
F633: 18       clc
F634: 69 0B    adc #$0b
F636: 85 F5    sta dummy_write_00f5
F638: EA       nop
F639: 91 D8    sta ($d8), y
F63B: 60       rts
F63C: 85 F5    sta dummy_write_00f5
F63E: EA       nop
F63F: A5 E2    lda $e2
F641: 10 18    bpl $f65b
F643: A9 D0    lda #$d0
F645: 8D 02 18 sta $1802
F648: A6 ED    ldx $ed
F64A: BD 00 F6 lda $f600, x
F64D: 38       sec
F64E: E9 0C    sbc #$0c
F650: 8D 03 18 sta $1803
F653: A9 00    lda #$00
F655: 8D 04 18 sta $1804
F658: 85 F5    sta dummy_write_00f5
F65A: EA       nop
F65B: 60       rts


