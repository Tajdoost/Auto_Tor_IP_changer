# Auto Tor IP Changer - User Guide

## Table of Contents
- [Quick Start](#quick-start)
- [Installation Guide](#installation-guide)
- [Basic Usage](#basic-usage)
- [Advanced Usage](#advanced-usage)
- [Configuration](#configuration)
- [Browser Setup](#browser-setup)
- [Command Line Options](#command-line-options)
- [Practical Examples](#practical-examples)
- [Monitoring and Logging](#monitoring-and-logging)
- [Performance Tuning](#performance-tuning)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

## Quick Start

### 1. Clone and Install
```bash
git clone https://github.com/FDX100/Auto_Tor_IP_changer.git
cd Auto_Tor_IP_changer
python3 install.py
```

### 2. Run the Tool
```bash
aut
```

### 3. Configure Your Browser
Set your browser's SOCKS proxy to `127.0.0.1:9050`

That's it! Your IP will now change automatically at the intervals you specify.

## Installation Guide

### System Requirements
- **Operating System**: Linux (Ubuntu 18.04+, Debian 9+, or similar)
- **Python**: Version 3.6 or higher
- **Privileges**: Sudo access for installation
- **Network**: Internet connection

### Step-by-Step Installation

#### Method 1: Automated Installation (Recommended)
```bash
# 1. Clone the repository
git clone https://github.com/FDX100/Auto_Tor_IP_changer.git

# 2. Navigate to directory
cd Auto_Tor_IP_changer

# 3. Run installer
python3 install.py

# 4. Follow the prompt and press 'Y' to install
```

#### Method 2: Manual Installation
```bash
# 1. Install system dependencies
sudo apt update
sudo apt install tor python3-pip

# 2. Install Python dependencies
pip3 install requests[socks]

# 3. Clone and run directly
git clone https://github.com/FDX100/Auto_Tor_IP_changer.git
cd Auto_Tor_IP_changer
python3 autoTOR.py
```

#### Method 3: Docker Installation (Advanced)
```dockerfile
# Dockerfile
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    tor \
    python3 \
    python3-pip \
    && pip3 install requests[socks]

COPY autoTOR.py /app/autoTOR.py
WORKDIR /app

CMD ["python3", "autoTOR.py"]
```

```bash
# Build and run
docker build -t auto-tor .
docker run -it --network=host auto-tor
```

### Verification
After installation, verify everything works:
```bash
# Check if command is available
which aut

# Test the installation
aut --help  # (if you added help option)

# Check if Tor is running
sudo systemctl status tor
```

## Basic Usage

### Starting the Application
```bash
# If installed system-wide
aut

# If running from source directory
python3 autoTOR.py
```

### Basic Configuration Prompts
When you run the tool, you'll see these prompts:

#### 1. Time Interval Configuration
```
[+] time to change Ip in Sec [type=60] >>
```
**What to enter:**
- `30` - Change IP every 30 seconds (fast, for testing)
- `60` - Change IP every minute
- `300` - Change IP every 5 minutes (recommended)
- `1800` - Change IP every 30 minutes (for stealth)

#### 2. Number of Changes
```
[+] how many time do you want to change your ip [type=1000]for infinte ip change type [0] >>
```
**What to enter:**
- `0` - Infinite changes (run until stopped)
- `10` - Change IP 10 times then stop
- `100` - Change IP 100 times then stop

### Example Session
```bash
$ aut

                _          _______
     /\        | |        |__   __|
    /  \  _   _| |_ ___      | | ___  _ __
   / /\ \| | | | __/ _ \     | |/ _ \| '__|
  / ____ \ |_| | || (_) |    | | (_) | |
 /_/    \_\__,_|\__\___/     |_|\___/|_|
                V 2.1
from mrFD

 http://facebook.com/ninja.hackerz.kurdish/

change your  SOCKES to 127.0.0.1:9050 

[+] time to change Ip in Sec [type=60] >> 120
[+] how many time do you want to change your ip [type=1000]for infinte ip change type [0] >> 5

[+] Your IP has been Changed to : 185.220.101.42
[+] Your IP has been Changed to : 199.87.154.255
[+] Your IP has been Changed to : 178.17.174.14
[+] Your IP has been Changed to : 185.220.102.8
[+] Your IP has been Changed to : 192.42.116.16
```

### Stopping the Application
- **Graceful Stop**: Press `Ctrl+C` to stop the application cleanly
- **Force Stop**: If unresponsive, use `Ctrl+Z` then `kill %1`

## Advanced Usage

### Custom Scripts and Integration

#### Create a Custom Wrapper Script
```bash
#!/bin/bash
# save as: ~/bin/auto-tor-custom

echo "Starting Auto Tor IP Changer with custom settings..."

# Pre-configured settings
echo "300" | python3 /usr/share/aut/autoTOR.py  # 5 minute intervals
echo "0"   # Infinite changes
```

#### Integration with Other Tools
```bash
# Use with curl for web scraping
function tor_curl() {
    curl --socks5-hostname 127.0.0.1:9050 "$@"
}

# Use with wget
function tor_wget() {
    wget --proxy=on --proxy-user="" --proxy-password="" \
         --proxy-host=127.0.0.1 --proxy-port=9050 "$@"
}
```

### Scheduled IP Changes
```bash
# Add to crontab for scheduled execution
crontab -e

# Change IP every hour
0 * * * * /usr/bin/aut
```

### Background Execution
```bash
# Run in background
nohup aut > ip_changes.log 2>&1 &

# Check if running
ps aux | grep autoTOR

# Stop background process
pkill -f autoTOR.py
```

## Configuration

### Tor Configuration (`/etc/tor/torrc`)

#### Basic Configuration
```
# SOCKS proxy settings
SocksPort 9050

# Control port for faster IP changes
ControlPort 9051

# Entry and exit node preferences
EntryNodes {us},{ca},{gb}
ExitNodes {us},{ca},{gb}

# Exclude certain countries (optional)
ExcludeNodes {cn},{ru},{ir},{kp}
```

#### Performance Optimization
```
# Faster circuit building
CircuitBuildTimeout 10
LearnCircuitBuildTimeout 0
CircuitIdleTimeout 30
NewCircuitPeriod 15

# Connection settings
KeepalivePeriod 60
SocksTimeout 30

# Disable unused features for speed
ClientOnly 1
```

#### Security Hardening
```
# Enhanced privacy
ExcludeExitNodes {??}  # Exclude unknown countries
StrictNodes 1

# Disable dangerous features
ClientRejectInternalAddresses 1
SafeLogging 1

# Authentication for control port
HashedControlPassword 16:872860B76453A77D60CA2BB8C1A7042072093276A3D701AD684053EC4C
```

### Application Configuration

#### Environment Variables
```bash
# Set custom Tor proxy
export TOR_PROXY_HOST="127.0.0.1"
export TOR_PROXY_PORT="9050"

# Set custom IP check service
export IP_CHECK_URL="https://httpbin.org/ip"

# Set log level
export LOG_LEVEL="INFO"
```

#### Configuration File (Create `config.json`)
```json
{
  "tor_proxy": {
    "host": "127.0.0.1",
    "port": 9050
  },
  "ip_services": [
    "https://www.myexternalip.com/raw",
    "https://ipinfo.io/ip",
    "https://httpbin.org/ip"
  ],
  "default_interval": 300,
  "default_count": 0,
  "log_file": "ip_changes.log",
  "enable_logging": true
}
```

## Browser Setup

### Firefox Configuration

#### Method 1: GUI Setup
1. **Open Firefox Settings**
   - Go to `Settings` > `General` > `Network Settings`
   - Click `Settings...`

2. **Configure Proxy**
   - Select `Manual proxy configuration`
   - SOCKS Host: `127.0.0.1`
   - Port: `9050`
   - Select `SOCKS v5`
   - Check `Proxy DNS when using SOCKS v5`

3. **Verify Setup**
   - Visit [whatismyipaddress.com](https://whatismyipaddress.com)
   - Your IP should show a Tor exit node

#### Method 2: Firefox Profile
```bash
# Create Tor-specific Firefox profile
firefox -CreateProfile "tor-profile"

# Launch Firefox with Tor proxy
firefox -P tor-profile -proxy-server="socks5://127.0.0.1:9050"
```

### Chrome/Chromium Configuration
```bash
# Launch Chrome with Tor proxy
google-chrome --proxy-server="socks5://127.0.0.1:9050" \
              --host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE 127.0.0.1"

# Create desktop shortcut
cat > ~/Desktop/Chrome-Tor.desktop << EOF
[Desktop Entry]
Name=Chrome (Tor)
Exec=google-chrome --proxy-server="socks5://127.0.0.1:9050"
Icon=google-chrome
Type=Application
EOF
```

### System-wide Proxy (Optional)
```bash
# Set system proxy (temporary)
export http_proxy=socks5://127.0.0.1:9050
export https_proxy=socks5://127.0.0.1:9050
export HTTP_PROXY=socks5://127.0.0.1:9050
export HTTPS_PROXY=socks5://127.0.0.1:9050

# Make permanent (add to ~/.bashrc)
echo 'export http_proxy=socks5://127.0.0.1:9050' >> ~/.bashrc
echo 'export https_proxy=socks5://127.0.0.1:9050' >> ~/.bashrc
```

## Command Line Options

### Creating Enhanced Command Line Interface
You can enhance the tool with command line options by modifying `autoTOR.py`:

```python
import argparse

def parse_arguments():
    parser = argparse.ArgumentParser(description='Auto Tor IP Changer')
    parser.add_argument('-i', '--interval', type=int, default=60,
                       help='Time interval between IP changes (seconds)')
    parser.add_argument('-c', '--count', type=int, default=0,
                       help='Number of IP changes (0 for infinite)')
    parser.add_argument('-v', '--verbose', action='store_true',
                       help='Enable verbose output')
    parser.add_argument('--no-banner', action='store_true',
                       help='Hide banner on startup')
    return parser.parse_args()

# Usage examples:
# aut -i 30 -c 10        # Change every 30 seconds, 10 times
# aut --interval 300     # Change every 5 minutes, infinite
# aut -v                 # Verbose output
```

### Batch Operations
```bash
# Pre-configure settings in a script
#!/bin/bash
# auto-tor-batch.sh

INTERVAL=${1:-300}  # Default 5 minutes
COUNT=${2:-0}       # Default infinite

echo "Starting Auto Tor with $INTERVAL second intervals"
if [ $COUNT -eq 0 ]; then
    echo "Running indefinitely (Ctrl+C to stop)"
else
    echo "Will change IP $COUNT times"
fi

printf "%s\n%s\n" "$INTERVAL" "$COUNT" | python3 /usr/share/aut/autoTOR.py
```

## Practical Examples

### Example 1: Web Scraping with IP Rotation
```python
#!/usr/bin/env python3
import requests
import time
from autoTOR import change, ma_ip

def scrape_with_rotation(urls, change_every=5):
    """Scrape URLs with automatic IP rotation"""
    session = requests.Session()
    session.proxies = {
        'http': 'socks5://127.0.0.1:9050',
        'https': 'socks5://127.0.0.1:9050'
    }
    
    for i, url in enumerate(urls):
        # Change IP every N requests
        if i > 0 and i % change_every == 0:
            print(f"Changing IP after {change_every} requests...")
            change()
            time.sleep(2)  # Wait for new circuit
        
        try:
            print(f"Scraping: {url} (IP: {ma_ip().strip()})")
            response = session.get(url, timeout=10)
            print(f"  Status: {response.status_code}")
            
            # Process response here
            # save_data(response.text)
            
        except Exception as e:
            print(f"  Error: {e}")
        
        time.sleep(1)  # Be nice to servers

# Usage
urls = [
    'http://httpbin.org/ip',
    'http://httpbin.org/user-agent',
    'http://httpbin.org/headers',
    # Add more URLs...
]

scrape_with_rotation(urls, change_every=3)
```

### Example 2: Testing Geographic Restrictions
```python
#!/usr/bin/env python3
import requests
import json
from autoTOR import change, ma_ip

def test_geo_restrictions(test_urls, max_attempts=10):
    """Test access to geo-restricted content"""
    results = []
    
    for attempt in range(max_attempts):
        change()
        time.sleep(3)
        
        current_ip = ma_ip().strip()
        
        # Get location info
        try:
            geo_response = requests.get(
                f'http://ipinfo.io/{current_ip}/json',
                proxies={'http': 'socks5://127.0.0.1:9050',
                        'https': 'socks5://127.0.0.1:9050'}
            )
            location = geo_response.json()
            country = location.get('country', 'Unknown')
            city = location.get('city', 'Unknown')
        except:
            country = 'Unknown'
            city = 'Unknown'
        
        print(f"Attempt {attempt + 1}: IP {current_ip} ({city}, {country})")
        
        # Test each URL
        for url in test_urls:
            try:
                response = requests.get(
                    url,
                    proxies={'http': 'socks5://127.0.0.1:9050',
                            'https': 'socks5://127.0.0.1:9050'},
                    timeout=10
                )
                accessible = response.status_code == 200
                print(f"  {url}: {'✓' if accessible else '✗'}")
                
                results.append({
                    'ip': current_ip,
                    'country': country,
                    'city': city,
                    'url': url,
                    'accessible': accessible,
                    'status_code': response.status_code
                })
            except Exception as e:
                print(f"  {url}: Error ({e})")
    
    return results

# Usage
test_urls = [
    'https://www.bbc.co.uk/iplayer',
    'https://www.hulu.com',
    'https://www.netflix.com',
]

results = test_geo_restrictions(test_urls, max_attempts=5)
```

### Example 3: Privacy-Enhanced Browsing Session
```bash
#!/bin/bash
# privacy-session.sh

echo "Starting privacy-enhanced browsing session..."

# Start Tor IP changer in background
aut &
AUTO_TOR_PID=$!

# Start Firefox with Tor proxy
firefox --new-instance --private-window \
        --proxy-server="socks5://127.0.0.1:9050" &
FIREFOX_PID=$!

echo "Privacy session started!"
echo "Auto Tor PID: $AUTO_TOR_PID"
echo "Firefox PID: $FIREFOX_PID"
echo "Press any key to stop session..."

read -n 1

# Cleanup
kill $AUTO_TOR_PID 2>/dev/null
kill $FIREFOX_PID 2>/dev/null

echo "Privacy session ended."
```

## Monitoring and Logging

### Basic Logging Setup
```python
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('auto_tor.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

def logged_change():
    """Enhanced change function with logging"""
    old_ip = ma_ip()
    start_time = datetime.now()
    
    logger.info(f"Starting IP change. Current IP: {old_ip}")
    
    os.system("service tor reload")
    time.sleep(2)
    
    new_ip = ma_ip()
    end_time = datetime.now()
    duration = (end_time - start_time).total_seconds()
    
    if old_ip != new_ip:
        logger.info(f"IP changed successfully: {old_ip} -> {new_ip} ({duration:.2f}s)")
    else:
        logger.warning(f"IP change may have failed. Still showing: {old_ip}")
    
    print(f'[+] Your IP has been Changed to: {new_ip}')
```

### Real-time Monitoring Dashboard
```python
#!/usr/bin/env python3
import curses
import time
import threading
from datetime import datetime

class TorMonitor:
    def __init__(self):
        self.current_ip = "Unknown"
        self.change_count = 0
        self.last_change = "Never"
        self.status = "Stopped"
        self.running = False
    
    def start_monitoring(self, stdscr):
        """Start the monitoring interface"""
        curses.curs_set(0)  # Hide cursor
        stdscr.nodelay(1)   # Non-blocking input
        
        while True:
            stdscr.clear()
            
            # Header
            stdscr.addstr(0, 0, "=== Auto Tor IP Changer Monitor ===", curses.A_BOLD)
            stdscr.addstr(2, 0, f"Current IP: {self.current_ip}")
            stdscr.addstr(3, 0, f"Status: {self.status}")
            stdscr.addstr(4, 0, f"Changes: {self.change_count}")
            stdscr.addstr(5, 0, f"Last Change: {self.last_change}")
            stdscr.addstr(7, 0, "Press 'q' to quit, 'c' to force change")
            
            # Check for user input
            key = stdscr.getch()
            if key == ord('q'):
                break
            elif key == ord('c'):
                self.force_change()
            
            stdscr.refresh()
            time.sleep(1)
    
    def force_change(self):
        """Force an IP change"""
        self.status = "Changing..."
        change()
        self.current_ip = ma_ip().strip()
        self.change_count += 1
        self.last_change = datetime.now().strftime("%H:%M:%S")
        self.status = "Active"

# Usage
monitor = TorMonitor()
curses.wrapper(monitor.start_monitoring)
```

### Log Analysis Tools
```bash
#!/bin/bash
# analyze-logs.sh

LOG_FILE="auto_tor.log"

echo "=== Auto Tor Log Analysis ==="
echo

echo "Total IP changes:"
grep -c "IP changed successfully" $LOG_FILE

echo
echo "Average change duration:"
grep "IP changed successfully" $LOG_FILE | \
grep -o '([0-9.]*s)' | \
sed 's/[()]//g; s/s//' | \
awk '{sum+=$1; count++} END {print sum/count "s"}'

echo
echo "Most recent changes:"
tail -10 $LOG_FILE | grep "IP changed successfully"

echo
echo "Failed changes:"
grep -c "IP change may have failed" $LOG_FILE
```

## Performance Tuning

### Tor Optimization
```bash
# Edit /etc/tor/torrc for better performance
sudo nano /etc/tor/torrc

# Add these optimizations:
CircuitBuildTimeout 10
LearnCircuitBuildTimeout 0
CircuitIdleTimeout 30
NewCircuitPeriod 15
MaxCircuitDirtiness 300
KeepalivePeriod 60
```

### System Optimization
```bash
# Increase file descriptor limits
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf

# Optimize network settings
echo "net.core.rmem_max = 16777216" | sudo tee -a /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Fast IP Change Method
```python
def quick_ip_change():
    """Faster IP change using Tor control protocol"""
    import socket
    
    try:
        # Connect to Tor control port
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(5)
            s.connect(('127.0.0.1', 9051))
            
            # Authenticate (assuming no password)
            s.send(b'AUTHENTICATE ""\r\n')
            response = s.recv(1024)
            
            if b'250 OK' in response:
                # Request new circuit
                s.send(b'SIGNAL NEWNYM\r\n')
                response = s.recv(1024)
                
                if b'250 OK' in response:
                    time.sleep(1)  # Brief wait
                    return True
    except Exception as e:
        print(f"Fast change failed: {e}")
    
    # Fallback to service reload
    os.system("service tor reload")
    return False
```

## Security Considerations

### Operational Security (OpSec)

#### 1. DNS Leak Prevention
```bash
# Check for DNS leaks
curl --socks5-hostname 127.0.0.1:9050 https://www.dnsleaktest.com

# Configure system DNS to prevent leaks
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
```

#### 2. Browser Fingerprinting Protection
```javascript
// Firefox about:config settings
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("geo.enabled", false);
user_pref("webgl.disabled", true);
```

#### 3. Time Zone Anonymization
```bash
# Set timezone to UTC for anonymity
sudo timedatectl set-timezone UTC
```

### Access Control
```bash
# Restrict access to Tor data directory
sudo chmod 700 /var/lib/tor

# Create dedicated user for Tor operations
sudo useradd -r -s /bin/false toruser
sudo chown -R toruser:toruser /var/lib/tor
```

### Monitoring for Compromise
```python
def security_check():
    """Perform basic security checks"""
    checks = []
    
    # Check if using Tor
    try:
        response = requests.get('https://check.torproject.org/api/ip',
                              proxies={'https': 'socks5://127.0.0.1:9050'})
        data = response.json()
        checks.append(("Using Tor", data.get('IsTor', False)))
    except:
        checks.append(("Using Tor", False))
    
    # Check for DNS leaks
    try:
        # This would need a proper DNS leak test service
        checks.append(("DNS Secure", True))  # Placeholder
    except:
        checks.append(("DNS Secure", False))
    
    return checks

# Run security check
for check, status in security_check():
    print(f"{check}: {'✓' if status else '✗'}")
```

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: "Service tor not found"
**Symptoms:**
- Error when trying to change IP
- `service tor reload` fails

**Solutions:**
```bash
# Check if Tor is installed
which tor

# Install Tor if missing
sudo apt update
sudo apt install tor

# Check service status
sudo systemctl status tor

# Start and enable Tor
sudo systemctl start tor
sudo systemctl enable tor
```

#### Issue 2: "Connection refused" on port 9050
**Symptoms:**
- Can't get IP address
- Proxy connection errors

**Solutions:**
```bash
# Check if Tor is listening on correct port
netstat -tlnp | grep 9050

# Check Tor configuration
sudo nano /etc/tor/torrc
# Ensure: SocksPort 9050

# Restart Tor with correct config
sudo systemctl restart tor

# Check firewall
sudo ufw status
sudo ufw allow 9050
```

#### Issue 3: IP Not Changing
**Symptoms:**
- Same IP after reload
- Change appears successful but IP unchanged

**Solutions:**
```bash
# Force new circuit
echo -e 'AUTHENTICATE ""\r\nSIGNAL NEWNYM\r\nQUIT' | nc 127.0.0.1 9051

# Check Tor logs for errors
sudo journalctl -u tor -f

# Verify Tor configuration
tor --verify-config

# Try alternative change method
sudo systemctl restart tor  # Instead of reload
```

#### Issue 4: Permission Denied Errors
**Symptoms:**
- Can't execute service commands
- Installation fails

**Solutions:**
```bash
# Run with sudo
sudo python3 autoTOR.py

# Add user to sudoers for specific commands
echo "$USER ALL=(ALL) NOPASSWD: /usr/sbin/service tor reload" | sudo tee -a /etc/sudoers

# Use systemctl instead of service
sudo systemctl reload tor
```

#### Issue 5: Slow IP Changes
**Symptoms:**
- Long delays during IP changes
- Timeouts

**Solutions:**
```bash
# Optimize Tor configuration
sudo nano /etc/tor/torrc

# Add these lines:
CircuitBuildTimeout 10
NewCircuitPeriod 15
MaxCircuitDirtiness 300

# Restart Tor
sudo systemctl restart tor

# Use control port method for faster changes
# (See Performance Tuning section)
```

### Diagnostic Commands
```bash
# Complete diagnostic script
#!/bin/bash
echo "=== Auto Tor Diagnostics ==="

echo "1. Checking Tor installation..."
which tor && echo "✓ Tor installed" || echo "✗ Tor not found"

echo "2. Checking Tor service..."
systemctl is-active tor && echo "✓ Tor running" || echo "✗ Tor not running"

echo "3. Checking port 9050..."
netstat -tlnp | grep 9050 > /dev/null && echo "✓ Port 9050 open" || echo "✗ Port 9050 not listening"

echo "4. Checking Python dependencies..."
python3 -c "import requests" && echo "✓ Requests available" || echo "✗ Requests not installed"

echo "5. Testing Tor connectivity..."
curl --socks5-hostname 127.0.0.1:9050 -s https://www.myexternalip.com/raw && echo "✓ Tor connectivity OK" || echo "✗ Tor connectivity failed"

echo "6. Checking permissions..."
groups | grep -q sudo && echo "✓ User has sudo" || echo "✗ User lacks sudo"
```

## FAQ

### Q: How often should I change my IP?
**A:** It depends on your use case:
- **Web browsing**: Every 30-60 minutes
- **Web scraping**: Every 5-20 requests
- **High privacy**: Every 10-15 minutes
- **Testing**: Every 30 seconds to 2 minutes

### Q: Does this work with IPv6?
**A:** The current version primarily works with IPv4. For IPv6 support, you would need to:
- Configure Tor for IPv6: `IPv6Exit 1` in torrc
- Use IPv6-capable IP checking services
- Modify the IP detection code

### Q: Can I use this with VPN?
**A:** Yes, you can layer Tor over VPN:
1. Connect to VPN first
2. Start Tor service
3. Run Auto Tor IP Changer
This provides VPN → Tor routing for enhanced privacy.

### Q: How secure is this tool?
**A:** The tool itself is relatively simple and relies on Tor's security. Security depends on:
- Proper Tor configuration
- Browser settings
- Operational security practices
- Regular updates

### Q: Can I run multiple instances?
**A:** Running multiple instances simultaneously is not recommended as they would conflict over the Tor service. Instead, use a single instance with appropriate timing.

### Q: How do I update the tool?
**A:**
```bash
cd Auto_Tor_IP_changer
git pull origin master
# Re-run installer if needed
python3 install.py
```

### Q: What if I get blocked by websites?
**A:** Some websites block Tor exit nodes. Solutions:
- Use different exit nodes: Configure `ExitNodes` in torrc
- Combine with legitimate browsing patterns
- Use residential proxy services for sensitive sites
- Consider the legal and ethical implications

### Q: How much bandwidth does this use?
**A:** Minimal bandwidth for IP changes (~1-5 KB per change). However, establishing new Tor circuits uses more bandwidth (~50-200 KB per circuit).

This comprehensive user guide covers all aspects of using the Auto Tor IP Changer tool, from basic installation to advanced configuration and troubleshooting.