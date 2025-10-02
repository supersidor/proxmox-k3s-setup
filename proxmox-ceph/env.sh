export ARGS="[Configurations]
namespace = rook-ceph
rgw-pool-prefix = default
format = bash
cephfs-filesystem-name = cephfs
cephfs-metadata-pool-name = cephfs_metadata
cephfs-data-pool-name = cephfs_data
rbd-data-pool-name = k3s
"
export NAMESPACE=rook-ceph
export ROOK_EXTERNAL_FSID=2e6caa76-139c-4707-a8dd-4d33b49efa93
export ROOK_EXTERNAL_USERNAME=client.healthchecker
export ROOK_EXTERNAL_CEPH_MON_DATA=home1=192.168.50.134:6789,home2=192.168.50.233:6789,home3=192.168.50.191:6789
export ROOK_EXTERNAL_USER_SECRET=AQApT9hoYehwCBAAFNi4csn8Hmk0+vsEKSsu+g==
export ROOK_EXTERNAL_DASHBOARD_LINK=https://192.168.50.134:8443/
export CSI_RBD_NODE_SECRET=AQApT9hoiXa8CBAASiwIsViHrCyUfIv9lp28MQ==
export CSI_RBD_NODE_SECRET_NAME=csi-rbd-node
export CSI_RBD_PROVISIONER_SECRET=AQApT9hoWJ4DCRAAHGBC6YswwbA2U9fJIYx6UQ==
export CSI_RBD_PROVISIONER_SECRET_NAME=csi-rbd-provisioner
export CEPHFS_POOL_NAME=cephfs_data
export CEPHFS_METADATA_POOL_NAME=cephfs_metadata
export CEPHFS_FS_NAME=cephfs
export CSI_CEPHFS_NODE_SECRET=AQApT9ho42xMCRAA8cF9TJOsK+FBo3aKgDRCrQ==
export CSI_CEPHFS_PROVISIONER_SECRET=AQApT9hoTPqOCRAAqjkd56qolZdd5xY9CGdvaA==
export CSI_CEPHFS_NODE_SECRET_NAME=csi-cephfs-node
export CSI_CEPHFS_PROVISIONER_SECRET_NAME=csi-cephfs-provisioner
export MONITORING_ENDPOINT=192.168.50.134
export MONITORING_ENDPOINT_PORT=9283
export RBD_POOL_NAME=k3s
export RGW_POOL_PREFIX=default