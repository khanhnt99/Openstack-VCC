# Bash Script to install Openstack
- Phiên bản sử dụng:
    + Openstack Wallaby (Keystone, Glance, Placement, Nova, Neutron (ovs))
    + Hệ điều hành: Ubuntu 20.04
- Document dựa trên:
    + https://github.com/TrongTan124/install-OpenStack
- Preinstall
    + Cài đặt git.
    + Cấu hình netplan network.
    + Trên controller: `./controller-all.sh`
    + Trên compute: `./compute-all.sh`