FROM python:3.7-slim as builder

COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt --no-cache-dir 

WORKDIR /app/
COPY ./src /app/src

RUN useradd -md /usr/local/airflow airflowc
USER airflow

ENTRYPOINT [ "sh", "-c" ]
