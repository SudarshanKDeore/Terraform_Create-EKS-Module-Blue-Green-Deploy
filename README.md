# Terraform_Create-EKS-Module-Blue-Green-Deploy

```
Blue-Green EKS is implemented by creating two identical clusters with separate Terraform states and switching traffic between them for zero-downtime deployments.

ALB Ingress Blue-Green uses separate Kubernetes services behind one ALB, and traffic is switched instantly by updating the Ingress backend without downtime.
```

## ▶️ How to Deploy (Blue / Green)

## Blue
```
cd envs/production/blue
terraform init -backend-config=backend.hcl
terraform apply
```

## Green
```
cd envs/production/green
terraform init -backend-config=backend.hcl
terraform apply
```

## 🧠 Key Concept (VERY IMPORTANT)

## File	Purpose
```
backend.hcl	            - Where state is stored
main.tf	                - What infrastructure is created
Module	                - Reusable logic
No tfvars	             - Values fixed per env
```

## 🧠 High-Level Flow
```
User
 ↓
Route53 DNS
 ↓
ALB (Ingress)
 ├── Target Group → app-blue (current)
 └── Target Group → app-green (new)

Switch traffic by changing Ingress rule.
```

## 🔁 Traffic Switch (Blue → Green)
## 🔄 Update ONLY this line: name: app-blue to name: app-green Manually
```
backend:
  service:
    name: app-blue           ---->  # app-green
    port:
      number: 80

Apply:
kubectl apply -f ingress.yaml

✅ ALB updates target group
✅ No restart
✅ No downtime
```
## ⏪ Rollback (Green → Blue)
```
Just switch back:
  name: app-blue
```
## 🚀 Zero-Downtime Strategy
```
Step	Action
1	    Deploy Green
2	    Test Green internally
3	    Switch Ingress
4	    Monitor
5	    Delete Blue later
```

# In Terms Of Jenkins CI-CD Pipeline-
## 📁 Repo Structure (Typical)
```
k8s/
├── blue/
│   ├── deployment.yaml
│   └── service.yaml
├── green/
│   ├── deployment.yaml
│   └── service.yaml
└── ingress.yaml
```
## 🧠 Blue-Green Pipeline Flow in terms of Jenkins
```
Code Push
   ↓
Jenkins Build
   ↓
Deploy GREEN
   ↓
Health Check
   ↓
Switch ALB Ingress
   ↓
Monitor
   ↓
Cleanup BLUE (optional)
```
## 🔁 Traffic Switch in Jenkinsfile (Blue → Green)
```
    stage('Switch Traffic to GREEN') {
      steps {
        sh '''
        sed -i 's/app-blue/app-green/g' k8s/ingress.yaml
        kubectl apply -f k8s/ingress.yaml
        '''
      }
    }
```
## sed -i 's/app-blue/app-green/g' k8s/ingress.yaml
```
sed               -->   Stream EDitor
-i                -->   In-place edit
k8s/ingress.yaml  -->   The file being modified
```
```
__'s/app-blue/app-green/g'__
s         -->    Substitute
app-blue  -->    Search pattern
app-green -->    Replacement
g         -->    Global (replace all matches in file)
```
