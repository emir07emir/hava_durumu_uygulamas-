# 🌤️ Hava Durumu Uygulaması (Flutter)

Bu proje, **Flutter** kullanılarak geliştirilmiş bir hava durumu uygulamasıdır.  
Kullanıcılar şehir adı girerek o şehre ait **anlık hava durumu** ve **7 günlük tahmini** görüntüleyebilir.  
Ayrıca şehir arka plan görseli **Unsplash API** üzerinden dinamik olarak yüklenmektedir.

---

## 🚀 Özellikler

- 🌍 Şehir adından **koordinat alma** (Open-Meteo Geocoding API).
- 🌤️ **Anlık hava durumu** bilgisi (sıcaklık ve hava koduna göre ikon).
- 📅 **7 günlük hava durumu tahmini** (max/min sıcaklık).
- 🖼️ Şehir için **dinamik arka plan görseli** (Unsplash API).
- 📱 Modern ve şık tasarım (Material 3 + Google Fonts).

---

## 📂 Proje Yapısı

# bash
lib/
│
├── main.dart          # Ana uygulama dosyası, UI + API istekleri
├── openmeteo.dart     # OpenMeteo model sınıfı (JSON parse için)
└── my_flutter_app_icons.dart # Özel ikon setleri

## Kullanılan Teknolojiler
- Flutter
- Dart
- http => API istekleri için
- OpenMeteo API => güncel hava durumu bilgileri için
- Unsplash API => arkaplan fotoğrafları için


## KURULUM

1 - Repoyu Klonlayın

-git clone https://github.com/kullaniciadi/hava-durumu-uygulamasi.git
cd hava-durumu-uygulamasi


2 - Gerekli Paketleri Yükleyin

- flutter pub get

3 - Uygulamayı Çalıştırın

- flutter run


📌 Notlar
- Unsplash API kullanabilmek için kendi client_id değeriniz ile güncelleme yapmalısınız.
- Minimum SDK sürümünüzün 21 veya üzerinde olduğundan emin olun.


👨‍💻 Geliştirici

İbrahim Emir Erdoğan
linkedn : https://www.linkedin.com/in/ibrahim-emir-erdo%C4%9Fan-281300296/

















