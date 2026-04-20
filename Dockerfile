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