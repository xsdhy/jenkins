FROM jenkins/jenkins:lts-jdk11

USER root

# 清理可能存在的 broken docker 源配置，然后安装 docker CLI
# 使用 Debian 官方源的 docker.io 以避免 GPG key 问题
RUN find /etc/apt/ -name "*.list" -type f -exec sed -i '/download.docker.com/d' {} + && \
    apt-get update && \
    apt-get install -y docker.io && \
    rm -rf /var/lib/apt/lists/*

# 确保 docker 组存在并将 jenkins 用户加入
# 注意：在 Linux 上运行时，可能需要确保容器内 docker 组 GID 与宿主机一致
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins
