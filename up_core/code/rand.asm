# -------------Init table 
02          #  R0 - Multiply by 2 to shift left
00          #  R1
0F          #  R2 - Seed
F0          #  R3 - Stash address

      # Setup
      STW      # Place seed in stash address


 
      # Loop
      PUSHC    # Start of oop
 
         # Seed stored in 0xF0

         LDW      # R0 = 0x02          R1 = X               R2 = Seed            R3 = Seed address
         PUSH     # R0 = 0x02          R1 = X               R2 = X               R3 = Seed address
         SW01     # R0 = X             R1 = 0x02            R2 = X               R3 = Seed address
         SW12     # R0 = X             R1 = X               R2 = 0x02            R3 = Seed address
         REF      # R0 = 0x02          R1 = X               R2 = 0x02            R3 = Seed address
         SW01     # R0 = X             R1 = 0x02            R2 = 0x02            R3 = Seed address
         SUB      # R0 = 0x00          R1 = 0x02            R2 = 0x02            R3 = Seed address
         SW01     # R0 = 0x02          R1 = 0x00            R2 = 0x02            R3 = Seed address
         NAND     # R0 = 0xFF          R1 = 0x00            R2 = 0x02            R3 = Seed address
         SW01     # R0 = 0x00          R1 = 0xFF            R2 = 0x02            R3 = Seed address
         POP      # R0 = 0x00          R1 = 0xFF            R2 = Seed            R3 = Seed address
         NAND     # R0 = NOT Seed      R1 = 0xFF            R2 = Seed            R3 = Seed address
         PUSH     # R0 = NOT Seed      R1 = 0xFF            R2 = X               R3 = Seed address
         SW01     # R0 = 0xFF          R1 = NOT Seed        R2 = X               R3 = Seed address
         SW12     # R0 = 0xFF          R1 = X               R2 = NOT Seed        R3 = Seed address
         PUSH     # R0 = 0xFF          R1 = X               R2 = X               R3 = Seed address
         REF      # R0 = 0x02          R1 = X               R2 = X               R3 = Seed address
         SW01     # R0 = X             R1 = 0x02            R2 = X               R3 = Seed address
         SW23     # R0 = X             R1 = 0x02            R2 = Seed address    R3 = X
         SW12     # R0 = X             R1 = Seed address    R2 = 0x02            R3 = X
         SUB      # R0 = NOT address   R1 = Seed address    R2 = 0x02            R3 = X
         SW01     # R0 = Seed address  R1 = NOT address     R2 = 0x02            R3 = X
         SW12     # R0 = Seed address  R1 = 0x02            R2 = NOT address     R3 = X
         SW23     # R0 = Seed address  R1 = 0x02            R2 = X               R3 = NOT address
         POP      # R0 = Seed address  R1 = 0x02            R2 = NOT Seed        R3 = NOT address
         STW      # R0 = Seed address  R1 = 0x02            R2 = X               R3 = NOT address
 

         # NOT Seed stored in 0xEE
         # Seed stored in 0xF0




      PO   PC     # End of loop
           
           
           
           
           
           
           
           
           
           
           
        
        
