run_test()
{
    TEST=$1
    RUNS=$2
    DATA=$3
    ADDR=$4
    VERB=$5
    TRAIL=$6
    RUNME="./../model/up2Run.py -g -i ../programs/$TEST.up2 -o $TEST.hex --runs $RUNS --data_nibbles $DATA --address_nibbles $ADDR --verbosity "$VERB" $TRAIL | diff -a --suppress-common-line -y $TEST.expected -"
    echo "$RUNME"
    PASS=$(eval $RUNME)
    if [ "$PASS" == "" ]
    then
        echo "PASS"
    else
        echo $PASS
        echo "FAIL"
        exit 1
    fi
}

run_test "mem"      "200"   "1"     "1"     "LAST"  ""
run_test "mem_2"    "8000"  "2"     "2"     "LAST"  ""
run_test "loop"     "100"   "1"     "1"     "LAST"  ""
run_test "imm"      "1000"  "1"     "1"     "ALL"   "| grep \"RET\" | grep -o \"R2=0x..\""

