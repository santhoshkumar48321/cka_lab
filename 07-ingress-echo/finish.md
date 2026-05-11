## Well done! 🎉

You practiced creating a ClusterIP Service and an Ingress resource to expose an application at a specific host and path.

**Why it matters on the CKA exam**: Ingress configuration is a frequent exam topic in the Services & Networking domain, often asking for specific ports, hosts, and paths.

**CKA Domain**: Services & Networking

**Common mistake to avoid**: Exposing the wrong port on the Service — the Service must listen on port `8090` (not `80`) while targeting pod port `80`. Mixing these up causes the Ingress backend check to fail.

**Further reading**: https://kubernetes.io/docs/concepts/services-networking/ingress/
