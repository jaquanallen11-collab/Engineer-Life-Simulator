import SwiftUI

// MARK: - Team & Character Views

struct TeamDashboardView: View {
    @ObservedObject var store: GameStore
    @ObservedObject var npcEngine: NPCEngine
    @State private var selectedCharacter: NPCCharacter?
    @State private var showingNewProject = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Team List Sidebar
            VStack(alignment: .leading, spacing: 15) {
                Text("Your Team")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(npcEngine.currentTeam) { character in
                            TeamMemberCard(character: character) {
                                selectedCharacter = character
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                Button {
                    showingNewProject = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Project")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
            .frame(width: 300)
            .background(.ultraThinMaterial)
            
            // Main Content
            if let character = selectedCharacter {
                CharacterDetailView(
                    character: character,
                    npcEngine: npcEngine,
                    store: store
                )
            } else if !npcEngine.activeProjects.isEmpty {
                ProjectsListView(npcEngine: npcEngine, store: store)
            } else {
                EmptyTeamView()
            }
        }
        .sheet(isPresented: $showingNewProject) {
            NewProjectSheet(npcEngine: npcEngine, store: store)
        }
    }
}

struct TeamMemberCard: View {
    let character: NPCCharacter
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Avatar
                Text(character.avatar)
                    .font(.system(size: 32))
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(.ultraThinMaterial))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(character.fullName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(character.role.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        // Relationship indicator
                        HStack(spacing: 3) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 10))
                            Text("\(character.relationshipWithPlayer)")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(relationshipColor(character.relationshipWithPlayer))
                        
                        // Mood
                        Text(character.mood.emoji)
                            .font(.system(size: 12))
                        
                        // Energy
                        HStack(spacing: 2) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 10))
                            Text("\(character.energy)")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(energyColor(character.energy))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func relationshipColor(_ value: Int) -> Color {
        switch value {
        case 80...: return .green
        case 60..<80: return .blue
        case 40..<60: return .yellow
        case 20..<40: return .orange
        default: return .red
        }
    }
    
    private func energyColor(_ value: Int) -> Color {
        switch value {
        case 70...: return .green
        case 40..<70: return .yellow
        default: return .red
        }
    }
}

struct CharacterDetailView: View {
    let character: NPCCharacter
    @ObservedObject var npcEngine: NPCEngine
    @ObservedObject var store: GameStore
    @State private var selectedInteraction: InteractionType?
    @State private var lastResult: InteractionResult?
    @State private var showingResult = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 15) {
                    Text(character.avatar)
                        .font(.system(size: 80))
                    
                    Text(character.fullName)
                        .font(.system(size: 32, weight: .bold))
                    
                    HStack(spacing: 12) {
                        Text(character.seniority.rawValue)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(.purple.opacity(0.2)))
                        
                        Text(character.role.rawValue)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(.blue.opacity(0.2)))
                    }
                }
                
                // Status
                GlassmorphicCard {
                    VStack(spacing: 15) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Mood")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                                HStack {
                                    Text(character.mood.emoji)
                                    Text(character.mood.rawValue)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Relationship")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                                Text("\(character.relationshipWithPlayer)%")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(relationshipColor(character.relationshipWithPlayer))
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            StatusBar(
                                label: "Energy",
                                value: character.energy,
                                color: .green
                            )
                            
                            Spacer()
                            
                            StatusBar(
                                label: "Productivity",
                                value: character.productivity,
                                color: .blue
                            )
                        }
                    }
                }
                
                // Skills
                GlassmorphicCard {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Skills")
                            .font(.system(size: 20, weight: .bold))
                        
                        SkillBar(name: "Technical", value: character.skills.technical, color: .purple)
                        SkillBar(name: "Communication", value: character.skills.communication, color: .blue)
                        SkillBar(name: "Problem Solving", value: character.skills.problemSolving, color: .green)
                        SkillBar(name: "Teamwork", value: character.skills.teamwork, color: .orange)
                        SkillBar(name: "Leadership", value: character.skills.leadership, color: .red)
                        SkillBar(name: "Creativity", value: character.skills.creativity, color: .pink)
                    }
                }
                
                // Personality
                GlassmorphicCard {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Personality")
                            .font(.system(size: 20, weight: .bold))
                        
                        PersonalityTraitRow(name: "Openness", value: character.personality.openness)
                        PersonalityTraitRow(name: "Conscientiousness", value: character.personality.conscientiousness)
                        PersonalityTraitRow(name: "Extraversion", value: character.personality.extraversion)
                        PersonalityTraitRow(name: "Agreeableness", value: character.personality.agreeableness)
                        PersonalityTraitRow(name: "Emotional Stability", value: character.personality.emotionalStability)
                    }
                }
                
                // Interactions
                GlassmorphicCard {
                    VStack(spacing: 15) {
                        Text("Interact with \(character.firstName)")
                            .font(.system(size: 20, weight: .bold))
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            InteractionButton(title: "Ask for Help", icon: "questionmark.circle.fill", color: .blue) {
                                performInteraction(.askForHelp)
                            }
                            
                            InteractionButton(title: "Collaborate", icon: "person.2.fill", color: .purple) {
                                performInteraction(.collaborate)
                            }
                            
                            InteractionButton(title: "Praise", icon: "hand.thumbsup.fill", color: .green) {
                                performInteraction(.praise)
                            }
                            
                            InteractionButton(title: "Give Feedback", icon: "text.bubble.fill", color: .orange) {
                                performInteraction(.critique)
                            }
                            
                            InteractionButton(title: "Small Talk", icon: "bubble.left.and.bubble.right.fill", color: .cyan) {
                                performInteraction(.smallTalk)
                            }
                            
                            InteractionButton(title: "Request Project", icon: "folder.badge.plus", color: .pink) {
                                performInteraction(.requestProject)
                            }
                        }
                    }
                }
                
                // Result display
                if showingResult, let result = lastResult {
                    GlassmorphicCard {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: result.success ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(result.success ? .green : .red)
                                    .font(.system(size: 24))
                                
                                Text(result.success ? "Success" : "Failed")
                                    .font(.system(size: 18, weight: .bold))
                                
                                Spacer()
                            }
                            
                            Text(result.message)
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                            
                            if result.relationshipChange != 0 {
                                HStack {
                                    Text("Relationship:")
                                    Text("\(result.relationshipChange >= 0 ? "+" : "")\(result.relationshipChange)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(result.relationshipChange >= 0 ? .green : .red)
                                }
                            }
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding()
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showingResult)
    }
    
    private func performInteraction(_ type: InteractionType) {
        let result = npcEngine.interactWithCharacter(character, interaction: type)
        lastResult = result
        withAnimation {
            showingResult = true
        }
        
        // Auto-hide after 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
                showingResult = false
            }
        }
        
        // Add to game log
        store.addLog("\(character.firstName): \(result.message)")
    }
    
    private func relationshipColor(_ value: Int) -> Color {
        switch value {
        case 80...: return .green
        case 60..<80: return .blue
        case 40..<60: return .yellow
        case 20..<40: return .orange
        default: return .red
        }
    }
}

struct StatusBar: View {
    let label: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            
            HStack(spacing: 6) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.2))
                        .frame(width: 100, height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: CGFloat(value), height: 8)
                }
                
                Text("\(value)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(color)
            }
        }
    }
}

struct SkillBar: View {
    let name: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(name)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(value))
                }
            }
            .frame(height: 8)
        }
    }
}

struct PersonalityTraitRow: View {
    let name: String
    let value: Double
    
    var body: some View {
        HStack {
            Text(name)
                .font(.system(size: 14, weight: .medium))
            Spacer()
            ForEach(0..<5) { index in
                Circle()
                    .fill(Double(index) < value * 5 ? Color.purple : Color.gray.opacity(0.3))
                    .frame(width: 10, height: 10)
            }
        }
    }
}

struct InteractionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProjectsListView: View {
    @ObservedObject var npcEngine: NPCEngine
    @ObservedObject var store: GameStore
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Active Projects")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 30)
                
                ForEach(npcEngine.activeProjects) { project in
                    ProjectCard(project: project, npcEngine: npcEngine, store: store)
                }
            }
            .padding()
        }
    }
}

struct ProjectCard: View {
    let project: TeamProject
    @ObservedObject var npcEngine: NPCEngine
    @ObservedObject var store: GameStore
    @State private var playerContribution: Double = 10.0
    
    var progressPercentage: Double {
        Double(project.progress) / Double(project.complexity.targetProgress) * 100
    }
    
    var body: some View {
        GlassmorphicCard {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(project.name)
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(project.complexity.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(.purple.opacity(0.2)))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(project.daysRemaining) days")
                            .font(.system(size: 16, weight: .bold))
                        Text("remaining")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Progress
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Progress")
                            .font(.system(size: 14, weight: .medium))
                        Spacer()
                        Text("\(Int(progressPercentage))%")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.green.opacity(0.2))
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.green)
                                .frame(width: geometry.size.width * CGFloat(progressPercentage / 100))
                        }
                    }
                    .frame(height: 12)
                }
                
                // Stats
                HStack(spacing: 30) {
                    VStack {
                        Text("Quality")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text("\(project.quality)%")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    
                    VStack {
                        Text("Morale")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text("\(project.morale)%")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.purple)
                    }
                    
                    VStack {
                        Text("Team Size")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text("\(project.teamMembers.count + 1)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
                
                Divider()
                
                // Team Members
                VStack(alignment: .leading, spacing: 10) {
                    Text("Team")
                        .font(.system(size: 16, weight: .semibold))
                    
                    HStack(spacing: -8) {
                        ForEach(project.teamMembers.prefix(5)) { member in
                            Text(member.avatar)
                                .font(.system(size: 28))
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(.ultraThinMaterial))
                                .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                        }
                        
                        if project.teamMembers.count > 5 {
                            Text("+\(project.teamMembers.count - 5)")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                    }
                }
                
                Divider()
                
                // Work on Project
                VStack(spacing: 12) {
                    HStack {
                        Text("Your Contribution")
                            .font(.system(size: 14, weight: .medium))
                        Spacer()
                        Text("\(Int(playerContribution))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    Slider(value: $playerContribution, in: 1...30)
                        .tint(.green)
                    
                    Button {
                        npcEngine.updateProjectProgress(projectId: project.id, playerContribution: playerContribution)
                        store.addLog("Worked on \(project.name) - contributed \(Int(playerContribution)) points")
                    } label: {
                        HStack {
                            Image(systemName: "hammer.fill")
                            Text("Work on Project")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct EmptyTeamView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(.purple)
            
            Text("No Team Yet")
                .font(.system(size: 24, weight: .bold))
            
            Text("You'll be assigned a team when you join a company!")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NewProjectSheet: View {
    @ObservedObject var npcEngine: NPCEngine
    @ObservedObject var store: GameStore
    @Environment(\.dismiss) var dismiss
    
    @State private var projectName = ""
    @State private var selectedComplexity: ProjectComplexity = .moderate
    @State private var selectedMembers: Set<String> = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Start New Project")
                .font(.system(size: 28, weight: .bold))
            
            TextField("Project Name", text: $projectName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Picker("Complexity", selection: $selectedComplexity) {
                Text("Simple").tag(ProjectComplexity.simple)
                Text("Moderate").tag(ProjectComplexity.moderate)
                Text("Complex").tag(ProjectComplexity.complex)
                Text("Very Complex").tag(ProjectComplexity.veryComplex)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Text("Select Team Members")
                .font(.system(size: 18, weight: .semibold))
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(npcEngine.currentTeam) { member in
                        HStack {
                            Text(member.avatar)
                            Text(member.fullName)
                            Spacer()
                            if selectedMembers.contains(member.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedMembers.contains(member.id) ? Color.purple.opacity(0.2) : Color.gray.opacity(0.1))
                        )
                        .onTapGesture {
                            if selectedMembers.contains(member.id) {
                                selectedMembers.remove(member.id)
                            } else {
                                selectedMembers.insert(member.id)
                            }
                        }
                    }
                }
                .padding()
            }
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Button("Start Project") {
                    let members = npcEngine.currentTeam.filter { selectedMembers.contains($0.id) }
                    let project = npcEngine.startTeamProject(
                        name: projectName.isEmpty ? "New Project" : projectName,
                        complexity: selectedComplexity,
                        teamMembers: members
                    )
                    store.addLog("Started new project: \(project.name)")
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedMembers.isEmpty)
            }
        }
        .padding()
        .frame(width: 500, height: 600)
    }
}
