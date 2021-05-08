#!/usr/bin/env python3
import matplotlib.pyplot as plt
import numpy as np
import socket
import struct
HOST = '192.168.1.2'  # The server's hostname or IP address
PORT_fifo = 8888        # The port used by the server
PORT_ctr= 8889        # The port used by the server
N=1024*8;

fmt='I'*N*2
fmt_tran='I'*3
Int=5000;
Int_tri=5000000;
Int_tri_sim=50;


plt.ion()
figure, ax=plt.subplots(figsize=(100,8))
x=np.zeros(N)
y=np.zeros(N)
line1, =ax.plot(x,y,'r.',markersize=1)
####controller
def fifo_control(Int,Int_tri,Int_tri_sim):
    HOST = '192.168.1.2'  # The server's hostname or IP address
    PORT_ctr= 8889        # The port used by the server
    fmt_tran='I'*3
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    #tran_raw=struct.pack(fmt_tran,Int,Int_tri,Int_tri_sim+i*10)
    #s.sendall(tran_raw)
    #s.sendall(b'Hello, world')
        s.connect((HOST, PORT_ctr))
        tran_raw=struct.pack(fmt_tran,Int,Int_tri,Int_tri_sim)
        try:
            s.sendall(tran_raw)
        except:
            print("sending fail")
    s.close()

def data_unfold(data_raw,N,res):
    si=2147483648;
    data=struct.unpack('I'*2,data_raw)
    for i in range(N):
        x[i]=data[2*i]
        y[i]=data[2*i+1]
    x=np.array(x)
    y=np.array(y)
    marker=np.where(y>=si)
    y[marker]=y[marker]-si
    marker_x=0

    
si=2147483648;
count=0
for i in range(2):
    fifo_control(Int,Int_tri,Int_tri_sim+i*5)
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

    #tran_raw=struct.pack(fmt_tran,Int,Int_tri,Int_tri_sim+i*10)
    #s.sendall(tran_raw)
    #s.sendall(b'Hello, world')
        s.connect((HOST, PORT_fifo))
        data_raw = s.recv(N*8,socket.MSG_WAITALL)
        N_tmp=int(len(data_raw)/4)
        data=struct.unpack('I'*N_tmp,data_raw)
        tmp=0
        j=0
        x=[]
        y=[]
        for i in range(int(N_tmp/2)):
            #print(data[2*i])
            if data[2*i]>tmp:
                x.append(data[2*i])
                y.append(data[2*i+1])
                tmp=data[2*i]
                j=j+1
            else:
                x.append(data[2*i])
                y.append(data[2*i+1]-si)
                line1.set_xdata(np.array(x)/50e3)
                line1.set_ydata(np.array(y)+np.random.rand(1)[0]*Int/Int_tri_sim/10)
                ax.set_xlim((0,Int_tri/50e3))
                ax.set_ylim(0,Int/Int_tri_sim*1.5)
                figure.canvas.draw()
                figure.canvas.flush_events()
                j=0
                x=[]
                y=[]
                tmp=0
        data=[]
    s.close()

