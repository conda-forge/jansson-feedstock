mkdir "%SRC_DIR%"\build
pushd "%SRC_DIR%"\build

cmake -G "Ninja" ^
      -DBUILD_SHARED_LIBS=ON ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      ..
if errorlevel 1 exit 1

cmake --build . --target install --config Release
if errorlevel 1 exit 1
