# NPC Engine Architecture

## System Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    ENGINEER LIFE SIMULATOR                       │
│                     (Main Game Loop)                             │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ Player joins company
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                      NPCEngine.swift                             │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  NPCEngine (@MainActor class)                             │  │
│  │  ┌─────────────────────────────────────────────────────┐  │  │
│  │  │ • allCharacters: [NPCCharacter]                     │  │  │
│  │  │ • currentTeam: [NPCCharacter]                       │  │  │
│  │  │ • activeProjects: [TeamProject]                     │  │  │
│  │  │ • relationshipMap: [String: Double]                 │  │  │
│  │  └─────────────────────────────────────────────────────┘  │  │
│  │                                                             │  │
│  │  Methods:                                                   │  │
│  │  • generateNewTeam(size, company) → Creates 4-8 NPCs      │  │
│  │  • interactWithCharacter(char, interaction) → Dialogue    │  │
│  │  • startTeamProject(name, complexity, members) → Project  │  │
│  │  • updateProjectProgress(id, contribution) → Advances     │  │
│  │  • updateAllCharacters() → Yearly updates                 │  │
│  │  • generateRandomEvent(char) → Random encounters          │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
│  Supporting Classes:                                              │
│  ┌─────────────────┐  ┌──────────────────┐                      │
│  │PersonalityEngine│  │ DialogueEngine   │                      │
│  │• generatePerson │  │• generateResponse│                      │
│  │• generateSkills │  │• getTemplates()  │                      │
│  │• getModifier()  │  │• contextual AI   │                      │
│  └─────────────────┘  └──────────────────┘                      │
└─────────────────────────────────────────────────────────────────┘
                         │
                         │ State changes
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                      TeamViews.swift                             │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  TeamDashboardView                                        │  │
│  │  ├── TeamMemberCard × N                                   │  │
│  │  ├── CharacterDetailView (on selection)                   │  │
│  │  │   ├── Status indicators                                │  │
│  │  │   ├── Skills display                                   │  │
│  │  │   ├── Personality traits                               │  │
│  │  │   └── Interaction buttons × 6                          │  │
│  │  └── ProjectsListView                                     │  │
│  │      └── ProjectCard × N                                  │  │
│  │          ├── Progress bar                                 │  │
│  │          ├── Quality/Morale/Team stats                    │  │
│  │          ├── Team avatars                                 │  │
│  │          └── Work button + slider                         │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
│  NewProjectSheet (modal):                                        │
│  ├── Project name input                                          │
│  ├── Complexity picker                                           │
│  ├── Team member selection (multi-select)                        │
│  └── Start button                                                │
└─────────────────────────────────────────────────────────────────┘
                         │
                         │ Game integration
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                GameStoreNPCExtension.swift                       │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Extension GameStore                                      │  │
│  │  • initializeTeamForCompany()                             │  │
│  │  • updateTeamDynamics()                                   │  │
│  │  • getTeamPerformanceBoost() → Int                        │  │
│  │  • calculateProjectBonus() → Int                          │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                         │
                         │ Updates game state
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   ModernGameViews.swift                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  ModernGameView                                           │  │
│  │  ├── ModernSidebar                                        │  │
│  │  │   ├── Player stats                                     │  │
│  │  │   ├── Action buttons                                   │  │
│  │  │   └── Team Dashboard button ← NEW!                    │  │
│  │  ├── TeamDashboardView (conditional)                      │  │
│  │  └── ModernScenarioView / ActivityLog                     │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
│  ModernCompanyView:                                              │
│  • selectCompany() → initializeTeamForCompany()                 │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow: Interaction

```
User clicks "Praise" button
         │
         ▼
CharacterDetailView.performInteraction(.praise)
         │
         ▼
NPCEngine.interactWithCharacter(character, .praise)
         │
         ▼
PersonalityEngine.getInteractionModifier(personality, .praise)
         │
         ▼
DialogueEngine.generateResponse(character, .praised)
         │
         ▼
InteractionResult created {
    success: true,
    message: "Thanks! That means a lot!",
    relationshipChange: +8
}
         │
         ▼
Update character state:
    • relationship += 8
    • mood → happy
    • record interaction
         │
         ▼
GameStore.addLog("Alex: Thanks! That means a lot!")
         │
         ▼
UI updates with animation
```

## Data Flow: Project Progress

```
User clicks "Next Year"
         │
         ▼
GameStore.nextYear()
         │
         ▼
GameStore.updateTeamDynamics(npcEngine)
         │
         ▼
NPCEngine.updateAllCharacters()
    ├── Energy +5 for all
    ├── Mood stabilization
    └── Productivity fluctuation
         │
         ▼
For each active project:
    NPCEngine.updateProjectProgress(projectId, 0)
         │
         ▼
    Calculate team contribution:
        For each team member:
            contribution = (
                (technical + problemSolving) / 2
                × energy / 100
                × mood multiplier
                × (0.5 + relationship / 200)
                × 10
            )
         │
         ▼
    Update project:
        • progress += totalContribution
        • quality ± random(5-10)
        • morale adjustments
        • daysRemaining--
         │
         ▼
    Check completion:
        if progress >= target:
            completeProject()
            • Reward team members
            • Calculate bonus
            • Remove from active
         │
         ▼
GameStore.getTeamPerformanceBoost()
    • Calculate average relationship
    • Return performance modifier
         │
         ▼
GameStore.calculateProjectBonus()
    • Sum completed project bonuses
    • Return total money
         │
         ▼
Apply bonuses to player:
    • performance += boost
    • money += projectBonus
         │
         ▼
UI updates with new stats
```

## Character State Machine

```
┌─────────────┐
│   Created   │
│  (Initial)  │
└──────┬──────┘
       │
       │ Added to team
       ▼
┌─────────────┐     Interactions     ┌─────────────┐
│   Neutral   │◄─────────────────────►│  Building   │
│ Relationship│                       │Relationship │
│   (50)      │     Success!          │   (60-80)   │
└──────┬──────┘                       └──────┬──────┘
       │                                      │
       │ Poor interactions                    │ Great interactions
       ▼                                      ▼
┌─────────────┐                       ┌─────────────┐
│    Poor     │                       │   Strong    │
│ Relationship│                       │   Ally      │
│   (20-40)   │                       │   (80-100)  │
└─────────────┘                       └─────────────┘
       │                                      │
       │ Decline help                         │ Eager to help
       │ Low cooperation                      │ High cooperation
       │ -10% productivity                    │ +15% productivity
```

## Mood Cycle

```
     ┌──────────────────────────────────┐
     │      Natural Stabilization       │
     │      (Each year: 50% chance      │
     │       to return to Neutral)      │
     └──────────────────────────────────┘
              ▲                    │
              │                    ▼
    ┌─────────────────┐   ┌─────────────────┐
    │   Frustrated    │   │    Neutral      │
    │      😤         │◄──┤      😐         │
    │   -30% prod     │   │   Normal prod   │
    └────────┬────────┘   └────────┬────────┘
             │                     │
    Bad      │                     │ Good
    feedback │                     │ interaction
             ▼                     ▼
    ┌─────────────────┐   ┌─────────────────┐
    │    Annoyed      │   │     Happy       │
    │      😒         │   │      🙂         │
    │   -20% prod     │   │   +10% prod     │
    └────────┬────────┘   └────────┬────────┘
             │                     │
             │                     │ Praise
             │                     ▼
             │            ┌─────────────────┐
             │            │   Very Happy    │
             └────────────┤      😄         │
                          │   +20% prod     │
                          └─────────────────┘
```

## Project Lifecycle

```
Start
  │
  │ User creates project
  ▼
┌────────────────┐
│   Planning     │
│ Select members │
│ Set complexity │
└───────┬────────┘
        │
        │ Start project
        ▼
┌────────────────┐
│   In Progress  │◄─────┐
│ Days remaining │      │
│ Quality: 50%   │      │
│ Progress: 0%   │      │
└───────┬────────┘      │
        │               │
        │ Work on it    │
        │ (each year)   │
        ▼               │
┌────────────────┐      │
│   Advancing    │      │
│ Progress += X  │      │
│ Quality ± Y    │      │
│ Morale changes │      │
└───────┬────────┘      │
        │               │
        │ Not complete  │
        │───────────────┘
        │
        │ Progress >= Target
        ▼
┌────────────────┐
│   Complete!    │
│ Award bonus    │
│ Boost relations│
└────────────────┘
```

## Personality Impact Matrix

```
Interaction Type │ Key Personality Trait │ Success Factor
─────────────────┼───────────────────────┼────────────────
Ask for Help     │ Agreeableness         │ Direct
Collaborate      │ Agreeableness +       │ Average
                 │ Extraversion          │
Praise           │ Emotional Stability   │ Impact scale
Critique         │ Emotional Stability × │ Success chance
                 │ Openness              │
Small Talk       │ Extraversion          │ Direct
Request Project  │ Conscientiousness     │ Direct
```

## Integration Points

```
EngineerLifeSimulatorApp.swift
    └── ContentView
        └── ModernGameView
            ├── ModernSidebar
            │   └── "Team Dashboard" button
            │       └── opens TeamDashboardView
            │
            └── TeamDashboardView
                ├── Team list
                ├── Character details
                └── Active projects
```

## Memory Management

```
@MainActor NPCEngine
    ├── @Published allCharacters    [Stored in memory]
    ├── @Published currentTeam      [References to allCharacters]
    ├── @Published activeProjects   [Stored in memory]
    └── @Published interactions     [Limited to 50, auto-trimmed]

Performance:
• O(1) character lookup by ID
• O(n) team updates per year
• O(m) project updates per year
• Memory: ~1KB per character
• Typical: 8 chars × 1KB = 8KB total
```

## Event System

```
Every Year Cycle:
    ├── updateAllCharacters() [Guaranteed]
    │   ├── Energy +5
    │   ├── Mood → Neutral (50% chance)
    │   └── Productivity ± 5
    │
    ├── generateRandomEvent() [10% per character]
    │   ├── Personal News (25% of events)
    │   ├── Technical Breakthrough (25%)
    │   ├── Needs Help (25%)
    │   └── Sharing Idea (25%)
    │
    └── New Project Assignment [20% if < 3 projects]
        └── Auto-select 2-5 team members
```

This architecture provides:
- ✅ Separation of concerns
- ✅ Easy testing (each component isolated)
- ✅ Scalable (add more characters without performance issues)
- ✅ Maintainable (clear data flow)
- ✅ Observable (SwiftUI reactive updates)
- ✅ Type-safe (Swift strong typing)
