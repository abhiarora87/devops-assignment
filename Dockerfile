FROM --platform=linux/amd64 python:3.7.11-slim

WORKDIR /project

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY app.py app.py

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
