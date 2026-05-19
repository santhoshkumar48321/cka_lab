## Well done!
**What you practiced:** Migrating an HTTPS Ingress to the Gateway API by creating a Gateway with TLS termination and an HTTPRoute.
**Why it matters in CKA:** The CKA exam tests both Ingress and Gateway API resources — Gateway API is the modern replacement and TLS configuration is a key differentiator.
**CKA Domain:** Services & Networking
**Common mistake:** Omitting the `tls.certificateRefs` section from the Gateway listener — without it, the HTTPS listener has no certificate and TLS termination fails.
**Further reading:** https://kubernetes.io/docs/concepts/services-networking/gateway/
