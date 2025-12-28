#!/bin/bash

# Engineer Life Simulator - Project Setup Script
# This script helps create an Xcode project for the app

echo "🚀 Engineer Life Simulator - Project Setup"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "EngineerLifeSimulatorApp.swift" ]; then
    echo "❌ Error: EngineerLifeSimulatorApp.swift not found!"
    echo "Please run this script from the EngineerLifeSimulator directory."
    exit 1
fi

echo "✅ Found project files"
echo ""

# Check for Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed or not in PATH"
    echo "Please install Xcode from the Mac App Store"
    exit 1
fi

echo "✅ Xcode found: $(xcodebuild -version | head -n 1)"
echo ""

# Check if project already exists
if [ -d "EngineerLifeSimulator.xcodeproj" ]; then
    echo "⚠️  Warning: EngineerLifeSimulator.xcodeproj already exists"
    read -p "Do you want to recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf EngineerLifeSimulator.xcodeproj
        echo "🗑️  Removed existing project"
    else
        echo "Keeping existing project. Opening in Xcode..."
        open EngineerLifeSimulator.xcodeproj
        exit 0
    fi
fi

echo "📦 Creating Xcode project..."
echo ""

# Create a Package.swift file for SPM
cat > Package.swift << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EngineerLifeSimulator",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "EngineerLifeSimulator",
            targets: ["EngineerLifeSimulator"])
    ],
    targets: [
        .executableTarget(
            name: "EngineerLifeSimulator",
            dependencies: [],
            path: ".",
            sources: [
                "EngineerLifeSimulatorApp.swift",
                "GameModels.swift",
                "GameStoreNPCExtension.swift",
                "AssetEngine.swift",
                "VisualIntegrationHub.swift",
                "MetalAssetRenderer.swift",
                "PlayerCustomizationEngine.swift",
                "Enhanced3DAssetViews.swift",
                "PlayerCustomizationViews.swift",
                "ModernGameViews.swift",
                "ModernShopViews.swift",
                "ModernViews.swift",
                "MajorMinorViews.swift",
                "TeamViews.swift",
                "DisciplineViews.swift",
                "DisciplineExtensions.swift",
                "MetalRenderer.swift",
                "NPCEngine.swift",
                "MLPredictor.swift",
                "Metal4MLPipeline.swift",
                "EngineeringDisciplines.swift",
                "DynamicVisualSystem.swift",
                "DynamicVisualIntegration.swift",
                "DynamicVisualView.swift"
            ],
            resources: [
                .process("AdvancedShaders.metal"),
                .process("Shaders.metal")
            ]
        )
    ]
)
EOF

echo "✅ Created Package.swift"
echo ""

# Count Swift files
SWIFT_COUNT=$(ls -1 *.swift 2>/dev/null | wc -l | tr -d ' ')
METAL_COUNT=$(ls -1 *.metal 2>/dev/null | wc -l | tr -d ' ')

echo "📊 Project Statistics:"
echo "   - Swift files: $SWIFT_COUNT"
echo "   - Metal shader files: $METAL_COUNT"
echo ""

# Generate Xcode project from Package.swift
echo "🔨 Generating Xcode project..."
swift package generate-xcodeproj 2>/dev/null

if [ -d "EngineerLifeSimulator.xcodeproj" ]; then
    echo "✅ Xcode project created successfully!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Open EngineerLifeSimulator.xcodeproj in Xcode"
    echo "   2. Select your development team in Signing & Capabilities"
    echo "   3. Build the project (⌘B)"
    echo "   4. Run the app (⌘R)"
    echo ""
    read -p "Would you like to open the project now? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        open EngineerLifeSimulator.xcodeproj
        echo "🎉 Opening Xcode..."
    fi
else
    echo "❌ Failed to generate Xcode project"
    echo ""
    echo "Alternative: Create project manually in Xcode"
    echo "   1. Open Xcode"
    echo "   2. File → New → Project"
    echo "   3. macOS → App"
    echo "   4. Name: EngineerLifeSimulator"
    echo "   5. Interface: SwiftUI"
    echo "   6. Add all .swift and .metal files to the project"
    echo ""
    echo "See BUILD_GUIDE.md for detailed instructions"
fi

echo ""
echo "📚 Documentation available:"
echo "   - BUILD_GUIDE.md - Detailed build instructions"
echo "   - QUICK_START.md - How to use the app"
echo "   - METAL_INTEGRATION_GUIDE.md - Graphics system details"
echo ""
echo "✨ Happy coding!"
