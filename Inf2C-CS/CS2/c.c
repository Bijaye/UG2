#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <inttypes.h>

typedef enum {dm, fa} cache_map_t;
typedef enum {uc, sc} cache_org_t;
typedef enum {instruction, data} access_t;

typedef struct {
    uint32_t address;
    access_t accesstype;
} mem_access_t;


uint32_t cache_size; 
uint32_t block_size = 64;
cache_map_t cache_mapping;
cache_org_t cache_org;



/* Reads a memory access from the trace file and returns
 * 1) access type (instruction or data access
 * 2) memory address
 */
mem_access_t read_transaction(FILE *ptr_file) {
    char buf[1000];
    char* token;
    char* string = buf;
    mem_access_t access;

    if (fgets(buf,1000, ptr_file)!=NULL) {

        /* Get the access type */
        token = strsep(&string, " \n");        
        if (strcmp(token,"I") == 0) {
            access.accesstype = instruction;
        } else if (strcmp(token,"D") == 0) {
            access.accesstype = data;
        } else {
            printf("Unkown access type\n");
            exit(0);
        }
        
        /* Get the access type */        
        token = strsep(&string, " \n");
        access.address = (uint32_t)strtol(token, NULL, 16);

        return access;
    }

    /* If there are no more entries in the file,  
     * return an address 0 that will terminate the infinite loop in main
     */
    access.address = 0;
    return access;
}

//returns the log base 2 of a number
uint32_t log2r( uint32_t x )
{
  uint32_t ans = 0 ;
  while( x>>=1 ) ans++;
  return ans ;
}

void main(int argc, char** argv)
{

    /* Read command-line parameters and initialize:
     * cache_size, cache_mapping and cache_org variables
     */

    if ( argc != 4 ) { /* argc should be 2 for correct execution */
        printf("Usage: ./cache_sim [cache size: 128-4096] [cache mapping: dm|fa] [cache organization: uc|sc]\n");
        exit(0);
    } else  {
        /* argv[0] is program name, parameters start with argv[1] */

        /* Set cache size */
        cache_size = atoi(argv[1]);

        /* Set Cache Mapping */
        if (strcmp(argv[2], "dm") == 0) {
            cache_mapping = dm;
        } else if (strcmp(argv[2], "fa") == 0) {
            cache_mapping = fa;
        } else {
            printf("Unknown cache mapping\n");
            exit(0);
        }

        /* Set Cache Organization */
        if (strcmp(argv[3], "uc") == 0) {
            cache_org = uc;
        } else if (strcmp(argv[3], "sc") == 0) {
            cache_org = sc;
        } else {
            printf("Unknown cache organization\n");
            exit(0);
        }
    }


    /* Open the file mem_trace.txt to read memory accesses */
    FILE *ptr_file;
    ptr_file =fopen("mem_trace.txt","r");
    if (!ptr_file) {
        printf("Unable to open the trace file\n");
        exit(1);
    }

   //Initialization
   //Cache is an array with nr of rows=nr of blocks and nr of columns=2(onde to store de valid bit and one for the tag)

    uint32_t **cache;
    uint32_t **cache2;
    int hits=0,accesses=0;
    int i;
            //dm uc
            if(cache_org==sc) 
                      cache_size/=2;
            uint32_t nr_blocks=cache_size/64;
            uint32_t index_bits=log2r(nr_blocks);
            uint32_t offset_bits=log2r(block_size); //6
            uint32_t tag_bits=32-index_bits-offset_bits;
            printf("nr_blocks: %d ,indexes: %d, tag_bits: %d\n",nr_blocks,index_bits,tag_bits);
            cache=(uint32_t **) malloc (nr_blocks*sizeof(uint32_t *));
            for(i=0;i<nr_blocks;i++){
              cache[i]=(uint32_t *) malloc(2*sizeof(uint32_t));
              cache[i][0]=0; //set valid bit to 0
            
             }
           
             
    
    /* Loop until whole trace file has been read */
    mem_access_t access;
    while(1) {
        access = read_transaction(ptr_file);
        //If no transactions left, break out of loop
        if (access.address == 0)
            break;

	/* Do a cache access */
	// ADD YOUR CODE HERE
        
        //the number of entries in the cache is a power of two, so we can use log2 to get the index
        uint32_t drop_offset=(access.address)>>offset_bits;
        uint32_t index=log2r(drop_offset);
        uint32_t tag=drop_offset>>index_bits;
        printf("index: %d tag: %d", index,tag);
        if(cache[index][1]==tag&&cache[index][0]==1) 
                hits++;
            else {cache[index][0]=1; cache[index][1]=tag; }   

            accesses++;
      
        
       
    }

    /* Print the statistics */
    // ADD YOUR CODE HERE

 
    /* Close the trace file */
    fclose(ptr_file);

}

