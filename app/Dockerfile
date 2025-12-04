FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt /app/
COPY djangoforcontainerization /app/

RUN  apt-get update && apt-get install

SHELL ["/bin/bash", "-c"]

RUN pip install --no-cache-dir -r requirements.txt


EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
