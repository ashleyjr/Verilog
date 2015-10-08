# -------------Init table 
F0          #  R0 
90          #  R1 
70          #  R2
51          #  R3



   
      # Loop
      PUSHC
      

      PUSH
      SW23
      PUSH
      SW12
      PUSH
      SW01
      SW12
      PUSH
     
      REF
      SW01
      SW12
      SW23
    
      STW

      POP
      SW12
      SW01
      POP
      SW12
      POP
      SW23
      POP

      
      # Start function call
                  # R0 - Var in/out
                  # R1 - 
                  # R2 -
                  # R3 - Address
      
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

      SW23

      # Start function call
                  # R0 - Var in/out
                  # R1 - 
                  # R2 -
                  # R3 - Address
      
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


      SW12 


      # Start function call
                  # R0 - Var in/out
                  # R1 - 
                  # R2 -
                  # R3 - Address
      
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



# Function - x2 

      SW23
      PUSH        # Stash R3
      
      
      # Start function code

      SW01
      SW12
      SW23        # R0 to R3
      REF
      SW01
      SW12        # REF in R2
      REF
      SW01        # REF in R1
      SUB         # 0x00 in R0
      SW01
      SW23
      ADD         # R2 copy R0
      SW01
      ADD         # Input var x2
 
      # End function code
     
     
      SW01
      SW12
      SW23        # Hide R0 in R3
      REF
      SW01
      SW12        # REF in R2
      REF
      SW01        # REF in R1
      ADD     
      SW23  
      SW12
      SW01        # R3 back in R0
      POP         # Restore R3
      SW23
      POPC        # R1 != R2


# Function - +1 

      SW23
      PUSH        # Stash R3
      
      
      # Start function code

      SW01
      SW12
      SW23        # R0 to R3
      REF
      SW01
      SW12        # REF in R2
      REF
      SW01        # REF in R1
      SUB         # 0x00 in R0
      SW01
      NAND        # 0xFF in R0
      SW01
      SW23
      SW12
      SUB         # Var - 0xFF == Var + 0x01
      
      # End function code
     
     
      SW01
      SW12
      SW23        # Hide R0 in R3
      REF
      SW01
      SW12        # REF in R2
      REF
      SW01        # REF in R1
      ADD     
      SW23  
      SW12
      SW01        # R3 back in R0
      POP         # Restore R3
      SW23
      POPC        # R1 != R2




# Function - -1 

      SW23
      PUSH        # Stash R3
      
      
      # Start function code

      SW01
      SW12
      SW23        # R0 to R3
      REF
      SW01
      SW12        # REF in R2
      REF
      SW01        # REF in R1
      SUB         # 0x00 in R0
      SW01
      NAND        # 0xFF in R0
      SW01
      SW23
      SW12
      ADD         # Var + 0xFF == Var - 0x01
      
      # End function code
     
     
      SW01
      SW12
      SW23        # Hide R0 in R3
      REF
      SW01
      SW12        # REF in R2
      REF
      SW01        # REF in R1
      ADD     
      SW23  
      SW12
      SW01        # R3 back in R0
      POP         # Restore R3
      SW23
      POPC        # R1 != R2




