# Dance Class Manager – Cloud Deployment (Terraform + GCP)

Dieses Repository ist im Rahmen eines Projekts im Studium entstanden. 
Zentraler Aspekt war die Entwicklung einer Cloud Infrastruktur, die mit IaC beschrieben ist.
Gewählt wurde eine klassische 3-Schichten-Webapp, die mittels Terraform auf GCP deployed wurde. 
Die zugrundeliegende App ist minimalistisch und dient lediglich der Anschauung.

## Grober Architektur Überblick

- **Frontend**: statische Dateien (HTML/CSS/JS) in einem **Cloud Storage Bucket** über HTTPS(S) Load Balancer als Website.
- **Backend**: Spring Boot REST‑API auf **Cloud Run**.
- **Datenbank**: **Cloud SQL** (MySQL) mit Verbindung über VPC / Cloud SQL Connector.

Terraform erzeugt die komplette Infrastruktur (SQL, Netzwerk, Bucket, Cloud Run Service, Loadbalancer, Service Accounts, IAM Rechte und Firewall Rules).

## Vorraussetzungen

Auf der Maschine müssen installiert sein:
- `gcloud` (Google Cloud SDK, inkl. Auth)
- `terraform` (mindestens version 1.14)
- `docker` (um ein image des backends zu bauen)

Ferner muss ein GCP-Project mit aktiviertem Billing und Owner-Rechten für den autorisierten Account vorliegen.


## Vorbereitung

1. **Authentifizierung für gcloud (einmalig pro maschine)**
```bash
gcloud config set project <PROJECT_ID>
gcloud auth login
gcloud auth application-default login
```
Browser öffnet und dann mit GCP-User-Account einloggen und Rechte vergeben.

2. **Variablen anpassen (einmalig auf gcp setup abgestimmt)**

In `*infrastructure/terraform.tfvars.example` liegen Beispielwerte. Kopieren:

```bash
cd infrastructure
cp terraform.tfvars.example terraform.tfvars
```

Wichtige Variablen:
- `project_id` - GCP Projekt  
- `region` - GCP Projekt Region
- mehr mögliche variablen in `*infrastructure/variables.tf`

3. Grundlegende Service APIs von GCP im Projekt aktivieren
```bash
gcloud services enable cloudresourcemanager.googleapis.com serviceusage.googleapis.com
gcloud services enable compute.googleapis.com artifactregistry.googleapis.com 
```

## **Infrastructure Setup**

```bash
cd infrastructure
terraform init
terraform plan
terraform apply
```
Jetzt steht nur die Infrastruktur! Frontend und Backend müssen manuell hochgeladen werden. Siehe unten bei Frontend Deploy und Backend Deploy

## **Infrastructure Teardown**

```bash
cd infrastructure
terraform destroy
```

## **Aufruf der Anwendung**

  `frontend_url` im Browser öffnen.

## Backend Deploy:
1. docker image bauen und pushen:
```bash
$PROJECT_ID = "dance-class-manager-eu" # replace with correct project id
$BACKEND_VERSION = "v0.0.3" # replace with next version
docker build -t europe-west3-docker.pkg.dev/$PROJECT_ID/dance-class-manager-eu-docker-repo/backend:$BACKEND_VERSION ./backend/
docker tag europe-west3-docker.pkg.dev/$PROJECT_ID/dance-class-manager-eu-docker-repo/backend:$BACKEND_VERSION europe-west3-docker.pkg.dev/$PROJECT_ID/dance-class-manager-eu-docker-repo/backend:latest
docker push europe-west3-docker.pkg.dev/$PROJECT_ID/dance-class-manager-eu-docker-repo/backend:latest
```
2. cloud run image auf das backend:latest switchen
3. TADAAAA backend erreichbar.

## Frontend Deploy:
1. staatische daten hochladen:
```bash
gsutil -m rsync -d -r ./frontend/ gs://dance-class-manager-eu-frontend/
```
## Author
[Floelly](https://github.com/Floelly)

## Contributing
This is a student project and is not actively accepting contributions or feature requests.

## Project Status
Student project finished 03/2026 - not maintained

## License
The MIT License (MIT): (see LICENSE file)