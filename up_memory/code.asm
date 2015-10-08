# -------------Init table 
22          #  R0 
BB          #  R1 
01          #  R2 - Var
1C          #  R3 - Address x2 function



      SW12
      SW01

      # Loop
      PUSHC



      # Call function

                  # R3 - Address
                  # R0 - Var In/Out
      PUSH        # Stash R2
      SW12
      PUSH        # Stash R1


      SW01
      SW12        # Get R0 out of the way
      REF
      SW01
      SW12
      REF
      SW01        # Force R1 == R2
      PUSHC       # Return to this line
      BE          # Jumps to function first time but need to pass through on return
      POP         # Dummy pop for a return push


      POP         # Resotre R1 
      SW12
      POP         # Restore R2

      # End function call


      POPC



# Function 1 - 

      SW23
      PUSH        # Stash R3

      # The function code

      SW01
      SW12
      SW23
      REF
      SW01
      SW12
      REF
      SW01
      SUB
      SW01
      SW23
      ADD
      SW01
      ADD
      # end


      # --- function code
      SW01
      SW12
      SW23
      REF
      SW01
      SW12
      REF
      SW01
      ADD
      SW23
      SW12
      SW01


      # --- function code

      POP        # Restore R3
      SW23

      POPC



