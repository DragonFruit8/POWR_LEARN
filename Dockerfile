FROM python:3.8-slim-buster
LABEL maintainer="powerdev.tech"

ENV PYTHONDONTWRITEBYTECODE 1

ENV PYTHONUNBUFFERED 1


COPY requirements.txt .
COPY ./requirements.dev.txt .
COPY . /app 
WORKDIR /app

EXPOSE 8000

# Create Virtual Environment
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r requirements.txt && \
    if [ "$DEV" = "true" ] ; \
        then /py/bin/pip install -r requirements.dev.txt ; \
    fi && \
    rm -rf /root/.cache/pip && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user 
# Add flake8 to path
RUN python -m pip install flake8

# Set Virtual Environment
ENV VIRTUAL_ENV=/py

# Local Path to Python Virtual Environment
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

USER django-user

CMD ["python", "manage.py", "runserver"]