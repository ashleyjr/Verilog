# -------------Init table 
01          #  R0 - Jump back
1E          #  R1 - First function
00          #  R2 - Blank
7F          #  R3 - Address if variable

      # Setup
      STW         # R2 @ 0x7F
            
      # Loop
      PUSHC

      PUSHC
      POP
      SW01
      ADD
      SW01
      SW12
      PUSH
      POPC
      SW12





      POPC


# Function 1 - 

      PUSH
      SW23
      PUSH
      SW12
      PUSH
      SW01
      SW12
      PUSH        # Subroutine code

      POP
      SW12
      SW01
      POP
      SW12
      POP
      SW23
      POP
      POPC

# Function 2 - 

      PUSH
      SW23
      PUSH
      SW12
      PUSH
      SW01
      SW12
      PUSH        # Subroutine code

      POP
      SW12
      SW01
      POP
      SW12
      POP
      SW23
      POP
      POPC

# Function 3 - 

      PUSH
      SW23
      PUSH
      SW12
      PUSH
      SW01
      SW12
      PUSH        # Subroutine code

      POP
      SW12
      SW01
      POP
      SW12
      POP
      SW23
      POP
      POPC
