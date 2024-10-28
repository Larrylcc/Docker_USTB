# 使用NVIDIA CUDA基础镜像
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# 避免交互式配置
ENV DEBIAN_FRONTEND=noninteractive

# 设置时区和语言环境
ENV TZ=Asia/Shanghai
ENV LANG=C.UTF-8

# 设置工作目录
WORKDIR /workspace

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3.8-dev \
    python3-pip \
    python3.8-venv \
    wget \
    git \
    libsndfile1 \
    ffmpeg \
    # 添加OpenCV所需的系统依赖
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 确保使用 Python 3.8
RUN ln -sf /usr/bin/python3.8 /usr/bin/python3 && \
    ln -sf /usr/bin/python3.8 /usr/bin/python

# 升级 pip 并安装依赖
RUN python3.8 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# 安装 Python 依赖
RUN pip install --no-cache-dir \
    torch==2.2.1 \
    torchvision==0.17.1 \
    --extra-index-url https://download.pytorch.org/whl/cu118 \
    numpy==1.24.3 \
    scipy==1.10.1 \
    pillow==10.0.0 \
    scikit-learn==1.3.0 \
    joblib==1.3.1 \
    matplotlib==3.7.1 \
    librosa==0.10.1 \
    ipython==8.12.0 \
    # 添加OpenCV
    opencv-python-headless==4.8.1.78

# 设置工作目录
WORKDIR /workspace

# 设置默认命令
CMD ["bash"]