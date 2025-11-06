#!/usr/bin/env bash
set -euo pipefail

echo "Stopping RDMA cluster..."

limactl stop node1 &
limactl stop node2 &
wait

echo "VMs stopped"

if [[ "${1:-}" == "delete" ]]; then
    echo "Deleting VMs..."
    limactl delete -f node1
    limactl delete -f node2
    echo "VMs deleted"
fi
