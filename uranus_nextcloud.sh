#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ============================
# Config paths and variables
# ============================
HOME_DIR="/home/saitama"
GITOPS_ROOT="${HOME_DIR}/uranus_gitops"
SECRETS_DIR="${GITOPS_ROOT}/infra/secrets/uranus"
AGE_KEY_FILE="${HOME_DIR}/.config/sops/age/keys.txt"

# DB settings (MUST match your Postgres Helm install)
POSTGRES_DB="uranus_homelab"
POSTGRES_USER="uranus_app"
POSTGRES_PASSWORD="ChangeMeNow123!"   # change here if you changed Helm values

# Nextcloud admin user
NEXTCLOUD_ADMIN_USER="admin"
NEXTCLOUD_ADMIN_PASSWORD="SuperSecret123!"   # change if you want

echo "[0] Using:"
echo "    GITOPS_ROOT=${GITOPS_ROOT}"
echo "    SECRETS_DIR=${SECRETS_DIR}"
echo

# ============================
# 1) Get real age public key
# ============================
if [ ! -f "${AGE_KEY_FILE}" ]; then
  echo "ERROR: ${AGE_KEY_FILE} not found. Did you run age-keygen already?"
  exit 1
fi

AGE_PUB_KEY=$(grep '^# public key:' "${AGE_KEY_FILE}" | awk '{print $4}' || true)

if [ -z "${AGE_PUB_KEY}" ]; then
  echo "ERROR: Could not extract age public key from ${AGE_KEY_FILE}"
  exit 1
fi

echo "[1] Using age public key: ${AGE_PUB_KEY}"
echo

# ============================
# 2) Ensure dirs, rewrite .sops.yaml
# ============================
mkdir -p "${GITOPS_ROOT}"
mkdir -p "${SECRETS_DIR}"

cd "${GITOPS_ROOT}"

cat > "${GITOPS_ROOT}/.sops.yaml" <<EOF
keys:
  - &uranus_age ${AGE_PUB_KEY}

creation_rules:
  - path_regex: infra/secrets/uranus/.*\\.sops\\.ya?ml
    key_groups:
      - age:
          - *uranus_age
EOF

echo "[2] .sops.yaml written:"
cat "${GITOPS_ROOT}/.sops.yaml"
echo

# ============================
# 3) Create PLAINTEXT Nextcloud values
# ============================
cat > "${SECRETS_DIR}/nextcloud.values.sops.yaml" <<EOF
fullnameOverride: nextcloud

ingress:
  enabled: true
  ingressClassName: traefik
  hostname: uranus-cloud.duckdns.org
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: web
    traefik.ingress.kubernetes.io/router.tls: "false"
  tls: []

service:
  type: ClusterIP

externalDatabase:
  enabled: true
  type: postgresql
  host: postgresql.uranus-db.svc.cluster.local
  user: ${POSTGRES_USER}
  password: ${POSTGRES_PASSWORD}
  database: ${POSTGRES_DB}
  port: 5432

mariadb:
  enabled: false

persistence:
  enabled: true
  storageClass: standard
  accessModes:
    - ReadWriteOnce
  size: 50Gi

nextcloudUsername: ${NEXTCLOUD_ADMIN_USER}
nextcloudPassword: ${NEXTCLOUD_ADMIN_PASSWORD}
nextcloudHost: uranus-cloud.duckdns.org
EOF

echo "[3] Plaintext Nextcloud values created at:"
echo "    ${SECRETS_DIR}/nextcloud.values.sops.yaml"
echo

# ============================
# 4) Encrypt values with SOPS
# ============================
sops -e -i "${SECRETS_DIR}/nextcloud.values.sops.yaml"

echo "[4] Encrypted Nextcloud values (first 10 lines):"
head -n 10 "${SECRETS_DIR}/nextcloud.values.sops.yaml" || true
echo

# ============================
# 5) Deploy Nextcloud with Helm
# ============================
echo "[5] Helm: adding/updating Bitnami repo..."
helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
helm repo update

echo "[5] Deploying / upgrading Nextcloud..."
sops -d "${SECRETS_DIR}/nextcloud.values.sops.yaml" | \
  helm upgrade --install nextcloud bitnami/nextcloud \
    --namespace nextcloud \
    --create-namespace \
    -f -

echo
echo "[6] Pods in namespace 'nextcloud':"
kubectl get pods -n nextcloud || true

echo
echo "Watch with:"
echo "  kubectl get pods -n nextcloud -w"
echo
echo "Once pods are 1/1 Running, test Nextcloud via Traefik:"
echo "  NODE_IP=\$(minikube ip)"
echo "  curl -I -H \"Host: uranus-cloud.duckdns.org\" \"http://\${NODE_IP}:30080/login\""
echo "  curl -I -H \"Host: uranus-cloud.duckdns.org\" \"http://192.168.88.12/login\""
echo
echo "Then in browser:  http://uranus-cloud.duckdns.org/"
echo "Login with:"
echo "  user: ${NEXTCLOUD_ADMIN_USER}"
echo "  pass: ${NEXTCLOUD_ADMIN_PASSWORD}"

