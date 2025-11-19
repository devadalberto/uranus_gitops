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
