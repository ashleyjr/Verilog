# -------------Init table 
C2          #  R0 - Stash address
00          #  R1 
00          #  R2 
A0          #  R3 - Seed

      # Setup
      SW01
      SW12
      SW23
      STW      # Place seed in stash address
      

      # Loop
      PUSHC    # Start of oop
         
         LDW      # R0 = X                R1 = X                  R2 = Seed               R3 = 0xC2
         SW23
         REF
         SW01
         MUL      # R0 = 0x04             R1 = 0xC2               R2 = 0xC2               R3 = Seed
         SW01
         MUL      # R0 = 0x08             R1 = 0x04               R2 = 0xC2               R3 = Seed
         SW01
         MUL      # R0 = 0x10             R1 = 0x08               R2 = 0xC2               R3 = Seed
         SW01
         MUL      # R0 = 0x20             R1 = 0x10               R2 = 0xC2               R3 = Seed
         SW01
         SW23
         NAND     # R0 = S NAND 0x20      R1 = 0x20               R2 = Seed               R3 = 0xC2
         PUSH     
         SW01
         SW12
         SW23
         REF
         SW01
         SW12
         REF
         SW01
         SUB
         SW01
         NAND     # R0 = 0xFF             R1 = 0x00               R2 = 0xC2               R3 = S NAND 0x20
         SW01
         SW23
         NAND     # R0 = S AND 0x20       R1 = 0xFF               R2 = S NAND 0x20        R3 = 0xC2
         POP      # R0 = S AND 0x20       R1 = 0xFF               R2 = Seed               R3 = 0xC2
         SW23
         SW01
         SW12     # R0 = S AND 0x20       R1 = 0xFF               R2 = S AND 0x20         R3 = Seed
         PUSH     # R0 = X                R1 = X                  R2 = X                  R3 = Seed
         REF
         SW01
         SW12
         REF
         SW01
         MUL      # R0 = 0x04             R1 = 0xC2               R2 = 0xC2               R3 = Seed
         SW01
         MUL      # R0 = 0x08             R1 = 0x04               R2 = 0xC2               R3 = Seed
         SW01
         MUL      # R0 = 0x10             R1 = 0x08               R2 = 0xC2               R3 = Seed
         SW01
         MUL      # R0 = 0x20             R1 = 0x10               R2 = 0xC2               R3 = Seed
         SW01
         MUL      # R0 = 0x40             R1 = 0x20               R2 = 0xC2               R3 = Seed
         SW01
         MUL      # R0 = 0x80             R1 = 0x40               R2 = 0xC2               R3 = Seed
         SW01
         SW23
         NAND     # R0 = S NAND 0x80      R1 = 0x80               R2 = Seed               R3 = 0xC2
         PUSH     
         SW01
         SW12
         SW23
         REF
         SW01
         SW12
         REF
         SW01
         SUB
         SW01
         NAND     # R0 = 0xFF             R1 = 0x00               R2 = 0xC2               R3 = S NAND 0x80
         SW01
         SW23
         NAND     # R0 = S AND 0x80       R1 = 0xFF               R2 = S NAND 0x80        R3 = 0xC2
         POP      # R0 = S AND 0x80       R1 = 0xFF               R2 = Seed               R3 = 0xC2
         SW23
         POP
         SW01
         SW12     # R0 = 0xFF             R1 = S AND 0x20         R2 = S AND 0x80         R3 = Seed
         PUSH
         SW12
         PUSH     # R0 = 0xFF             R1 = X                  R2 = X                  R3 = Seed
         REF
         SW01
         SW12
         REF
         SW01
         MUL      # R0 = 0x04             R1 = 0xC2               R2 = 0xC2               R3 = Seed
         POP
         SW01
         MUL
         SW01
         SW12     # R0 = 0x04             R1 = S AND 0x20         R2 = (S AND 0x20)<<2    R3 = Seed
         PUSH     # R0 = 0x04             R1 = S AND 0x20         R2 = X                  R3 = Seed 
               

         # Create 0x02
         # Create jump to address
         # Branch

POPC     # End of loop
        

           
           
           
           
           
           
           
           
           
           
        
        
