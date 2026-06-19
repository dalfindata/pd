#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${repo_root}"

echo "[pd] running fast Linux package checks"
go version
go test ./client/... ./pkg/...
