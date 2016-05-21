# -------------Init table 
F0          #  R0 - Stash address
80          #  R1 - 1st bit mask
20          #  R2 - 3rd bit mask
A0          #  R3 - Seed

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
         
         
         PUSH     # Stash                 R1 = 0x80               R2 = X                  R3 = Seed 
         SW23     
         NAND     # R0 = S NAND 0x80      R1 = 0x80               R2 = Seed               R3 = X  
         PUSH     # R0 = S NAND 0x80      R1 = 0x80               R2 = X                  R3 = X  
         SW12     # R0 = S NAND 0x80      R1 = X                  R2 = 0x80               R3 = X  
         PUSH     # R0 = S NAND 0x80      R1 = X                  R2 = X                  R3 = X  
         SW01
         SW12
         SW23
         REF
         SW01
         SW12
         REF
         SW01
         SUB      # R0 = 0x00             R1 = Stash              R2 = Stash              R3 = S NAND 0x80
         SW01
         NAND     # R0 = 0xFF             R1 = 0x00               R2 = Stash              R3 = S NAND 0x80
         SW01
         SW23
         NAND     # R0 = S AND 0x80       R1 = 0xFF               R2 = S NAND 0x80        R3 = 0x20
         SW01
         SW12
         SW23
         POP
         SW12
         SW01
         POP
         SW12
         POP
         SW23     # R0 = 0x80             R1 = 0x20               R2 = S AND 0x80         R3 = Seed
         PUSH     # R0 = 0x80             R1 = Seed               R2 = X                  R3 = 0x20
         SW12
         SW23
         SW01
         SW12
         REF      # R0 = Stash            R1 = 0x20               R2 = 0x80               R3 = Seed



         PUSH     # Stash                 R1 = 0x20               R2 = X                  R3 = Seed 
         SW23     
         NAND     # R0 = S NAND 0x20      R1 = 0x20               R2 = Seed               R3 = X  
         PUSH     # R0 = S NAND 0x20      R1 = 0x20               R2 = X                  R3 = X  
         SW12     # R0 = S NAND 0x20      R1 = X                  R2 = 0x20               R3 = X  
         PUSH     # R0 = S NAND 0x20      R1 = X                  R2 = X                  R3 = X  
         SW01
         SW12
         SW23
         REF
         SW01
         SW12
         REF
         SW01
         SUB      # R0 = 0x00             R1 = Stash              R2 = Stash              R3 = S NAND 0x20
         SW01
         NAND     # R0 = 0xFF             R1 = 0x00               R2 = Stash              R3 = S NAND 0x20
         SW01
         SW23
         NAND     # R0 = S AND 0x20       R1 = 0xFF               R2 = S NAND 0x20        R3 = 0x20
         SW01
         SW12
         SW23
         POP
         SW12
         SW01
         POP
         SW12
         POP
         SW23     # R0 = 0x20             R1 = 0x20               R2 = S AND 0x20         R3 = Seed
         PUSH     # R0 = 0x20             R1 = Seed               R2 = X                  R3 = 0x20
         SW12
         SW23
         SW01
         SW12
         REF      # R0 = Stash            R1 = 0x80               R2 = 0x20               R3 = Seed



      POPC     # End of loop
        

           
           
           
           
           
           
           
           
           
           
        
        
