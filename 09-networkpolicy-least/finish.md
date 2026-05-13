## Well done! 🎉

You practiced implementing a least-permissive NetworkPolicy strategy using a default-deny base policy plus a targeted allow policy.

**Why it matters on the CKA exam**: NetworkPolicy is a major Services & Networking topic. Exam questions frequently require you to write policies that allow specific namespaces or pods while denying everything else.

**CKA Domain**: Services & Networking

**Common mistake to avoid**: Missing a podSelector for same-namespace traffic and using a namespaceSelector instead.

**Further reading**: https://kubernetes.io/docs/concepts/services-networking/network-policies/
