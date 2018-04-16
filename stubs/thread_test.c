#include "header.h"
#define ARRAYSIZE 17
#define NUMTHREADS 4

struct ThreadData {
    int start, stop;
    int* array; 
};

void* squarer(void* td) 
{
 struct ThreadData* data=(struct ThreadData*) td;

 int start=data->start;
 int stop=data->stop;
 int* array=data->array;
 int i;
 pid_t tid1;

 tid1 = syscall(SYS_gettid); // here is the correct statement //
 info("tid : %d",tid1);

 for (i=start; i<stop; i++) {
         sleep(1);
         array[i]=i*i;
         info("arr[%d] = [%d]",i,array[i]);
 } 
 return NULL;
}

int main(void) {
    int array[ARRAYSIZE];
    pthread_t thread[NUMTHREADS];
    struct ThreadData data[NUMTHREADS];
    int i;

    int tasksPerThread=(ARRAYSIZE+NUMTHREADS-1)/NUMTHREADS;

    for (i=0; i<NUMTHREADS; i++) {
        data[i].start=i*tasksPerThread;
        data[i].stop=(i+1)*tasksPerThread;
        data[i].array=array;
    }

    data[NUMTHREADS-1].stop=ARRAYSIZE;

    for (i=0; i<NUMTHREADS; i++) {
            pthread_create(&thread[i], NULL, squarer, &data[i]);
    }

    for (i=0; i<NUMTHREADS; i++) {
            pthread_join(thread[i], NULL);
    }

    for (i=0; i<ARRAYSIZE; i++) {
            info("%d ", array[i]);
    }
    //printf("\n");

    return 0;
}

