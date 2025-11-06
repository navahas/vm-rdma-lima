#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA_DIR="$(dirname "$SCRIPT_DIR")"

echo "Starting RDMA cluster..."
echo ""

limactl start --name=node --tty=false "$INFRA_DIR/node.yaml" &
NODE1_PID=$!

limactl start --name=node --tty=false "$INFRA_DIR/node.yaml" &
NODE2_PID=$!

echo "Waiting for VMs to boot..."
wait $NODE1_PID
wait $NODE2_PID

echo ""
echo "Both VMs running"
echo ""

echo "node1: $(limactl shell node1 hostname -I 2>/dev/null || echo 'starting...')"
echo "node2: $(limactl shell node2 hostname -I 2>/dev/null || echo 'starting...')"
echo ""

echo "Next steps:"
echo "  limactl shell node1 sudo /Users/navahas/dev/fasts3/vm/infra/scripts/setup-rxe.sh"
echo "  limactl shell node2 sudo /Users/navahas/dev/fasts3/vm/infra/scripts/setup-rxe.sh"
echo "  ./tests/test-connectivity.sh"
