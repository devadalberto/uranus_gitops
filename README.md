# Uranus homelab

> WARNING: This file is auto-generated.  
> Edit the files under `docs/` and re-run `scripts/gen-readme.sh`.

This repo describes and automates the homelab on **uranus**:

- KVM/libvirt VMs (pfSense, Pi-hole, etc.)
- Minikube cluster with Traefik
- Nextcloud + PostgreSQL
- Secrets managed with `sops` and `age`


---

# Uranus homelab overview

- Host: `uranus` (Ubuntu 24.04)
- KVM/libvirt for VMs
- Minikube (docker driver) for k8s
- Pi-hole VM on 192.168.88.50
- Nextcloud behind Traefik on `uranus-cloud.duckdns.org`
- Postgres via Helm in namespace `uranus-db` with PVs on `/srv/minikube`




---

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


---

# Kubernetes summary

```bash
# Nodes
NAME       STATUS   ROLES           AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
minikube   Ready    control-plane   19h   v1.30.0   192.168.49.2   <none>        Ubuntu 22.04.5 LTS   6.8.0-87-generic   docker://28.4.0

# Traefik services

# Nextcloud (homelab-apps)
NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nextcloud         1/1     1            1           18h
deployment.apps/onlyoffice-docs   1/1     1            1           18h

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/nextcloud         ClusterIP   10.109.242.250   <none>        8080/TCP   18h
service/onlyoffice-docs   ClusterIP   10.102.216.109   <none>        80/TCP     18h

# Postgres (uranus-db)
NAME                               READY   AGE
statefulset.apps/uranus-postgres   1/1     15h

NAME                              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/uranus-db-postgresql      ClusterIP   10.107.168.98   <none>        5432/TCP   15h
service/uranus-db-postgresql-hl   ClusterIP   None            <none>        5432/TCP   18h

NAME                                                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/data-uranus-db-postgresql-0   Bound    pvc-3ffcf145-75d9-45b6-ae5f-d7ccfb72519c   10Gi       RWO            standard       <unset>                 18h
persistentvolumeclaim/uranus-postgres-data          Bound    pvc-284cf247-8d5f-46c1-b6fb-13075c277226   20Gi       RWO            standard       <unset>                 15h
```
