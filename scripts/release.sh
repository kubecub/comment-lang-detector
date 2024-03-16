#!/usr/bin/env bash
# Copyright © 2023 KubeCub open source community. All rights reserved.
# Licensed under the MIT License (the "License");
# you may not use this file except in compliance with the License.


set -o errexit
set -o nounset
set -o pipefail

KUBECUB_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
source "${KUBECUB_ROOT}/scripts/common.sh"
source "${KUBECUB_ROOT}/scripts/lib/release.sh"

KUBECUB_RELEASE_RUN_TESTS=${KUBECUB_RELEASE_RUN_TESTS-y}

kubecub::golang::setup_env
kubecub::build::verify_prereqs
kubecub::release::verify_prereqs
#kubecub::build::build_image
kubecub::build::build_command
kubecub::release::package_tarballs
kubecub::release::updload_tarballs
git push origin ${VERSION}
#kubecub::release::github_release
#kubecub::release::generate_changelog
