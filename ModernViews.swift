import SwiftUI

// MARK: - Modern UI Components

struct GlassmorphicCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.2), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

struct NeonButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var color: Color = .purple
    var isDisabled: Bool = false
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: isDisabled ? [.gray.opacity(0.5)] : [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: isDisabled ? .clear : color.opacity(0.5), radius: isPressed ? 5 : 15, x: 0, y: isPressed ? 2 : 8)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

struct AnimatedNumberText: View {
    let value: Int
    @State private var displayValue: Int = 0
    
    var body: some View {
        Text("$\(displayValue.formatted())")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [.green, .mint],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .onAppear {
                animateNumber()
            }
            .onChange(of: value) { _ in
                animateNumber()
            }
    }
    
    private func animateNumber() {
        let steps = 20
        let increment = (value - displayValue) / steps
        
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.02) {
                displayValue += increment
                if i == steps {
                    displayValue = value
                }
            }
        }
    }
}

// MARK: - Modern Start View

struct ModernStartView: View {
    @ObservedObject var store: GameStore
    @State private var playerName = ""
    @State private var showAnimation = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                Text("⚡️")
                    .font(.system(size: 100))
                    .scaleEffect(showAnimation ? 1.0 : 0.5)
                    .opacity(showAnimation ? 1.0 : 0)
                
                Text("Engineer Life")
                    .font(.system(size: 60, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(showAnimation ? 1.0 : 0.8)
                    .opacity(showAnimation ? 1.0 : 0)
                
                Text("SIMULATOR")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .tracking(8)
                    .foregroundColor(.secondary)
                    .opacity(showAnimation ? 1.0 : 0)
            }
            .padding(.bottom, 40)
            
            VStack(spacing: 20) {
                GlassmorphicCard {
                    TextField("Enter your name", text: $playerName)
                        .textFieldStyle(.plain)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .padding()
                }
                .frame(maxWidth: 400)
                .scaleEffect(showAnimation ? 1.0 : 0.8)
                .opacity(showAnimation ? 1.0 : 0)
                
                NeonButton(
                    title: "Start Your Journey",
                    icon: "arrow.right.circle.fill",
                    action: {
                        if !playerName.isEmpty {
                            withAnimation(.spring()) {
                                store.startGame(name: playerName)
                            }
                        }
                    },
                    color: .purple,
                    isDisabled: playerName.isEmpty
                )
                .scaleEffect(showAnimation ? 1.0 : 0.8)
                .opacity(showAnimation ? 1.0 : 0)
            }
            
            Spacer()
            
            Text("A next-gen career simulation powered by Metal 4 & CoreML")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .opacity(showAnimation ? 0.7 : 0)
        }
        .padding()
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                showAnimation = true
            }
        }
    }
}

// MARK: - Modern Ivy Exam View

struct ModernIvyExamView: View {
    @ObservedObject var store: GameStore
    @State private var showContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            GlassmorphicCard {
                VStack(spacing: 25) {
                    Text("🎓")
                        .font(.system(size: 80))
                    
                    Text("Ivy League Challenge")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                    
                    Text("Take the prestigious entrance exam to unlock elite universities")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    VStack(spacing: 15) {
                        NeonButton(
                            title: "Take the Exam",
                            icon: "pencil.and.outline",
                            action: {
                                withAnimation {
                                    if Bool.random() {
                                        store.passIvyExam()
                                    } else {
                                        store.skipIvyExam()
                                    }
                                }
                            },
                            color: .purple
                        )
                        
                        NeonButton(
                            title: "Skip to California Unis",
                            icon: "arrow.right",
                            action: {
                                withAnimation {
                                    store.skipIvyExam()
                                }
                            },
                            color: .blue
                        )
                    }
                }
                .padding()
            }
            .frame(maxWidth: 600)
            .scaleEffect(showContent ? 1.0 : 0.8)
            .opacity(showContent ? 1.0 : 0)
            
            Spacer()
        }
        .padding()
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
}

// MARK: - Modern University View

struct ModernUniversityView: View {
    @ObservedObject var store: GameStore
    @State private var showContent = false
    @State private var selectedUni: University?
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 10) {
                Text("Choose Your University")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                AnimatedNumberText(value: store.player.money)
            }
            .padding(.top, 40)
            .opacity(showContent ? 1.0 : 0)
            .offset(y: showContent ? 0 : -20)
            
            ScrollView {
                VStack(spacing: 20) {
                    if store.player.ivyExamPassed {
                        universitySection(title: "🏆 Ivy League", universities: UniversityData.ivyLeague)
                    }
                    
                    universitySection(title: "🌴 California", universities: UniversityData.california)
                }
                .padding()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
    
    @ViewBuilder
    private func universitySection(title: String, universities: [University]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            ForEach(universities, id: \.name) { uni in
                UniversityCardModern(
                    university: uni,
                    isSelected: selectedUni?.name == uni.name,
                    canAfford: store.player.money >= uni.tuition
                ) {
                    withAnimation(.spring()) {
                        selectedUni = uni
                        store.selectUniversity(uni)
                    }
                }
            }
        }
    }
}

struct UniversityCardModern: View {
    let university: University
    let isSelected: Bool
    let canAfford: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: university.isIvy ? [.purple, .blue] : [.orange, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Text(String(university.name.prefix(1)))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(university.name)
                            .font(.system(size: 20, weight: .bold))
                        
                        if university.isIvy {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 14))
                        }
                    }
                    
                    Text("$\(university.tuition.formatted())/year")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(canAfford ? .green : .red)
                    
                    HStack(spacing: 12) {
                        Label("\(university.prestigeBoost)", systemImage: "star.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Action
                Image(systemName: canAfford ? "arrow.right.circle.fill" : "lock.fill")
                    .font(.system(size: 24))
                    .foregroundColor(canAfford ? .purple : .gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: isSelected ? .purple.opacity(0.5) : .clear, radius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Color.purple : Color.clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!canAfford)
    }
}
