#!/bin/bash

# Vue Stream Barcode Scanner - Setup Script
# This script helps you quickly set up and test the project

echo "🚀 Vue Stream Barcode Scanner - Setup"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found"
    echo "Please run this script from the project root directory"
    exit 1
fi

echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Installation failed"
    exit 1
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "🎯 What's next?"
echo ""
echo "1️⃣  Test the demo:"
echo "   npm run dev"
echo "   (Opens at https://localhost:5173)"
echo ""
echo "2️⃣  Build the library:"
echo "   npm run build"
echo ""
echo "3️⃣  Customize & publish:"
echo "   - Update package.json with your info"
echo "   - Update LICENSE with your name"
echo "   - See PUBLISH_GUIDE.md for details"
echo ""
echo "📚 Documentation:"
echo "   - README.md         → Main documentation"
echo "   - QUICKSTART.md     → Quick start guide"
echo "   - EXAMPLES.md       → Code examples"
echo "   - PUBLISH_GUIDE.md  → Publishing guide"
echo ""
echo "💡 Pro tip: Read PROJECT_SUMMARY.md for complete overview"
echo ""
echo "🎉 Happy coding!"

