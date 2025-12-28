import SwiftUI
import MetalKit

// MARK: - Player Customization View with Metal 4 Rendering

struct PlayerCustomizationView: View {
    @ObservedObject var customizationEngine: PlayerCustomizationEngine
    @State private var showContent = false
    @State private var avatarRotation: Float = 0
    @State private var selectedCategory = 0
    
    private let categories = ["Appearance", "Hair", "Body", "Outfit", "Accessories"]
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            HStack(spacing: 0) {
                // Left: Avatar Preview
                VStack {
                    Text("Your Engineer")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.top, 40)
                    
                    // 3D Avatar Render
                    Metal3DAvatarView(
                        customizationEngine: customizationEngine,
                        rotation: $avatarRotation
                    )
                    .frame(width: 400, height: 500)
                    .padding()
                    
                    HStack(spacing: 20) {
                        Button {
                            withAnimation {
                                avatarRotation -= .pi / 4
                            }
                        } label: {
                            Image(systemName: "rotate.left")
                                .font(.system(size: 24))
                                .foregroundColor(.cyan)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button {
                            withAnimation {
                                avatarRotation += .pi / 4
                            }
                        } label: {
                            Image(systemName: "rotate.right")
                                .font(.system(size: 24))
                                .foregroundColor(.cyan)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer()
                    
                    Text("Customization complete!")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity)
                
                // Right: Customization Options
                VStack(spacing: 0) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(categories[index]).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            switch selectedCategory {
                            case 0:
                                AppearanceCustomization(customizationEngine: customizationEngine)
                            case 1:
                                HairCustomization(customizationEngine: customizationEngine)
                            case 2:
                                BodyCustomization(customizationEngine: customizationEngine)
                            case 3:
                                OutfitCustomization(customizationEngine: customizationEngine)
                            case 4:
                                AccessoriesCustomization(customizationEngine: customizationEngine)
                            default:
                                EmptyView()
                            }
                        }
                        .padding()
                    }
                }
                .frame(width: 400)
                .background(.ultraThinMaterial)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
}

// MARK: - Appearance Customization

struct AppearanceCustomization: View {
    @ObservedObject var customizationEngine: PlayerCustomizationEngine
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Skin Tone")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 15) {
                ForEach(customizationEngine.availableCustomizations.skinTones, id: \.self) { skinTone in
                    SkinToneButton(
                        skinTone: skinTone,
                        isSelected: customizationEngine.playerAvatar.skinTone == skinTone
                    ) {
                        customizationEngine.updateSkinTone(skinTone)
                    }
                }
            }
            
            Divider()
            
            Text("Eye Color")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 15) {
                ForEach(customizationEngine.availableCustomizations.eyeColors, id: \.self) { eyeColor in
                    EyeColorButton(
                        eyeColor: eyeColor,
                        isSelected: customizationEngine.playerAvatar.eyeColor == eyeColor
                    ) {
                        customizationEngine.updateEyeColor(eyeColor)
                    }
                }
            }
        }
    }
}

// MARK: - Hair Customization

struct HairCustomization: View {
    @ObservedObject var customizationEngine: PlayerCustomizationEngine
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hair Style")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 15) {
                ForEach(customizationEngine.availableCustomizations.hairStyles, id: \.self) { style in
                    HairStyleButton(
                        hairStyle: style,
                        isSelected: customizationEngine.playerAvatar.hairStyle == style
                    ) {
                        customizationEngine.updateHairStyle(style)
                    }
                }
            }
            
            Divider()
            
            Text("Hair Color")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 15) {
                ForEach(customizationEngine.availableCustomizations.hairColors, id: \.self) { color in
                    HairColorButton(
                        hairColor: color,
                        isSelected: customizationEngine.playerAvatar.hairColor == color
                    ) {
                        customizationEngine.updateHairColor(color)
                    }
                }
            }
            
            Divider()
            
            Text("Facial Hair")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 15) {
                ForEach(customizationEngine.availableCustomizations.facialHairs, id: \.self) { facial in
                    FacialHairButton(
                        facialHair: facial,
                        isSelected: customizationEngine.playerAvatar.facialHair == facial
                    ) {
                        customizationEngine.updateFacialHair(facial)
                    }
                }
            }
        }
    }
}

// MARK: - Body Customization

struct BodyCustomization: View {
    @ObservedObject var customizationEngine: PlayerCustomizationEngine
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Body Type")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 15) {
                ForEach(customizationEngine.availableCustomizations.bodyTypes, id: \.self) { bodyType in
                    BodyTypeButton(
                        bodyType: bodyType,
                        isSelected: customizationEngine.playerAvatar.bodyType == bodyType
                    ) {
                        customizationEngine.updateBodyType(bodyType)
                    }
                }
            }
        }
    }
}

// MARK: - Outfit Customization

struct OutfitCustomization: View {
    @ObservedObject var customizationEngine: PlayerCustomizationEngine
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Outfit Style")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 15) {
                ForEach(customizationEngine.availableCustomizations.outfits, id: \.self) { outfit in
                    OutfitButton(
                        outfit: outfit,
                        isSelected: customizationEngine.playerAvatar.outfit == outfit
                    ) {
                        customizationEngine.updateOutfit(outfit)
                    }
                }
            }
        }
    }
}

// MARK: - Accessories Customization

struct AccessoriesCustomization: View {
    @ObservedObject var customizationEngine: PlayerCustomizationEngine
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Accessories")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 15) {
                ForEach(customizationEngine.availableCustomizations.accessories, id: \.self) { accessory in
                    AccessoryButton(
                        accessory: accessory,
                        isSelected: customizationEngine.playerAvatar.accessories.contains(accessory)
                    ) {
                        var accessories = customizationEngine.playerAvatar.accessories
                        if let index = accessories.firstIndex(of: accessory) {
                            accessories.remove(at: index)
                        } else {
                            accessories.append(accessory)
                        }
                        customizationEngine.updateAccessories(accessories)
                    }
                }
            }
        }
    }
}

// MARK: - Customization Buttons

struct SkinToneButton: View {
    let skinTone: SkinTone
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color(simdColor: skinTone.color))
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? Color.cyan : Color.clear, lineWidth: 3)
                )
                .shadow(color: isSelected ? .cyan : .clear, radius: 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EyeColorButton: View {
    let eyeColor: EyeColor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color(simdColor: eyeColor.color))
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? Color.cyan : Color.clear, lineWidth: 3)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HairStyleButton: View {
    let hairStyle: HairStyle
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(getHairIcon(hairStyle))
                    .font(.system(size: 40))
                Text(hairStyle.rawValue.capitalized)
                    .font(.system(size: 12, weight: .medium))
            }
            .frame(width: 90, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.cyan.opacity(0.2) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? Color.cyan : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func getHairIcon(_ style: HairStyle) -> String {
        switch style {
        case .bald: return "👨‍🦲"
        case .buzzed: return "🧑"
        case .short: return "👦"
        case .medium: return "🧑"
        case .long: return "🧑‍🦰"
        case .curly: return "👨‍🦱"
        case .wavy: return "🧑‍🦰"
        case .spiky: return "👨"
        }
    }
}

struct HairColorButton: View {
    let hairColor: HairColor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(simdColor: hairColor.color))
                    .frame(width: 50, height: 40)
                Text(hairColor.rawValue.capitalized)
                    .font(.system(size: 10, weight: .medium))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isSelected ? Color.cyan : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FacialHairButton: View {
    let facialHair: FacialHair
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(facialHair.rawValue.capitalized)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 90, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.cyan.opacity(0.2) : Color.gray.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isSelected ? Color.cyan : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BodyTypeButton: View {
    let bodyType: BodyType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(bodyType.rawValue.capitalized)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 90, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.cyan.opacity(0.2) : Color.gray.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isSelected ? Color.cyan : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OutfitButton: View {
    let outfit: Outfit
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(getOutfitIcon(outfit))
                    .font(.system(size: 40))
                Text(outfit.rawValue.capitalized)
                    .font(.system(size: 12, weight: .medium))
            }
            .frame(width: 140, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.cyan.opacity(0.2) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? Color.cyan : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func getOutfitIcon(_ outfit: Outfit) -> String {
        switch outfit {
        case .casual: return "👕"
        case .business: return "👔"
        case .formal: return "🤵"
        case .sporty: return "🏃"
        case .tech: return "🧑‍💻"
        case .luxury: return "🕴️"
        }
    }
}

struct AccessoryButton: View {
    let accessory: Accessory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(getAccessoryIcon(accessory))
                    .font(.system(size: 32))
                Text(accessory.rawValue.capitalized)
                    .font(.system(size: 10, weight: .medium))
            }
            .frame(width: 90, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func getAccessoryIcon(_ accessory: Accessory) -> String {
        switch accessory {
        case .glasses: return "👓"
        case .sunglasses: return "🕶️"
        case .watch: return "⌚"
        case .necklace: return "📿"
        case .earrings: return "💎"
        case .hat: return "🎩"
        case .tie: return "👔"
        }
    }
}

// MARK: - Metal 3D Avatar View

struct Metal3DAvatarView: UIViewRepresentable {
    @ObservedObject var customizationEngine: PlayerCustomizationEngine
    @Binding var rotation: Float
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.delegate = context.coordinator
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.rotation = rotation
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(customizationEngine: customizationEngine)
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        var customizationEngine: PlayerCustomizationEngine
        var rotation: Float = 0
        
        init(customizationEngine: PlayerCustomizationEngine) {
            self.customizationEngine = customizationEngine
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
        
        func draw(in view: MTKView) {
            // Render avatar using Metal
            // This would use the customizationEngine.renderAvatarPreview method
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(simdColor: simd_float4) {
        self.init(
            red: Double(simdColor.x),
            green: Double(simdColor.y),
            blue: Double(simdColor.z),
            opacity: Double(simdColor.w)
        )
    }
}
