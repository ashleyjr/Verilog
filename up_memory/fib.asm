# -------------Init table 
7E          #  R0
01          #  R1
00          #  R2
7F          #  R3

      # Setup
      STW      # 0x00 @ 0x7F
      SW01
      SW12
      SW23
      SW01
      SW12
      STW      # 0x01 @ 0x7E  
      SW12
      SW01
      SW23
      SW12
      SW01     # Regs back in the same order as setup table
            
      # Loop
      INT
      PUSHC
      POPC
ISR
      PUSH
      LDW      # 0x7E contents in R2
      SW01
      SW12
      SW23     # Now in R1
      PUSH
      LDW      # 0x7F contents in R2 
      ADD      # New in R0
      SW01
      SW12
      STW      # New stored in 0x7F
      POP
      SW23
      SW12
      SW01
      STW
      POP      # Old stored in 0x7E
      POPC
