# Engineer Life Simulator - Setup Guide

## Quick Start

### 1. Create Xcode Project

1. Open Xcode
2. Create new macOS App project
3. Name it "EngineerLifeSimulator"
4. Select SwiftUI interface
5. Select Swift language

### 2. Add Files

Add all the created files to your Xcode project:

**Core Files:**
- `EngineerLifeSimulatorApp.swift` (App entry point)
- `GameModels.swift` (Copy from your original Eng App swift code.swift)

**Metal Rendering:**
- `MetalRenderer.swift`
- `Metal4MLPipeline.swift`
- `Shaders.metal`
- `AdvancedShaders.metal`

**Modern UI Views:**
- `ModernViews.swift`
- `ModernGameViews.swift`
- `ModernShopViews.swift`
- `MLPredictor.swift`

### 3. Configure Build Settings

**Info.plist additions:**
```xml
<key>NSSupportsAutomaticGraphicsSwitching</key>
<true/>
<key>LSMinimumSystemVersion</key>
<string>14.0</string>
```

**Build Settings:**
- Deployment Target: macOS 14.0+
- Swift Language Version: Swift 5.9+
- Metal Compiler: Metal 3.1+

### 4. Add Frameworks

Link the following frameworks:
- `Metal.framework`
- `MetalKit.framework`  
- `MetalPerformanceShaders.framework`
- `CoreML.framework`
- `Accelerate.framework`

### 5. Run

Build and run the project (⌘R)

## Project Structure

```
EngineerLifeSimulator/
├── EngineerLifeSimulatorApp.swift    # Main app entry
├── GameModels.swift                   # Game data models
├── MetalRenderer.swift                # Metal 4 renderer
├── Metal4MLPipeline.swift            # ML inference
├── MLPredictor.swift                  # AI predictions
├── Shaders.metal                      # Basic shaders
├── AdvancedShaders.metal             # Effects shaders
├── ModernViews.swift                  # UI: Start, Exam, Uni
├── ModernGameViews.swift             # UI: Game, Scenarios
└── ModernShopViews.swift             # UI: Shop, Portfolio
```

## Migrating from Original Code

Your original `Eng App swift code.swift` contains all the game logic and models. To integrate:

1. **Keep the model definitions** (Player, Company, Job, etc.)
2. **Keep the GameStore class** - it manages all game state
3. **Replace the old views** with the new modern versions
4. **Add Metal rendering** as the background layer
5. **Add ML predictions** for enhanced gameplay

## Troubleshooting

### Metal Not Available
- Ensure you're running on a Mac with Metal support
- Check that Metal is enabled in Build Settings

### Shaders Not Compiling
- Verify `.metal` files are in "Copy Bundle Resources"
- Check Metal compiler version in Build Settings

### ML Pipeline Errors
- Metal 4 ML features require macOS 14+
- Ensure CoreML framework is linked

### UI Not Rendering
- Check that all SwiftUI files are properly imported
- Verify @StateObject and @ObservedObject usage

## Performance Optimization

- **Particle Count**: Adjust `particleCount` in MetalRenderer (default: 100)
- **Heap Size**: Modify intermediates heap size in Metal4MLPipeline
- **Frame Rate**: Set in MTKView (`preferredFramesPerSecond`)

## Next Steps

1. ✅ Run the basic game
2. 🎨 Customize colors and themes
3. 🤖 Train actual CoreML models
4. 🎮 Add more scenarios and companies
5. 💎 Add luxury items and achievements
6. 📊 Add statistics and charts
7. 🌐 Add multiplayer/leaderboards

## Resources

- [Metal Programming Guide](https://developer.apple.com/metal/)
- [CoreML Documentation](https://developer.apple.com/documentation/coreml)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)

---

Enjoy building your engineering empire! 🚀
