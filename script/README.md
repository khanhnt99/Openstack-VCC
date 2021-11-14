# Bash Script to install Openstack
- Phiên bản sử dụng:
    + Openstack Wallaby (Keystone, Glance, Placement, Nova, Neutron (ovs))
    + Hệ điều hành: Ubuntu 20.04
- Document dựa trên:
    + https://github.com/TrongTan124/install-OpenStack
- Preinstall
    + Cài đặt git.
    + Thay đổi các giá trị biến trong file config.
    + Sửa đổi file `/etc/cloud/cloud.cfg` để đổi hostname.
    + Trên controller: `./controller-all.sh`
    + Trên compute1: `./compute1-all.sh`
    + Trên compute2: `./compute2-all.sh`