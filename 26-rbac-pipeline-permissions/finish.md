## Well done!
**What you practiced:** Creating a ClusterRole with minimal deployment permissions and binding it to a ServiceAccount scoped to a single namespace using a RoleBinding.
**Why it matters in CKA:** RBAC is a core CKA security topic — the key insight is that a RoleBinding (not ClusterRoleBinding) to a ClusterRole grants namespace-scoped permissions, which is the correct pattern for CI/CD pipelines.
**CKA Domain:** Security
**Common mistake:** Using a ClusterRoleBinding instead of a RoleBinding — this would grant the ServiceAccount cluster-wide permissions, violating the principle of least privilege.
**Further reading:** https://kubernetes.io/docs/reference/access-authn-authz/rbac/
