# Dockerfile
FROM python:3.11-slim

# Oracle Instant Client ve build tools için gerekli paketler
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libaio1 \
    gcc \
    g++ \
    python3-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Oracle Instant Client kurulumu
WORKDIR /opt/oracle
RUN wget https://download.oracle.com/otn_software/linux/instantclient/214000/instantclient-basic-linux.x64-21.4.0.0.0dbru.zip \
    && unzip instantclient-basic-linux.x64-21.4.0.0.0dbru.zip \
    && rm instantclient-basic-linux.x64-21.4.0.0.0dbru.zip

# Oracle environment variables
ENV ORACLE_HOME=/opt/oracle/instantclient_21_4
ENV LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
ENV PATH=$ORACLE_HOME:$PATH

# Çalışma dizini
WORKDIR /app

# Python bağımlılıklarını kopyala ve kur
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Build tools'ları temizle (image boyutunu küçültmek için)
RUN apt-get remove -y gcc g++ python3-dev build-essential wget unzip \
    && apt-get autoremove -y \
    && apt-get clean

# Uygulama dosyalarını kopyala
COPY . .

# Port
EXPOSE 5000

# Uygulamayı başlat
CMD ["python", "app.py"]