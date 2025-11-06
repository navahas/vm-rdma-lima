#!/usr/bin/env bash
set -euo pipefail

echo "Testing RDMA operations..."
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

echo "Test 1: node2 -> node1"

limactl shell node1 rping -s -a 0.0.0.0 -v -C 5 > /tmp/node1-rping.log 2>&1 &
SERVER_PID=$!
sleep 2

limactl shell node2 rping -c -a "$NODE1_IP" -v -C 5 || { kill $SERVER_PID 2>/dev/null; exit 1; }
kill $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true

echo ""
echo "Test 2: node1 -> node2"

limactl shell node2 rping -s -a 0.0.0.0 -v -C 5 > /tmp/node2-rping.log 2>&1 &
SERVER_PID=$!
sleep 2

limactl shell node1 rping -c -a "$NODE2_IP" -v -C 5 || { kill $SERVER_PID 2>/dev/null; exit 1; }
kill $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true

echo ""
echo "RDMA tests passed"
