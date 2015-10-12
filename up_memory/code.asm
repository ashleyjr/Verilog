# -------------Init table 
A1          #  R0 
00          #  R1 
A0          #  R2
A0          #  R3


      INT
   
      # Loop
      PUSHC
      
      LDW         # 0xA0

      SW23
      PUSH        # Stash 0xA0
      SW23
      PUSH        # Stash value in 0xA0

      REF
      SW01
      SW12
      SW23
      LDW         # 0xA1

      SW23
      POP         
      BE          


LABEL: No ADD
      POP         # restore
      SW23
      POP
      SW23

      POPC


ISR
      PUSH
      SW23
      PUSH
      SW12
      PUSH
      SW01
      SW12
      PUSH        # Stash

      REF
      SW01
      SW12
      REF
      SW01
      SUB
      SW01
      NAND        # 0xFF in R0

      SW01
      SW12
      REF
      SW01
      SW12
      SW23
      LDW
      SW12
      SUB         # Contents of A1 + 1 in R0

      SW01
      SW12
      STW         # Go back to mem A1

      POP         # Restore
      SW12
      SW01
      POP
      SW12
      POP
      SW23
      POP

      POPC