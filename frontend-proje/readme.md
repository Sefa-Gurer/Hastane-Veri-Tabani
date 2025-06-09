# 🏥 Hastane Yönetim Sistemi

Oracle Database ve Flask kullanılarak geliştirilmiş kapsamlı bir hastane yönetim sistemi.

## 📋 İçindekiler

1. [Proje Hakkında](#-proje-hakkında)
2. [Özellikler](#-özellikler)
3. [Teknoloji Stack](#-teknoloji-stack)
4. [Kurulum](#-kurulum)
5. [Kullanım](#-kullanım)
6. [Veritabanı Şeması](#️-veritabanı-şeması)
7. [API Dokümantasyonu](#-api-dokümantasyonu)
8. [Klasör Yapısı](#-klasör-yapısı)
9. [Ekran Görüntüleri](#-ekran-görüntüleri)
10. [Sorun Giderme](#-sorun-giderme)

## 🎯 Proje Hakkında

Bu proje, modern web teknolojileri kullanılarak geliştirilmiş bir hastane yönetim sistemidir. Sistem, hasta kayıtları, personel yönetimi, tahlil sonuçları ve muayene takibi gibi temel hastane işlemlerini kapsar.

### Proje Amaçları
- Oracle Database ile karmaşık veri ilişkilerini yönetmek
- PL/SQL ile stored procedure, function ve trigger kullanımını göstermek
- Flask web framework ile modern web uygulaması geliştirmek
- Docker containerization teknolojisini uygulamak

## ✨ Özellikler

### 👥 Hasta Yönetimi
- Hasta kayıt sistemi
- Demografik bilgi yönetimi
- Tahlil geçmişi takibi
- Muayene kayıtları

### 👨‍⚕️ Personel Yönetimi
- Doktor, hemşire ve teknisyen kayıtları
- Poliklinik bazında personel organizasyonu
- Unvan ve yetki yönetimi

### 🧪 Tahlil Sistemi
- Laboratuvar sonuçları
- Normal değer aralık kontrolü
- Tarihsel tahlil takibi

### 📊 Raporlama
- İstatistiksel raporlar
- Kan grubu dağılımları
- Aylık muayene trendleri

### 🏥 Tedavi Takibi
- Yatan hasta yönetimi
- Ayakta tedavi kayıtları
- Teşhis kodları (ICD-10)

## 🛠 Teknoloji Stack

- **Backend**: Python Flask 2.0+
- **Database**: Oracle Database XE 21c
- **Frontend**: HTML5, CSS3, Bootstrap 5
- **Containerization**: Docker & Docker Compose
- **Database Driver**: cx_Oracle
- **Template Engine**: Jinja2

## 🚀 Kurulum

### Ön Gereksinimler
- Docker 20.10+
- Docker Compose 1.29+
- Git

### Hızlı Kurulum

1. **Proje İndirme**
```bash
git clone <repository-url>
cd hastane-yonetim-sistemi
```

2. **Otomatik Kurulum**
```bash
# Hızlı kurulum scripti
make quick-install
```

3. **Servisleri Başlatma**
```bash
make start
```

4. **Uygulamaya Erişim**
- Web Arayüz: http://localhost:5000
- Oracle Database: localhost:1521

### Manuel Kurulum

1. **Docker Compose ile Başlatma**
```bash
docker-compose up -d
```

2. **Veritabanı Şeması Yükleme**
```bash
# Oracle container'ının hazır olmasını bekleyin (yaklaşık 2-3 dakika)
docker exec -it oracle-xe sqlplus sys/oracle123@localhost:1521/XE as sysdba

# Hastane kullanıcısı oluştur
CREATE USER hospital IDENTIFIED BY hospital123;
GRANT CONNECT, RESOURCE, DBA TO hospital;
exit

# Şemayı yükle
docker exec -i oracle-xe sqlplus hospital/hospital123@localhost:1521/XE < paste.txt
```

### Kullanışlı Komutlar
```bash
make start          # Uygulamayı başlat
make stop           # Servisleri durdur
make logs           # Logları göster
make test           # Bağlantıyı test et
make db-shell       # Oracle SQL shell
make clean          # Temizle
```

## 💻 Kullanım

### Ana Sayfa (Dashboard)
- **URL**: http://localhost:5000
- Genel sistem istatistikleri
- Poliklinik personel dağılımı
- Son tahlil sonuçları

### Hasta Yönetimi
- **Hasta Listesi**: `/patients` - Tüm hastaları görüntüle
- **Hasta Detayı**: `/patient/<tc>` - Detaylı hasta bilgileri
- **Yeni Hasta**: `/add_patient` - Hasta ekleme formu

### Personel Yönetimi
- **Personel Listesi**: `/staff` - Tüm personeli görüntüle
- **Yeni Personel**: `/add_staff` - Personel ekleme formu

### Tahlil Sistemi
- **Tahlil Sonuçları**: `/tests` - Tüm tahlil sonuçları
- Normal aralık kontrolü ile renk kodlu gösterim

### Raporlar
- **Raporlar**: `/reports` - İstatistiksel raporlar ve analizler

## 🗄️ Veritabanı Şeması

### Ana Tablolar

#### Hastalar
```sql
CREATE TABLE Hastalar (
    Hasta_tc NUMBER(11) PRIMARY KEY,
    Hasta_Ad VARCHAR2(50) NOT NULL,
    Hasta_Soyad VARCHAR2(50) NOT NULL,
    Hasta_Email VARCHAR2(225),
    Hasta_Tel NUMBER(10) NOT NULL,
    Hasta_Dogum_Tarihi DATE,
    Kan_Grubu VARCHAR2(5) NOT NULL
);
```

#### Personeller
```sql
CREATE TABLE Personeller (
    PersonelID NUMBER PRIMARY KEY,
    Personel_tc NUMBER(11) UNIQUE NOT NULL,
    Personel_Ad VARCHAR2(50) NOT NULL,
    Personel_Soyad VARCHAR2(50) NOT NULL,
    Personel_Email VARCHAR2(225),
    Personel_Tel NUMBER(10) NOT NULL,
    Unvan NUMBER NOT NULL,
    Poliklinik NUMBER NOT NULL
);
```

#### Tahliller
```sql
CREATE TABLE Tahliller (
    tc NUMBER(11) NOT NULL,
    Sonuc_Tipi VARCHAR2(50) NOT NULL,
    Sonuc NUMBER,
    Tarih DATE NOT NULL,
    FOREIGN KEY (tc) REFERENCES Hastalar(Hasta_tc)
);
```

### Fonksiyonlar

#### FN_Personel_Sayisi_Poliklinik
Belirtilen poliklinikteki personel sayısını döner.
```sql
SELECT FN_Personel_Sayisi_Poliklinik(1) FROM DUAL;
```

#### FN_Tahlil_Sayisi
Hastanın toplam tahlil sayısını döner.
```sql
SELECT FN_Tahlil_Sayisi(10000000001) FROM DUAL;
```

### Stored Procedure'lar

#### Hasta_Ekle
Yeni hasta eklemek için kullanılan procedure.
```sql
BEGIN
    Hasta_Ekle(
        p_tc => 12345678901,
        p_ad => 'Ahmet',
        p_soyad => 'Yılmaz',
        p_email => 'ahmet@example.com',
        p_tel => 5551234567,
        p_dogum => TO_DATE('1990-01-01', 'YYYY-MM-DD'),
        p_kan_grubu => 'A+'
    );
END;
/
```

#### Personel_Ekle
Yeni personel eklemek için kullanılan procedure.
```sql
BEGIN
    Personel_Ekle(
        p_tc => 98765432109,
        p_ad => 'Dr. Ayşe',
        p_soyad => 'Kaya',
        p_email => 'ayse.kaya@hospital.com',
        p_tel => 5559876543,
        p_unvan_id => 4,
        p_poliklinik => 1
    );
END;
/
```

### Trigger'lar

- **TRG_PersonelID**: Personel ID otomatik oluşturma
- **TRG_HastaEmailKontrol**: Email format kontrolü
- **TRG_Tedavi_Suresi**: Tedavi süresini otomatik hesaplama
- **TRG_GirisLog**: Sisteme giriş zamanını kaydetme

### View'lar

#### vw_Personel_Gorunumu
Personel bilgilerini unvan ve poliklinikle birlikte gösterir.

#### vw_Hasta_Tahlil_Ozeti
Hasta tahlil sonuçlarının özet görünümü.

## 🔌 API Dokümantasyonu

### Poliklinik Personel Sayısı
```http
GET /api/clinic_staff/<clinic_id>
```

**Örnek İstek:**
```bash
curl http://localhost:5000/api/clinic_staff/1
```

**Örnek Yanıt:**
```json
{
    "clinic_id": 1,
    "staff_count": 3
}
```

## 📁 Klasör Yapısı

```
hastane-yonetim-sistemi/
├── app.py                 # Ana Flask uygulaması
├── requirements.txt       # Python bağımlılıkları
├── docker-compose.yml     # Docker servis tanımları
├── Dockerfile             # Flask container tanımı
├── Makefile              # Otomatik komutlar
├── quick-setup.sh        # Hızlı kurulum scripti
├── start-app.sh          # Uygulama başlatma scripti
├── paste.txt             # Veritabanı şeması (SQL)
├── paste-2.txt           # Flask uygulaması kodu
├── templates/            # HTML şablonları
│   ├── base.html
│   ├── index.html
│   ├── patients.html
│   ├── patient_detail.html
│   ├── staff.html
│   ├── add_patient.html
│   ├── add_staff.html
│   ├── tests.html
│   ├── reports.html
│   └── error.html
├── static/               # CSS, JS dosyaları
│   ├── css/
│   ├── js/
│   └── images/
└── .env                  # Environment değişkenleri
```

## 📸 Ekran Görüntüleri

### Ana Sayfa Dashboard
- Genel istatistikler kartları
- Poliklinik personel dağılım grafiği
- Son tahlil sonuçları tablosu

### Hasta Listesi
- Tüm hastaların tablo görünümü
- TC, ad, soyad, telefon, kan grubu bilgileri
- Her hasta için tahlil sayısı

### Hasta Detay Sayfası
- Demografik bilgiler
- Tahlil sonuçları (normal aralık kontrolü ile)
- Muayene geçmişi

### Tahlil Sonuçları
- Renk kodlu normal aralık gösterimi
- Hasta bilgileri ile birlikte sonuçlar
- Tarih sıralı listeleme

## 🔧 Sorun Giderme

### Sık Karşılaşılan Problemler

#### 1. Oracle Container Başlamıyor
```bash
# Container durumunu kontrol edin
docker ps -a

# Logları kontrol edin
docker logs oracle-xe

# Container'ı yeniden başlatın
docker-compose restart oracle-db
```

#### 2. Veritabanı Bağlantı Hatası
```bash
# Oracle'ın hazır olup olmadığını kontrol edin
docker exec oracle-xe sqlplus sys/oracle123@localhost:1521/XE as sysdba

# Bağlantı testi
make test
```

#### 3. Python Modül Hatası
```bash
# Requirements'ı yeniden yükleyin
docker-compose build --no-cache hospital-app
```

#### 4. Port Çakışması
Docker Compose dosyasında port numaralarını değiştirin:
```yaml
ports:
  - "1522:1521"  # 1521 yerine 1522
  - "5001:5000"  # 5000 yerine 5001
```

#### 5. Veritabanı Şeması Yüklenmiyor
```bash
# Manuel şema yükleme
docker cp paste.txt oracle-xe:/tmp/
docker exec oracle-xe sqlplus hospital/hospital123@localhost:1521/XE @/tmp/paste.txt
```

### Log Kontrolü
```bash
# Tüm servis logları
make logs

# Sadece Oracle logları
make oracle-logs

# Flask uygulama logları
docker logs hospital-web
```

## 📊 Test Verileri

Sistem başlatıldığında otomatik olarak test verileri yüklenir:

- **5 Hasta**: Farklı kan grupları ve demografik bilgiler
- **5 Personel**: Farklı unvan ve polikliniklerden
- **8 Tahlil Sonucu**: Normal ve anormal değerlerle
- **6 Muayene Kaydı**: Farklı tarihlerden
- **3 Yatan Hasta**: Tedavi süreleri ile
- **3 Ayakta Tedavi**: Reçete ve teşhis bilgileri

## 📝 Geliştirici Notları

### Yeni Özellik Ekleme
1. Veritabanı değişiklikleri için `paste.txt` dosyasını güncelleyin
2. Flask route'ları `app.py` dosyasına ekleyin
3. HTML template'leri `templates/` klasörüne ekleyin
4. CSS/JS dosyalarını `static/` klasörüne yerleştirin

### Kod Yapısı
- **Database Connection**: `DatabaseConnection` sınıfı
- **Error Handling**: Her route'da kapsamlı hata yakalama
- **Template Inheritance**: `base.html` şablonu kullanımı
- **CSRF Protection**: Form güvenliği için token sistemi

### Performans İpuçları
- Index'ler sık kullanılan sorgular için optimize edilmiş
- Connection pooling Docker environment'ta otomatik
- View'lar karmaşık JOIN işlemleri için kullanılıyor

---

## 📄 Lisans

Bu proje eğitim amaçlı geliştirilmiştir ve MIT lisansı altında paylaşılmaktadır.

---

*Bu README dosyası projenin tam kullanım kılavuzudur. Kurulum veya kullanım ile ilgili sorularınız için issue açabilirsiniz.*