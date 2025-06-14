--------------------------------------------------------
--  File created - Saturday-June-14-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence SEQ_MUAYENEID
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_MUAYENEID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_PERSONELID
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_PERSONELID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_POLIKLINIKID
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_POLIKLINIKID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_TAHLILLOG
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_TAHLILLOG"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_UNVANID
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_UNVANID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Table HASTALAR
--------------------------------------------------------

  CREATE TABLE "HASTALAR" 
   (	"HASTA_TC" NUMBER(11,0), 
	"HASTA_AD" VARCHAR2(50), 
	"HASTA_SOYAD" VARCHAR2(50), 
	"HASTA_EMAIL" VARCHAR2(225), 
	"HASTA_TEL" NUMBER(10,0), 
	"HASTA_DOGUM_TARIHI" DATE, 
	"KAN_GRUBU" VARCHAR2(5)
   ) ;
--------------------------------------------------------
--  DDL for Table MUAYENELER
--------------------------------------------------------

  CREATE TABLE "MUAYENELER" 
   (	"MUAYENEID" NUMBER, 
	"HASTA_TC" NUMBER(11,0), 
	"PERSONELID" NUMBER, 
	"MUAYENE_TARIHI" DATE DEFAULT SYSDATE, 
	"NOTLAR" VARCHAR2(500)
   ) ;
--------------------------------------------------------
--  DDL for Table PERSONELLER
--------------------------------------------------------

  CREATE TABLE "PERSONELLER" 
   (	"PERSONELID" NUMBER, 
	"PERSONEL_TC" NUMBER(11,0), 
	"PERSONEL_AD" VARCHAR2(50), 
	"PERSONEL_SOYAD" VARCHAR2(50), 
	"PERSONEL_EMAIL" VARCHAR2(225), 
	"PERSONEL_TEL" NUMBER(10,0), 
	"UNVAN" NUMBER, 
	"POLIKLINIK" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table POLIKLINIKLER
--------------------------------------------------------

  CREATE TABLE "POLIKLINIKLER" 
   (	"POLIKLINIKID" NUMBER, 
	"POLIKLINIK_ADI" VARCHAR2(50)
   ) ;
--------------------------------------------------------
--  DDL for Table RADYOLOJIK_GORUNTULER
--------------------------------------------------------

  CREATE TABLE "RADYOLOJIK_GORUNTULER" 
   (	"TC" NUMBER(11,0), 
	"SONUC_TIPI" VARCHAR2(50), 
	"SONUC" BLOB, 
	"TARIH" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table SISTEME_GIRIS_BILGILERI
--------------------------------------------------------

  CREATE TABLE "SISTEME_GIRIS_BILGILERI" 
   (	"PERSONEL" NUMBER, 
	"SIFRE" VARCHAR2(50)
   ) ;
--------------------------------------------------------
--  DDL for Table SISTEME_GIRIS_ZAMANI
--------------------------------------------------------

  CREATE TABLE "SISTEME_GIRIS_ZAMANI" 
   (	"PERSONEL" NUMBER, 
	"GIRIS_ZAMANI" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TAHLILLER
--------------------------------------------------------

  CREATE TABLE "TAHLILLER" 
   (	"TC" NUMBER(11,0), 
	"SONUC_TIPI" VARCHAR2(50), 
	"SONUC" NUMBER, 
	"TARIH" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table TAHLIL_ARALIKLERI
--------------------------------------------------------

  CREATE TABLE "TAHLIL_ARALIKLERI" 
   (	"SONUC_TIPI" VARCHAR2(50), 
	"SONUC_MAX" NUMBER, 
	"SONUC_MIN" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table TAHLIL_LOG
--------------------------------------------------------

  CREATE TABLE "TAHLIL_LOG" 
   (	"LOGID" NUMBER, 
	"TC" NUMBER(11,0), 
	"SONUC_TIPI" VARCHAR2(50), 
	"SONUC" NUMBER, 
	"TARIH" DATE, 
	"LOG_TARIHI" DATE DEFAULT SYSDATE
   ) ;
--------------------------------------------------------
--  DDL for Table TEDAVI_AYAKTA
--------------------------------------------------------

  CREATE TABLE "TEDAVI_AYAKTA" 
   (	"MUAYENEID" NUMBER, 
	"UYGULANAN_TEDAVI" VARCHAR2(255), 
	"RECETE" VARCHAR2(4000), 
	"TESHIS_KODU" VARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table TEDAVI_YATARAK
--------------------------------------------------------

  CREATE TABLE "TEDAVI_YATARAK" 
   (	"MUAYENEID" NUMBER, 
	"ODA_NO" VARCHAR2(10), 
	"YATIS_TARIHI" DATE, 
	"CIKIS_TARIHI" DATE, 
	"TEDAVI_SURESI" NUMBER, 
	"TESHIS_KODU" VARCHAR2(20), 
	"TEDAVI_EDEN_DOKTORID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table TESHIS_TURLERI
--------------------------------------------------------

  CREATE TABLE "TESHIS_TURLERI" 
   (	"TESHIS_KODU" VARCHAR2(20), 
	"TESHIS_ACIKLAMASI" VARCHAR2(255)
   ) ;
--------------------------------------------------------
--  DDL for Table UNVANLAR
--------------------------------------------------------

  CREATE TABLE "UNVANLAR" 
   (	"UNVANID" NUMBER, 
	"UNVAN_ADI" VARCHAR2(50)
   ) ;
--------------------------------------------------------
--  DDL for View VW_HASTA_TAHLIL_OZETI
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_HASTA_TAHLIL_OZETI" ("HASTA_TC", "HASTA_AD", "HASTA_SOYAD", "SONUC_TIPI", "SONUC", "TAHLIL_TARIHI") AS 
  SELECT 
    h.Hasta_tc,
    h.Hasta_Ad,
    h.Hasta_Soyad,
    t.Sonuc_Tipi,
    t.Sonuc,
    TO_CHAR(t.Tarih, 'DD.MM.YYYY') AS Tahlil_Tarihi
FROM Hastalar h
JOIN Tahliller t ON h.Hasta_tc = t.tc
;
--------------------------------------------------------
--  DDL for View VW_PERSONEL_GORUNUMU
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PERSONEL_GORUNUMU" ("PERSONELID", "PERSONEL_TC", "PERSONEL_AD", "PERSONEL_SOYAD", "PERSONEL_EMAIL", "PERSONEL_TEL", "UNVAN", "POLIKLINIK") AS 
  SELECT 
    p.PersonelID,
    p.Personel_tc,
    p.Personel_Ad,
    p.Personel_Soyad,
    p.Personel_Email,
    p.Personel_Tel,
    u.Unvan_adi AS Unvan,
    pk.Poliklinik_adi AS Poliklinik
FROM Personeller p
JOIN Unvanlar u ON p.Unvan = u.UnvanID
JOIN Poliklinikler pk ON p.Poliklinik = pk.PoliklinikID
;
REM INSERTING into HASTALAR
SET DEFINE OFF;
Insert into HASTALAR (HASTA_TC,HASTA_AD,HASTA_SOYAD,HASTA_EMAIL,HASTA_TEL,HASTA_DOGUM_TARIHI,KAN_GRUBU) values (10000000001,'Ali','Y?lmaz','ali.yilmaz@example.com',5301112233,to_date('12-MAY-90','DD-MON-RR'),'A+');
Insert into HASTALAR (HASTA_TC,HASTA_AD,HASTA_SOYAD,HASTA_EMAIL,HASTA_TEL,HASTA_DOGUM_TARIHI,KAN_GRUBU) values (10000000002,'Ay?e','Demir','ayse.demir@example.com',5322223344,to_date('30-SEP-85','DD-MON-RR'),'B+');
REM INSERTING into MUAYENELER
SET DEFINE OFF;
Insert into MUAYENELER (MUAYENEID,HASTA_TC,PERSONELID,MUAYENE_TARIHI,NOTLAR) values (1,10000000001,1,to_date('30-MAR-24','DD-MON-RR'),'Gö?üs a?r?s? ?ikayeti');
Insert into MUAYENELER (MUAYENEID,HASTA_TC,PERSONELID,MUAYENE_TARIHI,NOTLAR) values (2,10000000002,2,to_date('01-APR-24','DD-MON-RR'),'Ba? dönmesi');
Insert into MUAYENELER (MUAYENEID,HASTA_TC,PERSONELID,MUAYENE_TARIHI,NOTLAR) values (3,10000000002,1,to_date('01-MAY-24','DD-MON-RR'),'Düzenli kontrol');
Insert into MUAYENELER (MUAYENEID,HASTA_TC,PERSONELID,MUAYENE_TARIHI,NOTLAR) values (4,10000000001,2,to_date('02-MAY-24','DD-MON-RR'),'?laç raporu yenileme');
Insert into MUAYENELER (MUAYENEID,HASTA_TC,PERSONELID,MUAYENE_TARIHI,NOTLAR) values (5,10000000001,1,to_date('05-MAY-24','DD-MON-RR'),'Bay?lma sonras? yat??');
Insert into MUAYENELER (MUAYENEID,HASTA_TC,PERSONELID,MUAYENE_TARIHI,NOTLAR) values (6,10000000002,1,to_date('10-MAY-24','DD-MON-RR'),'Gözlem amaçl? yat??');
REM INSERTING into PERSONELLER
SET DEFINE OFF;
Insert into PERSONELLER (PERSONELID,PERSONEL_TC,PERSONEL_AD,PERSONEL_SOYAD,PERSONEL_EMAIL,PERSONEL_TEL,UNVAN,POLIKLINIK) values (1,20000000001,'Mehmet','Kaya','mehmet.kaya@example.com',5343334455,1,1);
Insert into PERSONELLER (PERSONELID,PERSONEL_TC,PERSONEL_AD,PERSONEL_SOYAD,PERSONEL_EMAIL,PERSONEL_TEL,UNVAN,POLIKLINIK) values (2,20000000002,'Fatma','Çelik','fatma.celik@example.com',5354445566,2,2);
REM INSERTING into POLIKLINIKLER
SET DEFINE OFF;
Insert into POLIKLINIKLER (POLIKLINIKID,POLIKLINIK_ADI) values (1,'Kardiyoloji');
Insert into POLIKLINIKLER (POLIKLINIKID,POLIKLINIK_ADI) values (2,'Nöroloji');
Insert into POLIKLINIKLER (POLIKLINIKID,POLIKLINIK_ADI) values (3,'Dahiliye');
REM INSERTING into RADYOLOJIK_GORUNTULER
SET DEFINE OFF;
Insert into RADYOLOJIK_GORUNTULER (TC,SONUC_TIPI,TARIH) values (10000000001,'MR',to_date('15-MAR-24','DD-MON-RR'));
Insert into RADYOLOJIK_GORUNTULER (TC,SONUC_TIPI,TARIH) values (10000000002,'RÖNTGEN',to_date('16-MAR-24','DD-MON-RR'));
REM INSERTING into SISTEME_GIRIS_BILGILERI
SET DEFINE OFF;
Insert into SISTEME_GIRIS_BILGILERI (PERSONEL,SIFRE) values (1,'sifre123');
Insert into SISTEME_GIRIS_BILGILERI (PERSONEL,SIFRE) values (2,'sifre456');
REM INSERTING into SISTEME_GIRIS_ZAMANI
SET DEFINE OFF;
Insert into SISTEME_GIRIS_ZAMANI (PERSONEL,GIRIS_ZAMANI) values (1,to_date('10-MAY-24','DD-MON-RR'));
Insert into SISTEME_GIRIS_ZAMANI (PERSONEL,GIRIS_ZAMANI) values (2,to_date('10-MAY-24','DD-MON-RR'));
REM INSERTING into TAHLILLER
SET DEFINE OFF;
Insert into TAHLILLER (TC,SONUC_TIPI,SONUC,TARIH) values (10000000001,'GLUKOZ',95,to_date('01-APR-24','DD-MON-RR'));
Insert into TAHLILLER (TC,SONUC_TIPI,SONUC,TARIH) values (10000000002,'TSH',2.1,to_date('02-APR-24','DD-MON-RR'));
REM INSERTING into TAHLIL_ARALIKLERI
SET DEFINE OFF;
Insert into TAHLIL_ARALIKLERI (SONUC_TIPI,SONUC_MAX,SONUC_MIN) values ('GLUKOZ',110,70);
Insert into TAHLIL_ARALIKLERI (SONUC_TIPI,SONUC_MAX,SONUC_MIN) values ('KOLESTEROL',200,125);
Insert into TAHLIL_ARALIKLERI (SONUC_TIPI,SONUC_MAX,SONUC_MIN) values ('TSH',4,0.4);
Insert into TAHLIL_ARALIKLERI (SONUC_TIPI,SONUC_MAX,SONUC_MIN) values ('ÜRE',45,10);
Insert into TAHLIL_ARALIKLERI (SONUC_TIPI,SONUC_MAX,SONUC_MIN) values ('DEM?R',170,60);
Insert into TAHLIL_ARALIKLERI (SONUC_TIPI,SONUC_MAX,SONUC_MIN) values ('?NSÜL?N',25,2);
REM INSERTING into TAHLIL_LOG
SET DEFINE OFF;
REM INSERTING into TEDAVI_AYAKTA
SET DEFINE OFF;
Insert into TEDAVI_AYAKTA (MUAYENEID,UYGULANAN_TEDAVI,RECETE,TESHIS_KODU) values (2,'S?v? takviyesi ve tansiyon kontrolü önerildi','Betaserc 24mg, 2x1','R42');
Insert into TEDAVI_AYAKTA (MUAYENEID,UYGULANAN_TEDAVI,RECETE,TESHIS_KODU) values (3,'Kan tahlili ve tansiyon ölçümü yap?ld?. Bulgular normal.','Multivitamin, 1x1','Z00.0');
Insert into TEDAVI_AYAKTA (MUAYENEID,UYGULANAN_TEDAVI,RECETE,TESHIS_KODU) values (4,'Reçetesi biten tansiyon ilac? yeniden yaz?ld?','Norvasc 5mg, 1x1','Z76.0');
REM INSERTING into TEDAVI_YATARAK
SET DEFINE OFF;
Insert into TEDAVI_YATARAK (MUAYENEID,ODA_NO,YATIS_TARIHI,CIKIS_TARIHI,TEDAVI_SURESI,TESHIS_KODU,TEDAVI_EDEN_DOKTORID) values (1,'205A',to_date('30-MAR-24','DD-MON-RR'),to_date('04-APR-24','DD-MON-RR'),null,'I20.0',1);
Insert into TEDAVI_YATARAK (MUAYENEID,ODA_NO,YATIS_TARIHI,CIKIS_TARIHI,TEDAVI_SURESI,TESHIS_KODU,TEDAVI_EDEN_DOKTORID) values (5,'301B',to_date('05-MAY-24','DD-MON-RR'),to_date('08-MAY-24','DD-MON-RR'),null,'R55',1);
Insert into TEDAVI_YATARAK (MUAYENEID,ODA_NO,YATIS_TARIHI,CIKIS_TARIHI,TEDAVI_SURESI,TESHIS_KODU,TEDAVI_EDEN_DOKTORID) values (6,'102A',to_date('10-MAY-24','DD-MON-RR'),to_date('13-MAY-24','DD-MON-RR'),null,'Z03.89',1);
REM INSERTING into TESHIS_TURLERI
SET DEFINE OFF;
Insert into TESHIS_TURLERI (TESHIS_KODU,TESHIS_ACIKLAMASI) values ('I20.0','Stabil angina pektoris');
Insert into TESHIS_TURLERI (TESHIS_KODU,TESHIS_ACIKLAMASI) values ('R55','Senkop ve kollaps');
Insert into TESHIS_TURLERI (TESHIS_KODU,TESHIS_ACIKLAMASI) values ('Z03.89','T?bbi gözlem alt?nda de?erlendirme');
Insert into TESHIS_TURLERI (TESHIS_KODU,TESHIS_ACIKLAMASI) values ('R51','Ba? a?r?s?');
Insert into TESHIS_TURLERI (TESHIS_KODU,TESHIS_ACIKLAMASI) values ('J00','Nazofarenjit (so?uk alg?nl???)');
Insert into TESHIS_TURLERI (TESHIS_KODU,TESHIS_ACIKLAMASI) values ('I10','Esansiyel (primer) hipertansiyon');
Insert into TESHIS_TURLERI (TESHIS_KODU,TESHIS_ACIKLAMASI) values ('R42','Ba? dönmesi ve sersemlik');
Insert into TESHIS_TURLERI (TESHIS_KODU,TESHIS_ACIKLAMASI) values ('Z00.0','Genel sa?l?k kontrolü');
Insert into TESHIS_TURLERI (TESHIS_KODU,TESHIS_ACIKLAMASI) values ('Z76.0','Yinelenen reçete için ba?vuru');
REM INSERTING into UNVANLAR
SET DEFINE OFF;
Insert into UNVANLAR (UNVANID,UNVAN_ADI) values (1,'Doktor');
Insert into UNVANLAR (UNVANID,UNVAN_ADI) values (2,'Hem?ire');
Insert into UNVANLAR (UNVANID,UNVAN_ADI) values (3,'Teknisyen');
REM INSERTING into VW_HASTA_TAHLIL_OZETI
SET DEFINE OFF;
Insert into VW_HASTA_TAHLIL_OZETI (HASTA_TC,HASTA_AD,HASTA_SOYAD,SONUC_TIPI,SONUC,TAHLIL_TARIHI) values (10000000001,'Ali','Y?lmaz','GLUKOZ',95,'01.04.2024');
Insert into VW_HASTA_TAHLIL_OZETI (HASTA_TC,HASTA_AD,HASTA_SOYAD,SONUC_TIPI,SONUC,TAHLIL_TARIHI) values (10000000002,'Ay?e','Demir','TSH',2.1,'02.04.2024');
REM INSERTING into VW_PERSONEL_GORUNUMU
SET DEFINE OFF;
Insert into VW_PERSONEL_GORUNUMU (PERSONELID,PERSONEL_TC,PERSONEL_AD,PERSONEL_SOYAD,PERSONEL_EMAIL,PERSONEL_TEL,UNVAN,POLIKLINIK) values (1,20000000001,'Mehmet','Kaya','mehmet.kaya@example.com',5343334455,'Doktor','Kardiyoloji');
Insert into VW_PERSONEL_GORUNUMU (PERSONELID,PERSONEL_TC,PERSONEL_AD,PERSONEL_SOYAD,PERSONEL_EMAIL,PERSONEL_TEL,UNVAN,POLIKLINIK) values (2,20000000002,'Fatma','Çelik','fatma.celik@example.com',5354445566,'Hem?ire','Nöroloji');
--------------------------------------------------------
--  DDL for Index IDX_RADYOLOJI_TARIH
--------------------------------------------------------

  CREATE INDEX "IDX_RADYOLOJI_TARIH" ON "RADYOLOJIK_GORUNTULER" ("TARIH") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_TAHLILLER_TC_TARIH
--------------------------------------------------------

  CREATE INDEX "IDX_TAHLILLER_TC_TARIH" ON "TAHLILLER" ("TC", "TARIH") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_TAHLILTARIH
--------------------------------------------------------

  CREATE INDEX "IDX_TAHLILTARIH" ON "TAHLILLER" ("TARIH") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007107
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007107" ON "HASTALAR" ("HASTA_TC") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007110
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007110" ON "TAHLIL_ARALIKLERI" ("SONUC_TIPI") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007122
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007122" ON "POLIKLINIKLER" ("POLIKLINIKID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007124
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007124" ON "UNVANLAR" ("UNVANID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007133
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007133" ON "PERSONELLER" ("PERSONELID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007134
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007134" ON "PERSONELLER" ("PERSONEL_TC") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007138
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007138" ON "SISTEME_GIRIS_BILGILERI" ("SIFRE") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007142
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007142" ON "TAHLIL_LOG" ("LOGID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007144
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007144" ON "TESHIS_TURLERI" ("TESHIS_KODU") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007146
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007146" ON "MUAYENELER" ("MUAYENEID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007152
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007152" ON "TEDAVI_YATARAK" ("MUAYENEID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007156
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007156" ON "TEDAVI_AYAKTA" ("MUAYENEID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007107
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007107" ON "HASTALAR" ("HASTA_TC") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007146
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007146" ON "MUAYENELER" ("MUAYENEID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007133
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007133" ON "PERSONELLER" ("PERSONELID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007134
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007134" ON "PERSONELLER" ("PERSONEL_TC") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007122
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007122" ON "POLIKLINIKLER" ("POLIKLINIKID") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_RADYOLOJI_TARIH
--------------------------------------------------------

  CREATE INDEX "IDX_RADYOLOJI_TARIH" ON "RADYOLOJIK_GORUNTULER" ("TARIH") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007138
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007138" ON "SISTEME_GIRIS_BILGILERI" ("SIFRE") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_TAHLILLER_TC_TARIH
--------------------------------------------------------

  CREATE INDEX "IDX_TAHLILLER_TC_TARIH" ON "TAHLILLER" ("TC", "TARIH") 
  ;
--------------------------------------------------------
--  DDL for Index IDX_TAHLILTARIH
--------------------------------------------------------

  CREATE INDEX "IDX_TAHLILTARIH" ON "TAHLILLER" ("TARIH") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007110
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007110" ON "TAHLIL_ARALIKLERI" ("SONUC_TIPI") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007142
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007142" ON "TAHLIL_LOG" ("LOGID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007156
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007156" ON "TEDAVI_AYAKTA" ("MUAYENEID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007152
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007152" ON "TEDAVI_YATARAK" ("MUAYENEID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007144
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007144" ON "TESHIS_TURLERI" ("TESHIS_KODU") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007124
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007124" ON "UNVANLAR" ("UNVANID") 
  ;
--------------------------------------------------------
--  DDL for Trigger TRG_GIRISLOG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_GIRISLOG" 
AFTER INSERT ON Sisteme_Giris_Bilgileri
FOR EACH ROW
BEGIN
    INSERT INTO Sisteme_Giris_Zamani (Personel, Giris_Zamani)
    VALUES (:NEW.Personel, SYSDATE);
END;

/
ALTER TRIGGER "TRG_GIRISLOG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_HASTAEMAILKONTROL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_HASTAEMAILKONTROL" 
BEFORE INSERT OR UPDATE ON Hastalar
FOR EACH ROW
BEGIN
    IF :NEW.Hasta_Email IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Hasta Email bo? b?rak?lamaz.');
    ELSIF INSTR(:NEW.Hasta_Email, '@') = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Geçersiz Email format?. @ i?areti içermelidir.');
    END IF;
END;

/
ALTER TRIGGER "TRG_HASTAEMAILKONTROL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_MUAYENEID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_MUAYENEID" 
BEFORE INSERT ON Muayeneler
FOR EACH ROW
BEGIN
    :NEW.MuayeneID := SEQ_MuayeneID.NEXTVAL;
END;
/
ALTER TRIGGER "TRG_MUAYENEID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_PERSONELID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_PERSONELID" 
BEFORE INSERT ON Personeller
FOR EACH ROW
BEGIN
    :NEW.PersonelID := SEQ_PersonelID.NEXTVAL;
END;
/
ALTER TRIGGER "TRG_PERSONELID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_POLIKLINIKID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_POLIKLINIKID" 
BEFORE INSERT ON Poliklinikler
FOR EACH ROW
BEGIN
    :NEW.PoliklinikID := SEQ_PoliklinikID.NEXTVAL;
END;
/
ALTER TRIGGER "TRG_POLIKLINIKID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TAHLILLOG_ID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TAHLILLOG_ID" 
BEFORE INSERT ON Tahlil_Log
FOR EACH ROW
BEGIN
    IF :NEW.LogID IS NULL THEN
        :NEW.LogID := SEQ_TahlilLog.NEXTVAL;
    END IF;
END;
/
ALTER TRIGGER "TRG_TAHLILLOG_ID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TEDAVI_SURESI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TEDAVI_SURESI" 
BEFORE INSERT OR UPDATE ON Tedavi_Yatarak
FOR EACH ROW
BEGIN
    IF :NEW.Cikis_Tarihi IS NOT NULL THEN
        :NEW.Tedavi_Suresi := :NEW.Cikis_Tarihi - :NEW.Yatis_Tarihi;
    ELSE
        :NEW.Tedavi_Suresi := NULL;
    END IF;
END;
/
ALTER TRIGGER "TRG_TEDAVI_SURESI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_UNVANID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_UNVANID" 
BEFORE INSERT ON Unvanlar
FOR EACH ROW
BEGIN
    :NEW.UnvanID := SEQ_UnvanID.NEXTVAL;
END;
/
ALTER TRIGGER "TRG_UNVANID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_HASTAEMAILKONTROL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_HASTAEMAILKONTROL" 
BEFORE INSERT OR UPDATE ON Hastalar
FOR EACH ROW
BEGIN
    IF :NEW.Hasta_Email IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Hasta Email bo? b?rak?lamaz.');
    ELSIF INSTR(:NEW.Hasta_Email, '@') = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Geçersiz Email format?. @ i?areti içermelidir.');
    END IF;
END;

/
ALTER TRIGGER "TRG_HASTAEMAILKONTROL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_MUAYENEID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_MUAYENEID" 
BEFORE INSERT ON Muayeneler
FOR EACH ROW
BEGIN
    :NEW.MuayeneID := SEQ_MuayeneID.NEXTVAL;
END;
/
ALTER TRIGGER "TRG_MUAYENEID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_PERSONELID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_PERSONELID" 
BEFORE INSERT ON Personeller
FOR EACH ROW
BEGIN
    :NEW.PersonelID := SEQ_PersonelID.NEXTVAL;
END;
/
ALTER TRIGGER "TRG_PERSONELID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_POLIKLINIKID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_POLIKLINIKID" 
BEFORE INSERT ON Poliklinikler
FOR EACH ROW
BEGIN
    :NEW.PoliklinikID := SEQ_PoliklinikID.NEXTVAL;
END;
/
ALTER TRIGGER "TRG_POLIKLINIKID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_GIRISLOG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_GIRISLOG" 
AFTER INSERT ON Sisteme_Giris_Bilgileri
FOR EACH ROW
BEGIN
    INSERT INTO Sisteme_Giris_Zamani (Personel, Giris_Zamani)
    VALUES (:NEW.Personel, SYSDATE);
END;

/
ALTER TRIGGER "TRG_GIRISLOG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TAHLILLOG_ID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TAHLILLOG_ID" 
BEFORE INSERT ON Tahlil_Log
FOR EACH ROW
BEGIN
    IF :NEW.LogID IS NULL THEN
        :NEW.LogID := SEQ_TahlilLog.NEXTVAL;
    END IF;
END;
/
ALTER TRIGGER "TRG_TAHLILLOG_ID" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_TEDAVI_SURESI
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_TEDAVI_SURESI" 
BEFORE INSERT OR UPDATE ON Tedavi_Yatarak
FOR EACH ROW
BEGIN
    IF :NEW.Cikis_Tarihi IS NOT NULL THEN
        :NEW.Tedavi_Suresi := :NEW.Cikis_Tarihi - :NEW.Yatis_Tarihi;
    ELSE
        :NEW.Tedavi_Suresi := NULL;
    END IF;
END;
/
ALTER TRIGGER "TRG_TEDAVI_SURESI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_UNVANID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_UNVANID" 
BEFORE INSERT ON Unvanlar
FOR EACH ROW
BEGIN
    :NEW.UnvanID := SEQ_UnvanID.NEXTVAL;
END;
/
ALTER TRIGGER "TRG_UNVANID" ENABLE;
--------------------------------------------------------
--  DDL for Procedure HASTA_EKLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HASTA_EKLE" (
    p_tc        IN NUMBER,
    p_ad        IN VARCHAR2,
    p_soyad     IN VARCHAR2,
    p_email     IN VARCHAR2,
    p_tel       IN NUMBER,
    p_dogum     IN DATE,
    p_kan_grubu IN VARCHAR2
)
IS
BEGIN
    INSERT INTO Hastalar (
        Hasta_tc, Hasta_Ad, Hasta_Soyad, Hasta_Email, Hasta_Tel, Hasta_Dogum_Tarihi, Kan_Grubu
    ) VALUES (
        p_tc, p_ad, p_soyad, p_email, p_tel, p_dogum, p_kan_grubu
    );

    DBMS_OUTPUT.PUT_LINE('Hasta ba?ar?yla eklendi.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('HATA: ' || SQLERRM);
END;

/
--------------------------------------------------------
--  DDL for Procedure PERSONEL_EKLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PERSONEL_EKLE" (
    p_tc         IN NUMBER,
    p_ad         IN VARCHAR2,
    p_soyad      IN VARCHAR2,
    p_email      IN VARCHAR2,
    p_tel        IN NUMBER,
    p_unvan_id   IN NUMBER,
    p_poliklinik IN NUMBER
)
IS
BEGIN
    INSERT INTO Personeller (
        Personel_tc, Personel_Ad, Personel_Soyad, Personel_Email, Personel_Tel, Unvan, Poliklinik
    ) VALUES (
        p_tc, p_ad, p_soyad, p_email, p_tel, p_unvan_id, p_poliklinik
    );

    DBMS_OUTPUT.PUT_LINE('Personel ba?ar?yla eklendi.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('HATA: ' || SQLERRM);
END;

/
--------------------------------------------------------
--  DDL for Function FN_PERSONEL_SAYISI_POLIKLINIK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "FN_PERSONEL_SAYISI_POLIKLINIK" (p_id IN NUMBER)
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
--------------------------------------------------------
--  DDL for Function FN_TAHLIL_SAYISI
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "FN_TAHLIL_SAYISI" (tc_no IN NUMBER)
RETURN NUMBER
IS
    sayi NUMBER;
BEGIN
    SELECT COUNT(*) INTO sayi
    FROM Tahliller
    WHERE tc = tc_no;

    RETURN sayi;
END;

/
--------------------------------------------------------
--  Constraints for Table HASTALAR
--------------------------------------------------------

  ALTER TABLE "HASTALAR" ADD PRIMARY KEY ("HASTA_TC") ENABLE;
  ALTER TABLE "HASTALAR" ADD CONSTRAINT "CHK_KAN_GRUBU" CHECK (Kan_Grubu IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-')) ENABLE;
  ALTER TABLE "HASTALAR" ADD CONSTRAINT "CHK_TEL" CHECK (Hasta_Tel BETWEEN 5000000000 AND 6000000000) ENABLE;
  ALTER TABLE "HASTALAR" ADD CONSTRAINT "CHK_TC" CHECK (Hasta_tc BETWEEN 10000000000 AND 99999999999) ENABLE;
  ALTER TABLE "HASTALAR" MODIFY ("KAN_GRUBU" NOT NULL ENABLE);
  ALTER TABLE "HASTALAR" MODIFY ("HASTA_TEL" NOT NULL ENABLE);
  ALTER TABLE "HASTALAR" MODIFY ("HASTA_SOYAD" NOT NULL ENABLE);
  ALTER TABLE "HASTALAR" MODIFY ("HASTA_AD" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table MUAYENELER
--------------------------------------------------------

  ALTER TABLE "MUAYENELER" ADD PRIMARY KEY ("MUAYENEID") ENABLE;
  ALTER TABLE "MUAYENELER" MODIFY ("HASTA_TC" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PERSONELLER
--------------------------------------------------------

  ALTER TABLE "PERSONELLER" ADD UNIQUE ("PERSONEL_TC") ENABLE;
  ALTER TABLE "PERSONELLER" ADD PRIMARY KEY ("PERSONELID") ENABLE;
  ALTER TABLE "PERSONELLER" ADD CONSTRAINT "CHK_PERSONEL_TEL" CHECK (Personel_Tel BETWEEN 5000000000 AND 6000000000) ENABLE;
  ALTER TABLE "PERSONELLER" ADD CONSTRAINT "CHK_PERSONEL_TC" CHECK (Personel_tc BETWEEN 10000000000 AND 99999999999) ENABLE;
  ALTER TABLE "PERSONELLER" MODIFY ("POLIKLINIK" NOT NULL ENABLE);
  ALTER TABLE "PERSONELLER" MODIFY ("UNVAN" NOT NULL ENABLE);
  ALTER TABLE "PERSONELLER" MODIFY ("PERSONEL_TEL" NOT NULL ENABLE);
  ALTER TABLE "PERSONELLER" MODIFY ("PERSONEL_SOYAD" NOT NULL ENABLE);
  ALTER TABLE "PERSONELLER" MODIFY ("PERSONEL_AD" NOT NULL ENABLE);
  ALTER TABLE "PERSONELLER" MODIFY ("PERSONEL_TC" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table POLIKLINIKLER
--------------------------------------------------------

  ALTER TABLE "POLIKLINIKLER" ADD PRIMARY KEY ("POLIKLINIKID") ENABLE;
  ALTER TABLE "POLIKLINIKLER" MODIFY ("POLIKLINIK_ADI" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table RADYOLOJIK_GORUNTULER
--------------------------------------------------------

  ALTER TABLE "RADYOLOJIK_GORUNTULER" ADD CONSTRAINT "CHK_SONUC_TIPI_RADYO" CHECK (
        Sonuc_Tipi IN ('MR', 'RÖNTGEN')
    ) ENABLE;
  ALTER TABLE "RADYOLOJIK_GORUNTULER" MODIFY ("TARIH" NOT NULL ENABLE);
  ALTER TABLE "RADYOLOJIK_GORUNTULER" MODIFY ("SONUC_TIPI" NOT NULL ENABLE);
  ALTER TABLE "RADYOLOJIK_GORUNTULER" MODIFY ("TC" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table SISTEME_GIRIS_BILGILERI
--------------------------------------------------------

  ALTER TABLE "SISTEME_GIRIS_BILGILERI" ADD UNIQUE ("SIFRE") ENABLE;
  ALTER TABLE "SISTEME_GIRIS_BILGILERI" MODIFY ("PERSONEL" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table SISTEME_GIRIS_ZAMANI
--------------------------------------------------------

  ALTER TABLE "SISTEME_GIRIS_ZAMANI" MODIFY ("PERSONEL" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TAHLILLER
--------------------------------------------------------

  ALTER TABLE "TAHLILLER" MODIFY ("TARIH" NOT NULL ENABLE);
  ALTER TABLE "TAHLILLER" MODIFY ("SONUC_TIPI" NOT NULL ENABLE);
  ALTER TABLE "TAHLILLER" MODIFY ("TC" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TAHLIL_ARALIKLERI
--------------------------------------------------------

  ALTER TABLE "TAHLIL_ARALIKLERI" ADD PRIMARY KEY ("SONUC_TIPI") ENABLE;
  ALTER TABLE "TAHLIL_ARALIKLERI" MODIFY ("SONUC_MIN" NOT NULL ENABLE);
  ALTER TABLE "TAHLIL_ARALIKLERI" MODIFY ("SONUC_MAX" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TAHLIL_LOG
--------------------------------------------------------

  ALTER TABLE "TAHLIL_LOG" ADD PRIMARY KEY ("LOGID") ENABLE;
--------------------------------------------------------
--  Constraints for Table TEDAVI_AYAKTA
--------------------------------------------------------

  ALTER TABLE "TEDAVI_AYAKTA" ADD PRIMARY KEY ("MUAYENEID") ENABLE;
--------------------------------------------------------
--  Constraints for Table TEDAVI_YATARAK
--------------------------------------------------------

  ALTER TABLE "TEDAVI_YATARAK" ADD PRIMARY KEY ("MUAYENEID") ENABLE;
  ALTER TABLE "TEDAVI_YATARAK" MODIFY ("TEDAVI_EDEN_DOKTORID" NOT NULL ENABLE);
  ALTER TABLE "TEDAVI_YATARAK" MODIFY ("YATIS_TARIHI" NOT NULL ENABLE);
  ALTER TABLE "TEDAVI_YATARAK" MODIFY ("ODA_NO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TESHIS_TURLERI
--------------------------------------------------------

  ALTER TABLE "TESHIS_TURLERI" ADD PRIMARY KEY ("TESHIS_KODU") ENABLE;
  ALTER TABLE "TESHIS_TURLERI" MODIFY ("TESHIS_ACIKLAMASI" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table UNVANLAR
--------------------------------------------------------

  ALTER TABLE "UNVANLAR" ADD PRIMARY KEY ("UNVANID") ENABLE;
  ALTER TABLE "UNVANLAR" MODIFY ("UNVAN_ADI" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table MUAYENELER
--------------------------------------------------------

  ALTER TABLE "MUAYENELER" ADD CONSTRAINT "FK_MUAYENE_HASTA" FOREIGN KEY ("HASTA_TC")
	  REFERENCES "HASTALAR" ("HASTA_TC") ENABLE;
  ALTER TABLE "MUAYENELER" ADD CONSTRAINT "FK_MUAYENE_PERSONEL" FOREIGN KEY ("PERSONELID")
	  REFERENCES "PERSONELLER" ("PERSONELID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PERSONELLER
--------------------------------------------------------

  ALTER TABLE "PERSONELLER" ADD CONSTRAINT "FK_POLIKLINIK" FOREIGN KEY ("POLIKLINIK")
	  REFERENCES "POLIKLINIKLER" ("POLIKLINIKID") ENABLE;
  ALTER TABLE "PERSONELLER" ADD CONSTRAINT "FK_UNVAN" FOREIGN KEY ("UNVAN")
	  REFERENCES "UNVANLAR" ("UNVANID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table RADYOLOJIK_GORUNTULER
--------------------------------------------------------

  ALTER TABLE "RADYOLOJIK_GORUNTULER" ADD CONSTRAINT "FK_TC2" FOREIGN KEY ("TC")
	  REFERENCES "HASTALAR" ("HASTA_TC") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SISTEME_GIRIS_BILGILERI
--------------------------------------------------------

  ALTER TABLE "SISTEME_GIRIS_BILGILERI" ADD CONSTRAINT "FK_PERSONEL" FOREIGN KEY ("PERSONEL")
	  REFERENCES "PERSONELLER" ("PERSONELID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SISTEME_GIRIS_ZAMANI
--------------------------------------------------------

  ALTER TABLE "SISTEME_GIRIS_ZAMANI" ADD CONSTRAINT "FK_GIRIS" FOREIGN KEY ("PERSONEL")
	  REFERENCES "PERSONELLER" ("PERSONELID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TAHLILLER
--------------------------------------------------------

  ALTER TABLE "TAHLILLER" ADD CONSTRAINT "FK_SONUC_TIPI" FOREIGN KEY ("SONUC_TIPI")
	  REFERENCES "TAHLIL_ARALIKLERI" ("SONUC_TIPI") ENABLE;
  ALTER TABLE "TAHLILLER" ADD CONSTRAINT "FK_TC" FOREIGN KEY ("TC")
	  REFERENCES "HASTALAR" ("HASTA_TC") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TEDAVI_AYAKTA
--------------------------------------------------------

  ALTER TABLE "TEDAVI_AYAKTA" ADD CONSTRAINT "FK_TEDAVI_AYAKTA_MUAYENE" FOREIGN KEY ("MUAYENEID")
	  REFERENCES "MUAYENELER" ("MUAYENEID") ENABLE;
  ALTER TABLE "TEDAVI_AYAKTA" ADD CONSTRAINT "FK_TESHIS_KODU_AYAKTA" FOREIGN KEY ("TESHIS_KODU")
	  REFERENCES "TESHIS_TURLERI" ("TESHIS_KODU") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TEDAVI_YATARAK
--------------------------------------------------------

  ALTER TABLE "TEDAVI_YATARAK" ADD CONSTRAINT "FK_TEDAVI_DOKTOR" FOREIGN KEY ("TEDAVI_EDEN_DOKTORID")
	  REFERENCES "PERSONELLER" ("PERSONELID") ENABLE;
  ALTER TABLE "TEDAVI_YATARAK" ADD CONSTRAINT "FK_TEDAVI_YATARAK_MUAYENE" FOREIGN KEY ("MUAYENEID")
	  REFERENCES "MUAYENELER" ("MUAYENEID") ENABLE;
  ALTER TABLE "TEDAVI_YATARAK" ADD CONSTRAINT "FK_TESHIS_KODU" FOREIGN KEY ("TESHIS_KODU")
	  REFERENCES "TESHIS_TURLERI" ("TESHIS_KODU") ENABLE;
