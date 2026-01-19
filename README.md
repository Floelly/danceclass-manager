# DanceFlow – Cloud Deployment (Terraform + GCP)

Dieses Projekt stellt die Infrastruktur für die DanceFlow Full‑Stack Web App auf **Google Cloud** mit **Terraform** bereit.

## Architektur Überblick

- **Frontend**: statische Dateien (HTML/CSS/JS) in einem **Cloud Storage Bucket** als Website.
- **Backend**: Spring Boot REST‑API auf **Cloud Run**.
- **Datenbank**: **Cloud SQL** (MySQL) mit Verbindung über VPC / Cloud SQL Connector.

Terraform erzeugt die komplette Infrastruktur (SQL, Netzwerk, Bucket, Cloud Run Service, Service Accounts, IAM Rechte und Firewall Rules).

## Voraussetzungen

Auf der Maschine müssen installiert sein:
- `gcloud` (Google Cloud SDK, inkl. Auth)
- `terraform` (Version siehe `required_version` in `*infrastructure/main.tf`)
- GCP-Project mit aktiviertem Billing und Owner-Rechten für deinen Account

## Folder structure

- `backend/`: spring boot backend auf maven Basis
- `frontend/`: staatisches html/css/js
- `infrastructure/`: terraform IaC scripts
- `README.md`

## Vorbereitung

### 1. **Authentifizierung für gcloud (einmalig pro maschine)**

```bash
gcloud config set project <PROJECT_ID>
gcloud auth login
gcloud auth application-default login
```
Browser öffnet und dann mit GCP-User-Account einloggen und Rechte vergeben.

### 3. **Variablen anpassen (einmalig auf gcp setup abgestimmt)**

In `*infrastructure/terraform.tfvars.example` liegen Beispielwerte. Kopieren:

```bash
cd infrastructure
cp terraform.tfvars.example terraform.tfvars
```

Wichtige Variablen:
- `project_id` - GCP Projekt  
- `database_password` - password for spring boot database user

Optionale Variablen:
- `region` - z.B. `europe-west3`
- `database_name`, `database_user` - for spring boot database connection
- mehr mögliche variablen in `*infrastructure/variables.tf`

### 4. **Infrastructure Setup**

```bash
cd infrastructure
terraform init
terraform validate
terraform apply
```

### 5. **Aufruf der Anwendung**

- **Frontend**:  
  - `frontend_url` im Browser öffnen.
- **Backend**:  
  - nur über Frontend erreichbar wegen Sicherheit.
- **Cloud SQL**:
  - nur über Backend erreichbar wegen Sicherheit

### 6. **Infrastructure Teardown**

```bash
cd infrastructure
terraform destroy
```


# NOTES:

1. docker image bauen und pushen:
```bash
$PROJECT_ID = "dance-class-manager-eu" # replace with correct project id
$BACKEND_VERSION = "v0.0.3"
docker build -t europe-west3-docker.pkg.dev/$PROJECT_ID/dance-class-manager-eu-docker-repo/backend:$BACKEND_VERSION ./backend/
docker tag europe-west3-docker.pkg.dev/$PROJECT_ID/dance-class-manager-eu-docker-repo/backend:$BACKEND_VERSION europe-west3-docker.pkg.dev/$PROJECT_ID/dance-class-manager-eu-docker-repo/backend:latest
docker push europe-west3-docker.pkg.dev/$PROJECT_ID/dance-class-manager-eu-docker-repo/backend:latest
```
2. cloud run image auf das backend:latest switchen
3. TADAAAA backend erreichbar.