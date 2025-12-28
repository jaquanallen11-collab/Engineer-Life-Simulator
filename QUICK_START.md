# Quick Start Guide - Metal 4 Visual Integration

## 🚀 Getting Started

Your Engineer Life Simulator now has complete Metal 4 graphics integration! Here's how to get started:

## 1. Build and Run

```bash
# Open the project in Xcode
open EngineerLifeSimulator.xcodeproj

# Or use the workspace if you have one
# open EngineerLifeSimulator.xcworkspace
```

### Build Steps:
1. Select your target device/simulator
2. Build the project (⌘B)
3. Run (⌘R)

## 2. First Launch

When you start the game, you'll see:

### Settings Button (Top Right)
- Click the gear icon ⚙️
- Adjust graphics quality:
  - **Low**: Best performance, minimal effects
  - **Medium**: Balanced (recommended for older devices)
  - **High**: Full features (default)
  - **Ultra**: Maximum quality

## 3. Player Customization

### Access Customization:
1. Start a new game or continue
2. In the game view, look at the sidebar
3. Click **"Customize"** button (pink, with person icon)

### Customize Your Avatar:
- **Appearance Tab**: Choose skin tone (6 options)
- **Hair Tab**: Select style (8) and color (8)
- **Body Tab**: Choose body type (5), facial hair (6), eye color (6)
- **Outfit Tab**: Pick your style (6 options)
- **Accessories Tab**: Add extras (7 options)

**Live Preview**: The 3D avatar updates in real-time as you make changes!

## 4. Shopping with 3D Previews

### Open the Shop:
1. From game view sidebar, click **"Shop"**
2. Choose a category:
   - Investments
   - Properties
   - Vehicles
   - Global Homes

### View 3D Assets:
- **Hover** over any shop card to see 3D preview
- **Click** to purchase (if you can afford it)
- **Watch** the particle effect celebration!

### Example - Buying a Car:
```
1. Go to Shop → Vehicles
2. Hover over "Ferrari 488 GTB"
3. See the car rotate in 3D
4. Click "Purchase" (if you have $280,000)
5. Enjoy the success animation!
```

## 5. Portfolio with 3D Views

### Access Portfolio:
1. From game view, click **"Portfolio"**
2. Switch tabs:
   - Investments
   - Properties
   - Vehicles

### Interactive 3D:
- **Click** the 3D preview to expand/collapse
- **Rotate**: Asset automatically rotates
- **Value Tracking**: See real-time value changes
- **Sell**: Click "Sell" button when ready

## 6. Graphics Features

### What You'll See:

#### 3D Asset Rendering
- Vehicles with metallic paint
- Properties with architectural details
- Investments with data visualization
- Real-time lighting and shadows

#### Player Avatar
- Realistic skin rendering
- Subsurface scattering
- Dynamic lighting
- Smooth customization

#### Visual Effects
- ✨ Particle effects on purchases
- 🌟 Glow effects on luxury items
- 📊 Holographic UI overlays
- 📈 Animated value charts

## 7. Testing Features

### Test Vehicle Rendering:
```
1. Open Shop → Vehicles
2. Hover over different vehicle types:
   - Sport Car (Corvette)
   - Supercar (Ferrari 488)
   - SUV (Range Rover)
   - Luxury Sedan (Mercedes S-Class)
3. Notice the realistic car paint and reflections
```

### Test Player Customization:
```
1. Click "Customize" from game
2. Try different combinations:
   - Change skin tone
   - Switch hair styles
   - Add facial hair
   - Change outfit
3. Watch the 3D avatar update instantly
```

### Test Portfolio Views:
```
1. Buy a few assets from shop
2. Open Portfolio
3. Switch between tabs
4. Click 3D previews to expand
5. Watch rotation and effects
```

## 8. Performance Tips

### If You Experience Lag:

**Option 1: Lower Graphics**
1. Click Settings (gear icon)
2. Change quality to "Medium" or "Low"

**Option 2: Disable Effects**
1. Settings → Advanced Settings
2. Toggle off:
   - Particle Effects
   - Holographic UI
   - 3D Previews (uses icons instead)

### Recommended Settings by Device:

| Device | Quality | Notes |
|--------|---------|-------|
| MacBook Pro (M1+) | Ultra | Full experience |
| MacBook Pro (Intel) | High | Very good |
| MacBook Air | Medium | Balanced |
| Mac Mini | High | Excellent |
| Older Macs | Low-Medium | Adjust as needed |

## 9. Known Features

### What Works:
✅ All 3D asset rendering
✅ Player customization (48 options)
✅ Particle effects
✅ Holographic UI
✅ Value charts
✅ Purchase animations
✅ Settings panel

### Graphics Quality Impact:

**High/Ultra:**
- Full 3D previews
- All particle effects
- Holographic overlays
- Maximum visual fidelity

**Medium:**
- 3D previews enabled
- Holographic UI
- No particles (performance)

**Low:**
- Icon fallbacks
- No effects
- Best performance

## 10. Quick Troubleshooting

### No 3D Previews?
- Check: Settings → Graphics Quality (must be Medium+)
- Verify: Metal support on your device

### Slow Performance?
- Lower graphics quality
- Disable particle effects
- Close other applications

### Avatar Not Updating?
- Make sure you're clicking the customization buttons
- Check that customization view is visible
- Try different category tabs

### Shaders Not Loading?
- Clean build folder (⇧⌘K)
- Rebuild project (⌘B)
- Check Metal version (needs Metal 2.0+)

## 11. Asset Catalog

### Vehicles (22 Total)
**American** 🇺🇸
- Chevrolet Corvette Z06
- Ford Mustang GT
- Dodge Charger Hellcat
- Cadillac Escalade

**German** 🇩🇪
- Porsche 911 Turbo S
- Mercedes S-Class
- BMW 7 Series
- Audi A8

**Italian** 🇮🇹
- Ferrari 488 GTB
- Lamborghini Aventador
- Ferrari LaFerrari

**British** 🇬🇧
- Range Rover Autobiography
- McLaren 720S
- Bentley Continental GT

**Japanese** 🇯🇵
- Nissan GT-R Nismo
- Acura NSX
- Lexus LX 600

**Swedish/Other**
- Tesla Model S Plaid
- Bugatti Chiron

### Properties (27 Total)
**Cities with Homes:**
- New York, San Francisco, Los Angeles
- London, Paris, Dubai
- Tokyo, Hong Kong, Singapore
- And 13 more global cities!

**Property Types:**
- Houses (Suburban, Urban, Modern, Luxury)
- Condos (Studio, 1-3BR, Penthouse)
- Apartments (Studio to 3BR)
- Villas (Beachfront, Mountain, City)
- Mansions (Beverly Hills, NYC, Miami, etc.)

### Investments (12 Total)
- **Stocks**: Index Funds, Tech, Blue Chips
- **Bonds**: Government, Corporate, Municipal
- **Crypto**: Bitcoin, Ethereum, Altcoins
- **Other**: Startups, Real Estate, Commodities

## 12. Game Flow

### Typical Session:
```
1. Start Game → Create Character
2. Take Ivy Exam → Choose Major/Minor
3. Graduate → Get Job
4. Enter Main Game View

In Main Game:
5. Click "Customize" → Create Your Avatar
6. Earn Money → Open Shop
7. Buy Assets (3D previews on hover!)
8. Check Portfolio (3D views of your assets)
9. Click "Next Year" → Assets appreciate/depreciate
10. Build Your Empire!
```

## 13. Tips for Best Experience

### Visual Quality:
1. Use fullscreen mode for immersion
2. Enable High/Ultra graphics for best visuals
3. Hover over assets to see 3D previews
4. Expand portfolio cards for full 3D view

### Customization:
1. Create your avatar early in the game
2. Try different combinations
3. Match outfit to your career stage
4. Accessories add personality!

### Shopping:
1. Compare 3D previews before buying
2. Watch for location-based property deals
3. Diversify with multiple asset types
4. Check depreciation rates (vehicles)

### Portfolio Management:
1. Regularly check asset values
2. Sell depreciated vehicles
3. Hold appreciating properties
4. Balance risk with investments

## 14. Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Build | ⌘B |
| Run | ⌘R |
| Clean Build | ⇧⌘K |
| Settings | Click gear icon |

## 15. What's Next?

### Enjoy Your Enhanced Game!
- ✨ Stunning 3D graphics
- 👤 Customizable avatar
- 🏎️ 22 vehicles to collect
- 🏠 27 properties worldwide
- 💼 12 investment types
- 🎨 Complete Metal 4 integration

### Explore:
- Try all customization options
- Buy assets from different countries
- Build a diverse portfolio
- Max out your graphics settings
- Watch the beautiful particle effects!

## Need Help?

Check these guides:
- `METAL_INTEGRATION_GUIDE.md` - Technical details
- `SYSTEM_ARCHITECTURE.md` - System overview
- `ASSET_ENGINE_GUIDE.md` - Asset management
- `README.md` - Project overview

---

## 🎮 Start Playing!

1. Build the project
2. Run it
3. Open Settings → Set quality
4. Create your avatar
5. Start buying assets!

**Have fun with your Metal 4-powered Engineer Life Simulator!** 🚀
