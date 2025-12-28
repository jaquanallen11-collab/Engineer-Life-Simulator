import SwiftUI
import MetalKit

// MARK: - Enhanced Asset Preview Views with Metal 4 Rendering

struct Metal3DAssetPreview: View {
    let assetType: AssetPreviewType
    let assetRenderer: MetalAssetRenderer
    @State private var rotation: Float = 0
    @State private var isRotating = true
    
    var body: some View {
        ZStack {
            // Metal rendered 3D view
            MetalAssetView(
                renderer: assetRenderer,
                assetType: assetType,
                rotation: $rotation
            )
            .frame(width: 300, height: 300)
            
            // Controls overlay
            VStack {
                Spacer()
                
                HStack {
                    Button {
                        isRotating.toggle()
                    } label: {
                        Image(systemName: isRotating ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
            }
        }
        .onAppear {
            startRotation()
        }
    }
    
    private func startRotation() {
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            if isRotating {
                rotation += 0.02
            }
        }
    }
}

enum AssetPreviewType {
    case vehicle(Vehicle)
    case property(Property)
    case investment(Investment)
}

struct MetalAssetView: UIViewRepresentable {
    let renderer: MetalAssetRenderer
    let assetType: AssetPreviewType
    @Binding var rotation: Float
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.delegate = context.coordinator
        mtkView.isPaused = false
        mtkView.enableSetNeedsDisplay = false
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.rotation = rotation
        context.coordinator.assetType = assetType
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(renderer: renderer, assetType: assetType)
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        var renderer: MetalAssetRenderer
        var assetType: AssetPreviewType
        var rotation: Float = 0
        
        init(renderer: MetalAssetRenderer, assetType: AssetPreviewType) {
            self.renderer = renderer
            self.assetType = assetType
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
        
        func draw(in view: MTKView) {
            // Render based on asset type
            Task { @MainActor in
                switch assetType {
                case .vehicle(let vehicle):
                    _ = renderer.renderVehiclePreview(vehicle: vehicle, rotation: rotation)
                case .property(let property):
                    _ = renderer.renderPropertyPreview(property: property, rotation: rotation)
                case .investment(let investment):
                    _ = renderer.renderInvestmentVisualization(investment: investment, time: rotation)
                }
            }
        }
    }
}

// MARK: - Enhanced Shop Card with 3D Preview

struct Enhanced3DShopCard: View {
    let icon: String
    let name: String
    let description: String
    let price: Int
    let returns: String
    let volatility: String
    let color: Color
    let canAfford: Bool
    let previewType: AssetPreviewType
    let assetRenderer: MetalAssetRenderer
    let action: () -> Void
    
    @State private var showPreview = false
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // 3D Preview Thumbnail
                ZStack {
                    if showPreview {
                        Metal3DAssetPreview(assetType: previewType, assetRenderer: assetRenderer)
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        // Fallback icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [color, color.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: icon)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .onHover { hovering in
                    withAnimation {
                        isHovered = hovering
                        showPreview = hovering
                    }
                }
                .scaleEffect(isHovered ? 1.05 : 1.0)
                .shadow(color: isHovered ? color.opacity(0.5) : .clear, radius: 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
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
                
                Image(systemName: canAfford ? "cart.fill.badge.plus" : "lock.fill")
                    .font(.system(size: 32))
                    .foregroundColor(canAfford ? color : .gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: isHovered ? color.opacity(0.3) : .black.opacity(0.1), radius: 10)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!canAfford)
    }
}

// MARK: - Enhanced Portfolio Card with 3D View

struct Enhanced3DPortfolioCard: View {
    let assetType: AssetPreviewType
    let assetRenderer: MetalAssetRenderer
    let assetName: String
    let currentValue: Int
    let purchasePrice: Int
    let additionalInfo: String
    let onSell: () -> Void
    
    @State private var showFullPreview = false
    @State private var isHovered = false
    
    private var valueChange: Int {
        currentValue - purchasePrice
    }
    
    private var valueChangePercentage: Double {
        Double(valueChange) / Double(purchasePrice) * 100
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 3D Asset Preview
            Button {
                withAnimation {
                    showFullPreview.toggle()
                }
            } label: {
                Metal3DAssetPreview(assetType: assetType, assetRenderer: assetRenderer)
                    .frame(height: showFullPreview ? 400 : 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .buttonStyle(PlainButtonStyle())
            
            // Asset Info
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(assetName)
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(additionalInfo)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("$\(currentValue.formatted())")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(valueChange >= 0 ? .green : .red)
                        
                        HStack(spacing: 4) {
                            Image(systemName: valueChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                            Text("\(valueChange >= 0 ? "+" : "")$\(valueChange.formatted())")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(valueChange >= 0 ? .green : .red)
                        
                        Text("\(valueChangePercentage >= 0 ? "+" : "")\(valueChangePercentage.formatted(.number.precision(.fractionLength(1))))%")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(valueChange >= 0 ? .green.opacity(0.8) : .red.opacity(0.8))
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Purchase Price")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("$\(purchasePrice.formatted())")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    NeonButton(
                        title: "Sell",
                        icon: "dollarsign.circle.fill",
                        action: onSell,
                        color: .orange
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 15)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - Holographic UI Overlay

struct HolographicOverlay: View {
    @State private var phase: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                for i in stride(from: 0, to: size.height, by: 4) {
                    let opacity = sin(phase + Double(i) * 0.1) * 0.1 + 0.1
                    let rect = CGRect(x: 0, y: i, width: size.width, height: 2)
                    context.fill(
                        Path(rect),
                        with: .color(.cyan.opacity(opacity))
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

// MARK: - Particle Effect View

struct ParticleEffectView: View {
    let particleCount: Int
    @State private var particles: [ParticleData] = []
    
    var body: some View {
        Canvas { context, size in
            for particle in particles {
                var circle = Path()
                circle.addEllipse(in: CGRect(
                    x: particle.position.x,
                    y: particle.position.y,
                    width: particle.size,
                    height: particle.size
                ))
                
                context.fill(
                    circle,
                    with: .color(particle.color.opacity(particle.alpha))
                )
            }
        }
        .onAppear {
            initializeParticles()
            startAnimation()
        }
    }
    
    private func initializeParticles() {
        particles = (0..<particleCount).map { _ in
            ParticleData(
                position: CGPoint(x: CGFloat.random(in: 0...300), y: CGFloat.random(in: 0...300)),
                velocity: CGVector(dx: CGFloat.random(in: -2...2), dy: CGFloat.random(in: -2...2)),
                size: CGFloat.random(in: 2...6),
                color: [Color.cyan, .purple, .blue, .pink].randomElement()!,
                alpha: CGFloat.random(in: 0.3...1.0)
            )
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            particles = particles.map { particle in
                var p = particle
                p.position.x += particle.velocity.dx
                p.position.y += particle.velocity.dy
                
                // Wrap around
                if p.position.x < 0 { p.position.x = 300 }
                if p.position.x > 300 { p.position.x = 0 }
                if p.position.y < 0 { p.position.y = 300 }
                if p.position.y > 300 { p.position.y = 0 }
                
                return p
            }
        }
    }
}

struct ParticleData {
    var position: CGPoint
    var velocity: CGVector
    var size: CGFloat
    var color: Color
    var alpha: CGFloat
}

// MARK: - Glowing Asset Badge

struct GlowingAssetBadge: View {
    let text: String
    let color: Color
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(color)
                    .shadow(color: color.opacity(glowIntensity), radius: 10)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    glowIntensity = 1.0
                }
            }
    }
}
