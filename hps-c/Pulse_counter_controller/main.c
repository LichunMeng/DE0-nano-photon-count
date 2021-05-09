//for TCP socket
#include <stdio.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#define MAX 1024*8 
#define PORT 8889
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
//#define F_CLOCK( 50) //clock frequency MHZ
#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

int hps_control(unsigned int *h2p_fifo_addr,unsigned long *h2p_lw_counter_addr,unsigned long *h2p_lw_FIFO_csr_addr,unsigned long *h2p_lw_tri_sim_addr,unsigned long *h2p_lw_tri_addr) {

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
	
	*h2p_lw_FIFO_csr_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + FIFO_PLS_OUT_CSR_BASE) & ( unsigned long)( HW_REGS_MASK ) );

	*h2p_lw_tri_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + TRIGGER_BASE) & ( unsigned long)( HW_REGS_MASK ) );
	
	*h2p_lw_tri_sim_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + TRIGGER_SIM_BASE) & ( unsigned long)( HW_REGS_MASK ) );

	return (fd);
}	


int setting(uint32_t Intg,uint32_t Tri_intg, uint32_t sim_intg,unsigned long *h2p_lw_counter_addr,unsigned long *h2p_lw_tri_sim_addr,unsigned long *h2p_lw_tri_addr){
	*((uint32_t *)*h2p_lw_counter_addr) = Intg; 
	*((uint32_t *)*h2p_lw_tri_sim_addr) = sim_intg; 
	*((uint32_t *)*h2p_lw_tri_addr) = Tri_intg; 
	return (0);
}

int hps_data_get(unsigned int *h2p_fifo_addr,unsigned long *h2p_lw_FIFO_csr_addr,uint64_t data[]) {

	int i;
	uint32_t status;
	for (i=0;i<MAX;i++){
		status=(*((uint32_t *)(*h2p_lw_FIFO_csr_addr+4)))&0x3F;

		if (((status)&0x2)==0) 
		{	
			data[i]=*((uint64_t *)*h2p_fifo_addr) ;
		}   
		else
			i--;
	}
	return( 0 );
}
// Function designed for chat between client and server.
//int setNonblocking(int fd)
//{
//	    int flags;
//
//	        /* If they have O_NONBLOCK, use the Posix way to do it */
//#if defined(O_NONBLOCK)
//	        /* Fixme: O_NONBLOCK is defined but broken on SunOS 4.1.x and AIX 3.2.5. */
//	        if (-1 == (flags = fcntl(fd, F_GETFL, 0)))
//			        flags = 0;
//		    return fcntl(fd, F_SETFL, flags | O_NONBLOCK);
//#else
//		        /* Otherwise, use the old way of doing it */
//		        flags = 1;
//			    return ioctl(fd, FIOBIO, &flags);
//#endif
//} 
int main()
{
	int fd;
    	char buff[12];
	unsigned long h2p_lw_counter_addr,h2p_lw_FIFO_csr_addr,h2p_lw_tri_sim_addr,h2p_lw_tri_addr;
	unsigned int h2p_fifo_addr;
	fd=hps_control(&h2p_fifo_addr,&h2p_lw_counter_addr,&h2p_lw_FIFO_csr_addr,&h2p_lw_tri_sim_addr,&h2p_lw_tri_addr);
	uint32_t Intg=5000;
	uint32_t Tri_intg=10000000; 
	uint32_t sim_intg=10;
    	//uint32_t n=0,i=0,count=0,t=0;
    	int sockfd, connfd, len;
    	struct sockaddr_in servaddr, cli;
  
    	// socket create and verification
    	sockfd = socket(AF_INET, SOCK_STREAM|SOCK_NONBLOCK, 0);
    	if (sockfd == -1) {
    	    printf("Controller socket creation failed...\n");
    	    exit(0);
    	}
    	else
    	    printf("Controller socket successfully created..\n");
    	bzero(&servaddr, sizeof(servaddr));
	int timeout=500000;
	setsockopt( sockfd, SOL_SOCKET,SO_RCVTIMEO,(void *)&timeout, sizeof(timeout));
	setsockopt( sockfd, 6 ,18,(void *)&timeout, sizeof(timeout));
  
    	// assign IP, PORT
    	servaddr.sin_family = AF_INET;
    	servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    	servaddr.sin_port = htons(PORT);
  
    	// Binding newly created socket to given IP and verification
    	if ((bind(sockfd, (SA*)&servaddr, sizeof(servaddr)))!= 0) {
    	    printf("Controller socket bind failed...\n");
    	    exit(0);
    	}
    	else
    	    printf("Controller socket successfully binded..\n");
  
    	// Now server is ready to listen and verification
    	if ((listen(sockfd, 5)) != 0) {
    	    printf("Listen failed...\n");
    	    exit(0);
    	}
    	else
    	    printf("Controller server listening..\n");
    	len = sizeof(cli);
       	setting(Intg,Tri_intg, sim_intg,&h2p_lw_counter_addr,&h2p_lw_tri_sim_addr,&h2p_lw_tri_addr);
    	// Accept the data packet from client and verification
	while (1){
		if((connfd = accept4(sockfd, (SA*)&cli, &len,SOCK_NONBLOCK))>0){
    			bzero(buff, 12);
    			read(connfd, buff, sizeof(buff));
			Intg=buff[0]|buff[1]<<8|buff[2]<<16|buff[3]<<24;
			Tri_intg=buff[4]|buff[5]<<8|buff[6]<<16|buff[7]<<24;
			sim_intg=buff[8]|buff[9]<<8|buff[10]<<16|buff[11]<<24;

			if (Intg!=0){
       			setting(Intg,Tri_intg, sim_intg,&h2p_lw_counter_addr,&h2p_lw_tri_sim_addr,&h2p_lw_tri_addr);
			printf("T_Int=%dus, T_Tri=%dms, T_Pho=%dns\r\n",Intg/50,Tri_intg/50000,sim_intg*20);
			}
    			close(connfd);
    			}
	}
	close(fd);
	return (0);
}
