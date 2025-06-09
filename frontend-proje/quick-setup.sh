#!/bin/bash

echo "🏥 Hastane Yönetim Sistemi - Hızlı Kurulum"
echo "=========================================="

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Mevcut container'ları temizle
echo "🧹 Eski container'ları temizleniyor..."
docker-compose down -v 2>/dev/null || true
docker stop oracle-xe 2>/dev/null || true
docker rm oracle-xe 2>/dev/null || true

# Gerekli dizinleri oluştur
echo "📁 Dizin yapısı oluşturuluyor..."
mkdir -p init-scripts templates static/css static/js

# Docker-compose ile başlat
echo "🚀 Servisler başlatılıyor..."
docker-compose up -d oracle-db

echo "⏳ Oracle Database başlatılıyor... (2-3 dakika sürebilir)"
echo "📊 İlerlemeyi takip etmek için: docker logs -f oracle-xe"

# Oracle'ın hazır olmasını bekle
echo "🔄 Oracle'ın hazır olması bekleniyor..."
for i in {1..60}; do
    if docker exec oracle-xe sqlplus -S system/oracle123@localhost:1521/XE <<< "SELECT 1 FROM DUAL;" &>/dev/null; then
        echo "✅ Oracle Database hazır!"
        break
    fi
    echo -n "."
    sleep 5
done

# Hospital kullanıcısının oluşturulduğunu kontrol et
echo "👤 Hospital kullanıcısı kontrol ediliyor..."
sleep 10

if docker exec oracle-xe sqlplus -S hospital/hospital123@localhost:1521/XE <<< "SELECT COUNT(*) FROM user_tables;" &>/dev/null; then
    echo "✅ Hospital kullanıcısı ve tablolar hazır!"
else
    echo "❌ Hospital kullanıcısı oluşturulamadı. Manuel kurulum gerekebilir."
fi

echo ""
echo "🎉 Kurulum tamamlandı!"
echo "📋 Kullanılabilir komutlar:"
echo "   docker-compose logs oracle-db    # Oracle loglarını görüntüle"
echo "   docker-compose up hospital-app   # Web uygulamasını başlat"
echo "   docker-compose down              # Servisleri durdur"
echo ""
echo "🌐 Oracle Enterprise Manager: http://localhost:5500/em"
echo "   Kullanıcı: system"
echo "   Şifre: oracle123"
