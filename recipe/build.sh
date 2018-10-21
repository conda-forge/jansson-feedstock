#!/bin/bash

./configure --prefix=$PREFIX
make
make check || { cat "${SRC_DIR}/test/test-suite.log"; exit 1; }
make install
