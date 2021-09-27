#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <assert.h>
#include <ctype.h>
#include <string.h>
#include "sort.h"

void
usage(char *prog) 
{
    fprintf(stderr, "usage: %s <-i file>\n", prog);
    exit(1);
}

int
main(int argc, char *argv[])
{
    // arguments
    char *inFile = "/no/such/file";

    // input params
    int c;
    opterr = 0;
    while ((c = getopt(argc, argv, "i:")) != -1) {
	switch (c) {
	case 'i':
	    inFile = strdup(optarg);
	    break;
	default:
	    usage(argv[0]);
	}
    }

    // open and create output file
    int fd = open(inFile, O_RDONLY);
    if (fd < 0) {
	perror("open");
	exit(1);
    }

    rec_t r;
    while (1) {	
	int rc;
	rc = read(fd, &r, sizeof(rec_t));
	if (rc == 0) // 0 indicates EOF
	    break;
	if (rc < 0) {
	    perror("read");
	    exit(1);
	}
	printf("key: %u rec:", r.key);
	int j;
	for (j = 0; j < NUMRECS; j++) 
	    printf("%u ", r.record[j]);
	printf("\n");
    }
    
    (void) close(fd);

    return 0;
}

