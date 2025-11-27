# Host networking snapshot

```bash
ip -br addr
lo               UNKNOWN        127.0.0.1/8 ::1/128 
eno1             UP             
wlp2s0           DOWN           
br-lan           UP             192.168.88.12/24 fd00::5857:29ff:feb3:513d/64 fe80::5857:29ff:feb3:513d/64 
virbr0           DOWN           192.168.122.1/24 
docker0          DOWN           172.17.0.1/16 fe80::8072:41ff:fe43:e754/64 
vnet1            UNKNOWN        fe80::fc54:ff:fe26:7356/64 
br-fe0a09603d46  UP             192.168.49.1/24 fe80::f4dd:92ff:fee3:f828/64 
vetha0db42f@if2  UP             fe80::4cbe:c5ff:fee5:6c1a/64 

ip route
default via 192.168.88.1 dev br-lan proto static metric 100 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
192.168.49.0/24 dev br-fe0a09603d46 proto kernel scope link src 192.168.49.1 
192.168.88.0/24 dev br-lan proto kernel scope link src 192.168.88.12 
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 linkdown 
```
