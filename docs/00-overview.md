# Uranus homelab overview

- Host: `uranus` (Ubuntu 24.04)
- KVM/libvirt for VMs
- Minikube (docker driver) for k8s
- Pi-hole VM on 192.168.88.50
- Nextcloud behind Traefik on `uranus-cloud.duckdns.org`
- Postgres via Helm in namespace `uranus-db` with PVs on `/srv/minikube`


