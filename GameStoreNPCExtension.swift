import Foundation

// MARK: - GameStore Integration with NPC Engine

extension GameStore {
    
    // Initialize NPC Engine when joining company
    func initializeTeamForCompany(_ company: Company, npcEngine: NPCEngine) {
        let teamSize = min(company.prestigeLevel, 8) // Higher prestige = bigger teams
        npcEngine.generateNewTeam(size: teamSize, company: company)
        
        // Auto-generate an initial project
        if !npcEngine.currentTeam.isEmpty {
            let initialProject = npcEngine.startTeamProject(
                name: "\(company.name) Initiative",
                complexity: .moderate,
                teamMembers: Array(npcEngine.currentTeam.prefix(3))
            )
            addLog("You've been assigned to: \(initialProject.name)")
        }
    }
    
    // Year progression with NPC updates
    func updateTeamDynamics(npcEngine: NPCEngine) {
        // Update all character states
        npcEngine.updateAllCharacters()
        
        // Update active projects
        for project in npcEngine.activeProjects {
            npcEngine.updateProjectProgress(projectId: project.id, playerContribution: 0)
        }
        
        // Random character events (10% chance per character)
        for character in npcEngine.currentTeam {
            if Double.random(in: 0...1) < 0.1 {
                if let event = npcEngine.generateRandomEvent(for: character) {
                    addLog("📢 \(event.message)")
                    if let char = npcEngine.getCharacterById(character.id) {
                        _ = npcEngine.interactWithCharacter(char, interaction: .smallTalk)
                    }
                }
            }
        }
        
        // Chance for new project (20% if < 3 active projects)
        if npcEngine.activeProjects.count < 3 && Double.random(in: 0...1) < 0.2 {
            let complexities: [ProjectComplexity] = [.simple, .moderate, .complex]
            let projectNames = [
                "Performance Optimization",
                "Feature Development",
                "Bug Fixes Sprint",
                "Architecture Redesign",
                "Security Audit",
                "Database Migration",
                "API Overhaul",
                "UI Refresh"
            ]
            
            let selectedMembers = npcEngine.currentTeam.shuffled().prefix(Int.random(in: 2...5))
            let newProject = npcEngine.startTeamProject(
                name: projectNames.randomElement()!,
                complexity: complexities.randomElement()!,
                teamMembers: Array(selectedMembers)
            )
            addLog("🚀 New project assigned: \(newProject.name)")
        }
    }
    
    // Calculate performance boost from team relationships
    func getTeamPerformanceBoost(npcEngine: NPCEngine) -> Int {
        guard !npcEngine.currentTeam.isEmpty else { return 0 }
        
        let avgRelationship = npcEngine.currentTeam.reduce(0) { $0 + $1.relationshipWithPlayer } / npcEngine.currentTeam.count
        
        // Good relationships boost performance
        if avgRelationship > 70 {
            return 15
        } else if avgRelationship > 50 {
            return 5
        } else if avgRelationship < 30 {
            return -10
        }
        return 0
    }
    
    // Salary bonus from completed projects
    func calculateProjectBonus(npcEngine: NPCEngine) -> Int {
        var bonus = 0
        
        for project in npcEngine.activeProjects {
            if project.progress >= project.complexity.targetProgress {
                // Quality affects bonus
                let qualityMultiplier = Double(project.quality) / 100.0
                bonus += Int(Double(project.complexity.targetProgress) * qualityMultiplier * 0.5)
            }
        }
        
        return bonus
    }
}
