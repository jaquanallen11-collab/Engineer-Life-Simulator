import Foundation
import SwiftUI
import CoreML

// MARK: - NPC Character Engine

@MainActor
class NPCEngine: ObservableObject {
    @Published var allCharacters: [NPCCharacter] = []
    @Published var currentTeam: [NPCCharacter] = []
    @Published var activeProjects: [TeamProject] = []
    @Published var recentInteractions: [CharacterInteraction] = []
    @Published var relationshipMap: [String: Double] = [:] // characterID: relationship score
    
    private let personalityEngine = PersonalityEngine()
    private let dialogueEngine = DialogueEngine()
    
    init() {
        generateInitialCharacters()
    }
    
    // MARK: - Character Generation
    
    func generateInitialCharacters() {
        allCharacters = [
            generateCharacter(role: .softwareEngineer, seniority: .junior),
            generateCharacter(role: .softwareEngineer, seniority: .mid),
            generateCharacter(role: .softwareEngineer, seniority: .senior),
            generateCharacter(role: .productManager, seniority: .mid),
            generateCharacter(role: .designer, seniority: .mid),
            generateCharacter(role: .dataScientist, seniority: .senior),
            generateCharacter(role: .devOps, seniority: .junior),
            generateCharacter(role: .qa, seniority: .mid)
        ]
    }
    
    func generateCharacter(role: NPCRole, seniority: Seniority) -> NPCCharacter {
        let personality = personalityEngine.generatePersonality()
        let skills = personalityEngine.generateSkills(for: role, seniority: seniority)
        
        let firstName = NPCNames.firstNames.randomElement()!
        let lastName = NPCNames.lastNames.randomElement()!
        
        return NPCCharacter(
            id: UUID().uuidString,
            firstName: firstName,
            lastName: lastName,
            role: role,
            seniority: seniority,
            personality: personality,
            skills: skills,
            mood: .neutral,
            energy: 80,
            productivity: 75,
            relationshipWithPlayer: 50
        )
    }
    
    func generateNewTeam(size: Int, company: Company) {
        currentTeam = []
        
        // Generate diverse team
        let roles: [NPCRole] = [.softwareEngineer, .softwareEngineer, .productManager, .designer, .qa]
        
        for i in 0..<min(size, roles.count) {
            let character = generateCharacter(
                role: roles[i],
                seniority: [.junior, .mid, .senior].randomElement()!
            )
            currentTeam.append(character)
            allCharacters.append(character)
        }
    }
    
    // MARK: - Interactions
    
    func interactWithCharacter(_ character: NPCCharacter, interaction: InteractionType) -> InteractionResult {
        guard let index = allCharacters.firstIndex(where: { $0.id == character.id }) else {
            return InteractionResult(success: false, message: "Character not found", relationshipChange: 0)
        }
        
        let result = processInteraction(character: character, interaction: interaction)
        
        // Update character state
        allCharacters[index].relationshipWithPlayer += result.relationshipChange
        allCharacters[index].relationshipWithPlayer = max(0, min(100, allCharacters[index].relationshipWithPlayer))
        
        // Update mood
        if result.relationshipChange > 5 {
            allCharacters[index].mood = .happy
        } else if result.relationshipChange < -5 {
            allCharacters[index].mood = .annoyed
        }
        
        // Record interaction
        let interactionRecord = CharacterInteraction(
            characterId: character.id,
            type: interaction,
            timestamp: Date(),
            outcome: result.message
        )
        recentInteractions.insert(interactionRecord, at: 0)
        if recentInteractions.count > 50 {
            recentInteractions = Array(recentInteractions.prefix(50))
        }
        
        return result
    }
    
    private func processInteraction(character: NPCCharacter, interaction: InteractionType) -> InteractionResult {
        let personalityFactor = personalityEngine.getInteractionModifier(
            personality: character.personality,
            interaction: interaction
        )
        
        switch interaction {
        case .askForHelp:
            if character.energy > 50 && character.personality.agreeableness > 0.6 {
                return InteractionResult(
                    success: true,
                    message: dialogueEngine.generateResponse(character: character, context: .helping),
                    relationshipChange: Int.random(in: 3...8)
                )
            } else {
                return InteractionResult(
                    success: false,
                    message: dialogueEngine.generateResponse(character: character, context: .busy),
                    relationshipChange: Int.random(in: -2...1)
                )
            }
            
        case .collaborate:
            let successChance = (character.skills.teamwork + personalityFactor) / 2.0
            if Double.random(in: 0...1) < successChance {
                return InteractionResult(
                    success: true,
                    message: dialogueEngine.generateResponse(character: character, context: .collaborating),
                    relationshipChange: Int.random(in: 5...12)
                )
            } else {
                return InteractionResult(
                    success: false,
                    message: dialogueEngine.generateResponse(character: character, context: .declining),
                    relationshipChange: 0
                )
            }
            
        case .praise:
            let reactionStrength = character.personality.emotionalStability * 10
            return InteractionResult(
                success: true,
                message: dialogueEngine.generateResponse(character: character, context: .praised),
                relationshipChange: Int(reactionStrength) + Int.random(in: 5...10)
            )
            
        case .critique:
            if character.personality.emotionalStability > 0.7 {
                return InteractionResult(
                    success: true,
                    message: dialogueEngine.generateResponse(character: character, context: .constructiveCriticism),
                    relationshipChange: Int.random(in: 0...3)
                )
            } else {
                return InteractionResult(
                    success: false,
                    message: dialogueEngine.generateResponse(character: character, context: .offended),
                    relationshipChange: Int.random(in: -8...-3)
                )
            }
            
        case .smallTalk:
            let socialBonus = character.personality.extraversion * 10
            return InteractionResult(
                success: true,
                message: dialogueEngine.generateResponse(character: character, context: .casual),
                relationshipChange: Int(socialBonus) + Int.random(in: 1...5)
            )
            
        case .requestProject:
            if character.relationshipWithPlayer > 60 && character.productivity > 60 {
                return InteractionResult(
                    success: true,
                    message: dialogueEngine.generateResponse(character: character, context: .accepting),
                    relationshipChange: Int.random(in: 2...6)
                )
            } else {
                return InteractionResult(
                    success: false,
                    message: dialogueEngine.generateResponse(character: character, context: .toobusy),
                    relationshipChange: Int.random(in: -3...0)
                )
            }
        }
    }
    
    // MARK: - Team Projects
    
    func startTeamProject(name: String, complexity: ProjectComplexity, teamMembers: [NPCCharacter]) -> TeamProject {
        let project = TeamProject(
            id: UUID().uuidString,
            name: name,
            complexity: complexity,
            teamMembers: teamMembers,
            progress: 0,
            quality: 50,
            daysRemaining: complexity.duration,
            morale: 70
        )
        
        activeProjects.append(project)
        return project
    }
    
    func updateProjectProgress(projectId: String, playerContribution: Double) {
        guard let index = activeProjects.firstIndex(where: { $0.id == projectId }) else { return }
        
        var project = activeProjects[index]
        
        // Calculate team contribution
        var totalContribution = playerContribution
        
        for member in project.teamMembers {
            if let character = allCharacters.first(where: { $0.id == member.id }) {
                // Contribution based on skills, energy, mood, and relationship
                let skillFactor = (character.skills.technical + character.skills.problemSolving) / 2.0
                let energyFactor = Double(character.energy) / 100.0
                let moodFactor = character.mood.productivityMultiplier
                let relationshipFactor = 0.5 + (Double(character.relationshipWithPlayer) / 200.0)
                
                let memberContribution = skillFactor * energyFactor * moodFactor * relationshipFactor * 10
                totalContribution += memberContribution
                
                // Update character energy
                updateCharacterEnergy(character.id, change: -5)
            }
        }
        
        // Update project
        project.progress += Int(totalContribution)
        project.daysRemaining -= 1
        
        // Quality fluctuates based on team morale and skills
        let qualityChange = Int.random(in: -5...10)
        project.quality = max(0, min(100, project.quality + qualityChange))
        
        // Morale changes
        if project.progress > project.complexity.targetProgress / 2 {
            project.morale = min(100, project.morale + 3)
        } else if project.daysRemaining < 5 {
            project.morale = max(0, project.morale - 5)
        }
        
        activeProjects[index] = project
        
        // Check completion
        if project.progress >= project.complexity.targetProgress {
            completeProject(projectId: projectId)
        }
    }
    
    private func completeProject(projectId: String) {
        guard let index = activeProjects.firstIndex(where: { $0.id == projectId }) else { return }
        
        let project = activeProjects[index]
        
        // Reward team members based on performance
        for member in project.teamMembers {
            let relationshipBonus = project.quality > 70 ? 10 : 5
            interactWithCharacter(member, interaction: .praise)
            
            if let charIndex = allCharacters.firstIndex(where: { $0.id == member.id }) {
                allCharacters[charIndex].relationshipWithPlayer += relationshipBonus
                allCharacters[charIndex].mood = .happy
            }
        }
        
        activeProjects.remove(at: index)
    }
    
    // MARK: - Character State Management
    
    func updateAllCharacters() {
        for i in allCharacters.indices {
            // Natural energy recovery
            allCharacters[i].energy = min(100, allCharacters[i].energy + 5)
            
            // Mood gradually returns to neutral
            if allCharacters[i].mood != .neutral {
                if Bool.random() {
                    allCharacters[i].mood = .neutral
                }
            }
            
            // Productivity fluctuates
            let productivityChange = Int.random(in: -5...5)
            allCharacters[i].productivity = max(30, min(100, allCharacters[i].productivity + productivityChange))
        }
    }
    
    private func updateCharacterEnergy(_ characterId: String, change: Int) {
        if let index = allCharacters.firstIndex(where: { $0.id == characterId }) {
            allCharacters[index].energy = max(0, min(100, allCharacters[index].energy + change))
        }
    }
    
    // MARK: - Character Events
    
    func generateRandomEvent(for character: NPCCharacter) -> CharacterEvent? {
        let events: [CharacterEvent] = [
            CharacterEvent(
                type: .personalNews,
                message: "\(character.firstName) shared exciting personal news!",
                relationshipImpact: 5
            ),
            CharacterEvent(
                type: .technicalBreakthrough,
                message: "\(character.firstName) made a technical breakthrough on their task!",
                relationshipImpact: 3
            ),
            CharacterEvent(
                type: .needsHelp,
                message: "\(character.firstName) is struggling and could use your help.",
                relationshipImpact: 0
            ),
            CharacterEvent(
                type: .sharingIdea,
                message: "\(character.firstName) wants to share an interesting idea with you.",
                relationshipImpact: 2
            )
        ]
        
        return events.randomElement()
    }
    
    func getCharacterById(_ id: String) -> NPCCharacter? {
        return allCharacters.first(where: { $0.id == id })
    }
}

// MARK: - Models

struct NPCCharacter: Identifiable, Codable, Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let role: NPCRole
    let seniority: Seniority
    let personality: PersonalityTraits
    var skills: CharacterSkills
    var mood: CharacterMood
    var energy: Int
    var productivity: Int
    var relationshipWithPlayer: Int
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var avatar: String {
        let emojis = ["👨‍💻", "👩‍💻", "👨‍🔬", "👩‍🔬", "👨‍💼", "👩‍💼", "👨‍🎨", "👩‍🎨"]
        return emojis[abs(id.hashValue) % emojis.count]
    }
}

enum NPCRole: String, Codable {
    case softwareEngineer = "Software Engineer"
    case productManager = "Product Manager"
    case designer = "UX Designer"
    case dataScientist = "Data Scientist"
    case devOps = "DevOps Engineer"
    case qa = "QA Engineer"
}

enum Seniority: String, Codable {
    case junior = "Junior"
    case mid = "Mid-Level"
    case senior = "Senior"
    case staff = "Staff"
    case principal = "Principal"
    
    var experienceYears: Int {
        switch self {
        case .junior: return Int.random(in: 0...2)
        case .mid: return Int.random(in: 3...5)
        case .senior: return Int.random(in: 6...10)
        case .staff: return Int.random(in: 11...15)
        case .principal: return Int.random(in: 16...25)
        }
    }
}

struct PersonalityTraits: Codable, Equatable {
    var openness: Double // 0-1: curiosity, creativity
    var conscientiousness: Double // 0-1: organized, dependable
    var extraversion: Double // 0-1: sociable, energetic
    var agreeableness: Double // 0-1: cooperative, friendly
    var emotionalStability: Double // 0-1: calm under pressure
    
    static func random() -> PersonalityTraits {
        PersonalityTraits(
            openness: Double.random(in: 0.3...1.0),
            conscientiousness: Double.random(in: 0.3...1.0),
            extraversion: Double.random(in: 0.2...1.0),
            agreeableness: Double.random(in: 0.3...1.0),
            emotionalStability: Double.random(in: 0.4...1.0)
        )
    }
}

struct CharacterSkills: Codable, Equatable {
    var technical: Double // 0-1
    var communication: Double // 0-1
    var leadership: Double // 0-1
    var problemSolving: Double // 0-1
    var creativity: Double // 0-1
    var teamwork: Double // 0-1
}

enum CharacterMood: String, Codable, Equatable {
    case veryHappy = "Very Happy"
    case happy = "Happy"
    case neutral = "Neutral"
    case stressed = "Stressed"
    case annoyed = "Annoyed"
    case frustrated = "Frustrated"
    
    var emoji: String {
        switch self {
        case .veryHappy: return "😄"
        case .happy: return "🙂"
        case .neutral: return "😐"
        case .stressed: return "😰"
        case .annoyed: return "😒"
        case .frustrated: return "😤"
        }
    }
    
    var productivityMultiplier: Double {
        switch self {
        case .veryHappy: return 1.2
        case .happy: return 1.1
        case .neutral: return 1.0
        case .stressed: return 0.9
        case .annoyed: return 0.8
        case .frustrated: return 0.7
        }
    }
}

enum InteractionType {
    case askForHelp
    case collaborate
    case praise
    case critique
    case smallTalk
    case requestProject
}

struct InteractionResult {
    let success: Bool
    let message: String
    let relationshipChange: Int
}

struct CharacterInteraction: Identifiable {
    let id = UUID()
    let characterId: String
    let type: InteractionType
    let timestamp: Date
    let outcome: String
}

struct TeamProject: Identifiable, Codable {
    let id: String
    let name: String
    let complexity: ProjectComplexity
    let teamMembers: [NPCCharacter]
    var progress: Int
    var quality: Int
    var daysRemaining: Int
    var morale: Int
}

enum ProjectComplexity: String, Codable {
    case simple = "Simple"
    case moderate = "Moderate"
    case complex = "Complex"
    case veryComplex = "Very Complex"
    
    var targetProgress: Int {
        switch self {
        case .simple: return 100
        case .moderate: return 250
        case .complex: return 500
        case .veryComplex: return 1000
        }
    }
    
    var duration: Int {
        switch self {
        case .simple: return 5
        case .moderate: return 10
        case .complex: return 20
        case .veryComplex: return 30
        }
    }
}

struct CharacterEvent {
    let type: EventType
    let message: String
    let relationshipImpact: Int
    
    enum EventType {
        case personalNews
        case technicalBreakthrough
        case needsHelp
        case sharingIdea
    }
}

// MARK: - Supporting Classes

class PersonalityEngine {
    func generatePersonality() -> PersonalityTraits {
        return PersonalityTraits.random()
    }
    
    func generateSkills(for role: NPCRole, seniority: Seniority) -> CharacterSkills {
        let baseSkill = Double(seniority.experienceYears) / 25.0 + 0.3
        let variance = 0.2
        
        switch role {
        case .softwareEngineer:
            return CharacterSkills(
                technical: min(1.0, baseSkill + Double.random(in: 0...variance)),
                communication: min(1.0, baseSkill - 0.1 + Double.random(in: 0...variance)),
                leadership: min(1.0, baseSkill - 0.2 + Double.random(in: 0...variance)),
                problemSolving: min(1.0, baseSkill + 0.1 + Double.random(in: 0...variance)),
                creativity: min(1.0, baseSkill + Double.random(in: 0...variance)),
                teamwork: min(1.0, baseSkill + Double.random(in: 0...variance))
            )
        case .productManager:
            return CharacterSkills(
                technical: min(1.0, baseSkill - 0.1 + Double.random(in: 0...variance)),
                communication: min(1.0, baseSkill + 0.2 + Double.random(in: 0...variance)),
                leadership: min(1.0, baseSkill + 0.2 + Double.random(in: 0...variance)),
                problemSolving: min(1.0, baseSkill + 0.1 + Double.random(in: 0...variance)),
                creativity: min(1.0, baseSkill + Double.random(in: 0...variance)),
                teamwork: min(1.0, baseSkill + 0.1 + Double.random(in: 0...variance))
            )
        case .designer:
            return CharacterSkills(
                technical: min(1.0, baseSkill - 0.2 + Double.random(in: 0...variance)),
                communication: min(1.0, baseSkill + 0.1 + Double.random(in: 0...variance)),
                leadership: min(1.0, baseSkill - 0.1 + Double.random(in: 0...variance)),
                problemSolving: min(1.0, baseSkill + Double.random(in: 0...variance)),
                creativity: min(1.0, baseSkill + 0.3 + Double.random(in: 0...variance)),
                teamwork: min(1.0, baseSkill + Double.random(in: 0...variance))
            )
        default:
            return CharacterSkills(
                technical: min(1.0, baseSkill + Double.random(in: 0...variance)),
                communication: min(1.0, baseSkill + Double.random(in: 0...variance)),
                leadership: min(1.0, baseSkill + Double.random(in: 0...variance)),
                problemSolving: min(1.0, baseSkill + Double.random(in: 0...variance)),
                creativity: min(1.0, baseSkill + Double.random(in: 0...variance)),
                teamwork: min(1.0, baseSkill + Double.random(in: 0...variance))
            )
        }
    }
    
    func getInteractionModifier(personality: PersonalityTraits, interaction: InteractionType) -> Double {
        switch interaction {
        case .askForHelp:
            return personality.agreeableness
        case .collaborate:
            return (personality.agreeableness + personality.extraversion) / 2.0
        case .praise:
            return personality.emotionalStability
        case .critique:
            return personality.emotionalStability * personality.openness
        case .smallTalk:
            return personality.extraversion
        case .requestProject:
            return personality.conscientiousness
        }
    }
}

class DialogueEngine {
    func generateResponse(character: NPCCharacter, context: DialogueContext) -> String {
        let templates = getTemplates(for: context)
        let template = templates.randomElement()!
        
        return template
            .replacingOccurrences(of: "{name}", with: character.firstName)
            .replacingOccurrences(of: "{role}", with: character.role.rawValue)
    }
    
    private func getTemplates(for context: DialogueContext) -> [String] {
        switch context {
        case .helping:
            return [
                "Sure, I'd be happy to help! What do you need?",
                "Of course! Let me take a look at that.",
                "No problem, I've dealt with this before. Let's figure it out together.",
                "I'm free right now. What's the issue?"
            ]
        case .busy:
            return [
                "Sorry, I'm swamped right now. Can we talk later?",
                "I'm in the middle of something. Maybe ask someone else?",
                "I'd love to help, but I'm on a tight deadline right now.",
                "Can this wait? I'm really buried in work."
            ]
        case .collaborating:
            return [
                "Let's do this! I think we can make something great together.",
                "I'm excited to work with you on this!",
                "This will be a good learning experience for both of us.",
                "Great idea! When do we start?"
            ]
        case .declining:
            return [
                "I appreciate the offer, but I'm focused on other things right now.",
                "Maybe next time? I have too much on my plate.",
                "I don't think I'm the best fit for this.",
                "Thanks, but I'll have to pass."
            ]
        case .praised:
            return [
                "Thanks! That means a lot coming from you.",
                "I appreciate that! Just trying to do my best.",
                "Wow, thank you! I worked really hard on that.",
                "That's really nice of you to say!"
            ]
        case .constructiveCriticism:
            return [
                "I appreciate the feedback. I'll work on improving that.",
                "You're right. Let me revisit that approach.",
                "Good point. I hadn't thought of it that way.",
                "Thanks for pointing that out. I'll fix it."
            ]
        case .offended:
            return [
                "That seems a bit harsh...",
                "I don't think that's fair.",
                "Wow. Okay then.",
                "I was just trying my best..."
            ]
        case .casual:
            return [
                "Hey! How's your day going?",
                "Did you see the game last night?",
                "What are you working on these days?",
                "Got any fun plans for the weekend?"
            ]
        case .accepting:
            return [
                "I'm in! This sounds interesting.",
                "Count me in. I've been wanting to work on something like this.",
                "Absolutely! Let's make it happen.",
                "I'd love to be part of this project."
            ]
        case .toobusy:
            return [
                "I'm overloaded right now, sorry.",
                "I wish I could, but I'm maxed out on projects.",
                "My plate is completely full at the moment.",
                "I'd have to decline for now. Too much going on."
            ]
        }
    }
}

enum DialogueContext {
    case helping, busy, collaborating, declining, praised, constructiveCriticism, offended, casual, accepting, toobusy
}

struct NPCNames {
    static let firstNames = [
        "Alex", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Avery", "Quinn",
        "Sam", "Jamie", "Drew", "Blake", "Reese", "Peyton", "Cameron", "Dakota",
        "Skyler", "River", "Phoenix", "Sage", "Rowan", "Finley", "Parker", "Charlie"
    ]
    
    static let lastNames = [
        "Chen", "Patel", "Kim", "Garcia", "Nguyen", "Rodriguez", "Singh", "Lee",
        "Martinez", "Johnson", "Williams", "Brown", "Jones", "Davis", "Wilson", "Moore",
        "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson"
    ]
}
