#!/bin/bash

# 🔒 Secure Release Build Script with Obfuscation
# Usage: ./scripts/build_release.sh [apk|appbundle|ios]

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔒 Weather App - Secure Release Build${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ .env file not found!${NC}"
    echo "Please create .env file with required variables"
    exit 1
fi

# Build type (default: appbundle)
BUILD_TYPE=${1:-appbundle}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OBFUSCATION_DIR="build/obfuscation/$TIMESTAMP"

echo -e "${YELLOW}📋 Build Configuration:${NC}"
echo "  • Type: $BUILD_TYPE"
echo "  • Obfuscation: Enabled"
echo "  • Debug Info: $OBFUSCATION_DIR"
echo ""

# Clean previous builds
echo -e "${BLUE}🧹 Cleaning previous builds...${NC}"
flutter clean
flutter pub get

# Create obfuscation directory
mkdir -p "$OBFUSCATION_DIR"

# Run build based on type
case $BUILD_TYPE in
    apk)
        echo -e "${BLUE}🔨 Building obfuscated APK...${NC}"
        flutter build apk --release \
            --obfuscate \
            --split-debug-info="$OBFUSCATION_DIR" \
            --split-per-abi
        
        BUILD_OUTPUT="build/app/outputs/flutter-apk/"
        ;;
    
    appbundle)
        echo -e "${BLUE}🔨 Building obfuscated App Bundle...${NC}"
        flutter build appbundle --release \
            --obfuscate \
            --split-debug-info="$OBFUSCATION_DIR"
        
        BUILD_OUTPUT="build/app/outputs/bundle/release/"
        ;;
    
    ios)
        echo -e "${BLUE}🔨 Building obfuscated iOS IPA...${NC}"
        flutter build ipa --release \
            --obfuscate \
            --split-debug-info="$OBFUSCATION_DIR"
        
        BUILD_OUTPUT="build/ios/archive/"
        ;;
    
    *)
        echo -e "${RED}❌ Invalid build type: $BUILD_TYPE${NC}"
        echo "Usage: $0 [apk|appbundle|ios]"
        exit 1
        ;;
esac

# Check build success
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Build completed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}📦 Output Files:${NC}"
    ls -lh "$BUILD_OUTPUT"
    echo ""
    echo -e "${YELLOW}🔐 Debug Symbols:${NC}"
    ls -lh "$OBFUSCATION_DIR"
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🎉 Release build ready for distribution!${NC}"
    echo -e "${YELLOW}⚠️  Save debug symbols for crash reporting${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
else
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi
