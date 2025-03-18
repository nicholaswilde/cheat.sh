FROM alpine:3.14 AS builder
# FROM python:alpine AS builder
# https://rodneyosodo.medium.com/minimizing-python-docker-images-cf99f4468d39
RUN apk add --update --no-cache \
  git \
  sed \
  libstdc++ \
  pkgconf \
  py3-icu \
  py3-six \
  py3-pygments \
  py3-yaml \
  py3-gevent \
  py3-colorama \
  py3-requests \
  py3-redis

## copying
WORKDIR /app
COPY . /app

## building missing python packages
RUN apk add --no-cache --virtual build-deps py3-pip g++ python3-dev libffi-dev \
  && pip3 install --no-cache-dir --upgrade pygments \
  && pip3 install --no-cache-dir -r requirements.txt \
  && pip3 install --no-cache-dir git+https://github.com/aboSamoor/pycld2.git \
  && apk del build-deps

RUN mkdir -p /root/.cheat.sh/log/

# FROM python:3.13.2-alpine3.21
# WORKDIR /app
# COPY --from=builder /app /app
# COPY --from=builder /root/.cheat.sh /root/.cheat.sh

# Install server dependencies
RUN apk add --update --no-cache \
  py3-jinja2 \
  py3-flask \
  bash \
  gawk

RUN chmod +x ./entrypoint.sh
VOLUME ["/root/.cheat.sh/"]
# ENTRYPOINT ["python3", "-u", "bin/srv.py"]
ENTRYPOINT ["./entrypoint.sh"]
CMD [""]
