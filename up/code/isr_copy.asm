# -------------Init table 
A1          #  R0 
21          #  R1 
00          #  R2
A0          #  R3


      INT
   
      # Loop
      PUSHC
      
      LDW         # 0xA0

      SW23
      PUSH        # Stash 0xA0
      SW23
      PUSH        # Stash value iin 0xA0

      REF
      SW01
      SW12
      SW23
      LDW         # 0xA1

      SW01
      SW12
      SW23        # Jump address in R3

      POP
      BE

#LABEL: Copy
     
      SW23        # R1 back in place 
      SW12        
      SW23        # Hide while pop
      POP
      SW23        # Write new value to location
      STW         
      REF         # Restore R0
      
      POPC

#LABEL:Do not copy

      SW23
      SW12        # R1 back in place
      POP
      SW23        # R3
      REF         # R0
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
