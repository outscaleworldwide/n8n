
ARG NODE_VERSION=20
FROM n8nio/base:${NODE_VERSION}

# Set a default N8N_VERSION
ARG N8N_VERSION=1.48.0
ENV N8N_VERSION=${N8N_VERSION}
ENV NODE_ENV=production
ENV N8N_RELEASE_TYPE=stable

LABEL org.opencontainers.image.title="n8n"
LABEL org.opencontainers.image.description="Workflow Automation Tool"
LABEL org.opencontainers.image.source="https://github.com/n8n-io/n8n"
LABEL org.opencontainers.image.url="https://n8n.io"
LABEL org.opencontainers.image.version=${N8N_VERSION}

# Install n8n
RUN set -eux; \
  npm install -g --omit=dev n8n@${N8N_VERSION} --ignore-scripts && \
  npm rebuild --prefix=/usr/local/lib/node_modules/n8n sqlite3 && \
  rm -rf /usr/local/lib/node_modules/n8n/node_modules/@n8n/chat && \
  rm -rf /usr/local/lib/node_modules/n8n/node_modules/@n8n/design-system && \
  rm -rf /usr/local/lib/node_modules/n8n/node_modules/n8n-editor-ui/node_modules && \
  find /usr/local/lib/node_modules/n8n -type f -name "*.ts" -o -name "*.js.map" -o -name "*.vue" | xargs rm -f && \
  rm -rf /root/.npm

# Setup the Task Runner Launcher
ARG TARGETPLATFORM
ARG LAUNCHER_VERSION=1.1.1
COPY n8n-task-runners.json /etc/n8n-task-runners.json

RUN \
  if [[ "$TARGETPLATFORM" = "linux/amd64" ]]; then export ARCH_NAME="amd64"; \
  elif [[ "$TARGETPLATFORM" = "linux/arm64" ]]; then export ARCH_NAME="arm64"; fi; \
  mkdir /launcher-temp && \
  cd /launcher-temp && \
  wget https://github.com/n8n-io/task-runner-launcher/releases/download/${LAUNCHER_VERSION}/task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz && \
  wget https://github.com/n8n-io/task-runner-launcher/releases/download/${LAUNCHER_VERSION}/task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz.sha256 && \
  echo "$(cat task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz.sha256) task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz" > checksum.sha256 && \
  sha256sum -c checksum.sha256 && \
  tar xvf task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz --directory=/usr/local/bin && \
  cd - && \
  rm -r /launcher-temp

# Copy and fix permissions for entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Setup
RUN mkdir /home/node/.n8n && chown node:node /home/node/.n8n
ENV SHELL /bin/sh
USER node

# Launch
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
