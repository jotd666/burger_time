

***    
*** BUILD OPTIONS
***
	.ifdef		RELEASE
    * hardware options
    OPT_DISABLE_BG_LAYER=0                      | do not change!
    OPT_DISABLE_SPRITES=0                       | do not change!
												| do not change!
	* cheats to test game                       | do not change!
    * score is decimal format                   | do not change!
	* all options must be zeroed for release    | do not change!
    OPT_START_SCORE=0                           | do not change!
												| do not change!
	OPT_SKIP_GAME_DEMO=0                        | do not change!
	OPT_ONLY_ONE_ENEMY=0                        | do not change!
	OPT_ONLY_ONE_LIFE=0                         | do not change!
	OPT_START_AT_LEVEL_2=0
	.else
	
	* debug release, options can be changed
	
    OPT_DISABLE_BG_LAYER=0
    OPT_DISABLE_SPRITES=0
   
	* cheats to test game
    * score is decimal format
	* all options must be zeroed for release
    OPT_START_SCORE=0

	OPT_SKIP_GAME_DEMO=0
	* when only one enemy:
	* wolf struct at 8AE0, sprite shadow at 8850
	* balloon struct at 8B70 (y @8B74), sprite shadow at 8868
	* 
	OPT_ONLY_ONE_ENEMY=0
	OPT_ONLY_ONE_LIFE=0
	OPT_START_AT_LEVEL_2=0
	
	
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


| write current PC value to some address
.macro LOGPC	address
	.ifndef	RELEASE
     bsr    .next_\@
.next_\@:
      addq.l    #6,(a7) | skip this & next instruction
      move.l    (a7)+,0x\address
	.endif
.endm
