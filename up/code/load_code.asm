# -------------Init table 
00                #  R0 
00                #  R1 
00                #  R2
7F                #  R3

      # Loop
      PUSHC
      LDW         # R3 = mem     R2 = data   R1 =        R0 =
      SW12        # R3 = mem     R2 =        R1 = data   R0 =
      LDW         # R3 = mem     R2 = addr   R1 = data   R0 =
      SW23        # R3 = addr    R2 = mem    R1 = data   R0 =
      SW12        # R3 = addr    R2 = data   R1 = mem    R0 =
      STW
      SW12        # R3 = addr    R2 = mem    R1 = data   R0 =
      SW23        # R3 = mem     R2 = addr   R1 = data   R0 =
      POPC
