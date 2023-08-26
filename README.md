# ptplayer_blitzwrapper_scorpion
Wrapper for PHX's PTPlayer for use with Blitz Basic.

This is separate from but based on the previous wrapper created by E-Penguin and idrougge, with some key differences:

1. Uses ptplayer 6.4.
2. ptplayer.asm has no changes, the blitz wrapper is entirely separate in ptplayer_blitz.asm. As such, ptplayer.asm can be substituted with future or past versions with no need to embed blitz specific code into it.
3. Exception to the above that NULL_IS_CLEARED is enabled to resolve issues with samples being loaded and unloaded from memory.
4. There are also no references to other libraries eg bank and sound, 

It also uses the same library number and mostly the same function names so only one can be used at a time.

This was created specifically for use in the Scorpion Engine project, but I've published it here if you have any use for it. Please do let me know if there's any obvious issues in the code.