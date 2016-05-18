# -------------Init table 
02          #  R0 - Multiply by 2 to shift left
02          #  R1
01          #  R2 - Seed
F0          #  R3 - Stash address

      # Setup
      STW      # Place seed in stash address


 
      # Loop
      PUSHC    # Start of oop
          
         LDW      # R0 = 0x02             R1 = 0x02               R2 = Seed               R3 = Seed address
         MUL      # R0 = Seed << 1        R1 = 0x02               R2 = Seed               R3 = Seed address
         PUSH     # R0 = Seed << 1        R1 = 0x02               R2 = X                  R3 = Seed address
         SW01     # R0 = 0x02             R1 = Seed << 1          R2 = X                  R3 = Seed address
         SW12     # R0 = 0x02             R1 = X                  R2 = Seed << 1          R3 = Seed address
         SW01     # R0 = X                R1 = 0x02               R2 = Seed << 1          R3 = Seed address
         MUL      # R0 = Seed << 2        R1 = 0x02               R2 = Seed << 1          R3 = Seed address
         SW01     # R0 = 0x02             R1 = Seed << 2          R2 = Seed << 1          R3 = Seed address
         SW12     # R0 = 0x02             R1 = Seed << 1          R2 = Seed << 2          R3 = Seed address
         PUSH     # R0 = 0x02             R1 = Seed << 1          R2 = X                  R3 = Seed address

         # Stack = Seed, Seed << 2

         SW01     # R0 = Seed << 1        R1 = 0x02               R2 = X                  R3 = Seed address
         SW12     # R0 = Seed << 1        R1 = X                  R2 = 0x02               R3 = Seed address
         REF      # R0 = 0x02             R1 = X                  R2 = 0x02               R3 = Seed address
         SW01     # R0 = X                R1 = 0x02               R2 = 0x02               R3 = Seed address
         SUB      # R0 = 0x00             R1 = 0x02               R2 = 0x02               R3 = Seed address
         SW01     # R0 = 0x02             R1 = 0x00               R2 = 0x02               R3 = Seed address
         NAND     # R0 = 0xFF             R1 = 0x00               R2 = 0x02               R3 = Seed address
         SW01     # R0 = 0x00             R1 = 0xFF               R2 = 0x02               R3 = Seed address
         POP      # R0 = 0x00             R1 = 0xFF               R2 = Seed << 2          R3 = Seed address
         NAND     # R0 = ~(Seed << 2)     R1 = 0xFF               R2 = Seed << 2          R3 = Seed address
         PUSH     # R0 = ~(Seed << 2)     R1 = 0xFF               R2 = X                  R3 = Seed address
         SW01     # R0 = 0xFF             R1 = ~(Seed << 2)       R2 = X                  R3 = Seed address
         SW12     # R0 = 0xFF             R1 = X                  R2 = ~(Seed << 2)       R3 = Seed address
         PUSH     # R0 = 0xFF             R1 = X                  R2 = X                  R3 = Seed address

         # Stack = Seed, Seed << 2, ~(Seed << 2)

         
         PUSH     # R0 = 0x02             R1 = X                  R2 = X                  R3 = Seed address
         SW01     # R0 = X                R1 = 0x02               R2 = X                  R3 = Seed address
         SW12     # R0 = X                R1 = X                  R2 = 0x02               R3 = Seed address
         REF      # R0 = 0x02             R1 = X                  R2 = 0x02               R3 = Seed address
         SW01     # R0 = X                R1 = 0x02               R2 = 0x02               R3 = Seed address
         SUB      # R0 = 0x00             R1 = 0x02               R2 = 0x02               R3 = Seed address
         SW01     # R0 = 0x02             R1 = 0x00               R2 = 0x02               R3 = Seed address
         NAND     # R0 = 0xFF             R1 = 0x00               R2 = 0x02               R3 = Seed address
         SW01     # R0 = 0x00             R1 = 0xFF               R2 = 0x02               R3 = Seed address
         POP      # R0 = 0x00             R1 = 0xFF               R2 = Seed               R3 = Seed address
         NAND     # R0 = NOT Seed         R1 = 0xFF               R2 = Seed               R3 = Seed address
         PUSH     # R0 = NOT Seed         R1 = 0xFF               R2 = X                  R3 = Seed address
         SW01     # R0 = 0x02             R1 = NOT Seed           R2 = X                  R3 = Seed address
         SW12     # R0 = 0x02             R1 = X                  R2 = NOT Seed           R3 = Seed address
         SW01     # R0 = X                R1 = 0x02               R2 = NOT Seed           R3 = Seed address
         MUL      # R0 = (NOT Seed << 2)  R1 = 0x02               R2 = NOT Seed           R3 = Seed address

         
         SW12     # R0 = NOT Seed      R1 = Seed            R2 = 0xFF            R3 = Seed address
         PUSH     # R0 = NOT Seed      R1 = Seed            R2 = X               R3 = Seed address
         SW12     # R0 = NOT Seed      R1 = X               R2 = Seed            R3 = Seed address
         SW01     # R0 = X             R1 = NOT Seed        R2 = Seed            R3 = Seed address
         NAND     # R0 = NS NAND S     R1 = NOT Seed        R2 = Seed            R3 = Seed address
         SW01     # R0 = NOT Seed      R1 = NS NAND S       R2 = Seed            R3 = Seed address
         POP      # R0 = NOT Seed      R1 = NS NAND S       R2 = 0xFF            R3 = Seed address
         NAND     # R0 = NS AND S      R1 = NS NAND S       R2 = 0xFF            R3 = Seed address 
         SW01     # R0 = NS NAND S     R1 = NS AND S        R2 = 0xFF            R3 = Seed address 
         SW12     # R0 = NS NAND S     R1 = 0xFF            R2 = NS AND S        R3 = Seed address 
         STW      # R0 = NS NAND S     R1 = 0xFF            R2 = X               R3 = Seed address
         REF      # R0 = 0x02          R1 = 0xFF            R2 = X               R3 = Seed address



      PO   PC     # End of loop
           
           
           
           
           
           
           
           
           
           
           
        
        
