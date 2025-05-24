# ServerHome

## Table of Contents

1. [Introduction](#introduction)
2. [Directory Structure](#directory-structure)
3. [Installation](#installation)
   - [Complete Block](#complete-block)
   - [Using curl](#using-curl)
   - [Using wget](#using-wget)
4. [Usage](#usage)
5. [License](#license)

---

## Introduction

This repository contains a collection of server scripts and utilities designed to automate and simplify common administrative tasks.

---

## Directory Structure

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
  Additional documentation and notes.
- **README.md**
  This document.
- **server-helb/**
  Shell scripts for help pages.
- **server-management/**
  Installer script `install.sh` for all management tools.
- **utilities/**
  Python script `ping_test.py` for ping tests.
- **webapp-install/**
  Web application installation scripts.

---

## Installation
---
### Complete Block

```bash
sudo apt-get update
sudo apt-get install -y curl
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/inst/install.sh \
  -o /usr/local/bin/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```
Execute the block below to update your system, install curl, download the installer script, and make it executable:
---

### Using curl

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/inst/install.sh \
  -o /usr/local/bin/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```

### Using wget

```bash
sudo wget -qO /usr/local/bin/install.sh \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/inst/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```

---

## Usage

1. Run the installer script:

   ```bash
   sudo install.sh
   ```

2. List available scripts:

   ```bash
   ls /usr/local/bin
   ```

---
```bash
# 3) Initialize system services
  sudo systemv.sh
# 4) Execute auxiliary server scripts
  sudo skripts.sh
# 5) Display help page
  sudo help.sh
# 6) Perform system upgrade
  sudo upgrade.sh
# 7) Update hosts configuration
  sudo hosts.py
# 8) Run network connectivity test
  sudo ping.py
# 9) Concatenate and display files
  sudo cat.sh
# 10) Open URLs from list
  sudo urls.sh
# 11) Manage Docker containers
   docker.sh
# 12) Execute custom script 09.sh
   9.sh
# 13) Execute custom script 10.sh
  10.sh
# 14) Execute custom script 11.sh
  11.sh
   ```

---

---


## Installation Games

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/inst/game.sh \
  -o /usr/local/bin/game.sh \
&& sudo chmod +x /usr/local/bin/game.sh
```



### Using Games

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/bin/game/spaceship.py \
  -o /usr/local/bin/game/spaceship.py \
&& sudo chmod +x /usr/local/bin/game/spaceship.py
```

1) Run installer gamescript:
```bash
  sudo game.sh
```

2) Execute custom script
```bash
  sudo spaceship.py
```
---

---

### ## Installation nextcloud

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/bin/nextcloud.sh \
  -o /usr/local/bin/nextcloud.sh \
&& sudo chmod +x /usr/local/bin/nextcloud.sh
```
```bash
  sudo nextcloud.sh
```
---

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---
