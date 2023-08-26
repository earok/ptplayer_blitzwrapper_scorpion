; Wrapper by earok, using code by E-Penguin, idrougge et al. PTPlayer by PHX.

		include	"blitz.i"

ptplayerlib equ 48

		libheader ptplayerlib,0,0,blitz_finit,0		

		astatement
			args	word
			libs
			subs	MTInstall,0,0
		name "MTInstall","Install player routine. PAL=true, NTSC=false",0

		astatement
			args
			libs
			subs	MTRemove,0,0
		name "MTRemove","Remove player from system",0

		astatement
			args	long,long,word
			libs
			subs	MTInit,0,0
		name "MTInit","Module address, instrument address, song position",0

		astatement
			args
			libs
			subs	MTEnd,0,0
		name "MTEnd","Stop playing current module",0
		
		astatement
			args	long, word, word, word
			libs
			subs	MTSoundFX,0,0
		name "MTSoundFX","Address, length, period, volume",0		

		afunction long
			args	long
			libs
			subs	MTPlayFX,0,0
		name "MTPlayFX","SFX Structure Pointer. Returns pointer to channel-status structure.",0	

		astatement
			args	long
			libs
			subs	MTLoopFX,0,0
		name "MTLoopFX","SFX Structure Pointer.",0	

		astatement
			args	byte
			libs
			subs	MTStopFX,0,0
		name "MTStopFX","Channel to stop",0	
		
		astatement
			args	byte
			libs
			subs	MTMusicMask,0,0
		name "MTMusicMask","Channel mask",0		

		astatement
			args	word
			libs
			subs	MTMasterVolume,0,0
		name "MTMasterVolume","Set a master volume from 0 to 64 for all music channels.",0

		astatement
			args	word,byte
			libs
			subs	MTSampleVolume,0,0
		name "MTSampleVolume","Sample number,volume",0

		astatement
			args	byte
			libs
			subs	MTChannelMask,0,0
		name "MTChannelMask","Channel mask",0
		
		astatement
			args	byte
			libs
			subs	MTEnable,0,0
		name "MTEnable","Enabled",0		
		
		afunction byte
			args	
			libs
			subs	MTE8Trigger,0,0
		name "MTE8Trigger","Returns last E8 value",0		

		astatement
			args	byte
			libs
			subs	MTMusicChannels,0,0
		name "MTMusicChannels","Set number of music channels",0		

blitz_finit:
		nullsub	_blitz_mt_lib_finit,0,0 ; Call deinit routine on exit

		libfin ; End of Blitz library header

; Deinitialisation for Blitz so that user doesn't have to call MTRemove
_blitz_mt_lib_finit:
	bra	_mt_remove_cia
	
storeAddressRegisters	macro
	movem.l a4-a6,-(sp) ; Save registers for Blitz 2
	lea     CUSTOM,a6 ;Store the custom register in A6
	endm
	
storeAddressRegistersVBR macro
	movem.l a4-a6,-(sp) ; Save registers for Blitz 2
	;Load vector base into A0
	sub.l   a0,a0
	move.l  4.w,a6
	btst    #0,297(a6)              ; check for 68010
	beq     .novbr
	lea     getvbr(pc),a5
	jsr     -30(a6) 		
.novbr: lea     CUSTOM,a6
	endM

restoreAddressRegisters	macro
	movem.l (sp)+,a4-a6	; Restore registers for Blitz
	rts ;Return to Blitz
	endm
	
MTInstall:
	storeAddressRegistersVBR	
	jsr _mt_install_cia
	restoreAddressRegisters

MTRemove:
	storeAddressRegisters	
	jsr _mt_remove_cia
	restoreAddressRegisters
	
MTInit:
	storeAddressRegisters
	move.l D0,A0 ; a0 = module pointer
	move.l D1,A1 ; a1 = sample pointer (NULL means samples are stored within the module)
	move.w D2,D0 ; d0 = initial song position
	jsr _mt_init
	restoreAddressRegisters

MTEnd:
	storeAddressRegisters
	jsr _mt_end
	restoreAddressRegisters
	
MTSoundFX:	
	storeAddressRegisters
	move.l D0,A0 ;a0 = sample pointer
	move.w D1,D0 ;d0.w = sample length in words
	move.w D2,D1 ;d1.w = sample period
	Move.w D3,D2 ;d2.w = sample volume
	jsr _mt_soundfx
	restoreAddressRegisters	

MTPlayFX:	
	storeAddressRegisters
	move.l D0,A0 ;a0=SfxStructurePointer
	jsr _mt_playfx
	restoreAddressRegisters	

MTLoopFX:	
	storeAddressRegisters
	move.l D0,A0 ;a0=SfxStructurePointer
	jsr _mt_loopfx
	restoreAddressRegisters	

MTStopFX:	
	storeAddressRegisters
	jsr _mt_stopfx
	restoreAddressRegisters	

MTMusicMask:
	storeAddressRegisters
	jsr _mt_musicmask
	restoreAddressRegisters

MTMasterVolume:
	storeAddressRegisters
	jsr _mt_mastervol
	restoreAddressRegisters

MTSampleVolume:
	storeAddressRegisters
	jsr _mt_samplevol
	restoreAddressRegisters

MTChannelMask:
	storeAddressRegisters
	jsr _mt_channelmask
	restoreAddressRegisters
	
MTEnable:
	move.b	d0,_mt_Enable
	rts	

MTE8Trigger:
	move.b	_mt_E8Trigger,d0
	rts	

MTMusicChannels:
	move.b	d0,_mt_MusicChannels
	rts

; VBR Hack by phx
; https://eab.abime.net/showpost.php?p=1516508&postcount=7
;----- Get VBR 68010+ ---
        mc68010
getvbr:
        movec   vbr,a0
        rte
        mc68000
;------------------------

	include "ptplayer.asm"
