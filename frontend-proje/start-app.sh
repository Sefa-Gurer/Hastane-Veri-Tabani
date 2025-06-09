#!/bin/bash

echo "🚀 Web uygulaması başlatılıyor..."

# Oracle'ın çalıştığını kontrol et
if ! docker ps | grep -q oracle-xe; then
    echo "📦 Oracle container başlatılıyor..."
    docker-compose up -d oracle-db
    
    echo "⏳ Oracle hazır olana kadar bekleniyor..."
    sleep 30
fi

# Bağlantıyı test et
echo "🔗 Veritabanı bağlantısı test ediliyor..."
if docker exec oracle-xe sqlplus -S hospital/hospital123@localhost:1521/XE <<< "SELECT 1 FROM DUAL;" &>/dev/null; then
    echo "✅ Bağlantı başarılı!"
else
    echo "❌ Bağlantı hatası! Oracle container'ı kontrol edin."
    exit 1
fi

# Web uygulamasını başlat
echo "🌐 Flask uygulaması başlatılıyor..."

# Eğer Dockerfile varsa container olarak çalıştır
if [ -f "Dockerfile" ]; then
    docker-compose up --build hospital-app
else
    # Lokal olarak çalıştır
    if [ ! -d "hospital_env" ]; then
        echo "📦 Python sanal ortamı oluşturuluyor..."
        python -m venv hospital_env
    fi
    
    source hospital_env/bin/activate
    pip install -r requirements.txt
    
    export ORACLE_HOST=localhost
    export ORACLE_PORT=1521
    export ORACLE_SERVICE=XE
    export ORACLE_USER=hospital
    export ORACLE_PASSWORD=hospital123
    
    python app.py
fi
