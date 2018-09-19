FROM python:3.6-stretch

ENV PYTHONUNBUFFERED=1

# require by pipenv
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV NVIDIA_PUB_KEY "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub"
ENV NVIDIA_REPO "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /"

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        build-essential \
        wget \
    ; \
    wget -qO - ${NVIDIA_PUB_KEY} | apt-key add -; \
    echo ${NVIDIA_REPO} > /etc/apt/sources.list.d/cuda.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends nvidia-390-dev; \
    rm -rf /var/lib/apt/lists/*; \
    bundle install --deployment --without test; \
    python -V; \
    pip -V

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

