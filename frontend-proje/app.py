from flask import Flask, render_template, request, redirect, url_for, flash, jsonify, session
import cx_Oracle
import os
from datetime import datetime
import json
import secrets
from dotenv import load_dotenv

# .env dosyasını yükle
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('FLASK_SECRET_KEY', 'hastane_yonetim_sistemi_2024')

# CSRF token context processor eklendi
@app.context_processor
def inject_csrf_token():
    """Template'lerde csrf_token() fonksiyonu kullanabilmek için"""
    def csrf_token():
        if 'csrf_token' not in session:
            session['csrf_token'] = secrets.token_urlsafe(32)
        return session['csrf_token']
    return dict(csrf_token=csrf_token)

def validate_csrf_token():
    """CSRF token validation - İsteğe bağlı güvenlik"""
    if request.method == 'POST':
        token = session.get('csrf_token')
        form_token = request.form.get('csrf_token')
        if not token or token != form_token:
            flash('Güvenlik hatası: Form tekrar yüklenecek.', 'error')
            return False
    return True

# Oracle Database Connection
class DatabaseConnection:
    def __init__(self):
        # Docker ortamında host ismi değişebilir
        host = os.getenv('ORACLE_HOST', 'localhost')
        port = int(os.getenv('ORACLE_PORT', 1521))
        service = os.getenv('ORACLE_SERVICE', 'XE')
        
        self.dsn = cx_Oracle.makedsn(host, port, service_name=service)
        self.username = os.getenv('ORACLE_USER', 'hospital')
        self.password = os.getenv('ORACLE_PASSWORD', 'hospital123')
    
    def get_connection(self):
        try:
            connection = cx_Oracle.connect(
                user=self.username,
                password=self.password,
                dsn=self.dsn
            )
            return connection
        except cx_Oracle.DatabaseError as e:
            print(f"Veritabanı bağlantı hatası: {e}")
            return None

db = DatabaseConnection()

@app.route('/')
def index():
    """Ana sayfa - Genel istatistikler"""
    connection = db.get_connection()
    if not connection:
        flash('Veritabanı bağlantısı kurulamadı!', 'error')
        return render_template('error.html')
    
    try:
        cursor = connection.cursor()
        
        # Genel istatistikler
        stats = {}
        
        # Toplam hasta sayısı
        cursor.execute("SELECT COUNT(*) FROM Hastalar")
        stats['total_patients'] = cursor.fetchone()[0] or 0
        
        # Toplam personel sayısı
        cursor.execute("SELECT COUNT(*) FROM Personeller")
        stats['total_staff'] = cursor.fetchone()[0] or 0
        
        # Bu ay yapılan muayene sayısı
        cursor.execute("""
            SELECT COUNT(*) FROM Muayeneler 
            WHERE EXTRACT(MONTH FROM Muayene_Tarihi) = EXTRACT(MONTH FROM SYSDATE)
            AND EXTRACT(YEAR FROM Muayene_Tarihi) = EXTRACT(YEAR FROM SYSDATE)
        """)
        stats['monthly_exams'] = cursor.fetchone()[0] or 0
        
        # Aktif yatan hasta sayısı
        cursor.execute("""
            SELECT COUNT(*) FROM Tedavi_Yatarak 
            WHERE Cikis_Tarihi IS NULL
        """)
        stats['hospitalized_patients'] = cursor.fetchone()[0] or 0
        
        # Bu ay eklenen hasta sayısı
        cursor.execute("""
            SELECT COUNT(*) FROM Hastalar 
            WHERE EXTRACT(MONTH FROM Hasta_Dogum_Tarihi) = EXTRACT(MONTH FROM SYSDATE)
        """)
        stats['monthly_new_patients'] = cursor.fetchone()[0] or 0
        
        # Toplam tahlil sayısı
        cursor.execute("SELECT COUNT(*) FROM Tahliller")
        stats['total_tests'] = cursor.fetchone()[0] or 0
        
        # Poliklinik bazında personel sayıları (fonksiyon kullanarak) - VERİ TİPİ DÜZELTİLDİ
        cursor.execute("""
            SELECT p.Poliklinik_adi, FN_Personel_Sayisi_Poliklinik(p.PoliklinikID) as personel_sayisi
            FROM Poliklinikler p
            ORDER BY personel_sayisi DESC
        """)
        clinic_data = cursor.fetchall()
        
        # Veri tiplerini düzelt ve formatla
        clinic_stats = []
        for row in clinic_data:
            clinic_name = row[0]
            personel_sayisi = int(row[1]) if row[1] is not None else 0
            clinic_stats.append([clinic_name, personel_sayisi])
        
        # Son tahliller - FORMATLANDI
        cursor.execute("""
            SELECT h.Hasta_Ad, h.Hasta_Soyad, t.Sonuc_Tipi, t.Sonuc, t.Tarih
            FROM Tahliller t
            JOIN Hastalar h ON t.tc = h.Hasta_tc
            ORDER BY t.Tarih DESC
            FETCH FIRST 5 ROWS ONLY
        """)
        recent_tests_data = cursor.fetchall()
        
        # Recent tests formatla
        recent_tests = []
        for row in recent_tests_data:
            recent_tests.append({
                'hasta_ad': row[0],
                'hasta_soyad': row[1],
                'sonuc_tipi': row[2],
                'sonuc': row[3],
                'tarih': row[4].strftime('%d.%m.%Y') if row[4] else ''
            })
        
        cursor.close()
        connection.close()
        
        return render_template('index.html', 
                             stats=stats, 
                             clinic_stats=clinic_stats,
                             recent_tests=recent_tests)
        
    except cx_Oracle.DatabaseError as e:
        flash(f'Veritabanı hatası: {e}', 'error')
        return render_template('error.html')
    except Exception as e:
        flash(f'Beklenmeyen hata: {e}', 'error')
        return render_template('error.html')

@app.route('/patients')
def patients():
    """Hasta listesi - View kullanarak"""
    connection = db.get_connection()
    if not connection:
        flash('Veritabanı bağlantısı kurulamadı!', 'error')
        return render_template('error.html')
    
    try:
        cursor = connection.cursor()
        cursor.execute("""
            SELECT Hasta_tc, Hasta_Ad, Hasta_Soyad, Hasta_Email, 
                   Hasta_Tel, Hasta_Dogum_Tarihi, Kan_Grubu,
                   FN_Tahlil_Sayisi(Hasta_tc) as tahlil_sayisi
            FROM Hastalar
            ORDER BY Hasta_Ad, Hasta_Soyad
        """)
        
        patients_list = []
        for row in cursor:
            patients_list.append({
                'tc': row[0],
                'ad': row[1],
                'soyad': row[2],
                'email': row[3],
                'tel': row[4],
                'dogum_tarihi': row[5].strftime('%d.%m.%Y') if row[5] else '',
                'kan_grubu': row[6],
                'tahlil_sayisi': int(row[7]) if row[7] is not None else 0
            })
        
        cursor.close()
        connection.close()
        
        return render_template('patients.html', patients=patients_list)
        
    except cx_Oracle.DatabaseError as e:
        flash(f'Veritabanı hatası: {e}', 'error')
        return render_template('error.html')
    except Exception as e:
        flash(f'Beklenmeyen hata: {e}', 'error')
        return render_template('error.html')

@app.route('/patient/<tc>')
def patient_detail(tc):
    """Hasta detay sayfası - NORMAL ARALIK KONTROLÜ EKLENDİ"""
    connection = db.get_connection()
    if not connection:
        flash('Veritabanı bağlantısı kurulamadı!', 'error')
        return render_template('error.html')
    
    try:
        cursor = connection.cursor()
        
        # Hasta bilgileri
        cursor.execute("""
            SELECT Hasta_tc, Hasta_Ad, Hasta_Soyad, Hasta_Email, 
                   Hasta_Tel, Hasta_Dogum_Tarihi, Kan_Grubu
            FROM Hastalar WHERE Hasta_tc = :tc
        """, tc=tc)
        
        patient_data = cursor.fetchone()
        if not patient_data:
            flash('Hasta bulunamadı!', 'error')
            return redirect(url_for('patients'))
        
        patient = {
            'tc': patient_data[0],
            'ad': patient_data[1],
            'soyad': patient_data[2],
            'email': patient_data[3],
            'tel': patient_data[4],
            'dogum_tarihi': patient_data[5].strftime('%d.%m.%Y') if patient_data[5] else '',
            'kan_grubu': patient_data[6]
        }
        
        # Tahlil sonuçları ve normal aralık kontrolü - DÜZELTİLDİ
        cursor.execute("""
            SELECT t.Sonuc_Tipi, t.Sonuc, t.Tarih, ta.Sonuc_Min, ta.Sonuc_Max
            FROM Tahliller t
            LEFT JOIN Tahlil_Araliklari ta ON t.Sonuc_Tipi = ta.Sonuc_Tipi
            WHERE t.tc = :tc
            ORDER BY t.Tarih DESC
        """, tc=tc)
        
        tests = []
        for row in cursor:
            sonuc_tipi = row[0]
            sonuc = float(row[1]) if row[1] is not None else None
            tarih = row[2].strftime('%d.%m.%Y') if row[2] else ''
            min_val = float(row[3]) if row[3] is not None else None
            max_val = float(row[4]) if row[4] is not None else None
            
            # Normal aralık kontrolü
            normal = None
            if sonuc is not None and min_val is not None and max_val is not None:
                normal = min_val <= sonuc <= max_val
            
            tests.append({
                'tip': sonuc_tipi,
                'sonuc': sonuc,
                'tarih': tarih,
                'min': min_val,
                'max': max_val,
                'normal': normal
            })
        
        # Muayene geçmişi - NULL CHECK EKLENDİ
        cursor.execute("""
            SELECT m.MuayeneID, m.Muayene_Tarihi, m.Notlar,
                   p.Personel_Ad, p.Personel_Soyad, pol.Poliklinik_adi
            FROM Muayeneler m
            LEFT JOIN Personeller p ON m.PersonelID = p.PersonelID
            LEFT JOIN Poliklinikler pol ON p.Poliklinik = pol.PoliklinikID
            WHERE m.Hasta_tc = :tc
            ORDER BY m.Muayene_Tarihi DESC
        """, tc=tc)
        
        examinations = []
        for row in cursor:
            examinations.append({
                'id': row[0],
                'tarih': row[1].strftime('%d.%m.%Y') if row[1] else '',
                'notlar': row[2] if row[2] else 'Not eklenmemiş',
                'doktor': f"{row[3]} {row[4]}" if row[3] and row[4] else 'Bilinmiyor',
                'poliklinik': row[5] if row[5] else 'Belirtilmemiş'
            })
        
        cursor.close()
        connection.close()
        
        return render_template('patient_detail.html', 
                             patient=patient, 
                             tests=tests, 
                             examinations=examinations)
        
    except cx_Oracle.DatabaseError as e:
        flash(f'Veritabanı hatası: {e}', 'error')
        return render_template('error.html')
    except Exception as e:
        flash(f'Beklenmeyen hata: {e}', 'error')
        return render_template('error.html')

@app.route('/staff')
def staff():
    """Personel listesi - View kullanarak"""
    connection = db.get_connection()
    if not connection:
        flash('Veritabanı bağlantısı kurulamadı!', 'error')
        return render_template('error.html')
    
    try:
        cursor = connection.cursor()
        # View kullanarak personel listesi
        cursor.execute("SELECT * FROM vw_Personel_Gorunumu ORDER BY Personel_Ad, Personel_Soyad")
        
        staff_list = []
        for row in cursor:
            staff_list.append({
                'id': row[0],
                'tc': row[1],
                'ad': row[2],
                'soyad': row[3],
                'email': row[4],
                'tel': row[5],
                'unvan': row[6],
                'poliklinik': row[7]
            })
        
        cursor.close()
        connection.close()
        
        return render_template('staff.html', staff=staff_list)
        
    except cx_Oracle.DatabaseError as e:
        flash(f'Veritabanı hatası: {e}', 'error')
        return render_template('error.html')
    except Exception as e:
        flash(f'Beklenmeyen hata: {e}', 'error')
        return render_template('error.html')

@app.route('/tests')
def tests():
    """Tahlil sonuçları sayfası - VERİ TİPİ SORUNU DÜZELTİLDİ"""
    connection = db.get_connection()
    if not connection:
        flash('Veritabanı bağlantısı kurulamadı!', 'error')
        return render_template('error.html')
    
    try:
        cursor = connection.cursor()
        cursor.execute("""
            SELECT t.tc, h.Hasta_Ad, h.Hasta_Soyad, t.Sonuc_Tipi, 
                   t.Sonuc, t.Tarih, ta.Sonuc_Min, ta.Sonuc_Max
            FROM Tahliller t
            JOIN Hastalar h ON t.tc = h.Hasta_tc
            LEFT JOIN Tahlil_Araliklari ta ON t.Sonuc_Tipi = ta.Sonuc_Tipi
            ORDER BY t.Tarih DESC
        """)
        
        test_results = []
        for row in cursor:
            tc = row[0]
            hasta_ad = row[1]
            hasta_soyad = row[2]
            tip = row[3]
            sonuc = float(row[4]) if row[4] is not None else None
            tarih = row[5].strftime('%d.%m.%Y') if row[5] else ''
            min_val = float(row[6]) if row[6] is not None else None
            max_val = float(row[7]) if row[7] is not None else None
            
            # Normal aralık kontrolü - GÜVENLİ HALE GETİRİLDİ
            normal = None
            if sonuc is not None and min_val is not None and max_val is not None:
                normal = min_val <= sonuc <= max_val
            
            test_results.append({
                'tc': tc,
                'hasta_ad': hasta_ad,
                'hasta_soyad': hasta_soyad,
                'tip': tip,
                'sonuc': sonuc,
                'tarih': tarih,
                'min': min_val,
                'max': max_val,
                'normal': normal
            })
        
        cursor.close()
        connection.close()
        
        return render_template('tests.html', tests=test_results)
        
    except cx_Oracle.DatabaseError as e:
        flash(f'Veritabanı hatası: {e}', 'error')
        return render_template('error.html')
    except Exception as e:
        flash(f'Beklenmeyen hata: {e}', 'error')
        return render_template('error.html')

@app.route('/api/clinic_staff/<int:clinic_id>')
def api_clinic_staff(clinic_id):
    """Poliklinik personel sayısı API endpoint"""
    connection = db.get_connection()
    if not connection:
        return jsonify({'error': 'Veritabanı bağlantısı kurulamadı'}), 500
    
    try:
        cursor = connection.cursor()
        cursor.execute("SELECT FN_Personel_Sayisi_Poliklinik(:clinic_id) FROM DUAL", 
                      clinic_id=clinic_id)
        
        result = cursor.fetchone()
        staff_count = int(result[0]) if result and result[0] is not None else 0
        
        cursor.close()
        connection.close()
        
        return jsonify({'clinic_id': clinic_id, 'staff_count': staff_count})
        
    except cx_Oracle.DatabaseError as e:
        return jsonify({'error': str(e)}), 500
    except Exception as e:
        return jsonify({'error': f'Beklenmeyen hata: {str(e)}'}), 500

@app.route('/add_patient', methods=['GET', 'POST'])
def add_patient():
    """Yeni hasta ekleme - Procedure kullanarak - HATA YÖNETİMİ GÜÇLENDİRİLDİ"""
    if request.method == 'POST':
        # CSRF token kontrolü (opsiyonel güvenlik)
        if not validate_csrf_token():
            return render_template('add_patient.html')
        
        connection = db.get_connection()
        if not connection:
            flash('Veritabanı bağlantısı kurulamadı!', 'error')
            return render_template('add_patient.html')
        
        try:
            cursor = connection.cursor()
            
            tc = request.form.get('tc', '').strip()
            ad = request.form.get('ad', '').strip()
            soyad = request.form.get('soyad', '').strip()
            email = request.form.get('email', '').strip()
            tel = request.form.get('tel', '').strip()
            dogum_tarihi = request.form.get('dogum_tarihi', '').strip()
            kan_grubu = request.form.get('kan_grubu', '').strip()
            
            # Zorunlu alanları kontrol et
            if not all([tc, ad, soyad, tel, kan_grubu]):
                flash('Tüm zorunlu alanları doldurunuz!', 'error')
                return render_template('add_patient.html')
            
            # Procedure kullanarak hasta ekleme
            cursor.callproc('Hasta_Ekle', [
                int(tc), ad, soyad, email if email else None, int(tel), 
                datetime.strptime(dogum_tarihi, '%Y-%m-%d').date() if dogum_tarihi else None,
                kan_grubu
            ])
            
            connection.commit()
            cursor.close()
            connection.close()
            
            flash('Hasta başarıyla eklendi!', 'success')
            return redirect(url_for('patients'))
            
        except ValueError as e:
            flash(f'Geçersiz veri formatı: {e}', 'error')
            return render_template('add_patient.html')
        except cx_Oracle.DatabaseError as e:
            flash(f'Veritabanı hatası: {e}', 'error')
            return render_template('add_patient.html')
        except Exception as e:
            flash(f'Beklenmeyen hata: {e}', 'error')
            return render_template('add_patient.html')
    
    return render_template('add_patient.html')

@app.route('/add_staff', methods=['GET', 'POST'])
def add_staff():
    """Yeni personel ekleme - BASİTLEŞTİRİLMİŞ"""
    connection = db.get_connection()
    if not connection:
        flash('Veritabanı bağlantısı kurulamadı!', 'error')
        return render_template('error.html', error_message="Veritabanı bağlantı hatası")
    
    try:
        cursor = connection.cursor()
        
        # Unvanları ve poliklinikleri getir - DISTINCT kullanarak duplikasyonu önle
        cursor.execute("SELECT DISTINCT UnvanID, Unvan_adi FROM Unvanlar ORDER BY Unvan_adi")
        unvanlar = cursor.fetchall()
        
        cursor.execute("SELECT DISTINCT PoliklinikID, Poliklinik_adi FROM Poliklinikler ORDER BY Poliklinik_adi")
        poliklinikler = cursor.fetchall()
        
        print(f"Debug - Unvanlar: {unvanlar}")
        print(f"Debug - Poliklinikler: {poliklinikler}")
        
        # GET isteği - formu göster
        if request.method == 'GET':
            cursor.close()
            connection.close()
            return render_template('add_staff.html', unvanlar=unvanlar, poliklinikler=poliklinikler)
        
        # POST isteği - form verilerini işle
        if request.method == 'POST':
            print("POST isteği alındı!")
            print(f"Form verileri: {dict(request.form)}")
            
            try:
                # Form verilerini al ve temizle
                tc = request.form.get('tc', '').strip()
                ad = request.form.get('ad', '').strip()
                soyad = request.form.get('soyad', '').strip()
                email = request.form.get('email', '').strip()
                tel = request.form.get('tel', '').strip()
                unvan_id = request.form.get('unvan_id', '').strip()
                poliklinik_id = request.form.get('poliklinik_id', '').strip()
                
                print(f"İşlenen veriler - TC: {tc}, Ad: {ad}, Soyad: {soyad}, Email: {email}, Tel: {tel}, Unvan: {unvan_id}, Poliklinik: {poliklinik_id}")
                
                # Zorunlu alanları kontrol et
                if not all([tc, ad, soyad, email, tel, unvan_id, poliklinik_id]):
                    missing_fields = []
                    if not tc: missing_fields.append('TC')
                    if not ad: missing_fields.append('Ad')
                    if not soyad: missing_fields.append('Soyad')
                    if not email: missing_fields.append('E-posta')
                    if not tel: missing_fields.append('Telefon')
                    if not unvan_id: missing_fields.append('Unvan')
                    if not poliklinik_id: missing_fields.append('Poliklinik')
                    
                    flash(f'Şu alanlar eksik: {", ".join(missing_fields)}', 'error')
                    cursor.close()
                    connection.close()
                    return render_template('add_staff.html', unvanlar=unvanlar, poliklinikler=poliklinikler)
                
                # Basit format kontrolleri
                if len(tc) != 11 or not tc.isdigit():
                    flash('TC kimlik numarası 11 haneli rakam olmalıdır!', 'error')
                    cursor.close()
                    connection.close()
                    return render_template('add_staff.html', unvanlar=unvanlar, poliklinikler=poliklinikler)
                
                if len(tel) != 10 or not tel.isdigit() or not tel.startswith('5'):
                    flash('Telefon numarası 5 ile başlayan 10 haneli rakam olmalıdır!', 'error')
                    cursor.close()
                    connection.close()
                    return render_template('add_staff.html', unvanlar=unvanlar, poliklinikler=poliklinikler)
                
                if '@' not in email:
                    flash('Geçerli bir e-posta adresi giriniz!', 'error')
                    cursor.close()
                    connection.close()
                    return render_template('add_staff.html', unvanlar=unvanlar, poliklinikler=poliklinikler)
                
                # Veri tiplerini dönüştür
                tc_int = int(tc)
                tel_int = int(tel)
                unvan_id_int = int(unvan_id)
                poliklinik_id_int = int(poliklinik_id)
                
                # TC kimlik numarası tekrarını kontrol et
                cursor.execute("SELECT COUNT(*) FROM Personeller WHERE Personel_tc = :tc", tc=tc_int)
                if cursor.fetchone()[0] > 0:
                    flash('Bu TC kimlik numarası ile zaten kayıtlı personel var!', 'error')
                    cursor.close()
                    connection.close()
                    return render_template('add_staff.html', unvanlar=unvanlar, poliklinikler=poliklinikler)
                
                # Email tekrarını kontrol et  
                cursor.execute("SELECT COUNT(*) FROM Personeller WHERE Personel_Email = :email", email=email)
                if cursor.fetchone()[0] > 0:
                    flash('Bu e-posta adresi ile zaten kayıtlı personel var!', 'error')
                    cursor.close()
                    connection.close()
                    return render_template('add_staff.html', unvanlar=unvanlar, poliklinikler=poliklinikler)
                
                print(f"Personel ekleniyor: TC={tc_int}, Ad={ad}, Soyad={soyad}, Email={email}, Tel={tel_int}, Unvan={unvan_id_int}, Poliklinik={poliklinik_id_int}")
                
                # Procedure kullanarak personel ekleme
                cursor.callproc('Personel_Ekle', [
                    tc_int, ad, soyad, email, tel_int, unvan_id_int, poliklinik_id_int
                ])
                
                connection.commit()
                print("Personel başarıyla eklendi!")
                
                cursor.close()
                connection.close()
                
                flash(f'{ad} {soyad} adlı personel başarıyla eklendi!', 'success')
                return redirect(url_for('staff'))
                
            except cx_Oracle.IntegrityError as e:
                print(f"Oracle IntegrityError: {e}")
                flash('Bu bilgilerle zaten kayıtlı personel var!', 'error')
                cursor.close()
                connection.close()
                return render_template('add_staff.html', unvanlar=unvanlar, poliklinikler=poliklinikler)
                
            except cx_Oracle.DatabaseError as e:
                print(f"Oracle DatabaseError: {e}")
                flash(f'Veritabanı hatası: {e}', 'error')
                cursor.close()
                connection.close()
                return render_template('add_staff.html', unvanlar=unvanlar, poliklinikler=poliklinikler)
                
            except Exception as e:
                print(f"Genel hata: {e}")
                flash(f'Beklenmeyen hata: {e}', 'error')
                cursor.close()
                connection.close()
                return render_template('add_staff.html', unvanlar=unvanlar, poliklinikler=poliklinikler)
        
    except Exception as e:
        print(f"Ana hata: {e}")
        flash(f'Sistem hatası: {e}', 'error')
        return render_template('error.html', error_message=f"Sistem hatası: {e}")
    
    # Bu noktaya asla gelmemeli, ama güvenlik için
    return render_template('error.html', error_message="Bilinmeyen hata")

@app.route('/reports')
def reports():
    """Raporlar sayfası - HATA YÖNETİMİ GÜÇLENDİRİLDİ"""
    connection = db.get_connection()
    if not connection:
        flash('Veritabanı bağlantısı kurulamadı!', 'error')
        return render_template('error.html')
    
    try:
        cursor = connection.cursor()
        
        # Kan grubu dağılımı
        cursor.execute("""
            SELECT Kan_Grubu, COUNT(*) as sayi
            FROM Hastalar
            GROUP BY Kan_Grubu
            ORDER BY sayi DESC
        """)
        kan_grubu_dagilimi = cursor.fetchall()
        
        # Aylık muayene istatistikleri
        cursor.execute("""
            SELECT TO_CHAR(Muayene_Tarihi, 'YYYY-MM') as ay, COUNT(*) as sayi
            FROM Muayeneler
            WHERE Muayene_Tarihi >= ADD_MONTHS(SYSDATE, -6)
            GROUP BY TO_CHAR(Muayene_Tarihi, 'YYYY-MM')
            ORDER BY ay
        """)
        aylik_muayeneler = cursor.fetchall()
        
        # En çok tahlil yapılan hasta
        cursor.execute("""
            SELECT h.Hasta_Ad, h.Hasta_Soyad, COUNT(t.tc) as tahlil_sayisi
            FROM Hastalar h
            JOIN Tahliller t ON h.Hasta_tc = t.tc
            GROUP BY h.Hasta_tc, h.Hasta_Ad, h.Hasta_Soyad
            ORDER BY tahlil_sayisi DESC
            FETCH FIRST 10 ROWS ONLY
        """)
        en_cok_tahlil = cursor.fetchall()
        
        cursor.close()
        connection.close()
        
        return render_template('reports.html', 
                             kan_grubu_dagilimi=kan_grubu_dagilimi,
                             aylik_muayeneler=aylik_muayeneler,
                             en_cok_tahlil=en_cok_tahlil)
        
    except cx_Oracle.DatabaseError as e:
        flash(f'Veritabanı hatası: {e}', 'error')
        return render_template('error.html')
    except Exception as e:
        flash(f'Beklenmeyen hata: {e}', 'error')
        return render_template('error.html')

@app.errorhandler(404)
def not_found(error):
    return render_template('error.html', error_message="Sayfa bulunamadı (404)"), 404

@app.errorhandler(500)
def internal_error(error):
    return render_template('error.html', error_message="Sunucu hatası (500)"), 500

@app.errorhandler(Exception)
def handle_exception(error):
    # Genel hata yakalayıcı
    return render_template('error.html', error_message=f"Beklenmeyen hata: {str(error)}"), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)