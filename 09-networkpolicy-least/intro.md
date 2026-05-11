## Goal
Allow traffic from frontend to backend while keeping policy least permissive.

## Requirements
- Namespace: `frontend`
- Namespace: `backend`
- Deployment/Pod label in frontend: `app=frontend-app`
- Deployment/Pod label in backend: `app=backend-api`
- Create a NetworkPolicy in namespace `backend` that only allows ingress from namespace `frontend` to backend pods.
