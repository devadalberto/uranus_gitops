#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

DATE_TAG="$(date +%Y%m%d_%H%M%S)"

echo "[*] Snapshotting systemd units..."
mkdir -p infra/systemd

for unit in \
  nextcloud-port-forward.service \
  minecraft-atm10-port-forward.service
do
  if [ -f "/etc/systemd/system/$unit" ]; then
    sudo cp "/etc/systemd/system/$unit" "infra/systemd/$unit"
    sudo chown "$(id -u):$(id -g)" "infra/systemd/$unit"
    echo "  - captured $unit"
  else
    echo "  - $unit not found, skipping"
  fi
done

echo "[*] Snapshotting UFW rules..."
mkdir -p docs
sudo ufw status numbered > "docs/ufw-uranus-${DATE_TAG}.txt" || true

echo "[*] Snapshotting Kubernetes state..."
kubectl config use-context minikube >/dev/null 2>&1 || true

kubectl get nodes -o wide          > "docs/k8s-nodes-${DATE_TAG}.txt"      || true
kubectl get pods -A -o wide        > "docs/k8s-pods-${DATE_TAG}.txt"       || true
kubectl get svc  -A -o wide        > "docs/k8s-svcs-${DATE_TAG}.txt"       || true
kubectl -n homelab-apps get deploy nextcloud onlyoffice-docs -o yaml \
  > "docs/k8s-nextcloud-onlyoffice-${DATE_TAG}.yaml" || true
kubectl -n games get deploy,minecraft-atm10,svc/minecraft-atm10 -o yaml \
  > "docs/k8s-minecraft-atm10-${DATE_TAG}.yaml" || true

echo "[*] Exporting env var template from ~/.bashrc..."
mkdir -p env
grep -E '^(DB_|MC_|CF_|OO_)[A-Z0-9_]*=' "$HOME/.bashrc" 2>/dev/null \
  | sed -E 's/=(.*)$/=<changeme>/' \
  > "env/uranus-env.sample" || true

echo
echo "[*] Snapshot complete. New/updated files under infra/, docs/, env/."
