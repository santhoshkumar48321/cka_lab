## Well done! 🎉

You practiced rendering a Helm chart to static YAML while excluding pre-installed CRDs.

**Why it matters on the CKA exam**: GitOps and Helm templating questions test your ability to manage cluster resources declaratively without causing API conflicts from duplicate CRD installation.

**CKA Domain**: Cluster Architecture, Installation & Configuration

**Common mistake to avoid**: Forgetting `--skip-crds` and piping the output directly to `kubectl apply` — the API server will reject it with "CustomResourceDefinition already exists" for every Argo CD CRD.

**Further reading**: https://helm.sh/docs/helm/helm_template/
