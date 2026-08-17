FROM python:3.12-slim

ARG AQUACLEAN_REPO=https://github.com/jens62/geberit-aquaclean.git
ARG AQUACLEAN_VERSION=v3.1.2

RUN apt-get update \
    && apt-get install --no-install-recommends -y git curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone \
      --depth 1 \
      --branch "${AQUACLEAN_VERSION}" \
      "${AQUACLEAN_REPO}" \
      /app \
    && pip install --no-cache-dir .

ENV PYTHONPATH=/app \
    PYTHONUNBUFFERED=1

EXPOSE 8080

CMD ["python", "-m", "aquaclean_console_app", "--mode", "api"]
