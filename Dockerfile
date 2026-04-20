FROM debian:bullseye-slim as build

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        python3 python3-pip python3-venv python3-setuptools python3-dev \
        build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app && \
    cd /app && \
    python3 -m venv .venv && \
    .venv/bin/pip3 install --upgrade pip && \
    .venv/bin/pip3 install --upgrade setuptools wheel

COPY requirements.txt /app/
RUN /app/.venv/bin/pip3 install -r /app/requirements.txt

# -----------------------------------------------------------------------------

FROM debian:bullseye-slim as run

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        python2 python3 ffmpeg libpython2.7 \
        python3-pip curl && \
    curl -sS https://bootstrap.pypa.io/pip/2.7/get-pip.py | python2 && \
    python2 -m pip install scipy && \
    rm -rf /var/lib/apt/lists/*

COPY seasalt/ /app/seasalt/
COPY --from=build /app/.venv/ /app/.venv/
COPY web/ /app/web/

COPY run.sh /

WORKDIR /app

EXPOSE 8000

ENTRYPOINT ["/bin/bash", "/run.sh"]