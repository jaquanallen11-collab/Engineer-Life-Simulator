import SwiftUI
import Metal
import MetalKit
import CoreML
import Combine

// MARK: - App Entry

@main
struct EngineerLifeSimulatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1200, minHeight: 800)
                .preferredColorScheme(.dark)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

// MARK: - Main Content View

struct ContentView: View {
    @StateObject private var store = GameStore()
    @StateObject private var metalRenderer = MetalRenderer()
    @StateObject private var mlPredictor = CareerPredictor()
    @StateObject private var npcEngine = NPCEngine()
    @StateObject private var assetEngine = AssetEngine()
    @StateObject private var visualHub = VisualIntegrationHub()
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            // Metal-rendered animated background
            MetalBackgroundView(renderer: metalRenderer)
                .ignoresSafeArea()
                .blur(radius: 50)
                .opacity(0.3)
            
            // Gradient overlay
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.3),
                    Color.blue.opacity(0.2),
                    Color.black.opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Main game content
            Group {
                switch store.screen {
                case .start:
                    ModernStartView(store: store)
                case .ivyExam:
                    ModernIvyExamView(store: store)
                case .majorMinorSelection:
                    MajorMinorSelectionView(store: store)
                case .university:
                    ModernUniversityView(store: store)
                case .graduation:
                    ModernGraduationView(store: store)
                case .companies:
                    ModernCompanyView(store: store, npcEngine: npcEngine)
                case .jobs:
                    ModernJobView(store: store)
                case .game:
                    ModernGameView(store: store, metalRenderer: metalRenderer, mlPredictor: mlPredictor, npcEngine: npcEngine, assetEngine: assetEngine, visualHub: visualHub)
                case .jobOffers:
                    ModernJobOffersView(store: store)
                case .shop:
                    ModernShopView(store: store, assetEngine: assetEngine, visualHub: visualHub)
                case .portfolio:
                    ModernPortfolioView(store: store, assetEngine: assetEngine, visualHub: visualHub)
                }
            }
            .transition(.asymmetric(
                insertion: .scale.combined(with: .opacity),
                removal: .scale.combined(with: .opacity)
            ))
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: store.screen)
            
            // Settings overlay
            if showSettings {
                GraphicsSettingsView(visualHub: visualHub)
                    .frame(width: 600, height: 500)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .overlay(alignment: .topTrailing) {
            // Settings button
            Button {
                withAnimation {
                    showSettings.toggle()
                }
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(.ultraThinMaterial))
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
    }
}
