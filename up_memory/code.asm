# -------------Init table 
02          #  R0
80          #  R1
40          #  R2
00          #  R3

      # ----- Store 0x00 at 0x80
      SW23
      SW12
      STW
      # ------ Interupts now on
      INT
      # ----- Get PC, sub then return 
      PUSHC    # Prep jump
      LDW
      REF
      SW01
      SW12
      SUB
      SW01
      SW12
      STW
      POPC
      # ----- Jump back


ISR
      INT      # INterrupts off
      PUSH
      SW23
      PUSH
      SW12
      PUSH
      SW01
      SW12
      PUSH     # Stash all regs
      REF
      SW01
      SW12
      REF
      SW01
      MUL
      SW01
      MUL
      SW01
      MUL
      SW01
      MUL
      SW01
      MUL
      SW01
      SW12
      SW23
      LDW      # Load contents of 0x40 in R2
      SW23
      PUSH     # Keep the address for later
      REF
      SW01
      SW12
      REF
      SW01
      NAND     # NAND of R1 = R2 therefore not. R0 = 0xFD
      SW01
      ADD      # 0xFF = 0x02 + 0xFD
      SW01
      ADD      # 0x01 = 0x02 + 0xFF
      SW01
      SW23     
      ADD      # Contents of 0x80 + 0x01 in R0
      SW01
      SW12
      SW23     # Hold inc value in R3
      POP      # Get address back
      SW23     # 0x80 in R3 and inc value in R2
      STW
      INT      # Interrupts back on
      POP      # Build all regs
      SW12
      SW01
      POP
      SW12
      POP
      SW23
      POP
      POPC
