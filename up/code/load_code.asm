# -------------Init table 
01          #  R0 
FE          #  R1 
FF          #  R2
7F          #  R3

      
      # Loop
      PUSHC
               # Load addr in R3, store addr in R1
      LDW      # Read mem map data in to R2           
      SW12     # Load addr in R3, store addr in R2, data in R1
      SW23     # Load addr in R2, store addr in R3, data in R1
      SW12     # Load addr in R1, store addr in R3, data in R2
      STW      # Store data
      SW23     # Load addr in R1, store addr in R2, data in R3
      SW12     # Load addr in R2, store addr in R1, data in R3
      SW23     # Load addr in R3, store addr in R1, data in R2
      SW01     # Load addr in R3, store addr in R0, data in R2, 1 in R1
      SW12     # Load addr in R3, store addr in R0, data in R1, 1 in R2
      SW01     # Load addr in R3, store addr in R1, data in R0, 1 in R2
      SUB      # Load addr in R3, store addr in R1, store addr - 1 in R0, 1 in R2
      SW12     # Load addr in R3, store addr in R2, store addr - 1 in R0, 1 in R1
      SW01     # Load addr in R3, store addr in R2, store addr - 1 in R1, 1 in R0
      POPC
