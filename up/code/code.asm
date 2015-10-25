# -------------Init table 
01          #  R0 
00          #  R1 
00          #  R2
A0          #  R3


  
      STW         # A0 = 0x00
      
      
      # Loop
      PUSHC
      
      LDW         # 0xA0
     
      REF
      SW01
      ADD
      SW01
      SW12

      STW         # A0 = A0 + 1
      
      POPC


