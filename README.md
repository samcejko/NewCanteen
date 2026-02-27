# NewCanteen Android — Vyvinuto @samcejko & @ravenwtb

Moderní a rychlá Android aplikace pro objednávání obědů v systému iCanteen. Tato aplikace kombinuje výkonné parsování webu s prémiovým Material Design 3 rozhraním.

## ✨ Klíčové vlastnosti

- **Prémiový Design**: Tmavý režim, skleněné efekty a plynulé animace pro moderní pocit.
- **Material You**: Barvy aplikace se dynamicky přizpůsobují vašemu systému (Android 12+).
- **Multijazyčnost**: Plná podpora pro češtinu, angličtinu a ukrajinštinu.
- **Offline Cache**: Prohlížejte si jídelníček i bez připojení k internetu.
- **Burza Jídel**: Plná integrace pro vracení jídla a brání jídla z burzy.
- **Bleskový přístup**: Bezpečné uložení přihlašovacích údajů pro okamžitý přístup k objednávkám.

## 🚀 Rychlý Start (Automatický setup)

Nepotřebujete mít v počítači manuálně nainstalovanou Javu ani Android SDK. Skript si vše potřebné stáhne a nakonfiguruje sám.

1. Stáhněte nebo naklonujte tento repozitář.
2. Klikněte pravým tlačítkem na soubor `build_apk.ps1` a zvolte **Run with PowerShell**.
   - *Případně v terminálu: `powershell -ExecutionPolicy Bypass -File .\build_apk.ps1`*

### Co skript udělá?
- ☕ **Java**: Stáhne a nastaví OpenJDK 17 do složky v projektu.
- 📱 **Android SDK**: Stáhne nástroje pro sestavení a doinstaluje API 33.
- 🐘 **Gradle**: Nastaví sestavovací systém Gradle.
- 🔐 **Keystore**: Vygeneruje unikátní podpisový klíč pro vaši aplikaci.
- 📦 **Build**: Vezme webový kód ze složky `/icanteen` a vytvoří výsledné `iCanteen.apk`.

## 📂 Struktura projektu

- `/icanteen`: Frontend (HTML, JS, CSS) – to, co vidíte v aplikaci.
- `/icanteen-android`: Nativní Android obal využívající WebView.
- `build_apk.ps1`: Automatizační skript pro kompletní sestavení.

## 🛠 Požadavky
- Operační systém **Windows**.
- Připojení k internetu (pro stažení vývojářských nástrojů při prvním spuštění, cca 600 MB).

## 📄 Poznámky k úpravám
Pokud chcete změnit vzhled nebo funkce aplikace, stačí upravit soubory v `/icanteen`. Po uložení změn znovu spusťte `build_apk.ps1` a nové APK bude obsahovat vaše úpravy.

---
Vytvořeno studenty pro studenty. Projekt není oficiální aplikací systému iCanteen.
