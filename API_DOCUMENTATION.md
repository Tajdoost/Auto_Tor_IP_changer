# Auto Tor IP Changer - API Documentation

## Table of Contents
- [Overview](#overview)
- [Installation](#installation)
- [Public APIs](#public-apis)
- [Core Functions](#core-functions)
- [Usage Examples](#usage-examples)
- [Configuration](#configuration)
- [Error Handling](#error-handling)
- [Troubleshooting](#troubleshooting)

## Overview

Auto Tor IP Changer is a Python-based tool that automatically changes your IP address using the Tor network. It provides automated IP rotation with customizable intervals and repetition counts.

### Key Features
- Automatic IP address rotation
- Configurable time intervals
- Infinite or finite IP changes
- SOCKS5 proxy integration
- Automatic dependency installation

## Installation

### Prerequisites
- Linux-based operating system
- Python 3.x
- Root/sudo privileges (for installation)

### Installation Methods

#### Method 1: Automated Installation
```bash
git clone https://github.com/FDX100/Auto_Tor_IP_changer.git
cd Auto_Tor_IP_changer
python3 install.py
```

#### Method 2: Manual Installation
```bash
# Install Tor
sudo apt-get update
sudo apt-get install tor

# Install Python dependencies
pip3 install requests[socks]

# Run the tool directly
python3 autoTOR.py
```

## Public APIs

### Installation API (`install.py`)

#### `install.py` - Installation Manager

**Purpose**: Handles installation and uninstallation of the Auto Tor IP Changer tool.

**Public Interface**:
```python
# Interactive installation prompt
choice = input('[+] to install press (Y) to uninstall press (N) >> ')
```

**Installation Process**:
1. Sets executable permissions on `autoTOR.py`
2. Creates `/usr/share/aut/` directory
3. Copies main script to system directory
4. Creates system-wide executable `/usr/bin/aut`

**Example Usage**:
```bash
python3 install.py
# Follow prompts:
# Y - Install the tool system-wide
# N - Uninstall the tool
```

### Main Application API (`autoTOR.py`)

#### System Requirements Check

The application automatically checks and installs required dependencies:

- **pip3**: Python package manager
- **requests**: HTTP library with SOCKS support
- **tor**: The Tor anonymity network

## Core Functions

### `ma_ip()` - Get Current IP Address

**Purpose**: Retrieves the current external IP address through the Tor SOCKS5 proxy.

**Signature**:
```python
def ma_ip() -> str
```

**Returns**: 
- `str`: Current external IP address

**Implementation Details**:
```python
def ma_ip():
    url='https://www.myexternalip.com/raw'
    get_ip= requests.get(url,proxies=dict(http='socks5://127.0.0.1:9050',https='socks5://127.0.0.1:9050'))
    return get_ip.text
```

**Example Usage**:
```python
current_ip = ma_ip()
print(f"Current IP: {current_ip}")
```

**Error Conditions**:
- Network connectivity issues
- Tor service not running
- Proxy connection failures

### `change()` - Change IP Address

**Purpose**: Reloads the Tor service to obtain a new IP address and displays the result.

**Signature**:
```python
def change() -> None
```

**Side Effects**:
- Reloads Tor service
- Prints new IP address to console

**Implementation Details**:
```python
def change():
    os.system("service tor reload")
    print ('[+] Your IP has been Changed to : '+str(ma_ip()))
```

**Example Usage**:
```python
# Change IP address once
change()
# Output: [+] Your IP has been Changed to : 192.168.1.100
```

## Usage Examples

### Basic Usage

#### Example 1: Simple IP Change
```bash
# After installation
aut

# Follow prompts:
# Enter time interval: 60
# Enter number of changes: 5
```

#### Example 2: Infinite IP Changes
```bash
aut

# Prompts:
# Time to change IP: 30
# Number of changes: 0  # 0 for infinite
```

#### Example 3: Direct Python Execution
```python
import time
from autoTOR import ma_ip, change

# Get current IP
print(f"Starting IP: {ma_ip()}")

# Change IP every 60 seconds, 10 times
for i in range(10):
    time.sleep(60)
    change()
    print(f"Iteration {i+1} completed")
```

### Advanced Usage

#### Custom Time Intervals
```python
# Short intervals for testing
for i in range(3):
    time.sleep(10)  # 10 seconds
    change()

# Long intervals for stealth
for i in range(100):
    time.sleep(300)  # 5 minutes
    change()
```

#### Integration with Web Scraping
```python
import requests
from autoTOR import change, ma_ip

def scrape_with_rotation(urls, change_interval=5):
    """Scrape URLs with automatic IP rotation"""
    session = requests.Session()
    session.proxies = {
        'http': 'socks5://127.0.0.1:9050',
        'https': 'socks5://127.0.0.1:9050'
    }
    
    for i, url in enumerate(urls):
        if i % change_interval == 0:
            change()
            print(f"IP changed to: {ma_ip()}")
        
        response = session.get(url)
        print(f"Scraped {url}: {response.status_code}")
        time.sleep(2)
```

## Configuration

### Proxy Configuration

#### Browser Setup
1. **Firefox**:
   - Go to Settings → Network Settings
   - Select "Manual proxy configuration"
   - SOCKS Host: `127.0.0.1`
   - Port: `9050`
   - Select "SOCKS v5"

2. **Chrome/Chromium**:
   ```bash
   google-chrome --proxy-server="socks5://127.0.0.1:9050"
   ```

#### System-wide Proxy (Optional)
```bash
export http_proxy=socks5://127.0.0.1:9050
export https_proxy=socks5://127.0.0.1:9050
```

### Tor Configuration

#### Custom Tor Configuration (`/etc/tor/torrc`)
```
# Basic configuration
SocksPort 9050
ControlPort 9051

# Optional: Faster circuit building
CircuitBuildTimeout 10
KeepalivePeriod 60
NewCircuitPeriod 15

# Optional: Exclude certain countries
ExcludeNodes {cn},{ru},{ir}
```

## Error Handling

### Common Error Scenarios

#### 1. Dependency Installation Failures
```python
# Automatic handling in autoTOR.py
try:
    import requests
except Exception:
    print('[+] python3 requests is not installed')
    os.system('pip3 install requests')
    os.system('pip3 install requests[socks]')
    print('[!] python3 requests is installed ')
```

#### 2. Tor Service Issues
```python
try:
    check_tor = subprocess.check_output('which tor', shell=True)
except subprocess.CalledProcessError:
    print('[+] tor is not installed !')
    subprocess.check_output('sudo apt update',shell=True)
    subprocess.check_output('sudo apt install tor -y',shell=True)
    print('[!] tor is installed succesfully ')
```

#### 3. Network Connectivity
```python
def safe_ip_check():
    """Safely check IP with error handling"""
    try:
        return ma_ip()
    except requests.RequestException as e:
        print(f"Error getting IP: {e}")
        return None
    except Exception as e:
        print(f"Unexpected error: {e}")
        return None
```

### Graceful Shutdown

The application handles keyboard interrupts for clean exit:
```python
try:
    while True:
        time.sleep(int(x))
        change()
except KeyboardInterrupt:
    print('\nauto tor is closed ')
    quit()
```

## Troubleshooting

### Common Issues and Solutions

#### 1. "Service tor not found"
```bash
# Check if Tor is installed
which tor

# Install if missing
sudo apt-get update
sudo apt-get install tor

# Start Tor service
sudo systemctl start tor
sudo systemctl enable tor
```

#### 2. "Permission denied" errors
```bash
# Run with sudo for system operations
sudo python3 autoTOR.py

# Or install system-wide
sudo python3 install.py
```

#### 3. "Connection refused" on port 9050
```bash
# Check if Tor is running
sudo systemctl status tor

# Restart Tor service
sudo systemctl restart tor

# Check port availability
netstat -tlnp | grep 9050
```

#### 4. IP not changing
```bash
# Manual Tor circuit renewal
echo -e 'AUTHENTICATE ""\r\nSIGNAL NEWNYM\r\nQUIT' | nc 127.0.0.1 9051

# Check Tor logs
sudo journalctl -u tor
```

#### 5. Slow IP changes
```bash
# Edit /etc/tor/torrc
sudo nano /etc/tor/torrc

# Add these lines:
CircuitBuildTimeout 10
NewCircuitPeriod 15

# Restart Tor
sudo systemctl restart tor
```

### Debug Mode

For debugging, you can modify the script to add verbose output:
```python
def debug_change():
    """Enhanced change function with debugging"""
    print("[DEBUG] Reloading Tor service...")
    os.system("service tor reload")
    
    print("[DEBUG] Waiting for new circuit...")
    time.sleep(2)
    
    new_ip = ma_ip()
    print(f'[+] Your IP has been Changed to: {new_ip}')
    print(f'[DEBUG] Change completed at: {time.strftime("%Y-%m-%d %H:%M:%S")}')
```

### Monitoring and Logging

#### Basic Logging Implementation
```python
import logging
from datetime import datetime

logging.basicConfig(
    filename='ip_changes.log',
    level=logging.INFO,
    format='%(asctime)s - %(message)s'
)

def logged_change():
    """Change IP with logging"""
    old_ip = ma_ip()
    os.system("service tor reload")
    time.sleep(2)
    new_ip = ma_ip()
    
    logging.info(f'IP changed from {old_ip} to {new_ip}')
    print(f'[+] Your IP has been Changed to: {new_ip}')
```

### Performance Optimization

#### Faster IP Rotation
```python
def quick_change():
    """Optimized IP change function"""
    # Use Tor control protocol for faster changes
    import socket
    
    try:
        # Connect to Tor control port
        s = socket.socket()
        s.connect(('127.0.0.1', 9051))
        s.send(b'AUTHENTICATE ""\r\n')
        s.recv(1024)
        s.send(b'SIGNAL NEWNYM\r\n')
        s.recv(1024)
        s.close()
        
        time.sleep(1)  # Brief wait for new circuit
        print(f'[+] Your IP has been Changed to: {ma_ip()}')
    except Exception as e:
        # Fallback to service reload
        print(f"Control port method failed: {e}")
        change()
```

## API Reference Summary

| Function | Purpose | Parameters | Returns | Side Effects |
|----------|---------|------------|---------|--------------|
| `ma_ip()` | Get current external IP | None | `str` (IP address) | Network request |
| `change()` | Change IP address | None | None | Reloads Tor, prints new IP |
| `install.py` | Install/uninstall tool | Interactive input | None | System file modifications |

## Version Information

- **Version**: 2.1
- **Python Compatibility**: Python 3.x
- **Platform**: Linux (Ubuntu/Debian tested)
- **Dependencies**: `requests[socks]`, `tor`

## Security Considerations

1. **Root Privileges**: Installation requires sudo access
2. **Network Traffic**: All traffic routes through Tor
3. **Logging**: Consider log rotation and cleanup
4. **Process Isolation**: Run in dedicated user account when possible

## License and Attribution

- **Author**: mrFD
- **Contact**: http://facebook.com/ninja.hackerz.kurdish/
- **Repository**: https://github.com/FDX100/Auto_Tor_IP_changer.git