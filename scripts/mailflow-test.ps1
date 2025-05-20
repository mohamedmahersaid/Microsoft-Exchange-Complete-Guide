
# Test mail flow from Exchange

$testUser = "testuser@domain.com"

Write-Host "Testing mail flow to $testUser..." -ForegroundColor Green

Test-Mailflow -TargetEmailAddress $testUser

Write-Host "Mailflow test completed." -ForegroundColor Cyan
