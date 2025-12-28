import SwiftUI
import MetalKit

// MARK: - Visual Integration Hub
// Central system for managing all Metal 4 visual components

@MainActor
class VisualIntegrationHub: ObservableObject {
    @Published var metalAssetRenderer: MetalAssetRenderer
    @Published var playerCustomizationEngine: PlayerCustomizationEngine
    @Published var enableParticleEffects = true
    @Published var enableHolographicUI = true
    @Published var enable3DPreviews = true
    @Published var graphicsQuality: GraphicsQuality = .high
    
    init() {
        self.metalAssetRenderer = MetalAssetRenderer()
        self.playerCustomizationEngine = PlayerCustomizationEngine()
    }
    
    // MARK: - Graphics Settings
    
    func setGraphicsQuality(_ quality: GraphicsQuality) {
        graphicsQuality = quality
        
        switch quality {
        case .low:
            enableParticleEffects = false
            enableHolographicUI = false
            enable3DPreviews = false
        case .medium:
            enableParticleEffects = false
            enableHolographicUI = true
            enable3DPreviews = true
        case .high:
            enableParticleEffects = true
            enableHolographicUI = true
            enable3DPreviews = true
        case .ultra:
            enableParticleEffects = true
            enableHolographicUI = true
            enable3DPreviews = true
        }
    }
    
    // MARK: - Asset Preview Generation
    
    func generateVehiclePreview(_ vehicle: Vehicle, rotation: Float) async -> MTLTexture? {
        return await metalAssetRenderer.renderVehiclePreview(vehicle: vehicle, rotation: rotation)
    }
    
    func generatePropertyPreview(_ property: Property, rotation: Float) async -> MTLTexture? {
        return await metalAssetRenderer.renderPropertyPreview(property: property, rotation: rotation)
    }
    
    func generateInvestmentVisualization(_ investment: Investment, time: Float) async -> MTLTexture? {
        return await metalAssetRenderer.renderInvestmentVisualization(investment: investment, time: time)
    }
    
    // MARK: - Player Avatar
    
    func getPlayerAvatar() -> PlayerAvatar {
        return playerCustomizationEngine.currentAvatar
    }
    
    func generateAvatarPreview(rotation: Float) async -> MTLTexture? {
        return await playerCustomizationEngine.renderAvatarPreview(rotation: rotation)
    }
}

enum GraphicsQuality: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case ultra = "Ultra"
}

// MARK: - Graphics Settings View

struct GraphicsSettingsView: View {
    @ObservedObject var visualHub: VisualIntegrationHub
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 32))
                    .foregroundColor(.purple)
                Text("Graphics Settings")
                    .font(.system(size: 28, weight: .bold))
            }
            .padding(.bottom)
            
            // Quality Preset
            VStack(alignment: .leading, spacing: 12) {
                Text("Quality Preset")
                    .font(.system(size: 18, weight: .semibold))
                
                HStack(spacing: 12) {
                    ForEach(GraphicsQuality.allCases, id: \.self) { quality in
                        Button {
                            visualHub.setGraphicsQuality(quality)
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: getQualityIcon(quality))
                                    .font(.system(size: 32))
                                Text(quality.rawValue)
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(visualHub.graphicsQuality == quality ? .blue : .clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(visualHub.graphicsQuality == quality ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Divider()
            
            // Individual Settings
            VStack(alignment: .leading, spacing: 16) {
                Text("Advanced Settings")
                    .font(.system(size: 18, weight: .semibold))
                
                GraphicsToggle(
                    title: "3D Asset Previews",
                    description: "High-quality 3D models in shop and portfolio",
                    icon: "cube.fill",
                    isOn: $visualHub.enable3DPreviews
                )
                
                GraphicsToggle(
                    title: "Particle Effects",
                    description: "Animated particles for purchases and achievements",
                    icon: "sparkles",
                    isOn: $visualHub.enableParticleEffects
                )
                
                GraphicsToggle(
                    title: "Holographic UI",
                    description: "Futuristic UI overlays and effects",
                    icon: "rectangle.3.group.fill",
                    isOn: $visualHub.enableHolographicUI
                )
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func getQualityIcon(_ quality: GraphicsQuality) -> String {
        switch quality {
        case .low: return "gauge.low"
        case .medium: return "gauge.medium"
        case .high: return "gauge.high"
        case .ultra: return "gauge.high.fill"
        }
    }
}

struct GraphicsToggle: View {
    let title: String
    let description: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.cyan)
                .frame(width: 44)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .cyan))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

// MARK: - Animated Purchase Effect

struct PurchaseEffectView: View {
    @Binding var show: Bool
    let assetName: String
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            if show {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Success Icon
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.green, .green.opacity(0.3)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 160, height: 160)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(rotation))
                    }
                    .scaleEffect(scale)
                    
                    VStack(spacing: 8) {
                        Text("Purchase Successful!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(assetName)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .opacity(opacity)
                    
                    // Particle effects
                    ParticleEffectView(particleCount: 50)
                        .frame(width: 300, height: 300)
                        .opacity(opacity)
                }
                .padding(40)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 30)
                )
                .scaleEffect(scale)
            }
        }
        .onChange(of: show) { newValue in
            if newValue {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
                withAnimation(.linear(duration: 0.5)) {
                    rotation = 360
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        show = false
                        scale = 0.5
                        opacity = 0
                        rotation = 0
                    }
                }
            }
        }
    }
}

// MARK: - Asset Value Chart View (Metal Accelerated)

struct MetalValueChartView: View {
    let values: [Double]
    let title: String
    let color: Color
    @State private var animationProgress: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
            
            GeometryReader { geometry in
                Canvas { context, size in
                    guard values.count > 1 else { return }
                    
                    let maxValue = values.max() ?? 1
                    let minValue = values.min() ?? 0
                    let range = maxValue - minValue
                    
                    var path = Path()
                    let xStep = size.width / CGFloat(values.count - 1)
                    
                    // Draw line
                    for (index, value) in values.enumerated() {
                        let x = CGFloat(index) * xStep
                        let normalizedValue = CGFloat((value - minValue) / range)
                        let y = size.height * (1 - normalizedValue) * animationProgress
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    
                    // Stroke path
                    context.stroke(
                        path,
                        with: .linearGradient(
                            Gradient(colors: [color, color.opacity(0.5)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 3
                    )
                    
                    // Fill area under curve
                    var fillPath = path
                    if let lastPoint = values.last {
                        let normalizedValue = CGFloat((lastPoint - minValue) / range)
                        let y = size.height * (1 - normalizedValue) * animationProgress
                        fillPath.addLine(to: CGPoint(x: size.width, y: size.height))
                        fillPath.addLine(to: CGPoint(x: 0, y: size.height))
                    }
                    
                    context.fill(
                        fillPath,
                        with: .linearGradient(
                            Gradient(colors: [color.opacity(0.3), color.opacity(0.05)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Draw points
                    for (index, value) in values.enumerated() {
                        let x = CGFloat(index) * xStep
                        let normalizedValue = CGFloat((value - minValue) / range)
                        let y = size.height * (1 - normalizedValue) * animationProgress
                        
                        var circle = Path()
                        circle.addEllipse(in: CGRect(
                            x: x - 4,
                            y: y - 4,
                            width: 8,
                            height: 8
                        ))
                        
                        context.fill(circle, with: .color(color))
                        context.stroke(circle, with: .color(.white), lineWidth: 2)
                    }
                }
            }
            .frame(height: 200)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                animationProgress = 1.0
            }
        }
    }
}

// MARK: - 3D Rotating Asset Display

struct Rotating3DAssetDisplay: View {
    let assetType: AssetPreviewType
    let visualHub: VisualIntegrationHub
    @State private var rotation: Float = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Holographic background
            if visualHub.enableHolographicUI {
                HolographicOverlay()
            }
            
            // 3D Asset
            if visualHub.enable3DPreviews {
                Metal3DAssetPreview(
                    assetType: assetType,
                    assetRenderer: visualHub.metalAssetRenderer
                )
                .scaleEffect(scale)
            }
            
            // Particle effects
            if visualHub.enableParticleEffects {
                ParticleEffectView(particleCount: 30)
                    .allowsHitTesting(false)
            }
        }
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    scale = value
                }
        )
    }
}
