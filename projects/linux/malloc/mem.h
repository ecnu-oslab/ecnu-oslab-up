// ====== DO NOT MODIFY ======

#ifndef __mem_h__
#define __mem_h__

// different supported errors
#define E_NO_SPACE            1
#define E_CORRUPT_FREESPACE   2
#define E_PADDING_OVERWRITTEN 3
#define E_BAD_ARGS            4
#define E_BAD_POINTER         5

// used for errors
extern int m_error;

// styles for free space search
#define M_BESTFIT  0
#define M_WORSTFIT 1
#define M_FIRSTFIT 2

// routines
int Mem_Init(int size_of_region);
void *Mem_Alloc(int size, int style);
int Mem_Free(void *ptr);
void Mem_Dump();

#endif // __mem_h__
