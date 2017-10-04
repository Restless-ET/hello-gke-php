# hello-gke-php
Simple Hello World Symfony app with deployment setup using Kubernetes for Google Container Engine (GKE).

Before you start make sure that you have an active account on Google Cloud Platform with a previously created project in the Google Cloud console.


# Cloud SDK installation and setup

We'll need the Cloud SDK so now it's a good time to install it on your computer (if you haven't yet).

It’s quite easy to install following the [Google quickstarts](https://cloud.google.com/sdk/docs/quickstarts).
The following is a summary of the quickstart for Linux:

```
cd ~
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-173.0.0-linux-x86_64.tar.gz
tar -zxvf google-cloud-sdk-173.0.0-linux-x86_64.tar.gz
rm google-cloud-sdk-173.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
```

Now, authorize the SDK tools to access Google Cloud Platform:
```
gcloud init
```

And finally install kubectl, the client to manage kubernetes:
```
gcloud components install kubectl
```


# Install Terraform

In order to automate as much as possible of the infrastructure setup we’ll use Terraform.

So the first step is to download it from [here](https://www.terraform.io/downloads.html) and install it (if not already done). For linux:
```
curl -O https://releases.hashicorp.com/terraform/0.10.7/terraform_0.10.7_linux_amd64.zip
unzip terraform_0.10.7_linux_amd64.zip
```

Now move it to a folder which is in your PATH, e.g.:
```
mv terraform /usr/local/bin/
```

If you’ve never used Terraform before, now it's probably a good moment to read the [Getting Started](https://www.terraform.io/intro/getting-started/install.html) guide.


# Download GKE credentials

Follow these instructions to download the credentials file:

1. Log into the [Google Developers Console](https://console.cloud.google.com/) and select your project.
2. Go to "IAM & Admin”, then "Service accounts" and look for a "Compute Engine default service account".
3. On the right menu for that service account select "Create key", and select "JSON" as the key type.
4. Clicking "Create" will download your credentials.
5. Rename it to `account.json` and place it under the project `./setup/` folder.


# Create the cluster using Terraform

Go to the project setup folder (`./setup/`).

In order to initialize the necessary provider plugins run:
```
terraform init
```

Check what it’s going to create:
```
terraform plan -var gcp_project=[Your Google Cloud project ID]
```

Review the output and if it’s ok, launch it!.
```
terraform apply -var gcp_project=[Your Google Cloud project ID]
```

And you can check that the cluster has been created with:
```
gcloud container clusters list
```

To get the public IP of the LoadBalancer just run:
```
kubectl describe service | grep "LoadBalancer Ingress"
```

# Deployment

The easier (and quicker) to update our app is to set the new docker image for our `web` deployment.
For that just run (this uses an example that I've previously created to ease testing this):
```
kubectl set image deployment/web web=eu.gcr.io/brave-sunspot-181810/hello-gke-php:0.0.2 --namespace=default
```

Kubernetes will take care of replacing the old pods with the new ones (using the new image) one at a time, so there shouldn't be any downtime.


# Tear it down

Once you're done checking the setup you can destroy the Google Container cluster that was just created:
```
terraform destroy -var gcp_project=[Your Google Cloud project ID]
```


## DEVELOPMENT ENVIRONMENT - Installation/Setup ##

Assuming you already have Docker installed, to ease development we'll also be using Docker Compose.
So first, you'll need to [install Docker Compose](https://docs.docker.com/compose/install/). Then start the containers with:
```
docker-compose up -d
```

On a first run you'll need to manually install some project dependencies:
```
docker-compose exec web_app bash
composer install && composer symfony-scripts
```

That's it! Your app will be available at `http://localhost:8888`.
