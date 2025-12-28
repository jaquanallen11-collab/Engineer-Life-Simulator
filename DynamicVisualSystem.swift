import Metal
import MetalKit
import SwiftUI

// MARK: - Dynamic Visual System

@MainActor
class DynamicVisualSystem: ObservableObject {
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var library: MTLLibrary
    
    // Compute pipelines
    private var waveSimulationPipeline: MTLComputePipelineState?
    private var particlePhysicsPipeline: MTLComputePipelineState?
    private var fieldEffectPipeline: MTLComputePipelineState?
    
    // Buffers
    private var waveGridBuffer: MTLBuffer?
    private var energyFieldBuffer: MTLBuffer?
    private var dynamicParticlesBuffer: MTLBuffer?
    
    // Parameters
    @Published var visualIntensity: Float = 1.0
    @Published var energyLevel: Float = 0.5
    @Published var moodColor: SIMD3<Float> = SIMD3(0.4, 0.6, 1.0)
    @Published var particleCount: Int = 500
    @Published var time: Float = 0
    
    private let gridSize: Int = 128
    
    init(device: MTLDevice, library: MTLLibrary) {
        self.device = device
        self.library = library
        self.commandQueue = device.makeCommandQueue()!
        
        setupPipelines()
        setupBuffers()
    }
    
    private func setupPipelines() {
        // Setup wave simulation compute pipeline
        if let function = library.makeFunction(name: "waveSimulation") {
            waveSimulationPipeline = try? device.makeComputePipelineState(function: function)
        }
        
        // Setup particle physics pipeline
        if let function = library.makeFunction(name: "advancedParticlePhysics") {
            particlePhysicsPipeline = try? device.makeComputePipelineState(function: function)
        }
        
        // Setup energy field pipeline
        if let function = library.makeFunction(name: "energyFieldEffect") {
            fieldEffectPipeline = try? device.makeComputePipelineState(function: function)
        }
    }
    
    private func setupBuffers() {
        // Create wave grid buffer
        let waveGridSize = gridSize * gridSize * 4 * MemoryLayout<Float>.stride
        waveGridBuffer = device.makeBuffer(length: waveGridSize, options: .storageModeShared)
        
        // Initialize wave grid with random values
        if let buffer = waveGridBuffer?.contents().bindMemory(to: Float.self, capacity: gridSize * gridSize * 4) {
            for i in 0..<(gridSize * gridSize * 4) {
                buffer[i] = Float.random(in: -0.1...0.1)
            }
        }
        
        // Create energy field buffer
        let fieldSize = gridSize * gridSize * MemoryLayout<Float>.stride
        energyFieldBuffer = device.makeBuffer(length: fieldSize, options: .storageModeShared)
        
        // Create dynamic particles buffer
        setupDynamicParticles()
    }
    
    private func setupDynamicParticles() {
        struct DynamicParticle {
            var position: SIMD2<Float>
            var velocity: SIMD2<Float>
            var acceleration: SIMD2<Float>
            var color: SIMD4<Float>
            var size: Float
            var energy: Float
            var lifetime: Float
            var maxLifetime: Float
        }
        
        var particles: [DynamicParticle] = []
        for i in 0..<particleCount {
            let angle = Float(i) / Float(particleCount) * 2.0 * .pi
            let radius = Float.random(in: 0.3...0.8)
            
            particles.append(DynamicParticle(
                position: SIMD2(cos(angle) * radius, sin(angle) * radius),
                velocity: SIMD2(Float.random(in: -0.01...0.01), Float.random(in: -0.01...0.01)),
                acceleration: SIMD2(0, 0),
                color: SIMD4(moodColor.x, moodColor.y, moodColor.z, 1.0),
                size: Float.random(in: 0.005...0.02),
                energy: Float.random(in: 0.5...1.0),
                lifetime: Float.random(in: 0...10),
                maxLifetime: 10.0
            ))
        }
        
        let bufferSize = particles.count * MemoryLayout<DynamicParticle>.stride
        dynamicParticlesBuffer = device.makeBuffer(bytes: particles, length: bufferSize, options: .storageModeShared)
    }
    
    // MARK: - Update Methods
    
    func update(deltaTime: Float, stressLevel: Float, successRate: Float, careerProgress: Float) {
        time += deltaTime
        
        // Update energy level based on game state
        energyLevel = (1.0 - stressLevel) * successRate
        
        // Update mood color based on career progress
        updateMoodColor(progress: careerProgress, stress: stressLevel)
        
        // Run compute updates
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        
        // Update wave simulation
        updateWaveSimulation(commandBuffer: commandBuffer, deltaTime: deltaTime)
        
        // Update energy field
        updateEnergyField(commandBuffer: commandBuffer)
        
        // Update particle physics
        updateParticlePhysics(commandBuffer: commandBuffer, deltaTime: deltaTime)
        
        commandBuffer.commit()
    }
    
    private func updateMoodColor(progress: Float, stress: Float) {
        // Blue-ish when calm, red-ish when stressed, green-ish when successful
        let stressColor = SIMD3<Float>(1.0, 0.3, 0.2) // Red
        let calmColor = SIMD3<Float>(0.2, 0.4, 1.0)   // Blue
        let successColor = SIMD3<Float>(0.2, 1.0, 0.4) // Green
        
        let baseColor = mix(calmColor, stressColor, t: stress)
        moodColor = mix(baseColor, successColor, t: progress)
    }
    
    private func updateWaveSimulation(commandBuffer: MTLCommandBuffer, deltaTime: Float) {
        guard let pipeline = waveSimulationPipeline,
              let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
        
        encoder.setComputePipelineState(pipeline)
        encoder.setBuffer(waveGridBuffer, offset: 0, index: 0)
        
        var params = WaveParams(
            time: time,
            deltaTime: deltaTime,
            intensity: visualIntensity,
            energyLevel: energyLevel,
            gridSize: UInt32(gridSize)
        )
        encoder.setBytes(&params, length: MemoryLayout<WaveParams>.stride, index: 1)
        
        let threadGroupSize = MTLSize(width: 16, height: 16, depth: 1)
        let threadGroups = MTLSize(
            width: (gridSize + 15) / 16,
            height: (gridSize + 15) / 16,
            depth: 1
        )
        
        encoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
        encoder.endEncoding()
    }
    
    private func updateEnergyField(commandBuffer: MTLCommandBuffer) {
        guard let pipeline = fieldEffectPipeline,
              let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
        
        encoder.setComputePipelineState(pipeline)
        encoder.setBuffer(energyFieldBuffer, offset: 0, index: 0)
        encoder.setBuffer(waveGridBuffer, offset: 0, index: 1)
        
        var params = FieldParams(
            time: time,
            energyLevel: energyLevel,
            moodColor: moodColor,
            gridSize: UInt32(gridSize)
        )
        encoder.setBytes(&params, length: MemoryLayout<FieldParams>.stride, index: 2)
        
        let threadGroupSize = MTLSize(width: 16, height: 16, depth: 1)
        let threadGroups = MTLSize(
            width: (gridSize + 15) / 16,
            height: (gridSize + 15) / 16,
            depth: 1
        )
        
        encoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
        encoder.endEncoding()
    }
    
    private func updateParticlePhysics(commandBuffer: MTLCommandBuffer, deltaTime: Float) {
        guard let pipeline = particlePhysicsPipeline,
              let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
        
        encoder.setComputePipelineState(pipeline)
        encoder.setBuffer(dynamicParticlesBuffer, offset: 0, index: 0)
        encoder.setBuffer(energyFieldBuffer, offset: 0, index: 1)
        
        var params = ParticleParams(
            time: time,
            deltaTime: deltaTime,
            energyLevel: energyLevel,
            moodColor: moodColor,
            particleCount: UInt32(particleCount),
            gridSize: UInt32(gridSize)
        )
        encoder.setBytes(&params, length: MemoryLayout<ParticleParams>.stride, index: 2)
        
        let threadGroupSize = MTLSize(width: 64, height: 1, depth: 1)
        let threadGroups = MTLSize(
            width: (particleCount + 63) / 64,
            height: 1,
            depth: 1
        )
        
        encoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
        encoder.endEncoding()
    }
    
    // MARK: - Rendering Integration
    
    func renderToTexture(commandBuffer: MTLCommandBuffer, targetTexture: MTLTexture) {
        // This would render the visual system to a texture for compositing
        // Implementation depends on specific rendering needs
    }
    
    func getEnergyFieldBuffer() -> MTLBuffer? {
        return energyFieldBuffer
    }
    
    func getWaveGridBuffer() -> MTLBuffer? {
        return waveGridBuffer
    }
    
    func getDynamicParticlesBuffer() -> MTLBuffer? {
        return dynamicParticlesBuffer
    }
    
    func getDevice() -> MTLDevice {
        return device
    }
    
    func getCommandQueue() -> MTLCommandQueue {
        return commandQueue
    }
    
    // MARK: - Interactive Methods
    
    func triggerWaveAt(position: SIMD2<Float>, strength: Float) {
        guard let buffer = waveGridBuffer?.contents().bindMemory(to: Float.self, capacity: gridSize * gridSize * 4) else { return }
        
        let gridX = Int((position.x + 1.0) * 0.5 * Float(gridSize))
        let gridY = Int((position.y + 1.0) * 0.5 * Float(gridSize))
        
        for dy in -5...5 {
            for dx in -5...5 {
                let x = gridX + dx
                let y = gridY + dy
                
                guard x >= 0 && x < gridSize && y >= 0 && y < gridSize else { continue }
                
                let dist = sqrtf(Float(dx * dx + dy * dy))
                let falloff = max(0, 1.0 - dist / 5.0)
                let index = (y * gridSize + x) * 4
                
                buffer[index + 2] += strength * falloff // Add to wave height
            }
        }
    }
    
    func spawnParticleBurst(position: SIMD2<Float>, count: Int, color: SIMD3<Float>) {
        // Spawn temporary particle burst at position
        // Implementation would modify the particle buffer
    }
    
    func setVisualMode(mode: VisualMode) {
        switch mode {
        case .calm:
            visualIntensity = 0.5
            particleCount = 200
        case .energetic:
            visualIntensity = 1.5
            particleCount = 800
        case .focused:
            visualIntensity = 0.8
            particleCount = 400
        case .stressed:
            visualIntensity = 2.0
            particleCount = 1000
        }
    }
}

// MARK: - Supporting Structures

struct WaveParams {
    var time: Float
    var deltaTime: Float
    var intensity: Float
    var energyLevel: Float
    var gridSize: UInt32
}

struct FieldParams {
    var time: Float
    var energyLevel: Float
    var moodColor: SIMD3<Float>
    var gridSize: UInt32
}

struct ParticleParams {
    var time: Float
    var deltaTime: Float
    var energyLevel: Float
    var moodColor: SIMD3<Float>
    var particleCount: UInt32
    var gridSize: UInt32
}

enum VisualMode {
    case calm
    case energetic
    case focused
    case stressed
}

// MARK: - Helper Functions

func mix<T: SIMD>(_ a: T, _ b: T, t: T.Scalar) -> T where T.Scalar: FloatingPoint {
    return a * (1 - t) + b * t
}
