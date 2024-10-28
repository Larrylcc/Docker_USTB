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
    libgl1-mesa-glx \
    libglib2.0-0 \
    openssh-server \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 创建必要的SSH目录和配置
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 配置环境变量，避免依赖特定的OneAPI路径
RUN echo '#!/bin/bash' > /etc/profile.d/custom_env.sh && \
    echo 'export PATH=$PATH:/usr/local/cuda/bin' >> /etc/profile.d/custom_env.sh && \
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64' >> /etc/profile.d/custom_env.sh && \
    chmod +x /etc/profile.d/custom_env.sh

# 修改.bashrc，移除对OneAPI的依赖
RUN echo '# Custom environment settings' > /root/.bashrc && \
    echo 'source /etc/profile.d/custom_env.sh' >> /root/.bashrc

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
    opencv-python-headless==4.8.1.78

# 设置工作目录
WORKDIR /workspace

# 暴露SSH端口
EXPOSE 22

# 启动SSH服务
CMD ["/usr/sbin/sshd", "-D"]