FROM python:3.12-slim

ARG AQUACLEAN_REPO=https://github.com/jens62/geberit-aquaclean.git
ARG AQUACLEAN_VERSION=v3.1.2
ARG AQUACLEAN_COMMIT=

RUN apt-get update \
    && apt-get install --no-install-recommends -y git curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN if [ -n "${AQUACLEAN_COMMIT}" ]; then \
      git init /app \
      && git -C /app remote add origin "${AQUACLEAN_REPO}" \
      && git -C /app fetch --depth 1 origin "${AQUACLEAN_COMMIT}" \
      && git -C /app checkout --detach FETCH_HEAD; \
    else \
      git clone \
        --depth 1 \
        --branch "${AQUACLEAN_VERSION}" \
        "${AQUACLEAN_REPO}" \
        /app; \
    fi \
    && ACTUAL_COMMIT="$(git -C /app rev-parse HEAD)" \
    && echo "${ACTUAL_COMMIT}" > /app/.aquaclean-commit \
    && echo "AquaClean source commit: ${ACTUAL_COMMIT}" \
    && pip install --no-cache-dir .

ENV PYTHONPATH=/app \
    PYTHONUNBUFFERED=1 \
    AQUACLEAN_COMMIT=${AQUACLEAN_COMMIT}

EXPOSE 8080

CMD ["python", "-m", "aquaclean_console_app", "--mode", "api"]
