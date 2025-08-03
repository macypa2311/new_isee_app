# Projektübersicht: Neue ISEE App

**Ziel:** Rollenbasierte Steuerungs-App für PV (Photovoltaik) und WP (Wärmepumpe) mit zentralem Theme (Hell/Dunkel), Login mit Rollen, Geräteübersichten und Fehleranzeige.

## Hauptfunktionen
- Anmeldung mit Rollen: Superadmin, Admin, Installateur, Planer, Endkunde  
- Globaler Hell/Dunkel-Modus mit Persistenz  
- Rollenbasierte Startseite (Landingpage) mit individuellen Kacheln  
- Geräteübersichten für PV und WP, inklusive Fehlerstatus  
- Einstellungen (z. B. Theme)  
- Wiederverwendbares Design-System (Textstile, Farben)

## Struktur (Kurz)
- `lib/kern/`: Infrastruktur (Thema, Auth, App-Start, gemeinsame Widgets)  
- `lib/funktionen/`: Feature-Seiten (Login, Landing, Geräte etc.)  
- `lib/geteilte/`: Enums und Rollenmodelle  
- `docs/`: Projektdokumentation  

## Schnellstart
```bash
flutter pub get
flutter run