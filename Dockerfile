# syntax = docker/dockerfile:1.2
FROM nginx:1.21.6

RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && apt-get install -y \
  python3 python3-pip cython3 libffi-dev rustc libssl-dev git \
  && rm -rf /var/lib/apt/lists/*

# pip will clone the repo in /tmp/
RUN --mount=type=cache,target=/root/.cache/pip \
  --mount=type=cache,id=nuget,target=/tmp/ \
  pip3 install --upgrade cryptography git+https://github.com/dodekanisou/certbot-azure.git

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
