#!/usr/bin/env bash
set -euo pipefail

echo "Setting up Soft-RoCE..."

lsmod | grep -q rdma_rxe || modprobe rdma_rxe

if rdma link show | grep -q rxe0; then
    echo "rxe0 already exists"
    exit 0
fi

PRIMARY_IFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
[ -z "$PRIMARY_IFACE" ] && echo "ERROR: No network interface found" && exit 1

echo "Creating rxe0 on $PRIMARY_IFACE"
rdma link add rxe0 type rxe netdev "$PRIMARY_IFACE"

rdma link show | grep -q rxe0 || { echo "ERROR: Failed to create rxe0"; exit 1; }

echo "Soft-RoCE setup complete"
ibv_devices
