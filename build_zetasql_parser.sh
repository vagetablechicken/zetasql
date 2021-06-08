#!/bin/bash

# build zetasql parser into static library
# Copyright 2021 4Paradigm
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -eE

export BAZEL_LINKOPTS='-static-libstdc++:-lm'
export BAZEL_LINKLIBS='-l%:libstdc++.a'

TARGET='//zetasql/parser/...'
BUILD_ARGV='--features=-supports_dynamic_linker'

bazel build "$TARGET" "$BUILD_ARGV"
bazel test "$TARGET" "$BUILD_ARGV"

# explicitly build dependencies into static library
bazel query "deps($TARGET)" | grep //zetasql | xargs bazel build "$BUILD_ARGV"
bazel build "@com_googleapis_googleapis//:all" "$BUILD_ARGV"
bazel build "@com_google_file_based_test_driver//file_based_test_driver:all" "$BUILD_ARGV"
bazel build "@com_googlesource_code_re2//:re2" "$BUILD_ARGV"

unset BAZEL_LINKLIBS
unset BAZEL_LINKOPTS
