FROM python:3.10
ARG BACKEND_WORKDIR
WORKDIR /${BACKEND_WORKDIR}
ENV PYTHONUNBUFFERED=1
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["gunicorn", "kittygram_backend.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "5"]
