#!/usr/bin/env python3
import matplotlib.pyplot as plt
import numpy as np
import socket
import struct
HOST = '192.168.1.2'  # The server's hostname or IP address
PORT = 8888        # The port used by the server
N=1024*8;

fmt='I'*N*2
fmt_tran='I'*3
Int=5000;
Int_tri=5000000;
Int_tri_sim=100;


plt.ion()
figure, ax=plt.subplots(figsize=(100,8))
x=np.zeros(N)
y=np.zeros(N)
line1, =ax.plot(x,y,'r.',markersize=0.1)
tmp=0
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    #s.sendall(b'Hello, world')
    for i in range(100):
        tran_raw=struct.pack(fmt_tran,Int,Int_tri,Int_tri_sim+i*10)
        s.sendall(tran_raw)
        data_raw = s.recv(N*8)
        N=int(len(data_raw)/4)
        data=struct.unpack('I'*N,data_raw)
        for i in range(int(N/2)):
            x[i]=data[2*i]
            y[i]=data[2*i+1]
        #print(y[1])
        line1.set_xdata(x)
        line1.set_ydata(y)
        ax.set_xlim((0,Int_tri))
        ax.set_ylim(0,200)
        figure.canvas.draw()
        figure.canvas.flush_events()
        data=[]
    s.close()

