#!/usr/bin/env bash
set -euo pipefail

echo "Testing connectivity..."
echo ""

NODE1_IP=$(limactl shell node1 hostname -I 2>/dev/null | awk '{print $2}')
NODE2_IP=$(limactl shell node2 hostname -I 2>/dev/null | awk '{print $2}')

if [ -z "$NODE1_IP" ] || [ -z "$NODE2_IP" ]; then
    echo "ERROR: Could not get IPs"
    echo "Check socket_vmnet: sudo brew services start socket_vmnet"
    exit 1
fi

echo "node1: $NODE1_IP"
echo "node2: $NODE2_IP"
echo ""

limactl shell node1 ping -c 3 "$NODE2_IP" >/dev/null 2>&1 || { echo "FAIL: node1 -> node2"; exit 1; }
limactl shell node2 ping -c 3 "$NODE1_IP" >/dev/null 2>&1 || { echo "FAIL: node2 -> node1"; exit 1; }

echo "Connectivity: OK"
echo ""

echo "RDMA devices:"
echo "node1: $(limactl shell node1 ibv_devices 2>/dev/null | grep -c rxe || echo '0')"
echo "node2: $(limactl shell node2 ibv_devices 2>/dev/null | grep -c rxe || echo '0')"
echo ""

echo "If no devices, run setup-rxe.sh on both nodes"
