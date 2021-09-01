#ifndef __MEM_H_
#define __MEM_H_

#define E_NO_SPACE            1
#define E_CORRUPT_FREESPACE   2
#define E_PADDING_OVERWRITTEN 3
#define E_BAD_ARGS            4
#define E_BAD_POINTER         5

#define M_BESTFIT   0
#define M_WORSTFIT  1
#define M_FIRSTFIT  2

extern int m_error;

int mem_init(int size_of_region);
void * mem_alloc(int size, int style);
int mem_free(void * ptr);
void mem_dump();

#endif

