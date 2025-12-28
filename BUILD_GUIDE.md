# Build Guide - Engineer Life Simulator

## 🛠️ Setting Up the Project

This guide will help you create an Xcode project and build the app successfully.

## Prerequisites

- **macOS**: 13.0 (Ventura) or later
- **Xcode**: 15.0 or later
- **Swift**: 5.9 or later
- **Metal Support**: Required (built into modern Macs)

## Step 1: Create Xcode Project

### Option A: Using Xcode GUI

1. Open Xcode
2. Select "Create a new Xcode project"
3. Choose **macOS** → **App**
4. Configure:
   - Product Name: `EngineerLifeSimulator`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
   - Include Tests: Optional
5. Choose your Downloads folder as location
6. Click "Create"

### Option B: Using Command Line

```bash
cd /Users/jaysshit/Downloads/EngineerLifeSimulator

# Create Package.swift (for SPM) or use Xcode project
```

## Step 2: Add Files to Project

### If you created a new project:

1. Delete the default `ContentView.swift` and app file Xcode created
2. In Xcode, right-click the project folder
3. Select "Add Files to EngineerLifeSimulator..."
4. Select all `.swift` files in the folder
5. Ensure "Copy items if needed" is **unchecked** (files are already in place)
6. Click "Add"

### File Organization (recommended):

Create groups in Xcode for better organization:

```
EngineerLifeSimulator/
├── App
│   └── EngineerLifeSimulatorApp.swift
├── Core
│   ├── GameModels.swift
│   ├── GameStoreNPCExtension.swift
│   └── AssetEngine.swift
├── Metal Graphics
│   ├── VisualIntegrationHub.swift
│   ├── MetalAssetRenderer.swift
│   ├── PlayerCustomizationEngine.swift
│   ├── Enhanced3DAssetViews.swift
│   ├── PlayerCustomizationViews.swift
│   ├── MetalRenderer.swift
│   ├── AdvancedShaders.metal
│   └── Shaders.metal
├── UI Views
│   ├── ModernGameViews.swift
│   ├── ModernShopViews.swift
│   ├── ModernViews.swift
│   ├── MajorMinorViews.swift
│   ├── TeamViews.swift
│   └── DynamicVisualView.swift
├── Systems
│   ├── NPCEngine.swift
│   ├── MLPredictor.swift
│   ├── Metal4MLPipeline.swift
│   ├── DynamicVisualSystem.swift
│   ├── DynamicVisualIntegration.swift
│   ├── EngineeringDisciplines.swift
│   ├── DisciplineViews.swift
│   └── DisciplineExtensions.swift
└── Documentation
    ├── README.md
    ├── QUICK_START.md
    ├── METAL_INTEGRATION_GUIDE.md
    └── ... (other .md files)
```

## Step 3: Configure Build Settings

### 1. Target Settings

In Xcode:
1. Select your project in the navigator
2. Select the target "EngineerLifeSimulator"
3. Go to "Signing & Capabilities"
4. Select your Team (or use personal team)

### 2. Deployment Target

1. Go to "General" tab
2. Set "Minimum Deployments" to **macOS 13.0** or later

### 3. Build Settings

Search for and configure:

- **Swift Language Version**: Swift 5
- **Metal Compiler**: Use default settings
- **Enable Metal API Validation**: Debug mode only

### 4. Info.plist Settings (if needed)

Add these keys if missing:
```xml
<key>LSMinimumSystemVersion</key>
<string>13.0</string>
```

## Step 4: Verify Metal Shaders

Ensure both `.metal` files are in the target:

1. Select `AdvancedShaders.metal` in Project Navigator
2. Check "Target Membership" in File Inspector (right panel)
3. Ensure "EngineerLifeSimulator" is checked
4. Repeat for `Shaders.metal`

## Step 5: Build the Project

### Clean Build

```bash
# In Xcode: Product → Clean Build Folder (⇧⌘K)
# Or via command line:
xcodebuild clean -scheme EngineerLifeSimulator
```

### Build

```bash
# In Xcode: Product → Build (⌘B)
# Or via command line:
xcodebuild -scheme EngineerLifeSimulator
```

## Common Build Issues & Fixes

### Issue 1: "No such module 'MetalKit'"

**Fix**: MetalKit is a system framework, ensure:
- You're targeting macOS 13.0+
- Metal is enabled in build settings

### Issue 2: Metal shaders not compiling

**Fix**:
1. Clean build folder (⇧⌘K)
2. Verify `.metal` files are in target
3. Check for syntax errors in shader code
4. Rebuild (⌘B)

### Issue 3: "Cannot find type 'GameStore'"

**Fix**: Ensure all Swift files are added to the target:
1. Select file in navigator
2. Check "Target Membership" in File Inspector
3. Enable "EngineerLifeSimulator" checkbox

### Issue 4: SwiftUI preview crashes

**Fix**: 
- Previews may not work with Metal views
- Run the full app instead (⌘R)
- Metal rendering requires actual device, not just preview

### Issue 5: Missing @MainActor warnings

**Fix**: These are warnings, not errors. The code is marked correctly.

### Issue 6: "Command MetalLink failed"

**Fix**:
1. Check shader syntax in `.metal` files
2. Ensure Metal shaders use correct function signatures
3. Clean and rebuild

## Step 6: Run the Application

### Running in Xcode

1. Select target device: "My Mac"
2. Click Run (⌘R) or Product → Run
3. Wait for build to complete
4. App should launch

### Testing Features

Once running, test:

1. ✅ App launches without crashes
2. ✅ Start screen appears
3. ✅ Settings button works (gear icon)
4. ✅ Graphics quality can be adjusted
5. ✅ Game flow works (start → exam → university → job → game)
6. ✅ Player customization opens (in game view)
7. ✅ Shop displays assets (may show icons on Low quality)
8. ✅ Portfolio shows owned assets

## Performance Optimization

### Debug vs Release

- **Debug**: Slower, for development
- **Release**: Optimized, for distribution

To build Release:
```bash
# Xcode: Product → Scheme → Edit Scheme → Run → Build Configuration → Release
```

### Graphics Performance

If the app is slow:
1. Open Settings (gear icon)
2. Set quality to "Medium" or "Low"
3. Disable particle effects
4. Close other applications

## Distributing the App

### Archive Build

1. Product → Archive
2. Wait for archive to complete
3. Organizer window opens
4. Select archive → "Distribute App"
5. Choose distribution method:
   - **Development**: For testing
   - **Mac App Store**: For App Store
   - **Developer ID**: For direct distribution

### Export Options

```bash
# Command line archive:
xcodebuild archive \
  -scheme EngineerLifeSimulator \
  -archivePath ./build/EngineerLifeSimulator.xcarchive
```

## Troubleshooting Build Errors

### Error: "Could not find module for target"

```bash
# Solution: Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*
# Then rebuild in Xcode
```

### Error: "Metal shader compilation failed"

1. Open `AdvancedShaders.metal`
2. Check for syntax errors (Xcode shows them inline)
3. Common issues:
   - Missing semicolons
   - Wrong function signatures
   - Incompatible types

### Error: "Ambiguous use of..."

This means there are duplicate definitions. Check:
1. No duplicate struct/class names
2. No conflicting imports
3. No duplicate file additions to target

## Build Configuration File

Create `EngineerLifeSimulator.xcconfig`:

```ini
// Configuration settings file format documentation can be found at:
// https://help.apple.com/xcode/#/dev745c5c974

PRODUCT_NAME = EngineerLifeSimulator
PRODUCT_BUNDLE_IDENTIFIER = com.yourname.engineerlifesimulator
MACOSX_DEPLOYMENT_TARGET = 13.0
SWIFT_VERSION = 5.0
```

## Minimum Requirements

### For Development:
- macOS 13.0+
- Xcode 15.0+
- 8GB RAM (16GB recommended)
- Metal-compatible GPU (all modern Macs)

### For Running:
- macOS 13.0+
- 4GB RAM (8GB recommended)
- Metal-compatible GPU
- 500MB free disk space

## Next Steps

After successful build:

1. ✅ Run the app (⌘R)
2. ✅ Check QUICK_START.md for gameplay guide
3. ✅ Adjust graphics settings for your hardware
4. ✅ Report any issues found

## Getting Help

If you encounter issues:

1. Check build errors in Xcode Issue Navigator
2. Read error messages carefully
3. Review this guide's "Common Issues" section
4. Clean and rebuild (⇧⌘K then ⌘B)
5. Check minimum requirements

## Success Checklist

- [ ] Xcode project created
- [ ] All .swift files added to target
- [ ] Both .metal files added to target
- [ ] Build succeeds without errors (⌘B)
- [ ] App launches successfully (⌘R)
- [ ] Settings panel opens and works
- [ ] Graphics quality can be changed
- [ ] Game flow works end-to-end

**Once all checkboxes are complete, your build is successful!** 🎉

---

**Note**: The app uses Metal 4 for graphics, which requires a Metal-compatible GPU. All Macs from 2012 onwards support Metal.
