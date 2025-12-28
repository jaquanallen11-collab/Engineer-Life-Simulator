// Game Models for Engineer Life Simulator
import Foundation

// MARK: - Property & Asset Models

struct Property: Identifiable, Codable {
    let id: String
    let name: String
    let type: PropertyType
    let purchasePrice: Int
    let currentValue: Int
    let monthlyExpense: Int
    let rentalIncome: Int
    let location: String // City where property is located
    let country: String
}

enum PropertyType: String, Codable {
    case condo = "Condo"
    case house = "House"
    case apartment = "Apartment Complex"
    case mansion = "Mansion"
    case villa = "Villa"
    case penthouse = "Penthouse"
    case estate = "Estate"
}

struct Vehicle: Identifiable, Codable {
    let id: String
    let name: String
    let manufacturer: String
    let type: VehicleType
    let origin: VehicleOrigin
    let purchasePrice: Int
    let currentValue: Int
    let monthlyMaintenance: Int
    let prestigeBoost: Int
}

enum VehicleType: String, Codable {
    case economy = "Economy"
    case sedan = "Sedan"
    case suv = "SUV"
    case sports = "Sports Car"
    case luxury = "Luxury"
    case exotic = "Exotic"
    case supercar = "Supercar"
    case hypercar = "Hypercar"
}

enum VehicleOrigin: String, Codable {
    case american = "American"
    case german = "German"
    case italian = "Italian"
    case japanese = "Japanese"
    case british = "British"
    case korean = "Korean"
    case french = "French"
    case swedish = "Swedish"
}

struct Investment: Identifiable, Codable {
    let id: String
    let name: String
    let type: InvestmentType
    let purchasePrice: Int
    let currentValue: Int
    let volatility: Volatility
    let annualReturn: Double
}

enum InvestmentType: String, Codable {
    case stocks = "Stocks"
    case bonds = "Bonds"
    case crypto = "Cryptocurrency"
    case index = "Index Fund"
}

enum Volatility: String, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

// MARK: - City/Location Data

enum WorldCity: String, Codable, CaseIterable {
    // North America
    case sanFrancisco = "San Francisco"
    case newYork = "New York"
    case seattle = "Seattle"
    case austin = "Austin"
    case miami = "Miami"
    case vancouver = "Vancouver"
    case toronto = "Toronto"
    
    // Europe
    case london = "London"
    case paris = "Paris"
    case munich = "Munich"
    case zurich = "Zurich"
    case stockholm = "Stockholm"
    case amsterdam = "Amsterdam"
    case dublin = "Dublin"
    
    // Asia
    case tokyo = "Tokyo"
    case singapore = "Singapore"
    case hongKong = "Hong Kong"
    case seoul = "Seoul"
    case shanghai = "Shanghai"
    case bangalore = "Bangalore"
    
    // Oceania
    case sydney = "Sydney"
    case melbourne = "Melbourne"
    
    // Middle East
    case dubai = "Dubai"
    case telaviv = "Tel Aviv"
    
    var country: String {
        switch self {
        case .sanFrancisco, .newYork, .seattle, .austin, .miami: return "USA"
        case .vancouver, .toronto: return "Canada"
        case .london: return "UK"
        case .paris: return "France"
        case .munich: return "Germany"
        case .zurich: return "Switzerland"
        case .stockholm: return "Sweden"
        case .amsterdam: return "Netherlands"
        case .dublin: return "Ireland"
        case .tokyo: return "Japan"
        case .singapore: return "Singapore"
        case .hongKong: return "Hong Kong"
        case .seoul: return "South Korea"
        case .shanghai: return "China"
        case .bangalore: return "India"
        case .sydney, .melbourne: return "Australia"
        case .dubai: return "UAE"
        case .telaviv: return "Israel"
        }
    }
    
    var costOfLivingMultiplier: Double {
        switch self {
        case .sanFrancisco, .newYork, .hongKong, .zurich, .singapore: return 1.8
        case .london, .sydney, .tokyo, .dubai: return 1.6
        case .seattle, .munich, .vancouver, .stockholm: return 1.4
        case .austin, .paris, .melbourne, .telaviv: return 1.2
        case .toronto, .seoul, .amsterdam, .dublin: return 1.1
        case .miami, .shanghai, .bangalore: return 1.0
        }
    }
}
