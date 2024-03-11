<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Install Ubuntu](#install-ubuntu)
  - [SSHD](#sshd)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Install Ubuntu

## SSHD

```bash
sudo apt install openssh-server
sudo vim /etc/ssh/sshd_config
sudo systemctl restart sshd.service
```
