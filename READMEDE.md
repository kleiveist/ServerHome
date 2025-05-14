# ServerHome

## Inhaltsverzeichnis

1. [Einführung](#einführung)
2. [Verzeichnisstruktur](#verzeichnisstruktur)
3. [Installation](#installation)
   - [Mit `curl`](#mit-curl)
   - [Mit `wget`](#mit-wget)
4. [Verwendung](#verwendung)
5. [Lizenz](#lizenz)

---

## Einführung

Dieses Repository enthält eine Sammlung von Server-Skripten und Hilfsprogrammen zur Automatisierung und Vereinfachung häufiger Verwaltungsaufgaben.

---

## Verzeichnisstruktur

```text
📂 ServerHome
├── 📝 InContent.txt
├── 📝 README.md
├── 📝 READMEDE.md
├── 📂 bin/
│   ├── 📄 cat.sh
│   ├── 📄 docker.sh
│   ├── 🐍 hosts.py
│   ├── 🐍 ping.py
│   └── 📄 urls.sh
├── 📂 inst/
│   └── 📄 install.sh
├── 📂 server-helb/
│   ├── 📄 help.sh
│   └── 📄 skripts.sh
└── 📂 server-management/
    ├── 📄 systemv.sh
    └── 📄 upgrade.sh
```

- **InContent.txt**
  Zusätzliche Dokumentation und Notizen.
- **README.md**
  Dieses Dokument.
- **server-helb/**
  Shell-Skripte für Hilfeseiten.
- **server-management/**
  Installationsskript `install.sh` für alle Management-Tools.
- **utilities/**
  Python-Skript `ping_test.py` für Ping-Tests.
- **webapp-install/**
  Installationsskripte für Webanwendungen.

---

## Installation
---
### komplettblock
```bash
sudo apt-get update
sudo apt-get install -y curl
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/inst/install.sh \
  -o /usr/local/bin/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```
Führen Sie den folgenden Block aus, um das System zu aktualisieren, curl zu installieren, das Installationsskript herunterzuladen und ausführbar zu machen:
---
Führe einen der folgenden Befehle auf deinem Server aus:

### Mit `curl`

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/inst/install.sh \
  -o /usr/local/bin/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```

### Mit `wget`

```bash
sudo wget -qO /usr/local/bin/install.sh \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/inst/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```

---

## Verwendung

1. Run the installer script:

   ```bash
   sudo install.sh
   ```

2. List available scripts:

   ```bash
   ls /usr/local/bin
   ```

---

3) Initialize system services
   ```bash
    sudo systemv.sh
   ```

4) Execute auxiliary server scripts
   ```bash
    skripts.sh
   ```

5) Display help page
   ```bash
    help.sh
   ```

6) Perform system upgrade
   ```bash
    upgrade.sh
   ```

7) Update hosts configuration
   ```bash
    hosts.py
   ```

8) Run network connectivity test
   ```bash
    ping.py
   ```

9) Concatenate and display files
   ```bash
    cat.sh
   ```

10) Open URLs from list
   ```bash
    urls.sh
   ```

11) Manage Docker containers
   ```bash
    docker.sh
   ```

12) Execute custom script 09.sh
   ```bash
    game.py
   ```

13) Execute custom script 10.sh
   ```bash
    10.sh
   ```

14) Execute custom script 11.sh
   ```bash
    11.sh
   ```
---


### Using curl help_page.sh

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/server-management/systemv.sh \
  -o /usr/local/bin/systemv.sh \
&& sudo chmod +x /usr/local/bin/systemv.sh
```

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/server-helb/skripts.sh \
  -o /usr/local/bin/skripts.sh \
&& sudo chmod +x /usr/local/bin/skripts.sh
```

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/server-helb/help.sh \
  -o /usr/local/bin/help.sh \
&& sudo chmod +x /usr/local/bin/help.sh
```

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/server-management/upgrade.sh \
  -o /usr/local/bin/upgrade.sh \
&& sudo chmod +x /usr/local/bin/upgrade.sh
```
```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/bin/hosts.py \
  -o /usr/local/bin/hosts.py \
&& sudo chmod +x /usr/local/bin/hosts.py
```
```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/bin/ping.py \
  -o /usr/local/bin/ping.py \
&& sudo chmod +x /usr/local/bin/ping.py
```

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/bin/cat.sh \
  -o /usr/local/bin/cat.sh \
&& sudo chmod +x /usr/local/bin/cat.sh
```

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/bin/game.py \
  -o /usr/local/bin/game.py \
&& sudo chmod +x /usr/local/bin/game.py

---
## Lizenz

Dieses Projekt steht unter der MIT License. Siehe [LICENSE](LICENSE) für Details.

---
