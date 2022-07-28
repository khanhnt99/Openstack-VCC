# Cài đặt Percona ExtraDB Cluster
## 1. All node
- `wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb`
- `dpkg -i percona-release_latest.generic_all.deb`
- `percona-release enable pxc-57 release`
- `apt-get update`
- `apt search percona-xtradb-cluster`

```
Sorting... Done
Full Text Search... Done
percona-xtradb-cluster-5.7-dbg/unknown,stable 5.7.34-31.51-1.focal amd64
  Debugging package for Percona XtraDB Cluster

percona-xtradb-cluster-57/unknown,stable 5.7.34-31.51-1.focal amd64
  Percona XtraDB Cluster with Galera

percona-xtradb-cluster-client-5.7/unknown,stable 5.7.34-31.51-1.focal amd64
  Percona XtraDB Cluster database client binaries

percona-xtradb-cluster-common-5.7/unknown,stable 5.7.34-31.51-1.focal amd64
  Percona XtraDB Cluster database common files (e.g. /etc/mysql/my.cnf)

percona-xtradb-cluster-full-57/unknown,stable 5.7.34-31.51-1.focal amd64
  Percona XtraDB Cluster with Galera

percona-xtradb-cluster-garbd-5.7/unknown,stable 5.7.34-31.51-1.focal amd64
  Garbd components of Percona XtraDB Cluster

percona-xtradb-cluster-garbd-debug-5.7/unknown,stable 5.7.34-31.51-1.focal amd64
  Debugging package for Percona XtraDB Cluster Garbd.

percona-xtradb-cluster-server-5.7/unknown,stable 5.7.34-31.51-1.focal amd64
  Percona XtraDB Cluster database server binaries

percona-xtradb-cluster-server-debug-5.7/unknown,stable 5.7.34-31.51-1.focal amd64
  Percona XtraDB Cluster database server UNIV_DEBUG binaries

percona-xtradb-cluster-source-5.7/unknown,stable 5.7.34-31.51-1.focal amd64
  Percona XtraDB Cluster 5.7 source

percona-xtradb-cluster-test-5.7/unknown,stable 5.7.34-31.51-1.focal amd64
  Percona XtraDB Cluster database test suite
```
- `apt install percona-xtradb-cluster-57`

- Tip: Nếu không thể xóa dùng `dpkg -l | grep percona` list các package ra rồi purge + remove từng package `(lưu ý xóa cả file còn chứa)`.
- Cấu hình theo file `mysqld.cnf` trên tất cả các node.
- `mv wsrep.cnf wsrep.cnf.bak`


## 2. Node 1
- `/etc/init.d/mysql bootstrap-pxc`
- `CREATE USER 'sstuser'@'localhost' IDENTIFIED BY 'password';`
- `GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';`
- `FLUSH PRIVILEGES;`

## 3. Othernode 
- `service mysql restart`.

```
mysql> show status like 'wsrep_cluster_size';
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 2     |
+--------------------+-------+
1 row in set (0.01 sec)
```

#### Docs
- https://www.percona.com/doc/percona-xtradb-cluster/5.7/install/apt.html#apt
- https://repo.percona.com/apt/