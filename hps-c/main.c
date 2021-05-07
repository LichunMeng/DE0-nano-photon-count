//for TCP socket
#include <stdio.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#define MAX 1024 
#define PORT 8888
#define SA struct sockaddr
//for hps control and communication  
#include <inttypes.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"

#define AXI_BASE ( 0xc0000000)
#define AXI_SPAN ( 0x04000000)
#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

int hps_control(unsigned int *h2p_fifo_addr,unsigned long *h2p_lw_counter_addr,unsigned long *h2p_lw_FIFO_csr_addr,unsigned long *h2p_lw_tri_sim_addr,unsigned long *h2p_lw_tri_addr) {

	//void *h2p_lw_fifo_addr;// pointer for fifo output
	//void *h2p_lw_counter_addr; //pointer for pulse counter control 
	//void *h2p_lw_FIFO_csr_addr;//pointer for FIFO control
	//void *h2p_lw_tri_sim_addr; //pointer for sim trigger control
	//void *h2p_lw_tri_addr; //pointer for trigger control

	void *virtual_base;// memory base 
	void *virtual_base_axi;// memory base 
	int fd; // mapping for memory

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );
	virtual_base_axi = mmap( NULL, AXI_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, AXI_BASE);

	if( virtual_base_axi == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	
	*h2p_lw_counter_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PULSE_COUNTER_BASE) & ( unsigned long)( HW_REGS_MASK ) );
	*h2p_fifo_addr=virtual_base_axi+  (FIFO_PLS_OUT_BASE);
	
	//*h2p_lw_FIFO_csr_addr=virtual_base_axi +  FIFO_PLS_OUT_CSR_BASE;
	*h2p_lw_FIFO_csr_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + FIFO_PLS_OUT_CSR_BASE) & ( unsigned long)( HW_REGS_MASK ) );

	*h2p_lw_tri_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + TRIGGER_BASE) & ( unsigned long)( HW_REGS_MASK ) );
	
	*h2p_lw_tri_sim_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + TRIGGER_SIM_BASE) & ( unsigned long)( HW_REGS_MASK ) );
	//printf("%08x\r\n",*h2p_lw_fifo_addr);

	return (fd);
}	
int setting(uint32_t Intg,uint32_t Tri_intg, uint32_t sim_intg,unsigned long *h2p_lw_counter_addr,unsigned long *h2p_lw_tri_sim_addr,unsigned long *h2p_lw_tri_addr){
	*((uint32_t *)*h2p_lw_counter_addr) = Intg; 
	*((uint32_t *)*h2p_lw_tri_sim_addr) = sim_intg; 
	*((uint32_t *)*h2p_lw_tri_addr) = Tri_intg; 
	return (0);
}

int hps_data_get(unsigned int *h2p_fifo_addr,unsigned long *h2p_lw_FIFO_csr_addr,uint64_t data[]) {

	int i,t,count;
	for (i=0;i<MAX;i++){
		if (((*((uint32_t *)(*h2p_lw_FIFO_csr_addr+1)))&0x2)==0) 
		{	
			data[i]=*((uint64_t *)*h2p_fifo_addr) ;
			t=data[i]&0xffffffff;
			count=(data[i]&0xffffffff00000000)>>32;
	            	printf("count=%d,t=%d\r\n",count,t);
		}   
		else
			i--;
	}
	return( 0 );
}
// Function designed for chat between client and server.

int main()
{
	int fd;
	unsigned long h2p_lw_fifo_addr,h2p_lw_counter_addr,h2p_lw_FIFO_csr_addr,h2p_lw_tri_sim_addr,h2p_lw_tri_addr;
	unsigned int h2p_fifo_addr;
	fd=hps_control(&h2p_fifo_addr,&h2p_lw_counter_addr,&h2p_lw_FIFO_csr_addr,&h2p_lw_tri_sim_addr,&h2p_lw_tri_addr);
	uint32_t Intg=5000;
	uint32_t Tri_intg=400000; 
	uint32_t sim_intg=50;
	uint64_t data[MAX];
       	setting(Intg,Tri_intg, sim_intg,&h2p_lw_counter_addr,&h2p_lw_tri_sim_addr,&h2p_lw_tri_addr);
        //hps_data(Intg,Tri_intg, sim_intg,&h2p_lw_fifo_addr,&h2p_lw_counter_addr,&h2p_lw_FIFO_csr_addr,&h2p_lw_tri_sim_addr,&h2p_lw_tri_addr, data);
    	uint32_t n=0,i=0,count=0,t=0;
    	for (;;) {
            hps_data_get(&h2p_fifo_addr,&h2p_lw_FIFO_csr_addr,data);
	    //for (i=0;i<MAX;i++){
	    //    	t=data[i]&0xffffffff;
	    //    	count=(data[i]&0xffffffff00000000)>>32;
	    //        if ((data[i]&0x0000000080000000)==1){
	    //        	printf("count=%d,t=%d\r\n",count,t);
	    //        }
	    //        printf("t=%08d,count=%d\r\n",t,count);
    	    //}
	}
	close(fd);
}
