# syntax = docker/dockerfile:1.2
FROM nginx:1.31.2

RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && apt-get install -y \
  python3 python3-pip python3-venv cython3 libffi-dev rustc libssl-dev git \
  && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/certbot \
  && /opt/certbot/bin/python3 -m pip install --upgrade pip setuptools wheel \
  && /opt/certbot/bin/pip install --no-cache-dir certbot git+https://github.com/dodekanisou/certbot-azure.git

ENV PATH="/opt/certbot/bin:$PATH"
ENV VIRTUAL_ENV="/opt/certbot"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
