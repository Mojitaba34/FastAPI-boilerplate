FROM python:3.12-slim AS base

FROM base AS compile-image

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_DEFAULT_TIMEOUT=100
ENV PIP_NO_CACHE_DIR=1

RUN apt-get update && \
    apt-get install -yqq --no-install-recommends \
    build-essential libpq-dev python3-dev software-properties-common && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip wheel

COPY requirements.txt .
RUN pip install -r ./requirements.txt && \
    find /opt/venv -type f -name "*.pyc" -delete 2>/dev/null && \
    find /opt/venv -type f -name "*.pyo" -delete 2>/dev/null && \
    find /opt/venv -type d -name "test" -name "tests" -delete 2>/dev/null


FROM base AS dev

COPY --from=compile-image /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /app

COPY app app/

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]