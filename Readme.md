# Agec

Note, that Agec is licensed under the [MIT License](https://github.com/tos-kamiya/agec/blob/master/agec-license).


Run [Agec](https://github.com/tos-kamiya/agec) on a supplied folder.
As Agec has to compile all java files in order to obtain a jar, it is up to you to ensure their compatibility (the docker container is build with openjdk-18).
Only sources that can be compiled, can be analyzed.

**Build** using the [`makefile`](makefile).
**Run** using the [run-script](run.sh) script, supply it with the project folder.

> As only the `pwd` (current working directory) will be mounted automatically, you can not specify files/folders located in upper levels.

Example:

```bash
make
./run.sh java-small
```

Due to Agecs' way of presenting information, you have to use the logging output in order to obtain clones (therefore, the runner script re-runs certain phases with the diagnostic mode).
Therefore, we recommand redirecting the output into a file to allow subsequent analysis (output is separated by `=====`-blocks).
