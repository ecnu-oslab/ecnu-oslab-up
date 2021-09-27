# Project 0a: Linux Warm Up


## Objective

This project will help you getting familiar with Linux.
We will try to cover those most related topics to labs.
However, mastering \*nix requires years of practice,
thus we also encourage you to play with it as much as possible.

>"For the things we have to learn before we can do them, we learn by doing them."
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
>― Aristotle, The Nicomachean Ethics



## Overview
The project contains two parts,
- In part 1, you will learn basic commands (cd, cp, ...) and concepts (redirection, pipe, ...) of shell.
- In part 2, you will practice with Linux C programming environment (gcc compiler, gdb debugger, text editors).


## Readings

OSTEP [Lab Tutorial](http://pages.cs.wisc.edu/~remzi/OSTEP/lab-tutorial.pdf)

## Program Specifications

### Part 1
You need to write four shell scripts, all of them should be executable in a Linux shell.

**info.sh**

```
$ ./info.sh foo
```
The script does the following:

1. first builds a new directory `foo` in the current directory (the one contains `info.sh`).
2. then creates two files: `name.txt` containing your name; `stno.txt` containing your student number. 
3. Finally, it makes a copy of `name.txt` and `stno.txt` in the same directory of `foo` , name the copied file whatever you like.

**myls.sh**

```
$ ./myls.sh
```

Write an `ls` command with some additional options in `myls.sh` that lists files in the following manner:

- Includes all files, including hidden files.
- Sizes are listed in human readable format (e.g. 454M instead of 454279954)
- Files are ordered by recency, i.e. sort by last modified date and time. The latest modified comes the first.
- Output is colorized for directories, executables, etc.

**find.sh**

```
$ ./find.sh
```
It generates a text file `output`. Each row of `output` represents a file in directory `/bin`, and contains three fields which are name, owner and permission of that file. The fields should be separated by white spaces. Furthermore,

- All file names in `output` should start with letter "b" (other files should be excluded)
- The file `output` is sorted by the file name field (in order of alphabet, from small to large)
- The file `output` is read only for other users

Here is an example output

```
bacman root -rwxr-xr-x
badblocks root -rwxr-xr-x
baobab root -rwxr-xr-x
base64 root -rwxr-xr-x
basename root -rwxr-xr-x
bash root -rwxr-xr-x
bashbug root -r-xr-xr-x
bayes.rb root -rwxr-xr-x
bbox root -rwxr-xr-x
```

**dbg.sh**

Say you have a command that fails rarely. In order to debug it you need to capture its output but it can be time consuming to get a failure run. 

First, create a bash script `worker.sh` containing the following code. It picks a random number and exit with an error code 1 if n equals 42, otherwise, the script returns safely with exit code 0. Note that the error occurs with a probability of only 1%.

```bash
 #!/bin/bash
 
 n=$(( RANDOM % 100 ))

 if [[ n -eq 42 ]]; then
    echo "Something went wrong"
    >&2 echo "Error code 42: answer unknown"
    exit 1
 fi

 echo "All good"
```

You should write a bash script `dbg.sh` . It runs `worker.sh` repeatedly until it fails. Captures its standard output and error streams to files.

*Bonus:*

Try to report how many runs it took for the script to fail. You can report that amount in any form.

### Part 2

We have a C program [set_operation.c](set_operation.c), which contains several implementation bugs. You will first try to compile/run the program, then detect and correct the bugs using the gdb debugger. 

- set_operation.c computes <img src="https://render.githubusercontent.com/render/math?math=(A-B)\cup(B-A)"> , where <img src="https://render.githubusercontent.com/render/math?math=A"> and <img src="https://render.githubusercontent.com/render/math?math=B"> are two sets input by users.
- The algorithm is simple:
  - copy <img src="https://render.githubusercontent.com/render/math?math=A"> to a temporary set <img src="https://render.githubusercontent.com/render/math?math=A_2"> 
  - compute <img src="https://render.githubusercontent.com/render/math?math=A=A-B"> and <img src="https://render.githubusercontent.com/render/math?math=B=B-A_2"> 
  - union <img src="https://render.githubusercontent.com/render/math?math=A"> and <img src="https://render.githubusercontent.com/render/math?math=B">
- There are two sub-functions: output and check
  - "output" is used to output all elements in a linked list
  - "check" is used to check if an integer belongs to a linked list

A correct (bug-free) output should be:
```
---------------------------------
----Computing (A-B)union(B-A)----
---------------------------------
----input the number of elements of A: 3
1-th element: 3
2-th element: 4
3-th element: 5
----input the number of elements of B: 2
1-th element: 1
2-th element: 4
---- elements of (A-B)union(B-A) ----
1-th element: 3
2-th element: 5
3-th element: 1
```

## Hints

### Part 1

* In **info.sh**, you can use `echo` and redirection to output some texts into a file. You are doing this in a script, which means you are not able to vim into the files and manually modify them.
* In **myls.sh** or any other circumstances, the `man` program is your friend. Or you may try `tldr` which can be installed by `pip`.
* In **find.sh**, you may use `xargs` (between `find` and `ls`) or pipe. To sort the data, see command `sort`.
* In **dbg.sh**, try to do loops with either for, while or until. Note that you can use `$?` to capture the error code of the last command.
* Print some information for debugging. 

### Part 2
* Set breakpoints around important statements (e.g., loop, if) 
* Print out values of variables (e.g., loop variables, contents of pointers).

## Hand In 

- The four script files **info.sh** , **myls.sh** , **find.sh** and **dbg.sh**
- The source file **set_operation.c** after debugging.
- A lab report **README.md** contains:
    - A simple introduction of your project 
    - For part 1, explain the shell commands in your scripts (e.g., usage, options).
    - For part 2, explain the meaning of gcc options for compiling your program. Explain the detailed process of debugging (where are your breakpoints located, which variables you've watched, etc.) and the bugs you found.
    - Try to use **Typora** if you are new to markdown. You can also use other formats like doc or pdf, but they are not recommended.
- Keep your report concise and neat. An extremely verbose report will NOT be accepted.

## General Advice

Try to use and get familiar with the shell commands first. Make good use of "man", "help" and "--help".

Start small, and get things working incrementally. For example, you can try to write some sub-functions in your script first, then test them before you combine them together. For debugging, you could build several test cases, and see why the running process of the program is different from your expectation.

