import SwiftUI

// MARK: - Major/Minor Selection View

struct MajorMinorSelectionView: View {
    @ObservedObject var store: GameStore
    @State private var selectedMajor: EngineeringDiscipline?
    @State private var selectedMinor: EngineeringDiscipline?
    @State private var showContent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 15) {
                    Text("Choose Your Engineering Path")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .blue, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Select your major and minor specializations")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .opacity(showContent ? 1.0 : 0)
                .padding(.top, 40)
                
                // Major Selection
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("MAJOR")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.purple)
                        
                        if let major = selectedMajor {
                            Text(major.emoji)
                                .font(.system(size: 24))
                        }
                    }
                    
                    Text("Your primary field of study - determines your career path")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(EngineeringDiscipline.allCases, id: \.self) { discipline in
                            DisciplineCard(
                                discipline: discipline,
                                isSelected: selectedMajor == discipline,
                                isDisabled: selectedMinor == discipline
                            ) {
                                withAnimation(.spring()) {
                                    selectedMajor = discipline
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
                .scaleEffect(showContent ? 1.0 : 0.9)
                .opacity(showContent ? 1.0 : 0)
                
                // Minor Selection
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("MINOR")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.cyan)
                        
                        if let minor = selectedMinor {
                            Text(minor.emoji)
                                .font(.system(size: 24))
                        }
                    }
                    
                    Text("Secondary specialization - provides additional career options")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(EngineeringDiscipline.allCases, id: \.self) { discipline in
                            DisciplineCard(
                                discipline: discipline,
                                isSelected: selectedMinor == discipline,
                                isDisabled: selectedMajor == discipline
                            ) {
                                withAnimation(.spring()) {
                                    selectedMinor = discipline
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
                .scaleEffect(showContent ? 1.0 : 0.9)
                .opacity(showContent ? 1.0 : 0)
                
                // Confirm Button
                if let major = selectedMajor, let minor = selectedMinor {
                    VStack(spacing: 15) {
                        GlassmorphicCard {
                            VStack(spacing: 12) {
                                Text("Your Path:")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 20) {
                                    VStack {
                                        Text(major.emoji)
                                            .font(.system(size: 40))
                                        Text(major.rawValue)
                                            .font(.system(size: 14, weight: .bold))
                                            .multilineTextAlignment(.center)
                                        Text("Major")
                                            .font(.system(size: 12))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 20))
                                        .foregroundColor(.secondary)
                                    
                                    VStack {
                                        Text(minor.emoji)
                                            .font(.system(size: 32))
                                        Text(minor.rawValue)
                                            .font(.system(size: 14, weight: .bold))
                                            .multilineTextAlignment(.center)
                                        Text("Minor")
                                            .font(.system(size: 12))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Avg Starting Salary:")
                                    Text("$\(major.averageStartingSalary.formatted())")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                        }
                        
                        NeonButton(
                            title: "Confirm Selection",
                            icon: "checkmark.circle.fill",
                            action: {
                                store.selectMajorMinor(major: major, minor: minor)
                            },
                            color: .green
                        )
                        .padding(.horizontal, 40)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
}

struct DisciplineCard: View {
    let discipline: EngineeringDiscipline
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: isDisabled ? {} : action) {
            VStack(spacing: 12) {
                Text(discipline.emoji)
                    .font(.system(size: 48))
                
                Text(discipline.rawValue)
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("$\(discipline.averageStartingSalary.formatted())")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.green)
                
                Divider()
                
                Text(discipline.description)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Skills
                VStack(alignment: .leading, spacing: 4) {
                    Text("Key Skills:")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    ForEach(discipline.topSkills.prefix(2), id: \.self) { skill in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 4, height: 4)
                            Text(skill)
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(height: 280)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: isSelected ? .purple.opacity(0.5) : .clear, radius: 15)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 3)
            )
            .opacity(isDisabled ? 0.4 : 1.0)
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }
}

// MARK: - Discipline-Aware University View

struct ModernUniversityDisciplineView: View {
    @ObservedObject var store: GameStore
    @State private var showContent = false
    
    var availableUniversities: [University] {
        if store.player.ivyExamPassed {
            return UniversityData.ivyLeague + UniversityData.california
        } else {
            return UniversityData.california
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                HStack {
                    if let major = store.player.major {
                        Text(major.emoji)
                            .font(.system(size: 32))
                    }
                    
                    Text("Choose Your University")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                    
                    if let minor = store.player.minor {
                        Text(minor.emoji)
                            .font(.system(size: 24))
                    }
                }
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                
                if let major = store.player.major {
                    Text("Major: \(major.rawValue)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.purple)
                }
                
                if let minor = store.player.minor {
                    Text("Minor: \(minor.rawValue)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.cyan)
                }
                
                Text("Money: $\(store.player.money.formatted())")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.green)
            }
            .padding(.top, 40)
            .opacity(showContent ? 1.0 : 0)
            
            ScrollView {
                VStack(spacing: 15) {
                    if store.player.ivyExamPassed {
                        Text("Ivy League & Elite Universities")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gold)
                        
                        ForEach(UniversityData.ivyLeague, id: \.name) { uni in
                            UniversityCardModern(university: uni, store: store)
                        }
                    }
                    
                    Text("California Universities")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(.top)
                    
                    ForEach(UniversityData.california, id: \.name) { uni in
                        UniversityCardModern(university: uni, store: store)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
}

extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
}
