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

### Using curl

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
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/bin/urls.sh \
  -o /usr/local/bin/urls.sh \
&& sudo chmod +x /usr/local/bin/urls.sh
```

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/bin/docker.sh \
  -o /usr/local/bin/docker.sh \
&& sudo chmod +x /usr/local/bin/docker.sh
```

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/bin/game.py \
  -o /usr/local/bin/game.py \
&& sudo chmod +x /usr/local/bin/game.py
```
---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---
