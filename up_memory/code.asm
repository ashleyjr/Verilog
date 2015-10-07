# -------------Init table 
01          #  R0 - Jump back
3F          #  R1 - First function
42          #  R2 - Second function
7F          #  R3 - Address if variable

      # Setup
      STW         # R2 @ 0x7F
            

      SW12
      SW23



      # Loop
      PUSHC






      # Jump to address in R3
      # All other regs to be saved
      PUSH
      SW12
      PUSH
      SW01
      SW12
      PUSH

      REF
      SW01
      SW12
      REF
      SW01
      SW23
      PUSHC
      SW23
      BE
      SW23
      POP

      POP
      SW12
      SW01
      POP
      SW12
      POP


      SW12
      SW23



      # Jump to address in R3
      # All other regs to be saved
      PUSH
      SW12
      PUSH
      SW01
      SW12
      PUSH

      REF
      SW01
      SW12
      REF
      SW01
      SW23
      PUSHC
      SW23
      BE
      SW23
      POP

      POP
      SW12
      SW01
      POP
      SW12
      POP


      SW23
      SW12


      POPC



# Function 1 - 

      ADD
      SW01
      POPC




# Function 2 - 

      ADD
      SW01
      POPC
