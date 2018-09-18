FROM nvidia/cuda:9.0-base-ubuntu16.04

ENV PYTHONUNBUFFERED=1

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        apt-file \
    ; \
    apt-file update; \
    apt-get install software-properties-common

RUN set -ex; \
    add-apt-repository ppa:jonathonf/python-3.6; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3.6

RUN set -ex; \
    pip --no-cache-dir install \
        pipenv

WORKDIR /usr/src/app

# install dependencies
COPY Pipfile Pipfile.lock ./
# RUN set -x; \
#     pipenv install --system --verbose

COPY . ./

CMD ["python", "src/app.py"]

