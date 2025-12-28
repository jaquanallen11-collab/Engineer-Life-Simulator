import Foundation

// MARK: - GameStore Extensions for Disciplines
// Note: Player.major and Player.minor properties are now defined directly in the Player struct

extension GameStore {
    
    // MARK: - Major/Minor Selection
    
    func selectMajorMinor(major: EngineeringDiscipline, minor: EngineeringDiscipline) {
        player.major = major
        player.minor = minor
        addLog("Selected major: \(major.rawValue)")
        addLog("Selected minor: \(minor.rawValue)")
        addLog("Your engineering specialization is set!")
        screen = .university
    }
    
    // MARK: - Discipline-Aware Company Selection
    
    func getDisciplineCompanies() -> [Company] {
        guard let major = player.major else {
            return CompanyData.famousCompanies
        }
        
        var companies = DisciplineCompanies.getCompanies(for: major)
        
        // Add some minor discipline companies
        if let minor = player.minor {
            let minorCompanies = DisciplineCompanies.getCompanies(for: minor).shuffled().prefix(3)
            companies.append(contentsOf: minorCompanies)
        }
        
        return companies
    }
    
    // MARK: - Discipline-Aware Job Generation
    
    func getDisciplineJobs() -> [Job] {
        guard let major = player.major else {
            return GameConstants.jobs
        }
        
        var jobs = DisciplineJobs.getJobs(for: major)
        
        // Add one job from minor if available
        if let minor = player.minor {
            let minorJobs = DisciplineJobs.getJobs(for: minor)
            if let minorJob = minorJobs.randomElement() {
                jobs.append(minorJob)
            }
        }
        
        return jobs
    }
    
    // MARK: - Discipline-Aware Scenarios
    
    func generateDisciplineScenario() {
        guard let major = player.major else {
            generateScenario()
            return
        }
        
        let scenarios = DisciplineScenarios.getScenarios(for: major, chapter: player.lifeChapter)
        
        // 30% chance to get a minor-related scenario if available
        if let minor = player.minor, Double.random(in: 0...1) < 0.3 {
            let minorScenarios = DisciplineScenarios.getScenarios(for: minor, chapter: player.lifeChapter)
            if !minorScenarios.isEmpty {
                currentScenario = minorScenarios.randomElement()
                return
            }
        }
        
        currentScenario = scenarios.randomElement()
    }
    
    // MARK: - Discipline-Aware Career Progression
    
    func generateDisciplineJobOffers() {
        guard let major = player.major else {
            generateJobOffers()
            return
        }
        
        jobOffers = []
        let companies = getDisciplineCompanies().shuffled().prefix(5)
        let jobs = getDisciplineJobs()
        
        for company in companies {
            let job = jobs.randomElement()!
            let baseSalary = job.salary
            let salary = Int(Double(baseSalary) * company.startingSalaryModifier * (1 + Double(player.performance) / 200))
            let increase = Double.random(in: 0.05...0.25)
            let bonus = Int.random(in: 5000...25000)
            
            let offer = JobOffer(
                company: company,
                role: job.title,
                salary: salary,
                salaryIncrease: increase,
                signingBonus: bonus
            )
            jobOffers.append(offer)
        }
        
        screen = .jobOffers
    }
    
    // MARK: - Career Information
    
    func getDisciplineInfo() -> String {
        guard let major = player.major else {
            return "Engineering"
        }
        
        var info = "\(major.emoji) \(major.rawValue)"
        
        if let minor = player.minor {
            info += " + \(minor.emoji) \(minor.rawValue) minor"
        }
        
        return info
    }
    
    func getDisciplineSalaryBonus() -> Double {
        guard let major = player.major else {
            return 1.0
        }
        
        // Higher paying disciplines get a multiplier
        let baseSalary = major.averageStartingSalary
        let multiplier = Double(baseSalary) / 75000.0 // Normalize to average
        
        return multiplier
    }
}

// MARK: - Updated Player Codable Support

// Note: You'll need to add these to the Player struct in your main code:
/*
Add to Player struct:

    var major: EngineeringDiscipline?
    var minor: EngineeringDiscipline?
    
    // Update CodingKeys if using custom Codable implementation
    enum CodingKeys: String, CodingKey {
        case name, age, gameYear, money, performance, rank, role
        case lifeChapter, ivyExamPassed, university, company
        case companyRating, yearsInCompany, isEmployed
        case educationHistory, investments, properties, assets
        case major, minor  // Add these
    }
*/
