#!/bin/bash
# Author Nguyen Trong Tan
# Edit by khanhnt99
# Ham dinh nghia mau cho cac thong bao hien ra man hinh
function echocolor {
    echo "$(tput setaf 2)##### $1 #####$(tput sgr0)"
}

# Ham sua file config cua Openstack
## Ham add
function ops_add {
    crudini --set $1 $2 $3 $4
}
### How to use
#### ops_add PATH_FILE SECTION PARAMETER VALUE

## Ham del
function ops_del {
    crudini --del $1 $2 $3
}
### How to use
#### ops_del PATH_FILE SECTION PARAMETER