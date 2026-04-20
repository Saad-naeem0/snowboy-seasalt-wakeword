#!/usr/bin/env bash
cd /app
.venv/bin/python3 -m web --port ${PORT:-8000} "$@"