not sure what to write here

To load program into memory, drag .asm file onto asembler_MNPU2-sv.py. It will put binary code into program.bin
All other commands can be found in tasks.json

- ISA: https://docs.google.com/spreadsheets/d/1aOvMMqjjtbJwQ4dTB1HlWPE_uM2PamwpnOvkguVXVjU/edit?usp=sharing
- Minecraft implementation showcase: https://youtu.be/GCmohTZukFM

- Diffrences from original implementation:
  - There is no dCache(data cache) or iCache(instruction cache), CPU reads straight from RAM/ROM.
  - Proper HALT isnt implemented yet.
  - Wait for input isnt implemented yet.
  - Hazard where you couldnt set pointer to a register that just got updated (it would read previous value) doesnt exist in this implementation, so code like this will work fine:
    ```asm
    INC R7
    POI R7
    ```
    in original implementation you have to do sth like this:
    ```asm
    INC R7
    NOOP ; or any other instruction to create this space
    POI R7
    ```
