FROM jenkins/jenkins:lts-jdk11

USER root

# 安装必要的依赖并设置 Docker 官方源
# 先清理可能存在的 broken docker.list，防止 apt-get update 失败
RUN rm -f /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y lsb-release curl gnupg && \
    curl -fsSLo /usr/share/keyrings/docker-archive-keyring.gpg https://download.docker.com/linux/debian/gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# 确保 docker 组存在并将 jenkins 用户加入
# 注意：在 Linux 上运行时，可能需要确保容器内 docker 组 GID 与宿主机一致
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins
