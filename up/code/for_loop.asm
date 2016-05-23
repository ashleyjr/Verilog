# -------------Init table 
0A          #  R0
00          #  R1 
01          #  R2
13          #  R3



      PUSHC

      # 10 times for loop

      PUSHC
      ADD
      SW01     # Add one to R1
      REF      # Bring back top stop
      SW12
      SW01
      BE       # Branch is at top
      SW01
      SW12
      POPC
#LABEL:OutLoop
      SW01
      SW12
           

      SUB
      SW01
      SUB
      SW01
      SUB
      SW01 
      SUB
      SW01
      SUB
      SW01
      SUB
      SW01
      SUB
      SW01
      SUB
      SW01
      SUB
      SW01
      SUB
      SW01
      REF
      POPC
