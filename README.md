# jenkins-infra

Reusable Jenkins server setup for local development with Podman on macOS.

This repo is meant to host the Jenkins server itself. Your application repos stay
separate and keep only their own `Jenkinsfile`.

## What Lives Here

- Jenkins server container build
- Jenkins plugins list
- Jenkins Configuration as Code
- Local runtime settings for Podman

## What Stays In Each App Repo

- application source code
- tests
- `Jenkinsfile`

That means one Jenkins server can run jobs for many repositories.

## Prerequisites

1. Install Podman on macOS
2. Start the Podman VM

Example commands after Podman is installed:

```bash
podman machine init
podman machine start
```

## First-Time Startup

```bash
cp .env.example .env
podman compose up -d --build
```

Open Jenkins at:

```text
http://localhost:8080/
```

Default login:
- Username: `admin`
- Password: value from `.env`

## Create Pipeline Jobs For App Repos

For each application repo:

1. Create a new Jenkins **Pipeline** job.
2. Choose **Pipeline script from SCM**.
3. Set the repo URL to the application repository.
4. Set branch to `*/main` or your target branch.
5. Set script path to `Jenkinsfile`.
6. Enable **Build when a change is pushed to GitHub**.

This Jenkins server can host multiple jobs, one per repository.

## GitHub Webhook Setup

GitHub must be able to reach your Jenkins URL.

Webhook payload URL:

```text
http://<your-public-jenkins-url>/github-webhook/
```

If Jenkins runs only on your laptop, expose it with a public tunnel and use that
public URL both in Jenkins and in the GitHub webhook.

## Useful Commands

Start server:

```bash
podman compose up -d --build
```

Stop server:

```bash
podman compose down
```

Reset Jenkins state:

```bash
podman compose down -v
```
