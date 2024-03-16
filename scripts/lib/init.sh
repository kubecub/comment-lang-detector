#!/usr/bin/env bash
# Copyright © 2023 KubeCub open source community. All rights reserved.
# Licensed under the MIT License (the "License");
# you may not use this file except in compliance with the License.


set -o errexit
set +o nounset
set -o pipefail

# Unset CDPATH so that path interpolation can work correctly
# https://github.com/kubecubrnetes/kubecubrnetes/issues/52255
unset CDPATH

# Default use go modules
export GO111MODULE=on

# The root of the build/dist directory
KUBECUB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"

source "${KUBECUB_ROOT}/scripts/lib/util.sh"
source "${KUBECUB_ROOT}/scripts/lib/logging.sh"
source "${KUBECUB_ROOT}/scripts/lib/color.sh"

kubecub::log::install_errexit

source "${KUBECUB_ROOT}/scripts/lib/version.sh"
source "${KUBECUB_ROOT}/scripts/lib/golang.sh"
