# -------------Init table 
02          #  R0 - Multiply by 2 to shift left
00          #  R1
01          #  R2 - Seed
7F          #  R3 - Stash address

      # Setup
      STW      # Place seed in stash address




      # Loop
      PUSHC    # Start of oop
         LDW      # Get current value
         SW23
         PUSH     # Put address on stack
            REF
            SW01
            SW12
            REF
            SW01
            SUB      # R0 = 0x00
               SW23
               SW01
               ADD
               SW01     # R1 == R2 == Current seed
                  NAND     # Use a NAND to NOT current seed
                      
               
               SW01     # Get result from R0 to R3
               SW12
               SW23
         POP      # Get address from stack
         SW23     # Put back in to R3 ready for next loop
         STW      # Store
      POPC     # End of loop
