# Megakent Danışman — Uygulama Tasarımı ve İşlev Taslağı

## Kaynak: `apk.apk` (decompiled_app) Detaylı İnceleme

---

## 1. GENEL SİSTEM MİMARİSİ

| Özellik | Orijinal Değer (decompiled_app) |
|---|---|
| Paket Adı | `com.megakentemlak.danisman` |
| Uygulama Adı | Megakent Danışman |
| Teknoloji | Ionic / Capacitor (`capacitor.config.json`) |
| Ana URL | `https://dijitaltahta.com/#login` |
| Offline Sayfa | `offline.html` |
| Kullanıcı Ajanı | `KiraMobilApp/1.0` |
| Splash Ekranı | `#000000` zemin, `#ef1c1c` spinner, 1500ms süre |
| Durum Çubuğu | Açık (`LIGHT`), beyaz (`#ffffff`) zemin |
| Yerel Bildirim İkon Rengi | `#0f766e` |

---

## 2. RENK PALETI (Orijinal `index.html` / `offline.html`'den)

| Rol | Hex | Açıklama |
|---|---|---|
| Zemin (Arka Plan) | `#0f172a` | Koyu lacivert |
| Kart / Yüzey | `#111c33` | Biraz daha açık lacivert |
| Kenar / Çerçeve | `#1e293b` | Gri-mavi sınır |
| Ana Renk (Buton) | `#0f766e` | Deniz yeşili / Turkuaz |
| İkincil / Vurgu | `#14b8a6` | Açık turkuaz |
| Metin (Beyaz) | `#e2e8f0` | Açık beyaz |
| Açıklama Metni | `#94a3b8` | Açık gri |
| Spinner Çizgi | `#1e293b` (arka) / `#14b8a6` (ön) | Dairesel ilerleme |

---

## 3. TİPOGRAFİ

- Font Ailesi: `system-ui, -apple-system, "Segoe UI", Roboto, sans-serif`
- Başlık (`h1`): `20px`, kalın (`700`), beyaz (`#fff`)
- Açıklama (`p`): `15px`, `line-height: 1.5`, `#94a3b8`
- Buton (`button`): `15px`, kalın (`700`), beyaz metin

---

## 4. EKRANLAR VE BİLEŞENLER

### EKRAN A: Ana Ekran (`index.html`)

**İşlev**: `https://dijitaltahta.com/#login` adresini yüklemek.

**Tasarım**:
- Tam ekran (`height: 100%`)
- Arka plan: `#0f172a`
- Merkezde küçük yükleme animasyonu (`spin`):
  - 44px genişlik/yükseklik
  - 4px kalınlık
  - `#1e293b` zemin, `#14b8a6` üst çizgi
  - `animation: s 0.9s linear infinite` (sürekli dönen)
- Hiçbir buton yok; sayfa yüklenince kullanıcı sunucuya yönlendirilir.

**Flutter Karşılığı**:
- `InAppWebView` tam ekranda (`SafeArea` + `Stack`)
- `CircularProgressIndicator` (`strokeWidth: 4`, `valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF14b8a6))`)
- Yükleme sırasında koyu renkli (`#0f172a`) `ColoredBox` ile kaplanır.

---

### EKRAN B: Bağlantı Yok / Offline (`offline.html`)

**İşlev**: İnternet yoksa kullanıcıya bilgi verip yeniden deneme imkanı sunmak.

**Bileşenler**:
1. **Kart (`.card`)**:
   - Genişlik: `%100`, max `380px`
   - Arka plan: `#111c33`
   - Çerçeve: `1px solid #1e293b`
   - Yuvarlak köşe: `border-radius: 20px`
   - İç boşluk: `28px 22px`

2. **İkon (`.ico`)**:
   - `64px` kare
   - `border-radius: 18px`
   - Arka plan: `#134e4a`
   - İçerik: Emoji `📶` (`font-size: 30px`)

3. **Başlık (`h1`)**:
   - Metin: `Sisteme bağlanılamadı`
   - `font-size: 20px`, beyaz (`#fff`), kalın (`700`)

4. **Açıklama (`p`)**:
   - Metin: `İnternet bağlantınızı kontrol edin. Sorun sürerse sistem bakımda olabilir; biraz sonra tekrar deneyin.`
   - `font-size: 15px`, `#94a3b8`, `line-height: 1.5`

5. **Buton (`#retry`)**:
   - Tam genişlik (`width: 100%`)
   - `border-radius: 14px`
   - İç boşluk: `14px`
   - `font-size: 15px`, kalın (`700`), beyaz metin (`#fff`)
   - Arka plan: `#0f766e`
   - Basılı (`:active`): `#115e59`

6. **Yükleme Spinner (`#spin`)**:
   - `display: none` (başlangıçta gizli)
   - `22px` genişlik/yükseklik
   - `border: 3px solid #1e293b`, üst `#14b8a6`
   - `animation: s 0.9s linear infinite`

**Buton İşlevi (`retry`)**:
- `click` olunca `spin` görünür (`display: block`)
- Eğer `window.Capacitor.Plugins.KiraPrint` ve `restartApp` varsa: `restartApp()` çağrılır, hata olursa `location.replace(URL_HOME)` yapılır.
- Yoksa doğrudan `location.replace(URL_HOME)` yapılır.
- `online` olayı (`window.addEventListener('online', retry)`) dinlenir; bağlantı geri gelince otomatik yeniden deneme tetiklenir.

**Flutter Karşılığı**:
- `OfflineScreen` widget'i (`StatefulWidget`)
- Kart tasarımı aynı (`Container` + `BoxDecoration`)
- `ElevatedButton` (`backgroundColor: #0f766e`, `shape: RoundedRectangleBorder(borderRadius: 14)`)
- `onPressed`: `_handleRetry()` → `setState` ile `_loading = true` → 800ms sonra `_restartApp()` çağrılır.
- `CircularProgressIndicator` (`strokeWidth: 3`, `valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF14b8a6))`)
- `Connectivity().onConnectivityChanged` dinlenir (`online` olayı karşılığı).

---

### EKRAN C: Splash / Açılış (`capacitor.config.json` SplashScreen)

**İşlev**: Uygulama açılırken kısa süreli giriş ekranı.

**Ayarlar**:
- `launchShowDuration`: 1500ms
- `launchAutoHide`: `true`
- `backgroundColor`: `#000000`
- `showSpinner`: `true`
- `androidSpinnerStyle`: `large`
- `spinnerColor`: `#ef1c1c`
- `splashFullScreen`: `false`
- `splashImmersive`: `false`

**Flutter Karşılığı**:
- `flutter_native_splash` paketi (`pubspec.yaml`'de mevcut)
- `color: "#000000"`, `image: assets/images/splash_icon.png`

---

## 5. NAVİGASYON VE URL KURALLARI

**İzinli Domainler** (`allowedDomains`):
- `megakentemlak.com`
- `www.megakentemlak.com`
- `dijitaltahta.com`
- `www.dijitaltahta.com`
- `localhost`

**Davranış** (`shouldOverrideUrlLoading`):
- Eğer URL izinli listede değilse:
  - `url_launcher` ile harici tarayıcıda (`LaunchMode.externalApplication`) açılmaya çalışılır.
  - Açılmazsa sessizce (`catch (_) {}`) göz ardı edilir.
  - `NavigationActionPolicy.CANCEL` ile webview'de yükleme iptal edilir.

---

## 6. BUTONLARIN İŞLEVSEL HARİTASI

| Buton / Bileşen | Konum | İşlevi | Flutter Karşılığı |
|---|---|---|---|
| `#retry` (`button`) | Offline Kart | Bağlantıyı yeniden dene | `ElevatedButton` → `_restartApp()` |
| `spin` (`#spin`) | Offline Kart (alt) | Yükleniyor animasyonu | `CircularProgressIndicator` |
| `spin` (Ana Ekran) | Ana Ekran (merkez) | Ana yükleme animasyonu | `CircularProgressIndicator` |
| `url_launcher` | WebView (arka planda) | Harici bağlantıları aç | `url_launcher` (`launchUrl`) |

---

## 7. PLUGIN / İZİN HARİTASI

| Plugin / İzin | Amaç | Flutter Karşılığı |
|---|---|---|
| `INTERNET` | Ağ erişimi | Otomatik (`flutter_inappwebview`) |
| `ACCESS_NETWORK_STATE` | Bağlantı durumu | `connectivity_plus` |
| `CAMERA` / `POST_NOTIFICATIONS` | Kamera / Bildirim | `permission_handler` / `flutter_local_notifications` |
| `Browser` (Capacitor) | Harici tarayıcı açma | `url_launcher` |
| `SplashScreen` | Açılış ekranı | `flutter_native_splash` |
| `StatusBar` | Durum çubuğu rengi/stili | Flutter varsayılan (`ThemeData`) |
| `LocalNotifications` | Bildirimler | `flutter_local_notifications` |

---

## 8. TASARIM KURALLARI (Flutter Uygulaması İçin)

1. **Tam Ekran WebView**: `InAppWebView` (`Stack` içinde, `SafeArea` ile kaplanmış) tam ekran olmalı; yükleme sırasında `ColoredBox` (`#0f172a`) ile kaplanmalı.
2. **Offline Kartı**: `OfflineScreen` (`Scaffold` + `SafeArea` + `Center`) içinde `SingleChildScrollView` ile sınırlandırılmış (`maxWidth: 380`) kart kullanılmalı.
3. **Renk Uyumu**: Tüm `Color` sabitleri yukarıdaki paletten (`#0f172a`, `#111c33`, `#1e293b`, `#0f766e`, `#14b8a6`, `#94a3b8`, `#e2e8f0`) alınmalı.
4. **Buton Davranışı**: Offline butonu basıldığında `_loading` `true` yapılmalı, `Future.delayed` (800ms) ile geri yüklenmeli; aynı zamanda webview yeniden başlatılmalı.
5. **Bağlantı Dinleme**: `Connectivity().onConnectivityChanged` dinlenmeli; `online` olunca `_showOffline` kapatılmalı (`offline.html`'deki `window.addEventListener('online', retry)` karşılığı).
6. **Yükleme Durumu**: `_isLoadingWeb` (`bool`) her `onLoadStart`/`onLoadStop`'ta güncellenmeli; `Positioned.fill` ile spinner gösterilmeli.
7. **Domain Kontrolü**: `shouldOverrideUrlLoading` içinde `allowedDomains` listesi (`megakentemlak.com`, `dijitaltahta.com`, `localhost`) kontrol edilmeli.
8. **Kullanıcı Ajanı**: `InAppWebViewSettings`'te `applicationNameForUserAgent: 'KiraMobilApp/1.0'` ayarlanmalı (`DESKTOP` modu kullanılmamalı; `RECOMMENDED` veya `MOBILE` tercih edilmeli).
