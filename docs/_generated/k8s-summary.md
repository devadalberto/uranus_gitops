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
