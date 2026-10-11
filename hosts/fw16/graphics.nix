{
  # AMD iGPU by default, the NVIDIA module on demand through `nvidia-offload`.
  # The bus IDs are the decimal form of `lspci | grep -E "VGA|Display"`
  # (c2:00.0 and c3:00.0) and move if the expansion bay module changes.
  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:194:0:0";
    amdgpuBusId = "PCI:195:0:0";
  };
}
