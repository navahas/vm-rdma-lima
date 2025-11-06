# VMS

```
rdma-core          # Core RDMA user-space libraries (libibverbs + librdmacm shared libs)
libibverbs-dev     # Development headers for low-level RDMA verbs API (e.g. infiniband/verbs.h)
librdmacm-dev      # Development headers for the RDMA Connection Manager API (rdma/rdma_cma.h)
ibverbs-utils      # Command-line tools for basic verbs testing (ibv_devinfo, ibv_rc_pingpong, ibv_srq_pingpong, etc.)
rdmacm-utils       # RDMA CM command-line tools (rping, rdma link show, rdma res show, etc.)
infiniband-diags   # Diagnostic and debug tools for IB/RDMA devices (ibstat, perfquery, iblinkinfo, etc.)
build-essential    # GCC, g++, make, and build tools for compiling the C examples
iproute2           # Networking utilities (ip link, addr, route) — used to inspect and configure interfaces like eth0
ethtool            # Inspect and configure Ethernet devices (needed when enabling Soft-RoCE over eth0)
pciutils           # Shows PCI devices (lspci) — helpful to check for physical or virtual RNICs
```

```bash
# setup
sudo modprobe rdma_rxe
sudo rdma link add rxe0 type rxe netdev eth0
rdma link show
```

| Command                  | Needed For                    | Package                                              |
| ------------------------ | ----------------------------- | ---------------------------------------------------- |
| `modprobe rdma_rxe`      | Load Soft-RoCE kernel module  | `rdma-core`                                          |
| `rdma link add/show`     | Create and inspect rxe device | `rdmacm-utils`                                       |
| `ibv_devices`            | Verify verbs layer visibility | `ibverbs-utils`                                      |
| `gcc -libverbs -lrdmacm` | Compile RDMA programs         | `libibverbs-dev`, `librdmacm-dev`, `build-essential` |
| `ip`, `ethtool`, `lspci` | Debug / network setup         | `iproute2`, `ethtool`, `pciutils`                    |
