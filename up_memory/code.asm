# -------------Init table 
30          #  R0
30          #  R1
80          #  R2
60          #  R3


      # Setup 
      STW            # 0x80 @ 0x60
      SW12
      SW23
      SW12
      STW            # 0x80 @ 0x30 
      INT
          

      # Main Loop
      PUSHC          # Prep jump back
     
      REF
      SW01
      SW12
      REF
      SW01
      ADD
      SW01
      SW12
      SW23
      LDW            # Contents of 0x40 in R2

      REF
      SW01
      SW12
      SW23
      LDW            # Contents of 0x20 in R2
                     # Contents of 0x40 in R1

      SW23
      POP
      SW23
      BE             # Jump back if contents equal
      SW23
      PUSH           # Did not jump so build stack

      REF
      SW01
      SW12
      REF
      SW01
      ADD
      SW01
      SW12
      SW23
      STW
      POPC


ISR
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
      SW23
      LDW      # Contents of 0x20 in R2
      REF
      SW01
      ADD
      SW01
      SW12
      STW      # Add 0x20 and write back
      
      POP      # Build all regs
      SW12
      SW01
      POP
      SW12
      POP
      SW23
      POP
      POPC     # RET
