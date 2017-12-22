run_test()
{
    TEST=$1
    RUNS=$2
    DATA=$3
    ADDR=$4
    RUNME="./../model/up2Run.py -g -i ../programs/$TEST.up2 -o $TEST.hex --runs $RUNS --data_nibbles $DATA --address_nibbles $ADDR --verbosity "LAST" | diff -a --suppress-common-line -y $TEST.expected -"
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

run_test "mem"      "200"   "1"     "1"
run_test "mem_2"    "8000"  "2"     "2"
run_test "loop"     "100"   "1"     "1"
