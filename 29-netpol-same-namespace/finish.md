## Well done!
**What you practiced:** Creating a least-permissive NetworkPolicy within a single namespace using podSelector to allow only specific pods to communicate.
**Why it matters in CKA:** NetworkPolicy is a key CKA topic — understanding the difference between podSelector and namespaceSelector for same-namespace vs cross-namespace traffic is frequently tested.
**CKA Domain:** Services & Networking
**Common mistake:** Using `namespaceSelector` when both pods are in the same namespace — for same-namespace traffic, `podSelector` alone is correct and more precise.
**Further reading:** https://kubernetes.io/docs/concepts/services-networking/network-policies/
