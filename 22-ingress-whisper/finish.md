## Well done!
**What you practiced:** Creating an Ingress resource with host-based routing to forward external traffic to an internal ClusterIP service.
**Why it matters in CKA:** Ingress configuration is a core networking topic on the CKA exam — you must know how to route traffic by hostname and path.
**CKA Domain:** Services & Networking
**Common mistake:** Forgetting to specify `pathType: Prefix` — without it, many Ingress controllers reject the rule or use undefined behaviour.
**Further reading:** https://kubernetes.io/docs/concepts/services-networking/ingress/
