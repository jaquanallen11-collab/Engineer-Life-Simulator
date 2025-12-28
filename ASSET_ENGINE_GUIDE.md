# 🏦 Asset Engine - Complete Documentation

## Overview

The **AssetEngine** is a dedicated, centralized system that manages all purchasable and ownable assets in Engineer Life Simulator. It provides a clean separation of concerns, handling everything from purchasing to depreciation/appreciation calculations.

---

## 🎯 What It Does

The AssetEngine is the **single source of truth** for:
- **Vehicles** (22 cars from 6 countries)
- **Properties** (27 global real estate locations)
- **Investments** (12 different investment types)
- Asset valuation updates
- Transaction history
- Net worth calculations

---

## 📦 Core Components

### 1. **AssetEngine Class** (`@MainActor`)

The main observable object that manages all assets.

```swift
@StateObject private var assetEngine = AssetEngine()
```

#### Published Properties:
- `ownedVehicles: [Vehicle]` - Player's vehicle collection
- `ownedProperties: [Property]` - Player's real estate portfolio
- `ownedInvestments: [Investment]` - Player's investment holdings
- `assetHistory: [AssetTransaction]` - Complete transaction log

#### Private Catalogs:
- `vehicleCatalog` - All 22 available vehicles
- `propertyCatalog` - All 27 available properties
- `investmentCatalog` - All 12 available investments

---

## 🚗 Vehicles (22 Total)

### Available Origins:
- 🇺🇸 **American** (4 vehicles)
- 🇩🇪 **German** (4 vehicles)
- 🇮🇹 **Italian** (4 vehicles)
- 🇯🇵 **Japanese** (4 vehicles)
- 🇬🇧 **British** (4 vehicles)
- 🇰🇷 **Korean** (2 vehicles)

### Vehicle Types:
- Economy
- Sedan
- SUV
- Sports Car
- Luxury
- Supercar
- Hypercar

### Example Vehicles:

| Name | Manufacturer | Price | Maintenance | Prestige | Origin |
|------|-------------|-------|-------------|----------|--------|
| Ford Mustang | Ford | $55,000 | $300/mo | +5 | American |
| Tesla Model S | Tesla | $95,000 | $200/mo | +10 | American |
| Porsche 911 Turbo | Porsche | $180,000 | $700/mo | +20 | German |
| Ferrari 488 | Ferrari | $350,000 | $1,500/mo | +35 | Italian |
| McLaren 720S | McLaren | $300,000 | $1,300/mo | +32 | British |

### Vehicle Features:
- **Depreciation**: 8-16% annually (type-dependent)
- **Prestige System**: Boosts player status (2-40 points)
- **Monthly Maintenance**: $150-$1,500/month
- **Value Tracking**: Real-time current value calculation

---

## 🏠 Properties (27 Global Locations)

### Regions Covered:

#### 🌎 North America (9 properties)
- San Francisco, New York, Seattle, Austin, Miami
- Vancouver, Toronto

#### 🌍 Europe (7 properties)
- London, Paris, Munich, Zurich, Stockholm, Amsterdam, Dublin

#### 🌏 Asia (6 properties)
- Tokyo, Singapore, Hong Kong, Seoul, Shanghai, Bangalore

#### 🌏 Oceania & Middle East (5 properties)
- Sydney, Melbourne, Dubai, Tel Aviv

### Property Types:
- Condo
- House
- Apartment Complex
- Villa
- Penthouse
- Mansion
- Estate

### Example Properties:

| Name | City | Type | Price | Monthly Income | Appreciation |
|------|------|------|-------|----------------|--------------|
| SF Bay Area Condo | San Francisco | Condo | $850K | $3,500 | 8%/year |
| Manhattan Penthouse | New York | Penthouse | $3.5M | $15,000 | 6%/year |
| Tokyo Shibuya Apartment | Tokyo | Condo | $1.5M | $6,500 | 4%/year |
| Dubai Palm Jumeirah | Dubai | Villa | $3.8M | $16,000 | 8%/year |

### Property Features:
- **Appreciation**: 4-9% annually (location-dependent)
- **Rental Income**: Passive monthly income
- **Expenses**: Monthly maintenance costs
- **Location Awareness**: Adapts to player's current city

---

## 📈 Investments (12 Types)

### Investment Categories:

#### Index Funds (Low Risk)
- S&P 500 Index - $10K - 10% return
- Total Stock Market - $15K - 11% return
- International Index - $12K - 9% return

#### Stocks (Medium-High Risk)
- Tech Stocks Portfolio - $5K - 20% return
- Blue Chip Stocks - $8K - 12% return
- Growth Stocks - $6K - 25% return

#### Bonds (Low Risk)
- Government Bonds - $20K - 4% return
- Corporate Bonds - $15K - 6% return
- Municipal Bonds - $18K - 5% return

#### Cryptocurrency (High Risk)
- Crypto Portfolio - $3K - 35% return
- Bitcoin - $5K - 40% return
- Ethereum - $4K - 38% return

### Investment Features:
- **Volatility System**: Low/Medium/High with random fluctuations
- **Risk Levels**: 1-10 scale
- **Annual Returns**: With realistic volatility
- **Automatic Updates**: Yearly value recalculation

---

## 🔧 API Reference

### Purchasing Assets

```swift
// Buy a vehicle
let result = assetEngine.buyVehicle(name: "Tesla Model S", playerMoney: store.player.money)
if result.success {
    store.player.money -= result.cost
    store.addLog(result.message)
}

// Buy a property
let result = assetEngine.buyProperty(name: "SF Bay Area Condo", playerMoney: store.player.money)
if result.success {
    store.player.money -= result.cost
    store.addLog(result.message)
}

// Buy an investment
let result = assetEngine.buyInvestment(name: "S&P 500 Index", playerMoney: store.player.money)
if result.success {
    store.player.money -= result.cost
    store.addLog(result.message)
}
```

### Selling Assets

```swift
// Sell a vehicle
let result = assetEngine.sellVehicle(vehicleId: vehicle.id)
if result.success {
    store.player.money += result.value
    store.addLog(result.message)
}

// Similar for properties and investments
let result = assetEngine.sellProperty(propertyId: property.id)
let result = assetEngine.sellInvestment(investmentId: investment.id)
```

### Yearly Updates

```swift
// Called at end of each year
assetEngine.updateAllAssets()

// Vehicles depreciate (8-16% annually)
// Properties appreciate (4-9% annually)
// Investments fluctuate based on volatility
```

### Financial Calculations

```swift
// Monthly costs (maintenance + property expenses)
let monthlyCosts = assetEngine.calculateMonthlyAssetCosts()

// Monthly income (rental income)
let monthlyIncome = assetEngine.calculateMonthlyIncome()

// Net monthly impact
let netImpact = assetEngine.calculateNetMonthlyAssetImpact()

// Total net worth (all assets)
let netWorth = assetEngine.calculateTotalNetWorth()

// Total prestige from vehicles
let prestigeBoost = assetEngine.getTotalPrestigeBoost()
```

### Querying Assets

```swift
// Get available vehicles by budget
let affordableVehicles = assetEngine.getAvailableVehicles(maxPrice: 100000)

// Get properties in specific city
let tokyoProperties = assetEngine.getPropertiesByCity(.tokyo)

// Get vehicles by origin
let italianCars = assetEngine.getVehiclesByOrigin(.italian)

// Get affordable properties
let properties = assetEngine.getAvailableProperties(maxPrice: 1000000)

// Get investments within budget
let investments = assetEngine.getAvailableInvestments(maxPrice: 10000)
```

---

## 🔄 Integration Points

### 1. **ContentView** (EngineerLifeSimulatorApp.swift)
```swift
@StateObject private var assetEngine = AssetEngine()
```

### 2. **ModernGameView**
```swift
ModernGameView(store: store, ..., assetEngine: assetEngine)
```

Yearly updates:
```swift
assetEngine.updateAllAssets()
let netImpact = assetEngine.calculateNetMonthlyAssetImpact() * 12
store.player.money += netImpact
```

### 3. **ModernShopView**
```swift
ModernShopView(store: store, assetEngine: assetEngine)
```

All purchases go through AssetEngine.

### 4. **ModernPortfolioView**
```swift
ModernPortfolioView(store: store, assetEngine: assetEngine)
```

Displays all owned assets with real-time values.

---

## 📊 Transaction History

Every purchase and sale is automatically logged:

```swift
struct AssetTransaction {
    let type: TransactionType  // Purchase or Sale
    let assetName: String
    let amount: Int
    let date: Date
}
```

Transaction types:
- `vehiclePurchase` / `vehicleSale`
- `propertyPurchase` / `propertySale`
- `investmentPurchase` / `investmentSale`

---

## 💡 Usage Examples

### Example 1: Player Buys Ferrari
```swift
let result = assetEngine.buyVehicle(name: "Ferrari 488", playerMoney: 500000)
// Returns: (success: true, vehicle: Vehicle, cost: 350000, message: "Successfully purchased Ferrari 488!")
store.player.money -= 350000
// Player now has +35 prestige
// Monthly maintenance: -$1,500
```

### Example 2: Year-End Asset Update
```swift
// At end of year
assetEngine.updateAllAssets()

// Ferrari depreciates 8%: $350K → $322K
// SF Condo appreciates 8%: $850K → $918K
// Tech stocks gain 20%: $5K → $6K (with volatility)

let yearlyIncome = assetEngine.calculateNetMonthlyAssetImpact() * 12
// Rental income: +$42,000
// Maintenance: -$18,000
// Net: +$24,000
```

### Example 3: Net Worth Calculation
```swift
let totalNetWorth = store.player.money + assetEngine.calculateTotalNetWorth()
// Cash: $150,000
// Vehicles: $322,000 (Ferrari)
// Properties: $918,000 (SF Condo)
// Investments: $6,000 (Tech Stocks)
// Total Net Worth: $1,396,000
```

---

## 🎮 Game Balance

### Depreciation Rates:
- **Economy Cars**: 15-16% annually
- **Luxury Cars**: 11-14% annually
- **Supercars**: 8-10% annually (hold value better)

### Appreciation Rates:
- **Tier 1 Cities** (SF, NY, HK): 6-9% annually
- **Tier 2 Cities** (Austin, Tokyo): 4-7% annually
- **High Growth Markets** (Dubai, Bangalore): 7-9% annually

### Investment Returns:
- **Low Risk** (Bonds): 4-6% + minimal volatility
- **Medium Risk** (Index): 9-12% + moderate volatility
- **High Risk** (Stocks): 12-25% + high volatility
- **Extreme Risk** (Crypto): 35-40% + extreme volatility

---

## 🚀 Future Enhancements

Potential additions:
1. **Insurance System** - Monthly premiums for vehicles/properties
2. **Maintenance Events** - Random repair costs
3. **Market Crashes** - Economic downturns affect all assets
4. **Property Upgrades** - Renovations increase value
5. **Vehicle Customization** - Modify cars for extra prestige
6. **Asset Bundles** - Discounts for buying multiple assets
7. **Leasing Options** - Rent vehicles/properties
8. **Real Estate Development** - Build from scratch
9. **Asset Loans** - Borrow against net worth
10. **Asset Insurance** - Protect against losses

---

## 📝 Summary

The AssetEngine provides:
✅ **22 vehicles** from 6 countries  
✅ **27 properties** across 4 continents  
✅ **12 investment options** across 4 categories  
✅ **Automatic value updates** (appreciation/depreciation)  
✅ **Transaction history** for all purchases/sales  
✅ **Financial calculations** (net worth, monthly income/costs)  
✅ **Query system** for filtering available assets  
✅ **Clean API** for easy integration  

The system is fully integrated into the game loop and updates automatically with yearly progression!
