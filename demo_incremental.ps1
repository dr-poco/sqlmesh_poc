# Demo Script for Incremental Processing
Write-Host "SQLMesh DuckLake Incremental Processing Demo" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Activate virtual environment
& ".venv\Scripts\Activate.ps1"

# Step 1: Initial run
Write-Host "`nStep 1: Running initial pipeline..." -ForegroundColor Yellow
sqlmesh plan dev

# Step 2: Show initial results
Write-Host "`nStep 2: Initial results:" -ForegroundColor Yellow
sqlmesh fetchdf "SELECT * FROM analytics__dev.daily_revenue ORDER BY event_date"

# Step 3: Add new data
Write-Host "`nStep 3: Adding new data to seeds/raw_events.csv..." -ForegroundColor Yellow
$newData = @"
6,104,page_view,2025-08-05 14:00:00,0
7,104,purchase,2025-08-06 14:15:00,49.99
"@

Add-Content -Path "seeds/raw_events.csv" -Value $newData

# Step 4: Run incremental processing
Write-Host "`nStep 4: Running incremental processing..." -ForegroundColor Yellow
sqlmesh plan dev

# Step 5: Show updated results
Write-Host "`nStep 5: Updated results:" -ForegroundColor Yellow
sqlmesh fetchdf "SELECT * FROM analytics__dev.daily_revenue ORDER BY event_date"

# Step 6: Show differences between prod and dev
Write-Host "`nStep 6: Comparing prod vs dev environments..." -ForegroundColor Yellow
sqlmesh table_diff prod:dev analytics.daily_revenue --show-sample

# Step 7: Run incremental model in prod
Write-Host "`nStep 7: Running incremental model in production..." -ForegroundColor Yellow
sqlmesh run --ignore-cron

# Step 8: Promote changes to prod
Write-Host "`nStep 8: Promoting changes to production..." -ForegroundColor Yellow
sqlmesh plan

# Step 9: Verify environments match
Write-Host "`nStep 9: Verifying environments match..." -ForegroundColor Yellow
sqlmesh table_diff prod:dev analytics.daily_revenue

Write-Host "`nDemo complete! Check the results above to see incremental processing in action." -ForegroundColor Green
