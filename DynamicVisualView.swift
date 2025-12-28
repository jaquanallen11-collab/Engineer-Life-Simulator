import SwiftUI
import MetalKit

// MARK: - Dynamic Visual View

struct DynamicVisualView: View {
    @ObservedObject var visualSystem: DynamicVisualSystem
    @ObservedObject var renderer: MetalRenderer
    @State private var lastUpdate = Date()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base Metal background with particles
                MetalBackgroundView(renderer: renderer)
                    .opacity(0.6)
                
                // Dynamic visual overlay
                DynamicVisualMetalView(visualSystem: visualSystem)
                    .opacity(0.8)
                
                // Interactive overlay
                InteractiveVisualOverlay(visualSystem: visualSystem)
            }
            .onAppear {
                startUpdateLoop()
            }
        }
    }
    
    private func startUpdateLoop() {
        Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            let now = Date()
            let deltaTime = Float(now.timeIntervalSince(lastUpdate))
            lastUpdate = now
            
            // Update with dummy game state - integrate with real game state
            visualSystem.update(
                deltaTime: deltaTime,
                stressLevel: 0.3,
                successRate: 0.7,
                careerProgress: 0.5
            )
        }
    }
}

// MARK: - Dynamic Visual Metal View

struct DynamicVisualMetalView: NSViewRepresentable {
    @ObservedObject var visualSystem: DynamicVisualSystem
    
    func makeNSView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = visualSystem.getDevice()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = false
        mtkView.isPaused = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        mtkView.framebufferOnly = false
        return mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(visualSystem: visualSystem)
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        var visualSystem: DynamicVisualSystem
        var renderPipeline: MTLRenderPipelineState?
        var device: MTLDevice
        var commandQueue: MTLCommandQueue
        
        init(visualSystem: DynamicVisualSystem) {
            self.visualSystem = visualSystem
            self.device = visualSystem.getDevice()
            self.commandQueue = visualSystem.getCommandQueue()
            super.init()
            setupRenderPipeline()
        }
        
        func setupRenderPipeline() {
            let library = device.makeDefaultLibrary()
            let vertexFunction = library?.makeFunction(name: "dynamicVisualVertex")
            let fragmentFunction = library?.makeFunction(name: "dynamicVisualFragment")
            
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            
            pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
            pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
            pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
            pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
            pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
            
            renderPipeline = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let descriptor = view.currentRenderPassDescriptor,
                  let commandBuffer = commandQueue.makeCommandBuffer(),
                  let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor),
                  let pipeline = renderPipeline else {
                return
            }
            
            renderEncoder.setRenderPipelineState(pipeline)
            
            // Set buffers from visual system
            if let particleBuffer = visualSystem.getDynamicParticlesBuffer() {
                renderEncoder.setVertexBuffer(particleBuffer, offset: 0, index: 0)
            }
            
            if let energyBuffer = visualSystem.getEnergyFieldBuffer() {
                renderEncoder.setFragmentBuffer(energyBuffer, offset: 0, index: 1)
            }
            
            var params = VisualRenderParams(
                time: visualSystem.time,
                intensity: visualSystem.visualIntensity,
                energyLevel: visualSystem.energyLevel,
                moodColor: visualSystem.moodColor,
                particleCount: UInt32(visualSystem.particleCount)
            )
            renderEncoder.setVertexBytes(&params, length: MemoryLayout<VisualRenderParams>.stride, index: 1)
            renderEncoder.setFragmentBytes(&params, length: MemoryLayout<VisualRenderParams>.stride, index: 0)
            
            // Draw particles
            renderEncoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: visualSystem.particleCount)
            
            renderEncoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}

struct VisualRenderParams {
    var time: Float
    var intensity: Float
    var energyLevel: Float
    var moodColor: SIMD3<Float>
    var particleCount: UInt32
}

// MARK: - Interactive Visual Overlay

struct InteractiveVisualOverlay: View {
    @ObservedObject var visualSystem: DynamicVisualSystem
    @State private var dragLocation: CGPoint = .zero
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        dragLocation = value.location
                        handleInteraction(at: value.location)
                    }
            )
            .onTapGesture { location in
                handleTap(at: location)
            }
    }
    
    private func handleInteraction(at point: CGPoint) {
        // Convert screen coordinates to normalized device coordinates
        let normalizedX = Float(point.x) / Float(UIScreen.main.bounds.width) * 2.0 - 1.0
        let normalizedY = -(Float(point.y) / Float(UIScreen.main.bounds.height) * 2.0 - 1.0)
        
        visualSystem.triggerWaveAt(
            position: SIMD2(normalizedX, normalizedY),
            strength: 0.5
        )
    }
    
    private func handleTap(at point: CGPoint) {
        let normalizedX = Float(point.x) / Float(UIScreen.main.bounds.width) * 2.0 - 1.0
        let normalizedY = -(Float(point.y) / Float(UIScreen.main.bounds.height) * 2.0 - 1.0)
        
        visualSystem.triggerWaveAt(
            position: SIMD2(normalizedX, normalizedY),
            strength: 1.5
        )
        
        visualSystem.spawnParticleBurst(
            position: SIMD2(normalizedX, normalizedY),
            count: 20,
            color: visualSystem.moodColor
        )
    }
}

// MARK: - Control Panel for Visual System

struct VisualControlPanel: View {
    @ObservedObject var visualSystem: DynamicVisualSystem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Visual Controls")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Intensity: \(visualSystem.visualIntensity, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Slider(value: $visualSystem.visualIntensity, in: 0...3)
                    .accentColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Energy Level: \(visualSystem.energyLevel, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Slider(value: $visualSystem.energyLevel, in: 0...1)
                    .accentColor(.green)
            }
            
            Text("Visual Mode")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            HStack(spacing: 10) {
                VisualModeButton(title: "Calm", mode: .calm, visualSystem: visualSystem)
                VisualModeButton(title: "Focus", mode: .focused, visualSystem: visualSystem)
                VisualModeButton(title: "Energy", mode: .energetic, visualSystem: visualSystem)
                VisualModeButton(title: "Stress", mode: .stressed, visualSystem: visualSystem)
            }
            
            ColorPicker("Mood Color", selection: Binding(
                get: {
                    Color(
                        red: Double(visualSystem.moodColor.x),
                        green: Double(visualSystem.moodColor.y),
                        blue: Double(visualSystem.moodColor.z)
                    )
                },
                set: { color in
                    if let components = color.cgColor?.components {
                        visualSystem.moodColor = SIMD3(
                            Float(components[0]),
                            Float(components[1]),
                            Float(components[2])
                        )
                    }
                }
            ))
            .foregroundColor(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.7))
                .blur(radius: 10)
        )
    }
}

struct VisualModeButton: View {
    let title: String
    let mode: VisualMode
    @ObservedObject var visualSystem: DynamicVisualSystem
    
    var body: some View {
        Button(action: {
            visualSystem.setVisualMode(mode: mode)
        }) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.6))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#if DEBUG
struct DynamicVisualView_Previews: PreviewProvider {
    static var previews: some View {
        let device = MTLCreateSystemDefaultDevice()!
        let library = device.makeDefaultLibrary()!
        let visualSystem = DynamicVisualSystem(device: device, library: library)
        let renderer = MetalRenderer()
        
        return DynamicVisualView(visualSystem: visualSystem, renderer: renderer)
            .frame(width: 800, height: 600)
    }
}
#endif
