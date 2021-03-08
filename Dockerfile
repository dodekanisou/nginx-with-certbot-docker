# syntax = docker/dockerfile:1.2
FROM nginx:1.19

RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && apt-get install -y \
  python3 python3-pip cython3 libffi-dev rustc libssl-dev \
  && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install --upgrade certbot-azure cryptography

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
