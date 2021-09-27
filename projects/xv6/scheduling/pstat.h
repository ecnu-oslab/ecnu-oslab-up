#ifndef _PSTAT_H_
#define _PSTAT_H_

#include "param.h"


struct pstat {
  // whether this slot of the process table is in use (1 or 0)
  int inuse[NPROC]; 
  // PID of each process
  int pid[NPROC];   
  // current priority level of each process (0-NMLFQ)
  int priority[NPROC];  
  // current state (e.g., SLEEPING or RUNNABLE) of each process
  int state[NPROC];  
  // number of ticks each process has accumulated RUNNING/SCHEDULED at each priority queue 
  int ticks[NPROC][4];  
  // number of ticks each process has waited before being scheduled
  int wait_ticks[NPROC][4]; 
};


#endif // _PSTAT_H_
