#!/usr/bin/python
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("10.11.20.27",9999))
s.recv(1024)
s.send("TRUN .")
result = s.recv(1024)
print(result)
s.close()