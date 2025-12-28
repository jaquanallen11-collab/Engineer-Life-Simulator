import Foundation
import SwiftUI
import Metal
import MetalKit

// MARK: - Player Customization Engine with Metal 4 Rendering

@MainActor
class PlayerCustomizationEngine: ObservableObject {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private var library: MTLLibrary?
    
    private var avatarRenderPipeline: MTLRenderPipelineState?
    private var skinShaderPipeline: MTLComputePipelineState?
    
    @Published var playerAvatar: PlayerAvatar
    @Published var availableCustomizations: CustomizationCatalog
    
    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal not supported")
        }
        
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        
        // Default avatar
        self.playerAvatar = PlayerAvatar()
        self.availableCustomizations = CustomizationCatalog()
        
        setupLibrary()
        setupPipelines()
    }
    
    private func setupLibrary() {
        library = device.makeDefaultLibrary()
    }
    
    private func setupPipelines() {
        guard let library = library else { return }
        
        // Avatar rendering pipeline
        if let vertexFunction = library.makeFunction(name: "avatarVertexShader"),
           let fragmentFunction = library.makeFunction(name: "avatarFragmentShader") {
            
            let descriptor = MTLRenderPipelineDescriptor()
            descriptor.vertexFunction = vertexFunction
            descriptor.fragmentFunction = fragmentFunction
            descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            descriptor.depthAttachmentPixelFormat = .depth32Float
            
            avatarRenderPipeline = try? device.makeRenderPipelineState(descriptor: descriptor)
        }
        
        // Skin shader for realistic rendering
        if let skinFunction = library.makeFunction(name: "realisticSkinShader") {
            skinShaderPipeline = try? device.makeComputePipelineState(function: skinFunction)
        }
    }
    
    // MARK: - Customization Functions
    
    func updateSkinTone(_ skinTone: SkinTone) {
        playerAvatar.skinTone = skinTone
        objectWillChange.send()
    }
    
    func updateHairStyle(_ style: HairStyle) {
        playerAvatar.hairStyle = style
        objectWillChange.send()
    }
    
    func updateHairColor(_ color: HairColor) {
        playerAvatar.hairColor = color
        objectWillChange.send()
    }
    
    func updateFacialHair(_ facialHair: FacialHair) {
        playerAvatar.facialHair = facialHair
        objectWillChange.send()
    }
    
    func updateEyeColor(_ color: EyeColor) {
        playerAvatar.eyeColor = color
        objectWillChange.send()
    }
    
    func updateBodyType(_ bodyType: BodyType) {
        playerAvatar.bodyType = bodyType
        objectWillChange.send()
    }
    
    func updateOutfit(_ outfit: Outfit) {
        playerAvatar.outfit = outfit
        objectWillChange.send()
    }
    
    func updateAccessories(_ accessories: [Accessory]) {
        playerAvatar.accessories = accessories
        objectWillChange.send()
    }
    
    // MARK: - Avatar Rendering
    
    func renderAvatarPreview(size: CGSize, rotation: Float = 0) -> MTLTexture? {
        guard let pipeline = avatarRenderPipeline else { return nil }
        
        let width = Int(size.width)
        let height = Int(size.height)
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .bgra8Unorm,
            width: width,
            height: height,
            mipmapped: false
        )
        descriptor.usage = [.renderTarget, .shaderRead]
        
        guard let texture = device.makeTexture(descriptor: descriptor) else { return nil }
        
        renderAvatarToTexture(texture: texture, rotation: rotation)
        
        return texture
    }
    
    private func renderAvatarToTexture(texture: MTLTexture, rotation: Float) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor),
              let pipeline = avatarRenderPipeline else { return }
        
        encoder.setRenderPipelineState(pipeline)
        
        // Create avatar mesh data
        let meshData = generateAvatarMesh()
        
        var uniforms = AvatarRenderUniforms(
            modelMatrix: createRotationMatrix(rotation: rotation),
            viewMatrix: createViewMatrix(),
            projectionMatrix: createProjectionMatrix(),
            skinToneColor: playerAvatar.skinTone.color,
            hairColor: playerAvatar.hairColor.color,
            eyeColor: playerAvatar.eyeColor.color,
            lightPosition: simd_float3(2, 3, 2)
        )
        
        encoder.setVertexBytes(&uniforms, length: MemoryLayout<AvatarRenderUniforms>.stride, index: 1)
        encoder.setFragmentBytes(&uniforms, length: MemoryLayout<AvatarRenderUniforms>.stride, index: 0)
        
        let vertexBuffer = device.makeBuffer(bytes: meshData.vertices, length: meshData.vertices.count * MemoryLayout<Float>.stride, options: [])
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: meshData.vertices.count / 3)
        
        encoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
    }
    
    private func generateAvatarMesh() -> (vertices: [Float], normals: [Float]) {
        var vertices: [Float] = []
        var normals: [Float] = []
        
        // Generate simplified humanoid mesh
        // Head (sphere approximation)
        let headRadius: Float = 0.5
        let segments = 20
        
        for i in 0...segments {
            let theta1 = Float(i) / Float(segments) * .pi
            let theta2 = Float(i + 1) / Float(segments) * .pi
            
            for j in 0...segments {
                let phi = Float(j) / Float(segments) * 2 * .pi
                
                // Vertex 1
                let x1 = headRadius * sin(theta1) * cos(phi)
                let y1 = headRadius * cos(theta1) + 1.5
                let z1 = headRadius * sin(theta1) * sin(phi)
                vertices += [x1, y1, z1]
                
                let nx1 = sin(theta1) * cos(phi)
                let ny1 = cos(theta1)
                let nz1 = sin(theta1) * sin(phi)
                normals += [nx1, ny1, nz1]
            }
        }
        
        // Body (cylinder)
        let bodyHeight: Float = 1.0
        let bodyRadius: Float = 0.4
        
        for i in 0...segments {
            let angle = Float(i) / Float(segments) * 2 * .pi
            let x = bodyRadius * cos(angle)
            let z = bodyRadius * sin(angle)
            
            // Top
            vertices += [x, 1.0, z]
            normals += [cos(angle), 0, sin(angle)]
            
            // Bottom
            vertices += [x, 0.0, z]
            normals += [cos(angle), 0, sin(angle)]
        }
        
        return (vertices, normals)
    }
    
    // MARK: - Matrix Helpers
    
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
            simd_float4(0, 0, 1, -4),
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

// MARK: - Player Avatar Model

struct PlayerAvatar: Codable {
    var skinTone: SkinTone = .medium
    var hairStyle: HairStyle = .short
    var hairColor: HairColor = .brown
    var facialHair: FacialHair = .none
    var eyeColor: EyeColor = .brown
    var bodyType: BodyType = .average
    var outfit: Outfit = .casual
    var accessories: [Accessory] = []
}

enum SkinTone: String, Codable, CaseIterable {
    case pale, light, medium, tan, dark, deep
    
    var color: simd_float4 {
        switch self {
        case .pale: return simd_float4(1.0, 0.95, 0.9, 1.0)
        case .light: return simd_float4(0.95, 0.85, 0.75, 1.0)
        case .medium: return simd_float4(0.85, 0.7, 0.6, 1.0)
        case .tan: return simd_float4(0.75, 0.6, 0.5, 1.0)
        case .dark: return simd_float4(0.6, 0.45, 0.35, 1.0)
        case .deep: return simd_float4(0.4, 0.3, 0.25, 1.0)
        }
    }
}

enum HairStyle: String, Codable, CaseIterable {
    case bald, buzzed, short, medium, long, curly, wavy, spiky
}

enum HairColor: String, Codable, CaseIterable {
    case black, brown, blonde, red, gray, white, blue, purple
    
    var color: simd_float4 {
        switch self {
        case .black: return simd_float4(0.1, 0.1, 0.1, 1.0)
        case .brown: return simd_float4(0.4, 0.3, 0.2, 1.0)
        case .blonde: return simd_float4(0.9, 0.8, 0.5, 1.0)
        case .red: return simd_float4(0.7, 0.2, 0.1, 1.0)
        case .gray: return simd_float4(0.6, 0.6, 0.6, 1.0)
        case .white: return simd_float4(0.95, 0.95, 0.95, 1.0)
        case .blue: return simd_float4(0.2, 0.4, 0.8, 1.0)
        case .purple: return simd_float4(0.6, 0.2, 0.8, 1.0)
        }
    }
}

enum FacialHair: String, Codable, CaseIterable {
    case none, stubble, goatee, fullBeard, mustache, vanDyke
}

enum EyeColor: String, Codable, CaseIterable {
    case brown, blue, green, hazel, gray, amber
    
    var color: simd_float4 {
        switch self {
        case .brown: return simd_float4(0.4, 0.2, 0.1, 1.0)
        case .blue: return simd_float4(0.3, 0.5, 0.8, 1.0)
        case .green: return simd_float4(0.2, 0.6, 0.3, 1.0)
        case .hazel: return simd_float4(0.5, 0.4, 0.2, 1.0)
        case .gray: return simd_float4(0.5, 0.5, 0.5, 1.0)
        case .amber: return simd_float4(0.8, 0.5, 0.2, 1.0)
        }
    }
}

enum BodyType: String, Codable, CaseIterable {
    case slim, average, athletic, muscular, heavy
}

enum Outfit: String, Codable, CaseIterable {
    case casual, business, formal, sporty, tech, luxury
    
    var color: simd_float4 {
        switch self {
        case .casual: return simd_float4(0.4, 0.5, 0.7, 1.0)
        case .business: return simd_float4(0.2, 0.2, 0.3, 1.0)
        case .formal: return simd_float4(0.1, 0.1, 0.1, 1.0)
        case .sporty: return simd_float4(0.8, 0.2, 0.2, 1.0)
        case .tech: return simd_float4(0.3, 0.3, 0.3, 1.0)
        case .luxury: return simd_float4(0.6, 0.5, 0.4, 1.0)
        }
    }
}

enum Accessory: String, Codable, CaseIterable {
    case glasses, sunglasses, watch, necklace, earrings, hat, tie
}

struct CustomizationCatalog {
    let skinTones = SkinTone.allCases
    let hairStyles = HairStyle.allCases
    let hairColors = HairColor.allCases
    let facialHairs = FacialHair.allCases
    let eyeColors = EyeColor.allCases
    let bodyTypes = BodyType.allCases
    let outfits = Outfit.allCases
    let accessories = Accessory.allCases
}

struct AvatarRenderUniforms {
    var modelMatrix: simd_float4x4
    var viewMatrix: simd_float4x4
    var projectionMatrix: simd_float4x4
    var skinToneColor: simd_float4
    var hairColor: simd_float4
    var eyeColor: simd_float4
    var lightPosition: simd_float3
}
