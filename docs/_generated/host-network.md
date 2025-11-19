# Host networking snapshot

```bash
ip -br addr
lo               UNKNOWN        127.0.0.1/8 ::1/128 
eno1             UP             
wlp2s0           DOWN           
br-lan           UP             192.168.88.12/24 fd00::5857:29ff:feb3:513d/64 fe80::5857:29ff:feb3:513d/64 
virbr0           UP             192.168.122.1/24 
virbr1           UP             192.168.39.1/24 
vnet1            UNKNOWN        fe80::fc54:ff:fee0:21f0/64 
vnet2            UNKNOWN        fe80::fc54:ff:fe7c:5683/64 
vnet10           UNKNOWN        fe80::fc54:ff:fe26:7356/64 

ip route
default via 192.168.88.1 dev br-lan proto static metric 100 
192.168.39.0/24 dev virbr1 proto kernel scope link src 192.168.39.1 
192.168.88.0/24 dev br-lan proto kernel scope link src 192.168.88.12 
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 
```
