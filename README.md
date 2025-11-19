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


---

# Kubernetes summary

```bash
# Nodes
NAME       STATUS   ROLES           AGE     VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE            KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    control-plane   3d12h   v1.34.0   192.168.39.211   <none>        Buildroot 2025.02   6.6.95           docker://28.4.0

# Traefik services
NAME      TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
traefik   NodePort   10.99.200.87   <none>        80:30080/TCP,443:30443/TCP   11h

# Nextcloud (homelab-apps)
NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nextcloud   1/1     1            1           6h22m

NAME                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/nextcloud   ClusterIP   10.98.149.123   <none>        8080/TCP   6h22m

NAME                                  CLASS     HOSTS                      ADDRESS   PORTS   AGE
ingress.networking.k8s.io/nextcloud   traefik   uranus-cloud.duckdns.org             80      6h22m

# Postgres (uranus-db)
NAME                          READY   AGE
statefulset.apps/postgresql   1/1     8h

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/postgresql      ClusterIP   10.103.255.15   <none>        5432/TCP   8h
service/postgresql-hl   ClusterIP   None            <none>        5432/TCP   8h

NAME                                      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/data-postgresql-0   Bound    pvc-56f58be0-a837-4d7a-99f7-5f13d73f87f9   20Gi       RWO            standard       <unset>                 8h
```
