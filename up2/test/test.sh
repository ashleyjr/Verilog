run_test()
{
    TEST=$1
    RUNS=$2
    RUNME="./../model/up2Run.py -g -i ../programs/$TEST.up2 -o $TEST.hex --runs $RUNS --verbosity "LAST" | diff -a --suppress-common-line -y $TEST.expected -"
    echo "$RUNME"
    eval $RUNME
}

run_test "mem" "200"
run_test "loop" "100"
