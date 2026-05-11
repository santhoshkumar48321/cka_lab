## Well done! 🎉

You practiced implementing a least-permissive NetworkPolicy strategy using a default-deny base policy plus a targeted allow policy.

**Why it matters on the CKA exam**: NetworkPolicy is a major Services & Networking topic. Exam questions frequently require you to write policies that allow specific namespaces or pods while denying everything else.

**CKA Domain**: Services & Networking

**Common mistake to avoid**: Creating only the allow policy without the default-deny — without default-deny, all other pods in the cluster can still reach the backend because Kubernetes allows all traffic by default when no policies apply.

**Further reading**: https://kubernetes.io/docs/concepts/services-networking/network-policies/
