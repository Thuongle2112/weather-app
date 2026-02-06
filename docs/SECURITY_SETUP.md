# 🔒 Security & Environment Setup

## Overview

Dự án đã được audit và bảo mật với các biện pháp:
- ✅ API keys moved to environment variables
- ✅ Sensitive files gitignored
- ✅ Keystore protection
- ✅ Automated security scanning
- ✅ Code obfuscation enabled

## 🚀 Quick Setup

### 1. Clone and Configure

```bash
# Clone repository
git clone <your-repo-url>
cd weather-app

# Copy environment template
cp .env.example .env

# Edit with your API keys
nano .env
```

### 2. Required API Keys

Add these to your `.env` file:

```env
# OpenWeather API - Get from https://openweathermap.org/api
OPENWEATHER_API_KEY=your_key_here

# LocationIQ API - Get from https://locationiq.com/
LOCATIONIQ_API_KEY=your_key_here

# AdMob IDs - Get from https://admob.google.com/
ADMOB_BANNER_ID=ca-app-pub-xxx
ADMOB_INTERSTITIAL_ID=ca-app-pub-xxx
ADMOB_REWARDED_ID=ca-app-pub-xxx

# Application ID
APPLICATION_ID=com.zamoon6.weather_today
```

### 3. Firebase Setup

```bash
# Add Firebase configuration files (NOT committed to git)
# Android: android/app/google-services.json
# iOS: ios/Runner/GoogleService-Info.plist
```

### 4. Android Signing (Production Only)

```bash
# Create keystore (if not exists)
keytool -genkey -v -keystore android/app/my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

# Create key.properties
cat > android/key.properties << EOF
storePassword=<your-password>
keyPassword=<your-password>
keyAlias=my-key-alias
storeFile=my-release-key.jks
EOF
```

**⚠️ CRITICAL:** Never commit `.jks` files or `key.properties` to git!

## 🛡️ Security Features

### Gitignore Protection

Protected files (automatically ignored):
- ✅ `.env` and environment variables
- ✅ `*.jks` and `*.keystore` files
- ✅ `key.properties`
- ✅ `google-services.json`
- ✅ `GoogleService-Info.plist`
- ✅ Service account credentials
- ✅ Obfuscation symbols

### Environment Variables

All sensitive data loaded from `.env`:
- `OPENWEATHER_API_KEY` - Weather data API
- `LOCATIONIQ_API_KEY` - Maps and geocoding
- `ADMOB_*` - Advertisement IDs
- `APPLICATION_ID` - App bundle identifier

### Code Obfuscation

Release builds automatically obfuscated:
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/obfuscation
```

## 🔍 Security Scanning

### Automated Security Check

Run before every commit:
```bash
./scripts/security_check.sh
```

This checks for:
- Sensitive files in git
- Hardcoded API keys
- Missing .env variables
- Keystore protection
- .gitignore completeness
- Git history vulnerabilities

### Manual Checks

**Check for hardcoded secrets:**
```bash
grep -r "pk\.[a-zA-Z0-9]" lib/ --exclude-dir=.git
grep -r "AIza" lib/ --exclude-dir=.git | grep -v firebase_options
```

**Verify .env is not tracked:**
```bash
git ls-files | grep "\.env$"
# Should return nothing
```

**Check keystore protection:**
```bash
git ls-files | grep -E "\.jks|\.keystore"
# Should return nothing
```

## 📋 Security Checklist

Before committing code:
- [ ] Run `./scripts/security_check.sh`
- [ ] Verify no API keys in code
- [ ] Check .env is gitignored
- [ ] Ensure keystore files not staged
- [ ] Review git diff for sensitive data

Before releasing:
- [ ] Rotate any exposed API keys
- [ ] Verify obfuscation enabled
- [ ] Backup keystore and passwords
- [ ] Upload debug symbols to Firebase
- [ ] Test all features work with env vars

## 🚨 What to Do if Keys are Exposed

### 1. Immediate Actions

```bash
# 1. Rotate all exposed API keys immediately
# - OpenWeather: https://home.openweathermap.org/api_keys
# - LocationIQ: https://locationiq.com/dashboard
# - AdMob: https://admob.google.com/

# 2. Update .env with new keys
nano .env

# 3. Update CI/CD environment variables
# Go to Codemagic dashboard and update secrets
```

### 2. Clean Git History

```bash
# Install BFG Repo-Cleaner
brew install bfg

# Create password file with exposed keys
cat > passwords.txt << EOF
pk.28eeb40e74e9cbb71e80113c2cfc9cb6
pk.28454d5918e4f8f3a7a2a5efbd1df896
EOF

# Remove from history
bfg --replace-text passwords.txt
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push (coordinate with team!)
git push --force
```

### 3. Notify Team

- Inform all developers to pull latest changes
- Document incident in security log
- Review and improve security practices

## 📚 Related Documentation

- [SECURITY_AUDIT.md](docs/SECURITY_AUDIT.md) - Full security audit report
- [OBFUSCATION_GUIDE.md](docs/OBFUSCATION_GUIDE.md) - Code obfuscation setup
- [.env.example](.env.example) - Environment variables template

## 🔗 External Resources

- [Flutter Security Best Practices](https://docs.flutter.dev/security)
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [Git Secrets Detection](https://github.com/awslabs/git-secrets)

## 💡 Tips

1. **Never** commit `.env` files
2. **Always** use environment variables for secrets
3. **Rotate** API keys regularly
4. **Run** security check before commits
5. **Backup** keystore files securely (offline)
6. **Enable** two-factor auth on all accounts
7. **Review** dependencies for vulnerabilities
8. **Monitor** API usage for anomalies

## ⚙️ CI/CD Security

Codemagic automatically:
- ✅ Loads secrets from environment variables
- ✅ Builds with obfuscation enabled
- ✅ Saves debug symbols separately
- ✅ Doesn't expose secrets in logs
- ✅ Uses secure artifact storage

**Never** hardcode secrets in `codemagic.yaml`!

---

**Status:** 🔒 Secured  
**Last Audit:** 27/01/2026  
**Next Review:** Monthly
