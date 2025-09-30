#!/bin/bash

TEST_DIR="tests"
OUT_DIR="out"

# Prepare testing directory
prepare_directories() {
    mkdir -p $TEST_DIR
    rm -r $TEST_DIR
    mkdir -p $TEST_DIR

    mkdir -p $OUT_DIR
    rm -r $OUT_DIR
    mkdir -p $OUT_DIR
}


# Test -f
prepare_directories

mkdir -p $TEST_DIR/a/
mkdir -p $TEST_DIR/a/b/
mkdir -p $TEST_DIR/a/b/c/
mkdir -p $TEST_DIR/a/d/
mkdir -p $TEST_DIR/a/e/
mkdir -p $TEST_DIR/f/

touch $TEST_DIR/a/file01
touch $TEST_DIR/a/file02
touch $TEST_DIR/a/b/file03
touch $TEST_DIR/a/b/file04
touch $TEST_DIR/a/b/c/file05
touch $TEST_DIR/a/b/c/file06
touch $TEST_DIR/a/d/file07
touch $TEST_DIR/a/d/file08
touch $TEST_DIR/a/e/file09
touch $TEST_DIR/a/e/file10
touch $TEST_DIR/f/file11
touch $TEST_DIR/f/file12

./manage.sh -o $OUT_DIR -f $TEST_DIR

if [[ -f "$OUT_DIR/file01" &&
          -f "$OUT_DIR/file02" &&
          -f "$OUT_DIR/file03" &&
          -f "$OUT_DIR/file04" &&
          -f "$OUT_DIR/file05" &&
          -f "$OUT_DIR/file06" &&
          -f "$OUT_DIR/file07" &&
          -f "$OUT_DIR/file08" &&
          -f "$OUT_DIR/file09" &&
          -f "$OUT_DIR/file10" &&
          -f "$OUT_DIR/file11" &&
          -f "$OUT_DIR/file12"
    ]]; then
    echo "-f succeeded: All files exist"
else
    echo "-f failed: At least one file not present"
fi


# Test -e

prepare_directories

mkdir -p $TEST_DIR/a/
mkdir -p $TEST_DIR/a/b/
mkdir -p $TEST_DIR/a/b/c/
mkdir -p $TEST_DIR/a/d/
mkdir -p $TEST_DIR/a/e/
mkdir -p $TEST_DIR/f/

touch $TEST_DIR/a/file01.aaa
touch $TEST_DIR/a/file02.aab
touch $TEST_DIR/a/b/file03.aac
touch $TEST_DIR/a/b/file04.aba
touch $TEST_DIR/a/b/c/file05.abb
touch $TEST_DIR/a/b/c/file06.abc
touch $TEST_DIR/a/d/file07.aca
touch $TEST_DIR/a/d/file08.acb
touch $TEST_DIR/a/e/file09.acc
touch $TEST_DIR/a/e/file10.baa
touch $TEST_DIR/f/file11.bab
touch $TEST_DIR/f/file12.bac

OUTPUT=$(./manage.sh -e $TEST_DIR)

if [[ $(echo $OUTPUT) == "1 .aaa 1 .aab 1 .aac 1 .aba 1 .abb 1 .abc 1 .aca 1 .acb 1 .acc 1 .baa 1 .bab 1 .bac" ]]; then
    echo "-e succeeded: All files found"
else
    echo "-e failed: At least one file extension was missing"
fi


# Test -n

prepare_directories

mkdir -p $TEST_DIR/a/
mkdir -p $TEST_DIR/a/b/
mkdir -p $TEST_DIR/a/b/c/
mkdir -p $TEST_DIR/a/d/
mkdir -p $TEST_DIR/a/e/
mkdir -p $TEST_DIR/f/

touch $TEST_DIR/a/file01.aaa
touch $TEST_DIR/a/file02.aab
touch $TEST_DIR/a/b/file03.aac
touch $TEST_DIR/a/b/file04.aba
touch $TEST_DIR/a/b/c/file05.abb
touch $TEST_DIR/a/b/c/file06.abc
touch $TEST_DIR/a/d/file07.aca
touch $TEST_DIR/a/d/file08.acb
touch $TEST_DIR/a/e/file09.acc
touch $TEST_DIR/a/e/file10.baa
touch $TEST_DIR/f/file11.bab
touch $TEST_DIR/f/file12.bac

OUTPUT=$(./manage.sh -n $TEST_DIR)

if [[ $(echo $OUTPUT) == "1 a 1 b 1 c 1 d 1 e 1 f 1 file01.aaa 1 file02.aab 1 file03.aac 1 file04.aba 1 file05.abb 1 file06.abc 1 file07.aca 1 file08.acb 1 file09.acc 1 file10.baa 1 file11.bab 1 file12.bac 1 tests" ]]; then
    echo "-n succeeded: All files found"
else
    echo "-n failed: At least one filename was missing"
fi


# Test -c

prepare_directories

mkdir -p $TEST_DIR/a/
mkdir -p $TEST_DIR/a/b/
mkdir -p $TEST_DIR/a/b/c/
mkdir -p $TEST_DIR/a/d/
mkdir -p $TEST_DIR/a/e/
mkdir -p $TEST_DIR/f/

touch $TEST_DIR/a/file01
touch $TEST_DIR/a/file02
touch $TEST_DIR/a/b/file03
touch $TEST_DIR/a/b/file04
touch $TEST_DIR/a/b/c/file05
touch $TEST_DIR/a/b/c/file06
touch $TEST_DIR/a/d/file07
touch $TEST_DIR/a/d/file08
touch $TEST_DIR/a/e/file09
touch $TEST_DIR/a/e/file10
touch $TEST_DIR/f/file11
touch $TEST_DIR/f/file12

./manage.sh -o $OUT_DIR -c ".*1.*" $TEST_DIR

if [[ -f "$OUT_DIR/file01" &&
          -f "$OUT_DIR/file10" &&
          -f "$OUT_DIR/file11" &&
          -f "$OUT_DIR/file12"
    ]]; then
    echo "-c succeeded: All files exist"
else
    echo "-c failed: At least one file not present"
fi


# Test -d

prepare_directories

mkdir -p $TEST_DIR/a/
mkdir -p $TEST_DIR/a/b/
mkdir -p $TEST_DIR/a/b/c/
mkdir -p $TEST_DIR/a/d/
mkdir -p $TEST_DIR/a/e/
mkdir -p $TEST_DIR/f/

touch $TEST_DIR/a/file01
touch $TEST_DIR/a/file02
touch $TEST_DIR/a/b/file03
touch $TEST_DIR/a/b/file04
touch $TEST_DIR/a/b/c/file05
touch $TEST_DIR/a/b/c/file06
touch $TEST_DIR/a/d/file07
touch $TEST_DIR/a/d/file08
touch $TEST_DIR/a/e/file09
touch $TEST_DIR/a/e/file10
touch $TEST_DIR/f/file11
touch $TEST_DIR/f/file12

./manage.sh -d ".*1.*" $TEST_DIR

if [[ ! (-f "$TEST_DIR/file01" &&
          -f "$TEST_DIR/a/e/file10" &&
          -f "$TEST_DIR/f/file11" &&
          -f "$TEST_DIR/f/file12")
    ]]; then
    echo "-d succeeded: All files deleted"
else
    echo "-d failed: At least one file still present"
fi


# Test -t

prepare_directories

mkdir -p $TEST_DIR/a/
mkdir -p $TEST_DIR/a/b/
mkdir -p $TEST_DIR/a/b/c/
mkdir -p $TEST_DIR/a/d/
mkdir -p $TEST_DIR/a/e/
mkdir -p $TEST_DIR/f/

touch $TEST_DIR/a/file01
touch $TEST_DIR/a/file02
touch $TEST_DIR/a/b/file03
touch $TEST_DIR/a/b/file04
touch $TEST_DIR/a/b/c/file05
touch $TEST_DIR/a/b/c/file06
touch $TEST_DIR/a/d/file07
touch $TEST_DIR/a/d/file08
touch $TEST_DIR/a/e/file09
touch $TEST_DIR/a/e/file10
touch $TEST_DIR/f/file11
touch $TEST_DIR/f/file12

./manage.sh -t ".*1.*" $TEST_DIR

if [[ -f $(realpath ~/.local/share/Trash/file01) &&
          -f $(realpath ~/.local/share/Trash/file10) &&
          -f $(realpath ~/.local/share/Trash/file11) &&
          -f $(realpath ~/.local/share/Trash/file12)
    ]]; then
    echo "-t succeeded: All files trashed"
else
    echo "-t failed: At least one file still present"
fi


# Test -m

prepare_directories

mkdir -p $TEST_DIR/a/
mkdir -p $TEST_DIR/a/b/
mkdir -p $TEST_DIR/a/b/c/
mkdir -p $TEST_DIR/a/d/
mkdir -p $TEST_DIR/a/e/
mkdir -p $TEST_DIR/f/

touch $TEST_DIR/a/file01
touch $TEST_DIR/a/file02
touch $TEST_DIR/a/b/file03
touch $TEST_DIR/a/b/file04
touch $TEST_DIR/a/b/c/file05
touch $TEST_DIR/a/b/c/file06
touch $TEST_DIR/a/d/file07
touch $TEST_DIR/a/d/file08
touch $TEST_DIR/a/e/file09
touch $TEST_DIR/a/e/file10
touch $TEST_DIR/f/file11
touch $TEST_DIR/f/file12

./manage.sh -o $OUT_DIR -m ".*1.*" $TEST_DIR

if [[ -f "$OUT_DIR/file01" &&
          -f "$OUT_DIR/file10" &&
          -f "$OUT_DIR/file11" &&
          -f "$OUT_DIR/file12"
    ]]; then
    echo "-m succeeded: All files moved"
else
    echo "-m failed: At least one file still present"
fi
