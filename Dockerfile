FROM nvidia/cuda:9.0-devel-ubuntu16.04

ENV PYTHONUNBUFFERED=1

# require by pipenv
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        apt-file \
    ; \
    apt-file update; \
    apt-get install -y --no-install-recommends \
        software-properties-common

RUN set -ex; \
    add-apt-repository ppa:jonathonf/python-3.6; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3.6 \
        python3-pip \
    ; \
    python3 -V; \
    pip3 -V

RUN set -ex; \
    pip3 --no-cache-dir install \
        pipenv

WORKDIR /usr/src/app
USER root

# install dependencies
COPY Pipfile Pipfile.lock ./
RUN set -x; \
    pipenv install --system --verbose

COPY . ./

CMD ["python3", "src/app.py"]

