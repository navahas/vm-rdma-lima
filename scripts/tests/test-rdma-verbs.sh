#!/usr/bin/env bash
set -euo pipefail

echo "Testing RDMA verbs API..."
echo ""
NODE1_IP=$(limactl shell node1 hostname -I 2>/dev/null | awk '{print $2}')
NODE2_IP=$(limactl shell node2 hostname -I 2>/dev/null | awk '{print $2}')

[ -z "$NODE1_IP" ] || [ -z "$NODE2_IP" ] && echo "ERROR: Could not get IPs" && exit 1

echo "node1: $NODE1_IP"
echo "node2: $NODE2_IP"
echo ""

NODE1_DEVICES=$(limactl shell node1 ibv_devices 2>/dev/null | grep -c rxe || echo "0")
NODE2_DEVICES=$(limactl shell node2 ibv_devices 2>/dev/null | grep -c rxe || echo "0")

[ "$NODE1_DEVICES" = "0" ] || [ "$NODE2_DEVICES" = "0" ] && echo "ERROR: RDMA devices not found. Run setup-rxe.sh first." && exit 1

echo "RC ping-pong test (1000 iterations, 4KB)"

limactl shell node1 ibv_rc_pingpong -d rxe0 -g 0 > /tmp/node1-verbs.log 2>&1 &
SERVER_PID=$!
sleep 3

limactl shell node2 ibv_rc_pingpong -d rxe0 -g 0 "$NODE1_IP" 2>&1 || { kill $SERVER_PID 2>/dev/null; exit 1; }

kill $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true

echo ""
echo "RDMA verbs API test passed"
