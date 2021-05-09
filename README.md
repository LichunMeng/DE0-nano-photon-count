# DE0-nano-photon-count
########################
In this project, DE0-nano-soc development board is applied and it achieves the function of countting the TTL pulse for thegiving time period and sending the result through socket. For example, the TTL pulse can be generated by the single photon counter, the DE0-nano can send the photon number and time stampe through socket, which can be received by the client computer for the further analysis

######################## files in the project
FOLDER "fpga-rtl"

It has the whole Project file which can be open with Quartus.

"soc_system.sof" is the final complied file given by Quartus, DE0-nano board will works when it is downloaded to the board.

"Pulse_cnt.v" verilog file, it is used to achieve the main function

"TRI_gen.v" verilog file, it is used to generate trigger signal.

"soc_system.qsys" qsys file, describe the whole architic of the system.

"ghrd.v" top level file

FOLDER "hps-c/Pulse_counter_FIFO_read_out": read out data from avalon memory slave and send it to socket 192.168.1.2:8888
FOLDER "hps-c/Pulse_counter_controller": receive control data from socket 192.168.1.2:8889 and write them to proper register in order to control the pulse counter.
FOLDER "client": python file, send control data and plot data
##############electric signal connection
GPIO_[0]:input, TTL signal
GPIO_[1]:input, Trgger_in
GPIO_[2]:output, Trgger_out (please connect it to GPIO_0[1], you can connect it to other devices for triggering
GPIO_[3]:output, sim_TTL, it simulates the TTL signal, please connect it t GPIO_[0] during test.
#################conunter control on the client side
fmt_tran='I'*3# 3 usigned 32 data
tran_raw=struct.pack(fmt_tran,Int,Int_tri,Int_tri_sim)# prepare bytes that will send
#Int: integration time, unit: fpga clock 20ns
#Int_tri: triggering period, unit: fpga clock 20ns
#Int_tri_sim: time period for the simulate the TTL signal, unit: fpga clock 20ns
HOST = '192.168.1.2'  # The server's hostname or IP address
PORT_ctr= 8889        # The port used by the server
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
tran_raw=struct.pack(fmt_tran,Int,Int_tri,Int_tri_sim+i*10)
s.sendall(tran_raw)
############### receive data on th client side
hps sends 1024*8 data each package, each data has 64 bits. First 32 bits represent the time stampe with unit clock, the last 32 bits represent the TTL counts during the time period of "Int". When GPIO0:1 pin has trgger signal, the 32nd bit is set as 1 as flag.
 
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((HOST, PORT_fifo))
        data_raw = s.recv(N*8,socket.MSG_WAITALL)
        N_tmp=int(len(data_raw)/4)
        data=struct.unpack('I'*N_tmp,data_raw)
