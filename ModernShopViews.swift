import SwiftUI

// MARK: - Modern Job Offers View

struct ModernJobOffersView: View {
    @ObservedObject var store: GameStore
    @State private var showContent = false
    @State private var selectedOffer: JobOffer?
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button {
                    withAnimation {
                        store.closeOverlay()
                    }
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.purple)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                VStack {
                    Text("Job Offers")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("\(store.jobOffers.count) companies interested")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Color.clear.frame(width: 28)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(store.jobOffers) { offer in
                        JobOfferCardModern(
                            offer: offer,
                            isSelected: selectedOffer?.id == offer.id
                        ) {
                            withAnimation {
                                selectedOffer = offer
                                store.acceptJobOffer(offer)
                            }
                        }
                        .scaleEffect(showContent ? 1.0 : 0.8)
                        .opacity(showContent ? 1.0 : 0)
                    }
                }
                .padding()
            }
        }
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
}

struct JobOfferCardModern: View {
    let offer: JobOffer
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        GlassmorphicCard {
            VStack(spacing: 20) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 70, height: 70)
                        
                        Text(String(offer.company.name.prefix(1)))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(offer.company.name)
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(offer.role)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                // Compensation Details
                VStack(spacing: 15) {
                    CompensationRow(
                        icon: "dollarsign.circle.fill",
                        label: "Base Salary",
                        value: "$\(offer.salary.formatted())/year",
                        color: .green
                    )
                    
                    CompensationRow(
                        icon: "gift.circle.fill",
                        label: "Signing Bonus",
                        value: "$\(offer.signingBonus.formatted())",
                        color: .orange
                    )
                    
                    CompensationRow(
                        icon: "chart.line.uptrend.xyaxis.circle.fill",
                        label: "Annual Increase",
                        value: "\((offer.salaryIncrease * 100).formatted())%",
                        color: .blue
                    )
                    
                    CompensationRow(
                        icon: "star.circle.fill",
                        label: "Prestige Level",
                        value: "\(offer.company.prestigeLevel)/10",
                        color: .yellow
                    )
                }
                
                NeonButton(
                    title: "Accept Offer",
                    icon: "checkmark.circle.fill",
                    action: action,
                    color: .purple
                )
            }
        }
    }
}

struct CompensationRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
        }
    }
}

// MARK: - Modern Shop View

struct ModernShopView: View {
    @ObservedObject var store: GameStore
    @ObservedObject var assetEngine: AssetEngine
    @ObservedObject var visualHub: VisualIntegrationHub
    @State private var showContent = false
    @State private var selectedCategory = 0
    @State private var showPurchaseEffect = false
    @State private var lastPurchasedAsset = ""
    
    private let categories = ["Investments", "Properties", "Vehicles", "Global Homes"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button {
                    withAnimation {
                        store.closeOverlay()
                    }
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.purple)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                VStack {
                    Text("Investment Shop")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    AnimatedNumberText(value: store.player.money)
                }
                
                Spacer()
                
                Color.clear.frame(width: 28)
            }
            .padding()
            
            // Category Picker
            Picker("Category", selection: $selectedCategory) {
                ForEach(0..<categories.count, id: \.self) { index in
                    Text(categories[index]).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // Content
            ScrollView {
                VStack(spacing: 20) {
                    if selectedCategory == 0 {
                        InvestmentsSection(store: store, assetEngine: assetEngine)
                    } else if selectedCategory == 1 {
                        PropertiesSection(store: store, assetEngine: assetEngine)
                    } else if selectedCategory == 2 {
                        VehiclesSection(store: store, assetEngine: assetEngine)
                    } else {
                        GlobalHomesSection(store: store, assetEngine: assetEngine)
                    }
                }
                .padding()
            }
        }
        .background(
            LinearGradient(
                colors: [Color.green.opacity(0.1), Color.mint.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
}

struct InvestmentsSection: View {
    @ObservedObject var store: GameStore
    @ObservedObject var assetEngine: AssetEngine
    
    var body: some View {
        VStack(spacing: 15) {
            ModernShopCard(
                icon: "chart.line.uptrend.xyaxis",
                name: "S&P 500 Index Fund",
                description: "Diversified market exposure",
                price: 10000,
                returns: "8-12% annually",
                volatility: "Low",
                color: .blue,
                canAfford: store.player.money >= 10000
            ) {
                let result = assetEngine.buyInvestment(name: "S&P 500 Index", playerMoney: store.player.money)
                if result.success {
                    store.player.money -= result.cost
                    store.addLog(result.message)
                }
            }
            
            ModernShopCard(
                icon: "laptopcomputer",
                name: "Tech Stocks Portfolio",
                description: "High-growth technology companies",
                price: 5000,
                returns: "15-25% annually",
                volatility: "High",
                color: .purple,
                canAfford: store.player.money >= 5000
            ) {
                let result = assetEngine.buyInvestment(name: "Tech Stocks Portfolio", playerMoney: store.player.money)
                if result.success {
                    store.player.money -= result.cost
                    store.addLog(result.message)
                }
            }
            
            ModernShopCard(
                icon: "doc.text.fill",
                name: "Government Bonds",
                description: "Safe and stable investment",
                price: 20000,
                returns: "3-5% annually",
                volatility: "Low",
                color: .green,
                canAfford: store.player.money >= 20000
            ) {
                let result = assetEngine.buyInvestment(name: "Government Bonds", playerMoney: store.player.money)
                if result.success {
                    store.player.money -= result.cost
                    store.addLog(result.message)
                }
            }
            
            ModernShopCard(
                icon: "bitcoinsign.circle.fill",
                name: "Cryptocurrency",
                description: "High risk, high reward",
                price: 3000,
                returns: "20-50% annually",
                volatility: "Extreme",
                color: .orange,
                canAfford: store.player.money >= 3000
            ) {
                let result = assetEngine.buyInvestment(name: "Crypto Portfolio", playerMoney: store.player.money)
                if result.success {
                    store.player.money -= result.cost
                    store.addLog(result.message)
                }
            }
        }
    }
}

struct PropertiesSection: View {
    @ObservedObject var store: GameStore
    @ObservedObject var assetEngine: AssetEngine
    
    var body: some View {
        VStack(spacing: 15) {
            ModernShopCard(
                icon: "building.2.fill",
                name: "Downtown Condo",
                description: "Prime location, great rental income",
                price: 300000,
                returns: "$1,500/mo net income",
                volatility: "Stable",
                color: .cyan,
                canAfford: store.player.money >= 300000
            ) {
                // Using legacy property - not in AssetEngine catalog
                store.buyProperty(name: "Downtown Condo", type: .condo, price: 300000, monthlyExpense: 500, rentalIncome: 2000)
            }
            
            ModernShopCard(
                icon: "house.fill",
                name: "Suburban House",
                description: "Family home with appreciation potential",
                price: 450000,
                returns: "$2,000/mo net income",
                volatility: "Moderate",
                color: .green,
                canAfford: store.player.money >= 450000
            ) {
                store.buyProperty(name: "Suburban House", type: .house, price: 450000, monthlyExpense: 800, rentalIncome: 2800)
            }
            
            ModernShopCard(
                icon: "building.fill",
                name: "Apartment Complex",
                description: "Multiple units, high cash flow",
                price: 800000,
                returns: "$5,000/mo net income",
                volatility: "Moderate",
                color: .purple,
                canAfford: store.player.money >= 800000
            ) {
                store.buyProperty(name: "Apartment Complex", type: .apartment, price: 800000, monthlyExpense: 2000, rentalIncome: 7000)
            }
        }
    }
}

struct VehiclesSection: View {
    @ObservedObject var store: GameStore
    @ObservedObject var assetEngine: AssetEngine
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🚗 American Cars")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ModernShopCard(
                icon: "car.fill",
                name: "Ford Mustang",
                description: "Iconic American muscle car",
                price: 55000,
                returns: "Prestige +5",
                volatility: "Stable",
                color: .blue,
                canAfford: store.player.money >= 55000
            ) {
                let result = assetEngine.buyVehicle(name: "Ford Mustang", playerMoney: store.player.money)
                if result.success {
                    store.player.money -= result.cost
                    store.addLog(result.message)
                }
            }
            
            ModernShopCard(
                icon: "car.fill",
                name: "Tesla Model S",
                description: "Electric luxury sedan",
                price: 95000,
                returns: "Prestige +10",
                volatility: "Moderate",
                color: .red,
                canAfford: store.player.money >= 95000
            ) {
                let result = assetEngine.buyVehicle(name: "Tesla Model S", playerMoney: store.player.money)
                if result.success {
                    store.player.money -= result.cost
                    store.addLog(result.message)
                }
            }
            
            ModernShopCard(
                icon: "car.fill",
                name: "Chevrolet Corvette",
                description: "American sports car icon",
                price: 70000,
                returns: "Prestige +7",
                volatility: "Stable",
                color: .orange,
                canAfford: store.player.money >= 70000
            ) {
                store.player.money -= 70000
                store.addLog("Purchased Chevrolet Corvette")
            }
            
            Divider().padding(.vertical, 10)
            
            Text("🇩🇪 German Engineering")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ModernShopCard(
                icon: "car.fill",
                name: "BMW M5",
                description: "Ultimate driving machine",
                price: 105000,
                returns: "Prestige +12",
                volatility: "Moderate",
                color: .blue,
                canAfford: store.player.money >= 105000
            ) {
                store.player.money -= 105000
                store.addLog("Purchased BMW M5")
            }
            
            ModernShopCard(
                icon: "car.fill",
                name: "Mercedes-Benz S-Class",
                description: "Luxury and innovation",
                price: 115000,
                returns: "Prestige +15",
                volatility: "Low",
                color: .gray,
                canAfford: store.player.money >= 115000
            ) {
                store.player.money -= 115000
                store.addLog("Purchased Mercedes-Benz S-Class")
            }
            
            ModernShopCard(
                icon: "car.fill",
                name: "Porsche 911 Turbo",
                description: "Legendary sports car",
                price: 180000,
                returns: "Prestige +20",
                volatility: "Stable",
                color: .yellow,
                canAfford: store.player.money >= 180000
            ) {
                store.player.money -= 180000
                store.addLog("Purchased Porsche 911 Turbo")
            }
            
            Divider().padding(.vertical, 10)
            
            Text("🇮🇹 Italian Exotics")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ModernShopCard(
                icon: "car.fill",
                name: "Ferrari 488",
                description: "Prancing horse supercar",
                price: 350000,
                returns: "Prestige +35",
                volatility: "High",
                color: .red,
                canAfford: store.player.money >= 350000
            ) {
                store.player.money -= 350000
                store.addLog("Purchased Ferrari 488")
            }
            
            ModernShopCard(
                icon: "car.fill",
                name: "Lamborghini Huracán",
                description: "Raging bull performance",
                price: 320000,
                returns: "Prestige +33",
                volatility: "High",
                color: .orange,
                canAfford: store.player.money >= 320000
            ) {
                store.player.money -= 320000
                store.addLog("Purchased Lamborghini Huracán")
            }
            
            ModernShopCard(
                icon: "car.fill",
                name: "Maserati Quattroporte",
                description: "Italian luxury sedan",
                price: 145000,
                returns: "Prestige +18",
                volatility: "Moderate",
                color: .blue,
                canAfford: store.player.money >= 145000
            ) {
                store.player.money -= 145000
                store.addLog("Purchased Maserati Quattroporte")
            }
            
            Divider().padding(.vertical, 10)
            
            Text("🇯🇵 Japanese Precision")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ModernShopCard(
                icon: "car.fill",
                name: "Lexus LS",
                description: "Japanese luxury excellence",
                price: 85000,
                returns: "Prestige +9",
                volatility: "Low",
                color: .gray,
                canAfford: store.player.money >= 85000
            ) {
                store.player.money -= 85000
                store.addLog("Purchased Lexus LS")
            }
            
            ModernShopCard(
                icon: "car.fill",
                name: "Nissan GT-R",
                description: "Godzilla of supercars",
                price: 115000,
                returns: "Prestige +13",
                volatility: "Moderate",
                color: .red,
                canAfford: store.player.money >= 115000
            ) {
                store.player.money -= 115000
                store.addLog("Purchased Nissan GT-R")
            }
            
            ModernShopCard(
                icon: "car.fill",
                name: "Honda NSX",
                description: "Hybrid supercar technology",
                price: 170000,
                returns: "Prestige +17",
                volatility: "Moderate",
                color: .red,
                canAfford: store.player.money >= 170000
            ) {
                store.player.money -= 170000
                store.addLog("Purchased Honda NSX")
            }
            
            Divider().padding(.vertical, 10)
            
            Text("🇬🇧 British Luxury")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ModernShopCard(
                icon: "car.fill",
                name: "Aston Martin DB11",
                description: "British grand tourer",
                price: 215000,
                returns: "Prestige +25",
                volatility: "High",
                color: .green,
                canAfford: store.player.money >= 215000
            ) {
                store.player.money -= 215000
                store.addLog("Purchased Aston Martin DB11")
            }
            
            ModernShopCard(
                icon: "car.fill",
                name: "Bentley Continental GT",
                description: "Handcrafted luxury",
                price: 230000,
                returns: "Prestige +27",
                volatility: "Moderate",
                color: .green,
                canAfford: store.player.money >= 230000
            ) {
                store.player.money -= 230000
                store.addLog("Purchased Bentley Continental GT")
            }
            
            ModernShopCard(
                icon: "car.fill",
                name: "McLaren 720S",
                description: "Formula 1 for the road",
                price: 300000,
                returns: "Prestige +32",
                volatility: "High",
                color: .orange,
                canAfford: store.player.money >= 300000
            ) {
                store.player.money -= 300000
                store.addLog("Purchased McLaren 720S")
            }
        }
    }
}

struct GlobalHomesSection: View {
    @ObservedObject var store: GameStore
    @ObservedObject var assetEngine: AssetEngine
    
    // Get current player location (from company or default)
    private var playerCity: String {
        store.player.company?.plantName ?? "San Francisco"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🏠 Local Properties - \(playerCity)")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            localProperties
            
            Divider().padding(.vertical, 10)
            
            Text("🌎 North America")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            northAmericanProperties
            
            Divider().padding(.vertical, 10)
            
            Text("🌍 Europe")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            europeanProperties
            
            Divider().padding(.vertical, 10)
            
            Text("🌏 Asia & Oceania")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            asianProperties
        }
    }
    
    private var localProperties: some View {
        Group {
            if playerCity.contains("San Francisco") || playerCity.contains("Mountain View") || playerCity.contains("Cupertino") {
                ModernShopCard(
                    icon: "house.fill",
                    name: "SF Bay Area Condo",
                    description: "Tech hub premium location",
                    price: 850000,
                    returns: "$3,500/mo net income",
                    volatility: "Moderate",
                    color: .cyan,
                    canAfford: store.player.money >= 850000
                ) {
                    store.buyProperty(name: "SF Bay Area Condo", type: .condo, price: 850000, monthlyExpense: 1500, rentalIncome: 5000)
                }
            } else if playerCity.contains("Seattle") {
                ModernShopCard(
                    icon: "house.fill",
                    name: "Seattle Downtown Loft",
                    description: "Emerald City modern living",
                    price: 650000,
                    returns: "$2,800/mo net income",
                    volatility: "Moderate",
                    color: .green,
                    canAfford: store.player.money >= 650000
                ) {
                    store.buyProperty(name: "Seattle Downtown Loft", type: .condo, price: 650000, monthlyExpense: 1200, rentalIncome: 4000)
                }
            } else if playerCity.contains("New York") {
                ModernShopCard(
                    icon: "building.2.fill",
                    name: "Manhattan Studio",
                    description: "Heart of the Big Apple",
                    price: 950000,
                    returns: "$4,000/mo net income",
                    volatility: "High",
                    color: .purple,
                    canAfford: store.player.money >= 950000
                ) {
                    store.buyProperty(name: "Manhattan Studio", type: .condo, price: 950000, monthlyExpense: 2000, rentalIncome: 6000)
                }
            } else {
                ModernShopCard(
                    icon: "house.fill",
                    name: "Local Property",
                    description: "Convenient neighborhood home",
                    price: 400000,
                    returns: "$1,800/mo net income",
                    volatility: "Stable",
                    color: .blue,
                    canAfford: store.player.money >= 400000
                ) {
                    store.buyProperty(name: "Local Property", type: .house, price: 400000, monthlyExpense: 800, rentalIncome: 2600)
                }
            }
        }
    }
    
    private var northAmericanProperties: some View {
        Group {
            ModernShopCard(
                icon: "building.2.fill",
                name: "Manhattan Penthouse",
                description: "NYC luxury with skyline views",
                price: 3500000,
                returns: "$15,000/mo net income",
                volatility: "Moderate",
                color: .purple,
                canAfford: store.player.money >= 3500000
            ) {
                store.buyProperty(name: "Manhattan Penthouse", type: .penthouse, price: 3500000, monthlyExpense: 5000, rentalIncome: 20000)
            }
            
            ModernShopCard(
                icon: "house.fill",
                name: "Miami Beach Villa",
                description: "Ocean-front Florida paradise",
                price: 2200000,
                returns: "$9,000/mo net income",
                volatility: "High",
                color: .cyan,
                canAfford: store.player.money >= 2200000
            ) {
                store.buyProperty(name: "Miami Beach Villa", type: .villa, price: 2200000, monthlyExpense: 3000, rentalIncome: 12000)
            }
            
            ModernShopCard(
                icon: "house.fill",
                name: "Austin Tech House",
                description: "Modern home in Silicon Hills",
                price: 750000,
                returns: "$3,200/mo net income",
                volatility: "Moderate",
                color: .orange,
                canAfford: store.player.money >= 750000
            ) {
                store.buyProperty(name: "Austin Tech House", type: .house, price: 750000, monthlyExpense: 1300, rentalIncome: 4500)
            }
            
            ModernShopCard(
                icon: "house.fill",
                name: "Vancouver Waterfront",
                description: "Canadian west coast luxury",
                price: 1800000,
                returns: "$7,500/mo net income",
                volatility: "High",
                color: .blue,
                canAfford: store.player.money >= 1800000
            ) {
                store.buyProperty(name: "Vancouver Waterfront", type: .condo, price: 1800000, monthlyExpense: 2500, rentalIncome: 10000)
            }
        }
    }
    
    private var europeanProperties: some View {
        Group {
            ModernShopCard(
                icon: "building.2.fill",
                name: "London Mayfair Flat",
                description: "Prime central London location",
                price: 2800000,
                returns: "$12,000/mo net income",
                volatility: "Low",
                color: .red,
                canAfford: store.player.money >= 2800000
            ) {
                store.buyProperty(name: "London Mayfair Flat", type: .penthouse, price: 2800000, monthlyExpense: 4000, rentalIncome: 16000)
            }
            
            ModernShopCard(
                icon: "house.fill",
                name: "Paris Apartment",
                description: "Elegant Haussmann building",
                price: 1900000,
                returns: "$8,000/mo net income",
                volatility: "Stable",
                color: .purple,
                canAfford: store.player.money >= 1900000
            ) {
                store.buyProperty(name: "Paris Apartment", type: .condo, price: 1900000, monthlyExpense: 2800, rentalIncome: 10800)
            }
            
            ModernShopCard(
                icon: "house.fill",
                name: "Munich Modern Villa",
                description: "German engineering excellence",
                price: 2100000,
                returns: "$9,000/mo net income",
                volatility: "Low",
                color: .blue,
                canAfford: store.player.money >= 2100000
            ) {
                store.buyProperty(name: "Munich Modern Villa", type: .villa, price: 2100000, monthlyExpense: 3200, rentalIncome: 12200)
            }
            
            ModernShopCard(
                icon: "house.fill",
                name: "Zurich Lake House",
                description: "Swiss Alps luxury",
                price: 3200000,
                returns: "$13,000/mo net income",
                volatility: "Low",
                color: .cyan,
                canAfford: store.player.money >= 3200000
            ) {
                store.buyProperty(name: "Zurich Lake House", type: .villa, price: 3200000, monthlyExpense: 4500, rentalIncome: 17500)
            }
            
            ModernShopCard(
                icon: "house.fill",
                name: "Amsterdam Canal House",
                description: "Historic Dutch charm",
                price: 1600000,
                returns: "$6,800/mo net income",
                volatility: "Stable",
                color: .orange,
                canAfford: store.player.money >= 1600000
            ) {
                store.buyProperty(name: "Amsterdam Canal House", type: .house, price: 1600000, monthlyExpense: 2200, rentalIncome: 9000)
            }
        }
    }
    
    private var asianProperties: some View {
        Group {
            ModernShopCard(
                icon: "building.2.fill",
                name: "Tokyo Shibuya Apartment",
                description: "Heart of Japan's tech scene",
                price: 1500000,
                returns: "$6,500/mo net income",
                volatility: "Stable",
                color: .red,
                canAfford: store.player.money >= 1500000
            ) {
                store.buyProperty(name: "Tokyo Shibuya Apartment", type: .condo, price: 1500000, monthlyExpense: 2000, rentalIncome: 8500)
            }
            
            ModernShopCard(
                icon: "building.2.fill",
                name: "Singapore Marina Bay",
                description: "Luxury in the Lion City",
                price: 2500000,
                returns: "$10,500/mo net income",
                volatility: "Low",
                color: .green,
                canAfford: store.player.money >= 2500000
            ) {
                store.buyProperty(name: "Singapore Marina Bay", type: .penthouse, price: 2500000, monthlyExpense: 3500, rentalIncome: 14000)
            }
            
            ModernShopCard(
                icon: "building.2.fill",
                name: "Hong Kong Victoria Peak",
                description: "Elite harbor view residence",
                price: 4200000,
                returns: "$18,000/mo net income",
                volatility: "High",
                color: .purple,
                canAfford: store.player.money >= 4200000
            ) {
                store.buyProperty(name: "Hong Kong Victoria Peak", type: .penthouse, price: 4200000, monthlyExpense: 6000, rentalIncome: 24000)
            }
            
            ModernShopCard(
                icon: "house.fill",
                name: "Sydney Harbor House",
                description: "Australian waterfront luxury",
                price: 2600000,
                returns: "$11,000/mo net income",
                volatility: "Moderate",
                color: .blue,
                canAfford: store.player.money >= 2600000
            ) {
                store.buyProperty(name: "Sydney Harbor House", type: .villa, price: 2600000, monthlyExpense: 3800, rentalIncome: 14800)
            }
            
            ModernShopCard(
                icon: "building.2.fill",
                name: "Dubai Palm Jumeirah",
                description: "Ultra-luxury Middle East",
                price: 3800000,
                returns: "$16,000/mo net income",
                volatility: "High",
                color: .yellow,
                canAfford: store.player.money >= 3800000
            ) {
                store.buyProperty(name: "Dubai Palm Jumeirah", type: .villa, price: 3800000, monthlyExpense: 5500, rentalIncome: 21500)
            }
        }
    }
}

struct LuxurySection: View {
    @ObservedObject var store: GameStore
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Coming Soon!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(100)
        }
    }
}

struct ModernShopCard: View {
    let icon: String
    let name: String
    let description: String
    let price: Int
    let returns: String
    let volatility: String
    let color: Color
    let canAfford: Bool
    let action: () -> Void
    
    var body: some View {
        GlassmorphicCard {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.system(size: 20, weight: .bold))
                    
                    Text(description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        Label("$\(price.formatted())", systemImage: "dollarsign.circle")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(canAfford ? .green : .red)
                        
                        Label(returns, systemImage: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.cyan)
                    }
                    
                    Label(volatility, systemImage: "waveform.path.ecg")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                Button(action: action) {
                    Image(systemName: canAfford ? "cart.fill.badge.plus" : "lock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(canAfford ? color : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!canAfford)
            }
        }
    }
}

// MARK: - Modern Portfolio View

struct ModernPortfolioView: View {
    @ObservedObject var store: GameStore
    @ObservedObject var assetEngine: AssetEngine
    @ObservedObject var visualHub: VisualIntegrationHub
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button {
                    withAnimation {
                        store.closeOverlay()
                    }
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.purple)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                VStack {
                    Text("Portfolio")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Net Worth: $\(calculateNetWorth().formatted())")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                Color.clear.frame(width: 28)
            }
            .padding()
            
            // Tab Selection
            Picker("Category", selection: $selectedTab) {
                Text("Investments").tag(0)
                Text("Properties").tag(1)
                Text("Vehicles").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // Content
            ScrollView {
                VStack(spacing: 20) {
                    if selectedTab == 0 {
                        InvestmentsPortfolioSection(assetEngine: assetEngine)
                    } else if selectedTab == 1 {
                        PropertiesPortfolioSection(assetEngine: assetEngine)
                    } else {
                        VehiclesPortfolioSection(assetEngine: assetEngine)
                    }
                }
                .padding()
            }
        }
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private func calculateNetWorth() -> Int {
        return store.player.money + assetEngine.calculateTotalNetWorth()
    }
}

struct InvestmentsPortfolioSection: View {
    @ObservedObject var assetEngine: AssetEngine
    
    var body: some View {
        if assetEngine.ownedInvestments.isEmpty {
            EmptyPortfolioView(message: "No investments yet", icon: "chart.line.uptrend.xyaxis")
        } else {
            VStack(spacing: 15) {
                ForEach(assetEngine.ownedInvestments) { investment in
                    PortfolioInvestmentCard(investment: investment) {
                        let result = assetEngine.sellInvestment(investmentId: investment.id)
                        // Money added through callback if needed
                    }
                }
            }
        }
    }
}

struct PropertiesPortfolioSection: View {
    @ObservedObject var assetEngine: AssetEngine
    
    var body: some View {
        if assetEngine.ownedProperties.isEmpty {
            EmptyPortfolioView(message: "No properties yet", icon: "house.fill")
        } else {
            VStack(spacing: 15) {
                ForEach(assetEngine.ownedProperties) { property in
                    PortfolioPropertyCard(property: property) {
                        let result = assetEngine.sellProperty(propertyId: property.id)
                        // Money added through callback if needed
                    }
                }
            }
        }
    }
}

struct VehiclesPortfolioSection: View {
    @ObservedObject var assetEngine: AssetEngine
    
    var body: some View {
        if assetEngine.ownedVehicles.isEmpty {
            EmptyPortfolioView(message: "No vehicles yet", icon: "car.fill")
        } else {
            VStack(spacing: 15) {
                ForEach(assetEngine.ownedVehicles) { vehicle in
                    PortfolioVehicleCard(vehicle: vehicle) {
                        let result = assetEngine.sellVehicle(vehicleId: vehicle.id)
                        // Money added through callback if needed
                    }
                }
            }
        }
    }
}

struct EmptyPortfolioView: View {
    let message: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.secondary)
            
            Text("Visit the shop to start building your wealth!")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(60)
    }
}

struct PortfolioInvestmentCard: View {
    let investment: Investment
    let onSell: () -> Void
    
    private var gain: Int {
        investment.currentValue - investment.purchasePrice
    }
    
    private var gainPercentage: Double {
        Double(gain) / Double(investment.purchasePrice) * 100
    }
    
    var body: some View {
        GlassmorphicCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(investment.name)
                            .font(.system(size: 20, weight: .bold))
                        
                        Text(investment.type.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("$\(investment.currentValue.formatted())")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.green)
                        
                        HStack(spacing: 4) {
                            Image(systemName: gain >= 0 ? "arrow.up.right" : "arrow.down.right")
                            Text("\(gain >= 0 ? "+" : "")$\(gain.formatted())")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(gain >= 0 ? .green : .red)
                    }
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Purchase Price")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("$\(investment.purchasePrice.formatted())")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Return")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("\(gainPercentage >= 0 ? "+" : "")\(gainPercentage.formatted(.number.precision(.fractionLength(1))))%")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(gain >= 0 ? .green : .red)
                    }
                    
                    NeonButton(title: "Sell", icon: "dollarsign", action: onSell, color: .orange)
                }
            }
        }
    }
}

struct PortfolioPropertyCard: View {
    let property: Property
    let onSell: () -> Void
    
    private var monthlyIncome: Int {
        property.rentalIncome - property.monthlyExpense
    }
    
    var body: some View {
        GlassmorphicCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(property.name)
                            .font(.system(size: 20, weight: .bold))
                        
                        Text(property.type.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("$\(property.currentValue.formatted())")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.green)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "house.fill")
                            Text(property.location)
                        }
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Monthly Income:")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            Text("$\(monthlyIncome.formatted())")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.green)
                        }
                        
                        HStack {
                            Text("Annual:")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                            Text("$\((monthlyIncome * 12).formatted())")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.green)
                        }
                    }
                    
                    Spacer()
                    
                    NeonButton(title: "Sell", icon: "dollarsign", action: onSell, color: .orange)
                }
            }
        }
    }
}

struct PortfolioVehicleCard: View {
    let vehicle: Vehicle
    let onSell: () -> Void
    
    private var valueChange: Int {
        vehicle.currentValue - vehicle.purchasePrice
    }
    
    private var valueChangePercentage: Double {
        Double(valueChange) / Double(vehicle.purchasePrice) * 100
    }
    
    var body: some View {
        GlassmorphicCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(vehicle.name)
                            .font(.system(size: 20, weight: .bold))
                        
                        HStack {
                            Text(vehicle.manufacturer)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("•")
                                .foregroundColor(.secondary)
                            
                            Text(vehicle.origin.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Text(vehicle.type.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(.ultraThinMaterial))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("$\(vehicle.currentValue.formatted())")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(valueChange >= 0 ? .green : .orange)
                        
                        HStack(spacing: 4) {
                            Image(systemName: valueChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                            Text("\(valueChange >= 0 ? "+" : "")$\(valueChange.formatted())")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(valueChange >= 0 ? .green : .orange)
                    }
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Purchase Price")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("$\(vehicle.purchasePrice.formatted())")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Value Change")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("\(valueChangePercentage >= 0 ? "+" : "")\(valueChangePercentage.formatted(.number.precision(.fractionLength(1))))%")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(valueChange >= 0 ? .green : .orange)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .foregroundColor(.orange)
                            Text("Monthly Maintenance:")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            Text("$\(vehicle.monthlyMaintenance.formatted())")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Prestige Boost:")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            Text("+\(vehicle.prestigeBoost)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Spacer()
                    
                    NeonButton(title: "Sell", icon: "dollarsign", action: onSell, color: .orange)
                }
            }
        }
    }
}
