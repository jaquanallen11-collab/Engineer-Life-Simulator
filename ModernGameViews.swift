import SwiftUI

// MARK: - Modern Graduation View

struct ModernGraduationView: View {
    @ObservedObject var store: GameStore
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Spacer()
                
                Text("🎓")
                    .font(.system(size: 120))
                    .scaleEffect(showConfetti ? 1.2 : 0.8)
                    .rotationEffect(.degrees(showConfetti ? 360 : 0))
                
                Text("GRADUATION!")
                    .font(.system(size: 56, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                GlassmorphicCard {
                    VStack(spacing: 15) {
                        Text("Bachelor's in Engineering")
                            .font(.system(size: 24, weight: .bold))
                        
                        if let uni = store.player.university {
                            Text(uni.name)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        Text("You've completed your education and are ready to enter the professional world!")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                .frame(maxWidth: 600)
                
                NeonButton(
                    title: "Enter Career World",
                    icon: "briefcase.fill",
                    action: {
                        withAnimation {
                            store.proceedToCareer()
                        }
                    },
                    color: .purple
                )
                
                Spacer()
            }
            .padding()
            
            if showConfetti {
                ConfettiView()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.6)) {
                showConfetti = true
            }
        }
    }
}

// MARK: - Modern Company View

struct ModernCompanyView: View {
    @ObservedObject var store: GameStore
    @ObservedObject var npcEngine: NPCEngine
    @State private var showContent = false
    @State private var selectedCompany: Company?
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text("Choose Your Company")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Start your engineering career")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            .opacity(showContent ? 1.0 : 0)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(CompanyData.famousCompanies, id: \.name) { company in
                        CompanyCardModern(
                            company: company,
                            isSelected: selectedCompany?.name == company.name
                        ) {
                            withAnimation(.spring()) {
                                selectedCompany = company
                                store.selectCompany(company)
                                // Initialize team when joining company
                                store.initializeTeamForCompany(company, npcEngine: npcEngine)
                            }
                        }
                        .scaleEffect(showContent ? 1.0 : 0.8)
                        .opacity(showContent ? 1.0 : 0)
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

struct CompanyCardModern: View {
    let company: Company
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: getCompanyColors(company.name),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    Text(String(company.name.prefix(1)))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(company.name)
                        .font(.system(size: 22, weight: .bold))
                    
                    Text(company.plantName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 15) {
                        Label("Prestige \(company.prestigeLevel)/10", systemImage: "star.fill")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.yellow)
                        
                        Label("+\(Int(company.startingSalaryModifier * 100))%", systemImage: "dollarsign.circle.fill")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.purple)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: isSelected ? .purple.opacity(0.5) : .clear, radius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getCompanyColors(_ name: String) -> [Color] {
        switch name {
        case "Apple": return [.gray, .black]
        case "Google": return [.blue, .red, .yellow, .green]
        case "Microsoft": return [.blue, .cyan]
        case "Amazon": return [.orange, .yellow]
        case "Meta": return [.blue, .purple]
        case "Tesla": return [.red, .pink]
        case "SpaceX": return [.blue, .indigo]
        case "NVIDIA": return [.green, .lime]
        default: return [.purple, .blue]
        }
    }
}

// MARK: - Modern Job View

struct ModernJobView: View {
    @ObservedObject var store: GameStore
    @State private var showContent = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text("Choose Your Role")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                if let company = store.player.company {
                    Text("at \(company.name)")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 40)
            .opacity(showContent ? 1.0 : 0)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(GameConstants.jobs, id: \.title) { job in
                        JobCardModern(job: job, store: store)
                            .scaleEffect(showContent ? 1.0 : 0.8)
                            .opacity(showContent ? 1.0 : 0)
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

struct JobCardModern: View {
    let job: Job
    @ObservedObject var store: GameStore
    
    private var calculatedSalary: Int {
        Int(Double(job.salary) * (store.player.company?.startingSalaryModifier ?? 1.0))
    }
    
    var body: some View {
        Button {
            withAnimation {
                store.selectJob(job)
            }
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: getJobIcon(job.title))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(job.title)
                        .font(.system(size: 20, weight: .bold))
                    
                    Text(job.description)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("$\(calculatedSalary.formatted())/year")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.purple)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getJobIcon(_ title: String) -> String {
        switch title {
        case "Software Engineer": return "chevron.left.forwardslash.chevron.right"
        case "Hardware Engineer": return "cpu"
        case "Systems Engineer": return "gearshape.2"
        case "Data Engineer": return "chart.bar.fill"
        default: return "wrench.and.screwdriver"
        }
    }
}

// MARK: - Modern Game View

struct ModernGameView: View {
    @ObservedObject var store: GameStore
    @ObservedObject var metalRenderer: MetalRenderer
    @ObservedObject var mlPredictor: CareerPredictor
    @ObservedObject var npcEngine: NPCEngine
    @ObservedObject var assetEngine: AssetEngine
    @ObservedObject var visualHub: VisualIntegrationHub
    @State private var showPredictions = false
    @State private var showTeamDashboard = false
    @State private var showCustomization = false
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                // Modern Sidebar
                ModernSidebar(
                    store: store,
                    predictor: mlPredictor,
                    npcEngine: npcEngine,
                    assetEngine: assetEngine,
                    showPredictions: $showPredictions,
                    showTeamDashboard: $showTeamDashboard,
                    showCustomization: $showCustomization
                )
                
                // Main Content Area
                if showTeamDashboard {
                    TeamDashboardView(store: store, npcEngine: npcEngine)
                } else if showCustomization {
                    PlayerCustomizationView(customizationEngine: visualHub.playerCustomizationEngine)
                } else {
                    VStack(spacing: 0) {
                        if let scenario = store.currentScenario {
                            ModernScenarioView(scenario: scenario, store: store, predictor: mlPredictor)
                        } else {
                            EmptyScenarioView()
                        }
                        
                        // Activity Log
                        ModernActivityLog(logs: store.logs)
                    }
                }
                
                // Predictions Overlay
                if showPredictions {
                    ModernPredictionsPanel(predictor: mlPredictor, player: store.player, showPredictions: $showPredictions)
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showPredictions)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showTeamDashboard)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showCustomization)
        }
    }
}

struct ModernSidebar: View {
    @ObservedObject var store: GameStore
    @ObservedObject var predictor: CareerPredictor
    @ObservedObject var npcEngine: NPCEngine
    @ObservedObject var assetEngine: AssetEngine
    @Binding var showPredictions: Bool
    @Binding var showTeamDashboard: Bool
    @Binding var showCustomization: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Player Info
            VStack(spacing: 12) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text(String(store.player.name.prefix(1)))
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                Text(store.player.name)
                    .font(.system(size: 22, weight: .bold))
                
                Text(store.player.lifeChapter.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(.ultraThinMaterial))
            }
            
            Divider()
            
            // Stats Grid
            VStack(spacing: 10) {
                StatCard(icon: "calendar", title: "Age", value: "\(store.player.age)", color: .blue)
                StatCard(icon: "dollarsign.circle.fill", title: "Money", value: "$\(store.player.money.formatted())", color: .green)
                StatCard(icon: "chart.bar.fill", title: "Net Worth", value: "$\((store.player.money + assetEngine.calculateTotalNetWorth()).formatted())", color: .cyan)
                StatCard(icon: "chart.line.uptrend.xyaxis", title: "Performance", value: "\(store.player.performance)%", color: .purple)
                StatCard(icon: "star.fill", title: "Rank", value: store.player.rank, color: .yellow)
                
                if let company = store.player.company {
                    StatCard(icon: "building.2.fill", title: "Company", value: company.name, color: .orange)
                }
            }
            
            Divider()
            
            // Actions
            VStack(spacing: 12) {
                NeonButton(title: "Next Year", icon: "arrow.right.circle.fill", action: {
                    withAnimation {
                        store.nextYear()
                    }
                }, color: .purple)
                
                if store.player.isEmployed {
                    NeonButton(title: "Quit Job", icon: "rectangle.portrait.and.arrow.right", action: {
                        store.quitJob()
                    }, color: .red)
                } else {
                    NeonButton(title: "Find Job", icon: "magnifyingglass", action: {
                        store.generateJobOffers()
                    }, color: .blue)
                }
                
                HStack(spacing: 12) {
                    Button {
                        store.openShop()
                    } label: {
                        VStack {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 20))
                            Text("Shop")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        store.openPortfolio()
                    } label: {
                        VStack {
                            Image(systemName: "chart.pie.fill")
                                .font(.system(size: 20))
                            Text("Portfolio")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                NeonButton(title: "AI Predictions", icon: "brain", action: {
                    Task {
                        await predictor.predictCareerOutcome(player: store.player)
                        withAnimation {
                            showPredictions.toggle()
                        }
                    }
                }, color: .cyan)
                
                // Team Dashboard Button
                if !npcEngine.currentTeam.isEmpty {
                    NeonButton(
                        title: "Team Dashboard",
                        icon: "person.3.fill",
                        action: {
                            withAnimation {
                                showTeamDashboard.toggle()
                                showCustomization = false
                            }
                        },
                        color: .orange
                    )
                }
                
                // Player Customization Button
                NeonButton(
                    title: "Customize",
                    icon: "person.circle.fill",
                    action: {
                        withAnimation {
                            showCustomization.toggle()
                            showTeamDashboard = false
                        }
                    },
                    color: .pink
                )
            }
            
            Spacer()
            
            // Next Year button
            NeonButton(
                title: "Next Year",
                icon: "forward.fill",
                action: {
                    store.nextYear()
                    store.updateTeamDynamics(npcEngine: npcEngine)
                    
                    // Update all assets (appreciation/depreciation)
                    assetEngine.updateAllAssets()
                    
                    // Apply monthly asset costs and income
                    let netImpact = assetEngine.calculateNetMonthlyAssetImpact() * 12
                    store.player.money += netImpact
                    
                    if netImpact != 0 {
                        store.addLog("Asset income/expenses: \(netImpact >= 0 ? "+" : "")$\(netImpact.formatted())")
                    }
                    
                    // Apply team performance boost
                    let boost = store.getTeamPerformanceBoost(npcEngine: npcEngine)
                    store.player.performance = max(0, min(100, store.player.performance + boost))
                    
                    // Project completion bonuses
                    let bonus = store.calculateProjectBonus(npcEngine: npcEngine)
                    if bonus > 0 {
                        store.player.money += bonus
                        store.addLog("Project completion bonus: +$\(bonus.formatted())")
                    }
                },
                color: .green
            )
            
            Spacer()
            
            // Save
            Button {
                store.saveGame()
            } label: {
                HStack {
                    Image(systemName: "arrow.down.doc.fill")
                    Text("Save Game")
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .frame(width: 280)
        .background(.ultraThinMaterial)
    }
}

struct EmptyScenarioView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "hourglass")
                .font(.system(size: 60))
                .foregroundColor(.purple)
            
            Text("Year in Progress...")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
}

struct ModernScenarioView: View {
    let scenario: Scenario
    @ObservedObject var store: GameStore
    @ObservedObject var predictor: CareerPredictor
    @State private var hoveredChoice: String?
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            GlassmorphicCard {
                VStack(spacing: 25) {
                    Text(scenario.title)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                    
                    Text(scenario.description)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    VStack(spacing: 15) {
                        ForEach(Array(scenario.choices.keys.sorted()), id: \.self) { key in
                            if let choice = scenario.choices[key] {
                                ChoiceButton(
                                    choice: choice,
                                    isHovered: hoveredChoice == key
                                ) {
                                    withAnimation {
                                        store.handleChoice(key)
                                        store.nextYear()
                                    }
                                }
                                .onHover { isHovered in
                                    hoveredChoice = isHovered ? key : nil
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: 700)
            
            Spacer()
        }
        .padding()
    }
}

struct ChoiceButton: View {
    let choice: Choice
    let isHovered: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(choice.text)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 6) {
                        Image(systemName: choice.performanceChange >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundColor(choice.performanceChange >= 0 ? .green : .red)
                        
                        Text("\(choice.performanceChange >= 0 ? "+" : "")\(choice.performanceChange) Performance")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(choice.performanceChange >= 0 ? .green : .red)
                    }
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.purple)
                    .offset(x: isHovered ? 5 : 0)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: isHovered ? [.purple, .blue] : [.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 2
                    )
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .shadow(color: isHovered ? .purple.opacity(0.3) : .clear, radius: 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ModernActivityLog: View {
    let logs: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "scroll.fill")
                    .foregroundColor(.purple)
                Text("Activity Log")
                    .font(.system(size: 18, weight: .bold))
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(logs, id: \.self) { log in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 6, height: 6)
                            
                            Text(log)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .frame(height: 220)
        .background(.ultraThinMaterial)
    }
}

struct ModernPredictionsPanel: View {
    @ObservedObject var predictor: CareerPredictor
    let player: Player
    @Binding var showPredictions: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("AI Career Insights")
                        .font(.system(size: 24, weight: .bold))
                    Text("Powered by CoreML")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        showPredictions = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            if predictor.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        PredictionCard(
                            title: "Promotion Likelihood",
                            icon: "arrow.up.circle.fill",
                            description: predictor.getPredictionDescription(for: "promotion"),
                            color: .purple
                        )
                        
                        PredictionCard(
                            title: "Salary Growth",
                            icon: "dollarsign.circle.fill",
                            description: predictor.getPredictionDescription(for: "salary_increase"),
                            color: .green
                        )
                        
                        PredictionCard(
                            title: "Job Satisfaction",
                            icon: "heart.circle.fill",
                            description: predictor.getPredictionDescription(for: "job_satisfaction"),
                            color: .pink
                        )
                        
                        PredictionCard(
                            title: "Wealth Trajectory",
                            icon: "chart.line.uptrend.xyaxis.circle.fill",
                            description: predictor.getPredictionDescription(for: "wealth_growth"),
                            color: .cyan
                        )
                    }
                }
            }
        }
        .padding()
        .frame(width: 350)
        .background(.ultraThinMaterial)
    }
}

struct PredictionCard: View {
    let title: String
    let icon: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                
                Text(description)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Confetti Effect

struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    Circle()
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size)
                        .position(piece.position)
                }
            }
            .onAppear {
                generateConfetti(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    private func generateConfetti(in size: CGSize) {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
        
        for _ in 0..<100 {
            let piece = ConfettiPiece(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: -100...0)
                ),
                color: colors.randomElement()!,
                size: CGFloat.random(in: 8...20)
            )
            confettiPieces.append(piece)
            
            animateConfetti(piece: piece, in: size)
        }
    }
    
    private func animateConfetti(piece: ConfettiPiece, in size: CGSize) {
        withAnimation(.linear(duration: Double.random(in: 2...4))) {
            if let index = confettiPieces.firstIndex(where: { $0.id == piece.id }) {
                confettiPieces[index].position.y = size.height + 100
                confettiPieces[index].position.x += CGFloat.random(in: -100...100)
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    let size: CGFloat
}
