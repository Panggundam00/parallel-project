#include <stdio.h>
#include <stdlib.h>
#include <curand.h>
#include <curand_kernel.h>
#define MAX_NONCE 100000000000 // 100000000000
#define MAX 10

//char* tohexadecimal

void mine1(long blockNum, char *trans, char *preHash, int prefixZero){
    //char prefix[] = "0000" ;
    
    for(int i = 0; i < MAX_NONCE; i++){
        printf("mining...\n") ;
        srand(i*blockNum*(trans[0])*(preHash[0]));
        int count = 0 ;
        for(int j = 0; j < prefixZero; j++){
            if(rand() % 10 == 0){
                count++ ;
            }
        }
        if (count == prefixZero){
            printf("found, nonce = %d\n", i) ;
            break;
        }
        //printf("%d\n", rand() % 10);
    }
}

__global__ void mine(long int* blockNum, char *trans, char *preHash, int *prefixZero){
    int index = threadIdx.x ;
    for(int i = 0; i < (MAX_NONCE/1024/10); i++){
        //printf("mining...\n") ;
        int n = ((MAX_NONCE/1024/10)*(blockIdx.x*blockDim.x)+index) + i ;
        curandState_t state;
        curand_init(n*(*blockNum)*(*trans)*(*preHash), 0, 0, &state);
        //printf("rand = %d\n", curand(&state) % MAX) ;
        //int random = curand(&state) % MAX ;
        //printf("random = %d\n", random) ;
        //srand(n*(*blockNum)*(*trans)*(*preHash));
        int count = 0 ;
        int random = curand(&state) % MAX ;
        for(int j = 0; j < (*prefixZero); j++){
            if(random == 0){
                count++ ;
            }
        }
        if (count == (*prefixZero)){
            //printf("found, nonce = %d\n", n) ;
            //exit(1) ;
        }
    }
}

int main(){
    char trans[] = "A-20->B,b-10->C" ;
    char preHash[] = "0000000xa036944e29568d0cff17edbe038f81208fecf9a66be9a2b8321c6ec7" ;

    int difficulty = 5 ;
    //mine(1, trans, preHash, difficulty) ;

    long int blockNum = 1 ;
    char tran = trans[0] ;
    char preH = preHash[0] ;

    long int *d_blockNum ;
    char *d_trans ;
    char *d_preHash ;
    int *d_diff ;

    cudaMalloc((void**) &d_blockNum, sizeof(long int));
    cudaMalloc((void**) &d_trans, sizeof(char));
    cudaMalloc((void**) &d_preHash, sizeof(char));
    cudaMalloc((void**) &d_diff, sizeof(int));
    cudaMemcpy(d_blockNum, &blockNum, sizeof(long int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_trans, &tran, sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_preHash, &preH, sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_diff, &difficulty, sizeof(int), cudaMemcpyHostToDevice);

    cudaEvent_t start, stop ;
	cudaEventCreate(&start) ;
	cudaEventCreate(&stop) ;

    cudaEventRecord(start) ;
    mine<<<10, 1024>>>(d_blockNum, d_trans, d_preHash, d_diff) ;
    cudaEventRecord(stop) ;

    cudaEventSynchronize(stop) ;
	float millisec = 0 ;
	cudaEventElapsedTime(&millisec, start, stop) ;
    printf("Time used: %f\n", millisec) ;

    cudaFree(d_blockNum);
    cudaFree(d_trans);
    cudaFree(d_preHash);
    cudaFree(d_diff);

    printf("end\n") ;

    return 0 ;
}