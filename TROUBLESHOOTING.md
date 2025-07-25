# TerraQuantum Django Project - Troubleshooting Guide

## Common Dependency Issues and Fixes

### 1. CORS Headers Error
**Error:** `ModuleNotFoundError: No module named 'corsheaders'`

**Cause:** The package name in PyPI is `django-cors-headers`, not `corsheaders`

**Fix:**
```bash
pip uninstall corsheaders
pip install django-cors-headers==4.3.1
```

**Django Settings Update:**
```python
INSTALLED_APPS = [
    # ... other apps
    'corsheaders',  # Note: use 'corsheaders' in settings, not 'django-cors-headers'
    # ... 
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    # ... other middleware
]

# CORS configuration
CORS_ALLOW_ALL_ORIGINS = True  # For development only
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]
```

### 2. TensorFlow Version Error
**Error:** `ERROR: Could not find a version that satisfies the requirement tensorflow==2.15.0`

**Cause:** TensorFlow 2.15.0 is no longer available on PyPI

**Fix:**
```bash
pip install tensorflow>=2.16.1
```

### 3. PyTorch Version Error
**Error:** `ERROR: Could not find a version that satisfies the requirement torch==2.1.0`

**Cause:** PyTorch 2.1.0 is no longer available

**Fix:**
```bash
pip install torch>=2.2.0
```

### 4. OpenCV Version Error
**Error:** `ERROR: Could not find a version that satisfies the requirement opencv-python==4.8.0`

**Cause:** The exact version is no longer available

**Fix:**
```bash
pip install opencv-python>=4.8.0.74
```

## Complete Fix Commands

### Option 1: Quick Fix
```bash
# Navigate to your Django project directory
cd D:\goldddddddddddddddddscan\

# Activate virtual environment
.\quantum_venv\Scripts\activate

# Install correct packages
pip install django-cors-headers==4.3.1
pip install tensorflow>=2.16.1
pip install torch>=2.2.0
pip install opencv-python>=4.8.0.74

# Test Django
python manage.py check
```

### Option 2: Use the Fix Script
```bash
# Copy the fix_quantum_dependencies.py to your project directory
# Then run:
python fix_quantum_dependencies.py
```

### Option 3: Use the Fixed PowerShell Script
```powershell
# Run the fixed deployment script
.\quantum-ai-deploy-fixed.ps1
```

## Verification Steps

1. **Check installed packages:**
```bash
pip list | grep -E "(django|tensorflow|torch|opencv|cors)"
```

2. **Test Django configuration:**
```bash
python manage.py check
```

3. **Test Django startup:**
```bash
python manage.py runserver --dry-run
```

## Django Settings Template

Create or update your `settings.py`:

```python
import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'your-secret-key-here'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['localhost', '127.0.0.1']

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    # Third party apps
    'rest_framework',
    'corsheaders',
    
    # Your quantum apps
    # 'quantum_ai',
    # 'terra_quantum',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'your_project.urls'

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# CORS settings
CORS_ALLOW_ALL_ORIGINS = True  # For development only
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://localhost:8000",
    "http://127.0.0.1:8000",
]

# REST Framework settings
REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.AllowAny',
    ],
    'DEFAULT_RENDERER_CLASSES': [
        'rest_framework.renderers.JSONRenderer',
    ],
}

# Static files
STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'

# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
```

## Additional Notes

- Always activate your virtual environment before installing packages
- Use `pip list` to verify package installations
- The package name in PyPI vs. Django settings can be different (e.g., `django-cors-headers` vs. `corsheaders`)
- Keep your `requirements.txt` updated with working versions
- Consider using `pip freeze > requirements.txt` after successful installation

## Support

If you continue to experience issues:
1. Check the error logs carefully
2. Verify Python and pip versions
3. Try creating a fresh virtual environment
4. Consult the Django and package documentation