#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$ROOT_DIR/docs"
GEN_DIR="$DOCS_DIR/_generated"
README="$ROOT_DIR/README.md"

mkdir -p "$GEN_DIR"

############################
# 1) Capture live state    #
############################

# Host networking snapshot
{
  echo '# Host networking snapshot'
  echo
  echo '```bash'
  echo 'ip -br addr'
  ip -br addr
  echo
  echo 'ip route'
  ip route
  echo '```'
} > "$GEN_DIR/host-network.md"

# Kubernetes summary (nodes, ingress, nextcloud, postgres)
{
  echo '# Kubernetes summary'
  echo
  echo '```bash'
  echo '# Nodes'
  kubectl get nodes -o wide
  echo
  echo '# Traefik services'
  kubectl get svc -n traefik
  echo
  echo '# Nextcloud (homelab-apps)'
  kubectl get deploy,svc,ingress -n homelab-apps
  echo
  echo '# Postgres (uranus-db)'
  kubectl get statefulset,svc,pvc -n uranus-db
  echo '```'
} > "$GEN_DIR/k8s-summary.md"

############################
# 2) Assemble README       #
############################

cat > "$README" <<'EOF'
# Uranus homelab

> WARNING: This file is auto-generated.  
> Edit the files under `docs/` and re-run `scripts/gen-readme.sh`.

This repo describes and automates the homelab on **uranus**:

- KVM/libvirt VMs (pfSense, Pi-hole, etc.)
- Minikube cluster with Traefik
- Nextcloud + PostgreSQL
- Secrets managed with `sops` and `age`
EOF

# Append all manual docs (sorted) then generated snapshots
for section in "$DOCS_DIR"/[0-9][0-9]-*.md; do
  [ -f "$section" ] || continue
  printf '\n\n---\n\n' >> "$README"
  cat "$section" >> "$README"
done

for section in "$GEN_DIR"/*.md; do
  [ -f "$section" ] || continue
  printf '\n\n---\n\n' >> "$README"
  cat "$section" >> "$README"
done

echo "README.md regenerated at $README"

