## Well done! 🎉

You practiced creating a PersistentVolumeClaim and wiring it into a Deployment so a stateful application has durable storage.

**Why it matters on the CKA exam**: PVC creation and volume mounting are core Storage domain skills. Exam questions often combine creating the PVC with editing a Deployment or Pod spec to use it.

**CKA Domain**: Storage

**Common mistake to avoid**: Applying the Deployment before the PVC exists, which leaves the pod stuck Pending.

**Further reading**: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
