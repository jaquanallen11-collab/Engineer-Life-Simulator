import SwiftUI

// MARK: - Example Integration with Dynamic Visual System

/*
 This file demonstrates how to integrate the DynamicVisualSystem with your
 Engineer Life Simulator game. The visual system reacts to game state and
 provides immersive visual feedback.
 
 INTEGRATION STEPS:
 
 1. Add DynamicVisualSystem to your main app or game view:
    @StateObject private var visualSystem: DynamicVisualSystem
 
 2. Initialize it with the Metal device:
    let device = MTLCreateSystemDefaultDevice()!
    let library = device.makeDefaultLibrary()!
    visualSystem = DynamicVisualSystem(device: device, library: library)
 
 3. Update it with game state in your update loop or game state changes
 
 4. Add the visual view to your UI hierarchy
*/

// MARK: - Example Game Integration

struct EnhancedGameView: View {
    @ObservedObject var store: GameStore
    @ObservedObject var metalRenderer: MetalRenderer
    @StateObject private var visualSystem: DynamicVisualSystem
    
    init(store: GameStore, metalRenderer: MetalRenderer) {
        self.store = store
        self.metalRenderer = metalRenderer
        
        // Initialize visual system with Metal device
        let device = metalRenderer.device!
        let library = device.makeDefaultLibrary()!
        _visualSystem = StateObject(wrappedValue: DynamicVisualSystem(device: device, library: library))
    }
    
    var body: some View {
        ZStack {
            // Dynamic visual background
            DynamicVisualView(visualSystem: visualSystem, renderer: metalRenderer)
                .ignoresSafeArea()
            
            // Game UI on top
            VStack {
                // Your existing game UI
                gameContent
                
                // Optional: Visual control panel
                if store.debugMode {
                    VisualControlPanel(visualSystem: visualSystem)
                        .frame(maxWidth: 300)
                        .padding()
                }
            }
        }
        .onChange(of: store.currentWeek) { _ in
            updateVisualSystem()
        }
        .onChange(of: store.stress) { _ in
            updateVisualSystem()
        }
    }
    
    private var gameContent: some View {
        // Your existing game content here
        Text("Game Content")
    }
    
    private func updateVisualSystem() {
        // Map game state to visual parameters
        let stressLevel = Float(store.stress) / 100.0
        let energyLevel = Float(store.energy) / 100.0
        let successRate = calculateSuccessRate()
        let careerProgress = Float(store.currentWeek) / 520.0 // Normalize to 0-1
        
        // Update visual system
        visualSystem.update(
            deltaTime: 1.0 / 60.0,
            stressLevel: stressLevel,
            successRate: successRate,
            careerProgress: careerProgress
        )
        
        // Set visual mode based on game state
        if store.stress > 75 {
            visualSystem.setVisualMode(mode: .stressed)
        } else if energyLevel > 0.7 {
            visualSystem.setVisualMode(mode: .energetic)
        } else if energyLevel < 0.3 {
            visualSystem.setVisualMode(mode: .calm)
        } else {
            visualSystem.setVisualMode(mode: .focused)
        }
    }
    
    private func calculateSuccessRate() -> Float {
        // Calculate based on grades, skills, etc.
        let avgGrade = store.grades.isEmpty ? 0.5 : store.grades.values.map { $0 / 4.0 }.reduce(0, +) / Float(store.grades.count)
        return avgGrade
    }
}

// MARK: - Event-Driven Visual Effects

extension DynamicVisualSystem {
    
    /// Call when player completes a major achievement
    func triggerSuccessEffect() {
        setVisualMode(mode: .energetic)
        visualIntensity = 2.0
        moodColor = SIMD3(0.2, 1.0, 0.4) // Green success color
        
        // Create particle burst at center
        spawnParticleBurst(
            position: SIMD2(0, 0),
            count: 100,
            color: SIMD3(0.2, 1.0, 0.4)
        )
    }
    
    /// Call when player fails or makes a mistake
    func triggerFailureEffect() {
        triggerWaveAt(position: SIMD2(0, 0), strength: 2.0)
        moodColor = SIMD3(1.0, 0.3, 0.2) // Red failure color
    }
    
    /// Call during exam or high-stress moments
    func triggerStressEffect() {
        setVisualMode(mode: .stressed)
        visualIntensity = 2.5
    }
    
    /// Call during rest or relaxation activities
    func triggerRelaxationEffect() {
        setVisualMode(mode: .calm)
        moodColor = SIMD3(0.3, 0.5, 0.9) // Calm blue
    }
    
    /// Call when working on a project (focused state)
    func triggerFocusEffect() {
        setVisualMode(mode: .focused)
        moodColor = SIMD3(0.6, 0.4, 0.9) // Purple focus color
    }
}

// MARK: - Activity-Based Visual Mappings

struct VisualActivityMapper {
    static func configureVisualsForActivity(_ activity: String, visualSystem: DynamicVisualSystem) {
        switch activity {
        case "Study":
            visualSystem.triggerFocusEffect()
            
        case "Exercise", "Socialize":
            visualSystem.setVisualMode(mode: .energetic)
            visualSystem.moodColor = SIMD3(0.9, 0.6, 0.3) // Orange energy
            
        case "Sleep", "Relax":
            visualSystem.triggerRelaxationEffect()
            
        case "Work", "Intern":
            visualSystem.setVisualMode(mode: .focused)
            visualSystem.moodColor = SIMD3(0.5, 0.7, 0.4) // Work green
            
        case "Exam", "Interview":
            visualSystem.triggerStressEffect()
            
        default:
            visualSystem.setVisualMode(mode: .calm)
        }
    }
}

// MARK: - Example Usage in Game Events

/*
// In your game logic when activities happen:

// When player starts studying
visualSystem.triggerFocusEffect()
visualSystem.triggerWaveAt(position: SIMD2(0, 0.5), strength: 1.0)

// When player completes a difficult exam successfully
if examScore > 90 {
    visualSystem.triggerSuccessEffect()
} else if examScore < 60 {
    visualSystem.triggerFailureEffect()
}

// When player is doing an activity
VisualActivityMapper.configureVisualsForActivity(currentActivity, visualSystem: visualSystem)

// When interacting with UI (button clicks, etc.)
Button("Submit") {
    // Your action
    visualSystem.triggerWaveAt(
        position: SIMD2(0.5, 0.5), // button position
        strength: 0.8
    )
}

// Continuous updates in your game loop
Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
    visualSystem.update(
        deltaTime: 1.0/60.0,
        stressLevel: Float(store.stress) / 100.0,
        successRate: calculateSuccessRate(),
        careerProgress: Float(store.currentWeek) / 520.0
    )
}
*/

// MARK: - Discipline-Specific Visual Themes

extension DynamicVisualSystem {
    
    func applyDisciplineTheme(_ discipline: EngineeringDiscipline) {
        switch discipline {
        case .software:
            moodColor = SIMD3(0.2, 0.7, 1.0) // Blue tech
            
        case .electrical:
            moodColor = SIMD3(1.0, 0.8, 0.2) // Electric yellow
            
        case .mechanical:
            moodColor = SIMD3(0.7, 0.7, 0.7) // Metal gray
            
        case .civil:
            moodColor = SIMD3(0.5, 0.4, 0.3) // Earth brown
            
        case .chemical:
            moodColor = SIMD3(0.6, 0.9, 0.4) // Chemical green
            
        case .biomedical:
            moodColor = SIMD3(0.9, 0.3, 0.5) // Medical red
            
        case .aerospace:
            moodColor = SIMD3(0.3, 0.3, 0.8) // Sky blue
            
        case .environmental:
            moodColor = SIMD3(0.3, 0.8, 0.3) // Nature green
            
        case .industrial:
            moodColor = SIMD3(0.8, 0.5, 0.2) // Industrial orange
            
        case .materials:
            moodColor = SIMD3(0.6, 0.5, 0.7) // Material purple
            
        default:
            moodColor = SIMD3(0.5, 0.5, 0.5) // Default gray
        }
    }
}

// MARK: - Real-Time Performance Monitoring

class VisualPerformanceMonitor: ObservableObject {
    @Published var fps: Double = 60.0
    @Published var updateTime: Double = 0.0
    @Published var particleCount: Int = 0
    
    private var lastUpdate = Date()
    private var frameCount = 0
    
    func recordFrame(updateDuration: TimeInterval, particleCount: Int) {
        frameCount += 1
        self.updateTime = updateDuration * 1000.0 // ms
        self.particleCount = particleCount
        
        let now = Date()
        if now.timeIntervalSince(lastUpdate) >= 1.0 {
            fps = Double(frameCount)
            frameCount = 0
            lastUpdate = now
        }
    }
}

struct PerformanceOverlay: View {
    @ObservedObject var monitor: VisualPerformanceMonitor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("FPS: \(Int(monitor.fps))")
            Text("Update: \(monitor.updateTime, specifier: "%.2f")ms")
            Text("Particles: \(monitor.particleCount)")
        }
        .font(.system(.caption, design: .monospaced))
        .foregroundColor(.green)
        .padding(8)
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
    }
}
