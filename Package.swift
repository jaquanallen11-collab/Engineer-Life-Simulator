// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EngineerLifeSimulator",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "EngineerLifeSimulator",
            targets: ["EngineerLifeSimulator"])
    ],
    targets: [
        .executableTarget(
            name: "EngineerLifeSimulator",
            dependencies: [],
            path: ".",
            sources: [
                "EngineerLifeSimulatorApp.swift",
                "GameModels.swift",
                "GameStoreNPCExtension.swift",
                "AssetEngine.swift",
                "VisualIntegrationHub.swift",
                "MetalAssetRenderer.swift",
                "PlayerCustomizationEngine.swift",
                "Enhanced3DAssetViews.swift",
                "PlayerCustomizationViews.swift",
                "ModernGameViews.swift",
                "ModernShopViews.swift",
                "ModernViews.swift",
                "MajorMinorViews.swift",
                "TeamViews.swift",
                "DisciplineViews.swift",
                "DisciplineExtensions.swift",
                "MetalRenderer.swift",
                "NPCEngine.swift",
                "MLPredictor.swift",
                "Metal4MLPipeline.swift",
                "EngineeringDisciplines.swift",
                "DynamicVisualSystem.swift",
                "DynamicVisualIntegration.swift",
                "DynamicVisualView.swift"
            ],
            resources: [
                .process("AdvancedShaders.metal"),
                .process("Shaders.metal")
            ]
        )
    ]
)
