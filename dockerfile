FROM python:3.9.7-slim-bullseye

RUN apt-get update && apt-get install -y curl unzip gcc \
    && rm -rf /var/lib/apt/lists/* 

COPY install_cg3.sh /tmp/install_cg3.sh

RUN bash /tmp/install_cg3.sh \
    && apt-get update && apt-get install -y cg3 \
    && rm -rf /var/lib/apt/lists/* \
    && rm /tmp/install_cg3.sh

RUN pip install --no-cache-dir virtualenv

RUN mkdir -p /usr/nobody \
    && python -m virtualenv /usr/nobody/venv \
    && chmod -R 777 /usr/nobody

USER nobody

RUN curl -L https://github.com/UCREL/CyTag/archive/refs/heads/v1.0.zip -o /usr/nobody/cytag.zip \
    && unzip /usr/nobody/cytag.zip -d /usr/nobody/. \
    && rm /usr/nobody/cytag.zip

SHELL ["/bin/bash", "-c"]

COPY requirements.txt /usr/nobody/requirements.txt

RUN source /usr/nobody/venv/bin/activate \
    && pip install --no-cache-dir -r /usr/nobody/requirements.txt \
    && rm /usr/nobody/requirements.txt

WORKDIR /usr/nobody/CyTag-1.0

ENTRYPOINT ["/usr/nobody/venv/bin/python", "CyTag.py"]