# Quick Start: NPC Character Engine

## What You've Got

Your Engineer Life Simulator now has a **fully-functional AI-powered NPC system** that makes every coworker feel like a real person!

## 🎯 Key Features at a Glance

### Every Character is Unique
- **5 personality traits** (Big Five model)
- **6 skill categories** (technical, communication, leadership, etc.)
- **Dynamic moods** that affect productivity
- **Evolving relationships** based on your actions

### Natural Interactions
Click any team member to:
- 💬 **Ask for Help** - Need assistance? They might help if they like you
- 🤝 **Collaborate** - Work together, boost relationships
- 👍 **Praise** - Always works, always positive
- 📝 **Give Feedback** - Risky but builds respect (if they take it well)
- ☕ **Small Talk** - Safe relationship building
- 📁 **Request Project** - Need them on your team? Ask nicely

### Team Projects
- Start projects from Team Dashboard
- Choose your team members (pick wisely!)
- Contribute your own work with the slider
- Team auto-contributes based on skills, energy, mood, and their relationship with you
- Complete projects for **bonus money!**

## 🚀 How to Use It

### 1. Join a Company
When you select a company, you'll automatically get a team of 4-8 coworkers based on company prestige.

### 2. Access Team Dashboard
In the game view, look for the orange **"Team Dashboard"** button in the left sidebar.

### 3. Interact with Team
- Click any team member card to see their full profile
- Use the 6 interaction buttons
- Watch relationship numbers go up (or down!)

### 4. Start Projects
- Click "New Project" in the Team Dashboard
- Name your project
- Choose complexity (Simple to Very Complex)
- Select team members to work with
- Click "Work on Project" to contribute

### 5. Advance Time
When you click "Next Year":
- All characters recover energy
- Moods stabilize
- Projects progress automatically
- Random events may occur
- You get performance bonuses based on team relationships!

## 💡 Pro Tips

### Building Relationships Fast
1. **Praise often** - No risk, steady gains
2. **Collaborate when you can** - Biggest boost
3. **Small talk with introverts** - They appreciate it
4. **Give feedback to stable characters** - Check their Emotional Stability trait first

### Project Success
1. **Pick high-skill members** - Check their Technical & Problem Solving bars
2. **Choose people who like you** - 60+ relationship works best
3. **Keep team size 3-5** - Sweet spot for efficiency
4. **Contribute 10-20 points** - Balance your effort
5. **Watch the morale** - Happy team = quality work

### Performance Optimization
Your team affects YOUR performance:
- **Great relationships (70+ avg)**: +15 performance boost
- **Good relationships (50-69)**: +5 performance boost
- **Poor relationships (<30)**: -10 performance penalty

Good relationships = better performance = faster promotions!

## 📊 Understanding the Stats

### Character Stats
- **Relationship (0-100)**: How much they like you
  - 80+: Best friends, super helpful
  - 60-79: Good colleagues
  - 40-59: Professional, neutral
  - 20-39: Strained
  - <20: They don't like you

- **Energy (0-100)**: Willingness to work/help
  - Recovers +5 every year
  - Drops when working
  - Below 50 = less likely to help

- **Mood**: Affects productivity multiplier
  - Very Happy 😄: +20%
  - Happy 🙂: +10%
  - Neutral 😐: 0%
  - Stressed 😰: -10%
  - Annoyed 😒: -20%
  - Frustrated 😤: -30%

### Project Stats
- **Progress**: How close to completion (%)
- **Quality**: How good the work is (affects bonus!)
- **Morale**: Team happiness (affects quality)
- **Days Remaining**: Time left before deadline

## 🎲 Random Events

Every year, each character has a 10% chance of generating an event:
- 📢 **Personal News**: They share something exciting (+5 relationship)
- 💡 **Technical Breakthrough**: Innovation moment (+3 relationship)
- 🆘 **Needs Help**: They need your assistance (opportunity!)
- 💭 **Sharing Idea**: Wants to brainstorm with you (+2 relationship)

These create natural storytelling moments!

## 🔧 Files Added

### Core Engine
- **NPCEngine.swift**: Main character engine
  - `NPCEngine` class: Manages all characters
  - `NPCCharacter` struct: Character data model
  - `PersonalityEngine`: Generates personalities
  - `DialogueEngine`: AI-powered responses
  - `TeamProject`: Project management

### UI Components
- **TeamViews.swift**: All team-related views
  - `TeamDashboardView`: Main interface
  - `CharacterDetailView`: Character profiles
  - `ProjectCard`: Project management UI
  - `NewProjectSheet`: Create new projects

### Integration
- **GameStoreNPCExtension.swift**: Connects NPC system to game
  - Team initialization
  - Yearly updates
  - Performance calculations
  - Bonus calculations

### Documentation
- **NPC_ENGINE_GUIDE.md**: Full technical documentation
- **NPC_QUICKSTART.md**: This file!

## 🎮 Example Gameplay Flow

1. **Graduate** from university
2. **Join Apple** (gets team of 8 due to high prestige)
3. **Open Team Dashboard**
4. **Click on "Alex Chen"** (Software Engineer)
5. See they have high Extraversion → **Small Talk** works great
6. Relationship goes from 50 → 55
7. **Collaborate** on a task
8. Relationship jumps to 65
9. **Start a new project**: "iOS App Feature"
10. Select Alex + 2 others with high skills
11. **Work on project**: Set slider to 15
12. **Next Year**: Project progresses, team contributes automatically
13. **Complete project**: Get $5,000 bonus!
14. **Next Year** again: +15 performance from good team relationships
15. **Get promoted** earlier thanks to performance boost!

## 🐛 Troubleshooting

**Q: Team Dashboard button not showing?**
A: You need to join a company first. The button only appears after you have a team.

**Q: Characters won't help me?**
A: Check their energy level and your relationship. They need energy >50 and generally prefer helping people they like (relationship >50).

**Q: Project not progressing?**
A: Make sure you're clicking "Work on Project" and advancing years. Projects need both player contribution and time.

**Q: Relationships not improving?**
A: Match interactions to personality! Check their traits:
- High Extraversion → loves Small Talk
- High Agreeableness → helps often
- High Emotional Stability → accepts feedback well
- High Conscientiousness → respects project requests
- High Openness → enjoys collaboration

## 🎨 Visual Design

The NPC system uses your game's modern aesthetic:
- **Glassmorphic cards** for character profiles
- **Neon buttons** for interactions
- **Color-coded indicators** (green = good, red = bad)
- **Emoji avatars** for quick recognition
- **Smooth animations** for state changes
- **Purple/orange theme** for team features

## 🚀 What Makes This Special

Unlike simple NPC systems, yours features:
1. **Personality-driven AI**: Responses change based on Big Five traits
2. **Dynamic relationships**: Not scripted, emergent from interactions
3. **Real consequences**: Team affects YOUR performance and money
4. **Natural progression**: Moods and energy change realistically
5. **Strategic depth**: Team composition matters for project success
6. **Emergent stories**: Random events create unique narratives
7. **BitLife authenticity**: Feels like working at a real company

## Next Steps

### To Start Using:
1. Copy models from original code to `GameModels.swift`
2. Add all files to your Xcode project
3. Build and run
4. Play through university
5. Join a company
6. Click "Team Dashboard" - you're in!

### To Customize:
- Edit `NPCNames.firstNames` and `lastNames` for different names
- Modify `getTemplates()` in `DialogueEngine` for new dialogue
- Adjust relationship thresholds in `interactWithCharacter()`
- Change project complexity values in `ProjectComplexity`
- Add new interaction types to `InteractionType` enum

## 🎯 Summary

You now have an **industry-leading NPC system** that makes your game feel alive. Every coworker is unique, relationships matter, and teamwork pays off. This isn't just decoration - it's core gameplay that affects your career trajectory!

**Your game went from solo career simulator to collaborative workplace experience.** 🌟

Enjoy working with your new AI-powered team! 👥💼🚀
