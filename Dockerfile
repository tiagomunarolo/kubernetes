FROM python:3.8-alpine

WORKDIR /src

COPY /src   /src

ADD requirements.txt /src

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["gunicorn"  , "-w", "4", "-b", "0.0.0.0:5000", "app:app"]