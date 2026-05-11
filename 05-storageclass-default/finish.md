## Well done! 🎉

You practiced creating a StorageClass and designating it as the cluster default so PVCs can be fulfilled automatically without specifying a storage class.

**Why it matters on the CKA exam**: StorageClass configuration is a key Storage domain topic. Exam questions often test whether you know the exact annotation name and value needed to set a default.

**CKA Domain**: Storage

**Common mistake to avoid**: Setting `is-default-class: "true"` when another StorageClass is already marked as default — having two default StorageClasses causes inconsistent PVC binding behavior and may be penalised.

**Further reading**: https://kubernetes.io/docs/concepts/storage/storage-classes/#default-storageclass
