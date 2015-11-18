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

// DECLARE CACHES AND COUNTERS FOR THE STATS HERE

typedef struct{
  int u_accesses;
  int u_hits;
  float u_hit_rate;
  int i_accesses;
  int i_hits;
  float i_hit_rate;
  int d_accesses;
  int d_hits;
  float d_hit_rate;
} statistics;

uint32_t cache_size;
uint32_t block_size = 64;
cache_map_t cache_mapping;
cache_org_t cache_org;
int fifo=0;

uint32_t nr_blocks;  //computed in main
uint32_t **cache;  //cache for instructions (or for evertyhing in case of uc)
uint32_t **cache2; //cache for declarations

int u_accesses=0;
int u_hits=0;
float u_hit_rate=0.0;
int d_accesses=0;
int d_hits=0;
float d_hit_rate=0.0;
int i_accesses=0;
int i_hits=0;
float i_hit_rate=0.0;

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

//allocates memory for a cache containing a valid bit and a tag bit (two columns)
uint32_t** init_cache(){
  int i;
  uint32_t** c;
  c=(uint32_t **) malloc (nr_blocks*sizeof(uint32_t *));
  for(i=0;i<nr_blocks;i++){
    c[i]=(uint32_t *) malloc(2*sizeof(uint32_t));
    c[i][0]=0; //store valid bit
    c[i][1]=0; //store tag
   }
  return c;

}

void check_dm(uint32_t** c,uint32_t index,uint32_t tag, access_t at){
  if(c[index][1]==tag&&c[index][0]==1){     //go to the index and check if tags match and entry is valid
      if(at==instruction) i_hits++;
        else d_hits++;
      }
  else{ //otherwise it's a miss, update tag
    c[index][0]=1;
    c[index][1]=tag; }

  if(at==instruction)    //doesn't matter for uc
        i_accesses++;
  else
        d_accesses++;

}

void check_fa(uint32_t** c,uint32_t tag,access_t at){
  int i;
  int found=0;
  for(i=0;i<nr_blocks;i++)
     if(c[i][1]==tag&&c[i][0]==1){   //check if entry if valid and tags match
           if(at==instruction) i_hits++;
           else d_hits++;
           found=1;
           break;
         }
  if(found==0){

    c[fifo][0]=1;
    c[fifo][1]=tag;
    if(fifo==nr_blocks-1) fifo=0;  //reset to first line
    else fifo++;
   }
   if(at==instruction) i_accesses++;
   else d_accesses++;
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


    
            if(cache_org==sc)
                cache_size/=2;
            nr_blocks=cache_size/64;
            cache=init_cache();
            if(cache_org==sc)
                cache2=init_cache();

            //compute indexes and tags for uc
            uint32_t index_bits=log2r(nr_blocks);
            uint32_t offset_bits=log2r(block_size); //6
            uint32_t tag_bits=32-index_bits-offset_bits;
           // printf("nr_blocks: %d ,indexes: %d, tag_bits: %d, offset_bits: %d\n",nr_blocks,index_bits,tag_bits,offset_bits);




    /* Loop until whole trace file has been read */
    mem_access_t access;
    while(1) {
        access = read_transaction(ptr_file);
        //If no transactions left, break out of loop
        if (access.address == 0)
            break;

	/* Do a cache access */
	// ADD YOUR CODE HERE

        //get address without offset bits
        uint32_t drop_offset=(access.address)>>offset_bits;

      //  printf("index: %d tag: %d\n",index,tag);

        if(cache_mapping==dm){
          uint32_t index=drop_offset&(nr_blocks-1);  //get index_bits (from the last part of the address)
          uint32_t tag=drop_offset>>index_bits;     //get tag bits(simply drop the index_bits)
          if(cache_org==uc)
                check_dm(cache,index,tag,access.accesstype);
          else {
            if(access.accesstype==instruction)
                check_dm(cache,index,tag,instruction);
            else
                check_dm(cache2,index,tag,data);
          }
        }
        else{  //cache_mapping=fa
           uint32_t tag=drop_offset;  //the tag is just the entire address without the offset_bits
           if(cache_org==uc)
                 check_fa(cache,tag,access.accesstype);
           else
           {
             if(access.accesstype==instruction)
                 check_fa(cache,tag,instruction);
             else
                 check_fa(cache2,tag,data);
           }


        }

    }

    /* Print the statistics */
    // ADD YOUR CODE HERE

    if(cache_org==uc){
      u_hits=i_hits+d_hits;
      u_accesses=i_accesses+d_accesses;
      u_hit_rate=(0.0+u_hits)/u_accesses;
      printf("U.accesses: %d\nU.hits: %d\nU.hit rate: %1.3f\n",u_accesses,u_hits,u_hit_rate);
     }
    else{
      i_hit_rate=(0.0+i_hits)/i_accesses; d_hit_rate=(0.0+d_hits)/d_accesses;
      printf("I.accesses: %d\nI.hits: %d\nI.hit rate:%1.3f\n\nD.accesses: %d\nD.hits: %d\nD.hit rate:%1.3f\n",i_accesses,i_hits,i_hit_rate,d_accesses,d_hits,d_hit_rate);
    }
    /* Close the trace file */
    fclose(ptr_file);

}
