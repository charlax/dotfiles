```bash
sudo diskutil unmountdisk force disk2
sudo dd if=/dev/zero of=/dev/disk2 bs=1024 count=1024
```

Use DiskUtility to format to FAT32 with MBR scheme.
