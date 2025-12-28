import Foundation

// MARK: - Engineering Disciplines

enum EngineeringDiscipline: String, Codable, CaseIterable {
    case software = "Software Engineering"
    case mechanical = "Mechanical Engineering"
    case electrical = "Electrical Engineering"
    case civil = "Civil Engineering"
    case chemical = "Chemical Engineering"
    case aerospace = "Aerospace Engineering"
    case environmental = "Environmental Engineering"
    case biomedical = "Biomedical Engineering"
    case industrial = "Industrial Engineering"
    case petroleum = "Petroleum Engineering"
    case materials = "Materials Engineering"
    case nuclear = "Nuclear Engineering"
    
    var description: String {
        switch self {
        case .software:
            return "Design and develop software systems, apps, and infrastructure"
        case .mechanical:
            return "Design mechanical systems, machines, and thermal devices"
        case .electrical:
            return "Work with electrical systems, circuits, and power generation"
        case .civil:
            return "Design and oversee construction of infrastructure and buildings"
        case .chemical:
            return "Develop chemical processes and manufacturing systems"
        case .aerospace:
            return "Design aircraft, spacecraft, and propulsion systems"
        case .environmental:
            return "Develop solutions for environmental protection and sustainability"
        case .biomedical:
            return "Create medical devices and healthcare technologies"
        case .industrial:
            return "Optimize production systems and supply chain operations"
        case .petroleum:
            return "Extract and process oil and natural gas resources"
        case .materials:
            return "Develop new materials and improve existing ones"
        case .nuclear:
            return "Design nuclear power systems and radiation applications"
        }
    }
    
    var emoji: String {
        switch self {
        case .software: return "💻"
        case .mechanical: return "⚙️"
        case .electrical: return "⚡"
        case .civil: return "🏗️"
        case .chemical: return "⚗️"
        case .aerospace: return "🚀"
        case .environmental: return "🌍"
        case .biomedical: return "🏥"
        case .industrial: return "🏭"
        case .petroleum: return "🛢️"
        case .materials: return "🔬"
        case .nuclear: return "⚛️"
        }
    }
    
    var averageStartingSalary: Int {
        switch self {
        case .software: return 95000
        case .petroleum: return 93000
        case .chemical: return 85000
        case .electrical: return 82000
        case .aerospace: return 80000
        case .nuclear: return 79000
        case .mechanical: return 78000
        case .biomedical: return 77000
        case .materials: return 76000
        case .civil: return 72000
        case .industrial: return 71000
        case .environmental: return 68000
        }
    }
    
    var topSkills: [String] {
        switch self {
        case .software:
            return ["Programming", "Algorithms", "System Design", "Debugging"]
        case .mechanical:
            return ["CAD", "Thermodynamics", "Materials Science", "Manufacturing"]
        case .electrical:
            return ["Circuit Design", "Signal Processing", "Power Systems", "Electronics"]
        case .civil:
            return ["Structural Analysis", "AutoCAD", "Construction Management", "Surveying"]
        case .chemical:
            return ["Process Design", "Thermodynamics", "Reaction Engineering", "Safety"]
        case .aerospace:
            return ["Aerodynamics", "Propulsion", "Flight Mechanics", "CAD"]
        case .environmental:
            return ["Sustainability", "Water Treatment", "Air Quality", "Environmental Law"]
        case .biomedical:
            return ["Biomechanics", "Medical Devices", "FDA Regulations", "Tissue Engineering"]
        case .industrial:
            return ["Operations Research", "Lean Manufacturing", "Supply Chain", "Quality Control"]
        case .petroleum:
            return ["Drilling", "Reservoir Engineering", "Geophysics", "Production"]
        case .materials:
            return ["Material Properties", "Characterization", "Nanotechnology", "Synthesis"]
        case .nuclear:
            return ["Reactor Physics", "Radiation Safety", "Thermal Hydraulics", "Nuclear Fuel"]
        }
    }
}

// MARK: - Discipline-Specific Companies

struct DisciplineCompanies {
    static func getCompanies(for discipline: EngineeringDiscipline) -> [Company] {
        switch discipline {
        case .software:
            return [
                Company(name: "Apple", plantName: "Cupertino Campus", startingSalaryModifier: 1.3, prestigeLevel: 10),
                Company(name: "Google", plantName: "Mountain View", startingSalaryModifier: 1.35, prestigeLevel: 10),
                Company(name: "Microsoft", plantName: "Redmond", startingSalaryModifier: 1.25, prestigeLevel: 9),
                Company(name: "Meta", plantName: "Menlo Park", startingSalaryModifier: 1.3, prestigeLevel: 9),
                Company(name: "Amazon", plantName: "Seattle HQ", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "Netflix", plantName: "Los Gatos", startingSalaryModifier: 1.4, prestigeLevel: 8),
                Company(name: "Uber", plantName: "San Francisco", startingSalaryModifier: 1.15, prestigeLevel: 7),
                Company(name: "Salesforce", plantName: "San Francisco", startingSalaryModifier: 1.2, prestigeLevel: 7)
            ]
            
        case .mechanical:
            return [
                Company(name: "Tesla", plantName: "Fremont Factory", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "General Motors", plantName: "Detroit", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "Ford", plantName: "Dearborn", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "Boeing", plantName: "Seattle", startingSalaryModifier: 1.15, prestigeLevel: 9),
                Company(name: "Caterpillar", plantName: "Peoria", startingSalaryModifier: 1.0, prestigeLevel: 7),
                Company(name: "John Deere", plantName: "Moline", startingSalaryModifier: 1.0, prestigeLevel: 7),
                Company(name: "3M", plantName: "St. Paul", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "GE", plantName: "Boston", startingSalaryModifier: 1.1, prestigeLevel: 8)
            ]
            
        case .electrical:
            return [
                Company(name: "Intel", plantName: "Santa Clara", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "NVIDIA", plantName: "Santa Clara", startingSalaryModifier: 1.25, prestigeLevel: 9),
                Company(name: "AMD", plantName: "Santa Clara", startingSalaryModifier: 1.2, prestigeLevel: 8),
                Company(name: "Texas Instruments", plantName: "Dallas", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "Qualcomm", plantName: "San Diego", startingSalaryModifier: 1.2, prestigeLevel: 8),
                Company(name: "Broadcom", plantName: "San Jose", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "Analog Devices", plantName: "Boston", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "Siemens", plantName: "Munich", startingSalaryModifier: 1.1, prestigeLevel: 8)
            ]
            
        case .civil:
            return [
                Company(name: "Bechtel", plantName: "San Francisco", startingSalaryModifier: 1.15, prestigeLevel: 9),
                Company(name: "AECOM", plantName: "Dallas", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "Fluor", plantName: "Irving", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "Jacobs Engineering", plantName: "Dallas", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "Kiewit", plantName: "Omaha", startingSalaryModifier: 1.0, prestigeLevel: 7),
                Company(name: "Turner Construction", plantName: "New York", startingSalaryModifier: 1.0, prestigeLevel: 7),
                Company(name: "HDR", plantName: "Omaha", startingSalaryModifier: 1.0, prestigeLevel: 7),
                Company(name: "Parsons", plantName: "Pasadena", startingSalaryModifier: 1.05, prestigeLevel: 7)
            ]
            
        case .chemical:
            return [
                Company(name: "DuPont", plantName: "Wilmington", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "Dow Chemical", plantName: "Midland", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "ExxonMobil", plantName: "Houston", startingSalaryModifier: 1.25, prestigeLevel: 9),
                Company(name: "BASF", plantName: "Ludwigshafen", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "3M", plantName: "St. Paul", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "Air Products", plantName: "Allentown", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "Linde", plantName: "Munich", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "Procter & Gamble", plantName: "Cincinnati", startingSalaryModifier: 1.1, prestigeLevel: 8)
            ]
            
        case .aerospace:
            return [
                Company(name: "SpaceX", plantName: "Hawthorne", startingSalaryModifier: 1.15, prestigeLevel: 10),
                Company(name: "Blue Origin", plantName: "Kent", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "Boeing", plantName: "Seattle", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "Lockheed Martin", plantName: "Bethesda", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "Northrop Grumman", plantName: "Falls Church", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "NASA", plantName: "Houston", startingSalaryModifier: 1.0, prestigeLevel: 10),
                Company(name: "Raytheon", plantName: "Waltham", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "Airbus", plantName: "Toulouse", startingSalaryModifier: 1.1, prestigeLevel: 8)
            ]
            
        case .environmental:
            return [
                Company(name: "AECOM", plantName: "Dallas", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "Jacobs", plantName: "Dallas", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "Tetra Tech", plantName: "Pasadena", startingSalaryModifier: 1.05, prestigeLevel: 7),
                Company(name: "CH2M Hill", plantName: "Denver", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "Arcadis", plantName: "Amsterdam", startingSalaryModifier: 1.05, prestigeLevel: 7),
                Company(name: "EPA", plantName: "Washington DC", startingSalaryModifier: 0.9, prestigeLevel: 8),
                Company(name: "Stantec", plantName: "Edmonton", startingSalaryModifier: 1.0, prestigeLevel: 6),
                Company(name: "GHD", plantName: "Sydney", startingSalaryModifier: 1.0, prestigeLevel: 6)
            ]
            
        case .biomedical:
            return [
                Company(name: "Medtronic", plantName: "Minneapolis", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "Johnson & Johnson", plantName: "New Brunswick", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "Abbott", plantName: "Chicago", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "Boston Scientific", plantName: "Boston", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "Stryker", plantName: "Kalamazoo", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "Siemens Healthineers", plantName: "Munich", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "GE Healthcare", plantName: "Chicago", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "Zimmer Biomet", plantName: "Warsaw", startingSalaryModifier: 1.1, prestigeLevel: 7)
            ]
            
        case .industrial:
            return [
                Company(name: "Amazon", plantName: "Seattle HQ", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "Toyota", plantName: "Toyota City", startingSalaryModifier: 1.15, prestigeLevel: 9),
                Company(name: "General Electric", plantName: "Boston", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "Procter & Gamble", plantName: "Cincinnati", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "UPS", plantName: "Atlanta", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "FedEx", plantName: "Memphis", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "3M", plantName: "St. Paul", startingSalaryModifier: 1.1, prestigeLevel: 8),
                Company(name: "Honeywell", plantName: "Charlotte", startingSalaryModifier: 1.1, prestigeLevel: 8)
            ]
            
        case .petroleum:
            return [
                Company(name: "ExxonMobil", plantName: "Houston", startingSalaryModifier: 1.3, prestigeLevel: 10),
                Company(name: "Chevron", plantName: "San Ramon", startingSalaryModifier: 1.25, prestigeLevel: 9),
                Company(name: "Shell", plantName: "Houston", startingSalaryModifier: 1.25, prestigeLevel: 9),
                Company(name: "BP", plantName: "London", startingSalaryModifier: 1.2, prestigeLevel: 8),
                Company(name: "ConocoPhillips", plantName: "Houston", startingSalaryModifier: 1.2, prestigeLevel: 8),
                Company(name: "Halliburton", plantName: "Houston", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "Schlumberger", plantName: "Houston", startingSalaryModifier: 1.2, prestigeLevel: 8),
                Company(name: "Baker Hughes", plantName: "Houston", startingSalaryModifier: 1.15, prestigeLevel: 7)
            ]
            
        case .materials:
            return [
                Company(name: "Corning", plantName: "Corning", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "DuPont", plantName: "Wilmington", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "3M", plantName: "St. Paul", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "Applied Materials", plantName: "Santa Clara", startingSalaryModifier: 1.2, prestigeLevel: 8),
                Company(name: "Alcoa", plantName: "Pittsburgh", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "PPG Industries", plantName: "Pittsburgh", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "Owens Corning", plantName: "Toledo", startingSalaryModifier: 1.05, prestigeLevel: 7),
                Company(name: "Saint-Gobain", plantName: "Paris", startingSalaryModifier: 1.1, prestigeLevel: 7)
            ]
            
        case .nuclear:
            return [
                Company(name: "Westinghouse", plantName: "Pittsburgh", startingSalaryModifier: 1.2, prestigeLevel: 8),
                Company(name: "Bechtel", plantName: "San Francisco", startingSalaryModifier: 1.2, prestigeLevel: 9),
                Company(name: "GE Hitachi Nuclear", plantName: "Wilmington", startingSalaryModifier: 1.2, prestigeLevel: 8),
                Company(name: "NuScale Power", plantName: "Portland", startingSalaryModifier: 1.15, prestigeLevel: 7),
                Company(name: "Exelon", plantName: "Chicago", startingSalaryModifier: 1.15, prestigeLevel: 8),
                Company(name: "Duke Energy", plantName: "Charlotte", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "Southern Company", plantName: "Atlanta", startingSalaryModifier: 1.1, prestigeLevel: 7),
                Company(name: "TerraPower", plantName: "Bellevue", startingSalaryModifier: 1.2, prestigeLevel: 8)
            ]
        }
    }
}

// MARK: - Discipline-Specific Jobs

struct DisciplineJobs {
    static func getJobs(for discipline: EngineeringDiscipline) -> [Job] {
        switch discipline {
        case .software:
            return [
                Job(title: "Software Engineer", salary: 95000, description: "Build software systems and applications"),
                Job(title: "Full Stack Developer", salary: 90000, description: "Develop front-end and back-end systems"),
                Job(title: "DevOps Engineer", salary: 100000, description: "Manage infrastructure and deployments"),
                Job(title: "Data Engineer", salary: 105000, description: "Build data pipelines and warehouses")
            ]
            
        case .mechanical:
            return [
                Job(title: "Mechanical Design Engineer", salary: 75000, description: "Design mechanical components and systems"),
                Job(title: "Manufacturing Engineer", salary: 72000, description: "Optimize production processes"),
                Job(title: "HVAC Engineer", salary: 70000, description: "Design heating and cooling systems"),
                Job(title: "Automotive Engineer", salary: 78000, description: "Develop vehicle systems and components")
            ]
            
        case .electrical:
            return [
                Job(title: "Electrical Design Engineer", salary: 80000, description: "Design electrical circuits and systems"),
                Job(title: "Power Systems Engineer", salary: 82000, description: "Work on power generation and distribution"),
                Job(title: "Controls Engineer", salary: 78000, description: "Design control systems and automation"),
                Job(title: "Hardware Engineer", salary: 85000, description: "Develop electronic hardware components")
            ]
            
        case .civil:
            return [
                Job(title: "Structural Engineer", salary: 72000, description: "Design buildings and structures"),
                Job(title: "Transportation Engineer", salary: 70000, description: "Plan roads, bridges, and transit systems"),
                Job(title: "Geotechnical Engineer", salary: 73000, description: "Analyze soil and foundation conditions"),
                Job(title: "Water Resources Engineer", salary: 71000, description: "Design water management systems")
            ]
            
        case .chemical:
            return [
                Job(title: "Process Engineer", salary: 82000, description: "Design and optimize chemical processes"),
                Job(title: "Plant Engineer", salary: 80000, description: "Manage chemical plant operations"),
                Job(title: "R&D Engineer", salary: 85000, description: "Research new chemical products"),
                Job(title: "Quality Engineer", salary: 75000, description: "Ensure product quality standards")
            ]
            
        case .aerospace:
            return [
                Job(title: "Aerospace Systems Engineer", salary: 85000, description: "Design aircraft and spacecraft systems"),
                Job(title: "Propulsion Engineer", salary: 88000, description: "Develop engines and propulsion systems"),
                Job(title: "Flight Test Engineer", salary: 82000, description: "Test and validate aircraft performance"),
                Job(title: "Avionics Engineer", salary: 83000, description: "Design aircraft electronics systems")
            ]
            
        case .environmental:
            return [
                Job(title: "Environmental Engineer", salary: 68000, description: "Develop environmental protection solutions"),
                Job(title: "Sustainability Engineer", salary: 70000, description: "Implement green technologies"),
                Job(title: "Water Treatment Engineer", salary: 69000, description: "Design water purification systems"),
                Job(title: "Air Quality Engineer", salary: 67000, description: "Monitor and improve air quality")
            ]
            
        case .biomedical:
            return [
                Job(title: "Biomedical Device Engineer", salary: 75000, description: "Design medical devices and equipment"),
                Job(title: "Clinical Engineer", salary: 73000, description: "Support hospital equipment and systems"),
                Job(title: "Biomechanics Engineer", salary: 77000, description: "Study mechanical aspects of biology"),
                Job(title: "Tissue Engineer", salary: 78000, description: "Develop artificial tissues and organs")
            ]
            
        case .industrial:
            return [
                Job(title: "Process Improvement Engineer", salary: 70000, description: "Optimize manufacturing processes"),
                Job(title: "Supply Chain Engineer", salary: 72000, description: "Design and manage supply chains"),
                Job(title: "Quality Engineer", salary: 68000, description: "Ensure production quality standards"),
                Job(title: "Operations Engineer", salary: 71000, description: "Manage facility operations")
            ]
            
        case .petroleum:
            return [
                Job(title: "Drilling Engineer", salary: 90000, description: "Plan and execute drilling operations"),
                Job(title: "Reservoir Engineer", salary: 95000, description: "Analyze oil and gas reservoirs"),
                Job(title: "Production Engineer", salary: 92000, description: "Optimize well production"),
                Job(title: "Completion Engineer", salary: 88000, description: "Design well completion systems")
            ]
            
        case .materials:
            return [
                Job(title: "Materials Scientist", salary: 75000, description: "Research and develop new materials"),
                Job(title: "Metallurgist", salary: 74000, description: "Study metals and alloys"),
                Job(title: "Polymer Engineer", salary: 76000, description: "Work with plastic and polymer materials"),
                Job(title: "Ceramics Engineer", salary: 73000, description: "Develop ceramic materials")
            ]
            
        case .nuclear:
            return [
                Job(title: "Nuclear Engineer", salary: 78000, description: "Design nuclear power systems"),
                Job(title: "Reactor Engineer", salary: 82000, description: "Work on nuclear reactor design"),
                Job(title: "Radiation Safety Engineer", salary: 76000, description: "Ensure radiation safety compliance"),
                Job(title: "Nuclear Fuel Engineer", salary: 80000, description: "Design and manage nuclear fuel systems")
            ]
        }
    }
}

// MARK: - Discipline-Specific Scenarios

struct DisciplineScenarios {
    static func getScenarios(for discipline: EngineeringDiscipline, chapter: LifeChapter) -> [Scenario] {
        let baseScenarios = getBaseScenarios(for: chapter)
        let disciplineSpecific = getDisciplineSpecificScenarios(for: discipline, chapter: chapter)
        return baseScenarios + disciplineSpecific
    }
    
    private static func getBaseScenarios(for chapter: LifeChapter) -> [Scenario] {
        switch chapter {
        case .university:
            return [
                Scenario(title: "Study Group", description: "Join a study group for the upcoming exam?", choices: [
                    "join": Choice(text: "Join the group", performanceChange: 10),
                    "solo": Choice(text: "Study alone", performanceChange: -5)
                ])
            ]
        case .earlyCareer, .midCareer, .seniorCareer:
            return []
        }
    }
    
    private static func getDisciplineSpecificScenarios(for discipline: EngineeringDiscipline, chapter: LifeChapter) -> [Scenario] {
        switch (discipline, chapter) {
        // Software Engineering Scenarios
        case (.software, .earlyCareer):
            return [
                Scenario(title: "Code Review", description: "Your code has critical bugs. Fix immediately or defer?", choices: [
                    "fix": Choice(text: "Fix immediately", performanceChange: 15),
                    "defer": Choice(text: "Defer to later", performanceChange: -10)
                ]),
                Scenario(title: "Tech Stack", description: "Learn a new programming language for the project?", choices: [
                    "learn": Choice(text: "Learn it", performanceChange: 12),
                    "stick": Choice(text: "Stick with current", performanceChange: -5)
                ])
            ]
            
        case (.software, .midCareer):
            return [
                Scenario(title: "Architecture", description: "Propose a microservices architecture redesign?", choices: [
                    "propose": Choice(text: "Propose redesign", performanceChange: 20),
                    "wait": Choice(text: "Wait for directive", performanceChange: -8)
                ])
            ]
            
        // Mechanical Engineering Scenarios
        case (.mechanical, .earlyCareer):
            return [
                Scenario(title: "CAD Design", description: "Prototype failed stress test. Redesign or patch?", choices: [
                    "redesign": Choice(text: "Complete redesign", performanceChange: 15),
                    "patch": Choice(text: "Quick patch", performanceChange: -8)
                ]),
                Scenario(title: "Manufacturing", description: "Suggest cost-saving manufacturing change?", choices: [
                    "suggest": Choice(text: "Propose changes", performanceChange: 12),
                    "follow": Choice(text: "Follow specs", performanceChange: 3)
                ])
            ]
            
        // Electrical Engineering Scenarios
        case (.electrical, .earlyCareer):
            return [
                Scenario(title: "Circuit Debug", description: "PCB has intermittent failures. Deep debug or quick fix?", choices: [
                    "debug": Choice(text: "Deep debug", performanceChange: 15),
                    "quick": Choice(text: "Quick workaround", performanceChange: -7)
                ]),
                Scenario(title: "Power Design", description: "Optimize power consumption for better efficiency?", choices: [
                    "optimize": Choice(text: "Redesign for efficiency", performanceChange: 13),
                    "spec": Choice(text: "Meet minimum spec", performanceChange: 2)
                ])
            ]
            
        // Civil Engineering Scenarios
        case (.civil, .earlyCareer):
            return [
                Scenario(title: "Site Issue", description: "Foundation soil quality concerns. Halt or continue?", choices: [
                    "halt": Choice(text: "Halt construction", performanceChange: 18),
                    "continue": Choice(text: "Continue carefully", performanceChange: -15)
                ]),
                Scenario(title: "Permit Delay", description: "Permits delayed. Wait or find workaround?", choices: [
                    "wait": Choice(text: "Wait for permits", performanceChange: 10),
                    "workaround": Choice(text: "Find workaround", performanceChange: -8)
                ])
            ]
            
        // Aerospace Engineering Scenarios
        case (.aerospace, .earlyCareer):
            return [
                Scenario(title: "Test Flight", description: "Aerodynamic test shows instability. Scrub or proceed?", choices: [
                    "scrub": Choice(text: "Scrub test", performanceChange: 16),
                    "proceed": Choice(text: "Proceed cautiously", performanceChange: -12)
                ]),
                Scenario(title: "Weight Reduction", description: "Component overweight. Redesign or accept?", choices: [
                    "redesign": Choice(text: "Redesign lighter", performanceChange: 14),
                    "accept": Choice(text: "Accept weight", performanceChange: -6)
                ])
            ]
            
        // Environmental Engineering Scenarios
        case (.environmental, .earlyCareer):
            return [
                Scenario(title: "Contamination", description: "Site contamination found. Report or overlook?", choices: [
                    "report": Choice(text: "Report immediately", performanceChange: 20),
                    "overlook": Choice(text: "Overlook it", performanceChange: -25)
                ]),
                Scenario(title: "Green Solution", description: "Propose expensive but sustainable solution?", choices: [
                    "propose": Choice(text: "Propose green option", performanceChange: 15),
                    "cheap": Choice(text: "Cheap solution", performanceChange: -5)
                ])
            ]
            
        // Chemical Engineering Scenarios
        case (.chemical, .earlyCareer):
            return [
                Scenario(title: "Process Safety", description: "Pressure reading abnormal. Shutdown or monitor?", choices: [
                    "shutdown": Choice(text: "Emergency shutdown", performanceChange: 18),
                    "monitor": Choice(text: "Continue monitoring", performanceChange: -14)
                ]),
                Scenario(title: "Yield Optimization", description: "Experiment with process parameters?", choices: [
                    "experiment": Choice(text: "Run experiments", performanceChange: 13),
                    "standard": Choice(text: "Keep standard", performanceChange: 2)
                ])
            ]
            
        default:
            return []
        }
    }
}
