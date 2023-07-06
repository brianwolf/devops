FROM python:3.10-slim

USER root

WORKDIR /home

# install linux dependencies
RUN apt update
RUN apt install wget curl -y

# install dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt --upgrade pip
RUN rm -fr requirements.txt

# make a user
RUN chmod -R 777 /home
RUN useradd -ms /bin/bash 1001
USER 1001

# exec app
COPY app.py app.py

ENV PYTHON_HOST=0.0.0.0
ENV PYTHON_PORT=5000
ENV TZ=America/Argentina/Buenos_Aires

EXPOSE 5000

CMD python3 -m gunicorn -b ${PYTHON_HOST}:${PYTHON_PORT} --workers=1 --threads=4 app:app

