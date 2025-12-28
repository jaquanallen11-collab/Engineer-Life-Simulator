import SwiftUI

// MARK: - Discipline-Aware Company View

struct ModernDisciplineCompanyView: View {
    @ObservedObject var store: GameStore
    @ObservedObject var npcEngine: NPCEngine
    @State private var showContent = false
    @State private var selectedCompany: Company?
    
    var companies: [Company] {
        store.getDisciplineCompanies()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with discipline info
            VStack(spacing: 10) {
                HStack {
                    if let major = store.player.major {
                        Text(major.emoji)
                            .font(.system(size: 32))
                    }
                    
                    Text("Choose Your Company")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                }
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                
                if let major = store.player.major {
                    Text("\(major.rawValue) Positions")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                if let minor = store.player.minor {
                    Text("Minor: \(minor.rawValue)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.cyan)
                }
            }
            .padding(.top, 40)
            .opacity(showContent ? 1.0 : 0)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(companies, id: \.name) { company in
                        CompanyCardModern(
                            company: company,
                            isSelected: selectedCompany?.name == company.name
                        ) {
                            withAnimation(.spring()) {
                                selectedCompany = company
                                store.selectCompany(company)
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

// MARK: - Discipline-Aware Job View

struct ModernDisciplineJobView: View {
    @ObservedObject var store: GameStore
    @State private var showContent = false
    
    var jobs: [Job] {
        store.getDisciplineJobs()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 10) {
                HStack {
                    if let major = store.player.major {
                        Text(major.emoji)
                            .font(.system(size: 28))
                    }
                    
                    Text("Choose Your Role")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                }
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                
                Text("at \(store.player.company?.name ?? "Company")")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.secondary)
                
                if let major = store.player.major {
                    Text("\(major.rawValue) Positions")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.purple)
                }
            }
            .padding(.top, 30)
            .opacity(showContent ? 1.0 : 0)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(jobs, id: \.title) { job in
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
    @State private var isHovered = false
    
    var estimatedSalary: Int {
        let baseSalary = job.salary
        let companyModifier = store.player.company?.startingSalaryModifier ?? 1.0
        let disciplineBonus = store.getDisciplineSalaryBonus()
        let performanceBonus = 1.0 + (Double(store.player.performance) / 200.0)
        
        return Int(Double(baseSalary) * companyModifier * disciplineBonus * performanceBonus)
    }
    
    var body: some View {
        Button(action: {
            store.selectJob(job)
        }) {
            HStack(spacing: 20) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    if let major = store.player.major {
                        Text(major.emoji)
                            .font(.system(size: 32))
                    } else {
                        Image(systemName: "briefcase.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(job.title)
                        .font(.system(size: 22, weight: .bold))
                    
                    Text(job.description)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack(spacing: 15) {
                        Label("~$\(estimatedSalary.formatted())/year", systemImage: "dollarsign.circle.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.green)
                        
                        if store.player.performance > 70 {
                            Label("High Match", systemImage: "star.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.purple)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: isHovered ? .purple.opacity(0.3) : .clear, radius: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isHovered ? Color.purple : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - Discipline Info Panel

struct DisciplineInfoPanel: View {
    @ObservedObject var store: GameStore
    
    var body: some View {
        if let major = store.player.major {
            GlassmorphicCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Your Specialization")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    
                    HStack(spacing: 15) {
                        VStack {
                            Text(major.emoji)
                                .font(.system(size: 32))
                            Text("Major")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(major.rawValue)
                                .font(.system(size: 14, weight: .bold))
                            Text("Avg: $\(major.averageStartingSalary.formatted())")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                        
                        if let minor = store.player.minor {
                            VStack {
                                Text(minor.emoji)
                                    .font(.system(size: 24))
                                Text("Minor")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Top Skills
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Key Skills:")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        FlowLayout(spacing: 6) {
                            ForEach(major.topSkills, id: \.self) { skill in
                                Text(skill)
                                    .font(.system(size: 10, weight: .medium))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.purple.opacity(0.2))
                                    )
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - Flow Layout for Skills

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: x, y: y, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}
