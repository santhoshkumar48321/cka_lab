## Well done! 🎉

You have successfully created a least-permissive NetworkPolicy.

**CKA Domain:** Services & Networking
**Common mistake:** Forgetting to label the source namespace so `namespaceSelector` matches, which makes the policy appear correct but still blocks traffic.
**Further reading:** https://kubernetes.io/docs/concepts/services-networking/network-policies/
