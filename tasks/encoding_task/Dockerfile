FROM prefecthq/prefect:0.14.10

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt --no-cache-dir 

WORKDIR /app/
COPY ./src /app/src

ENTRYPOINT [ "sh", "-c" ]
