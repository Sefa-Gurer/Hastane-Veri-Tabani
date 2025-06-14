# 🏥 Hastane Veri Tabanı Yönetim Sistemi

Bu proje, Oracle Database ve Flask kullanılarak geliştirilmiş kapsamlı bir hastane yönetim sistemidir. Hasta kayıtları, personel yönetimi, tahlil sonuçları ve muayene takibi gibi temel hastane işlemlerini kapsar.

## 📋 İçindekiler

- [Proje Hakkında](#proje-hakkında)
- [Özellikler](#özellikler)
- [Teknoloji Stack](#teknoloji-stack)
- [Kurulum](#kurulum)
- [Kullanım](#kullanım)
- [Veritabanı Şeması](#veritabanı-şeması)
- [Ekran Görüntüleri](#ekran-görüntüleri)
- [Proje Yapısı](#proje-yapısı)
- [Katkıda Bulunma](#katkıda-bulunma)

## 🎯 Proje Hakkında

Hastane Veri Tabanı Yönetim Sistemi, modern web teknolojileri kullanılarak geliştirilmiş bir sağlık bilgi sistemidir. Oracle Database'in güçlü özelliklerini kullanarak karmaşık veri ilişkilerini yönetir ve Flask web framework ile kullanıcı dostu bir arayüz sunar.

### Proje Amaçları
- Oracle Database ile profesyonel veri tabanı yönetimi
- PL/SQL stored procedure, function ve trigger kullanımı
- Flask ile modern web uygulaması geliştirme
- Docker containerization teknolojisi uygulama
- Hastane iş süreçlerinin dijitalleştirilmesi

## ✨ Özellikler

### 👥 Hasta Yönetimi
- Hasta kayıt ve bilgi güncelleme sistemi
- Demografik bilgi ve kan grubu takibi
- Tahlil geçmişi ve sonuç analizi
- Muayene kayıtları ve tedavi geçmişi

### 👨‍⚕️ Personel Yönetimi
- Doktor, hemşire ve teknisyen kayıtları
- Poliklinik bazında personel organizasyonu
- Unvan ve yetki yönetimi
- Sisteme giriş kontrolü

### 🧪 Tahlil ve Laboratuvar
- Laboratuvar sonuçları kayıt sistemi
- Normal değer aralık kontrolü
- Anormal sonuç uyarıları
- Tarihsel tahlil trend analizi

### 📊 Raporlama ve Analiz
- Gerçek zamanlı istatistiksel raporlar
- Kan grubu dağılım analizleri
- Aylık muayene trend grafikleri
- Poliklinik bazında personel dağılımı

### 🏥 Tedavi Takibi
- Yatan hasta yönetim sistemi
- Ayakta tedavi kayıtları
- ICD-10 teşhis kod sistemi
- Tedavi süresi otomatik hesaplama

## 🛠 Teknoloji Stack

- **Backend**: Python Flask 2.3+
- **Database**: Oracle Database XE 21c
- **Frontend**: HTML5, CSS3, Bootstrap 5, JavaScript
- **Containerization**: Docker & Docker Compose
- **Database Driver**: cx_Oracle 8.3.0
- **Template Engine**: Jinja2
- **Validation**: WTForms, Flask-WTF

## 🚀 Kurulum

### Ön Gereksinimler
- Docker 20.10+
- Docker Compose 1.29+
- Git

### Hızlı Kurulum

1. **Projeyi İndirin**
```bash
git clone <repository-url>
cd Hastane-Veri-Tabani
```

2. **Otomatik Kurulum**
```bash
cd frontend-proje
make quick-install
```

3. **Servisleri Başlatın**
```bash
make start
```

4. **Uygulamaya Erişim**
- Web Arayüz: http://localhost:5000
- Oracle Database: localhost:1521
- Oracle Enterprise Manager: http://localhost:5500/em

### Manuel Kurulum

```bash
# Docker servisleri başlat
docker-compose up -d

# Veritabanı bağlantısını test et
make test

# Logs kontrol et
make logs
```

## 💻 Kullanım

### Ana Dashboard
- **URL**: http://localhost:5000
- Sistem istatistikleri ve genel bakış
- Hızlı erişim menüleri
- Son tahlil sonuçları

### Hasta İşlemleri
- **Hasta Listesi**: Tüm hasta kayıtlarını görüntüleme
- **Hasta Detayı**: Detaylı hasta bilgileri ve tahlil geçmişi
- **Yeni Hasta**: Hasta ekleme formu (Procedure kullanımı)

### Personel İşlemleri
- **Personel Listesi**: Aktif personel görüntüleme (View kullanımı)
- **Yeni Personel**: Personel ekleme (Procedure kullanımı)

### Tahlil Sistemi
- **Tahlil Sonuçları**: Normal aralık kontrolü ile sonuç görüntüleme
- **Filtreleme**: Normal/Anormal sonuç filtreleme

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

### PL/SQL Fonksiyonlar

#### FN_Personel_Sayisi_Poliklinik
```sql
-- Poliklinik bazında personel sayısını döner
SELECT FN_Personel_Sayisi_Poliklinik(1) FROM DUAL;
```

#### FN_Tahlil_Sayisi
```sql
-- Hastanın toplam tahlil sayısını döner
SELECT FN_Tahlil_Sayisi(10000000001) FROM DUAL;
```

### Stored Procedures

#### Hasta_Ekle & Personel_Ekle
- Parametre validasyonu ile güvenli veri girişi
- Hata yönetimi ve exception handling
- DBMS_OUTPUT mesajları

### Triggers

- **TRG_PersonelID**: Otomatik ID oluşturma
- **TRG_HastaEmailKontrol**: Email format validasyonu
- **TRG_Tedavi_Suresi**: Tedavi süresini otomatik hesaplama
- **TRG_GirisLog**: Sisteme giriş kayıtları

### Views

- **vw_Personel_Gorunumu**: Personel JOIN bilgileri
- **vw_Hasta_Tahlil_Ozeti**: Hasta tahlil özetleri

## 📸 Ekran Görüntüleri

### Database Export Dosyası ve Website Ekran Görüntüleri

<table align="center">
  <tr>
    <td align="center">
      <img src="Ekran Görüntüleri/IMG-20250610-WA0105.jpg" width="400px" alt="Ana Dashboard"/>
      <br/>
      <em><strong>Ana Dashboard</strong><br/>Sistem istatistikleri ve genel bakış</em>
    </td>
    <td align="center">
      <img src="Ekran Görüntüleri/IMG-20250610-WA0106.jpg" width="400px" alt="Hasta Yönetimi"/>
      <br/>
      <em><strong>Hasta Yönetimi</strong><br/>Hasta listesi ve detay bilgileri</em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="Ekran Görüntüleri/IMG-20250610-WA0107.jpg" width="400px" alt="Personel Sistemi"/>
      <br/>
      <em><strong>Personel Sistemi</strong><br/>Personel kayıt ve yönetim</em>
    </td>
    <td align="center">
      <img src="Ekran Görüntüleri/IMG-20250610-WA0108.jpg" width="400px" alt="Tahlil Sonuçları"/>
      <br/>
      <em><strong>Tahlil Sonuçları</strong><br/>Normal aralık kontrolü ile sonuçlar</em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="Ekran Görüntüleri/IMG-20250610-WA0109.jpg" width="400px" alt="Raporlama Sistemi"/>
      <br/>
      <em><strong>Raporlama Sistemi</strong><br/>İstatistiksel analizler ve grafikler</em>
    </td>
    <td align="center">
      <img src="Ekran Görüntüleri/IMG-20250610-WA0110.jpg" width="400px" alt="Veri Formu"/>
      <br/>
      <em><strong>Veri Giriş Formları</strong><br/>Hasta ve personel ekleme</em>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="Ekran Görüntüleri/IMG-20250610-WA0111.jpg" width="400px" alt="Database Schema"/>
      <br/>
      <em><strong>Veritabanı Şeması</strong><br/>Tablo yapısı ve ilişkiler</em>
    </td>
    <td align="center">
      <img src="Ekran Görüntüleri/IMG-20250610-WA0112.jpg" width="400px" alt="Oracle Database"/>
      <br/>
      <em><strong>Oracle Database</strong><br/>SQL Developer ve tablo yapıları</em>
    </td>
  </tr>
  <tr>
    <td align="center" colspan="2">
      <img src="Ekran Görüntüleri/IMG-20250610-WA0113.jpg" width="400px" alt="Sistem Görünümü"/>
      <br/>
      <em><strong>Sistem Genel Görünümü</strong><br/>Uygulamanın genel kullanım arayüzü</em>
    </td>
  </tr>
</table>

## 📁 Proje Yapısı

```
Hastane-Veri-Tabani/
├── 📁 Adem/                    # Adem'in PL/SQL kodları
│   ├── index 1.txt            # Tahlil index
│   ├── index 2.txt            # Radyoloji index
│   ├── procedure 1.txt        # Personel ekleme procedure
│   └── procedure 2.txt        # Hasta ekleme procedure
├── 📁 Akın/                   # Akın'ın PL/SQL kodları
│   ├── index 3.txt           # Tahlil tarih index
│   ├── trigger 1.txt         # Giriş log trigger
│   └── trigger 2.txt         # Email kontrol trigger
├── 📁 Sefa/                   # Sefa'nın PL/SQL kodları
│   ├── fonksiyon 1.txt       # Personel sayısı fonksiyonu
│   ├── fonksiyon 2.txt       # Tahlil sayısı fonksiyonu
│   ├── trigger 3.txt         # Tedavi süresi trigger
│   ├── view 1.txt            # Personel görünümü
│   └── view 2.txt            # Hasta tahlil özeti
├── 📁 frontend-proje/         # Flask Web Uygulaması
│   ├── 📁 templates/         # HTML şablonları
│   ├── app.py                # Ana Flask uygulaması
│   ├── docker-compose.yml    # Docker servisleri
│   ├── Dockerfile            # Flask container
│   ├── requirements.txt      # Python bağımlılıkları
│   ├── Makefile             # Otomatik komutlar
│   └── README.md            # Detaylı dokümantasyon
├── 📁 Ekran Görüntüleri/     # Uygulama ekran görüntüleri
│   ├── IMG-20250610-WA0105.jpg
│   ├── IMG-20250610-WA0106.jpg
│   ├── IMG-20250610-WA0107.jpg
│   ├── IMG-20250610-WA0108.jpg
│   ├── IMG-20250610-WA0109.jpg
│   ├── IMG-20250610-WA0110.jpg
│   ├── IMG-20250610-WA0111.jpg
│   ├── IMG-20250610-WA0112.jpg
│   └── IMG-20250610-WA0113.jpg
├── local_sys_izinler.txt      # Oracle sistem izinleri
├── sahte_veri.txt            # Test verileri
├── veritabani_temel.txt      # Temel tablo yapıları
└── README.md                 # Bu dosya
```

## 🔧 Kullanışlı Komutlar

```bash
# Hızlı başlatma
make quick-install

# Servisleri başlat/durdur
make start
make stop

# Logları görüntüle
make logs
make oracle-logs

# Veritabanı bağlantısı test et
make test

# Oracle SQL shell
make db-shell

# Temizlik
make clean
```

## 🧪 Test Verileri

Sistem otomatik olarak test verileri ile gelir:
- **5 Hasta**: Farklı kan grupları ve demografik bilgiler
- **5 Personel**: Farklı unvan ve polikliniklerden
- **8 Tahlil Sonucu**: Normal ve anormal değerlerle
- **6 Muayene Kaydı**: Farklı tarihlerden
- **3 Yatan Hasta**: Tedavi süreleri ile
- **Multiple Ayakta Tedavi**: Reçete ve teşhis bilgileri

## 🚨 Sorun Giderme

### Oracle Container Başlamıyor
```bash
docker logs oracle-xe
docker-compose restart oracle-db
```

### Bağlantı Hatası
```bash
make test
docker exec oracle-xe sqlplus sys/oracle123@localhost:1521/XE as sysdba
```

### Port Çakışması
Docker Compose dosyasında port numaralarını değiştirin.

## 👥 Katkıda Bulunma

1. **Adem**: Index'ler ve Procedure'lar
   - Tahlil ve Radyoloji index'leri
   - Personel ve Hasta ekleme procedure'ları

2. **Akın**: Trigger'lar ve Index'ler
   - Sisteme giriş log trigger'ı
   - Email kontrol trigger'ı
   - Tahlil tarih index'i

3. **Sefa**: Fonksiyonlar, Trigger'lar ve View'lar
   - Personel sayısı ve tahlil sayısı fonksiyonları
   - Tedavi süresi trigger'ı
   - Personel ve tahlil view'ları

## 📄 Lisans

Bu proje eğitim amaçlı geliştirilmiştir ve MIT lisansı altında paylaşılmaktadır.

---

**🔗 Faydalı Linkler:**
- [Oracle Database Documentation](https://docs.oracle.com/en/database/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Bootstrap Documentation](https://getbootstrap.com/docs/)
- [Docker Documentation](https://docs.docker.com/)

---

*Bu proje, Oracle Database ve Flask teknolojilerini kullanarak modern bir hastane yönetim sistemi geliştirme sürecini göstermektedir. Eğitim ve öğrenme amaçlı hazırlanmıştır.*
