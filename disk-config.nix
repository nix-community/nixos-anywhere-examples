# Example to create a bios compatible gpt partition
{ lib, disks ? [ "/dev/sda" ], ... }: {
  disk = lib.genAttrs disks (dev: {
    device = dev;
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          name = "boot";
          size = "1M";
          type = "EF02";
        };
        esp = {
          name = "ESP";
          size = "500M";
          type = "EF00";
          content = {
            type = "mdraid";
            name = "boot";
          };
        };
        root = {
          name = "root";
          size = "100%";
          content = {
            type = "lvm_pv";
            vg = "pool";
          };
        };
      };
    };
  });
  mdadm = {
    boot = {
      type = "mdadm";
      level = 1;
      metadata = "1.0";
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
      };
    };
  };
  lvm_vg = {
    pool = {
      type = "lvm_vg";
      lvs = {
        root = {
          size = "100%FREE";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [
              "defaults"
            ];
          };
        };
      };
    };
  };
}
