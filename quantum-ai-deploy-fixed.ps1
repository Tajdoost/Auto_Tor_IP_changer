# TerraQuantum Web3 AI Deployment Script (Fixed Version)
# This script fixes the common dependency issues

param(
    [string]$VenvPath = "quantum_venv",
    [switch]$ForceReinstall = $false
)

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "INFO" { "Green" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        default { "White" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Test-PythonInstallation {
    try {
        $pythonVersion = python --version 2>&1
        Write-Log "Python detected: $pythonVersion"
        return $true
    }
    catch {
        Write-Log "Python not found in PATH" "ERROR"
        return $false
    }
}

function Install-FixedPackage {
    param([string]$Package, [string]$Description)
    
    Write-Log "Installing $Description..."
    
    # Handle special cases for problematic packages
    switch -Regex ($Package) {
        "corsheaders" {
            $Package = "django-cors-headers==4.3.1"
            Write-Log "Fixed corsheaders -> django-cors-headers==4.3.1" "WARN"
        }
        "tensorflow==2\.15\.0" {
            $Package = "tensorflow>=2.16.1"
            Write-Log "Updated TensorFlow to latest available version" "WARN"
        }
        "torch==2\.1\.0" {
            $Package = "torch>=2.2.0"
            Write-Log "Updated PyTorch to latest available version" "WARN"
        }
        "opencv-python==4\.8\.0" {
            $Package = "opencv-python>=4.8.0.74"
            Write-Log "Updated OpenCV to latest available version" "WARN"
        }
    }
    
    $installCommand = "pip install `"$Package`""
    
    try {
        Invoke-Expression $installCommand
        if ($LASTEXITCODE -eq 0) {
            Write-Log "$Description installed successfully"
        } else {
            Write-Log "Failed to install $Description" "ERROR"
        }
    }
    catch {
        Write-Log "Exception installing $Description : $_" "ERROR"
    }
}

# Main deployment logic
Write-Log "🚀 Starting TerraQuantum Web3 AI Ecosystem with Fixed Dependencies"

# Check Python installation
if (-not (Test-PythonInstallation)) {
    Write-Log "Please install Python 3.8+ and add it to PATH" "ERROR"
    exit 1
}

# Check and create virtual environment
if (Test-Path $VenvPath) {
    Write-Log "Virtual environment exists at $VenvPath"
    if ($ForceReinstall) {
        Write-Log "Force reinstall flag set, removing existing environment"
        Remove-Item -Recurse -Force $VenvPath
        python -m venv $VenvPath
    }
} else {
    Write-Log "Creating new virtual environment..."
    python -m venv $VenvPath
}

# Activate virtual environment
$activateScript = Join-Path $VenvPath "Scripts\Activate.ps1"
if (Test-Path $activateScript) {
    Write-Log "Activating virtual environment..."
    & $activateScript
} else {
    Write-Log "Could not find activation script" "ERROR"
    exit 1
}

# Upgrade pip first
Write-Log "Upgrading pip..."
python -m pip install --upgrade pip

# Install fixed dependencies
$dependencies = @(
    @{Package="django==4.2.6"; Description="Django Framework"},
    @{Package="djangorestframework==3.14.0"; Description="Django REST Framework"},
    @{Package="django-cors-headers==4.3.1"; Description="Django CORS Headers (Fixed)"},
    @{Package="numpy==1.26.0"; Description="NumPy"},
    @{Package="pandas==2.3.1"; Description="Pandas"},
    @{Package="qiskit==0.45.0"; Description="Qiskit Quantum Computing"},
    @{Package="pennylane==0.34.0"; Description="PennyLane Quantum ML"},
    @{Package="rasterio==1.3.9"; Description="Rasterio"},
    @{Package="tensorflow>=2.16.1"; Description="TensorFlow (Updated)"},
    @{Package="torch>=2.2.0"; Description="PyTorch (Updated)"},
    @{Package="opencv-python>=4.8.0.74"; Description="OpenCV (Updated)"}
)

foreach ($dep in $dependencies) {
    Install-FixedPackage -Package $dep.Package -Description $dep.Description
}

Write-Log "✅ Dependencies installation completed!"

# Provide Django configuration guidance
Write-Log "📋 Important Django Configuration Notes:" "WARN"
Write-Host @"
In your Django settings.py, ensure you have:

INSTALLED_APPS = [
    # ... other apps
    'rest_framework',
    'corsheaders',  # Note: 'corsheaders', not 'django-cors-headers'
    # ... your apps
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    # ... other middleware
]

# CORS settings for development
CORS_ALLOW_ALL_ORIGINS = True
"@

Write-Log "🎯 Next Steps:"
Write-Log "1. Update your Django settings.py with the CORS configuration above"
Write-Log "2. Run: python manage.py migrate"
Write-Log "3. Run: python manage.py collectstatic"
Write-Log "4. Run: python manage.py runserver"

Write-Log "🔧 If you encounter issues:"
Write-Log "- Verify 'corsheaders' is in INSTALLED_APPS (not 'django-cors-headers')"
Write-Log "- Check that CorsMiddleware is first in MIDDLEWARE"
Write-Log "- Run 'pip list' to verify package installations"