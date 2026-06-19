# Dalfin Local Linux CI

This document describes how to test the Dalfin Linux CI commands for `pd`
locally on an Apple silicon Mac using `apple/container`.

## Goal

Use a local Ubuntu environment on macOS for Linux preflight checks before
pushing CI changes. This is for command validation and artifact checks, not for
perfect parity with GitHub-hosted Ubuntu runners.

## Host setup

Start the `container` service on macOS:

```bash
container system start
container system status
```

Create an Ubuntu container machine sized for build work:

```bash
container machine create ubuntu:24.04 --name dalfin-ubuntu --cpus 4 --memory 8G
```

Open a shell in the machine:

```bash
container machine run -n dalfin-ubuntu
```

By default, `container machine create` mounts the macOS home directory read-write.
That means the repo remains visible inside the machine under `/Users/<mac-user>/...`.

## Guest bootstrap

Inside the Ubuntu machine, install the minimum tools needed for the current `pd`
CI commands:

```bash
sudo apt-get update
sudo apt-get install -y build-essential curl git make
```

Install the Go version expected by the current Dalfin CI workflow:

```bash
curl -LO https://go.dev/dl/go1.25.10.linux-arm64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.25.10.linux-arm64.tar.gz
export PATH=/usr/local/go/bin:$PATH
go version
```

## Run the local Linux checks

Change into the shared repo path inside the machine and run the scripts:

```bash
cd /Users/<mac-user>/Claude/Projects/DalfinDB/_worktrees/pd-ci/dalfin-local-linux-support
./scripts/ci/dalfin-linux-build.sh
./scripts/ci/dalfin-linux-fast-check.sh
```

## Notes

- These scripts are intentionally small mirrors of the GitHub-hosted Linux jobs.
- If the CI workflow changes, update these scripts first and then update the
  workflow to call the same commands.
- If a future runner image needs extra packages, add them to the guest bootstrap
  section here before expanding the workflow.
