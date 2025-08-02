FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x manage.py

ENV DJANGO_SETTINGS_MODULE=quotes_project.settings

EXPOSE 8000

CMD ["daphne", "-b", "0.0.0.0", "-p", "8000", "quotes_project.asgi:application"]