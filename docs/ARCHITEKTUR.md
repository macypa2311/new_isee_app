# Architektur

## Überblick
Die App ist rollenbasiert (Superadmin, Admin, Installateur, Planer, Endkunde) und steuert PV (Photovoltaik) sowie WP (Wärmepumpe). Zentral sind:
- Theme (Hell/Dunkel) mit Persistenz  
- Authentifizierung und Rollen  
- Rollenbasierte Startseiten (Landingpages)  
- Geräteübersichten mit Fehlerstatus  
- Wiederverwendbares Design-System (Textstile, Farben)  
- Einstellungen

## Struktur

### lib/kern/
Infrastruktur / zentrale Steuerung:
- `thema/`: ThemeController, DesignSystem (globaler Hell/Dunkel-Modus + Textstile)  
- `auth/`: AuthController, Benutzer-/Rollenmodell  
- `app_start/`: Einstieg und Routing (Login vs. Landing)  
- `gemeinsames/`: Wiederverwendbare Helfer (z. B. Fehlerdialog)

### lib/funktionen/
Konkrete Features:
- `login/`: Login-Seite mit Rollenwahl  
- `startseite/`: Rollen-basierte Landingpage  
- `geraete/`: Gerätebereiche (PV / WP) mit Überblick und Detail  
- `einstellungen/`: Einstellungen wie Theme

### lib/geteilte/
Gemeinsame Typen:
- Rollen-Enum mit deutschem Namen  
- Konstanten, ggf. Helper

## Zustand & Kommunikation
- `ThemaController` und `AuthController` sind `ChangeNotifier`-basierte zentrale Zustände, bereitgestellt per `Provider`.  
- `MaterialApp` liest `ThemaController` für `themeMode`.  
- Login setzt aktuellen Benutzer; Landingpage entscheidet je Rolle, was gezeigt wird.

## Erweiterbarkeit
- Neue Gerätetypen (z. B. Speicher) können analog zu PV / WP hinzugefügt werden.  
- API-Anbindung über Services/Repositories.  
- Persistenter Login via sicherem Speicher (z. B. Token).  