# 使用nvidia/cuda基础镜像，确保CPU架构兼容性
FROM nvidia/cuda:11.8.0-cudnn8-devel-centos7

# 设置环境变量
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1

# 设置工作目录
WORKDIR /workspace

# 替换默认的 CentOS 源为阿里云源
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak && \
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

# 安装基本工具
RUN yum install -y \
    wget \
    bzip2 \
    ca-certificates \
    curl \
    git \
    openssh-server \
    sudo \
    gcc \
    gcc-c++ \
    make \
    xz \
    && yum clean all

# 从官方源直接安装Python 3.8，确保lzma模块支持
RUN yum install -y \
    openssl-devel \
    bzip2-devel \
    libffi-devel \
    xz-devel \
    && cd /tmp \
    && wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz \
    && tar xzf Python-3.8.12.tgz \
    && cd Python-3.8.12 \
    && ./configure --enable-optimizations \
    && make altinstall \
    && cd / \
    && rm -rf /tmp/Python-3.8.12* \
    && ln -s /usr/local/bin/python3.8 /usr/local/bin/python3 \
    && ln -s /usr/local/bin/pip3.8 /usr/local/bin/pip3

# 升级pip并设置pip源
RUN python3.8 -m pip install --upgrade pip && \
    pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 安装Python包（更新到与PyTorch 2.4.0兼容的版本）
RUN pip3 install --no-cache-dir \
    torch==2.4.0 \
    torchaudio==2.4.0 \
    torchvision==0.19.0 \
    numpy==1.23.5 \
    scipy==1.10.1 \
    matplotlib==3.7.2 \
    joblib==1.2.0 \
    scikit-learn==1.2.2 \
    librosa==0.10.1 \
    opencv-python-headless==4.8.0.76 \
    numba==0.57.0 \
    pillow==10.0.1 \
    soundfile==0.12.1 \
    requests==2.31.0

# 配置SSH
RUN ssh-keygen -A && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# 暴露SSH端口
EXPOSE 22

# 启动SSH服务
CMD ["/usr/sbin/sshd", "-D"]
