;
; Burger Time 1982 Data East
;
; Decrypted & reverse-engineered by JOTD 2025
; 
; Note that some function names & comments are directly copied from
; the small leaked source part present at the end of the ROM
;
; Too bad the whole source hasn't leaked, but we managed :) Sometimes
; my RE work gives better clarity than the original source!
;
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

C000: 4C 3C CF jmp credit_inserted_interrupt_cf3c
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
C024: 20 32 C3 jsr clear_ram_init_zp_and_palette_c332
C027: 20 1D C3 jsr $c31d
C02A: A9 01    lda #$01
C02C: 85 01    sta $01
C02E: A9 00    lda #$00
C030: 85 1A    sta $1a
C032: 20 0D C7 jsr $c70d
C035: 85 F7    sta dummy_write_00f7
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
C04F: 20 2C CA jsr wait_a_while_ca2c
C052: 20 D9 C3 jsr $c3d9
C055: A2 FF    ldx #$ff
C057: 20 2C CA jsr wait_a_while_ca2c
C05A: 20 78 C4 jsr $c478
C05D: A2 3F    ldx #$3f
C05F: 20 2C CA jsr wait_a_while_ca2c
C062: 20 61 C5 jsr $c561
C065: 85 F5    sta dummy_write_00f5
C067: EA       nop 
C068: 20 0D C7 jsr $c70d
C06B: 20 48 C7 jsr gaminl_c748
C06E: A9 01    lda #$01
C070: 85 1C    sta $1c
C072: 85 F5    sta dummy_write_00f5
C074: EA       nop 
game_restart_c075:
C075: 20 67 C7 jsr roundinl_c767
C078: 85 F5    sta dummy_write_00f5
C07A: EA       nop 
wait_for_sync_c07b:
C07B: AD 03 40 lda $4003
C07E: 10 FB    bpl wait_for_sync_c07b
C080: 58       cli 
C081: EA       nop 
C082: EA       nop 
C083: EA       nop 
C084: EA       nop 
C085: 78       sei 
C086: 20 45 D0 jsr check_if_coin_inserted_d045
C089: 20 6E D0 jsr game_start_management_d06e
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
wait_for_no_sync_c0ad:
C0AD: AD 03 40 lda $4003
C0B0: 30 FB    bmi wait_for_no_sync_c0ad
C0B2: 20 E6 C8 jsr unknown_c8e6
C0B5: 20 7B D1 jsr handle_pepper_launch_d17b
C0B8: 20 96 D7 jsr handle_pepper_update_d796
C0BB: 20 98 D8 jsr handle_make_parts_fall_d898
C0BE: A5 1B    lda $1b
C0C0: F0 0C    beq $c0ce
C0C2: 20 28 DB jsr $db28
C0C5: 20 BB DB jsr $dbbb
C0C8: 20 77 DC jsr $dc77
C0CB: 85 F5    sta dummy_write_00f5
C0CD: EA       nop 
C0CE: 20 65 DD jsr teki_display_dd65
C0D1: 20 8D EA jsr $ea8d
C0D4: 20 DF E6 jsr pptkpt_e6df
C0D7: 20 41 E1 jsr handle_bonus_pickup_e141
C0DA: 20 90 E1 jsr lakmov_e190
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
C0F6: 20 BC C9 jsr display_text_block_c9bc
C0F9: 4C 19 C1 jmp $c119

C10B: C9 0F    cmp #$0f
C10D: D0 0A    bne $c119
C10F: A2 02    ldx #$02
C111: A0 C1    ldy #$c1
C113: 20 BC C9 jsr display_text_block_c9bc
C116: 85 F6    sta dummy_write_00f6
C118: EA       nop 
C119: A5 C6    lda $c6
C11B: D0 0D    bne end_game_mainloop_c12a
C11D: A5 C5    lda $c5
C11F: F0 03    beq $c124
C121: 4C 75 C0 jmp game_restart_c075
C124: 4C 7B C0 jmp wait_for_sync_c07b
C127: 85 F7    sta dummy_write_00f7
C129: EA       nop 
end_game_mainloop_c12a:
C12A: A9 00    lda #$00
C12C: 85 C6    sta $c6  ; dummy_write_decrypt_trigger
C12E: A5 1B    lda $1b  ; prev_crypted c9
C130: D0 0B    bne $c13d
C132: A2 3F    ldx #$3f
C134: 20 2C CA jsr wait_a_while_ca2c
C137: 4C 38 C0 jmp $c038
C13A: 85 F7    sta dummy_write_00f7  ; dummy_write_decrypt_trigger
C13C: EA       nop   ; prev_crypted 6e
C13D: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
C140: 20 E3 CB jsr $cbe3
C143: A5 21    lda $21
C145: D0 17    bne $c15e
C147: A5 29    lda player_lives_0029
C149: 30 0D    bmi $c158
C14B: A9 01    lda #$01
C14D: 85 20    sta $20  ; dummy_write_decrypt_trigger
C14F: 20 52 C2 jsr display_game_ready_c252  ; prev_crypted 08
C152: 4C 75 C0 jmp game_restart_c075
C155: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
C157: EA       nop   ; prev_crypted 6e
C158: 4C F1 C1 jmp game_over_c1f1
C15B: 85 F7    sta dummy_write_00f7  ; dummy_write_decrypt_trigger
C15D: EA       nop   ; prev_crypted 6e
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
C173: 4C 75 C0 jmp game_restart_c075
C176: 85 F7    sta dummy_write_00f7
C178: EA       nop 
C179: A5 29    lda player_lives_0029
C17B: 10 09    bpl $c186
C17D: 20 95 C2 jsr $c295
C180: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
C183: 85 F7    sta dummy_write_00f7  ; dummy_write_decrypt_trigger
C185: EA       nop   ; prev_crypted 6e
C186: 20 03 C3 jsr $c303
C189: A9 01    lda #$01
C18B: 85 1F    sta current_player_001f  ; dummy_write_decrypt_trigger
C18D: 85 20    sta $20  ; prev_crypted c1  ; dummy_write_decrypt_trigger
C18F: AD 03 40 lda $4003  ; prev_crypted cd
C192: 29 40    and #$40
C194: F0 0D    beq $c1a3
C196: A9 00    lda #$00
C198: 8D 05 50 sta $5005
C19B: A9 01    lda #$01
C19D: 8D 02 40 sta $4002
C1A0: 85 F7    sta dummy_write_00f7
C1A2: EA       nop 
C1A3: 20 81 C2 jsr $c281
C1A6: 4C 75 C0 jmp game_restart_c075
C1A9: 4C F1 C1 jmp game_over_c1f1
C1AC: 85 F7    sta dummy_write_00f7  ; dummy_write_decrypt_trigger
C1AE: EA       nop   ; prev_crypted 6e
C1AF: A5 2A    lda $2a
C1B1: 25 29    and player_lives_0029
C1B3: 30 3C    bmi game_over_c1f1
C1B5: A5 29    lda player_lives_0029
C1B7: 10 0D    bpl $c1c6
C1B9: A9 01    lda #$01
C1BB: 85 20    sta $20  ; dummy_write_decrypt_trigger
C1BD: 20 81 C2 jsr $c281  ; prev_crypted 08
C1C0: 4C 75 C0 jmp game_restart_c075
C1C3: 85 F7    sta dummy_write_00f7  ; dummy_write_decrypt_trigger
C1C5: EA       nop   ; prev_crypted 6e
C1C6: A5 2A    lda $2a
C1C8: 10 09    bpl $c1d3
C1CA: 20 AD C2 jsr $c2ad
C1CD: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
C1D0: 85 F7    sta dummy_write_00f7
C1D2: EA       nop 
C1D3: 20 03 C3 jsr $c303
C1D6: A9 00    lda #$00
C1D8: 85 1F    sta current_player_001f
C1DA: A9 01    lda #$01
C1DC: 85 20    sta $20  ; dummy_write_decrypt_trigger
C1DE: A9 FE    lda #$fe  ; prev_crypted 4d
C1E0: 8D 05 50 sta $5005
C1E3: A9 00    lda #$00
C1E5: 8D 02 40 sta $4002
C1E8: 20 6D C2 jsr $c26d
C1EB: 4C 75 C0 jmp game_restart_c075
C1EE: 85 F7    sta dummy_write_00f7
C1F0: EA       nop 
game_over_c1f1:
C1F1: 20 C5 C2 jsr $c2c5
C1F4: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
C1F7: A9 FE    lda #$fe
C1F9: 8D 05 50 sta $5005  ; dummy_write_decrypt_trigger
C1FC: A9 00    lda #$00  ; prev_crypted 4d
C1FE: 8D 02 40 sta $4002
C201: A9 00    lda #$00
C203: 85 CB    sta $cb
C205: A5 2D    lda $2d
C207: 85 CC    sta $cc
C209: A5 2E    lda $2e
C20B: 85 CD    sta $cd
C20D: A5 2F    lda player_pepper_002b
C20F: 85 CE    sta $ce
C211: 20 F3 EF jsr $eff3
C214: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
C217: AD 03 40 lda $4003
C21A: 29 40    and #$40
C21C: F0 0D    beq $c22b
C21E: A9 00    lda #$00
C220: 8D 05 50 sta $5005
C223: A9 01    lda #$01
C225: 8D 02 40 sta $4002
C228: 85 F7    sta dummy_write_00f7
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
C242: A5 1D    lda nb_credits_001d
C244: 05 1E    ora $1e
C246: F0 05    beq $c24d
C248: E6 1A    inc $1a
C24A: 85 F7    sta dummy_write_00f7
C24C: EA       nop 
C24D: 4C 38 C0 jmp $c038
C250: 85 F7    sta dummy_write_00f7
display_game_ready_c252:
C252: EA       nop 
C253: A2 E8    ldx #$e8
C255: A0 C2    ldy #$c2
C257: 20 BC C9 jsr display_text_block_c9bc
C25A: 85 F5    sta dummy_write_00f5
C25C: EA       nop 
C25D: A9 03    lda #$03
C25F: 20 5D EA jsr $ea5d
C262: 85 F5    sta dummy_write_00f5
C264: EA       nop 
C265: A2 1F    ldx #$1f
C267: 20 2C CA jsr wait_a_while_ca2c
C26A: 60       rts 
C26B: 85 F7    sta dummy_write_00f7
C26D: EA       nop 
C26E: A2 D2    ldx #$d2
C270: A0 C2    ldy #$c2
C272: 20 BC C9 jsr display_text_block_c9bc
C275: A2 E8    ldx #$e8
C277: A0 C2    ldy #$c2
C279: 20 BC C9 jsr display_text_block_c9bc
C27C: 4C 5D C2 jmp $c25d
C27F: 85 F7    sta dummy_write_00f7
C281: EA       nop 
C282: A2 DD    ldx #$dd
C284: A0 C2    ldy #$c2
C286: 20 BC C9 jsr display_text_block_c9bc
C289: A2 E8    ldx #$e8
C28B: A0 C2    ldy #$c2
C28D: 20 BC C9 jsr display_text_block_c9bc
C290: 4C 5D C2 jmp $c25d
C293: 85 F7    sta dummy_write_00f7
C295: EA       nop 
C296: E6 C8    inc $c8
C298: A2 D2    ldx #$d2
C29A: A0 C2    ldy #$c2
C29C: 20 BC C9 jsr display_text_block_c9bc
C29F: E6 C8    inc $c8
C2A1: A2 F5    ldx #$f5
C2A3: A0 C2    ldy #$c2
C2A5: 20 BC C9 jsr display_text_block_c9bc
C2A8: 4C 65 C2 jmp $c265
C2AB: 85 F7    sta dummy_write_00f7
C2AD: EA       nop 
C2AE: E6 C8    inc $c8
C2B0: A2 DD    ldx #$dd
C2B2: A0 C2    ldy #$c2
C2B4: 20 BC C9 jsr display_text_block_c9bc
C2B7: E6 C8    inc $c8
C2B9: A2 F5    ldx #$f5
C2BB: A0 C2    ldy #$c2
C2BD: 20 BC C9 jsr display_text_block_c9bc
C2C0: 4C 65 C2 jmp $c265
C2C3: 85 F7    sta dummy_write_00f7
C2C5: EA       nop 
C2C6: E6 C8    inc $c8
C2C8: A2 F5    ldx #$f5
C2CA: A0 C2    ldy #$c2
C2CC: 20 BC C9 jsr display_text_block_c9bc
C2CF: 4C 65 C2 jmp $c265


C303: EA       nop 
C304: A0 00    ldy #$00
C306: 85 F7    sta dummy_write_00f7
C308: EA       nop 
C309: B9 00 02 lda $0200, y
C30C: AA       tax 
C30D: B9 00 03 lda $0300, y
C310: 99 00 02 sta $0200, y
C313: 8A       txa 
C314: 99 00 03 sta $0300, y  ; dummy_write_decrypt_trigger
C317: C8       iny   ; prev_crypted 64
C318: D0 EF    bne $c309
C31A: 60       rts 
C31B: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
C31D: EA       nop   ; prev_crypted 6e
C31E: A9 00    lda #$00
C320: 8D 05 50 sta $5005
C323: 85 25    sta $25  ; dummy_write_decrypt_trigger
C325: 8D 03 40 sta $4003  ; prev_crypted c5
C328: A9 80    lda #$80
C32A: 85 27    sta $27  ; dummy_write_decrypt_trigger
C32C: 8D 00 40 sta $4000  ; prev_crypted c5  ; dummy_write_decrypt_trigger
C32F: 60       rts   ; prev_crypted 28
C330: 85 F6    sta dummy_write_00f6
clear_ram_init_zp_and_palette_c332:
C332: EA       nop 
C333: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
C335: EA       nop   ; prev_crypted 6e
C336: A9 00    lda #$00
C338: 85 03    sta $03
C33A: A9 10    lda #$10
C33C: 85 04    sta $04  ; dummy_write_decrypt_trigger
C33E: A2 10    ldx #$10  ; prev_crypted 4a
C340: 85 F6    sta dummy_write_00f6
C342: EA       nop 
C343: A0 00    ldy #$00
C345: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
C347: EA       nop   ; prev_crypted 6e
clear_video_c348:
C348: A9 00    lda #$00
C34A: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
C34C: C8       iny   ; prev_crypted 64
C34D: D0 F9    bne clear_video_c348
C34F: E6 04    inc $04
C351: CA       dex 
C352: D0 EF    bne $c343
C354: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
C356: EA       nop   ; prev_crypted 6e
clear_zero_page_c357:
C357: 95 01    sta $01, x
C359: E8       inx 
C35A: E0 E1    cpx #$e1
C35C: D0 F9    bne clear_zero_page_c357
C35E: A2 00    ldx #$00
C360: 85 F6    sta dummy_write_00f6
C362: EA       nop 
clear_0200_03ff_c363:
C363: 9D 00 02 sta $0200, x  ; dummy_write_decrypt_trigger
C366: 9D 00 03 sta $0300, x  ; prev_crypted d5
C369: E8       inx 
C36A: D0 F7    bne clear_0200_03ff_c363
C36C: A9 02    lda #$02
C36E: 85 35    sta $35
C370: A9 80    lda #$80
C372: 85 34    sta $34  ; dummy_write_decrypt_trigger
C374: A9 00    lda #$00  ; prev_crypted 4d
C376: 85 33    sta $33
C378: A2 23    ldx #$23
C37A: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
C37C: EA       nop   ; prev_crypted 6e
C37D: BD B3 C3 lda $c3b3, x
C380: 95 36    sta $36, x
C382: CA       dex 
C383: 10 F8    bpl $c37d
C385: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
C387: EA       nop   ; prev_crypted 6e
C388: A0 00    ldy #$00
C38A: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
C38C: EA       nop   ; prev_crypted 6e
C38D: A2 00    ldx #$00
C38F: 85 F6    sta dummy_write_00f6
C391: EA       nop 
set_palette_c392:
C392: BD A3 C3 lda $c3a3, x
C395: 99 00 0C sta $0c00, y
C398: C8       iny 
C399: E8       inx 
C39A: E0 10    cpx #$10
C39C: D0 F4    bne set_palette_c392
C39E: C0 20    cpy #$20
C3A0: D0 EB    bne $c38d
C3A2: 60       rts 

C3D9: EA       nop 
C3DA: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
C3DD: 20 E3 CB jsr $cbe3
C3E0: A2 0F    ldx #$0f
C3E2: A0 CE    ldy #$ce
C3E4: 20 BC C9 jsr display_text_block_c9bc
C3E7: A2 29    ldx #$29
C3E9: A0 CE    ldy #$ce
C3EB: 20 BC C9 jsr display_text_block_c9bc
C3EE: A2 BE    ldx #$be
C3F0: A0 CE    ldy #$ce
C3F2: 20 BC C9 jsr display_text_block_c9bc
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
C417: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
C41A: 20 E3 CB jsr $cbe3
C41D: A2 0F    ldx #$0f
C41F: A0 CE    ldy #$ce
C421: 20 BC C9 jsr display_text_block_c9bc
C424: A2 EF    ldx #$ef
C426: A0 CE    ldy #$ce
C428: 20 BC C9 jsr display_text_block_c9bc
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
C484: 20 48 C7 jsr gaminl_c748
C487: 20 67 C7 jsr roundinl_c767
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
C4C4: 8D 1E 18 sta player_y_181e
C4C7: A9 1D    lda #$1d
C4C9: 8D 1F 18 sta player_x_181f
C4CC: 20 65 DD jsr teki_display_dd65
C4CF: 85 F5    sta dummy_write_00f5
C4D1: EA       nop 
C4D2: A2 01    ldx #$01
C4D4: 20 2C CA jsr wait_a_while_ca2c
C4D7: E6 13    inc timer1_0013
C4D9: A2 07    ldx #$07
C4DB: 20 C3 D3 jsr $d3c3
C4DE: F0 04    beq $c4e4
C4E0: 60       rts 
C4E1: 85 F5    sta dummy_write_00f5
C4E3: EA       nop 
C4E4: A2 07    ldx #$07
C4E6: 20 69 D2 jsr update_character_d269
C4E9: 20 98 D8 jsr handle_make_parts_fall_d898
C4EC: 20 8D EA jsr $ea8d
C4EF: 20 90 E1 jsr lakmov_e190
C4F2: A5 19    lda $19
C4F4: D0 06    bne $c4fc
C4F6: 4C D2 C4 jmp $c4d2
C4F9: 85 F5    sta dummy_write_00f5
C4FB: EA       nop 
C4FC: A2 0F    ldx #$0f
C4FE: A0 C5    ldy #$c5
C500: 20 BC C9 jsr display_text_block_c9bc
C503: A2 FF    ldx #$ff
C505: 20 2C CA jsr wait_a_while_ca2c
C508: A9 00    lda #$00
C50A: 85 19    sta $19  ; dummy_write_decrypt_trigger
C50C: 4C 80 C4 jmp $c480  ; prev_crypted a4

C561: EA       nop 
C562: 20 48 C7 jsr gaminl_c748
C565: 20 67 C7 jsr roundinl_c767
C568: A0 01    ldy #$01
C56A: 84 68    sty $68  ; dummy_write_decrypt_trigger
C56C: 84 69    sty $69  ; prev_crypted c0  ; dummy_write_decrypt_trigger
C56E: C8       iny   ; prev_crypted 64
C56F: 84 6A    sty $6a
C571: 84 6B    sty $6b
C573: C8       iny 
C574: 84 6C    sty $6c  ; dummy_write_decrypt_trigger
C576: 84 6D    sty $6d  ; prev_crypted c0
C578: A9 1D    lda #$1d
C57A: 8D 03 18 sta $1803  ; dummy_write_decrypt_trigger
C57D: 8D 07 18 sta $1807  ; prev_crypted c5
C580: 8D 0B 18 sta $180b
C583: 8D 0F 18 sta $180f  ; dummy_write_decrypt_trigger
C586: 8D 13 18 sta $1813  ; prev_crypted c5
C589: 8D 17 18 sta $1817  ; dummy_write_decrypt_trigger
C58C: 8D 1F 18 sta player_x_181f  ; prev_crypted c5  ; dummy_write_decrypt_trigger
C58F: A9 40    lda #$40  ; prev_crypted 4d
C591: 85 A9    sta $a9
C593: 85 AA    sta $aa  ; dummy_write_decrypt_trigger
C595: 85 AB    sta $ab  ; prev_crypted c1  ; dummy_write_decrypt_trigger
C597: 85 AC    sta $ac  ; prev_crypted c1
C599: 85 AD    sta $ad
C59B: 85 AE    sta $ae  ; dummy_write_decrypt_trigger
C59D: A9 89    lda #$89  ; prev_crypted 4d
C59F: 8D 02 18 sta $1802
C5A2: A9 59    lda #$59
C5A4: 8D 06 18 sta $1806  ; dummy_write_decrypt_trigger
C5A7: A9 60    lda #$60  ; prev_crypted 4d
C5A9: 8D 0A 18 sta $180a  ; dummy_write_decrypt_trigger
C5AC: A9 90    lda #$90  ; prev_crypted 4d
C5AE: 8D 0E 18 sta $180e
C5B1: A9 97    lda #$97
C5B3: 8D 12 18 sta $1812  ; dummy_write_decrypt_trigger
C5B6: A9 30    lda #$30  ; prev_crypted 4d
C5B8: 8D 16 18 sta $1816
C5BB: A9 18    lda #$18
C5BD: 8D 1E 18 sta player_y_181e
C5C0: A9 01    lda #$01
C5C2: 85 13    sta timer1_0013  ; dummy_write_decrypt_trigger
C5C4: 85 14    sta timer1_0014  ; prev_crypted c1  ; dummy_write_decrypt_trigger
C5C6: 20 65 DD jsr teki_display_dd65  ; prev_crypted 08
C5C9: 85 F5    sta dummy_write_00f5
C5CB: EA       nop 
C5CC: A2 01    ldx #$01
C5CE: 20 2C CA jsr wait_a_while_ca2c
C5D1: E6 13    inc timer1_0013
C5D3: D0 03    bne $c5d8
C5D5: E6 14    inc timer1_0014  ; dummy_write_decrypt_trigger
C5D7: EA       nop   ; prev_crypted 6e
C5D8: A2 07    ldx #$07
C5DA: 20 C3 D3 jsr $d3c3
C5DD: F0 1B    beq $c5fa
C5DF: A5 14    lda timer1_0014
C5E1: C9 04    cmp #$04
C5E3: 90 3C    bcc $c621
C5E5: A2 30    ldx #$30
C5E7: A0 C6    ldy #$c6
C5E9: 20 BC C9 jsr display_text_block_c9bc
C5EC: A2 FF    ldx #$ff
C5EE: 20 2C CA jsr wait_a_while_ca2c
C5F1: A2 40    ldx #$40
C5F3: 20 2C CA jsr wait_a_while_ca2c
C5F6: 60       rts 
C5F7: 85 F5    sta dummy_write_00f5
C5F9: EA       nop 
C5FA: A5 6E    lda $6e
C5FC: 10 23    bpl $c621
C5FE: A2 07    ldx #$07
C600: 20 69 D2 jsr update_character_d269
C603: AD 1E 18 lda player_y_181e
C606: C9 22    cmp #$22
C608: F0 0B    beq $c615
C60A: C9 4A    cmp #$4a
C60C: F0 07    beq $c615
C60E: C9 82    cmp #$82
C610: D0 0F    bne $c621
C612: 85 F5    sta dummy_write_00f5
C614: EA       nop 
C615: 20 AD D1 jsr activate_pepper_d1ad
C618: EE 1E 18 inc player_y_181e
C61B: EE 1E 18 inc player_y_181e
C61E: 85 F5    sta dummy_write_00f5
C620: EA       nop 
C621: 20 96 D7 jsr handle_pepper_update_d796
C624: 20 98 D8 jsr handle_make_parts_fall_d898
C627: 20 DF E6 jsr pptkpt_e6df
C62A: 20 90 E1 jsr lakmov_e190
C62D: 4C CC C5 jmp $c5cc

C70D: EA       nop   ; prev_crypted 6e
C70E: AD 04 40 lda write_to_4004
C711: 49 FF    eor #$ff
C713: A8       tay 
C714: A2 02    ldx #$02
C716: 29 01    and #$01
C718: F0 05    beq $c71f
C71A: A2 04    ldx #$04
C71C: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
C71E: EA       nop   ; prev_crypted 6e
C71F: 86 29    stx player_lives_0029
C721: 86 2A    stx $2a
C723: 98       tya 
C724: 4A       lsr a
C725: 29 03    and #$03
C727: AA       tax 
C728: BD 3E C7 lda $c73e, x
C72B: 85 5A    sta $5a  ; dummy_write_decrypt_trigger
C72D: 85 5C    sta $5c  ; prev_crypted c1  ; dummy_write_decrypt_trigger
C72F: 85 5E    sta $5e  ; prev_crypted c1
C731: BD 42 C7 lda $c742, x
C734: 85 5B    sta $5b  ; dummy_write_decrypt_trigger
C736: 85 5D    sta $5d  ; prev_crypted c1
C738: 85 5F    sta $5f
C73A: 20 C3 EB jsr $ebc3
C73D: 60       rts 

gaminl_c748:
C748: EA       nop 
C749: A9 01    lda #$01
C74B: 85 61    sta $61  ; dummy_write_decrypt_trigger
C74D: 85 62    sta $62  ; prev_crypted c1  ; dummy_write_decrypt_trigger
C74F: A9 04    lda #$04  ; prev_crypted 4d
C751: 20 5D EA jsr $ea5d
C754: A9 00    lda #$00
C756: 85 65    sta $65
C758: 85 66    sta $66
C75A: 85 1F    sta current_player_001f  ; dummy_write_decrypt_trigger
C75C: 20 0F CC jsr $cc0f  ; prev_crypted 08
C75F: 20 03 C3 jsr $c303
C762: C6 61    dec $61  ; dummy_write_decrypt_trigger
C764: 60       rts   ; prev_crypted 28
C765: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
roundinl_c767:
C767: EA       nop   ; prev_crypted 6e
C768: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
C76B: A5 20    lda $20
C76D: D0 2C    bne $c79b
C76F: A9 04    lda #$04
C771: 20 5D EA jsr $ea5d
C774: AD 04 40 lda write_to_4004
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
C78A: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
C78C: EA       nop   ; prev_crypted 6e
C78D: A6 1F    ldx current_player_001f
C78F: F6 61    inc $61, x
C791: A9 00    lda #$00
C793: 95 65    sta $65, x  ; dummy_write_decrypt_trigger
C795: 20 0F CC jsr $cc0f  ; prev_crypted 08
C798: 85 F5    sta dummy_write_00f5
C79A: EA       nop 
C79B: A9 00    lda #$00
C79D: 85 20    sta $20  ; dummy_write_decrypt_trigger
C79F: 20 64 CC jsr $cc64  ; prev_crypted 08
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
C7C4: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
C7C6: EA       nop   ; prev_crypted 6e
C7C7: 84 64    sty $64
C7C9: A4 63    ldy $63
C7CB: B9 EF CD lda $cdef, y
C7CE: 8D 1C 18 sta player_attributes_181c
C7D1: B9 F7 CD lda $cdf7, y
C7D4: 8D 1D 18 sta player_code_181d  ; dummy_write_decrypt_trigger
C7D7: B9 FF CD lda $cdff, y  ; prev_crypted 5d
C7DA: 8D 1E 18 sta player_y_181e  ; dummy_write_decrypt_trigger
C7DD: B9 07 CE lda $ce07, y  ; prev_crypted 5d
C7E0: 8D 1F 18 sta player_x_181f
C7E3: A2 07    ldx #$07
C7E5: A9 FF    lda #$ff
C7E7: 85 F5    sta dummy_write_00f5
C7E9: EA       nop 
C7EA: 95 68    sta $68, x  ; dummy_write_decrypt_trigger
C7EC: CA       dex   ; prev_crypted 66
C7ED: 10 FB    bpl $c7ea
C7EF: A2 07    ldx #$07
C7F1: A9 01    lda #$01
C7F3: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
C7F5: EA       nop   ; prev_crypted 6e
C7F6: 95 99    sta $99, x
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
C813: 85 6F    sta $6f
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
C83E: 20 54 CA jsr display_player_lives_ca54
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
C890: 8D 1E 18 sta player_y_181e
C893: A9 1D    lda #$1d
C895: 8D 1F 18 sta player_x_181f
C898: A9 FF    lda #$ff
C89A: 85 A1    sta $a1
C89C: 85 A2    sta $a2
C89E: 85 A3    sta $a3
C8A0: 60       rts 
C8A1: 85 F6    sta dummy_write_00f6
clear_screen_and_sprites_c8a3:
C8A3: EA       nop 
C8A4: A0 00    ldy #$00
C8A6: 84 03    sty $03
C8A8: A9 10    lda #$10
C8AA: 85 04    sta $04
C8AC: 85 F6    sta dummy_write_00f6
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
C8C0: 20 2C CA jsr wait_a_while_ca2c
C8C3: 60       rts 
C8C4: 85 F5    sta dummy_write_00f5
C8C6: EA       nop 
C8C7: A2 35    ldx #$35
C8C9: A0 C9    ldy #$c9
C8CB: 20 BC C9 jsr display_text_block_c9bc
C8CE: A2 29    ldx #$29
C8D0: A0 C9    ldy #$c9
C8D2: 20 BC C9 jsr display_text_block_c9bc
C8D5: A5 21    lda $21
C8D7: F0 0A    beq $c8e3
C8D9: A2 40    ldx #$40
C8DB: A0 C9    ldy #$c9
C8DD: 20 BC C9 jsr display_text_block_c9bc
C8E0: 85 F5    sta dummy_write_00f5
C8E2: EA       nop 
C8E3: 60       rts 
C8E4: 85 F5    sta dummy_write_00f5
unknown_c8e6:
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
C8F9: 20 BC C9 jsr display_text_block_c9bc
C8FC: 60       rts 
C8FD: 85 F5    sta dummy_write_00f5
C8FF: EA       nop 
C900: A2 46    ldx #$46
C902: A0 C9    ldy #$c9
C904: 20 BC C9 jsr display_text_block_c9bc
C907: 60       rts 
C908: 85 F5    sta dummy_write_00f5
C90A: EA       nop 
C90B: C9 0F    cmp #$0f
C90D: D0 19    bne $c928
C90F: A5 1F    lda current_player_001f
C911: D0 0B    bne $c91e
C913: A2 29    ldx #$29
C915: A0 C9    ldy #$c9
C917: 20 BC C9 jsr display_text_block_c9bc
C91A: 60       rts 
C91B: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
C91D: EA       nop   ; prev_crypted 6e
C91E: A2 40    ldx #$40
C920: A0 C9    ldy #$c9
C922: 20 BC C9 jsr display_text_block_c9bc
C925: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
C927: EA       nop   ; prev_crypted 6e
C928: 60       rts 

C94E: EA       nop   ; prev_crypted 6e
C94F: 86 03    stx $03
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
C963: 85 04    sta $04  ; dummy_write_decrypt_trigger
C965: A0 05    ldy #$05  ; prev_crypted 48
C967: 85 F5    sta dummy_write_00f5
C969: EA       nop 
C96A: B5 2D    lda $2d, x
C96C: 29 0F    and #$0f
C96E: 85 05    sta $05
C970: E6 05    inc $05
C972: A5 05    lda $05
C974: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
C976: 88       dey   ; prev_crypted 44
C977: B5 2D    lda $2d, x
C979: 4A       lsr a
C97A: 4A       lsr a
C97B: 4A       lsr a
C97C: 4A       lsr a
C97D: 85 05    sta $05  ; dummy_write_decrypt_trigger
C97F: E6 05    inc $05  ; prev_crypted ea
C981: A5 05    lda $05
C983: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
C985: E8       inx   ; prev_crypted 6c
C986: 88       dey 
C987: 10 E1    bpl $c96a
C989: C8       iny 
C98A: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
C98C: EA       nop   ; prev_crypted 6e
C98D: B1 03    lda ($03), y
C98F: C9 01    cmp #$01
C991: D0 0C    bne $c99f
C993: A9 00    lda #$00
C995: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
C997: C8       iny   ; prev_crypted 64
C998: C0 05    cpy #$05
C99A: D0 F1    bne $c98d
C99C: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
C99E: EA       nop   ; prev_crypted 6e
C99F: 60       rts 

display_text_block_c9bc:
C9BC: EA       nop   ; prev_crypted 6e
C9BD: 86 03    stx $03  ; dummy_write_decrypt_trigger
C9BF: 84 04    sty $04  ; prev_crypted c0
C9C1: 85 F6    sta dummy_write_00f6
C9C3: EA       nop 
C9C4: A0 00    ldy #$00
C9C6: 84 08    sty $08
C9C8: B1 03    lda ($03), y
C9CA: 85 05    sta $05  ; dummy_write_decrypt_trigger
C9CC: C8       iny   ; prev_crypted 64
C9CD: B1 03    lda ($03), y
C9CF: 85 06    sta $06
C9D1: 85 F6    sta dummy_write_00f6
C9D3: EA       nop 
C9D4: C8       iny 
C9D5: B1 03    lda ($03), y
C9D7: C9 FF    cmp #$ff
C9D9: F0 4A    beq $ca25
C9DB: C9 FE    cmp #$fe
C9DD: F0 1D    beq $c9fc
C9DF: C9 FD    cmp #$fd
C9E1: F0 2C    beq $ca0f
C9E3: 84 07    sty $07  ; dummy_write_decrypt_trigger
C9E5: A4 08    ldy $08  ; prev_crypted c8
C9E7: 91 05    sta ($05), y
C9E9: E6 08    inc $08
C9EB: A4 07    ldy $07
C9ED: A5 C8    lda $c8
C9EF: F0 E3    beq $c9d4
C9F1: A2 0A    ldx #$0a
C9F3: 20 2C CA jsr wait_a_while_ca2c
C9F6: 4C D4 C9 jmp $c9d4
C9F9: 85 F6    sta dummy_write_00f6
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
CA0C: 85 F6    sta dummy_write_00f6
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
CA22: 85 F6    sta dummy_write_00f6
CA24: EA       nop 
CA25: A9 00    lda #$00
CA27: 85 C8    sta $c8
CA29: 60       rts 
CA2A: 85 F6    sta dummy_write_00f6
wait_a_while_ca2c:
CA2C: EA       nop 
wait_for_sync_ca2d:
CA2D: AD 03 40 lda $4003
CA30: 10 FB    bpl wait_for_sync_ca2d
CA32: 58       cli 
CA33: EA       nop 
CA34: EA       nop 
CA35: EA       nop 
CA36: EA       nop 
CA37: 78       sei 
CA38: 20 45 D0 jsr check_if_coin_inserted_d045
CA3B: A5 1A    lda $1a
CA3D: F0 0A    beq $ca49
CA3F: 8A       txa 
CA40: 48       pha 
CA41: 20 6E D0 jsr game_start_management_d06e
CA44: 68       pla 
CA45: AA       tax 
CA46: 85 F6    sta dummy_write_00f6
CA48: EA       nop 
CA49: AD 03 40 lda $4003
CA4C: 30 FB    bmi $ca49
CA4E: CA       dex 
CA4F: D0 DC    bne wait_for_sync_ca2d
CA51: 60       rts 
CA52: 85 F5    sta dummy_write_00f5
display_player_lives_ca54:
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
CA8E: 85 F7    sta dummy_write_00f7
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
CB04: C6 03    dec $03  ; dummy_write_decrypt_trigger
CB06: A9 C4    lda #$c4  ; prev_crypted 4d
CB08: 85 F5    sta dummy_write_00f5
CB0A: EA       nop 
CB0B: 91 04    sta ($04), y  ; dummy_write_decrypt_trigger
CB0D: 98       tya   ; prev_crypted 54
CB0E: 38       sec 
CB0F: E9 20    sbc #$20
CB11: A8       tay 
CB12: C6 06    dec $06  ; dummy_write_decrypt_trigger
CB14: 10 C6    bpl $cadc  ; prev_crypted 10
CB16: 85 F5    sta dummy_write_00f5
CB18: EA       nop 
CB19: 60       rts 
CB1A: 1D 13 85 ora $8513, x  ; dummy_write_decrypt_trigger
CB1E: EA       nop   ; prev_crypted 6e
CB1F: 20 E3 CB jsr $cbe3
CB22: A5 63    lda $63
CB24: 0A       asl a
CB25: A8       tay 
CB26: B9 D7 CD lda $cdd7, y
CB29: 85 03    sta $03
CB2B: B9 D8 CD lda $cdd8, y
CB2E: 85 04    sta $04
CB30: A9 10    lda #$10
CB32: 85 05    sta $05  ; dummy_write_decrypt_trigger
CB34: A9 04    lda #$04  ; prev_crypted 4d
CB36: 85 06    sta $06
CB38: A2 68    ldx #$68
CB3A: A0 00    ldy #$00
CB3C: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
CB3E: EA       nop   ; prev_crypted 6e
CB3F: B1 03    lda ($03), y
CB41: 29 F0    and #$f0
CB43: 11 05    ora ($05), y
CB45: 91 05    sta ($05), y  ; dummy_write_decrypt_trigger
CB47: E6 05    inc $05  ; prev_crypted ea
CB49: B1 03    lda ($03), y
CB4B: 0A       asl a
CB4C: 0A       asl a
CB4D: 0A       asl a
CB4E: 0A       asl a
CB4F: 11 05    ora ($05), y
CB51: 91 05    sta ($05), y
CB53: E6 05    inc $05  ; dummy_write_decrypt_trigger
CB55: E6 03    inc $03  ; prev_crypted ea  ; dummy_write_decrypt_trigger
CB57: D0 05    bne $cb5e  ; prev_crypted 70
CB59: E6 04    inc $04
CB5B: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
CB5D: EA       nop   ; prev_crypted 6e
CB5E: CA       dex 
CB5F: A5 05    lda $05
CB61: 29 07    and #$07
CB63: D0 DA    bne $cb3f
CB65: 18       clc 
CB66: A5 05    lda $05
CB68: 69 7F    adc #$7f
CB6A: 85 05    sta $05  ; dummy_write_decrypt_trigger
CB6C: A5 06    lda $06  ; prev_crypted c9
CB6E: 69 00    adc #$00
CB70: 85 06    sta $06
CB72: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
CB74: EA       nop   ; prev_crypted 6e
CB75: B1 03    lda ($03), y
CB77: 29 F0    and #$f0
CB79: 11 05    ora ($05), y
CB7B: 91 05    sta ($05), y  ; dummy_write_decrypt_trigger
CB7D: C6 05    dec $05  ; prev_crypted e2  ; dummy_write_decrypt_trigger
CB7F: B1 03    lda ($03), y  ; prev_crypted 59
CB81: 0A       asl a
CB82: 0A       asl a
CB83: 0A       asl a
CB84: 0A       asl a
CB85: 11 05    ora ($05), y
CB87: 91 05    sta ($05), y
CB89: C6 05    dec $05
CB8B: E6 03    inc $03  ; dummy_write_decrypt_trigger
CB8D: D0 05    bne $cb94  ; prev_crypted 70
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
CBA2: 85 05    sta $05  ; dummy_write_decrypt_trigger
CBA4: A5 06    lda $06  ; prev_crypted c9
CBA6: E9 00    sbc #$00
CBA8: 85 06    sta $06
CBAA: E0 00    cpx #$00
CBAC: D0 91    bne $cb3f
CBAE: A5 63    lda $63
CBB0: 29 0F    and #$0f
CBB2: 85 F3    sta $f3  ; dummy_write_decrypt_trigger
CBB4: 8A       txa   ; prev_crypted 46
CBB5: 48       pha   ; dummy_write_decrypt_trigger
CBB6: AD 03 40 lda $4003  ; prev_crypted cd
CBB9: 29 40    and #$40
CBBB: F0 07    beq $cbc4
CBBD: A5 1F    lda current_player_001f
CBBF: D0 13    bne $cbd4
CBC1: 85 F5    sta dummy_write_00f5
CBC3: EA       nop 
CBC4: A6 F3    ldx $f3
CBC6: BD D9 CB lda $cbd9, x
CBC9: 09 10    ora #$10
CBCB: 8D 04 40 sta write_to_4004  ; dummy_write_decrypt_trigger
CBCE: 68       pla   ; prev_crypted 2c
CBCF: AA       tax 
CBD0: 60       rts 
CBD1: 85 F5    sta dummy_write_00f5
CBD3: EA       nop 
CBD4: A5 F3    lda $f3
CBD6: 4C C9 CB jmp $cbc9

CBE3: EA       nop 
CBE4: A0 00    ldy #$00
CBE6: A9 04    lda #$04
CBE8: 85 04    sta $04
CBEA: A9 00    lda #$00
CBEC: 85 03    sta $03  ; dummy_write_decrypt_trigger
CBEE: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
CBF0: EA       nop 
CBF1: B1 03    lda ($03), y
CBF3: 29 0F    and #$0f
CBF5: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
CBF7: C8       iny   ; prev_crypted 64
CBF8: D0 F7    bne $cbf1
CBFA: E6 04    inc $04  ; dummy_write_decrypt_trigger
CBFC: A6 04    ldx $04  ; prev_crypted ca
CBFE: E0 08    cpx #$08
CC00: D0 EF    bne $cbf1
CC02: A9 00    lda #$00
CC04: 8D 04 40 sta write_to_4004
CC07: A2 01    ldx #$01
CC09: 20 2C CA jsr wait_a_while_ca2c
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
CC62: 85 F7    sta dummy_write_00f7
CC64: EA       nop 
CC65: A9 02    lda #$02
CC67: 85 0B    sta $0b
CC69: A9 02    lda #$02
CC6B: 85 0C    sta $0c
CC6D: A9 00    lda #$00
CC6F: 85 0D    sta $0d
CC71: 85 F7    sta dummy_write_00f7
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
CC93: 85 F7    sta dummy_write_00f7
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
CD00: F0 35    beq draw_tray_cd37
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

draw_tray_cd37:
CD37: 38       sec 
CD38: A5 05    lda $05
CD3A: E9 21    sbc #$21
CD3C: 85 05    sta $05  ; dummy_write_decrypt_trigger
CD3E: A5 06    lda $06  ; prev_crypted c9
CD40: E9 00    sbc #$00
CD42: 85 06    sta $06  ; dummy_write_decrypt_trigger
CD44: A0 00    ldy #$00  ; prev_crypted 48
CD46: A5 07    lda $07
CD48: 91 05    sta ($05), y
CD4A: AA       tax 
CD4B: E8       inx 
CD4C: E8       inx 
CD4D: 8A       txa 
CD4E: A0 05    ldy #$05
CD50: 91 05    sta ($05), y
CD52: E6 07    inc $07  ; dummy_write_decrypt_trigger
CD54: A5 07    lda $07  ; prev_crypted c9
CD56: A0 21    ldy #$21
CD58: 91 05    sta ($05), y
CD5A: C8       iny 
CD5B: 91 05    sta ($05), y  ; dummy_write_decrypt_trigger
CD5D: C8       iny   ; prev_crypted 64
CD5E: 91 05    sta ($05), y
CD60: C8       iny 
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
CD74: 91 05    sta ($05), y  ; dummy_write_decrypt_trigger
CD76: C8       iny   ; prev_crypted 64
CD77: 91 05    sta ($05), y
CD79: 38       sec 
CD7A: A5 06    lda $06
CD7C: E9 04    sbc #$04
CD7E: 85 06    sta $06
CD80: 18       clc 
CD81: A5 05    lda $05
CD83: 69 21    adc #$21
CD85: 85 05    sta $05  ; dummy_write_decrypt_trigger
CD87: A5 06    lda $06  ; prev_crypted c9
CD89: 69 00    adc #$00
CD8B: 85 06    sta $06  ; dummy_write_decrypt_trigger
CD8D: 85 F5    sta dummy_write_00f5  ; prev_crypted c1  ; dummy_write_decrypt_trigger
CD8F: EA       nop   ; prev_crypted 6e
CD90: 68       pla 
CD91: A8       tay 
CD92: 60       rts 
CD93: 85 F7    sta dummy_write_00f7  ; dummy_write_decrypt_trigger
CD95: EA       nop   ; prev_crypted 6e
CD96: 91 05    sta ($05), y
CD98: C8       iny 
CD99: E8       inx 
CD9A: 8A       txa 
CD9B: 91 05    sta ($05), y  ; dummy_write_decrypt_trigger
CD9D: C8       iny   ; prev_crypted 64
CD9E: E8       inx 
CD9F: 8A       txa 
CDA0: 91 05    sta ($05), y
CDA2: C8       iny 
CDA3: E8       inx 
CDA4: 8A       txa 
CDA5: 91 05    sta ($05), y  ; dummy_write_decrypt_trigger
CDA7: 60       rts   ; prev_crypted 28
CDA8: 85 F7    sta dummy_write_00f7
CDAA: EA       nop 
CDAB: 91 05    sta ($05), y  ; dummy_write_decrypt_trigger
CDAD: C8       iny   ; prev_crypted 64
CDAE: 91 05    sta ($05), y
CDB0: C8       iny 
CDB1: 91 05    sta ($05), y
CDB3: C8       iny 
CDB4: 91 05    sta ($05), y  ; dummy_write_decrypt_trigger
CDB6: 60       rts   ; prev_crypted 28


credit_inserted_interrupt_cf3c:
CF3C: 48       pha   ; dummy_write_decrypt_trigger
CF3D: AD 03 40 lda $4003  ; prev_crypted cd
CF40: 29 10    and #$10
CF42: F0 F1    beq $cf35	; bogus
CF44: 8A       txa 
CF45: 48       pha   ; dummy_write_decrypt_trigger
CF46: 98       tya   ; prev_crypted 54
CF47: 48       pha 
CF48: EA       nop 
CF49: D8       cld 
CF4A: A5 01    lda $01
CF4C: F0 40    beq $cf8e
CF4E: AD 04 40 lda write_to_4004
CF51: 49 FF    eor #$ff
CF53: 29 E0    and #$e0
CF55: 85 02    sta $02  ; dummy_write_decrypt_trigger
CF57: 4A       lsr a  ; prev_crypted 26
CF58: 4A       lsr a
CF59: 4A       lsr a
CF5A: 4A       lsr a
CF5B: 4A       lsr a
CF5C: A8       tay 
CF5D: 20 34 D0 jsr cpu_delay_d034
CF60: AD 02 40 lda $4002
CF63: 29 C0    and #$c0
CF65: F0 27    beq $cf8e
CF67: 85 26    sta $26
CF69: 20 34 D0 jsr cpu_delay_d034
CF6C: AD 02 40 lda $4002
CF6F: 25 26    and $26
CF71: F0 1B    beq $cf8e
CF73: 20 34 D0 jsr cpu_delay_d034
CF76: AD 02 40 lda $4002
CF79: 25 26    and $26
CF7B: F0 11    beq $cf8e
CF7D: 20 34 D0 jsr cpu_delay_d034
CF80: AD 02 40 lda $4002
CF83: 25 26    and $26
CF85: F0 07    beq $cf8e
CF87: A9 01    lda #$01
CF89: 85 F9    sta $f9
CF8B: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
CF8D: EA       nop   ; prev_crypted 6e
CF8E: 8D 00 40 sta $4000
CF91: 68       pla 
CF92: A8       tay 
CF93: 68       pla 
CF94: AA       tax 
CF95: 68       pla 
CF96: 40       rti 
CF97: 85 F6    sta dummy_write_00f6
CF99: EA       nop 
CF9A: E6 1E    inc $1e  ; dummy_write_decrypt_trigger
CF9C: A9 1B    lda #$1b  ; prev_crypted 4d
CF9E: 8D 03 40 sta $4003
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
CFD5: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
CFD7: EA       nop   ; prev_crypted 6e
CFD8: A2 05    ldx #$05
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
CFED: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
CFEF: EA       nop   ; prev_crypted 6e
CFF0: C6 1E    dec $1e
CFF2: 4C 03 D0 jmp $d003
CFF5: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
CFF7: EA       nop   ; prev_crypted 6e
CFF8: A5 02    lda $02
CFFA: C9 60    cmp #$60
CFFC: D0 05    bne $d003
CFFE: A2 04    ldx #$04
D000: 85 F5    sta dummy_write_00f5
D002: EA       nop 
D003: A5 1D    lda nb_credits_001d
D005: F8       sed 
D006: 18       clc 
D007: 7D 5C D0 adc $d05c, x
D00A: D9 64 D0 cmp $d064, y
D00D: 90 06    bcc $d015
D00F: B9 64 D0 lda $d064, y
D012: 85 F5    sta dummy_write_00f5
D014: EA       nop 
D015: 85 1D    sta nb_credits_001d
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
D02C: 85 F6    sta dummy_write_00f6
D02E: EA       nop 
D02F: 4C D4 CF jmp $cfd4
D032: 85 F5    sta dummy_write_00f5
cpu_delay_d034:
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
D043: 85 F6    sta dummy_write_00f6
check_if_coin_inserted_d045:
D045: EA       nop 
D046: A5 F9    lda $f9
D048: F0 11    beq $d05b
D04A: AD 02 40 lda $4002
D04D: 29 C0    and #$c0
D04F: D0 0A    bne $d05b
D051: A9 00    lda #$00
D053: 85 F9    sta $f9
D055: 20 99 CF jsr $cf99
D058: 85 F6    sta dummy_write_00f6
D05A: EA       nop 
D05B: 60       rts 


game_start_management_d06e:
D06E: EA       nop
D06F: A5 1A    lda $1a
D071: F0 1E    beq $d091
D073: A5 1C    lda $1c
D075: D0 09    bne check_if_game_start_d080
D077: 20 11 D1 jsr display_push_start_button_d111
D07A: 20 3F D1 jsr $d13f
D07D: 85 F5    sta dummy_write_00f5
D07F: EA       nop 
check_if_game_start_d080:
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
D0A8: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
D0AB: 20 E3 CB jsr $cbe3
D0AE: A2 E8    ldx #$e8
D0B0: A0 C2    ldy #$c2
D0B2: 20 BC C9 jsr display_text_block_c9bc
D0B5: A2 1F    ldx #$1f
D0B7: 20 2C CA jsr wait_a_while_ca2c
D0BA: 4C FD D0 jmp $d0fd
D0BD: 85 F5    sta dummy_write_00f5
D0BF: EA       nop 
D0C0: A5 1D    lda nb_credits_001d
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
D0E1: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
D0E4: 20 E3 CB jsr $cbe3
D0E7: A2 D2    ldx #$d2
D0E9: A0 C2    ldy #$c2
D0EB: 20 BC C9 jsr display_text_block_c9bc
D0EE: A2 E8    ldx #$e8
D0F0: A0 C2    ldy #$c2
D0F2: 20 BC C9 jsr display_text_block_c9bc
D0F5: A2 1F    ldx #$1f
D0F7: 20 2C CA jsr wait_a_while_ca2c
D0FA: 85 F5    sta dummy_write_00f5
D0FC: EA       nop 
D0FD: A2 05    ldx #$05
D0FF: A9 00    lda #$00
D101: 85 F5    sta dummy_write_00f5
D103: EA       nop 
D104: 95 2D    sta $2d, x  ; dummy_write_decrypt_trigger
D106: CA       dex   ; prev_crypted 66
D107: 10 FB    bpl $d104
D109: A2 FF    ldx #$ff
D10B: 9A       txs 
D10C: 4C 68 C0 jmp $c068
D10F: 85 F5    sta dummy_write_00f5
display_push_start_button_d111:
D111: EA       nop 
D112: AD 67 13 lda $1367
D115: CD 55 D1 cmp $d155
D118: F0 3A    beq $d154
D11A: A0 00    ldy #$00
D11C: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D11E: EA       nop   ; prev_crypted 6e
D11F: B9 55 D1 lda $d155, y
D122: 99 67 13 sta $1367, y  ; dummy_write_decrypt_trigger
D125: C8       iny   ; prev_crypted 64
D126: C0 11    cpy #$11
D128: D0 F5    bne $d11f
D12A: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D12C: EA       nop   ; prev_crypted 6e
D12D: A0 00    ldy #$00
D12F: 85 F5    sta dummy_write_00f5
D131: EA       nop 
D132: B9 66 D1 lda $d166, y
D135: 99 AB 13 sta $13ab, y
D138: C8       iny 
D139: C0 06    cpy #$06
D13B: D0 F5    bne $d132
D13D: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D13F: EA       nop   ; prev_crypted 6e
D140: A5 1D    lda nb_credits_001d
D142: 4A       lsr a
D143: 4A       lsr a
D144: 4A       lsr a
D145: 4A       lsr a
D146: AA       tax 
D147: E8       inx 
D148: A5 1D    lda nb_credits_001d
D14A: 29 0F    and #$0f
D14C: AA       tax 
D14D: E8       inx 
D14E: 8E B3 13 stx $13b3
D151: 85 F5    sta dummy_write_00f5
D153: EA       nop 
D154: 60       rts 

D16E: EA       nop   ; prev_crypted 6e
D16F: F8       sed 
D170: 38       sec 
D171: A5 1D    lda nb_credits_001d
D173: E9 01    sbc #$01
D175: 85 1D    sta nb_credits_001d  ; dummy_write_decrypt_trigger
D177: D8       cld   ; prev_crypted 74
D178: 60       rts 
D179: 85 F5    sta dummy_write_00f5
handle_pepper_launch_d17b:
D17B: EA       nop 
D17C: A5 6F    lda $6f
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
D1A3: D0 43    bne try_to_move_player_d1e8
D1A5: B5 2B    lda player_pepper_002b, x
D1A7: F0 2D    beq $d1d6
D1A9: 85 B9    sta $b9
D1AB: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
activate_pepper_d1ad:
D1AD: EA       nop   ; prev_crypted 6e
D1AE: A9 00    lda #$00
D1B0: 85 6E    sta $6e
D1B2: A9 05    lda #$05
D1B4: 85 A0    sta $a0  ; dummy_write_decrypt_trigger
D1B6: A5 BA    lda $ba  ; prev_crypted c9
D1B8: AA       tax 
D1B9: 18       clc 
D1BA: BD 4D D2 lda $d24d, x
D1BD: 6D 1E 18 adc player_y_181e
D1C0: 8D 1A 18 sta pepper_y_181a
D1C3: 18       clc 
D1C4: BD 4E D2 lda $d24e, x
D1C7: 6D 1F 18 adc player_x_181f
D1CA: 8D 1B 18 sta pepper_x_181b  ; dummy_write_decrypt_trigger
D1CD: A9 0D    lda #$0d  ; prev_crypted 4d
D1CF: 20 5D EA jsr $ea5d
D1D2: 60       rts 
D1D3: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D1D5: EA       nop   ; prev_crypted 6e
D1D6: A9 0E    lda #$0e
D1D8: 20 5D EA jsr $ea5d
D1DB: 4C E8 D1 jmp try_to_move_player_d1e8
D1DE: 85 F5    sta dummy_write_00f5
D1E0: EA       nop 
D1E1: A9 00    lda #$00
D1E3: 85 B9    sta $b9  ; dummy_write_decrypt_trigger
D1E5: 85 F5    sta dummy_write_00f5  ; prev_crypted c1  ; dummy_write_decrypt_trigger
D1E7: EA       nop   ; prev_crypted 6e
try_to_move_player_d1e8:
D1E8: B9 00 40 lda $4000, y
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
D1FC: 85 B0    sta $b0  ; dummy_write_decrypt_trigger
D1FE: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
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
D21B: 20 69 D2 jsr update_character_d269
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
D23B: F0 0A    beq update_player_character_d247
D23D: A9 47    lda #$47
D23F: 8D 1D 18 sta player_code_181d
D242: E6 C6    inc $c6
D244: 85 F5    sta dummy_write_00f5
D246: EA       nop 
update_player_character_d247:
D247: A2 07    ldx #$07
D249: 20 69 D2 jsr update_character_d269
D24C: 60       rts 

update_character_d269:
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
D2C7: F0 4B    beq enemy_moving_on_ladder_d314
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
D309: 99 03 18 sta $1803, y  ; dummy_write_decrypt_trigger
D30C: A6 08    ldx $08  ; prev_crypted ca
D30E: 4C 4A D3 jmp $d34a
D311: 85 F5    sta dummy_write_00f5
D313: EA       nop 
enemy_moving_on_ladder_d314:
D314: A4 09    ldy $09
D316: B5 A9    lda $a9, x
D318: 30 0D    bmi enemy_climbs_up_d327
D31A: B9 03 18 lda $1803, y
D31D: 85 0B    sta $0b  ; dummy_write_decrypt_trigger
D31F: E6 0B    inc $0b  ; prev_crypted ea
D321: 4C 31 D3 jmp $d331
D324: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D326: EA       nop   ; prev_crypted 6e
enemy_climbs_up_d327:
D327: B9 03 18 lda $1803, y
D32A: 85 0B    sta $0b  ; dummy_write_decrypt_trigger
D32C: C6 0B    dec $0b  ; prev_crypted e2  ; dummy_write_decrypt_trigger
D32E: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
D330: EA       nop 
D331: A5 0B    lda $0b
D333: 99 03 18 sta $1803, y  ; dummy_write_decrypt_trigger
D336: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
D338: EA       nop 
D339: B5 A9    lda $a9, x
D33B: 29 F0    and #$f0
D33D: F0 0B    beq $d34a
D33F: F6 A9    inc $a9, x
D341: B5 A9    lda $a9, x
D343: 29 F3    and #$f3
D345: 95 A9    sta $a9, x  ; dummy_write_decrypt_trigger
D347: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
D349: EA       nop 
D34A: 60       rts 

D3C3: EA       nop 
D3C4: B5 A9    lda $a9, x
D3C6: 4A       lsr a
D3C7: 4A       lsr a
D3C8: 4A       lsr a
D3C9: 4A       lsr a
D3CA: A8       tay 
D3CB: B9 E8 D3 lda jump_table_D3E8, y
D3CE: 85 05    sta $05
D3D0: B9 E9 D3 lda $d3e9, y
D3D3: 85 06    sta $06  ; dummy_write_decrypt_trigger
D3D5: 8A       txa   ; prev_crypted 46
D3D6: 0A       asl a
D3D7: 0A       asl a
D3D8: A8       tay 
D3D9: B9 02 18 lda $1802, y
D3DC: 85 03    sta $03  ; dummy_write_decrypt_trigger
D3DE: B9 03 18 lda $1803, y  ; prev_crypted 5d
D3E1: 85 04    sta $04
D3E3: E6 67    inc $67  ; dummy_write_decrypt_trigger
D3E5: 6C 05 00 jmp ($0005)  ; prev_crypted ac

jump_table_D3E8:
    .word	$D3F5  
	.word	left_d3fd  
	.word	right_d42e  
	.word	up_d45f  
	.word	down_d4ad  
	
D3F5: A9 00    lda #$00
D3F7: 85 67    sta $67
D3F9: 60       rts 
D3FA: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D3FC: EA       nop   ; prev_crypted 6e
left_d3fd:
D3FD: A5 03    lda $03
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
right_d42e:
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
up_d45f:
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
down_d4ad:
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
D51D: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D51F: EA       nop   ; prev_crypted 6e
D520: 60       rts 
D521: 85 F5    sta dummy_write_00f5
D523: EA       nop 
D524: A5 03    lda $03
D526: 85 08    sta $08
D528: AD 03 40 lda $4003
D52B: 29 40    and #$40
D52D: F0 0B    beq counter_period_stuff_d53a
D52F: A5 1F    lda current_player_001f
D531: F0 07    beq counter_period_stuff_d53a
D533: C6 08    dec $08  ; dummy_write_decrypt_trigger
D535: C6 08    dec $08  ; prev_crypted e2  ; dummy_write_decrypt_trigger
D537: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
D539: EA       nop 
counter_period_stuff_d53a:
D53A: E6 08    inc $08  ; dummy_write_decrypt_trigger
D53C: E6 08    inc $08  ; prev_crypted ea  ; dummy_write_decrypt_trigger
D53E: E6 08    inc $08  ; prev_crypted ea
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
D56D: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D56F: EA       nop   ; prev_crypted 6e
D570: A5 08    lda $08
D572: 29 F0    and #$f0
D574: C9 30    cmp #$30
D576: F0 0D    beq $d585
D578: C9 60    cmp #$60
D57A: F0 09    beq $d585
D57C: C9 90    cmp #$90
D57E: F0 05    beq $d585
D580: C9 C0    cmp #$c0
D582: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D584: EA       nop   ; prev_crypted 6e
D585: 60       rts 
D586: 85 F5    sta dummy_write_00f5
D588: EA       nop 
D589: A5 03    lda $03
D58B: 38       sec 
D58C: E9 08    sbc #$08
D58E: 4A       lsr a
D58F: 4A       lsr a
D590: 4A       lsr a
D591: 4A       lsr a
D592: 85 12    sta $12  ; dummy_write_decrypt_trigger
D594: A9 0F    lda #$0f  ; prev_crypted 4d
D596: 38       sec 
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
D5B5: 85 12    sta $12  ; dummy_write_decrypt_trigger
D5B7: A9 0F    lda #$0f  ; prev_crypted 4d
D5B9: 38       sec 
D5BA: E5 12    sbc $12
D5BC: 85 12    sta $12  ; dummy_write_decrypt_trigger
D5BE: A5 04    lda $04  ; prev_crypted c9
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

D68B: A9 FF    lda #$ff
D68D: 60       rts 

D790: EA       nop 
D791: 4C 38 D8 jmp $d838
D794: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
handle_pepper_update_d796:
D796: EA       nop   ; prev_crypted 6e
D797: A5 6E    lda $6e
D799: C9 FF    cmp #$ff
D79B: D0 03    bne $d7a0
D79D: 4C 63 D8 jmp $d863
D7A0: 20 72 E6 jsr load_pepper_coords_address_in_03_e672
D7A3: E6 6E    inc $6e  ; dummy_write_decrypt_trigger
D7A5: A5 6E    lda $6e  ; prev_crypted c9
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
D7BC: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
D7BE: EA       nop   ; prev_crypted 6e
D7BF: 4C 57 D8 jmp $d857
D7C2: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D7C4: EA       nop   ; prev_crypted 6e
D7C5: A5 BA    lda $ba
D7C7: 4A       lsr a
D7C8: A8       tay 
D7C9: B9 64 D8 lda $d864, y
D7CC: 8D 1C 18 sta player_attributes_181c  ; dummy_write_decrypt_trigger
D7CF: B9 6E D8 lda $d86e, y  ; prev_crypted 5d
D7D2: 8D 1D 18 sta player_code_181d  ; dummy_write_decrypt_trigger
D7D5: B9 69 D8 lda $d869, y  ; prev_crypted 5d
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
D7F3: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
D7F5: EA       nop   ; prev_crypted 6e
D7F6: 60       rts 
D7F7: 85 F5    sta dummy_write_00f5
D7F9: EA       nop 
D7FA: A5 BA    lda $ba
D7FC: 4A       lsr a
D7FD: A8       tay 
D7FE: AD 1D 18 lda player_code_181d
D801: D9 6E D8 cmp $d86e, y
D804: D0 09    bne $d80f
D806: B9 73 D8 lda $d873, y
D809: 8D 1D 18 sta player_code_181d
D80C: 85 F6    sta dummy_write_00f6
D80E: EA       nop 
D80F: B9 87 D8 lda $d887, y
D812: 8D 19 18 sta $1819
D815: 60       rts 
D816: 85 F5    sta dummy_write_00f5
D818: EA       nop 
D819: A5 BA    lda $ba
D81B: 4A       lsr a
D81C: A8       tay 
D81D: AD 1D 18 lda player_code_181d
D820: D9 73 D8 cmp $d873, y
D823: D0 09    bne $d82e
D825: B9 78 D8 lda $d878, y
D828: 8D 1D 18 sta player_code_181d
D82B: 85 F6    sta dummy_write_00f6
D82D: EA       nop 
D82E: B9 8C D8 lda $d88c, y
D831: 8D 19 18 sta $1819
D834: 60       rts 
D835: 85 F5    sta dummy_write_00f5
D837: EA       nop 
D838: A5 BA    lda $ba
D83A: 4A       lsr a
D83B: A8       tay 
D83C: AD 1D 18 lda player_code_181d
D83F: D9 78 D8 cmp $d878, y
D842: D0 09    bne $d84d
D844: B9 7D D8 lda $d87d, y
D847: 8D 1D 18 sta player_code_181d
D84A: 85 F6    sta dummy_write_00f6
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

handle_make_parts_fall_d898:
D898: EA       nop 
D899: A5 BA    lda $ba
D89B: C9 06    cmp #$06
D89D: F0 50    beq $d8ef
D89F: C9 08    cmp #$08
D8A1: F0 4C    beq $d8ef
D8A3: AD 1E 18 lda player_y_181e
D8A6: 49 FF    eor #$ff
D8A8: 38       sec 
D8A9: E9 28    sbc #$28
D8AB: 4A       lsr a
D8AC: 4A       lsr a
D8AD: 4A       lsr a
D8AE: 85 03    sta $03
D8B0: A9 00    lda #$00
D8B2: 85 04    sta $04
D8B4: AD 1F 18 lda player_x_181f
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
D8FA: 20 6A DA jsr walking_on_burger_part_da6a
D8FD: A5 BA    lda $ba
D8FF: C9 02    cmp #$02
D901: F0 15    beq $d918
D903: C8       iny 
D904: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D906: EA       nop   ; prev_crypted 6e
D907: 20 58 DA jsr $da58
D90A: F0 1F    beq $d92b
D90C: C8       iny 
D90D: C0 08    cpy #$08
D90F: D0 F6    bne $d907
D911: A0 04    ldy #$04
D913: D0 5F    bne $d974
D915: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D917: EA       nop   ; prev_crypted 6e
D918: 88       dey 
D919: 85 F5    sta dummy_write_00f5
D91B: EA       nop 
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
D93D: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D93F: EA       nop   ; prev_crypted 6e
D940: 88       dey 
D941: B1 03    lda ($03), y
D943: 29 1C    and #$1c
D945: F0 A8    beq $d8ef
D947: CA       dex 
D948: D0 F6    bne $d940
D94A: F0 28    beq $d974
D94C: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D94E: EA       nop   ; prev_crypted 6e
D94F: 8A       txa 
D950: D0 0D    bne $d95f
D952: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D954: EA       nop   ; prev_crypted 6e
D955: 88       dey 
D956: B1 05    lda ($05), y
D958: 29 03    and #$03
D95A: D0 F9    bne $d955
D95C: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D95E: EA       nop   ; prev_crypted 6e
D95F: A2 04    ldx #$04
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
D97D: 85 07    sta $07  ; dummy_write_decrypt_trigger
D97F: A5 04    lda $04  ; prev_crypted c9
D981: 69 00    adc #$00
D983: 29 03    and #$03
D985: 85 08    sta $08  ; dummy_write_decrypt_trigger
D987: A5 07    lda $07  ; prev_crypted c9
D989: 29 1F    and #$1f
D98B: 0A       asl a
D98C: 0A       asl a
D98D: 0A       asl a
D98E: 85 09    sta $09
D990: 46 08    lsr $08
D992: 66 07    ror $07  ; dummy_write_decrypt_trigger
D994: 46 08    lsr $08  ; prev_crypted a2  ; dummy_write_decrypt_trigger
D996: 66 07    ror $07  ; prev_crypted aa
D998: A5 07    lda $07
D99A: 29 F8    and #$f8
D99C: 85 07    sta $07  ; dummy_write_decrypt_trigger
D99E: A2 00    ldx #$00  ; prev_crypted 4a
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
D9BC: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
D9BE: EA       nop   ; prev_crypted 6e
D9BF: E8       inx 
D9C0: E8       inx 
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
D9E1: 9D 04 02 sta $0204, x  ; dummy_write_decrypt_trigger
D9E4: A9 01    lda #$01  ; prev_crypted 4d
D9E6: 9D 05 02 sta $0205, x
D9E9: A0 00    ldy #$00
D9EB: 84 0A    sty $0a  ; dummy_write_decrypt_trigger
D9ED: 85 F5    sta dummy_write_00f5  ; prev_crypted c1  ; dummy_write_decrypt_trigger
D9EF: EA       nop   ; prev_crypted 6e
D9F0: A4 0A    ldy $0a
D9F2: B9 68 00 lda active_character_array_0068, y
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
DA38: B9 68 00 lda active_character_array_0068, y
DA3B: 29 0F    and #$0f
DA3D: 09 40    ora #$40
DA3F: 99 68 00 sta active_character_array_0068, y
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
walking_on_burger_part_da6a:
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
DA8C: AD 04 40 lda write_to_4004
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

DB28: EA       nop 
DB29: A5 6F    lda $6f
DB2B: 30 6E    bmi $db9b
DB2D: A5 13    lda timer1_0013
DB2F: 29 1F    and #$1f
DB31: D0 68    bne $db9b
DB33: E6 C2    inc $c2  ; dummy_write_decrypt_trigger
DB35: A6 C2    ldx $c2  ; prev_crypted ca
DB37: E0 03    cpx #$03
DB39: D0 02    bne $db3d
DB3B: A2 00    ldx #$00
DB3D: 86 C2    stx $c2  ; dummy_write_decrypt_trigger
DB3F: B5 BC    lda $bc, x  ; prev_crypted d9
DB41: D5 BF    cmp $bf, x
DB43: F0 56    beq $db9b
DB45: A0 00    ldy #$00
DB47: 85 F5    sta dummy_write_00f5
DB49: EA       nop 
DB4A: B9 68 00 lda active_character_array_0068, y
DB4D: C9 FF    cmp #$ff
DB4F: F0 0B    beq $db5c
DB51: C8       iny 
DB52: C0 06    cpy #$06
DB54: D0 F4    bne $db4a
DB56: 4C 9B DB jmp $db9b
DB59: 85 F5    sta dummy_write_00f5
DB5B: EA       nop 
DB5C: F6 BF    inc $bf, x  ; dummy_write_decrypt_trigger
DB5E: E8       inx   ; prev_crypted 6c
DB5F: 8A       txa 
DB60: 09 20    ora #$20
DB62: 99 68 00 sta active_character_array_0068, y  ; dummy_write_decrypt_trigger
DB65: 84 0A    sty $0a  ; prev_crypted c0  ; dummy_write_decrypt_trigger
DB67: A9 01    lda #$01  ; prev_crypted 4d
DB69: 99 99 00 sta $0099, y  ; dummy_write_decrypt_trigger
DB6C: E6 C3    inc $c3  ; prev_crypted ea  ; dummy_write_decrypt_trigger
DB6E: A5 C3    lda $c3  ; prev_crypted c9
DB70: 29 03    and #$03
DB72: 85 C3    sta $c3  ; dummy_write_decrypt_trigger
DB74: 29 01    and #$01  ; prev_crypted 0d
DB76: AA       tax 
DB77: BD 9C DB lda $db9c, x
DB7A: 99 A9 00 sta control_bits_and_frame_array_00a9, y  ; dummy_write_decrypt_trigger
DB7D: 98       tya   ; prev_crypted 54
DB7E: 0A       asl a
DB7F: 0A       asl a
DB80: A8       tay 
DB81: BD 9E DB lda $db9e, x
DB84: 99 02 18 sta $1802, y  ; dummy_write_decrypt_trigger
DB87: A5 63    lda $63  ; prev_crypted c9
DB89: 0A       asl a
DB8A: 0A       asl a
DB8B: 18       clc 
DB8C: 65 C3    adc $c3
DB8E: AA       tax 
DB8F: BD A1 DB lda $dba1, x
DB92: 99 03 18 sta $1803, y  ; dummy_write_decrypt_trigger
DB95: 20 EB DC jsr $dceb  ; prev_crypted 08
DB98: 85 F5    sta dummy_write_00f5
DB9A: EA       nop 
DB9B: 60       rts 

DBBB: EA       nop 
DBBC: A5 6F    lda $6f
DBBE: 30 1C    bmi $dbdc
DBC0: A2 00    ldx #$00
DBC2: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DBC4: EA       nop   ; prev_crypted 6e
DBC5: B5 68    lda $68, x
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
DBDD: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DBDF: EA       nop   ; prev_crypted 6e
DBE0: 86 70    stx $70
DBE2: B5 A9    lda $a9, x
DBE4: 85 71    sta $71  ; dummy_write_decrypt_trigger
DBE6: 8A       txa   ; prev_crypted 46
DBE7: 0A       asl a
DBE8: 0A       asl a
DBE9: A8       tay 
DBEA: B9 02 18 lda $1802, y
DBED: 85 03    sta $03  ; dummy_write_decrypt_trigger
DBEF: B9 03 18 lda $1803, y  ; prev_crypted 5d
DBF2: 85 04    sta $04  ; dummy_write_decrypt_trigger
DBF4: A5 03    lda $03  ; prev_crypted c9
DBF6: C9 D9    cmp #$d9
DBF8: B0 54    bcs try_to_set_direction_left_dc4e
DBFA: C9 18    cmp #$18
DBFC: 90 60    bcc try_to_set_direction_right_dc5e
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
DC2C: 20 59 E0 jsr try_to_set_direction_up_e059
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
DC49: B0 13    bcs try_to_set_direction_right_dc5e
DC4B: 85 F5    sta dummy_write_00f5
DC4D: EA       nop 
try_to_set_direction_left_dc4e:
DC4E: A6 70    ldx $70
DC50: B5 A9    lda $a9, x
DC52: 29 0F    and #$0f
DC54: 09 20    ora #$20
DC56: 95 A9    sta $a9, x
DC58: 4C 6B DC jmp $dc6b
DC5B: 85 F5    sta dummy_write_00f5
DC5D: EA       nop 
try_to_set_direction_right_dc5e:
DC5E: A6 70    ldx $70
DC60: B5 A9    lda $a9, x
DC62: 29 0F    and #$0f
DC64: 09 40    ora #$40
DC66: 95 A9    sta $a9, x
DC68: 85 F5    sta dummy_write_00f5
DC6A: EA       nop 
DC6B: A6 70    ldx $70
DC6D: 20 69 D2 jsr update_character_d269
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
DCBB: B9 68 00 lda active_character_array_0068, y
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
DCEE: B9 68 00 lda active_character_array_0068, y
DCF1: 29 03    and #$03
DCF3: 0A       asl a
DCF4: A8       tay 
DCF5: B9 2A DD lda $dd2a, y
DCF8: 85 03    sta $03
DCFA: B9 2B DD lda $dd2b, y
DCFD: 85 04    sta $04
DCFF: B9 30 DD lda $dd30, y
DD02: 85 05    sta $05  ; dummy_write_decrypt_trigger
DD04: B9 31 DD lda $dd31, y  ; prev_crypted 5d
DD07: 85 06    sta $06
DD09: A5 0A    lda $0a
DD0B: 0A       asl a
DD0C: 0A       asl a
DD0D: AA       tax 
DD0E: B4 75    ldy $75, x
DD10: B1 03    lda ($03), y
DD12: 95 72    sta $72, x  ; dummy_write_decrypt_trigger
DD14: B1 05    lda ($05), y  ; prev_crypted 59
DD16: 95 73    sta $73, x
DD18: A9 00    lda #$00
DD1A: 95 74    sta $74, x  ; dummy_write_decrypt_trigger
DD1C: F6 75    inc $75, x  ; prev_crypted fa  ; dummy_write_decrypt_trigger
DD1E: B4 75    ldy $75, x  ; prev_crypted d8
DD20: B1 03    lda ($03), y
DD22: 10 07    bpl $dd2b
DD24: A9 00    lda #$00
DD26: 95 75    sta $75, x
DD28: 85 F5    sta dummy_write_00f5
DD2A: EA       nop 
DD2B: 60       rts 

teki_display_dd65:
DD65: EA       nop   ; prev_crypted 6e
DD66: A5 6F    lda $6f
DD68: 30 19    bmi $dd83
DD6A: A2 05    ldx #$05
DD6C: 86 70    stx $70  ; dummy_write_decrypt_trigger
DD6E: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
DD70: EA       nop 
DD71: A6 70    ldx $70
DD73: B5 68    lda $68, x
DD75: 29 F0    and #$f0
DD77: F0 0E    beq $dd87
DD79: 85 F5    sta dummy_write_00f5
DD7B: EA       nop 
DD7C: C6 70    dec $70  ; dummy_write_decrypt_trigger
DD7E: 10 F1    bpl $dd71  ; prev_crypted 10
DD80: 85 F5    sta dummy_write_00f5
DD82: EA       nop 
DD83: 60       rts 
DD84: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DD86: EA       nop   ; prev_crypted 6e
DD87: 8A       txa 
DD88: 0A       asl a
DD89: 0A       asl a
DD8A: A8       tay 
DD8B: B9 02 18 lda $1802, y
DD8E: 85 03    sta $03
DD90: B9 03 18 lda $1803, y
DD93: 85 04    sta $04  ; dummy_write_decrypt_trigger
DD95: B5 8A    lda $8a, x  ; prev_crypted d9
DD97: F0 0B    beq $dda4
DD99: D6 8A    dec $8a, x
DD9B: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DD9D: EA       nop   ; prev_crypted 6e
DD9E: 4C BB DE jmp $debb
DDA1: 85 F5    sta dummy_write_00f5
DDA3: EA       nop 
DDA4: 20 9D E0 jsr $e09d
DDA7: D0 F5    bne $dd9e
DDA9: 20 B6 E0 jsr $e0b6
DDAC: D0 F0    bne $dd9e
DDAE: AD 1E 18 lda player_y_181e
DDB1: 85 17    sta $17
DDB3: AD 1F 18 lda player_x_181f
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
DDD5: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DDD7: EA       nop   ; prev_crypted 6e
DDD8: 4C 13 DE jmp $de13
DDDB: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DDDD: EA       nop   ; prev_crypted 6e
DDDE: 4C ED DD jmp $dded
DDE1: 85 F5    sta dummy_write_00f5
DDE3: EA       nop 
DDE4: A5 17    lda $17
DDE6: 69 08    adc #$08
DDE8: 85 17    sta $17
DDEA: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DDEC: EA       nop   ; prev_crypted 6e
DDED: A6 70    ldx $70
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
DEC4: 20 69 D2 jsr update_character_d269
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
DEE7: 20 59 E0 jsr try_to_set_direction_up_e059
DEEA: F0 63    beq $df4f
DEEC: 20 7B E0 jsr $e07b
DEEF: F0 5E    beq $df4f
DEF1: 20 8C E0 jsr $e08c
DEF4: F0 59    beq $df4f
DEF6: 20 6A E0 jsr try_to_set_direction_down_e06a
DEF9: F0 54    beq $df4f
DEFB: 4C 3D E0 jmp $e03d
DEFE: 85 F5    sta dummy_write_00f5
DF00: EA       nop 
DF01: 20 7B E0 jsr $e07b
DF04: F0 49    beq $df4f
DF06: 20 59 E0 jsr try_to_set_direction_up_e059
DF09: F0 44    beq $df4f
DF0B: 20 6A E0 jsr try_to_set_direction_down_e06a
DF0E: F0 3F    beq $df4f
DF10: 20 8C E0 jsr $e08c
DF13: F0 3A    beq $df4f
DF15: 4C 3D E0 jmp $e03d
DF18: 85 F5    sta dummy_write_00f5
DF1A: EA       nop 
DF1B: 20 6A E0 jsr try_to_set_direction_down_e06a
DF1E: F0 2F    beq $df4f
DF20: 20 7B E0 jsr $e07b
DF23: F0 2A    beq $df4f
DF25: 20 8C E0 jsr $e08c
DF28: F0 25    beq $df4f
DF2A: 20 59 E0 jsr try_to_set_direction_up_e059
DF2D: F0 20    beq $df4f
DF2F: 4C 3D E0 jmp $e03d
DF32: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DF34: EA       nop   ; prev_crypted 6e
DF35: 20 59 E0 jsr try_to_set_direction_up_e059
DF38: F0 15    beq $df4f
DF3A: 20 8C E0 jsr $e08c
DF3D: F0 10    beq $df4f
DF3F: 20 6A E0 jsr try_to_set_direction_down_e06a
DF42: F0 0B    beq $df4f
DF44: 20 7B E0 jsr $e07b
DF47: F0 06    beq $df4f
DF49: 4C 3D E0 jmp $e03d
DF4C: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DF4E: EA       nop   ; prev_crypted 6e
DF4F: 4C 25 E0 jmp $e025
DF52: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DF54: EA       nop   ; prev_crypted 6e
DF55: 20 8C E0 jsr $e08c
DF58: F0 F5    beq $df4f
DF5A: 20 6A E0 jsr try_to_set_direction_down_e06a
DF5D: F0 F0    beq $df4f
DF5F: 20 59 E0 jsr try_to_set_direction_up_e059
DF62: F0 EB    beq $df4f
DF64: 20 7B E0 jsr $e07b
DF67: F0 E6    beq $df4f
DF69: 4C 3D E0 jmp $e03d
DF6C: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DF6E: EA       nop   ; prev_crypted 6e
DF6F: 20 6A E0 jsr try_to_set_direction_down_e06a
DF72: F0 DB    beq $df4f
DF74: 20 8C E0 jsr $e08c
DF77: F0 D6    beq $df4f
DF79: 20 59 E0 jsr try_to_set_direction_up_e059
DF7C: F0 D1    beq $df4f
DF7E: 20 7B E0 jsr $e07b
DF81: F0 CC    beq $df4f
DF83: 4C 3D E0 jmp $e03d
DF86: 85 F5    sta dummy_write_00f5
DF88: EA       nop 
DF89: 20 7B E0 jsr $e07b
DF8C: F0 C1    beq $df4f
DF8E: 20 59 E0 jsr try_to_set_direction_up_e059
DF91: F0 BC    beq $df4f
DF93: 20 8C E0 jsr $e08c
DF96: F0 B7    beq $df4f
DF98: 20 6A E0 jsr try_to_set_direction_down_e06a
DF9B: F0 B2    beq $df4f
DF9D: 4C 3D E0 jmp $e03d
DFA0: 85 F5    sta dummy_write_00f5
DFA2: EA       nop 
DFA3: 20 59 E0 jsr try_to_set_direction_up_e059
DFA6: F0 7D    beq $e025
DFA8: 20 7B E0 jsr $e07b
DFAB: F0 78    beq $e025
DFAD: 20 8C E0 jsr $e08c
DFB0: F0 73    beq $e025
DFB2: 20 6A E0 jsr try_to_set_direction_down_e06a
DFB5: F0 6E    beq $e025
DFB7: 4C 3D E0 jmp $e03d
DFBA: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DFBC: EA       nop   ; prev_crypted 6e
DFBD: 20 8C E0 jsr $e08c
DFC0: F0 63    beq $e025
DFC2: 20 59 E0 jsr try_to_set_direction_up_e059
DFC5: F0 5E    beq $e025
DFC7: 20 7B E0 jsr $e07b
DFCA: F0 59    beq $e025
DFCC: 20 6A E0 jsr try_to_set_direction_down_e06a
DFCF: F0 54    beq $e025
DFD1: 4C 3D E0 jmp $e03d
DFD4: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
DFD6: EA       nop   ; prev_crypted 6e
DFD7: 20 7B E0 jsr $e07b
DFDA: F0 49    beq $e025
DFDC: 20 6A E0 jsr try_to_set_direction_down_e06a
DFDF: F0 44    beq $e025
DFE1: 20 8C E0 jsr $e08c
DFE4: F0 3F    beq $e025
DFE6: 20 59 E0 jsr try_to_set_direction_up_e059
DFE9: F0 3A    beq $e025
DFEB: 4C 3D E0 jmp $e03d
DFEE: 85 F5    sta dummy_write_00f5
DFF0: EA       nop 
DFF1: 20 6A E0 jsr try_to_set_direction_down_e06a
DFF4: F0 2F    beq $e025
DFF6: 20 8C E0 jsr $e08c
DFF9: F0 2A    beq $e025
DFFB: 20 7B E0 jsr $e07b
DFFE: F0 25    beq $e025
E000: 20 59 E0 jsr try_to_set_direction_up_e059
E003: F0 20    beq $e025
E005: 4C 3D E0 jmp $e03d
E008: 85 F5    sta dummy_write_00f5
E00A: EA       nop 
E00B: 20 8C E0 jsr $e08c
E00E: F0 15    beq $e025
E010: 20 6A E0 jsr try_to_set_direction_down_e06a
E013: F0 10    beq $e025
E015: 20 7B E0 jsr $e07b
E018: F0 0B    beq $e025
E01A: 20 59 E0 jsr try_to_set_direction_up_e059
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
E034: 20 69 D2 jsr update_character_d269
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
try_to_set_direction_up_e059:
E059: EA       nop 
E05A: A6 70    ldx $70
E05C: A5 71    lda $71
E05E: 29 0F    and #$0f
E060: 09 60    ora #$60
E062: 95 A9    sta $a9, x
E064: 20 C3 D3 jsr $d3c3
E067: 60       rts 
E068: 85 F5    sta dummy_write_00f5
try_to_set_direction_down_e06a:
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
display_bonus_e0fb:
E0FB: EA       nop 
E0FC: 86 11    stx $11
E0FE: 84 12    sty $12
E100: A4 64    ldy $64
E102: B9 88 E1 lda $e188, y
E105: 85 C4    sta $c4  ; dummy_write_decrypt_trigger
E107: A4 63    ldy $63  ; prev_crypted c8
E109: 98       tya 
E10A: 0A       asl a
E10B: AA       tax 
E10C: BD 76 E1 lda $e176, x
E10F: 85 03    sta $03
E111: BD 77 E1 lda $e177, x
E114: 85 04    sta $04  ; dummy_write_decrypt_trigger
E116: B9 82 E1 lda $e182, y  ; prev_crypted 5d
E119: AA       tax 
E11A: A0 00    ldy #$00
E11C: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
E11E: E8       inx   ; prev_crypted 6c
E11F: 8A       txa 
E120: C8       iny 
E121: 91 03    sta ($03), y
E123: A0 20    ldy #$20
E125: E8       inx 
E126: 8A       txa 
E127: 91 03    sta ($03), y
E129: E8       inx 
E12A: 8A       txa 
E12B: C8       iny 
E12C: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
E12E: A9 00    lda #$00  ; prev_crypted 4d
E130: 85 60    sta $60
E132: A4 12    ldy $12
E134: A6 11    ldx $11
E136: A9 0B    lda #$0b
E138: 20 5D EA jsr $ea5d
E13B: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E13D: EA       nop   ; prev_crypted 6e
E13E: 60       rts 
E13F: 85 F5    sta dummy_write_00f5
handle_bonus_pickup_e141:
E141: EA       nop 
E142: A5 C4    lda $c4
E144: F0 2F    beq $e175
E146: 20 F2 E8 jsr check_player_picking_bonus_e8f2
E149: A5 13    lda timer1_0013
E14B: 29 3F    and #$3f
E14D: D0 26    bne $e175
E14F: C6 C4    dec $c4
E151: D0 22    bne $e175
E153: A5 63    lda $63
E155: 0A       asl a
E156: AA       tax 
E157: BD 76 E1 lda $e176, x
E15A: 85 03    sta $03  ; dummy_write_decrypt_trigger
E15C: BD 77 E1 lda $e177, x  ; prev_crypted dd
E15F: 85 04    sta $04
E161: A9 00    lda #$00
E163: A8       tay 
E164: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
E166: C8       iny   ; prev_crypted 64
E167: 91 03    sta ($03), y
E169: A0 20    ldy #$20
E16B: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
E16D: C8       iny   ; prev_crypted 64
E16E: 91 03    sta ($03), y
E170: 85 60    sta $60
E172: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E174: EA       nop   ; prev_crypted 6e
E175: 60       rts 

lakmov_e190:
E190: EA       nop
E191: A9 00    lda #$00
E193: 8D 00 02 sta $0200  ; dummy_write_decrypt_trigger
E196: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
E198: EA       nop 
E199: AC 00 02 ldy $0200
E19C: B9 02 02 lda $0202, y
E19F: D0 04    bne $e1a5
E1A1: 60       rts 
E1A2: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E1A4: EA       nop   ; prev_crypted 6e
E1A5: 29 0F    and #$0f
E1A7: 85 03    sta $03
E1A9: B9 03 02 lda $0203, y
E1AC: 85 04    sta $04  ; dummy_write_decrypt_trigger
E1AE: B9 04 02 lda $0204, y  ; prev_crypted 5d
E1B1: 85 05    sta $05
E1B3: B9 02 02 lda $0202, y
E1B6: 29 F0    and #$f0
E1B8: 4A       lsr a
E1B9: 4A       lsr a
E1BA: 4A       lsr a
E1BB: AA       tax 
E1BC: BD C9 E1 lda jump_table_E1C9, x
E1BF: 85 06    sta $06
E1C1: BD CA E1 lda $e1ca, x
E1C4: 85 07    sta $07  ; dummy_write_decrypt_trigger
E1C6: 6C 06 00 jmp ($0006)  ; prev_crypted ac

jump_table_E1C9:
	.word	$E200  
	.word	$E218 
	.word	$E236 
	.word	$E278  
	.word	$E2B0  
	.word	$E2E8  
	.word	$E400  
	.word	$E1EC 	| bogus
	.word	$E1EF  	| bogus
	.word	$E1F2  	| bogus
	.word	$E320 
	.word	$E358 
	.word	$E390  
	.word	$E3C8 
	.word	$E457 
	.word	$e203 
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
E27F: 20 B2 E4 jsr burger_part_touches_ground_e4b2
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
E31D: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E31F: EA       nop   ; prev_crypted 6e
E320: B9 05 02 lda $0205, y
E323: 29 10    and #$10
E325: D0 14    bne $e33b
E327: 20 A9 E4 jsr $e4a9
E32A: B9 05 02 lda $0205, y
E32D: 09 10    ora #$10
E32F: 99 05 02 sta $0205, y
E332: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E334: EA       nop   ; prev_crypted 6e
E335: 4C 03 E2 jmp $e203
E338: 85 F5    sta dummy_write_00f5
E33A: EA       nop 
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
E355: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E357: EA       nop   ; prev_crypted 6e
E358: B9 05 02 lda $0205, y
E35B: 29 10    and #$10
E35D: D0 14    bne $e373
E35F: 20 B2 E4 jsr burger_part_touches_ground_e4b2
E362: B9 05 02 lda $0205, y
E365: 09 10    ora #$10
E367: 99 05 02 sta $0205, y
E36A: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E36C: EA       nop   ; prev_crypted 6e
E36D: 4C 03 E2 jmp $e203
E370: 85 F5    sta dummy_write_00f5
E372: EA       nop 
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
E38D: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E38F: EA       nop   ; prev_crypted 6e
E390: B9 05 02 lda $0205, y
E393: 29 10    and #$10
E395: D0 14    bne $e3ab
E397: 20 BB E4 jsr $e4bb
E39A: B9 05 02 lda $0205, y
E39D: 09 10    ora #$10
E39F: 99 05 02 sta $0205, y
E3A2: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E3A4: EA       nop   ; prev_crypted 6e
E3A5: 4C 03 E2 jmp $e203
E3A8: 85 F5    sta dummy_write_00f5
E3AA: EA       nop 
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
E3C5: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E3C7: EA       nop   ; prev_crypted 6e
E3C8: B9 05 02 lda $0205, y
E3CB: 29 10    and #$10
E3CD: D0 14    bne $e3e3
E3CF: 20 C4 E4 jsr $e4c4
E3D2: B9 05 02 lda $0205, y
E3D5: 09 10    ora #$10
E3D7: 99 05 02 sta $0205, y
E3DA: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E3DC: EA       nop   ; prev_crypted 6e
E3DD: 4C 03 E2 jmp $e203
E3E0: 85 F5    sta dummy_write_00f5
E3E2: EA       nop 
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
E3FD: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E3FF: EA       nop   ; prev_crypted 6e
E400: 20 A2 CC jsr $cca2
E403: 98       tya 
E404: AA       tax 
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
E445: 20 8C E9 jsr add_to_score_e98c
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
E478: 20 8C E9 jsr add_to_score_e98c
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

E4A9: EA       nop 
E4AA: A9 00    lda #$00
E4AC: 85 11    sta $11
E4AE: F0 1C    beq $e4cc
E4B0: 85 F5    sta dummy_write_00f5
burger_part_touches_ground_e4b2:
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

E516: EA       nop   ; prev_crypted 6e
E517: A5 05    lda $05
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
E55B: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E55D: EA       nop   ; prev_crypted 6e
E55E: A9 0A    lda #$0a
E560: 20 5D EA jsr $ea5d
E563: A9 FF    lda #$ff
E565: 60       rts 
E566: 85 F5    sta dummy_write_00f5
E568: EA       nop 
E569: A9 00    lda #$00
E56B: 60       rts 
E56C: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E56E: EA       nop   ; prev_crypted 6e
E56F: A5 05    lda $05
E571: 29 0F    and #$0f
E573: C9 08    cmp #$08
E575: D0 2D    bne $e5a4
E577: A5 04    lda $04
E579: 4A       lsr a
E57A: 4A       lsr a
E57B: 4A       lsr a
E57C: 4A       lsr a
E57D: 85 12    sta $12  ; dummy_write_decrypt_trigger
E57F: A9 10    lda #$10  ; prev_crypted 4d
E581: 38       sec 
E582: E5 12    sbc $12
E584: 85 12    sta $12  ; dummy_write_decrypt_trigger
E586: A5 05    lda $05  ; prev_crypted c9
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
E5B1: 99 02 02 sta $0202, y  ; dummy_write_decrypt_trigger
E5B4: A9 0A    lda #$0a  ; prev_crypted 4d
E5B6: 20 5D EA jsr $ea5d
E5B9: A9 FF    lda #$ff
E5BB: 60       rts 
E5BC: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E5BE: EA       nop   ; prev_crypted 6e
E5BF: A2 00    ldx #$00
E5C1: 85 F5    sta dummy_write_00f5
E5C3: EA       nop 
E5C4: B5 68    lda $68, x
E5C6: 29 E0    and #$e0
E5C8: C9 40    cmp #$40
E5CA: F0 0C    beq $e5d8
E5CC: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E5CE: EA       nop   ; prev_crypted 6e
E5CF: E8       inx 
E5D0: E0 06    cpx #$06
E5D2: D0 F0    bne $e5c4
E5D4: 60       rts 
E5D5: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E5D7: EA       nop   ; prev_crypted 6e
E5D8: B5 B1    lda $b1, x
E5DA: 85 0D    sta $0d  ; dummy_write_decrypt_trigger
E5DC: C4 0D    cpy $0d  ; prev_crypted e0
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
E5FD: 86 C9    stx $c9  ; dummy_write_decrypt_trigger
E5FF: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
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
E619: 20 8C E9 jsr add_to_score_e98c
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

load_pepper_coords_address_in_03_e672:
E672: EA       nop 
E673: AD 1A 18 lda pepper_y_181a
E676: 85 03    sta $03
E678: AD 1B 18 lda pepper_x_181b
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

pptkpt_e6df:
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
E715: 85 03    sta $03  ; dummy_write_decrypt_trigger
E717: D0 10    bne $e729  ; prev_crypted 70
E719: 85 F5    sta dummy_write_00f5
E71B: EA       nop 
E71C: B5 68    lda $68, x
E71E: 29 03    and #$03
E720: A8       tay 
E721: B9 53 E7 lda $e753, y
E724: 85 03    sta $03  ; dummy_write_decrypt_trigger
E726: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
E728: EA       nop 
E729: 8A       txa 
E72A: 0A       asl a
E72B: 0A       asl a
E72C: A8       tay 
E72D: A5 03    lda $03
E72F: 99 01 18 sta $1801, y
E732: 4C F0 E6 jmp $e6f0
E735: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E737: EA       nop   ; prev_crypted 6e
E738: B5 68    lda $68, x
E73A: 29 EF    and #$ef
E73C: 95 68    sta $68, x  ; dummy_write_decrypt_trigger
E73E: 29 03    and #$03  ; prev_crypted 0d
E740: A8       tay 
E741: B9 5A E7 lda $e75a, y
E744: 85 03    sta $03  ; dummy_write_decrypt_trigger
E746: 4C 29 E7 jmp $e729  ; prev_crypted a4

E760: EA       nop
E761: A5 6F    lda $6f
E763: 30 1E    bmi $e783
E765: AD 1E 18 lda player_y_181e
E768: 85 03    sta $03
E76A: AD 1F 18 lda player_x_181f
E76D: 85 04    sta $04  ; dummy_write_decrypt_trigger
E76F: A2 00    ldx #$00  ; prev_crypted 4a
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
E784: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E786: EA       nop   ; prev_crypted 6e
E787: 29 70    and #$70
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
E7B4: A5 6F    lda $6f
E7B6: 09 F0    ora #$f0
E7B8: 85 6F    sta $6f
E7BA: A9 FF    lda #$ff
E7BC: 85 A0    sta $a0  ; dummy_write_decrypt_trigger
E7BE: A9 00    lda #$00  ; prev_crypted 4d
E7C0: 20 5D EA jsr $ea5d
E7C3: 4C 7B E7 jmp $e77b
E7C6: 85 F5    sta dummy_write_00f5
E7C8: EA       nop 
E7C9: A6 1F    ldx current_player_001f
E7CB: F6 65    inc $65, x  ; dummy_write_decrypt_trigger
E7CD: A4 63    ldy $63  ; prev_crypted c8
E7CF: B5 65    lda $65, x
E7D1: 85 05    sta $05
E7D3: D9 15 E8 cmp $e815, y
E7D6: D0 03    bne $e7db
E7D8: 20 FB E0 jsr display_bonus_e0fb
E7DB: A5 05    lda $05
E7DD: D9 1B E8 cmp $e81b, y
E7E0: D0 03    bne $e7e5
E7E2: 20 FB E0 jsr display_bonus_e0fb
E7E5: A5 05    lda $05
E7E7: D9 21 E8 cmp $e821, y
E7EA: D0 03    bne $e7ef
E7EC: 20 FB E0 jsr display_bonus_e0fb
E7EF: A5 05    lda $05
E7F1: D9 27 E8 cmp $e827, y
E7F4: D0 03    bne $e7f9
E7F6: 20 FB E0 jsr display_bonus_e0fb
E7F9: A5 05    lda $05
E7FB: D9 2D E8 cmp $e82d, y
E7FE: 90 14    bcc $e814
E800: A5 6F    lda $6f
E802: 29 0F    and #$0f
E804: 09 80    ora #$80
E806: 85 6F    sta $6f
E808: A9 FF    lda #$ff
E80A: 85 A0    sta $a0
E80C: A9 05    lda #$05
E80E: 20 5D EA jsr $ea5d
E811: 85 F5    sta dummy_write_00f5
E813: EA       nop 
E814: 60       rts 


E835: EA       nop 
E836: A5 6F    lda $6f
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
E85C: 8D 1D 18 sta player_code_181d
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
E871: A5 6F    lda $6f
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
E895: 8D 1D 18 sta player_code_181d
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

check_player_picking_bonus_e8f2:
E8F2: EA       nop
E8F3: A5 60    lda $60
E8F5: D0 7A    bne $e971
E8F7: A6 63    ldx $63
E8F9: BD 72 E9 lda $e972, x
E8FC: 85 03    sta $03
E8FE: BD 78 E9 lda $e978, x
E901: 85 04    sta $04
E903: AD 1E 18 lda player_y_181e
E906: 18       clc 
E907: 69 08    adc #$08
E909: C5 03    cmp $03
E90B: 90 64    bcc $e971
E90D: E9 10    sbc #$10
E90F: C5 03    cmp $03
E911: B0 5E    bcs $e971
E913: AD 1F 18 lda player_x_181f
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
E93A: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
E93C: C8       iny   ; prev_crypted 64
E93D: E6 05    inc $05  ; dummy_write_decrypt_trigger
E93F: A5 05    lda $05  ; prev_crypted c9
E941: 91 03    sta ($03), y
E943: A9 00    lda #$00
E945: A0 20    ldy #$20
E947: 91 03    sta ($03), y
E949: C8       iny 
E94A: 91 03    sta ($03), y  ; dummy_write_decrypt_trigger
E94C: A9 02    lda #$02  ; prev_crypted 4d
E94E: 85 C4    sta $c4
E950: E6 60    inc $60
E952: BC 81 E9 ldy $e981, x
E955: B9 87 E9 lda $e987, y
E958: 20 8C E9 jsr add_to_score_e98c
E95B: A6 1F    ldx current_player_001f
E95D: B5 2B    lda player_pepper_002b, x
E95F: 18       clc 
E960: F8       sed 
E961: 69 01    adc #$01
E963: 95 2B    sta player_pepper_002b, x  ; dummy_write_decrypt_trigger
E965: D8       cld   ; prev_crypted 74
E966: 20 94 CA jsr $ca94
E969: A9 11    lda #$11
E96B: 20 5D EA jsr $ea5d
E96E: 85 F5    sta dummy_write_00f5
E970: EA       nop 
E971: 60       rts 

add_to_score_e98c:
E98C: EA       nop   ; prev_crypted 6e
E98D: 85 04    sta $04  ; dummy_write_decrypt_trigger
E98F: 8A       txa   ; prev_crypted 46
E990: 48       pha 
E991: 98       tya 
E992: 48       pha 
E993: A5 1B    lda $1b
E995: D0 06    bne $e99d
E997: 4C 33 EA jmp $ea33
E99A: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E99C: EA       nop   ; prev_crypted 6e
E99D: A6 1F    ldx current_player_001f
E99F: BC 59 EA ldy $ea59, x
E9A2: A6 04    ldx $04
E9A4: 18       clc 
E9A5: F8       sed 
E9A6: B9 2D 00 lda player_score_002d, y
E9A9: 7D 38 EA adc $ea38, x
E9AC: 99 2D 00 sta player_score_002d, y  ; dummy_write_decrypt_trigger
E9AF: B9 2E 00 lda $002e, y  ; prev_crypted 5d
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
E9E0: D9 2D 00 cmp player_score_002d, y
E9E3: B0 1A    bcs $e9ff
E9E5: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E9E7: EA       nop   ; prev_crypted 6e
E9E8: B9 2D 00 lda player_score_002d, y
E9EB: 85 33    sta $33  ; dummy_write_decrypt_trigger
E9ED: B9 2E 00 lda $002e, y  ; prev_crypted 5d
E9F0: 85 34    sta $34
E9F2: B9 2F 00 lda $002f, y
E9F5: 85 35    sta $35  ; dummy_write_decrypt_trigger
E9F7: A2 02    ldx #$02  ; prev_crypted 4a
E9F9: 20 4E C9 jsr $c94e
E9FC: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
E9FE: EA       nop   ; prev_crypted 6e
E9FF: A6 1F    ldx current_player_001f
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
EA28: 20 54 CA jsr display_player_lives_ca54
EA2B: A9 02    lda #$02
EA2D: 20 5D EA jsr $ea5d
EA30: 85 F5    sta dummy_write_00f5
EA32: EA       nop 
EA33: 68       pla 
EA34: A8       tay 
EA35: 68       pla 
EA36: AA       tax 
EA37: 60       rts 

EA5D: EA       nop 
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

EA8D: EA       nop 
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
EACE: 20 8C E9 jsr add_to_score_e98c
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
EB04: 99 01 18 sta $1801, y  ; dummy_write_decrypt_trigger
EB07: 4C 9E EA jmp $ea9e  ; prev_crypted a4
EB0A: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
EB0C: EA       nop   ; prev_crypted 6e
EB0D: B5 68    lda $68, x
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
EB2C: 99 01 18 sta $1801, y  ; dummy_write_decrypt_trigger
EB2F: 4C 9E EA jmp $ea9e  ; prev_crypted a4
EB32: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
EB34: EA       nop   ; prev_crypted 6e
EB35: 86 03    stx $03  ; dummy_write_decrypt_trigger
EB37: B5 68    lda $68, x  ; prev_crypted d9
EB39: 29 03    and #$03
EB3B: AA       tax 
EB3C: D6 BE    dec $be, x  ; dummy_write_decrypt_trigger
EB3E: A6 03    ldx $03  ; prev_crypted ca
EB40: A9 FF    lda #$ff
EB42: 95 68    sta $68, x  ; dummy_write_decrypt_trigger
EB44: BC 4F EB ldy $eb4f, x  ; prev_crypted dc
EB47: A9 00    lda #$00
EB49: 99 00 18 sta $1800, y  ; dummy_write_decrypt_trigger
EB4C: 4C 9E EA jmp $ea9e  ; prev_crypted a4

EB6B: EA       nop 
EB6C: A2 05    ldx #$05
EB6E: 85 F5    sta dummy_write_00f5
EB70: EA       nop 
EB71: B5 68    lda $68, x
EB73: 10 0A    bpl $eb7f
EB75: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
EB77: EA       nop   ; prev_crypted 6e
EB78: CA       dex 
EB79: 10 F6    bpl $eb71
EB7B: 60       rts 
EB7C: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
EB7E: EA       nop   ; prev_crypted 6e
EB7F: BC 4F EB ldy $eb4f, x
EB82: B9 02 18 lda $1802, y
EB85: 85 03    sta $03  ; dummy_write_decrypt_trigger
EB87: B9 03 18 lda $1803, y  ; prev_crypted 5d
EB8A: 85 04    sta $04  ; dummy_write_decrypt_trigger
EB8C: AC 00 02 ldy $0200  ; prev_crypted cc
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
EBB3: 95 68    sta $68, x  ; dummy_write_decrypt_trigger
EBB5: A9 42    lda #$42  ; prev_crypted 4d
EBB7: 95 99    sta $99, x
EBB9: A9 0C    lda #$0c
EBBB: 20 5E EA jsr $ea5e
EBBE: 4C 78 EB jmp $eb78
EBC1: 85 F6    sta dummy_write_00f6
EBC3: EA       nop 
EBC4: A9 05    lda #$05
EBC6: 85 2B    sta player_pepper_002b
EBC8: 85 2C    sta $2c
EBCA: AD 04 40 lda write_to_4004
EBCD: 29 10    and #$10
EBCF: D0 05    bne $ebd6
EBD1: C6 2B    dec player_pepper_002b
EBD3: 85 F6    sta dummy_write_00f6  ; dummy_write_decrypt_trigger
EBD5: EA       nop   ; prev_crypted 6e
EBD6: 60       rts 

EFF3: EA       nop 
EFF4: A9 00    lda #$00
EFF6: 85 F3    sta $f3
EFF8: 85 F5    sta dummy_write_00f5
EFFA: EA       nop 
EFFB: A9 00    lda #$00
EFFD: 85 ED    sta $ed  ; dummy_write_decrypt_trigger
EFFF: A9 36    lda #$36  ; prev_crypted 4d
F001: 85 E4    sta $e4
F003: A9 00    lda #$00
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

F08C: EA       nop 
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
F0D2: 20 A3 C8 jsr clear_screen_and_sprites_c8a3
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
F105: 85 DE    sta $de  ; dummy_write_decrypt_trigger
F107: A9 07    lda #$07  ; prev_crypted 4d
F109: 85 DF    sta $df
F10B: A9 06    lda #$06
F10D: 85 E0    sta $e0  ; dummy_write_decrypt_trigger
F10F: A9 00    lda #$00  ; prev_crypted 4d
F111: 85 E1    sta $e1
F113: 85 E2    sta $e2  ; dummy_write_decrypt_trigger
F115: 85 E3    sta $e3  ; prev_crypted c1  ; dummy_write_decrypt_trigger
F117: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
F119: EA       nop 
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
F144: 85 E3    sta $e3  ; dummy_write_decrypt_trigger
F146: A9 00    lda #$00  ; prev_crypted 4d
F148: 85 DF    sta $df
F14A: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F14C: EA       nop   ; prev_crypted 6e
F14D: A5 DE    lda $de
F14F: 05 DF    ora $df
F151: D0 12    bne $f165
F153: A5 E2    lda $e2
F155: 10 07    bpl $f15e
F157: 09 0F    ora #$0f
F159: 85 E2    sta $e2
F15B: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F15D: EA       nop   ; prev_crypted 6e
F15E: 09 80    ora #$80
F160: 85 E2    sta $e2
F162: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F164: EA       nop   ; prev_crypted 6e
F165: 20 2F F3 jsr $f32f
F168: 20 7C F3 jsr $f37c
F16B: 20 E9 F3 jsr $f3e9
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
F192: 86 E2    stx $e2  ; dummy_write_decrypt_trigger
F194: 85 F5    sta dummy_write_00f5  ; prev_crypted c1  ; dummy_write_decrypt_trigger
F196: EA       nop   ; prev_crypted 6e
F197: 20 3E F6 jsr $f63e
F19A: A5 E3    lda $e3
F19C: 29 BF    and #$bf
F19E: 85 E3    sta $e3
F1A0: A5 E2    lda $e2
F1A2: 29 0F    and #$0f
F1A4: C9 03    cmp #$03
F1A6: 90 09    bcc $f1b1
F1A8: A5 E3    lda $e3
F1AA: 09 20    ora #$20
F1AC: 85 E3    sta $e3  ; dummy_write_decrypt_trigger
F1AE: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
F1B0: EA       nop 
F1B1: 4C 1A F1 jmp $f11a
F1B4: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F1B6: EA       nop   ; prev_crypted 6e
F1B7: A9 B4    lda #$b4
F1B9: 8D 02 18 sta $1802  ; dummy_write_decrypt_trigger
F1BC: A9 40    lda #$40  ; prev_crypted 4d
F1BE: 8D 03 18 sta $1803
F1C1: A9 47    lda #$47
F1C3: 8D 01 18 sta $1801  ; dummy_write_decrypt_trigger
F1C6: A9 01    lda #$01  ; prev_crypted 4d
F1C8: 8D 00 18 sta $1800
F1CB: A9 00    lda #$00
F1CD: 8D 04 18 sta $1804
F1D0: 85 EE    sta $ee
F1D2: 85 EF    sta $ef  ; dummy_write_decrypt_trigger
F1D4: A9 17    lda #$17  ; prev_crypted 4d
F1D6: 8D 05 18 sta $1805
F1D9: 60       rts 
F1DA: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F1DC: EA       nop   ; prev_crypted 6e
F1DD: A9 08    lda #$08
F1DF: 85 DD    sta $dd
F1E1: 85 F5    sta dummy_write_00f5
F1E3: EA       nop 
F1E4: A5 DD    lda $dd
F1E6: 0A       asl a
F1E7: AA       tax 
F1E8: BD 12 F2 lda $f212, x
F1EB: 85 D8    sta $d8  ; dummy_write_decrypt_trigger
F1ED: BD 24 F2 lda $f224, x  ; prev_crypted dd
F1F0: 85 DA    sta $da
F1F2: E8       inx 
F1F3: BD 12 F2 lda $f212, x
F1F6: 85 D9    sta $d9
F1F8: BD 24 F2 lda $f224, x
F1FB: 85 DB    sta $db  ; dummy_write_decrypt_trigger
F1FD: A6 DD    ldx $dd  ; prev_crypted ca
F1FF: BD 36 F2 lda $f236, x
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


F2CB: 20 45 D0 jsr check_if_coin_inserted_d045
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
F303: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F305: EA       nop   ; prev_crypted 6e
F306: A0 00    ldy #$00
F308: 85 F5    sta dummy_write_00f5
F30A: EA       nop 
F30B: B5 48    lda $48, x
F30D: 91 D8    sta ($d8), y  ; dummy_write_decrypt_trigger
F30F: E8       inx   ; prev_crypted 6c
F310: E0 0F    cpx #$0f
F312: D0 04    bne $f318
F314: 60       rts 
F315: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F317: EA       nop   ; prev_crypted 6e
F318: C8       iny 
F319: C0 03    cpy #$03
F31B: D0 EE    bne $f30b
F31D: A5 D8    lda $d8
F31F: 18       clc 
F320: 69 40    adc #$40
F322: 85 D8    sta $d8  ; dummy_write_decrypt_trigger
F324: A5 D9    lda $d9  ; prev_crypted c9
F326: 69 00    adc #$00
F328: 85 D9    sta $d9
F32A: 4C 06 F3 jmp $f306
F32D: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F32F: EA       nop   ; prev_crypted 6e
F330: A5 E0    lda $e0
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
F35B: 8D 03 40 sta $4003  ; dummy_write_decrypt_trigger
F35E: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
F360: EA       nop 
F361: A9 03    lda #$03
F363: 85 DC    sta $dc  ; dummy_write_decrypt_trigger
F365: A9 4C    lda #$4c  ; prev_crypted 4d
F367: 85 F5    sta dummy_write_00f5
F369: EA       nop 
F36A: 8D 01 18 sta $1801  ; dummy_write_decrypt_trigger
F36D: 85 F5    sta dummy_write_00f5  ; prev_crypted c1  ; dummy_write_decrypt_trigger
F36F: EA       nop   ; prev_crypted 6e
F370: A5 E2    lda $e2
F372: 49 10    eor #$10
F374: 85 E2    sta $e2  ; dummy_write_decrypt_trigger
F376: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
F378: EA       nop 
F379: 60       rts 
F37A: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F37C: EA       nop   ; prev_crypted 6e
F37D: AD 02 40 lda $4002
F380: 49 FF    eor #$ff
F382: 29 03    and #$03
F384: F0 08    beq $f38e
F386: BA       tsx 
F387: E8       inx 
F388: E8       inx 
F389: 9A       txs 
F38A: 60       rts 
F38B: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F38D: EA       nop   ; prev_crypted 6e
F38E: A5 E0    lda $e0
F390: D0 42    bne $f3d4
F392: A5 E2    lda $e2
F394: 29 E0    and #$e0
F396: D0 3C    bne $f3d4
F398: A6 CB    ldx $cb
F39A: AD 03 40 lda $4003
F39D: 29 40    and #$40
F39F: D0 05    bne $f3a6
F3A1: A2 00    ldx #$00
F3A3: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F3A5: EA       nop   ; prev_crypted 6e
F3A6: BD 00 40 lda $4000, x
F3A9: 49 FF    eor #$ff
F3AB: 29 0F    and #$0f
F3AD: AA       tax 
F3AE: BD D5 F3 lda $f3d5, x
F3B1: C5 EF    cmp $ef
F3B3: F0 1F    beq $f3d4
F3B5: 85 EF    sta $ef  ; dummy_write_decrypt_trigger
F3B7: 18       clc   ; prev_crypted 14
F3B8: 65 EE    adc $ee
F3BA: 10 05    bpl $f3c1
F3BC: A9 00    lda #$00
F3BE: 85 F5    sta dummy_write_00f5
F3C0: EA       nop 
F3C1: C9 24    cmp #$24
F3C3: 90 05    bcc $f3ca
F3C5: A9 23    lda #$23
F3C7: 85 F5    sta dummy_write_00f5
F3C9: EA       nop 
F3CA: 85 EE    sta $ee  ; dummy_write_decrypt_trigger
F3CC: A9 15    lda #$15  ; prev_crypted 4d
F3CE: 8D 03 40 sta $4003
F3D1: 85 F5    sta dummy_write_00f5
F3D3: EA       nop 
F3D4: 60       rts 

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
F46A: BD EB F4 lda jump_table_f4eb, x
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


jump_table_f4eb:
	.word	$f4fa  
	.word	$f4fa 
	.word	$f516  
	.word	$f516  
	.word	$f50c  
	.word	$f50c  
	
F4FA: A5 E3    lda $e3
F4FC: 29 20    and #$20
F4FE: D0 EA    bne $f4ea
F500: A9 F5    lda #$f5
F502: 85 EE    sta $ee  ; dummy_write_decrypt_trigger
F504: A6 ED    ldx $ed  ; prev_crypted ca
F506: 4C 09 F6 jmp $f609
F509: 85 F5    sta dummy_write_00f5
F50B: EA       nop 
F50C: A5 E2    lda $e2
F50E: 09 80    ora #$80
F510: 85 E2    sta $e2
F512: 60       rts 
F513: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F515: EA       nop   ; prev_crypted 6e
F516: A5 E2    lda $e2
F518: 29 0F    and #$0f
F51A: F0 16    beq $f532
F51C: C6 E2    dec $e2  ; dummy_write_decrypt_trigger
F51E: A9 F5    lda #$f5  ; prev_crypted 4d
F520: 85 EE    sta $ee
F522: A6 ED    ldx $ed
F524: 20 08 F6 jsr $f608
F527: A5 E3    lda $e3
F529: 09 40    ora #$40
F52B: 29 DF    and #$df
F52D: 85 E3    sta $e3  ; dummy_write_decrypt_trigger
F52F: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
F531: EA       nop 
F532: 60       rts 
F533: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F535: EA       nop   ; prev_crypted 6e
F536: AD 02 18 lda $1802
F539: 38       sec 
F53A: E9 04    sbc #$04
F53C: 8D 06 18 sta $1806  ; dummy_write_decrypt_trigger
F53F: AD 03 18 lda $1803  ; prev_crypted cd
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
F553: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F555: EA       nop   ; prev_crypted 6e
F556: B1 D8    lda ($d8), y
F558: 91 DA    sta ($da), y
F55A: 88       dey 
F55B: 10 F9    bpl $f556
F55D: A5 D9    lda $d9
F55F: 18       clc 
F560: 69 20    adc #$20
F562: 85 D9    sta $d9  ; dummy_write_decrypt_trigger
F564: A5 DB    lda $db  ; prev_crypted c9
F566: 18       clc 
F567: 69 20    adc #$20
F569: 85 DB    sta $db
F56B: CA       dex 
F56C: 10 E3    bpl $f551
F56E: 60       rts 
F56F: 85 F5    sta dummy_write_00f5
F571: EA       nop 
F572: AD 07 18 lda $1807
F575: 85 D9    sta $d9  ; dummy_write_decrypt_trigger
F577: AD 06 18 lda $1806  ; prev_crypted cd
F57A: 49 FF    eor #$ff
F57C: 85 D8    sta $d8  ; dummy_write_decrypt_trigger
F57E: 46 D9    lsr $d9  ; prev_crypted a2
F580: 46 D9    lsr $d9
F582: 46 D9    lsr $d9  ; dummy_write_decrypt_trigger
F584: 46 D9    lsr $d9  ; prev_crypted a2  ; dummy_write_decrypt_trigger
F586: 66 D8    ror $d8  ; prev_crypted aa
F588: 46 D9    lsr $d9
F58A: 66 D8    ror $d8  ; dummy_write_decrypt_trigger
F58C: 46 D9    lsr $d9  ; prev_crypted a2  ; dummy_write_decrypt_trigger
F58E: 66 D8    ror $d8  ; prev_crypted aa
F590: A5 D9    lda $d9
F592: 18       clc 
F593: 69 10    adc #$10
F595: 85 D9    sta $d9  ; dummy_write_decrypt_trigger
F597: C6 D8    dec $d8  ; prev_crypted e2
F599: 60       rts 
F59A: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F59C: EA       nop   ; prev_crypted 6e
F59D: A5 E2    lda $e2
F59F: 29 E0    and #$e0
F5A1: C9 40    cmp #$40
F5A3: F0 04    beq $f5a9
F5A5: 60       rts 
F5A6: 85 F5    sta dummy_write_00f5
F5A8: EA       nop 
F5A9: A9 9B    lda #$9b
F5AB: 85 D8    sta $d8  ; dummy_write_decrypt_trigger
F5AD: A5 E2    lda $e2  ; prev_crypted c9
F5AF: 29 0F    and #$0f
F5B1: F0 11    beq $f5c4
F5B3: AA       tax 
F5B4: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F5B6: EA       nop   ; prev_crypted 6e
F5B7: A5 D8    lda $d8
F5B9: 38       sec 
F5BA: E9 08    sbc #$08
F5BC: 85 D8    sta $d8  ; dummy_write_decrypt_trigger
F5BE: CA       dex   ; prev_crypted 66
F5BF: D0 F6    bne $f5b7
F5C1: 85 F5    sta dummy_write_00f5
F5C3: EA       nop 
F5C4: A6 ED    ldx $ed
F5C6: BD 00 F6 lda $f600, x
F5C9: 85 D9    sta $d9
F5CB: A5 D8    lda $d8
F5CD: CD 02 18 cmp $1802
F5D0: F0 10    beq $f5e2
F5D2: 90 08    bcc $f5dc
F5D4: EE 02 18 inc $1802  ; dummy_write_decrypt_trigger
F5D7: D0 09    bne $f5e2  ; prev_crypted 70
F5D9: 85 F5    sta dummy_write_00f5
F5DB: EA       nop 
F5DC: CE 02 18 dec $1802  ; dummy_write_decrypt_trigger
F5DF: 85 F5    sta dummy_write_00f5  ; prev_crypted c1
F5E1: EA       nop 
F5E2: A5 D9    lda $d9
F5E4: CD 03 18 cmp $1803
F5E7: F0 0D    beq $f5f6
F5E9: EE 03 18 inc $1803  ; dummy_write_decrypt_trigger
F5EC: 85 F5    sta dummy_write_00f5  ; prev_crypted c1  ; dummy_write_decrypt_trigger
F5EE: EA       nop   ; prev_crypted 6e
F5EF: 20 35 F5 jsr $f535
F5F2: 60       rts 
F5F3: 85 F5    sta dummy_write_00f5  ; dummy_write_decrypt_trigger
F5F5: EA       nop   ; prev_crypted 6e
F5F6: A5 D8    lda $d8
F5F8: CD 02 18 cmp $1802
F5FB: F0 0C    beq $f609
F5FD: 4C EF F5 jmp $f5ef

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
