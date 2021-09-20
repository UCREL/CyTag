FROM python:3.9.7-slim-bullseye

RUN apt-get update && apt-get install -y curl unzip gcc \
    && rm -rf /var/lib/apt/lists/* 

RUN addgroup --system cytag && adduser --system --home /usr/cytag --ingroup cytag cytag

COPY install_cg3.sh /tmp/install_cg3.sh

RUN bash /tmp/install_cg3.sh \
    && apt-get update && apt-get install -y cg3 \
    && rm -rf /var/lib/apt/lists/* \
    && rm /tmp/install_cg3.sh

RUN pip install --no-cache-dir virtualenv

RUN python -m virtualenv /usr/cytag/venv \
    && chown -R cytag:cytag /usr/cytag/venv

USER cytag

SHELL ["/bin/bash", "-c"]

COPY --chown=cytag:cytag requirements.txt /usr/cytag/requirements.txt

RUN source /usr/cytag/venv/bin/activate \
    && pip install --no-cache-dir -r /usr/cytag/requirements.txt \
    && rm /usr/cytag/requirements.txt

COPY --chown=cytag:cytag cytag.zip /usr/cytag/cytag.zip
RUN unzip /usr/cytag/cytag.zip -d /usr/cytag/. \
    && rm /usr/cytag/cytag.zip

WORKDIR /usr/cytag

ENTRYPOINT ["/usr/cytag/venv/bin/python", "CyTag.py"]