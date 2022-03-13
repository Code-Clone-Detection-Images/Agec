#!/usr/bin/env bash
BUILD_DIR=../build
echo "Running on $1"
cd "$1"

echo "Step 1: produce and disassemble java jar files"
echo "     1.1: prepare all java files"
# we do have a major problem. The java files have to compile. Although they are from different people in
# different folders and packages, using different java versions and which may reference other files
# in the same folder

# first of all, we remove *all* package statements:
# for f in $(find -name "*.java"); do
#    sed 's/package .*;//' -i $f
# done

echo "     1.2: compile java files"
echo $(find -name "*.java")
javac -d "$BUILD_DIR" $(find -name "*.java")
# undocumented :/
echo "     1.3: produce classlist"
cd "$BUILD_DIR"
ls *.class > "$HOME/classlist.lst"
echo "     1.4: produce jar"
set -eu
jar cvf "$HOME/Classify.jar" *


echo "     1.5: disassemble jar"
python2 "$AGEC_HOME/src/run_disasm.py" "$HOME/Classify.jar" "$HOME/classlist.lst" -o "$HOME/disassembled"

echo "Step 2: Generate ngram"
python2 "$AGEC_HOME/src/gen_ngram.py" --asm-directory "$HOME/disassembled" > "$HOME/ngram.txt"

echo "Step 3: Detect clones in ngram"
python2 "$AGEC_HOME/src/det_clone.py" "$HOME/ngram.txt" > "$HOME/clone_index.txt"

echo "Step 4: Decode clones"
python2 "$AGEC_HOME/src/tosl_clone.py" --asm-directory "$HOME/disassembled" "$HOME/clone_index.txt" > "$HOME/clones.txt"

echo "Step 5: Calculate clone metrics"
python2 "$AGEC_HOME/src/exp_clone.py" --asm-directory "$HOME/disassembled" "$HOME/clone_index.txt" --loc-to-trace --add-metric-clat --add-metric-max-depth > "$HOME/exp_clones.txt"

echo "Step 6: Cleanup"
rm -rf "$BUILD_DIR"

echo "=====Clones detected:====="
cat "$HOME/clones.txt"

echo "=====Clone metrics:====="
cat "$HOME/exp_clones.txt"