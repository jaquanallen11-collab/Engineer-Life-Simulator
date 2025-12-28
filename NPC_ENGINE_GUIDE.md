# NPC Character Engine Documentation

## Overview

The NPC Character Engine brings your Engineer Life Simulator to life with realistic, AI-powered coworkers that have unique personalities, skills, moods, and dynamic relationships. Work with your team on projects, build relationships, and experience natural workplace interactions.

## Core Features

### 🎭 Dynamic Character Generation
- **Realistic Personalities**: Each character has unique traits based on the Big Five personality model:
  - **Openness**: Curiosity and creativity
  - **Conscientiousness**: Organization and dependability
  - **Extraversion**: Sociability and energy
  - **Agreeableness**: Cooperation and friendliness
  - **Emotional Stability**: Resilience under pressure

- **Diverse Roles**: Multiple engineering roles with specialized skill sets:
  - Software Engineer
  - Product Manager
  - UX Designer
  - Data Scientist
  - DevOps Engineer
  - QA Engineer

- **Seniority Levels**: Characters range from Junior to Principal level, affecting their skills and experience

### 💬 Natural Interactions
Choose from 6 interaction types that feel authentic:

1. **Ask for Help**: Request assistance from teammates
   - Success depends on character's energy and agreeableness
   - Builds relationships when accepted

2. **Collaborate**: Work together on tasks
   - Success based on teamwork skills and personality
   - Significantly boosts relationships

3. **Praise**: Recognize good work
   - Always successful, always positive
   - Impact depends on emotional stability

4. **Give Feedback**: Provide constructive criticism
   - High emotional stability characters respond well
   - Can damage relationships if poorly received

5. **Small Talk**: Casual conversation
   - Success influenced by extraversion
   - Steady relationship building

6. **Request Project**: Ask them to join a project
   - Depends on relationship level and productivity
   - Essential for team projects

### 📊 Character States
Each character dynamically tracks:

- **Relationship (0-100)**: How much they like working with you
  - 80+: Strong ally, highly productive
  - 60-79: Good relationship, reliable
  - 40-59: Professional, neutral
  - 20-39: Strained, less cooperative
  - <20: Poor relationship, may decline requests

- **Mood**: Affects productivity and interactions
  - Very Happy 😄: +20% productivity
  - Happy 🙂: +10% productivity
  - Neutral 😐: Normal productivity
  - Stressed 😰: -10% productivity
  - Annoyed 😒: -20% productivity
  - Frustrated 😤: -30% productivity

- **Energy (0-100)**: Willingness to help and work
  - Recovers +5 per year
  - Decreases when working on projects
  - Low energy = less likely to help

- **Productivity (0-100)**: Work output quality
  - Fluctuates naturally ±5 per year
  - Affects project progress
  - Influenced by mood and relationships

### 🚀 Team Projects
Collaborate with your team on realistic engineering projects:

**Project Complexity Levels:**
- **Simple**: 5 days, 100 progress target
- **Moderate**: 10 days, 250 progress target
- **Complex**: 20 days, 500 progress target
- **Very Complex**: 30 days, 1000 progress target

**Project Mechanics:**
- Select team members based on skills and relationships
- Track progress, quality, morale, and days remaining
- Player contribution slider (1-30 points per session)
- Team members auto-contribute based on:
  - Technical & problem-solving skills
  - Current energy level
  - Mood productivity multiplier
  - Relationship with you

**Project Outcomes:**
- Completed projects = salary bonus (based on quality)
- High quality (70+) = relationship boost with team
- Team morale affects quality and progress
- Tight deadlines lower morale

### 🎲 Dynamic Events
Random character events create emergent storylines:

- **Personal News**: Characters share life updates (+5 relationship)
- **Technical Breakthrough**: Innovation moments (+3 relationship)
- **Needs Help**: Characters request assistance (opportunity)
- **Sharing Idea**: Collaborative brainstorming (+2 relationship)

Events trigger randomly (10% chance per character per year)

## Integration with Game Systems

### Team Assignment
- Join a company → automatically get a team
- Team size based on company prestige (4-8 members)
- Initial project assigned automatically
- Diverse team with multiple roles

### Yearly Progression
When advancing years:
- All characters recover energy (+5)
- Moods gradually return to neutral
- Productivity fluctuates naturally
- Projects advance automatically
- Random events may trigger
- 20% chance of new project assignment (if <3 active)

### Performance Bonuses
Your team relationships affect your own performance:
- Average relationship 70+: **+15 performance**
- Average relationship 50-69: **+5 performance**
- Average relationship <30: **-10 performance**

### Financial Bonuses
Complete projects to earn extra money:
- Bonus = (Target Progress × Quality%) × 0.5
- High-quality projects = significant earnings
- Complements salary and investments

## AI Dialogue System

The DialogueEngine generates contextual, personality-appropriate responses:

- **Helping**: "Sure, I'd be happy to help! What do you need?"
- **Busy**: "Sorry, I'm swamped right now. Can we talk later?"
- **Collaborating**: "Let's do this! I think we can make something great together."
- **Praised**: "Thanks! That means a lot coming from you."
- **Offended**: "That seems a bit harsh..."
- **Casual**: "Hey! How's your day going?"

Responses vary based on:
- Character personality traits
- Current mood and energy
- Relationship level with player
- Context of interaction

## UI Components

### Team Dashboard
- **Team List Sidebar**: Overview of all team members
  - Avatar, name, role, seniority
  - Relationship heart indicator with color coding
  - Mood emoji and energy bolt
  
- **Character Detail View**: Deep dive into individual characters
  - Full personality profile with 5 traits
  - 6 skill bars (technical, communication, leadership, etc.)
  - Current status (mood, energy, productivity, relationship)
  - 6 interaction buttons with icons

- **Projects List**: Active projects overview
  - Progress bars with percentage
  - Quality, morale, team size stats
  - Team member avatars
  - Contribution slider
  - Work on Project button

### Integration Points
- **Sidebar Button**: "Team Dashboard" (orange neon button)
- **Company Selection**: Team initialized when joining
- **Next Year**: Updates all team dynamics automatically

## Advanced Tips

### Building Strong Relationships
1. **Praise regularly**: Always positive, builds trust
2. **Small talk often**: Low risk, steady gains
3. **Collaborate when possible**: Biggest relationship boost
4. **Match personality**: Extraverts love small talk, conscientious types appreciate feedback
5. **Watch energy levels**: Don't ask for help when they're tired

### Optimizing Team Projects
1. **Choose high-skill members**: Check technical & problem-solving scores
2. **Build relationships first**: 60+ relationship = better contribution
3. **Balance team size**: 3-5 members optimal
4. **Contribute regularly**: Use slider to adjust workload
5. **Monitor morale**: Keep team happy for quality work

### Managing Difficult Characters
1. **Low emotional stability**: Avoid feedback, use praise instead
2. **Low agreeableness**: Build relationship slowly with small talk
3. **Low extraversion**: Less social interaction, focus on work
4. **Low energy**: Let them recover, ask others for help
5. **Poor mood**: Give them space, it'll improve naturally

### Maximizing Bonuses
1. **Focus on quality**: Aim for 70+ quality score
2. **Complete on time**: Late projects reduce morale
3. **Multiple projects**: Run 2-3 concurrent projects
4. **High complexity**: Bigger projects = bigger bonuses
5. **Team synergy**: Good relationships = better output

## Code Architecture

### NPCEngine.swift
- `NPCEngine`: Main @MainActor class managing all characters
- `NPCCharacter`: Character model with all attributes
- `PersonalityEngine`: Generates realistic personalities
- `DialogueEngine`: Contextual response generation
- `TeamProject`: Project model with progress tracking

### TeamViews.swift
- `TeamDashboardView`: Main team interface
- `TeamMemberCard`: Compact member display
- `CharacterDetailView`: Full character profile
- `ProjectCard`: Project management interface
- `NewProjectSheet`: Project creation modal

### GameStoreNPCExtension.swift
- `initializeTeamForCompany()`: Setup new team
- `updateTeamDynamics()`: Yearly updates
- `getTeamPerformanceBoost()`: Calculate performance effect
- `calculateProjectBonus()`: Project completion rewards

## Performance Considerations

- Characters update once per year (not real-time)
- Energy recovery is automatic (+5/year)
- Moods stabilize naturally over time
- Projects auto-progress each year
- Event system uses 10% probability (not every character every year)

## Future Enhancements

Potential additions to the NPC system:

- **Character backstories**: Generated life history
- **Rival dynamics**: Competitive relationships
- **Mentorship system**: Learn from seniors
- **Social network**: Character-to-character relationships
- **Career progression**: Characters get promoted/leave
- **Personality conflicts**: Team drama scenarios
- **Voice lines**: Audio dialogue (with text-to-speech)
- **Character animations**: Animated reactions
- **Meeting system**: Team meetings with group dynamics
- **Email/Slack**: Asynchronous communication
- **Character memories**: Remember past interactions

## Troubleshooting

**Team not appearing?**
- Ensure you've joined a company
- Check that `initializeTeamForCompany()` is called in `ModernCompanyView`

**Characters not updating?**
- Verify `updateTeamDynamics()` is called in Next Year action
- Check NPCEngine is passed to `ModernGameView`

**Projects not progressing?**
- Ensure player contribution is > 0
- Check team members have sufficient energy
- Verify `updateProjectProgress()` is being called

**Interactions not working?**
- Check character energy level (needs >0)
- Verify relationship level for project requests (needs >60)
- Ensure mood isn't affecting response

**Performance issues?**
- Limit active projects to 3
- Team size affects computation (optimal: 4-6 members)
- Character updates are O(n) per year

## Credits

The NPC Engine uses:
- **Big Five Personality Model**: Psychology-based trait system
- **Dynamic State Management**: Real-time character updates
- **Contextual AI**: Personality-driven responses
- **Project Management**: Agile-inspired mechanics
- **Relationship Dynamics**: Emergent social gameplay

Built with SwiftUI, Combine, and Metal 4 for seamless integration with the modern game engine.

---

**Ready to build your team and dominate the engineering world!** 🚀👥💻
