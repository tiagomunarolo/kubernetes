FROM python:3.8-alpine

WORKDIR src

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "gunicorn", "-w 4 app:app" ]