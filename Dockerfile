FROM python:3-slim
LABEL maintainer="https://github.com/lrk" 

ARG EXCALIBUR_WORKDIR="/excalibur"

ENV HOST=0.0.0.0
ENV PORT=5000
ENV EXCALIBUR_HOME=${EXCALIBUR_WORKDIR}
ENV EXCALIBUR_SECRET_KEY=

RUN apt update && \
    apt install --no-install-recommends --no-install-suggests -y \
    gettext-base \
    libgl1-mesa-glx \
    libglib2.0-0 \
    ghostscript \
    && apt-get remove --purge --auto-remove -y  && \
    rm -rf /var/lib/apt/lists/* 

RUN pip install --no-cache-dir -U pip setuptools && \
    pip install --no-cache-dir excalibur-py && \
    find $(pip show excalibur-py | grep -i location | cut -d' ' -f2) \( -type d -a -name test -o -name tests \) -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) -exec rm -rf '{}' \+


RUN mkdir /docker-entrypoint.d
COPY docker-entrypoint.sh /
COPY ./docker-entrypoints/*.sh ./docker-entrypoint.d/

RUN useradd -ms /bin/bash excalibur

WORKDIR ${EXCALIBUR_WORKDIR}

RUN mkdir -p "${EXCALIBUR_WORKDIR}/uploads" && \    
    ln -s "${EXCALIBUR_WORKDIR}/uploads" $(pip show excalibur-py | grep -i location | cut -d' ' -f2)/excalibur/www/static/uploads && \
    chown -R excalibur "${EXCALIBUR_WORKDIR}"

COPY excalibur.cfg.template /etc/excalibur/

USER excalibur

RUN [ -z "${EXCALIBUR_SECRET_KEY}" ] && export EXCALIBUR_SECRET_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
RUN excalibur initdb

EXPOSE ${PORT}

STOPSIGNAL SIGQUIT

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "excalibur","webserver" ]

