#!/usr/bin/env python3
import matplotlib.pyplot as plt
import numpy as np
import socket
import struct
HOST = '192.168.1.2'  # The server's hostname or IP address
PORT = 8888        # The port used by the server
N=1024;

fmt='I'*N*2
fmt_tran='I'*3
Int=5000;
Int_tri=5000000;
Int_tri_sim=100;


plt.ion()
figure, ax=plt.subplots(figsize=(100,8))
x=np.zeros(N)
y=np.zeros(N)
line1, =ax.plot(x,y,'r.')
tmp=0
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    #s.sendall(b'Hello, world')
    for i in range(5):
        tran_raw=struct.pack(fmt_tran,Int,Int_tri,Int_tri_sim)
        #s.sendall(tran_raw)
        data_raw = s.recv(N*8)
        data=struct.unpack(fmt,data_raw)
        for i in range(N):
            #x[i]=data[2*i]
            #y[i]=data[2*i+1]
            u=np.uint32(data[2*i+1])
            if (u>>31)==1:
                ss=i-tmp
                if ss<0:
                    print(ss+N)
                else:
                    print(ss)
                tmp=i
        #print(y[1])
            #line1.set_xdata(x)
            #line1.set_ydata(y)
            #ax.set_xlim((np.min(x),np.max(x)))
            #ax.set_ylim(0,200)
            #figure.canvas.draw()
            #figure.canvas.flush_events()
    s.close()

