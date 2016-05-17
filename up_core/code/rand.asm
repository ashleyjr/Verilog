# -------------Init table 
02          #  R0 - Multiply by 2 to shift left
00          #  R1
01          #  R2 - Seed
7F          #  R3 - Stash address

      # Setup
      STW      # Place seed in stash address


 
      # Loop
      PUSHC    # Start of oop
         
         
         REF                                                                  # NOT the seed and place on stack
         SW01
         SW12
         REF
         SW01
         SUB                  # R0 = 0x00
            LDW               # Get current seed
               SW01
               ADD
               SW01           # R1 == R2 == Current seed
                  NAND        # Use a NAND to NOT current seed
                  SW01
                  SW12
                  PUSH        # Put the NOT of current seed on the stack
         
        

         LDW                                                                     # << 2 the seed and place on stack
         REF                  # Load 0x02 in R0                                        
            SW01 
            SW12
            MUL               # Left shift the NOT
               SW01
               SW12
               MUL            # Left shift the NOT again
                  SW01
                  SW12
                  PUSH        # NOT << 2 on stack

         

         POP                                                                     # Task two from stack AND then place on stack
         SW12
         POP
            NAND  
               SW01
               SW12
               PUSH           # NAND on stack
                  REF
                  SW01
                  SW12
                  REF
                  SW01
                  SUB         # R0 = 0x00
                     SW01
                     POP
                     NAND        # NOT the value
                        PUSH     # AND on stack
                       
      PO   PC     # End of loop
           
           
           
           
           
           
           
           
           
           
           
        
        
