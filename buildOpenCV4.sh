#!/bin/bash

#based on https://devtalk.nvidia.com/default/topic/1042035/installing-opencv4-on-xavier/

WHEREAMI=$(pwd)
ARCH_BIN=7.0
source scripts/jetson_variables.sh
sudo apt-get install -y build-essential \
    cmake \
    unzip \
    pkg-config \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libgtk-3-dev \
    libatlas-base-dev \
    gfortran \
    python3-dev \
    python3-venv \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libdc1394-22-dev \
    libavresample-dev

echo "Clone OpenCV"
git clone https://github.com/opencv/opencv.git
echo "Clone OpenCV Contrib"
git clone https://github.com/opencv/opencv_contrib.git

echo "Create new virtual env"
python3 -m venv opencv4
source opencv4/bin/activate
echo "Install wheel and numpy into the virtual env"
pip install wheel
pip install numpy
cd opencv && mkdir -p build && cd build
echo "Starting cmake"
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=$WHEREAMI'/opencv_contrib/modules' \
    -D PYTHON_EXECUTABLE=$WHEREAMI'/opencv4/bin/python' \
    -D BUILD_EXAMPLES=ON \
    -D WITH_CUDA=ON \
    -D CUDA_ARCH_BIN=${ARCH_BIN} \
    -D CUDA_ARCH_PTX="" \
    -D ENABLE_FAST_MATH=ON \
    -D CUDA_FAST_MATH=ON \
    -D WITH_CUBLAS=ON \
    -D WITH_LIBV4L=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_GSTREAMER_0_10=OFF \
    -D WITH_TBB=ON \
    ../
echo "Start build process with 6 cores"
make -j6
sudo make install
sudo ldconfig
cd $WHEREAMI'/opencv4/lib/python3.6/site-packages'
ln -s /usr/local/lib/python3.6/site-packages/cv2.cpython-36m-aarch64-linux-gnu.so cv2.so