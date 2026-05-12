## Well done! 🎉

You practiced the full GitOps Helm workflow: rendering manifests with and without CRDs, then safely applying to a cluster that already has CRDs installed.

**Why it matters on the CKA exam**: The exam tests whether you understand the *why* behind `--skip-crds` / `--set crds.install=false` — not just the flag itself. A cluster that already has Argo CD CRDs will reject a `kubectl apply` that tries to recreate them. Knowing to split the render step from the apply step is the key insight.

**CKA Domain**: Cluster Architecture, Installation & Configuration

**Common mistake (real exam trap)**: Using `--skip-crds` on the *wrong* render — candidates often disable CRDs on the file they intend to apply but forget to also save a CRDs-included copy as the reference. The second trap is forgetting to create the target namespace before `kubectl apply`, causing every namespaced resource to fail.

**Further reading**: https://helm.sh/docs/helm/helm_template/
