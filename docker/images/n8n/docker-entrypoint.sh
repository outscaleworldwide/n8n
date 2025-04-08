COPY docker-entrypoint.sh /docker-entrypoint.sh

# ✅ Make sure the entrypoint script is executable!
RUN chmod +x /docker-entrypoint.sh

RUN \
  mkdir /home/node/.n8n && \
  chown node:node /home/node/.n8n

ENV SHELL /bin/sh
USER node

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

