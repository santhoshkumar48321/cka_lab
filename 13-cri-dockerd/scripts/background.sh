#!/usr/bin/env bash
set -euo pipefail

wait_kube() {
  for i in $(seq 1 60); do
    if kubectl get ns >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  echo "Kubernetes API not ready after 60 seconds" >&2
  exit 1
}

wait_kube

if ! command -v docker >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y docker.io
fi

service docker start
sleep 3

DEB_SYSTEMD_INVOKE="/usr/bin/deb-systemd-invoke"
DEB_SYSTEMD_INVOKE_BAK="/usr/bin/deb-systemd-invoke.bak"
restore_deb_systemd_invoke() {
  if [ -f "$DEB_SYSTEMD_INVOKE_BAK" ]; then
    mv -f "$DEB_SYSTEMD_INVOKE_BAK" "$DEB_SYSTEMD_INVOKE"
  fi
}

trap restore_deb_systemd_invoke EXIT

if [ -f "$DEB_SYSTEMD_INVOKE" ]; then
  cp "$DEB_SYSTEMD_INVOKE" "$DEB_SYSTEMD_INVOKE_BAK"
  cat > "$DEB_SYSTEMD_INVOKE" <<'YAML'
#!/usr/bin/env bash
exit 0
YAML
  chmod +x "$DEB_SYSTEMD_INVOKE"
fi

DEB_PATH="/root/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb"
if [ ! -f "$DEB_PATH" ]; then
  curl -fsSL "https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.15/cri-dockerd_0.3.15.3-0.ubuntu-jammy_amd64.deb" -o "$DEB_PATH"
fi

dpkg -i "$DEB_PATH" 2>/dev/null || true

restore_deb_systemd_invoke
trap - EXIT

systemctl daemon-reload

echo "Setup complete"
