#include <stdio.h>
#include <stdlib.h>
#define MAX_NONCE 1000000000 // 100000000000

//char* tohexadecimal

void mine(long blockNum, char *trans, char *preHash, int prefixZero){
    //char prefix[] = "0000" ;
    
    for(int i = 0; i < MAX_NONCE; i++){
        //printf("mining...\n") ;
        srand(i*blockNum*(trans[0])*(preHash[0]));
        int count = 0 ;
        for(int j = 0; j < prefixZero; j++){
            if(rand() % 10 == 0){
                count++ ;
            }
        }
        if (count == prefixZero){
            //printf("found, nonce = %d\n", i) ;
            
        }
        //printf("%d\n", rand() % 10);
    }
}

int main(){
    char trans[] = "A-20->B,b-10->C" ;
    char preHash[] = "0000000xa036944e29568d0cff17edbe038f81208fecf9a66be9a2b8321c6ec7" ;

    int difficulty = 4 ;

    cudaEvent_t start, stop ;
	cudaEventCreate(&start) ;
	cudaEventCreate(&stop) ;

    cudaEventRecord(start) ;
    mine(1, trans, preHash, difficulty) ;
    cudaEventRecord(stop) ;

    cudaEventSynchronize(stop) ;
	float millisec = 0 ;
	cudaEventElapsedTime(&millisec, start, stop) ;
    printf("Time used: %f\n", millisec) ;

    printf("end\n") ;

    return 0 ;
}
