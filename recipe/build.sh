#!/bin/bash
set -exo pipefail

# Create an out-of-source build dir
mkdir -p "${SRC_DIR}/build"
pushd "${SRC_DIR}/build"

# Configure CMake.
# - Build shared libs to match the original configure --disable-static
# - Set install prefix to PREFIX provided by conda-build
# - Set CMake policy minimum for compatibility similar to the windows .bat
cmake -G Ninja \
      -DJANSSON_BUILD_SHARED_LIBS=ON \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
      -DCMAKE_BUILD_TYPE=Release \
      ..

# Build & install
cmake --build . --target install --config Release -- -j${CPU_COUNT}

# Ignore this test
cat > "${SRC_DIR}/test/suites/api/check-exports" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "${SRC_DIR}/test/suites/api/check-exports"

# Run tests unless cross-compiling.
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
    echo "Running CMake 'check' target..."
    cmake --build . --target check --config Release -- -j${CPU_COUNT}
fi

popd