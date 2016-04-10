# -------------Init table 
01          #  R0 
FE          #  R1 
00          #  R2
7E          #  R3


      LDW      # Read mem map data in to R2           
      SW12
      SW23
      SW12
      STW      # Store data from mem map at 0x7E 
