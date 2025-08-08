# SQLMesh DuckLake Tutorial Setup Script
Write-Host "Setting up SQLMesh DuckLake Tutorial..." -ForegroundColor Green

# Check if Python is installed
try {
    python --version
} catch {
    Write-Host "Python is not installed or not in PATH. Please install Python 3.8+ first." -ForegroundColor Red
    exit 1
}

# Create virtual environment if it doesn't exist
if (-not (Test-Path ".venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv .venv
}

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& ".venv\Scripts\Activate.ps1"

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt

# Create data directories if they don't exist
if (-not (Test-Path "data\storage")) {
    New-Item -ItemType Directory -Path "data\storage" -Force
}

# Initialize DuckLake
Write-Host "Initializing DuckLake..." -ForegroundColor Yellow
$duckdbCommands = @"
INSTALL ducklake;
ATTACH 'ducklake:data/catalog.ducklake' AS my_ducklake (DATA_PATH 'data/storage/');
USE my_ducklake;
.exit
"@

$duckdbCommands | duckdb data/sqlmesh_state.db

# Initialize SQLMesh
Write-Host "Initializing SQLMesh..." -ForegroundColor Yellow
sqlmesh migrate

Write-Host "Setup complete! You can now run 'sqlmesh plan dev' to start the pipeline." -ForegroundColor Green
Write-Host "Remember to activate the virtual environment: .venv\Scripts\Activate.ps1" -ForegroundColor Cyan
