## Well done!
**What you practiced:** Rendering a Helm chart to static YAML with and without CRDs using the `--set crds.install=false` flag.
**Why it matters in CKA:** GitOps and Helm templating questions test your ability to manage cluster resources declaratively without causing API conflicts from duplicate CRD installation.
**CKA Domain:** Cluster Architecture, Installation & Configuration
**Common mistake:** Using `--skip-crds` instead of `--set crds.install=false` — for the argo/argo-cd chart, the correct flag is `--set crds.install=false` (the chart controls CRD installation via a value, not the standard Helm flag).
**Further reading:** https://helm.sh/docs/helm/helm_template/
