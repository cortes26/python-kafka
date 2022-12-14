FROM python:3.10-slim

# Set application directory
WORKDIR /opt/ihub-broker

# Copies current directory into the container at /ihub-broker
COPY . /opt/ihub-broker

# Libraries needed by app & not in lightweight linux by default
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get -y install curl gnupg gcc g++ mono-mcs unixodbc-dev libpq-dev

# Adds microsoft repository as certeficate repository server to download images
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list

# ODBC driver. Supports SQL Server
# https://docs.microsoft.com/es-es/sql/connect/odbc/windows/system-requirements-installation-and-driver-files?view=sql-server-ver15
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17

RUN pip install -r requirements.txt

CMD ["python", "app/main.py"]
