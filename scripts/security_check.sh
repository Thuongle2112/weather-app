#!/bin/bash

# 🔒 Security Check Script
# Scans project for security vulnerabilities and exposed secrets

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔒 Security Audit - Weather App${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ISSUES_FOUND=0

# Check 1: Sensitive files in git
echo -e "${BLUE}📋 Checking for sensitive files in git...${NC}"
SENSITIVE_FILES=$(git ls-files | grep -E "\.jks|\.keystore|key\.properties|google-services\.json|\.env$|credentials.*\.json" || true)
if [ -n "$SENSITIVE_FILES" ]; then
    echo -e "${RED}❌ CRITICAL: Sensitive files found in git:${NC}"
    echo "$SENSITIVE_FILES"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ No sensitive files in git${NC}"
fi
echo ""

# Check 2: Hardcoded API keys
echo -e "${BLUE}🔑 Scanning for hardcoded API keys...${NC}"
HARDCODED_KEYS=$(grep -r -n -E "pk\.[a-zA-Z0-9]{30,}|sk\.[a-zA-Z0-9]{30,}|AIza[a-zA-Z0-9_-]{35}" lib/ --include="*.dart" --exclude-dir=".dart_tool" | grep -v "dotenv.env" | grep -v "firebase_options.dart" || true)
if [ -n "$HARDCODED_KEYS" ]; then
    echo -e "${RED}❌ WARNING: Possible hardcoded keys found:${NC}"
    echo "$HARDCODED_KEYS"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ No hardcoded API keys found${NC}"
fi
echo ""

# Check 3: .env file exists
echo -e "${BLUE}📄 Checking .env configuration...${NC}"
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ WARNING: .env file not found${NC}"
    echo "   Run: cp .env.example .env"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ .env file exists${NC}"
    
    # Check required variables
    REQUIRED_VARS=("OPENWEATHER_API_KEY" "ADMOB_BANNER_ID" "ADMOB_INTERSTITIAL_ID" "ADMOB_REWARDED_ID" "LOCATIONIQ_API_KEY")
    for VAR in "${REQUIRED_VARS[@]}"; do
        if ! grep -q "^$VAR=" .env; then
            echo -e "${YELLOW}   ⚠️  Missing: $VAR${NC}"
        fi
    done
fi
echo ""

# Check 4: Keystore files
echo -e "${BLUE}🔐 Checking keystore files...${NC}"
KEYSTORES=$(find android/app -name "*.jks" -o -name "*.keystore" 2>/dev/null || true)
if [ -n "$KEYSTORES" ]; then
    echo -e "${YELLOW}⚠️  Keystore files found:${NC}"
    echo "$KEYSTORES"
    
    # Check if they're gitignored
    for KEYSTORE in $KEYSTORES; do
        if git check-ignore -q "$KEYSTORE"; then
            echo -e "${GREEN}   ✅ $KEYSTORE is gitignored${NC}"
        else
            echo -e "${RED}   ❌ $KEYSTORE is NOT gitignored!${NC}"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
    done
else
    echo -e "${GREEN}✅ No keystore files in project${NC}"
fi
echo ""

# Check 5: Firebase config files
echo -e "${BLUE}🔥 Checking Firebase configuration...${NC}"
FIREBASE_FILES=$(find . -name "google-services.json" -o -name "GoogleService-Info.plist" 2>/dev/null | grep -v ".git" || true)
if [ -n "$FIREBASE_FILES" ]; then
    echo -e "${YELLOW}⚠️  Firebase config files found:${NC}"
    echo "$FIREBASE_FILES"
    
    for FILE in $FIREBASE_FILES; do
        if git check-ignore -q "$FILE"; then
            echo -e "${GREEN}   ✅ $FILE is gitignored${NC}"
        else
            echo -e "${RED}   ❌ $FILE is NOT gitignored!${NC}"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
    done
fi
echo ""

# Check 6: Git history scan
echo -e "${BLUE}📜 Scanning git history for sensitive data...${NC}"
HISTORY_SECRETS=$(git log --all --full-history --source --format="" --name-only | grep -E "\.jks|\.keystore|key\.properties|\.env$" | sort -u || true)
if [ -n "$HISTORY_SECRETS" ]; then
    echo -e "${YELLOW}⚠️  WARNING: Sensitive files found in git history:${NC}"
    echo "$HISTORY_SECRETS"
    echo -e "${YELLOW}   Consider using BFG Repo-Cleaner to remove them${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ No sensitive files in git history${NC}"
fi
echo ""

# Check 7: .gitignore validation
echo -e "${BLUE}📝 Validating .gitignore...${NC}"
REQUIRED_PATTERNS=("*.jks" "*.keystore" ".env" "google-services.json" "key.properties")
MISSING_PATTERNS=()
for PATTERN in "${REQUIRED_PATTERNS[@]}"; do
    if ! grep -q "$PATTERN" .gitignore; then
        MISSING_PATTERNS+=("$PATTERN")
    fi
done

if [ ${#MISSING_PATTERNS[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Missing patterns in .gitignore:${NC}"
    printf '   %s\n' "${MISSING_PATTERNS[@]}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo -e "${GREEN}✅ .gitignore is complete${NC}"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}🎉 Security check passed! No issues found.${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Found $ISSUES_FOUND security issue(s).${NC}"
    echo -e "${YELLOW}Please review and fix the issues above.${NC}"
    exit 1
fi
