import Foundation
import SwiftUI

// MARK: - Asset Engine - Centralized Asset Management System

@MainActor
class AssetEngine: ObservableObject {
    @Published var ownedVehicles: [Vehicle] = []
    @Published var ownedProperties: [Property] = []
    @Published var ownedInvestments: [Investment] = []
    @Published var assetHistory: [AssetTransaction] = []
    
    // Asset catalogs (all available assets in the game)
    private var vehicleCatalog: [VehicleAsset] = []
    private var propertyCatalog: [PropertyAsset] = []
    private var investmentCatalog: [InvestmentAsset] = []
    
    init() {
        setupAssetCatalogs()
    }
    
    // MARK: - Catalog Setup
    
    private func setupAssetCatalogs() {
        setupVehicleCatalog()
        setupPropertyCatalog()
        setupInvestmentCatalog()
    }
    
    private func setupVehicleCatalog() {
        vehicleCatalog = [
            // American Cars
            VehicleAsset(name: "Ford Mustang", manufacturer: "Ford", type: .sports, origin: .american, 
                        price: 55000, monthlyMaintenance: 300, prestigeBoost: 5, depreciationRate: 0.15),
            VehicleAsset(name: "Tesla Model S", manufacturer: "Tesla", type: .luxury, origin: .american, 
                        price: 95000, monthlyMaintenance: 200, prestigeBoost: 10, depreciationRate: 0.12),
            VehicleAsset(name: "Chevrolet Corvette", manufacturer: "Chevrolet", type: .sports, origin: .american, 
                        price: 70000, monthlyMaintenance: 350, prestigeBoost: 7, depreciationRate: 0.14),
            VehicleAsset(name: "Cadillac Escalade", manufacturer: "Cadillac", type: .suv, origin: .american, 
                        price: 85000, monthlyMaintenance: 400, prestigeBoost: 8, depreciationRate: 0.16),
            
            // German Cars
            VehicleAsset(name: "BMW M5", manufacturer: "BMW", type: .luxury, origin: .german, 
                        price: 105000, monthlyMaintenance: 500, prestigeBoost: 12, depreciationRate: 0.13),
            VehicleAsset(name: "Mercedes-Benz S-Class", manufacturer: "Mercedes-Benz", type: .luxury, origin: .german, 
                        price: 115000, monthlyMaintenance: 550, prestigeBoost: 15, depreciationRate: 0.11),
            VehicleAsset(name: "Porsche 911 Turbo", manufacturer: "Porsche", type: .sports, origin: .german, 
                        price: 180000, monthlyMaintenance: 700, prestigeBoost: 20, depreciationRate: 0.10),
            VehicleAsset(name: "Audi RS7", manufacturer: "Audi", type: .luxury, origin: .german, 
                        price: 120000, monthlyMaintenance: 600, prestigeBoost: 14, depreciationRate: 0.13),
            
            // Italian Cars
            VehicleAsset(name: "Ferrari 488", manufacturer: "Ferrari", type: .supercar, origin: .italian, 
                        price: 350000, monthlyMaintenance: 1500, prestigeBoost: 35, depreciationRate: 0.08),
            VehicleAsset(name: "Lamborghini Huracán", manufacturer: "Lamborghini", type: .supercar, origin: .italian, 
                        price: 320000, monthlyMaintenance: 1400, prestigeBoost: 33, depreciationRate: 0.09),
            VehicleAsset(name: "Maserati Quattroporte", manufacturer: "Maserati", type: .luxury, origin: .italian, 
                        price: 145000, monthlyMaintenance: 800, prestigeBoost: 18, depreciationRate: 0.14),
            VehicleAsset(name: "Alfa Romeo Giulia", manufacturer: "Alfa Romeo", type: .sedan, origin: .italian, 
                        price: 55000, monthlyMaintenance: 400, prestigeBoost: 6, depreciationRate: 0.16),
            
            // Japanese Cars
            VehicleAsset(name: "Lexus LS", manufacturer: "Lexus", type: .luxury, origin: .japanese, 
                        price: 85000, monthlyMaintenance: 350, prestigeBoost: 9, depreciationRate: 0.12),
            VehicleAsset(name: "Nissan GT-R", manufacturer: "Nissan", type: .sports, origin: .japanese, 
                        price: 115000, monthlyMaintenance: 600, prestigeBoost: 13, depreciationRate: 0.11),
            VehicleAsset(name: "Honda NSX", manufacturer: "Honda", type: .supercar, origin: .japanese, 
                        price: 170000, monthlyMaintenance: 700, prestigeBoost: 17, depreciationRate: 0.10),
            VehicleAsset(name: "Toyota Camry", manufacturer: "Toyota", type: .sedan, origin: .japanese, 
                        price: 35000, monthlyMaintenance: 150, prestigeBoost: 2, depreciationRate: 0.15),
            
            // British Cars
            VehicleAsset(name: "Aston Martin DB11", manufacturer: "Aston Martin", type: .luxury, origin: .british, 
                        price: 215000, monthlyMaintenance: 1000, prestigeBoost: 25, depreciationRate: 0.12),
            VehicleAsset(name: "Bentley Continental GT", manufacturer: "Bentley", type: .luxury, origin: .british, 
                        price: 230000, monthlyMaintenance: 1100, prestigeBoost: 27, depreciationRate: 0.11),
            VehicleAsset(name: "McLaren 720S", manufacturer: "McLaren", type: .supercar, origin: .british, 
                        price: 300000, monthlyMaintenance: 1300, prestigeBoost: 32, depreciationRate: 0.09),
            VehicleAsset(name: "Rolls-Royce Ghost", manufacturer: "Rolls-Royce", type: .luxury, origin: .british, 
                        price: 350000, monthlyMaintenance: 1500, prestigeBoost: 40, depreciationRate: 0.08),
            
            // Korean Cars
            VehicleAsset(name: "Genesis G90", manufacturer: "Genesis", type: .luxury, origin: .korean, 
                        price: 75000, monthlyMaintenance: 350, prestigeBoost: 7, depreciationRate: 0.14),
            VehicleAsset(name: "Hyundai Ioniq 5", manufacturer: "Hyundai", type: .suv, origin: .korean, 
                        price: 45000, monthlyMaintenance: 200, prestigeBoost: 4, depreciationRate: 0.16),
        ]
    }
    
    private func setupPropertyCatalog() {
        propertyCatalog = [
            // North America - USA
            PropertyAsset(name: "SF Bay Area Condo", type: .condo, city: .sanFrancisco,
                         price: 850000, monthlyExpense: 1500, rentalIncome: 5000, appreciationRate: 0.08),
            PropertyAsset(name: "SF Victorian House", type: .house, city: .sanFrancisco,
                         price: 1500000, monthlyExpense: 2500, rentalIncome: 8000, appreciationRate: 0.09),
            PropertyAsset(name: "Manhattan Studio", type: .condo, city: .newYork,
                         price: 950000, monthlyExpense: 2000, rentalIncome: 6000, appreciationRate: 0.07),
            PropertyAsset(name: "Manhattan Penthouse", type: .penthouse, city: .newYork,
                         price: 3500000, monthlyExpense: 5000, rentalIncome: 20000, appreciationRate: 0.06),
            PropertyAsset(name: "Seattle Downtown Loft", type: .condo, city: .seattle,
                         price: 650000, monthlyExpense: 1200, rentalIncome: 4000, appreciationRate: 0.08),
            PropertyAsset(name: "Austin Tech House", type: .house, city: .austin,
                         price: 750000, monthlyExpense: 1300, rentalIncome: 4500, appreciationRate: 0.09),
            PropertyAsset(name: "Miami Beach Villa", type: .villa, city: .miami,
                         price: 2200000, monthlyExpense: 3000, rentalIncome: 12000, appreciationRate: 0.07),
            
            // North America - Canada
            PropertyAsset(name: "Vancouver Waterfront", type: .condo, city: .vancouver,
                         price: 1800000, monthlyExpense: 2500, rentalIncome: 10000, appreciationRate: 0.06),
            PropertyAsset(name: "Toronto Downtown Condo", type: .condo, city: .toronto,
                         price: 950000, monthlyExpense: 1800, rentalIncome: 5500, appreciationRate: 0.07),
            
            // Europe
            PropertyAsset(name: "London Mayfair Flat", type: .penthouse, city: .london,
                         price: 2800000, monthlyExpense: 4000, rentalIncome: 16000, appreciationRate: 0.05),
            PropertyAsset(name: "Paris Apartment", type: .condo, city: .paris,
                         price: 1900000, monthlyExpense: 2800, rentalIncome: 10800, appreciationRate: 0.06),
            PropertyAsset(name: "Munich Modern Villa", type: .villa, city: .munich,
                         price: 2100000, monthlyExpense: 3200, rentalIncome: 12200, appreciationRate: 0.05),
            PropertyAsset(name: "Zurich Lake House", type: .villa, city: .zurich,
                         price: 3200000, monthlyExpense: 4500, rentalIncome: 17500, appreciationRate: 0.04),
            PropertyAsset(name: "Stockholm Waterfront", type: .condo, city: .stockholm,
                         price: 1200000, monthlyExpense: 2000, rentalIncome: 7000, appreciationRate: 0.06),
            PropertyAsset(name: "Amsterdam Canal House", type: .house, city: .amsterdam,
                         price: 1600000, monthlyExpense: 2200, rentalIncome: 9000, appreciationRate: 0.05),
            PropertyAsset(name: "Dublin City Center", type: .condo, city: .dublin,
                         price: 800000, monthlyExpense: 1500, rentalIncome: 5000, appreciationRate: 0.07),
            
            // Asia
            PropertyAsset(name: "Tokyo Shibuya Apartment", type: .condo, city: .tokyo,
                         price: 1500000, monthlyExpense: 2000, rentalIncome: 8500, appreciationRate: 0.04),
            PropertyAsset(name: "Singapore Marina Bay", type: .penthouse, city: .singapore,
                         price: 2500000, monthlyExpense: 3500, rentalIncome: 14000, appreciationRate: 0.05),
            PropertyAsset(name: "Hong Kong Victoria Peak", type: .penthouse, city: .hongKong,
                         price: 4200000, monthlyExpense: 6000, rentalIncome: 24000, appreciationRate: 0.06),
            PropertyAsset(name: "Seoul Gangnam Tower", type: .condo, city: .seoul,
                         price: 1100000, monthlyExpense: 1800, rentalIncome: 6500, appreciationRate: 0.06),
            PropertyAsset(name: "Shanghai Pudong Apartment", type: .condo, city: .shanghai,
                         price: 900000, monthlyExpense: 1500, rentalIncome: 5500, appreciationRate: 0.07),
            PropertyAsset(name: "Bangalore Tech Hub House", type: .house, city: .bangalore,
                         price: 450000, monthlyExpense: 800, rentalIncome: 3000, appreciationRate: 0.09),
            
            // Oceania & Middle East
            PropertyAsset(name: "Sydney Harbor House", type: .villa, city: .sydney,
                         price: 2600000, monthlyExpense: 3800, rentalIncome: 14800, appreciationRate: 0.06),
            PropertyAsset(name: "Melbourne Downtown Apartment", type: .condo, city: .melbourne,
                         price: 850000, monthlyExpense: 1600, rentalIncome: 5500, appreciationRate: 0.07),
            PropertyAsset(name: "Dubai Palm Jumeirah", type: .villa, city: .dubai,
                         price: 3800000, monthlyExpense: 5500, rentalIncome: 21500, appreciationRate: 0.08),
            PropertyAsset(name: "Tel Aviv Beach Apartment", type: .condo, city: .telaviv,
                         price: 1200000, monthlyExpense: 2000, rentalIncome: 7500, appreciationRate: 0.07),
        ]
    }
    
    private func setupInvestmentCatalog() {
        investmentCatalog = [
            // Index Funds
            InvestmentAsset(name: "S&P 500 Index", type: .index, price: 10000, volatility: .low, 
                           annualReturn: 0.10, riskLevel: 2),
            InvestmentAsset(name: "Total Stock Market", type: .index, price: 15000, volatility: .low, 
                           annualReturn: 0.11, riskLevel: 3),
            InvestmentAsset(name: "International Index", type: .index, price: 12000, volatility: .medium, 
                           annualReturn: 0.09, riskLevel: 4),
            
            // Stocks
            InvestmentAsset(name: "Tech Stocks Portfolio", type: .stocks, price: 5000, volatility: .high, 
                           annualReturn: 0.20, riskLevel: 7),
            InvestmentAsset(name: "Blue Chip Stocks", type: .stocks, price: 8000, volatility: .low, 
                           annualReturn: 0.12, riskLevel: 3),
            InvestmentAsset(name: "Growth Stocks", type: .stocks, price: 6000, volatility: .high, 
                           annualReturn: 0.25, riskLevel: 8),
            
            // Bonds
            InvestmentAsset(name: "Government Bonds", type: .bonds, price: 20000, volatility: .low, 
                           annualReturn: 0.04, riskLevel: 1),
            InvestmentAsset(name: "Corporate Bonds", type: .bonds, price: 15000, volatility: .low, 
                           annualReturn: 0.06, riskLevel: 2),
            InvestmentAsset(name: "Municipal Bonds", type: .bonds, price: 18000, volatility: .low, 
                           annualReturn: 0.05, riskLevel: 1),
            
            // Crypto
            InvestmentAsset(name: "Crypto Portfolio", type: .crypto, price: 3000, volatility: .high, 
                           annualReturn: 0.35, riskLevel: 9),
            InvestmentAsset(name: "Bitcoin", type: .crypto, price: 5000, volatility: .high, 
                           annualReturn: 0.40, riskLevel: 9),
            InvestmentAsset(name: "Ethereum", type: .crypto, price: 4000, volatility: .high, 
                           annualReturn: 0.38, riskLevel: 9),
        ]
    }
    
    // MARK: - Vehicle Management
    
    func buyVehicle(name: String, playerMoney: Int) -> (success: Bool, vehicle: Vehicle?, cost: Int, message: String) {
        guard let asset = vehicleCatalog.first(where: { $0.name == name }) else {
            return (false, nil, 0, "Vehicle not found in catalog")
        }
        
        if playerMoney < asset.price {
            return (false, nil, asset.price, "Insufficient funds. Need $\(asset.price)")
        }
        
        let vehicle = Vehicle(
            id: UUID().uuidString,
            name: asset.name,
            manufacturer: asset.manufacturer,
            type: asset.type,
            origin: asset.origin,
            purchasePrice: asset.price,
            currentValue: asset.price,
            monthlyMaintenance: asset.monthlyMaintenance,
            prestigeBoost: asset.prestigeBoost
        )
        
        ownedVehicles.append(vehicle)
        
        let transaction = AssetTransaction(
            type: .vehiclePurchase,
            assetName: name,
            amount: asset.price,
            date: Date()
        )
        assetHistory.append(transaction)
        
        return (true, vehicle, asset.price, "Successfully purchased \(name)!")
    }
    
    func sellVehicle(vehicleId: String) -> (success: Bool, value: Int, message: String) {
        guard let index = ownedVehicles.firstIndex(where: { $0.id == vehicleId }) else {
            return (false, 0, "Vehicle not found")
        }
        
        let vehicle = ownedVehicles[index]
        let sellValue = vehicle.currentValue
        
        ownedVehicles.remove(at: index)
        
        let transaction = AssetTransaction(
            type: .vehicleSale,
            assetName: vehicle.name,
            amount: sellValue,
            date: Date()
        )
        assetHistory.append(transaction)
        
        return (true, sellValue, "Sold \(vehicle.name) for $\(sellValue)")
    }
    
    // MARK: - Property Management
    
    func buyProperty(name: String, playerMoney: Int) -> (success: Bool, property: Property?, cost: Int, message: String) {
        guard let asset = propertyCatalog.first(where: { $0.name == name }) else {
            return (false, nil, 0, "Property not found in catalog")
        }
        
        if playerMoney < asset.price {
            return (false, nil, asset.price, "Insufficient funds. Need $\(asset.price)")
        }
        
        let property = Property(
            id: UUID().uuidString,
            name: asset.name,
            type: asset.type,
            purchasePrice: asset.price,
            currentValue: asset.price,
            monthlyExpense: asset.monthlyExpense,
            rentalIncome: asset.rentalIncome,
            location: asset.city.rawValue,
            country: asset.city.country
        )
        
        ownedProperties.append(property)
        
        let transaction = AssetTransaction(
            type: .propertyPurchase,
            assetName: name,
            amount: asset.price,
            date: Date()
        )
        assetHistory.append(transaction)
        
        return (true, property, asset.price, "Successfully purchased \(name)!")
    }
    
    func sellProperty(propertyId: String) -> (success: Bool, value: Int, message: String) {
        guard let index = ownedProperties.firstIndex(where: { $0.id == propertyId }) else {
            return (false, 0, "Property not found")
        }
        
        let property = ownedProperties[index]
        let sellValue = property.currentValue
        
        ownedProperties.remove(at: index)
        
        let transaction = AssetTransaction(
            type: .propertySale,
            assetName: property.name,
            amount: sellValue,
            date: Date()
        )
        assetHistory.append(transaction)
        
        return (true, sellValue, "Sold \(property.name) for $\(sellValue)")
    }
    
    // MARK: - Investment Management
    
    func buyInvestment(name: String, playerMoney: Int) -> (success: Bool, investment: Investment?, cost: Int, message: String) {
        guard let asset = investmentCatalog.first(where: { $0.name == name }) else {
            return (false, nil, 0, "Investment not found in catalog")
        }
        
        if playerMoney < asset.price {
            return (false, nil, asset.price, "Insufficient funds. Need $\(asset.price)")
        }
        
        let investment = Investment(
            id: UUID().uuidString,
            name: asset.name,
            type: asset.type,
            purchasePrice: asset.price,
            currentValue: asset.price,
            volatility: asset.volatility,
            annualReturn: asset.annualReturn
        )
        
        ownedInvestments.append(investment)
        
        let transaction = AssetTransaction(
            type: .investmentPurchase,
            assetName: name,
            amount: asset.price,
            date: Date()
        )
        assetHistory.append(transaction)
        
        return (true, investment, asset.price, "Successfully invested in \(name)!")
    }
    
    func sellInvestment(investmentId: String) -> (success: Bool, value: Int, message: String) {
        guard let index = ownedInvestments.firstIndex(where: { $0.id == investmentId }) else {
            return (false, 0, "Investment not found")
        }
        
        let investment = ownedInvestments[index]
        let sellValue = investment.currentValue
        
        ownedInvestments.remove(at: index)
        
        let transaction = AssetTransaction(
            type: .investmentSale,
            assetName: investment.name,
            amount: sellValue,
            date: Date()
        )
        assetHistory.append(transaction)
        
        return (true, sellValue, "Sold \(investment.name) for $\(sellValue)")
    }
    
    // MARK: - Asset Updates (Yearly)
    
    func updateAllAssets() {
        updateVehicleValues()
        updatePropertyValues()
        updateInvestmentValues()
    }
    
    private func updateVehicleValues() {
        for i in 0..<ownedVehicles.count {
            guard let asset = vehicleCatalog.first(where: { $0.name == ownedVehicles[i].name }) else { continue }
            
            // Apply depreciation
            let depreciation = Double(ownedVehicles[i].currentValue) * asset.depreciationRate
            ownedVehicles[i].currentValue = max(Int(Double(ownedVehicles[i].currentValue) - depreciation), 
                                                 ownedVehicles[i].purchasePrice / 10) // Min 10% of original
        }
    }
    
    private func updatePropertyValues() {
        for i in 0..<ownedProperties.count {
            guard let asset = propertyCatalog.first(where: { $0.name == ownedProperties[i].name }) else { continue }
            
            // Apply appreciation
            let appreciation = Double(ownedProperties[i].currentValue) * asset.appreciationRate
            ownedProperties[i].currentValue = Int(Double(ownedProperties[i].currentValue) + appreciation)
        }
    }
    
    private func updateInvestmentValues() {
        for i in 0..<ownedInvestments.count {
            guard let asset = investmentCatalog.first(where: { $0.name == ownedInvestments[i].name }) else { continue }
            
            // Apply returns with volatility
            var returnRate = asset.annualReturn
            
            // Add random volatility based on risk
            let volatilityFactor: Double
            switch asset.volatility {
            case .low:
                volatilityFactor = Double.random(in: -0.02...0.02)
            case .medium:
                volatilityFactor = Double.random(in: -0.05...0.05)
            case .high:
                volatilityFactor = Double.random(in: -0.15...0.15)
            }
            
            returnRate += volatilityFactor
            
            let gain = Double(ownedInvestments[i].currentValue) * returnRate
            ownedInvestments[i].currentValue = max(Int(Double(ownedInvestments[i].currentValue) + gain), 0)
        }
    }
    
    // MARK: - Monthly Costs
    
    func calculateMonthlyAssetCosts() -> Int {
        let vehicleMaintenance = ownedVehicles.reduce(0) { $0 + $1.monthlyMaintenance }
        let propertyExpenses = ownedProperties.reduce(0) { $0 + $1.monthlyExpense }
        return vehicleMaintenance + propertyExpenses
    }
    
    func calculateMonthlyIncome() -> Int {
        let rentalIncome = ownedProperties.reduce(0) { $0 + $1.rentalIncome }
        return rentalIncome
    }
    
    func calculateNetMonthlyAssetImpact() -> Int {
        return calculateMonthlyIncome() - calculateMonthlyAssetCosts()
    }
    
    // MARK: - Net Worth Calculation
    
    func calculateTotalNetWorth() -> Int {
        let vehicleValue = ownedVehicles.reduce(0) { $0 + $1.currentValue }
        let propertyValue = ownedProperties.reduce(0) { $0 + $1.currentValue }
        let investmentValue = ownedInvestments.reduce(0) { $0 + $1.currentValue }
        return vehicleValue + propertyValue + investmentValue
    }
    
    func getTotalPrestigeBoost() -> Int {
        return ownedVehicles.reduce(0) { $0 + $1.prestigeBoost }
    }
    
    // MARK: - Queries
    
    func getAvailableVehicles(maxPrice: Int? = nil) -> [VehicleAsset] {
        if let maxPrice = maxPrice {
            return vehicleCatalog.filter { $0.price <= maxPrice }
        }
        return vehicleCatalog
    }
    
    func getAvailableProperties(maxPrice: Int? = nil, city: WorldCity? = nil) -> [PropertyAsset] {
        var filtered = propertyCatalog
        
        if let maxPrice = maxPrice {
            filtered = filtered.filter { $0.price <= maxPrice }
        }
        
        if let city = city {
            filtered = filtered.filter { $0.city == city }
        }
        
        return filtered
    }
    
    func getAvailableInvestments(maxPrice: Int? = nil) -> [InvestmentAsset] {
        if let maxPrice = maxPrice {
            return investmentCatalog.filter { $0.price <= maxPrice }
        }
        return investmentCatalog
    }
    
    func getPropertiesByCity(_ city: WorldCity) -> [PropertyAsset] {
        return propertyCatalog.filter { $0.city == city }
    }
    
    func getVehiclesByOrigin(_ origin: VehicleOrigin) -> [VehicleAsset] {
        return vehicleCatalog.filter { $0.origin == origin }
    }
}

// MARK: - Asset Catalog Models

struct VehicleAsset {
    let name: String
    let manufacturer: String
    let type: VehicleType
    let origin: VehicleOrigin
    let price: Int
    let monthlyMaintenance: Int
    let prestigeBoost: Int
    let depreciationRate: Double
}

struct PropertyAsset {
    let name: String
    let type: PropertyType
    let city: WorldCity
    let price: Int
    let monthlyExpense: Int
    let rentalIncome: Int
    let appreciationRate: Double
}

struct InvestmentAsset {
    let name: String
    let type: InvestmentType
    let price: Int
    let volatility: Volatility
    let annualReturn: Double
    let riskLevel: Int // 1-10
}

// MARK: - Transaction History

struct AssetTransaction: Identifiable, Codable {
    let id = UUID().uuidString
    let type: TransactionType
    let assetName: String
    let amount: Int
    let date: Date
}

enum TransactionType: String, Codable {
    case vehiclePurchase = "Vehicle Purchase"
    case vehicleSale = "Vehicle Sale"
    case propertyPurchase = "Property Purchase"
    case propertySale = "Property Sale"
    case investmentPurchase = "Investment Purchase"
    case investmentSale = "Investment Sale"
}
