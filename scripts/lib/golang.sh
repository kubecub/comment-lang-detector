#!/usr/bin/env bash
# Copyright © 2023 KubeCub open source community. All rights reserved.
# Licensed under the MIT License (the "License");
# you may not use this file except in compliance with the License.


# shellcheck disable=SC2034 # Variables sourced in other scripts.

# The server platform we are building on.
readonly KUBECUB_SUPPORTED_SERVER_PLATFORMS=(
  linux/amd64
  linux/arm64
)

# If we update this we should also update the set of platforms whose standard
# library is precompiled for in build/build-image/cross/Dockerfile
readonly KUBECUB_SUPPORTED_CLIENT_PLATFORMS=(
  linux/amd64
  linux/arm64
)

# The set of server targets that we are only building for Linux
# If you update this list, please also update build/BUILD.
kubecub::golang::server_targets() {
  local targets=(
    kubecub-apiserver
    kubecub-authz-server
    kubecub-pump
    kubecub-watcher
  )
  echo "${targets[@]}"
}

IFS=" " read -ra KUBECUB_SERVER_TARGETS <<< "$(kubecub::golang::server_targets)"
readonly KUBECUB_SERVER_TARGETS
readonly KUBECUB_SERVER_BINARIES=("${KUBECUB_SERVER_TARGETS[@]##*/}")

# The set of server targets we build docker images for
kubecub::golang::server_image_targets() {
  # NOTE: this contains cmd targets for kubecub::build::get_docker_wrapped_binaries
  local targets=(
    cmd/kubecub-apiserver
    cmd/kubecub-authz-server
    cmd/kubecub-pump
    cmd/kubecub-watcher
  )
  echo "${targets[@]}"
}

IFS=" " read -ra KUBECUB_SERVER_IMAGE_TARGETS <<< "$(kubecub::golang::server_image_targets)"
readonly KUBECUB_SERVER_IMAGE_TARGETS
readonly KUBECUB_SERVER_IMAGE_BINARIES=("${KUBECUB_SERVER_IMAGE_TARGETS[@]##*/}")

# ------------
# NOTE: All functions that return lists should use newlines.
# bash functions can't return arrays, and spaces are tricky, so newline
# separators are the preferred pattern.
# To transform a string of newline-separated items to an array, use kubecub::util::read-array:
# kubecub::util::read-array FOO < <(kubecub::golang::dups a b c a)
#
# ALWAYS remember to quote your subshells. Not doing so will break in
# bash 4.3, and potentially cause other issues.
# ------------

# Returns a sorted newline-separated list containing only duplicated items.
kubecub::golang::dups() {
  # We use printf to insert newlines, which are required by sort.
  printf "%s\n" "$@" | sort | uniq -d
}

# Returns a sorted newline-separated list with duplicated items removed.
kubecub::golang::dedup() {
  # We use printf to insert newlines, which are required by sort.
  printf "%s\n" "$@" | sort -u
}

# Depends on values of user-facing KUBECUB_BUILD_PLATFORMS, KUBECUB_FASTBUILD,
# and KUBECUB_BUILDER_OS.
# Configures KUBECUB_SERVER_PLATFORMS and KUBECUB_CLIENT_PLATFORMS, then sets them
# to readonly.
# The configured vars will only contain platforms allowed by the
# KUBECUB_SUPPORTED* vars at the top of this file.
declare -a KUBECUB_SERVER_PLATFORMS
declare -a KUBECUB_CLIENT_PLATFORMS
kubecub::golang::setup_platforms() {
  if [[ -n "${KUBECUB_BUILD_PLATFORMS:-}" ]]; then
    # KUBECUB_BUILD_PLATFORMS needs to be read into an array before the next
    # step, or quoting treats it all as one element.
    local -a platforms
    IFS=" " read -ra platforms <<< "${KUBECUB_BUILD_PLATFORMS}"

    # Deduplicate to ensure the intersection trick with kubecub::golang::dups
    # is not defeated by duplicates in user input.
    kubecub::util::read-array platforms < <(kubecub::golang::dedup "${platforms[@]}")

    # Use kubecub::golang::dups to restrict the builds to the platforms in
    # KUBECUB_SUPPORTED_*_PLATFORMS. Items should only appear at most once in each
    # set, so if they appear twice after the merge they are in the intersection.
    kubecub::util::read-array KUBECUB_SERVER_PLATFORMS < <(kubecub::golang::dups \
        "${platforms[@]}" \
        "${KUBECUB_SUPPORTED_SERVER_PLATFORMS[@]}" \
      )
    readonly KUBECUB_SERVER_PLATFORMS

    kubecub::util::read-array KUBECUB_CLIENT_PLATFORMS < <(kubecub::golang::dups \
        "${platforms[@]}" \
        "${KUBECUB_SUPPORTED_CLIENT_PLATFORMS[@]}" \
      )
    readonly KUBECUB_CLIENT_PLATFORMS

  elif [[ "${KUBECUB_FASTBUILD:-}" == "true" ]]; then
    KUBECUB_SERVER_PLATFORMS=(linux/amd64)
    readonly KUBECUB_SERVER_PLATFORMS
    KUBECUB_CLIENT_PLATFORMS=(linux/amd64)
    readonly KUBECUB_CLIENT_PLATFORMS
  else
    KUBECUB_SERVER_PLATFORMS=("${KUBECUB_SUPPORTED_SERVER_PLATFORMS[@]}")
    readonly KUBECUB_SERVER_PLATFORMS

    KUBECUB_CLIENT_PLATFORMS=("${KUBECUB_SUPPORTED_CLIENT_PLATFORMS[@]}")
    readonly KUBECUB_CLIENT_PLATFORMS
  fi
}

kubecub::golang::setup_platforms

# The set of client targets that we are building for all platforms
# If you update this list, please also update build/BUILD.
readonly KUBECUB_CLIENT_TARGETS=(
  kubecubctl
)
readonly KUBECUB_CLIENT_BINARIES=("${KUBECUB_CLIENT_TARGETS[@]##*/}")

readonly KUBECUB_ALL_TARGETS=(
  "${KUBECUB_SERVER_TARGETS[@]}"
  "${KUBECUB_CLIENT_TARGETS[@]}"
)
readonly KUBECUB_ALL_BINARIES=("${KUBECUB_ALL_TARGETS[@]##*/}")

# Asks golang what it thinks the host platform is. The go tool chain does some
# slightly different things when the target platform matches the host platform.
kubecub::golang::host_platform() {
  echo "$(go env GOHOSTOS)/$(go env GOHOSTARCH)"
}

# Ensure the go tool exists and is a viable version.
kubecub::golang::verify_go_version() {
  if [[ -z "$(command -v go)" ]]; then
    kubecub::log::usage_from_stdin <<EOF
Can't find 'go' in PATH, please fix and retry.
See http://golang.org/doc/install for installation instructions.
EOF
    return 2
  fi

  local go_version
  IFS=" " read -ra go_version <<< "$(go version)"
  local minimum_go_version
  minimum_go_version=go1.13.4
  if [[ "${minimum_go_version}" != $(echo -e "${minimum_go_version}\n${go_version[2]}" | sort -s -t. -k 1,1 -k 2,2n -k 3,3n | head -n1) && "${go_version[2]}" != "devel" ]]; then
    kubecub::log::usage_from_stdin <<EOF
Detected go version: ${go_version[*]}.
kubecub requires ${minimum_go_version} or greater.
Please install ${minimum_go_version} or later.
EOF
    return 2
  fi
}

# kubecub::golang::setup_env will check that the `go` commands is available in
# ${PATH}. It will also check that the Go version is good enough for the
# kubecub build.
#
# Outputs:
#   env-var GOBIN is unset (we want binaries in a predictable place)
#   env-var GO15VENDOREXPERIMENT=1
#   env-var GO111MODULE=on
kubecub::golang::setup_env() {
  kubecub::golang::verify_go_version

  # Unset GOBIN in case it already exists in the current session.
  unset GOBIN

  # This seems to matter to some tools
  export GO15VENDOREXPERIMENT=1

  # Open go module feature
  export GO111MODULE=on

  # This is for sanity.  Without it, user umasks leak through into release
  # artifacts.
  umask 0022
}
