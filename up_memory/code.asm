# -------------Init table 
02          #  R0
00          #  R1
34          #  INT
00          #  R3
# ----- Store 0x00 at 0x80
SW01       
SW12
REF
SW01
MUL
SW01
MUL
SW01
MUL
SW01
MUL
SW01
MUL
SW01
MUL
SW01
SW12
SW23     # 0x80 in R3
REF
SW01
SW12
REF
SW01
SUB      # 0x00 in R0 
SW01
SW12
STW
# ------ Interupts now on
INT     
# ------ Jump back padding
ADD
ADD
ADD
ADD
ADD
ADD
# ----- Get PC, sub then return 
PUSHC
POP
REF
SW01
SW12
SUB      # Take 2 off PC
SW01
SW12
PUSH
POPC
# ----- Jump back




# ----- Interrupt
INT      # Interrupts off while inside
REF
SW01
SW12
REF
SW01
MUL
SW01
MUL
SW01
MUL
SW01
MUL
SW01
MUL
SW01
MUL
SW01
SW12
SW23
LDW      # Load contents of 0x80 in R2
SW23
REF
SW01
SW12
REF
SW01
NAND     # NAND of R1 = R2 therefore not. R0 = 0xFD
SW01
ADD      # 0xFF = 0x02 + 0xFD
SW01
ADD      # 0x01 = 0x02 + 0xFF
SW01
SW23     
ADD      # Contents of 0x80 + 0x01 in R0
SW01
SW12
SW23     # Hold inc value in R3
REF
SW01
SW12
REF
SW01
MUL
SW01
MUL
SW01
MUL
SW01
MUL
SW01
MUL
SW01
MUL
SW01
SW12
SW23     # 0x80 in R3 and inc value in R2
STW
REF
SW01
SW12
REF
SW01
MUL
SW01
MUL
SW01
MUL
SW01
MUL
SW01
ADD
SW01
ADD
SW01
ADD
SW01
ADD
SW01
SW12     # Jump tp 0x28 
PUSH     
INT      # Interrupts back on
POPC
