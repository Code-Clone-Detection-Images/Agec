#!/usr/bin/env bash

BUILD_DIR=../build
cd "$HOME/test"

echo "Step 1: produce and disassemble java jar files"
echo "     1.1: comile java files"
javac -d "$BUILD_DIR" *.java
# undocumented :/
echo "     1.2: produce classlist"
cd "$BUILD_DIR"
ls > "$HOME/classlist.lst"
echo "     1.3: produce jar"
jar cvf Classify.jar *
echo "     1.4: link javap for disassembler"
ln -s "$(which javap)" "/usr/bin/javap" # path is hardcoded
echo "     1.5: disassemble jar"
python2 "$AGEC_HOME/src/run_disasm.py" Classify.jar "$HOME/classlist.lst" -o "$HOME/disassembled"

echo "Step 2: Generate ngram"
python2 "$AGEC_HOME/src/gen_ngram.py" --asm-directory "$HOME/disassembled" > ngrams.txt

echo "Step 3: Detect clones in ngram"
python2 "$AGEC_HOME/src/det_clone.py" ./ngrams.txt > clone_index

echo "Step 4: Decode clones"
python2 "$AGEC_HOME/src/tosl_clone.py" --asm-directory "$HOME/disassembled" ./clone_index > "$HOME/clones.txt"

echo "=====Clones detected:====="
cat "$HOME/clones.txt"
