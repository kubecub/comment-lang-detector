#!/usr/bin/env bash
# Copyright © 2023 KubeCub open source community. All rights reserved.
# Licensed under the MIT License (the "License");
# you may not use this file except in compliance with the License.


version="${VERSION}"
if [ "${version}" == "" ];then
  version=v`gsemver bump`
fi

if [ -z "`git tag -l ${version}`" ];then
  git tag -a -m "release version ${version}" ${version}
fi
