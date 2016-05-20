# -------------Init table 
20          #  R0 - Stash address
80          #  R1 - 1st bit mask
20          #  R2 - 3rd bit mask
90          #  R3 - Seed

      # Setup
      SW01
      SW12
      SW23
      STW      # Place seed in stash address
      SW23
      SW12
      SW01

 
      # Loop
      PUSHC    # Start of oop
         SW23     
         NAND     # R0 = S NAND 0x80      R1 = 0x80               R2 = Seed               R3 = 0x20  
         PUSH     # R0 = S NAND 0x80      R1 = 0x80               R2 = X                  R3 = 0x20  
         SW01
         SW12
         SW23
         REF
         SW01
         SW12
         REF
         SW01
         SUB      # R0 = 0x00             R1 = 0x20               R2 = 0x20               R3 = S NAND 0x80
         SW01
         NAND     # R0 = 0xFF             R1 = 0x00               R2 = 0x20               R3 = S NAND 0x80
         SW01
         SW23
         NAND     # R0 = S AND 0x80       R1 = 0xFF               R2 = S NAND 0x80        R3 = 0x20
         POP      # R0 = S AND 0x80       R1 = 0xFF               R2 = Seed               R3 = 0x20
         SW01
         SW12     # R0 = 0xFF             R1 = Seed               R2 = S AND 0x80         R3 = 0x20
         PUSH     # R0 = 0xFF             R1 = Seed               R2 = X                  R3 = 0x20
         SW01
         SW12
         SW23
         SW01
         NAND     # R0 = S NAND 0x20      R1 = Seed               R2 = 0x20               R3 = 0xFF
       
      POPC     # End of loop
        

           
           
           
           
           
           
           
           
           
           
        
        
