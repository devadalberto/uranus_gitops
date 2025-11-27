#!/usr/bin/env bash
set -euo pipefail

DB_NS="uranus-db"
DB_USER="uranus_app"
DB_NAME="uranus_homelab"

echo "[1] Pods in ${DB_NS}"
kubectl get pods -n "${DB_NS}" -o wide

echo
echo "[2] Services in ${DB_NS}"
kubectl get svc -n "${DB_NS}"

echo
echo "[3] Picking postgres pod..."
DB_POD="$(kubectl get pod -n "${DB_NS}" -l app=postgres -o jsonpath='{.items[0].metadata.name}')"
echo "DB_POD = ${DB_POD}"

echo
echo "[4] Checking version from inside pod..."
kubectl exec -it -n "${DB_NS}" "${DB_POD}" -- \
  psql -U "${DB_USER}" -d "${DB_NAME}" -c 'SELECT version();'

