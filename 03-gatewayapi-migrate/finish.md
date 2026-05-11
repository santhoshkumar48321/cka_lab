## Well done! 🎉

You practiced migrating a classic Ingress resource to the Gateway API — a modern, extensible Kubernetes networking standard.

**Why it matters on the CKA exam**: The CKA exam tests knowledge of both Ingress and Gateway API resources. Understanding how to translate between them demonstrates depth in the Services & Networking domain.

**CKA Domain**: Services & Networking

**Common mistake to avoid**: Using the wrong `gatewayClassName` value — it must match exactly: `nginx-gateway`. The controller ignores Gateways with an unknown class, so nothing will work and there will be no obvious error message.

**Further reading**: https://kubernetes.io/docs/concepts/services-networking/gateway/
