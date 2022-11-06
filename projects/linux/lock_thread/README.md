# Locks and Condition Variables

## Overview

In this project, you will be getting a feel for threads, locks, condition variables and performance. The first entity you will build is called a spin lock. A spin lock uses some kind of powerful hardware instruction in order to provide mutual exclusion among threads. Then, you may be not satisfied with performances of the simple spin lock, and step further to develop a mutex. With locks in hand, you can build thread-safe versions of three common data structures: counter, list and hash table. Then, you will try to make a nice report by comparing different lock implementations and  concurrency levels. Finally, you will tackle the producer-consumer problem using conditional variables. Ready? Welcome to parallel universes!

## Readings

OSTEP [Chapter 27](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-api.pdf), [Chapter 28](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-locks.pdf), [Chapter 29](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-locks-usage.pdf), [Chapter 30](https://pages.cs.wisc.edu/~remzi/OSTEP/threads-cv.pdf).

## Part 1: Spin Locks

To build a spin lock, you will use the x86 exchange primitive. As this is an assembly instruction, you will need be able to call it from C. Fortunately, gcc conveniently lets you do this without too much trouble: [xchg.c](xchg.c).

For those interested in learning more about calling assembly from C with gcc, see [here](http://www.ibiblio.org/gferg/ldp/GCC-Inline-Assembly-HOWTO.html) (Note that you may need to add the gcc option `-std=gnu99` since your code is no longer in ansi C).

To learn more about this instruction, you should read about it in the Intel assembly instruction manual found [here](http://www.intel.com/assets/pdf/manual/253666.pdf). However, I bet you can figure it out without looking.

The lock you build should define a `spinlock_t` data structure, which contains any values needed to build your lock, and two routines:

```C
spinlock_acquire(spinlock_t *lock)
spinlock_release(spinlock_t *lock)
```

These routine(s) should use the xchg code above as needed to build your spin lock.

## Part 2: Mutex

Mutex is another implementation of a lock which causes threads to sleep rather than spin when the lock is unavailable. Linux provides the system calls named *futex* for this purpose. Want to know details? Go and read its man page.

One difficulty on using futex is that it is a low level lock primitive. The man page says

> Bare futexes are not intended as an easy-to-use abstraction for end-users. (There is no wrapper function for this system call in glibc.)

However, we are not end-users, we are locksmiths! To call futex, [sys_futex.c](sys_futex.c) is a wrapper.

Again, the mutex you build should define a `mutex_t` data structure and two routines:

```C
mutex_acquire(mutex_t *lock)
mutex_release(mutex_t *lock)
```

Hint: starting from the simplest one and refining your mutex step by step.


## Part 3: Using Your Lock

Next, you will use your locks to build three concurrent data structures. The three data structures you will build are a thread-safe counter, list, and hash table.

To build the counter, you should implement the following code:

```C
struct counter_t *counter_new(int value);
void counter_destroy(struct counter_t *c);
int counter_get_value(struct counter_t *c);
void counter_increment(struct counter_t *c);
void counter_decrement(struct counter_t *c);
```

`counter_new` allocates memory and initialize it properly, `counter_destroy` frees the memory. The other three routines do the obvious things. You will make these routines available as a shared library, so that multi-threaded programs can update a shared counter. The library will be called `libcounter.so`

To build the list, you should implement the following routines:

```C
struct list_t *list_new();
void list_destroy(struct list_t *list);
void list_insert(struct list_t *list, int key);
void list_delete(struct list_t *list, int key);
int list_lookup(struct list_t *list, int key);
```

The structure `list_t` should contain whatever is needed to manage the list (including a lock). Don't do anything fancy; just a simple insert-at-head list would be fine. This library will be called `liblist.so`

To build the hash table, you should implement the following code:

```C
struct hash_t *hash_new(int size);
void hash_destroy(struct hash_t *hash);
void hash_insert(struct hash_t *hash, int key);
void hash_delete(struct hash_t *hash, int key);
int *hash_lookup(struct hash_t *hash, int key);
```

The only difference from the list interface is that the user can specify the number of buckets in the hash table. Each bucket should basically contain a list upon which to store elements. This library will be called `libhash.so`
The hash table should simply use one list per bucket. How can you make sure to allow as much concurrency as possible during accesses to the hash table?

## Part 4: Comparing Performance

Then, you will write up a report on some performance comparison experiments. Specifically, you will 

* Compare the performance of **your locks** versus the performance of pthread locks
* Compare different implementations of **your locks** (spin lock versus mutex, different mutex)
* Compare the fairness of **your locks**
* If your locks have parameters (e.g., two-phrase locks), how parameters influence the performances of your locks?
* Give some analysis for each experiment. Why you can observe the result? What cause the performance difference? 
* ...

<!--
You will do this for each of your data structures (counter, list, hash table). 
-->
You can do this only for hash table. 

The result of comparison should be presented accurately and clearly. Figures and tables are required. For example, you can give such an figure that along the x-axis, you vary the number of threads contending for the data structure, while the y-axis will plot how long it took all of the threads to finish running. The figure might look like this:

![](http://pages.cs.wisc.edu/~remzi/Classes/537/Spring2010/Projects/data.jpg)

where points represent running time (y-axis) of a lock implementation on
an operation (say, 100000 `hash_lookup` calls) with respect to the number of threads.

You could also study the following problem,
* Given a bucket size, how your hash table performs when conducting only one type of operations (`hash_lookup`, `hash_insert`, or `hash_delete`) 
* Given a bucket size, how your hash table performs when conducting both `hash_lookup` and  `hash_insert` 
* A hash table scaling test - this test should fix the number of threads (say at 20) and vary the number of buckets
* ...


<!--
This graph plots the average performance of many threads updating a shared counter: each thread would call `counter_increment(&counter)` in a loop max times.

For this experiment, max was set to 1000000, and each curve in the figure shows the performance of either using your own spin lock or a pthreads lock inside the counter library.
-->

<!--
Similar plots should be made for:
* A list insertion test - where you have threads each insert say 10e6 items into a list (and scale the number of lists threads)
* A list insert delete test - where you have threads each first insert say 10e6 items into a list, then delete all items. How about random insertion and delete?

* A hash table test - same as above but with a hash table with a reasonable bucket size
* A hash table scaling test - this test should fix the number of threads (say at 20) and vary the number of buckets
* ...
-->

Rather than only comparing pthread lock and your spin lock, you could also plot curves for your different mutex implementations.

Timing should be done with `gettimeofday()`. Read the man page for details. One thing that is good to do: write a wrapper which returns the time in seconds as a floating-point value. This makes the timing routine really easy to use.

To make your graph less noisy, you will have to run multiple iterations, as well as to make sure to let each experiment run long enough so as to be meaningful. You might then plot the average (as done above) and even a standard deviation.


## Part 5: The Producer-Consumer Problem

Finally, you will try to solve the classical producer-consumer problem.
Recall that, apart from protecting critical sections with locks,
another type of concurrency problem
requires communications among threads: some threads wait, and some threads signal.
The producer-consumer problem is such an example:
we have a bounded buffer, producer threads put items (integers, in our case) into the buffer,
and consumer threads get items (integers) from it.
Producers (consumers) should be blocked when the buffer is full (empty)
and woke up when new empty buffer slots (new items) are available.

One real-world application following the producer-consumer setting
is message queue (e.g., [kafka event streaming](https://kafka.apache.org/documentation/)) 
where events are placed in a queue by some producers (e.g., web crawlers)
and handled by some consumers (e.g., your powerful text analyzers).

To build the message queue, you should implement the following code:

```c
struct mq_t *mq_new(int buf_size);
void mq_destroy(struct mq_t *mq);
void mq_produce(struct mq_t *mq, int item);
int mq_consume(struct mq_t *mq);
```

The structure `mq_t` should contain whatever is needed including conditional variables, mutex (used by conditional variables), buffer, information of current status, etc. You don't have to implement your own conditional variables, simply use `pthread_cond_t` and its APIs (`pthread_cond_init`, `pthread_cond_signal`, `pthread_cond_wait`) to build your library. This library will be called `libmq.so`

You should also report on details of the message queue implementation.

## Testing

Researchers have spent a great deal of time and effort looking into concurrency bugs over many years. Concurrency bugs are hard to catch and passing all tests does not guarantee correctness.

We provide a test program for message queue. Run `test-lock.sh` to test it. Concurrency bugs may not be reproducible due to the randomness of scheduling. It's handy to have a script that runs the test script multiple times in case your program occasionally fails. Running `./test-many.sh 100` will repeat `test-lock.sh` 100 times, which will suffice in most cases. To identify potential dead-lock, command `timeout` would be useful, and you will see it in `test-many.sh`, giving each run a time limit of 1 second.

Feel free to add more tests or even build a new test framework if the current one does not meet your requirements.

We will NOT be grading based on testing results in this project, but you should check correctness before you dive deeper in performance or fairness.

## Hand In

* Source files (.c, .h) of your locks.
* `Makefile` which builds each of the libraries (Running `make` should build all four libraries).
* The **PDF** version of your report. The report should be NO MORE than 8 pages. Be concise!
* DO NOT submit \*.o \*.so or any binary files.

<div id="footer">
  Adapted from <a href="http://pages.cs.wisc.edu/~remzi/Classes/537/Spring2010/Projects/p4.html"> WISC CS537 </a> by Remzi Arpaci-Dusseau 
</div>
