

***    
*** BUILD OPTIONS
***
	.ifdef		RELEASE
    * hardware options
    OPT_DISABLE_BG_LAYER=0                      | do not change!
    OPT_DISABLE_SPRITES=0                       | do not change!
												| do not change!
	* cheats to test game                       | do not change!
	* all options must be zeroed for release    | do not change!
    OPT_START_SCORE=0                           | do not change!
												| do not change!

	.else
	
	* debug release, options can be changed
	
    OPT_DISABLE_BG_LAYER=0
    OPT_DISABLE_SPRITES=0
   
	* cheats to test game
	* all options must be zeroed for release
    OPT_START_SCORE=0

	OPT_ONLY_ONE_LIFE=0

	
	
	.endif
	
	.ifdef	RELEASE
	.macro	BREAKPOINT comment
	.endm
	.else
	* amiga specific
	.macro	BREAKPOINT comment
	move.l	a0,-(a7)
	lea		comment\@(pc),a0
	jbsr	osd_break
	move.l	(a7)+,a0
	jra		next\@
comment\@:
	.asciz	"\comment"
	.align	2
next\@:
	.endm
	.endif	
	

| write current PC value to some address
.macro LOGPC	address
	.ifndef	RELEASE
     bsr    .next_\@
.next_\@:
      addq.l    #6,(a7) | skip this & next instruction
      move.l    (a7)+,0x\address
	.endif
.endm

	.ifdef	RELEASE
	.macro	TMPBREAK
	.error  "stray TMPBREAK macro"
	.endm
	.macro	TMPWRITE
	.error  "stray TMPWRITE macro"
	.endm
	.else
	.macro	TMPBREAK
	BREAKPOINT	"work breakpoint"
	.endm
	.macro	TMPWRITE
	move.b	#0,0x100		| 0x100 is used but only for exceptions
	.endm
	.endif

***
*** end of BUILD OPTIONS
***

	* file is generated
	.include	"sounds.inc"
    
.macro _STRUCT
  .set _offset_,0
.endm

.macro _DS _element, _size
   \_element = _offset_
   .set _offset_,_offset_+\_size
.endm

