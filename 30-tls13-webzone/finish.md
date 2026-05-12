## Well done!
**What you practiced:** Editing a ConfigMap to enforce TLS 1.3-only on an nginx Deployment, then triggering a rollout to apply the change.
**Why it matters in CKA:** Security hardening via ConfigMap changes is a common CKA scenario — understanding that pods must be restarted to pick up ConfigMap changes is critical.
**CKA Domain:** Security
**Common mistake:** Editing the ConfigMap but forgetting to restart the Deployment — nginx reads its config at startup, so the change only takes effect after a pod restart.
**Further reading:** https://kubernetes.io/docs/concepts/configuration/configmap/
