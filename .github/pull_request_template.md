---
name: pull_request_template
description: Standard PR template for Zero-Touch-NinjaTrader changes.
type: reference
---
# Pull Request

## Summary
- 

## What changed
- 

## Validation
- [ ] `dotnet restore .\ZeroTouchNinjaTrader.sln`
- [ ] `dotnet build .\ZeroTouchNinjaTrader.sln -c Release`
- [ ] `dotnet test .\ZeroTouchNinjaTrader.sln -c Release`
- [ ] CI workflow passed
- [ ] Packaging output reviewed

## Deployment impact
- [ ] No deployment impact
- [ ] Affects CI packaging
- [ ] Affects self-hosted runner deployment
- [ ] Affects promotion/manual approval flow

## Notes for reviewers
- 
