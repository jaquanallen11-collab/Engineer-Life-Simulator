import Foundation
import Metal
import MetalKit
import SwiftUI

// MARK: - Metal 4 Asset Renderer - 3D Visualization System

@MainActor
class MetalAssetRenderer: ObservableObject {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private var library: MTLLibrary?
    
    // Render pipelines for different asset types
    private var vehicleRenderPipeline: MTLRenderPipelineState?
    private var propertyRenderPipeline: MTLRenderPipelineState?
    private var investmentVisualizerPipeline: MTLComputePipelineState?
    
    // Asset meshes and textures
    private var vehicleMeshes: [String: AssetMesh] = [:]
    private var propertyMeshes: [String: AssetMesh] = [:]
    
    // Visual effects
    private var particleSystem: MTLComputePipelineState?
    private var reflectionPipeline: MTLRenderPipelineState?
    private var glowEffect: MTLComputePipelineState?
    
    @Published var isRendering = false
    @Published var renderQuality: RenderQuality = .high
    
    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        
        setupLibrary()
        setupRenderPipelines()
        generateAssetMeshes()
    }
    
    private func setupLibrary() {
        do {
            let libraryURL = Bundle.main.url(forResource: "default", withExtension: "metallib")
            if let url = libraryURL {
                library = try device.makeLibrary(URL: url)
            } else {
                library = device.makeDefaultLibrary()
            }
        } catch {
            print("Error loading Metal library: \(error)")
            library = device.makeDefaultLibrary()
        }
    }
    
    private func setupRenderPipelines() {
        guard let library = library else { return }
        
        // Vehicle 3D renderer with PBR materials
        if let vertexFunction = library.makeFunction(name: "vehicleVertexShader"),
           let fragmentFunction = library.makeFunction(name: "vehicleFragmentShader") {
            
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
            
            // Enable blending for transparency
            pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
            pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
            pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            
            vehicleRenderPipeline = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        
        // Property 3D renderer with architectural details
        if let vertexFunction = library.makeFunction(name: "propertyVertexShader"),
           let fragmentFunction = library.makeFunction(name: "propertyFragmentShader") {
            
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
            
            propertyRenderPipeline = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        
        // Investment data visualizer (compute shader)
        if let computeFunction = library.makeFunction(name: "investmentVisualizer") {
            investmentVisualizerPipeline = try? device.makeComputePipelineState(function: computeFunction)
        }
        
        // Particle effects for asset acquisition
        if let particleFunction = library.makeFunction(name: "assetParticleEffect") {
            particleSystem = try? device.makeComputePipelineState(function: particleFunction)
        }
        
        // Glow effect for luxury items
        if let glowFunction = library.makeFunction(name: "luxuryGlowEffect") {
            glowEffect = try? device.makeComputePipelineState(function: glowFunction)
        }
    }
    
    // MARK: - Asset Mesh Generation
    
    private func generateAssetMeshes() {
        // Generate procedural meshes for each vehicle type
        vehicleMeshes["sports"] = generateSportCarMesh()
        vehicleMeshes["luxury"] = generateLuxurySedanMesh()
        vehicleMeshes["suv"] = generateSUVMesh()
        vehicleMeshes["supercar"] = generateSupercarMesh()
        
        // Generate property meshes
        propertyMeshes["house"] = generateHouseMesh()
        propertyMeshes["condo"] = generateCondoMesh()
        propertyMeshes["penthouse"] = generatePenthouseMesh()
        propertyMeshes["villa"] = generateVillaMesh()
    }
    
    private func generateSportCarMesh() -> AssetMesh {
        // Procedurally generate a low-poly sports car
        var vertices: [Float] = []
        var colors: [Float] = []
        
        // Car body (simplified box with aerodynamic shape)
        let carLength: Float = 2.0
        let carWidth: Float = 1.0
        let carHeight: Float = 0.6
        
        // Main body vertices
        vertices += [
            -carLength/2, 0, -carWidth/2,  // Front left bottom
            carLength/2, 0, -carWidth/2,   // Front right bottom
            carLength/2, 0, carWidth/2,    // Back right bottom
            -carLength/2, 0, carWidth/2,   // Back left bottom
            -carLength/2, carHeight, -carWidth/2,  // Front left top
            carLength/2, carHeight, -carWidth/2,   // Front right top
            carLength/2, carHeight, carWidth/2,    // Back right top
            -carLength/2, carHeight, carWidth/2    // Back left top
        ]
        
        // Sleek red color for sports car
        for _ in 0..<8 {
            colors += [0.9, 0.1, 0.1, 1.0] // RGBA
        }
        
        return AssetMesh(vertices: vertices, colors: colors, type: .vehicle)
    }
    
    private func generateLuxurySedanMesh() -> AssetMesh {
        var vertices: [Float] = []
        var colors: [Float] = []
        
        // Larger, more elegant sedan shape
        let carLength: Float = 2.5
        let carWidth: Float = 1.2
        let carHeight: Float = 0.7
        
        vertices += [
            -carLength/2, 0, -carWidth/2,
            carLength/2, 0, -carWidth/2,
            carLength/2, 0, carWidth/2,
            -carLength/2, 0, carWidth/2,
            -carLength/2, carHeight, -carWidth/2,
            carLength/2, carHeight, -carWidth/2,
            carLength/2, carHeight, carWidth/2,
            -carLength/2, carHeight, carWidth/2
        ]
        
        // Elegant black color
        for _ in 0..<8 {
            colors += [0.1, 0.1, 0.1, 1.0]
        }
        
        return AssetMesh(vertices: vertices, colors: colors, type: .vehicle)
    }
    
    private func generateSUVMesh() -> AssetMesh {
        var vertices: [Float] = []
        var colors: [Float] = []
        
        // Taller, boxier SUV shape
        let carLength: Float = 2.3
        let carWidth: Float = 1.3
        let carHeight: Float = 1.0
        
        vertices += [
            -carLength/2, 0, -carWidth/2,
            carLength/2, 0, -carWidth/2,
            carLength/2, 0, carWidth/2,
            -carLength/2, 0, carWidth/2,
            -carLength/2, carHeight, -carWidth/2,
            carLength/2, carHeight, -carWidth/2,
            carLength/2, carHeight, carWidth/2,
            -carLength/2, carHeight, carWidth/2
        ]
        
        // Dark blue SUV
        for _ in 0..<8 {
            colors += [0.1, 0.2, 0.5, 1.0]
        }
        
        return AssetMesh(vertices: vertices, colors: colors, type: .vehicle)
    }
    
    private func generateSupercarMesh() -> AssetMesh {
        var vertices: [Float] = []
        var colors: [Float] = []
        
        // Low, wide, aggressive supercar
        let carLength: Float = 2.2
        let carWidth: Float = 1.1
        let carHeight: Float = 0.5
        
        vertices += [
            -carLength/2, 0, -carWidth/2,
            carLength/2, 0, -carWidth/2,
            carLength/2, 0, carWidth/2,
            -carLength/2, 0, carWidth/2,
            -carLength/2 + 0.2, carHeight, -carWidth/2 + 0.1,
            carLength/2 - 0.2, carHeight, -carWidth/2 + 0.1,
            carLength/2 - 0.2, carHeight, carWidth/2 - 0.1,
            -carLength/2 + 0.2, carHeight, carWidth/2 - 0.1
        ]
        
        // Bright yellow/gold supercar
        for _ in 0..<8 {
            colors += [1.0, 0.8, 0.0, 1.0]
        }
        
        return AssetMesh(vertices: vertices, colors: colors, type: .vehicle)
    }
    
    private func generateHouseMesh() -> AssetMesh {
        var vertices: [Float] = []
        var colors: [Float] = []
        
        // Traditional house with roof
        let width: Float = 2.0
        let height: Float = 1.5
        let depth: Float = 2.0
        let roofHeight: Float = 0.8
        
        // Base
        vertices += [
            -width/2, 0, -depth/2,
            width/2, 0, -depth/2,
            width/2, 0, depth/2,
            -width/2, 0, depth/2,
            -width/2, height, -depth/2,
            width/2, height, -depth/2,
            width/2, height, depth/2,
            -width/2, height, depth/2,
            // Roof peak
            0, height + roofHeight, 0
        ]
        
        // Warm beige/brown house color
        for _ in 0..<9 {
            colors += [0.8, 0.7, 0.5, 1.0]
        }
        
        return AssetMesh(vertices: vertices, colors: colors, type: .property)
    }
    
    private func generateCondoMesh() -> AssetMesh {
        var vertices: [Float] = []
        var colors: [Float] = []
        
        // Modern condo building
        let width: Float = 1.5
        let height: Float = 3.0
        let depth: Float = 1.5
        
        vertices += [
            -width/2, 0, -depth/2,
            width/2, 0, -depth/2,
            width/2, 0, depth/2,
            -width/2, 0, depth/2,
            -width/2, height, -depth/2,
            width/2, height, -depth/2,
            width/2, height, depth/2,
            -width/2, height, depth/2
        ]
        
        // Modern grey/white
        for _ in 0..<8 {
            colors += [0.9, 0.9, 0.95, 1.0]
        }
        
        return AssetMesh(vertices: vertices, colors: colors, type: .property)
    }
    
    private func generatePenthouseMesh() -> AssetMesh {
        var vertices: [Float] = []
        var colors: [Float] = []
        
        // Luxurious penthouse with terrace
        let width: Float = 2.0
        let height: Float = 2.0
        let depth: Float = 2.0
        
        vertices += [
            -width/2, 0, -depth/2,
            width/2, 0, -depth/2,
            width/2, 0, depth/2,
            -width/2, 0, depth/2,
            -width/2, height, -depth/2,
            width/2, height, -depth/2,
            width/2, height, depth/2,
            -width/2, height, depth/2
        ]
        
        // Premium glass/steel look
        for _ in 0..<8 {
            colors += [0.3, 0.4, 0.6, 0.9]
        }
        
        return AssetMesh(vertices: vertices, colors: colors, type: .property)
    }
    
    private func generateVillaMesh() -> AssetMesh {
        var vertices: [Float] = []
        var colors: [Float] = []
        
        // Sprawling villa
        let width: Float = 3.0
        let height: Float = 1.8
        let depth: Float = 2.5
        
        vertices += [
            -width/2, 0, -depth/2,
            width/2, 0, -depth/2,
            width/2, 0, depth/2,
            -width/2, 0, depth/2,
            -width/2, height, -depth/2,
            width/2, height, -depth/2,
            width/2, height, depth/2,
            -width/2, height, depth/2
        ]
        
        // Mediterranean white
        for _ in 0..<8 {
            colors += [1.0, 0.95, 0.9, 1.0]
        }
        
        return AssetMesh(vertices: vertices, colors: colors, type: .property)
    }
    
    // MARK: - Rendering Functions
    
    func renderVehiclePreview(vehicle: Vehicle, rotation: Float = 0) -> MTLTexture? {
        guard let pipeline = vehicleRenderPipeline else { return nil }
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .bgra8Unorm,
            width: 512,
            height: 512,
            mipmapped: false
        )
        descriptor.usage = [.renderTarget, .shaderRead]
        
        guard let texture = device.makeTexture(descriptor: descriptor) else { return nil }
        
        // Get appropriate mesh based on vehicle type
        let meshKey = getMeshKeyForVehicle(vehicle)
        guard let mesh = vehicleMeshes[meshKey] else { return nil }
        
        // Render the vehicle
        renderAssetToTexture(texture: texture, mesh: mesh, rotation: rotation, pipeline: pipeline)
        
        return texture
    }
    
    func renderPropertyPreview(property: Property, rotation: Float = 0) -> MTLTexture? {
        guard let pipeline = propertyRenderPipeline else { return nil }
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .bgra8Unorm,
            width: 512,
            height: 512,
            mipmapped: false
        )
        descriptor.usage = [.renderTarget, .shaderRead]
        
        guard let texture = device.makeTexture(descriptor: descriptor) else { return nil }
        
        // Get appropriate mesh
        let meshKey = getMeshKeyForProperty(property)
        guard let mesh = propertyMeshes[meshKey] else { return nil }
        
        renderAssetToTexture(texture: texture, mesh: mesh, rotation: rotation, pipeline: pipeline)
        
        return texture
    }
    
    func renderInvestmentVisualization(investment: Investment, time: Float) -> MTLTexture? {
        guard let pipeline = investmentVisualizerPipeline else { return nil }
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .bgra8Unorm,
            width: 512,
            height: 512,
            mipmapped: false
        )
        descriptor.usage = [.shaderWrite, .shaderRead]
        
        guard let texture = device.makeTexture(descriptor: descriptor) else { return nil }
        
        // Compute shader to visualize investment performance
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeComputeCommandEncoder() else { return nil }
        
        encoder.setComputePipelineState(pipeline)
        encoder.setTexture(texture, index: 0)
        
        var params = InvestmentVisualizationParams(
            currentValue: Float(investment.currentValue),
            purchasePrice: Float(investment.purchasePrice),
            volatility: Float(investment.volatility == .high ? 1.0 : investment.volatility == .medium ? 0.5 : 0.2),
            time: time
        )
        encoder.setBytes(&params, length: MemoryLayout<InvestmentVisualizationParams>.stride, index: 0)
        
        let threadGroupSize = MTLSize(width: 16, height: 16, depth: 1)
        let threadGroups = MTLSize(
            width: (512 + threadGroupSize.width - 1) / threadGroupSize.width,
            height: (512 + threadGroupSize.height - 1) / threadGroupSize.height,
            depth: 1
        )
        
        encoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
        encoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        return texture
    }
    
    private func renderAssetToTexture(texture: MTLTexture, mesh: AssetMesh, rotation: Float, pipeline: MTLRenderPipelineState) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        encoder.setRenderPipelineState(pipeline)
        
        // Set up camera and lighting
        var uniforms = AssetRenderUniforms(
            modelMatrix: createRotationMatrix(rotation: rotation),
            viewMatrix: createViewMatrix(),
            projectionMatrix: createProjectionMatrix(),
            lightPosition: simd_float3(2, 3, 2),
            cameraPosition: simd_float3(0, 2, 5)
        )
        
        encoder.setVertexBytes(&uniforms, length: MemoryLayout<AssetRenderUniforms>.stride, index: 1)
        encoder.setFragmentBytes(&uniforms, length: MemoryLayout<AssetRenderUniforms>.stride, index: 0)
        
        // Create vertex buffer
        let vertexBuffer = device.makeBuffer(bytes: mesh.vertices, length: mesh.vertices.count * MemoryLayout<Float>.stride, options: [])
        let colorBuffer = device.makeBuffer(bytes: mesh.colors, length: mesh.colors.count * MemoryLayout<Float>.stride, options: [])
        
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setVertexBuffer(colorBuffer, offset: 0, index: 2)
        
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertices.count / 3)
        
        encoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
    }
    
    // MARK: - Helper Functions
    
    private func getMeshKeyForVehicle(_ vehicle: Vehicle) -> String {
        switch vehicle.type {
        case .sports, .exotic:
            return "sports"
        case .luxury, .sedan:
            return "luxury"
        case .suv:
            return "suv"
        case .supercar, .hypercar:
            return "supercar"
        default:
            return "sports"
        }
    }
    
    private func getMeshKeyForProperty(_ property: Property) -> String {
        switch property.type {
        case .house:
            return "house"
        case .condo, .apartment:
            return "condo"
        case .penthouse:
            return "penthouse"
        case .villa, .mansion, .estate:
            return "villa"
        }
    }
    
    private func createRotationMatrix(rotation: Float) -> simd_float4x4 {
        let cosR = cos(rotation)
        let sinR = sin(rotation)
        
        return simd_float4x4(
            simd_float4(cosR, 0, sinR, 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(-sinR, 0, cosR, 0),
            simd_float4(0, 0, 0, 1)
        )
    }
    
    private func createViewMatrix() -> simd_float4x4 {
        return simd_float4x4(
            simd_float4(1, 0, 0, 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(0, 0, 1, -5),
            simd_float4(0, 0, 0, 1)
        )
    }
    
    private func createProjectionMatrix() -> simd_float4x4 {
        let fov: Float = .pi / 4.0
        let aspect: Float = 1.0
        let near: Float = 0.1
        let far: Float = 100.0
        
        let ys = 1 / tan(fov * 0.5)
        let xs = ys / aspect
        let zs = far / (far - near)
        
        return simd_float4x4(
            simd_float4(xs, 0, 0, 0),
            simd_float4(0, ys, 0, 0),
            simd_float4(0, 0, zs, -near * zs),
            simd_float4(0, 0, 1, 0)
        )
    }
}

// MARK: - Supporting Structures

struct AssetMesh {
    let vertices: [Float]
    let colors: [Float]
    let type: AssetMeshType
}

enum AssetMeshType {
    case vehicle
    case property
}

struct AssetRenderUniforms {
    var modelMatrix: simd_float4x4
    var viewMatrix: simd_float4x4
    var projectionMatrix: simd_float4x4
    var lightPosition: simd_float3
    var cameraPosition: simd_float3
}

struct InvestmentVisualizationParams {
    var currentValue: Float
    var purchasePrice: Float
    var volatility: Float
    var time: Float
}

enum RenderQuality {
    case low, medium, high, ultra
    
    var resolution: Int {
        switch self {
        case .low: return 256
        case .medium: return 512
        case .high: return 1024
        case .ultra: return 2048
        }
    }
}
