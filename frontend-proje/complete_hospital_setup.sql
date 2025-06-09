-- HASTANE VERİTABANI KURULUM SCRİPTİ - TEK SEFERDE OLUŞTUR

-- 1. TABLOLARI OLUŞTUR
CREATE TABLE Tahlil_Araliklari (
    Sonuc_Tipi VARCHAR2(50) PRIMARY KEY,
    Sonuc_Max NUMBER NOT NULL,
    Sonuc_Min NUMBER NOT NULL
);

CREATE TABLE Hastalar (
    Hasta_tc NUMBER(11) PRIMARY KEY,
    Hasta_Ad VARCHAR2(50) NOT NULL,
    Hasta_Soyad VARCHAR2(50) NOT NULL,
    Hasta_Email VARCHAR2(225),
    Hasta_Tel NUMBER(10) NOT NULL,
    Hasta_Dogum_Tarihi DATE,
    Kan_Grubu VARCHAR2(5) NOT NULL,
    CONSTRAINT chk_tc CHECK (Hasta_tc BETWEEN 10000000000 AND 99999999999),
    CONSTRAINT chk_tel CHECK (Hasta_Tel BETWEEN 5000000000 AND 6000000000),
    CONSTRAINT chk_kan_grubu CHECK (Kan_Grubu IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-'))
);

CREATE TABLE Poliklinikler (
    PoliklinikID NUMBER PRIMARY KEY,
    Poliklinik_adi VARCHAR2(50) NOT NULL
);

CREATE TABLE Unvanlar (
    UnvanID NUMBER PRIMARY KEY,
    Unvan_adi VARCHAR2(50) NOT NULL
);

CREATE TABLE Personeller (
    PersonelID NUMBER PRIMARY KEY,
    Personel_tc NUMBER(11) UNIQUE NOT NULL,
    Personel_Ad VARCHAR2(50) NOT NULL,
    Personel_Soyad VARCHAR2(50) NOT NULL,
    Personel_Email VARCHAR2(225),
    Personel_Tel NUMBER(10) NOT NULL,
    Unvan NUMBER NOT NULL,
    Poliklinik NUMBER NOT NULL,
    CONSTRAINT chk_personel_tc CHECK (Personel_tc BETWEEN 10000000000 AND 99999999999),
    CONSTRAINT chk_personel_tel CHECK (Personel_Tel BETWEEN 5000000000 AND 6000000000),
    CONSTRAINT fk_Unvan FOREIGN KEY (Unvan) REFERENCES Unvanlar(UnvanID),
    CONSTRAINT fk_Poliklinik FOREIGN KEY (Poliklinik) REFERENCES Poliklinikler(PoliklinikID)
);

CREATE TABLE Sisteme_Giris_Bilgileri (
    Personel NUMBER NOT NULL,
    Sifre VARCHAR2(50) UNIQUE,
    CONSTRAINT fk_Personel FOREIGN KEY (Personel) REFERENCES Personeller(PersonelID)
);

CREATE TABLE Sisteme_Giris_Zamani (
    Personel NUMBER NOT NULL,
    Giris_Zamani DATE,
    CONSTRAINT fk_Giris FOREIGN KEY (Personel) REFERENCES Personeller(PersonelID)
);

CREATE TABLE Tahlil_Log (
    LogID NUMBER PRIMARY KEY,
    tc NUMBER(11),
    Sonuc_Tipi VARCHAR2(50),
    Sonuc NUMBER,
    Tarih DATE,
    Log_Tarihi DATE DEFAULT SYSDATE
);

CREATE TABLE Teshis_Turleri (
    Teshis_Kodu VARCHAR2(20) PRIMARY KEY,
    Teshis_Aciklamasi VARCHAR2(255) NOT NULL
);

CREATE TABLE Muayeneler (
    MuayeneID NUMBER PRIMARY KEY,
    Hasta_tc NUMBER(11) NOT NULL,
    PersonelID NUMBER,
    Muayene_Tarihi DATE DEFAULT SYSDATE,
    Notlar VARCHAR2(500),
    CONSTRAINT fk_muayene_hasta FOREIGN KEY (Hasta_tc) REFERENCES Hastalar(Hasta_tc),
    CONSTRAINT fk_muayene_personel FOREIGN KEY (PersonelID) REFERENCES Personeller(PersonelID)
);

CREATE TABLE Tedavi_Yatarak (
    MuayeneID NUMBER PRIMARY KEY,
    Oda_No VARCHAR2(10) NOT NULL,
    Yatis_Tarihi DATE NOT NULL,
    Cikis_Tarihi DATE,
    Tedavi_Suresi NUMBER,
    Teshis_Kodu VARCHAR2(20),
    Tedavi_Eden_DoktorID NUMBER NOT NULL,
    CONSTRAINT fk_tedavi_yatarak_muayene FOREIGN KEY (MuayeneID) REFERENCES Muayeneler(MuayeneID),
    CONSTRAINT fk_tedavi_doktor FOREIGN KEY (Tedavi_Eden_DoktorID) REFERENCES Personeller(PersonelID),
    CONSTRAINT fk_teshis_kodu FOREIGN KEY (Teshis_Kodu) REFERENCES Teshis_Turleri(Teshis_Kodu)
);

CREATE TABLE Tedavi_Ayakta (
    MuayeneID NUMBER PRIMARY KEY,
    Uygulanan_Tedavi VARCHAR2(255),
    Recete VARCHAR2(4000),
    Teshis_Kodu VARCHAR2(20),
    CONSTRAINT fk_tedavi_ayakta_muayene FOREIGN KEY (MuayeneID) REFERENCES Muayeneler(MuayeneID),
    CONSTRAINT fk_teshis_kodu_ayakta FOREIGN KEY (Teshis_Kodu) REFERENCES Teshis_Turleri(Teshis_Kodu)
);

CREATE TABLE Tahliller (
    tc NUMBER(11) NOT NULL,
    Sonuc_Tipi VARCHAR2(50) NOT NULL,
    Sonuc NUMBER,
    Tarih DATE NOT NULL,
    CONSTRAINT fk_tc_tahlil FOREIGN KEY (tc) REFERENCES Hastalar(Hasta_tc),
    CONSTRAINT fk_sonuc_tipi FOREIGN KEY (Sonuc_Tipi) REFERENCES Tahlil_Araliklari(Sonuc_Tipi)
);

CREATE TABLE Radyolojik_Goruntuler (
    tc NUMBER(11) NOT NULL,
    Sonuc_Tipi VARCHAR2(50) NOT NULL,
    Sonuc BLOB,
    Tarih DATE NOT NULL,
    CONSTRAINT fk_tc2 FOREIGN KEY (tc) REFERENCES Hastalar(Hasta_tc),
    CONSTRAINT chk_sonuc_tipi_radyo CHECK (Sonuc_Tipi IN ('MR', 'RÖNTGEN'))
);

-- 2. SEQUENCE'LARI OLUŞTUR
CREATE SEQUENCE SEQ_PoliklinikID START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_UnvanID START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_PersonelID START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_TahlilLog START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_MuayeneID START WITH 1 INCREMENT BY 1;

-- 3. TRIGGER'LARI OLUŞTUR
CREATE OR REPLACE TRIGGER TRG_PoliklinikID
BEFORE INSERT ON Poliklinikler
FOR EACH ROW
BEGIN
    :NEW.PoliklinikID := SEQ_PoliklinikID.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER TRG_UnvanID
BEFORE INSERT ON Unvanlar
FOR EACH ROW
BEGIN
    :NEW.UnvanID := SEQ_UnvanID.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER TRG_PersonelID
BEFORE INSERT ON Personeller
FOR EACH ROW
BEGIN
    :NEW.PersonelID := SEQ_PersonelID.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER TRG_TahlilLog_ID
BEFORE INSERT ON Tahlil_Log
FOR EACH ROW
BEGIN
    IF :NEW.LogID IS NULL THEN
        :NEW.LogID := SEQ_TahlilLog.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_MuayeneID
BEFORE INSERT ON Muayeneler
FOR EACH ROW
BEGIN
    :NEW.MuayeneID := SEQ_MuayeneID.NEXTVAL;
END;
/

-- 4. ÖRNEK VERİLERİ EKLE
INSERT INTO Tahlil_Araliklari VALUES ('GLUKOZ', 110, 70);
INSERT INTO Tahlil_Araliklari VALUES ('KOLESTEROL', 200, 125);
INSERT INTO Tahlil_Araliklari VALUES ('TSH', 4.0, 0.4);
INSERT INTO Tahlil_Araliklari VALUES ('ÜRE', 45, 10);
INSERT INTO Tahlil_Araliklari VALUES ('DEMİR', 170, 60);
INSERT INTO Tahlil_Araliklari VALUES ('İNSÜLİN', 25, 2);

INSERT INTO Poliklinikler (Poliklinik_adi) VALUES ('Kardiyoloji');
INSERT INTO Poliklinikler (Poliklinik_adi) VALUES ('Nöroloji');
INSERT INTO Poliklinikler (Poliklinik_adi) VALUES ('Dahiliye');
INSERT INTO Poliklinikler (Poliklinik_adi) VALUES ('Göğüs Hastalıkları');
INSERT INTO Poliklinikler (Poliklinik_adi) VALUES ('Ortopedi');

INSERT INTO Unvanlar (Unvan_adi) VALUES ('Doktor');
INSERT INTO Unvanlar (Unvan_adi) VALUES ('Hemşire');
INSERT INTO Unvanlar (Unvan_adi) VALUES ('Teknisyen');
INSERT INTO Unvanlar (Unvan_adi) VALUES ('Uzman Doktor');
INSERT INTO Unvanlar (Unvan_adi) VALUES ('Başhekim');

INSERT INTO Hastalar VALUES (10000000001, 'Ali', 'Yılmaz', 'ali.yilmaz@example.com', 5301112233, TO_DATE('1990-05-12','YYYY-MM-DD'), 'A+');
INSERT INTO Hastalar VALUES (10000000002, 'Ayşe', 'Demir', 'ayse.demir@example.com', 5322223344, TO_DATE('1985-09-30','YYYY-MM-DD'), 'B+');
INSERT INTO Hastalar VALUES (10000000003, 'Mehmet', 'Öz', 'mehmet.oz@example.com', 5331234567, TO_DATE('1980-03-15','YYYY-MM-DD'), 'AB+');
INSERT INTO Hastalar VALUES (10000000004, 'Fatma', 'Kaya', 'fatma.kaya@example.com', 5342345678, TO_DATE('1992-08-20','YYYY-MM-DD'), '0+');
INSERT INTO Hastalar VALUES (10000000005, 'Ahmet', 'Şen', 'ahmet.sen@example.com', 5353456789, TO_DATE('1988-12-10','YYYY-MM-DD'), 'A-');

INSERT INTO Personeller (Personel_tc, Personel_Ad, Personel_Soyad, Personel_Email, Personel_Tel, Unvan, Poliklinik)
VALUES (20000000001, 'Dr. Mehmet', 'Kaya', 'mehmet.kaya@hospital.com', 5343334455, 4, 1);
INSERT INTO Personeller (Personel_tc, Personel_Ad, Personel_Soyad, Personel_Email, Personel_Tel, Unvan, Poliklinik)
VALUES (20000000002, 'Fatma', 'Çelik', 'fatma.celik@hospital.com', 5354445566, 2, 2);
INSERT INTO Personeller (Personel_tc, Personel_Ad, Personel_Soyad, Personel_Email, Personel_Tel, Unvan, Poliklinik)
VALUES (20000000003, 'Dr. Ahmet', 'Şen', 'ahmet.sen@hospital.com', 5365556677, 4, 3);
INSERT INTO Personeller (Personel_tc, Personel_Ad, Personel_Soyad, Personel_Email, Personel_Tel, Unvan, Poliklinik)
VALUES (20000000004, 'Zeynep', 'Aksoy', 'zeynep.aksoy@hospital.com', 5376667788, 2, 1);
INSERT INTO Personeller (Personel_tc, Personel_Ad, Personel_Soyad, Personel_Email, Personel_Tel, Unvan, Poliklinik)
VALUES (20000000005, 'Dr. Elif', 'Yıldız', 'elif.yildiz@hospital.com', 5387778899, 5, 4);

INSERT INTO Sisteme_Giris_Bilgileri VALUES (1, 'sifre123');
INSERT INTO Sisteme_Giris_Bilgileri VALUES (2, 'sifre456');
INSERT INTO Sisteme_Giris_Bilgileri VALUES (3, 'sifre789');
INSERT INTO Sisteme_Giris_Bilgileri VALUES (4, 'sifre101');
INSERT INTO Sisteme_Giris_Bilgileri VALUES (5, 'sifre202');

INSERT INTO Sisteme_Giris_Zamani VALUES (1, TO_DATE('2024-06-05 08:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Sisteme_Giris_Zamani VALUES (2, TO_DATE('2024-06-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Sisteme_Giris_Zamani VALUES (3, TO_DATE('2024-06-05 08:45:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Tahliller VALUES (10000000001, 'GLUKOZ', 95, TO_DATE('2024-04-01','YYYY-MM-DD'));
INSERT INTO Tahliller VALUES (10000000002, 'TSH', 2.1, TO_DATE('2024-04-02','YYYY-MM-DD'));
INSERT INTO Tahliller VALUES (10000000001, 'KOLESTEROL', 185, TO_DATE('2024-04-05','YYYY-MM-DD'));
INSERT INTO Tahliller VALUES (10000000003, 'ÜRE', 35, TO_DATE('2024-04-10','YYYY-MM-DD'));
INSERT INTO Tahliller VALUES (10000000004, 'DEMİR', 120, TO_DATE('2024-04-15','YYYY-MM-DD'));
INSERT INTO Tahliller VALUES (10000000005, 'İNSÜLİN', 15, TO_DATE('2024-04-20','YYYY-MM-DD'));

INSERT INTO Teshis_Turleri VALUES ('I20.0', 'Stabil angina pektoris');
INSERT INTO Teshis_Turleri VALUES ('R55', 'Senkop ve kollaps');
INSERT INTO Teshis_Turleri VALUES ('Z03.89', 'Tıbbi gözlem altında değerlendirme');
INSERT INTO Teshis_Turleri VALUES ('R51', 'Baş ağrısı');
INSERT INTO Teshis_Turleri VALUES ('J00', 'Nazofarenjit (soğuk algınlığı)');
INSERT INTO Teshis_Turleri VALUES ('I10', 'Esansiyel (primer) hipertansiyon');
INSERT INTO Teshis_Turleri VALUES ('R42', 'Baş dönmesi ve sersemlik');
INSERT INTO Teshis_Turleri VALUES ('Z00.0', 'Genel sağlık kontrolü');
INSERT INTO Teshis_Turleri VALUES ('Z76.0', 'Yinelenen reçete için başvuru');
INSERT INTO Teshis_Turleri VALUES ('M79.1', 'Miyalji');

INSERT INTO Muayeneler (Hasta_tc, PersonelID, Muayene_Tarihi, Notlar)
VALUES (10000000001, 1, TO_DATE('2024-03-30', 'YYYY-MM-DD'), 'Göğüs ağrısı şikayeti');
INSERT INTO Muayeneler (Hasta_tc, PersonelID, Muayene_Tarihi, Notlar)
VALUES (10000000002, 2, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Baş dönmesi');
INSERT INTO Muayeneler (Hasta_tc, PersonelID, Muayene_Tarihi, Notlar)
VALUES (10000000002, 1, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Düzenli kontrol');
INSERT INTO Muayeneler (Hasta_tc, PersonelID, Muayene_Tarihi, Notlar)
VALUES (10000000001, 2, TO_DATE('2024-05-02', 'YYYY-MM-DD'), 'İlaç raporu yenileme');
INSERT INTO Muayeneler (Hasta_tc, PersonelID, Muayene_Tarihi, Notlar)
VALUES (10000000001, 1, TO_DATE('2024-05-05', 'YYYY-MM-DD'), 'Bayılma sonrası yatış');
INSERT INTO Muayeneler (Hasta_tc, PersonelID, Muayene_Tarihi, Notlar)
VALUES (10000000002, 1, TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'Gözlem amaçlı yatış');
INSERT INTO Muayeneler (Hasta_tc, PersonelID, Muayene_Tarihi, Notlar)
VALUES (10000000003, 3, TO_DATE('2024-05-15', 'YYYY-MM-DD'), 'Rutin check-up');
INSERT INTO Muayeneler (Hasta_tc, PersonelID, Muayene_Tarihi, Notlar)
VALUES (10000000004, 4, TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'Kalp kontrol');

INSERT INTO Tedavi_Yatarak VALUES (1, '205A', TO_DATE('2024-03-30', 'YYYY-MM-DD'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), null, 'I20.0', 1);
INSERT INTO Tedavi_Yatarak VALUES (5, '301B', TO_DATE('2024-05-05', 'YYYY-MM-DD'), TO_DATE('2024-05-08', 'YYYY-MM-DD'), null, 'R55', 1);
INSERT INTO Tedavi_Yatarak VALUES (6, '102A', TO_DATE('2024-05-10', 'YYYY-MM-DD'), TO_DATE('2024-05-13', 'YYYY-MM-DD'), null, 'Z03.89', 1);

INSERT INTO Tedavi_Ayakta VALUES (2, 'Sıvı takviyesi ve tansiyon kontrolü önerildi', 'Betaserc 24mg, 2x1', 'R42');
INSERT INTO Tedavi_Ayakta VALUES (3, 'Kan tahlili ve tansiyon ölçümü yapıldı. Bulgular normal.', 'Multivitamin, 1x1', 'Z00.0');
INSERT INTO Tedavi_Ayakta VALUES (4, 'Reçetesi biten tansiyon ilacı yeniden yazıldı', 'Norvasc 5mg, 1x1', 'Z76.0');
INSERT INTO Tedavi_Ayakta VALUES (7, 'Genel sağlık kontrolü yapıldı, normal bulgular', 'Vitamin D3, 1x1', 'Z00.0');
INSERT INTO Tedavi_Ayakta VALUES (8, 'EKG çekildi, kalp ritmi normal', 'Aspirin 100mg, 1x1', 'Z00.0');

-- 5. FONKSİYONLARI OLUŞTUR
CREATE OR REPLACE FUNCTION FN_Personel_Sayisi_Poliklinik(p_id IN NUMBER)
RETURN NUMBER
IS
    toplam NUMBER;
BEGIN
    SELECT COUNT(*) INTO toplam
    FROM Personeller
    WHERE Poliklinik = p_id;
    RETURN toplam;
END;
/

-- Test ve commit
COMMIT;
SELECT 'HASTANE VERİTABANI BAŞARIYLA OLUŞTURULDU!' AS DURUM FROM DUAL;
SELECT 'TOPLAM TABLO SAYISI: ' || COUNT(*) AS TABLO_SAYISI FROM user_tables;
SELECT 'TOPLAM HASTA SAYISI: ' || COUNT(*) AS HASTA_SAYISI FROM Hastalar;
SELECT 'TOPLAM PERSONEL SAYISI: ' || COUNT(*) AS PERSONEL_SAYISI FROM Personeller;
SELECT FN_Personel_Sayisi_Poliklinik(1) AS kardiyoloji_personel_sayisi FROM DUAL;
