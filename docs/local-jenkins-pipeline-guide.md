# Local Jenkins Pipeline Guide

## Purpose

This document explains how the local Jenkins server is used with the BSF-first
`hackathon-ci-demo` repository and what is required to keep the demo repeatable
on a macOS laptop.

## Current Architecture

The setup is split into two repositories:

- `hackathon-ci-demo`
  - BSF implementation under `BSF_NF/`
  - repo-local Codex skill assets
  - root `Jenkinsfile`
- `jenkins-infra`
  - Jenkins server bootstrap scripts
  - local runtime notes
  - optional container backup files

This separation lets one Jenkins server manage multiple application
repositories while keeping each app repo responsible for its own pipeline.

## What We Built

We built a local Jenkins server that runs directly on the laptop.

It is started from `jenkins-infra` using:

```bash
./scripts/start-jenkins-local.sh
```

That script:

1. downloads a local Java runtime into `.tools/`
2. downloads the Jenkins LTS WAR file into `.downloads/`
3. starts Jenkins using a repo-local `JENKINS_HOME` under `var/jenkins_home/`

## How The BSF Repo Is Integrated

The BSF repo keeps its pipeline in the root `Jenkinsfile`.

For `hackathon-ci-demo`, the Jenkins job is created as:

1. Jenkins job type: `Pipeline`
2. Definition: `Pipeline script from SCM`
3. SCM: `Git`
4. Repository URL:

```text
https://github.com/anilneeluru09/hackathon-ci-demo.git
```

5. Branch:

```text
*/main
```

6. Script path:

```text
Jenkinsfile
```

## What The BSF Pipeline Does

The current `Jenkinsfile` in `hackathon-ci-demo` does the following:

1. prevents concurrent builds with `disableConcurrentBuilds()`
2. polls GitHub every 2 minutes with:

```groovy
pollSCM('H/2 * * * *')
```

3. checks out the repository
4. runs `./ci/run_bsf_backend_tests.sh`
5. bootstraps Java 21 and Maven inside `BSF_NF/.tools/`
6. starts repo-local MongoDB if needed
7. runs Maven tests from `BSF_NF/backend/pom.xml`
8. publishes JUnit results from `reports/junit/*.xml`

## Why This Fits The macOS Demo

The primary demo path runs Jenkins directly on the same macOS laptop used for
the BSF demo. That means the BSF project can keep its macOS-oriented runtime
scripts for local startup while Jenkins reuses a dedicated CI helper script for
test execution.

This split keeps the story clean:

- local demo flow: `BSF_NF/scripts/start-all.sh`
- CI validation flow: `./ci/run_bsf_backend_tests.sh`

## End-To-End Setup Steps

### 1. Clone the infra repo

```bash
git clone https://github.com/anilneeluru09/jenkins-infra.git
cd jenkins-infra
```

### 2. Start Jenkins locally

```bash
chmod +x scripts/*.sh
./scripts/start-jenkins-local.sh
```

### 3. Complete first-time Jenkins setup

Open:

```text
http://localhost:8080
```

Then:

1. unlock Jenkins using `var/jenkins_home/secrets/initialAdminPassword`
2. install suggested plugins
3. create the Jenkins admin user

### 4. Create the application pipeline job

In Jenkins:

1. click `New Item`
2. enter the job name
3. select `Pipeline`
4. choose `Pipeline script from SCM`
5. configure the Git repository URL
6. set the branch
7. set script path to `Jenkinsfile`
8. save

### 5. Run the first manual build

Click `Build Now` once to confirm:

- Jenkins can clone the repository
- Jenkins can run the BSF pipeline
- Java, Maven, and MongoDB bootstrap correctly
- the BSF backend tests pass

### 6. Validate automatic polling

1. push a new commit to the repository
2. wait up to about 2 minutes
3. confirm Jenkins starts a new build automatically

## What A New Repository Must Have

To onboard a new repository quickly, it should have:

1. a `Jenkinsfile` at the repo root, or at a known path
2. a Git URL Jenkins can clone
3. a target branch to build, such as `main`
4. a repeatable build command inside the pipeline
5. any required credentials if the repository is private

For the BSF repo, the repeatable build command is:

```bash
./ci/run_bsf_backend_tests.sh
```

## Why This Matters For The Hackathon Story

This setup lets the demo highlight that:

- Codex was guided by a repo-specific skill
- Codex changes fit the actual repo workflow
- Jenkins validates future commits automatically

That makes the demo about engineering workflow and CI trust, not just code
generation.
