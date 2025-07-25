# Function Reference Guide

## Table of Contents
- [Core Functions](#core-functions)
- [Installation Functions](#installation-functions)
- [System Integration](#system-integration)
- [Error Handling](#error-handling)
- [Extension Functions](#extension-functions)

## Core Functions

### `ma_ip()`

#### Description
Retrieves the current external IP address by making an HTTP request through the Tor SOCKS5 proxy.

#### Signature
```python
def ma_ip() -> str
```

#### Parameters
- **None**

#### Returns
- **Type**: `str`
- **Description**: The current external IP address as a string

#### Raises
- `requests.exceptions.RequestException`: Network connectivity issues
- `requests.exceptions.ProxyError`: Tor proxy connection failures
- `requests.exceptions.Timeout`: Request timeout
- `requests.exceptions.ConnectionError`: Connection refused or network unreachable

#### Implementation
```python
def ma_ip():
    url='https://www.myexternalip.com/raw'
    get_ip= requests.get(url,proxies=dict(http='socks5://127.0.0.1:9050',https='socks5://127.0.0.1:9050'))
    return get_ip.text
```

#### Usage Examples

##### Basic Usage
```python
# Get current IP
current_ip = ma_ip()
print(f"Your current IP is: {current_ip.strip()}")
```

##### With Error Handling
```python
def safe_get_ip():
    """Safely get IP with comprehensive error handling"""
    try:
        ip = ma_ip()
        return ip.strip()
    except requests.exceptions.ProxyError:
        print("Error: Tor proxy not available. Check if Tor is running on port 9050")
        return None
    except requests.exceptions.Timeout:
        print("Error: Request timed out. Network may be slow")
        return None
    except requests.exceptions.RequestException as e:
        print(f"Error: Network request failed - {e}")
        return None
    except Exception as e:
        print(f"Unexpected error: {e}")
        return None

# Usage
ip = safe_get_ip()
if ip:
    print(f"Current IP: {ip}")
else:
    print("Failed to retrieve IP address")
```

##### Validate IP Format
```python
import re

def get_validated_ip():
    """Get IP and validate it's in correct format"""
    ip = ma_ip().strip()
    
    # IPv4 regex pattern
    ipv4_pattern = r'^(\d{1,3}\.){3}\d{1,3}$'
    
    if re.match(ipv4_pattern, ip):
        # Additional validation for valid IP ranges
        octets = ip.split('.')
        if all(0 <= int(octet) <= 255 for octet in octets):
            return ip
        else:
            raise ValueError("Invalid IP address range")
    else:
        raise ValueError("Invalid IP address format")

# Usage
try:
    valid_ip = get_validated_ip()
    print(f"Valid IP: {valid_ip}")
except ValueError as e:
    print(f"IP validation failed: {e}")
```

#### Performance Considerations
- **Latency**: ~1-3 seconds typical response time through Tor
- **Caching**: Consider caching IP for short periods to reduce requests
- **Rate Limiting**: Be mindful of API rate limits on myexternalip.com

#### Alternative Implementations
```python
def ma_ip_with_fallback():
    """IP detection with multiple fallback services"""
    services = [
        'https://www.myexternalip.com/raw',
        'https://ipinfo.io/ip',
        'https://httpbin.org/ip',
        'https://icanhazip.com'
    ]
    
    proxies = dict(http='socks5://127.0.0.1:9050', https='socks5://127.0.0.1:9050')
    
    for service in services:
        try:
            response = requests.get(service, proxies=proxies, timeout=10)
            if service == 'https://httpbin.org/ip':
                import json
                return json.loads(response.text)['origin']
            return response.text.strip()
        except:
            continue
    
    raise Exception("All IP detection services failed")
```

---

### `change()`

#### Description
Reloads the Tor service to establish a new circuit and obtain a different IP address, then displays the new IP.

#### Signature
```python
def change() -> None
```

#### Parameters
- **None**

#### Returns
- **Type**: `None`
- **Description**: Function performs side effects only

#### Side Effects
1. Executes `service tor reload` system command
2. Prints new IP address to stdout
3. May cause brief network interruption (~2-5 seconds)

#### Raises
- `OSError`: If system command execution fails
- `subprocess.CalledProcessError`: If tor service command fails
- Any exceptions from `ma_ip()` function

#### Implementation
```python
def change():
    os.system("service tor reload")
    print ('[+] Your IP has been Changed to : '+str(ma_ip()))
```

#### Usage Examples

##### Basic Usage
```python
# Simple IP change
change()
# Output: [+] Your IP has been Changed to : 198.51.100.42
```

##### Multiple IP Changes
```python
import time

def change_ip_multiple_times(count, interval):
    """Change IP multiple times with specified interval"""
    for i in range(count):
        print(f"Change #{i+1}:")
        change()
        if i < count - 1:  # Don't sleep after last change
            print(f"Waiting {interval} seconds...")
            time.sleep(interval)

# Usage
change_ip_multiple_times(3, 30)
```

##### Enhanced Change with Verification
```python
def enhanced_change():
    """Change IP with verification and retry logic"""
    old_ip = ma_ip().strip()
    print(f"Current IP: {old_ip}")
    
    max_retries = 3
    for attempt in range(max_retries):
        print(f"Attempt {attempt + 1}: Changing IP...")
        os.system("service tor reload")
        time.sleep(3)  # Wait for new circuit
        
        new_ip = ma_ip().strip()
        if new_ip != old_ip:
            print(f'[+] Your IP has been Changed to: {new_ip}')
            return True
        else:
            print(f"IP didn't change (still {old_ip}), retrying...")
    
    print("Failed to change IP after maximum retries")
    return False

# Usage
if enhanced_change():
    print("IP change successful")
else:
    print("IP change failed")
```

##### Change with Logging
```python
import logging
from datetime import datetime

def logged_change():
    """Change IP with detailed logging"""
    logger = logging.getLogger('ip_changer')
    
    try:
        old_ip = ma_ip().strip()
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        logger.info(f"Starting IP change at {timestamp}. Current IP: {old_ip}")
        
        os.system("service tor reload")
        time.sleep(2)
        
        new_ip = ma_ip().strip()
        
        if new_ip != old_ip:
            logger.info(f"IP successfully changed from {old_ip} to {new_ip}")
            print(f'[+] Your IP has been Changed to: {new_ip}')
        else:
            logger.warning(f"IP change may have failed - still showing {old_ip}")
            print(f'[!] IP may not have changed: {new_ip}')
            
    except Exception as e:
        logger.error(f"IP change failed with error: {e}")
        print(f"[ERROR] IP change failed: {e}")

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('ip_changes.log'),
        logging.StreamHandler()
    ]
)

# Usage
logged_change()
```

#### Performance Optimizations

##### Fast Change using Control Port
```python
def quick_change():
    """Faster IP change using Tor control protocol"""
    import socket
    
    try:
        # Method 1: Use Tor control port (faster)
        s = socket.socket()
        s.settimeout(5)
        s.connect(('127.0.0.1', 9051))
        s.send(b'AUTHENTICATE ""\r\n')
        response = s.recv(1024)
        
        if b'250 OK' in response:
            s.send(b'SIGNAL NEWNYM\r\n')
            response = s.recv(1024)
            s.close()
            
            if b'250 OK' in response:
                time.sleep(1)  # Brief wait for new circuit
                new_ip = ma_ip()
                print(f'[+] Your IP has been Changed to: {new_ip}')
                return True
        
        s.close()
    except Exception as e:
        print(f"Control port method failed: {e}")
    
    # Fallback to service reload
    print("Falling back to service reload method...")
    change()
    return False

# Usage
quick_change()
```

#### System Requirements
- **Permissions**: Requires ability to execute `service tor reload`
- **Dependencies**: Tor service must be installed and running
- **Network**: Active internet connection through Tor

---

## Installation Functions

### Installation Script (`install.py`)

#### Description
Interactive script that handles system-wide installation and uninstallation of the Auto Tor IP Changer tool.

#### Main Function Flow
```python
choice = input('[+] to install press (Y) to uninstall press (N) >> ')
```

#### Installation Process (Y/y)
1. **Set Permissions**: `chmod 777 autoTOR.py`
2. **Create Directory**: `mkdir /usr/share/aut`
3. **Copy Script**: `cp autoTOR.py /usr/share/aut/autoTOR.py`
4. **Create Wrapper**: Generate shell wrapper at `/usr/bin/aut`
5. **Set Executable**: Make all files executable

#### Uninstallation Process (N/n)
1. **Remove Directory**: `rm -r /usr/share/aut`
2. **Remove Executable**: `rm /usr/bin/aut`

#### Usage Examples

##### Automated Installation
```bash
# Install
echo "Y" | python3 install.py

# Uninstall
echo "N" | python3 install.py
```

##### Check Installation Status
```python
import os

def check_installation():
    """Check if Auto Tor IP Changer is installed"""
    aut_dir = "/usr/share/aut"
    aut_exec = "/usr/bin/aut"
    main_script = "/usr/share/aut/autoTOR.py"
    
    checks = {
        "Directory exists": os.path.exists(aut_dir),
        "Executable exists": os.path.exists(aut_exec),
        "Main script exists": os.path.exists(main_script),
        "Executable is executable": os.access(aut_exec, os.X_OK) if os.path.exists(aut_exec) else False
    }
    
    print("Installation Status:")
    for check, status in checks.items():
        print(f"  {check}: {'✓' if status else '✗'}")
    
    return all(checks.values())

# Usage
is_installed = check_installation()
print(f"\nInstallation complete: {'Yes' if is_installed else 'No'}")
```

---

## System Integration

### Dependency Management

#### Automatic Dependency Installation
The application automatically handles dependency installation with these functions:

##### pip3 Installation Check
```python
try:
    check_pip3 = subprocess.check_output('dpkg -s python3-pip', shell=True)
    if str('install ok installed') in str(check_pip3):
        pass
except subprocess.CalledProcessError:
    print('[+] pip3 not installed')
    subprocess.check_output('sudo apt update',shell=True)
    subprocess.check_output('sudo apt install python3-pip -y', shell=True)
    print('[!] pip3 installed succesfully')
```

##### Python Requests Installation
```python
try:
    import requests
except Exception:
    print('[+] python3 requests is not installed')
    os.system('pip3 install requests')
    os.system('pip3 install requests[socks]')
    print('[!] python3 requests is installed ')
```

##### Tor Installation Check
```python
try:
    check_tor = subprocess.check_output('which tor', shell=True)
except subprocess.CalledProcessError:
    print('[+] tor is not installed !')
    subprocess.check_output('sudo apt update',shell=True)
    subprocess.check_output('sudo apt install tor -y',shell=True)
    print('[!] tor is installed succesfully ')
```

#### Enhanced Dependency Management
```python
import subprocess
import sys

def check_and_install_dependencies():
    """Comprehensive dependency check and installation"""
    dependencies = {
        'system': {
            'tor': 'sudo apt-get install -y tor',
            'python3-pip': 'sudo apt-get install -y python3-pip'
        },
        'python': {
            'requests[socks]': 'pip3 install requests[socks]'
        }
    }
    
    print("Checking dependencies...")
    
    # Check system dependencies
    for package, install_cmd in dependencies['system'].items():
        try:
            if package == 'tor':
                subprocess.check_output(['which', 'tor'])
            elif package == 'python3-pip':
                subprocess.check_output(['dpkg', '-s', 'python3-pip'])
            print(f"✓ {package} is installed")
        except subprocess.CalledProcessError:
            print(f"✗ {package} not found, installing...")
            try:
                subprocess.check_output(install_cmd, shell=True)
                print(f"✓ {package} installed successfully")
            except subprocess.CalledProcessError as e:
                print(f"✗ Failed to install {package}: {e}")
                return False
    
    # Check Python dependencies
    for package, install_cmd in dependencies['python'].items():
        try:
            if package == 'requests[socks]':
                import requests
            print(f"✓ {package} is installed")
        except ImportError:
            print(f"✗ {package} not found, installing...")
            try:
                subprocess.check_output(install_cmd, shell=True)
                print(f"✓ {package} installed successfully")
            except subprocess.CalledProcessError as e:
                print(f"✗ Failed to install {package}: {e}")
                return False
    
    print("All dependencies satisfied!")
    return True

# Usage
if __name__ == "__main__":
    if not check_and_install_dependencies():
        sys.exit(1)
```

---

## Error Handling

### Exception Handling Patterns

#### Network Error Handling
```python
import requests
from requests.exceptions import *

def robust_ip_check():
    """IP check with comprehensive error handling"""
    try:
        return ma_ip()
    except ProxyError:
        print("Proxy Error: Tor service may not be running or SOCKS proxy unavailable")
        print("Solution: sudo systemctl start tor")
        return None
    except ConnectionError:
        print("Connection Error: Network unreachable or DNS issues")
        return None
    except Timeout:
        print("Timeout Error: Request took too long")
        return None
    except RequestException as e:
        print(f"Request Error: {e}")
        return None
    except Exception as e:
        print(f"Unexpected Error: {e}")
        return None
```

#### Service Error Handling
```python
def safe_service_reload():
    """Safely reload Tor service with error handling"""
    try:
        # Check if tor service exists
        result = subprocess.run(['systemctl', 'status', 'tor'], 
                              capture_output=True, text=True)
        
        if result.returncode != 0:
            print("Tor service not found or not running")
            return False
        
        # Reload service
        result = subprocess.run(['sudo', 'service', 'tor', 'reload'], 
                              capture_output=True, text=True)
        
        if result.returncode == 0:
            print("Tor service reloaded successfully")
            return True
        else:
            print(f"Failed to reload Tor service: {result.stderr}")
            return False
            
    except subprocess.CalledProcessError as e:
        print(f"Command execution failed: {e}")
        return False
    except PermissionError:
        print("Permission denied: Run with sudo privileges")
        return False
    except Exception as e:
        print(f"Unexpected error: {e}")
        return False
```

---

## Extension Functions

### Advanced Features

#### IP Change with Geolocation
```python
import requests
import json

def change_with_location():
    """Change IP and show location information"""
    old_ip = ma_ip().strip()
    
    # Get old location
    try:
        old_location = get_ip_location(old_ip)
        print(f"Current location: {old_location}")
    except:
        print(f"Current IP: {old_ip}")
    
    # Change IP
    os.system("service tor reload")
    time.sleep(3)
    
    new_ip = ma_ip().strip()
    
    # Get new location
    try:
        new_location = get_ip_location(new_ip)
        print(f"New location: {new_location}")
    except:
        print(f"New IP: {new_ip}")

def get_ip_location(ip):
    """Get geographical location of IP address"""
    try:
        response = requests.get(f'http://ipinfo.io/{ip}/json', 
                              proxies=dict(http='socks5://127.0.0.1:9050',
                                         https='socks5://127.0.0.1:9050'))
        data = response.json()
        return f"{data.get('city', 'Unknown')}, {data.get('country', 'Unknown')}"
    except:
        return f"IP: {ip}"
```

#### Scheduled IP Changes
```python
import schedule
import threading

def schedule_ip_changes():
    """Schedule automatic IP changes"""
    def change_job():
        print(f"Scheduled change at {datetime.now()}")
        change()
    
    # Schedule changes every 30 minutes
    schedule.every(30).minutes.do(change_job)
    
    def run_scheduler():
        while True:
            schedule.run_pending()
            time.sleep(1)
    
    # Run scheduler in background thread
    scheduler_thread = threading.Thread(target=run_scheduler, daemon=True)
    scheduler_thread.start()
    
    print("IP change scheduler started (every 30 minutes)")
    return scheduler_thread

# Usage
scheduler = schedule_ip_changes()
```

#### IP Change Statistics
```python
import json
from datetime import datetime

class IPChangeTracker:
    def __init__(self, log_file="ip_changes.json"):
        self.log_file = log_file
        self.load_history()
    
    def load_history(self):
        """Load change history from file"""
        try:
            with open(self.log_file, 'r') as f:
                self.history = json.load(f)
        except FileNotFoundError:
            self.history = []
    
    def save_history(self):
        """Save change history to file"""
        with open(self.log_file, 'w') as f:
            json.dump(self.history, f, indent=2)
    
    def tracked_change(self):
        """Change IP and track statistics"""
        start_time = datetime.now()
        old_ip = ma_ip().strip()
        
        os.system("service tor reload")
        time.sleep(2)
        
        new_ip = ma_ip().strip()
        end_time = datetime.now()
        
        change_record = {
            "timestamp": start_time.isoformat(),
            "old_ip": old_ip,
            "new_ip": new_ip,
            "duration_seconds": (end_time - start_time).total_seconds(),
            "success": old_ip != new_ip
        }
        
        self.history.append(change_record)
        self.save_history()
        
        print(f'[+] Your IP has been Changed to: {new_ip}')
        print(f'[+] Change took {change_record["duration_seconds"]:.2f} seconds')
        
        return change_record
    
    def get_statistics(self):
        """Get change statistics"""
        if not self.history:
            return "No IP changes recorded"
        
        successful_changes = [r for r in self.history if r["success"]]
        avg_duration = sum(r["duration_seconds"] for r in self.history) / len(self.history)
        success_rate = len(successful_changes) / len(self.history) * 100
        
        return f"""
IP Change Statistics:
- Total changes: {len(self.history)}
- Successful changes: {len(successful_changes)}
- Success rate: {success_rate:.1f}%
- Average duration: {avg_duration:.2f} seconds
- Last change: {self.history[-1]["timestamp"]}
        """

# Usage
tracker = IPChangeTracker()
tracker.tracked_change()
print(tracker.get_statistics())
```

This comprehensive function reference provides detailed documentation for all public APIs, functions, and components in the Auto Tor IP Changer project, including extensive examples, error handling patterns, and extension possibilities.