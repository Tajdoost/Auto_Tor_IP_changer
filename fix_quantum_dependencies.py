#!/usr/bin/env python3
"""
Fix Quantum Django Project Dependencies
This script fixes the common dependency issues in Django quantum computing projects.
"""

import subprocess
import sys
import os
import re

def run_command(command, description=""):
    """Run a shell command and return the result."""
    print(f"[INFO] {description}")
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"[ERROR] Command failed: {command}")
            print(f"Error: {result.stderr}")
            return False
        print(f"[SUCCESS] {description}")
        return True
    except Exception as e:
        print(f"[ERROR] Exception running command: {e}")
        return False

def fix_corsheaders_package():
    """Fix the corsheaders package installation."""
    print("\n=== Fixing CORS Headers Package ===")
    
    # First, try to install the correct package name
    commands = [
        "pip install django-cors-headers==4.3.1",
        "pip uninstall corsheaders -y",  # Remove old incorrect package if exists
    ]
    
    for cmd in commands:
        run_command(cmd, f"Running: {cmd}")

def update_django_settings():
    """Update Django settings to use correct corsheaders import."""
    print("\n=== Updating Django Settings ===")
    
    # Common Django project paths to check
    possible_paths = [
        "settings.py",
        "*/settings.py",
        "*/settings/*.py",
        "config/settings.py",
        "project/settings.py"
    ]
    
    # This is a template for what should be in Django settings
    settings_template = '''
# Add to INSTALLED_APPS:
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'corsheaders',  # Note: just 'corsheaders', not 'django-cors-headers'
    # ... your other apps
]

# Add to MIDDLEWARE:
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    # ... other middleware
]

# CORS Settings:
CORS_ALLOW_ALL_ORIGINS = True  # For development only
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://localhost:8000",
    "http://127.0.0.1:8000",
]
'''
    
    print("[INFO] Django settings template created")
    print("[NOTE] You need to manually update your settings.py file with the correct corsheaders configuration")
    print(settings_template)

def install_fixed_dependencies():
    """Install the fixed dependencies."""
    print("\n=== Installing Fixed Dependencies ===")
    
    # Core dependencies that should work
    fixed_packages = [
        "django==4.2.6",
        "djangorestframework==3.14.0", 
        "django-cors-headers==4.3.1",
        "numpy==1.26.0",
        "pandas==2.3.1",
        "qiskit==0.45.0",
        "pennylane==0.34.0",
        "rasterio==1.3.9",
        # Updated ML packages
        "tensorflow>=2.16.1",  # Use latest available
        "torch>=2.2.0",        # Use latest available
        "opencv-python>=4.8.0.74",  # Use available version
    ]
    
    for package in fixed_packages:
        run_command(f"pip install '{package}'", f"Installing {package}")

def upgrade_pip():
    """Upgrade pip to latest version."""
    print("\n=== Upgrading pip ===")
    run_command("python -m pip install --upgrade pip", "Upgrading pip")

def main():
    """Main function to fix all dependency issues."""
    print("🚀 TerraQuantum Django Project Dependency Fixer")
    print("=" * 50)
    
    # Step 1: Upgrade pip
    upgrade_pip()
    
    # Step 2: Fix corsheaders
    fix_corsheaders_package()
    
    # Step 3: Install fixed dependencies
    install_fixed_dependencies()
    
    # Step 4: Provide Django settings guidance
    update_django_settings()
    
    print("\n✅ Dependency fixes completed!")
    print("\n📋 Next steps:")
    print("1. Update your Django settings.py with the corsheaders configuration shown above")
    print("2. Run: python manage.py collectstatic")
    print("3. Run: python manage.py migrate")
    print("4. Run: python manage.py runserver")
    
    print("\n🔧 If you still have issues:")
    print("- Check that 'corsheaders' (not 'django-cors-headers') is in INSTALLED_APPS")
    print("- Ensure CorsMiddleware is first in MIDDLEWARE list")
    print("- Use pip list to verify all packages are installed correctly")

if __name__ == "__main__":
    main()