# jenkins-infra

Reusable Jenkins server setup for local development on macOS.

This repo hosts the Jenkins server itself. Application repos stay separate and
keep only their own `Jenkinsfile`.

For the current hackathon setup, the primary application repo is the BSF-first
`hackathon-ci-demo` project. Its `Jenkinsfile` validates the BSF backend and is
intended to showcase Codex-assisted implementation plus Jenkins-based trust.

Detailed documentation lives here:

- `docs/local-jenkins-pipeline-guide.md`
- `docs/local-jenkins-pipeline-guide.html`

## What Lives Here

- Jenkins server bootstrap scripts
- Jenkins plugins list
- Jenkins Configuration as Code
- local runtime helpers
- optional container backup files

## What Stays In Each App Repo

- application source code
- tests
- `Jenkinsfile`
- repo-specific Codex skill assets when used by the project

## Primary Path: Run Jenkins Directly On This Laptop

This is the main path for the BSF demo. Jenkins runs directly on macOS without
requiring the optional container backup path.

### 1. Start Jenkins locally

```bash
cd /Users/anil/Documents/anil/jenkins-infra
chmod +x scripts/*.sh
./scripts/start-jenkins-local.sh
```

Open Jenkins at:

```text
http://localhost:8080/
```

### 2. Complete first-time Jenkins setup

On first launch, Jenkins shows the setup wizard. Use it to:

1. Unlock Jenkins with the initial admin password from:

```bash
cat /Users/anil/Documents/anil/jenkins-infra/var/jenkins_home/secrets/initialAdminPassword
```

2. Install the suggested plugins
3. Create your admin user

### 3. Create the BSF pipeline job

For `hackathon-ci-demo`, create a Jenkins `Pipeline` job with:

- Definition: `Pipeline script from SCM`
- Repository URL: `https://github.com/anilneeluru09/hackathon-ci-demo.git`
- Branch: `*/main`
- Script path: `Jenkinsfile`

### 4. What the BSF pipeline does

The app repo pipeline:

1. checks out the repo
2. runs `./ci/run_bsf_backend_tests.sh`
3. bootstraps Java 21, Maven, and MongoDB inside the repo workspace
4. runs the BSF backend Maven test suite
5. publishes JUnit results from `reports/junit/*.xml`

### 5. Automatic commit detection

The pipeline uses `pollSCM('H/2 * * * *')`, so Jenkins can detect new commits
roughly every two minutes even without a public webhook URL.

Test flow:

1. Run `Build Now` once
2. Push a new commit to GitHub
3. Wait up to about 2 minutes
4. Confirm Jenkins starts the next build automatically

## Why This Matters For The Demo

This setup helps demonstrate that Codex was used for more than one-off coding:

- the application repo contains a repo-specific Codex skill
- the BSF implementation and CI flow are kept in sync
- Jenkins validates future commits automatically

That makes the demo about development workflow, integration, and trust.
