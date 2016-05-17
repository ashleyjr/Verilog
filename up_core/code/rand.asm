# -------------Init table 
7E          #  R0
02          #  R1
01          #  R2 - Seed
7F          #  R3 - Stash address

      # Setup
      STW      # Place seed in stash address
     
      # Loop
      PUSHC
      LDW      # Get the current value
      MUL      # Shift left (multiply by 2)
      SW01
      SW12
      STW      # Store the result in stash address
      SW01     # Get 0x02 back in R1
      POPC
