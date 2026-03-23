### EPIC F0 — Single User Profile & Core Health Entity
[FOUNDATION – Required for all other Epics]  

[ ] US-F0.1 — First profile creation  

User Story
As a user, I want to create my profile quickly, so the app can generate a realistic health plan for me.  

Actionable Prompt  
Implement a lightweight single-user profile creation flow as the root entity of the app.  

Requirements
  - [x] Required fields:
    - [x] first name or display name
    - [x] primary goal (energy, fitness, weight loss, consistency, stress reduction)
  - [x] Optional fields:
    - [x] age range
    - [x] gender
    - [x] height
    - [x] weight
    - [x] work style (remote, hybrid, on-site)
    - [x] free-text notes
  - [x] Automatic generation of a unique user_id
  - [x] Local storage on device
  - [x] API-ready persistence model for sync with ASP.NET Web API / Postgres later
  - [x] App must work with exactly one active health profile per device in MVP  

UI
  - [x] Onboarding starts with “Your profile”
  - [x] Max 1 screen
  - [x] Fast completion focus: “Set up in under 1 minute”
  - [x] Copy must clearly state: “You can adjust this later”  

Deliver
  - [x] User profile entity / model
  - [x] Create-profile flow in Flutter
  - [x] Persistent local storage
  - [x] Basic “Profile” screen  

Acceptance Criteria
  - [x] User can immediately continue to onboarding after profile creation
  - [x] No daily plan can exist without user_id
  - [x] App remains usable without mandatory login  

Out of Scope
  - [x] Multi-user household accounts
  - [x] Full authentication stack
  - [x] Cloud sync
  - [x] Wearable identity merge

### EPIC F1 — Goal & Constraint Onboarding
[FOUNDATION – Required to generate the first plan]  

[ ] US-F1.1 — Health goal selection  

User Story  
As a user, I want to choose my main health goal, so the app can tailor my plan to what matters most.  

Actionable Prompt  
Implement goal-selection onboarding as the first personalization step after profile creation.  

Requirements
  - [x] User must choose exactly 1 primary goal:
    - [x] feel more energetic
    - [x] get fitter
    - [x] lose weight
    - [x] build consistency
    - [x] reduce stress
  - [x] Store selected goal in profile settings
  - [x] Goal must influence initial plan generation rules  

UI
  - [x] Single-select card interface
  - [x] Clear, plain-language descriptions
  - [x] No medical or technical jargon  

Deliver
  - [x] Goal selection screen
  - [x] Goal enum in domain model
  - [x] Persistence of selected goal  

Acceptance Criteria
  - [x] User cannot continue without selecting 1 primary goal
  - [x] Selected goal is shown later in Profile / Plan screens  

Out of Scope
  - [x] Multiple simultaneous primary goals
  - [x] AI-generated goal recommendations

[ ] US-F1.2 — Weekly availability and constraints  

User Story  
As a user, I want to define my realistic weekly availability and common derailers, so the app creates a plan that fits real life.  

Actionable Prompt  
Implement onboarding inputs for time availability, schedule volatility, and common barriers.  

Requirements
  - [x] Required inputs:
    - [x] exercise availability per week (0–2 / 3–4 / 5+)
    - [x] schedule stability (stable / somewhat variable / highly variable)
    - [x] main derailers (multi-select):
    - [x] stress
    - [x] low energy
    - [x] lack of time
    - [x] poor sleep
    - [x] travel
    - [x] eating out
    - [x] low motivation
  - [x] Optional inputs:
    - [x] preferred workout style
    - [x] preferred walking goal style
  - [x] Results must be stored in onboarding settings
  - [x] Must feed initial plan generator  

UI
  - [x] 2–3 short screens max
  - [x] Large buttons, no typing required
  - [x] Tone: practical and non-judgmental  

Deliver
  - [x] Availability / constraint screens
  - [x] Constraint model
  - [x] Saved onboarding state  

Acceptance Criteria
  - [x] User can complete onboarding in under 3 minutes total
  - [x] Inputs are available to the initial planning engine  

Out of Scope
  - [x] Deep fitness assessment
  - [x] Clinical health intake
  - [x] Medical contraindication logic

[ ] US-F1.3 — Minimum acceptable effort setup  

User Story
As a user, I want to define what a “minimum win” looks like for me, so the system can protect consistency on hard days.  

Actionable Prompt  
Implement onboarding for minimum viable effort thresholds across core health areas.  

Requirements
  - [x] User defines or selects minimum acceptable level for:
    - [x] movement
    - [x] exercise
    - [x] sleep
    - [x] nutrition anchor
  - [x] Use presets if user skips customization
  - [x] Persist values as fallback defaults  

UI
  - [x] Simple sliders or preset cards
  - [x] Copy example: “On a hard day, what still counts?”  

Deliver
  - [x] Minimum effort setup screen
  - [x] Stored fallback baseline data  

Acceptance Criteria
  - [x] App can generate fallback plans immediately after onboarding  
  - [x] Defaults are editable later

Out of Scope
  - [x] Fully personalized AI fallback logic

### EPIC F2 — Initial Plan Generation
[CORE – First value moment]  

[x] US-F2.1 — Generate first weekly health plan  

User Story  
As a user, I want the app to create my first weekly plan automatically, so I don’t have to design a system from scratch.  

Actionable Prompt  
Implement rules-based weekly plan generation based on onboarding inputs.  

Requirements
  - [x] Plan must include:
    - [x] sleep target window
    - [x] weekly workout target
    - [x] daily movement baseline
    - [x] one nutrition anchor
    - [x] one recovery anchor
  - [x] Use rules engine, not AI, for MVP
  - [x] Store generated plan locally
  - [x] Prepare API payload model for backend storage  

UI
  - [x] End of onboarding confirmation screen
  - [x] Show simple summary: “Here’s your starting plan”  

Deliver
  - [x] Plan entity / model
  - [x] Rules-based plan generator in Flutter domain layer or shared service layer
  - [x] First-week plan persistence  

Acceptance Criteria
  - [x] Every onboarded user gets a generated weekly plan
  - [x] Plan reflects availability and constraint inputs
  - [x] User can enter the Today screen immediately after generation  

Out of Scope
  - [x] Dynamic multi-week adaptation
  - [x] Coach-written plans
  - [x] Wearable-based auto-calibration

### EPIC F3 — Today Screen & Daily Execution
[CORE – Main daily product loop]  

[ ] US-F3.1 — Today screen with 3 core actions  

User Story  
As a user, I want to see exactly what matters today, so I can act without overthinking.  

Actionable Prompt  
Implement the Today screen as the primary execution screen of the app.  

Requirements
  - [ ] Show:
    - [ ] current mode (Normal / Busy / Recovery)
    - [ ] 3 core actions for today
    - [ ] 1 optional stretch action
    - [ ] short explanation line
  - [ ] Today screen must derive its content from current weekly plan + mode
  - [ ] Actions must cover relevant areas such as movement, workout, sleep, nutrition  

UI
  - [ ] This is the home screen after onboarding
  - [ ] Strong visual hierarchy
  - [ ] Minimal clutter
  - [ ] Clear CTA buttons for check-in and logging  

Deliver
  - [ ] Today screen in Flutter
  - [ ] Daily action card components
  - [ ] Daily plan view model  

Acceptance Criteria
  - [ ] User can understand today’s plan in under 5 seconds
  - [ ] At least 3 actions are always visible
  - [ ] Optional stretch action is visually secondary  

Out of Scope
  - [ ] Complex analytics on home screen
  - [ ] Newsfeed / content feed

[ ] US-F3.2 — Daily quick check-in  

User Story  
As a user, I want to do a fast daily check-in, so the app can adapt my plan to my actual day.  

Actionable Prompt  
Implement a 3-input daily check-in flow that updates the day’s plan.  

Requirements
  - [ ] Inputs:
    - [ ] energy (low / medium / high)
    - [ ] stress (low / medium / high)
    - [ ] available time (very limited / some / enough)
  - [ ] Check-in takes under 10 seconds
  - [ ] Result must update daily mode and action difficulty  

UI
  - [ ] Bottom sheet or modal
  - [ ] One-tap selections
  - [ ] Immediate feedback after submission  

Deliver
  - [ ] Daily check-in UI
  - [ ] Check-in entity / model
  - [ ] Local persistence of daily state
  - [ ] Rule handler for mode switching  

Acceptance Criteria
  - [ ] User can submit check-in with max 3 taps
  - [ ] Today screen updates instantly after check-in
  - [ ] Check-in history is stored for weekly review  

Out of Scope
  - [ ] Open-ended journaling
  - [ ] Sentiment analysis

### EPIC F4 — Good / Better / Best Completion System
[CORE – Anti all-or-nothing mechanic]  

[ ] US-F4.1 — Multi-level completion logging  

User Story  
As a user, I want to log whether I completed the good, better, or best version of an action, so imperfect progress still counts.  

Actionable Prompt  
Implement a Good / Better / Best completion model for daily action logging.  

Requirements
  - [ ] Each action supports statuses:
    - [ ] missed
    - [ ] good
    - [ ] better
    - [ ] best
  - [ ] Logging must be tap-based and fast
  - [ ] Completion state must roll up into daily and weekly summaries  

UI
  - [ ] Segmented control or 4-state action buttons
  - [ ] “Good” should feel like a valid win, not a failure state  

Deliver
  - [ ] Completion entity / model
  - [ ] Logging interaction on action cards
  - [ ] Daily aggregation logic  

Acceptance Criteria
  - [ ] User can log completion in one interaction
  - [ ] Good-level completion counts toward weekly consistency
  - [ ] Logging works offline  

Out of Scope
  - [ ] Manual metric logging for every action
  - [ ] Detailed workout exercise logs

[ ] US-F4.2 — Default action tiers  

User Story  
As a user, I want every action to have a minimum, solid, and ideal version, so I know what success looks like at different energy levels.  

Actionable Prompt  
Implement default Good / Better / Best tier templates for sleep, movement, workout, and nutrition actions.  

Requirements
  - [ ] Core categories supported:
    - [ ] movement
    - [ ] exercise
    - [ ] sleep
    - [ ] nutrition
  - [ ] Each category must generate 3 tier definitions
  - [ ] Tiers must be editable later in settings  

UI
  - [ ] Tier meanings visible in action detail view
  - [ ] Copy examples should be short and concrete  

Deliver
  - [ ] Tier template model
  - [ ] Tier display component
  - [ ] Rule mapping from plan to tier variants  

Acceptance Criteria
  - [ ] Every daily action shows its expected tier structure
  - [ ] User can distinguish “minimum win” vs “ideal”  

Out of Scope
  - [ ] Fully custom action builder in MVP

### EPIC F5 — Adaptive Modes & Fallback Logic
[CORE – Key differentiator]  

[ ] US-F5.1 — Busy Day mode  

User Story  
As a user, I want the app to switch me into an easier mode on overloaded days, so I can protect momentum instead of dropping off.  

Actionable Prompt  
Implement Busy Day mode that reduces plan intensity while preserving core consistency behaviors.  

Requirements
  - [ ] Busy Day mode can be triggered by:
    - [ ] daily check-in
    - [ ] manual user action
  - [ ] Mode reduces difficulty, not to zero
  - [ ] Must preserve at least:
    - [ ] one movement action
    - [ ] one recovery or sleep action
    - [ ] one simplified nutrition or workout action  

UI
  - [ ] Clear visual state: “Busy Day”
  - [ ] Tone must feel supportive, not punitive
  - [ ] Manual switch visible on Today screen  

Deliver
  - [ ] Busy Day mode state
  - [ ] Daily plan reduction rules
  - [ ] Manual mode toggle  

Acceptance Criteria
  - [ ] User can switch to Busy Day mode in one tap
  - [ ] Today’s actions update immediately
  - [ ] Completion in Busy Day mode still counts toward consistency  

Out of Scope
  - [ ] AI-generated coaching explanations

[ ] US-F5.2 — Recovery Day mode  

User Story  
As a user, I want the app to recognize low-energy or overloaded states, so it can protect basics and avoid burnout.  

Actionable Prompt  
Implement Recovery Day mode focused on reduced load and base-habit protection.  

Requirements
  - [ ] Triggered via low energy / high stress rules or manual selection
  - [ ] Prioritize:
    - [ ] sleep
    - [ ] walking / light movement
    - [ ] simple nutrition anchor
    - [ ] optional recovery practice
  - [ ] Reduce workout pressure automatically  

UI
  - [ ] Recovery-focused visual tone
  - [ ] Clear explanation: “Today is about protecting the basics”  

Deliver
  - [ ] Recovery Day mode logic
  - [ ] Recovery-mode daily action templates  

Acceptance Criteria
  - [ ] Recovery Day can be entered manually or by rule
  - [ ] No full workout is required in Recovery mode
  - [ ] User still sees the day as actionable, not as “off-plan”  

Out of Scope
  - [ ] Medical fatigue scoring
  - [ ] Recovery biometrics integration

### EPIC F6 — Weekly Review & Rebalancing
[CORE – Main retention and adaptation loop]  

[ ] US-F6.1 — Weekly review summary  

User Story  
As a user, I want a simple weekly review, so I can understand what worked, what broke, and what should change.  

Actionable Prompt  
Implement a weekly review screen that summarizes the previous 7 days in clear, human terms.  

Requirements
  - [ ] Review must show:
    - [ ] days with minimum completion
    - [ ] strongest area this week
    - [ ] weakest area this week
    - [ ] energy trend summary
    - [ ] one-sentence weekly assessment
  - [ ] Data source: daily logs + check-ins + mode history  

UI
  - [ ] Calm summary cards
  - [ ] No dense dashboards
  - [ ] Use plain language  

Deliver
  - [ ] Weekly review screen
  - [ ] Weekly aggregation service
  - [ ] Summary data model  

Acceptance Criteria
  - [ ] Weekly review is available after 7 days of data or end-of-week boundary
  - [ ] User understands performance without charts if needed  

Out of Scope
  - [ ] Long-form reflection
  - [ ] Shareable reports

[ ] US-F6.2 — Bottleneck detection  

User Story  
As a user, I want the app to identify the main thing currently hurting my progress, so I don’t try to fix everything at once.  

Actionable Prompt  
Implement simple rules-based bottleneck detection in the weekly review.  

Requirements
  - [ ] Candidate bottlenecks:
    - [ ] sleep inconsistency
    - [ ] workout inconsistency
    - [ ] low movement
    - [ ] high stress
    - [ ] overambitious plan
    - [ ] nutrition inconsistency
  - [ ] App must identify exactly one primary bottleneck per review
  - [ ] Provide one short explanation  

UI
  - [ ] Highlight card in review: “Main focus for next week”
  - [ ] Keep language consumer-friendly  

Deliver
  - [ ] Bottleneck rules engine
  - [ ] Bottleneck summary card  

Acceptance Criteria
  - [ ] Every weekly review produces max 1 primary bottleneck
  - [ ] Bottleneck is based on actual user data, not random messaging  

Out of Scope
  - [ ] ML-based recommendations
  - [ ] Multi-factor clinical scoring

[ ] US-F6.3 — Weekly plan adjustment  

User Story  
As a user, I want the app to adjust next week’s plan based on what actually happened, so the system becomes more realistic over time.  

Actionable Prompt  
Implement weekly plan rebalancing based on consistency and bottleneck results.  

Requirements
  - [ ] Rules may:
    - [ ] reduce workout frequency or duration
    - [ ] prioritize sleep target
    - [ ] simplify daily actions
    - [ ] maintain current plan if stable
  - [ ] User must be able to accept or edit the adjusted plan  

UI
  - [ ] Review ends with “Next week’s plan”
  - [ ] Buttons: Accept / Adjust  

Deliver
  - [ ] Weekly rebalancing service
  - [ ] Plan versioning model
  - [ ] Accept/edit flow  

Acceptance Criteria
  - [ ] Next week’s plan is generated automatically
  - [ ] User can accept with one tap
  - [ ] Adjusted plan is visible in Plan tab  

Out of Scope
  - [ ] Fully autonomous long-term coaching

### EPIC F7 — Progress & Momentum
[CORE – Make progress visible without overtracking]  

[ ] US-F7.1 — Progress screen  

User Story  
As a user, I want a simple progress view, so I can see whether I’m staying more consistent over time.  

Actionable Prompt  
Implement a Progress tab showing the few metrics that matter for routine durability.  

Requirements
  - [ ] Show:
    - [ ] minimum-plan completion days per week
    - [ ] active days
    - [ ] sleep consistency trend
    - [ ] energy trend
    - [ ] current momentum score
  - [ ] Use simple visualizations only  

UI
  - [ ] Minimal charts
  - [ ] Strong focus on trends, not raw data overload  

Deliver
  - [ ] Progress tab
  - [ ] Trend computation logic
  - [ ] Momentum score model  

Acceptance Criteria
  - [ ] User can understand progress in under 30 seconds
  - [ ] Good-level completions are reflected positively
  - [ ] No requirement for perfect streaks  

Out of Scope
  - [ ] Advanced analytics
  - [ ] Export to CSV
  - [ ] Full BI dashboard

### EPIC F8 — Plan Editing & Routine Settings
[CORE – Give user control without complexity]  

[ ] US-F8.1 — Weekly plan editing  

User Story  
As a user, I want to adjust my weekly structure, so the plan fits my reality and preferences.  

Actionable Prompt  
Implement a Plan tab where users can edit core routine settings.  

Requirements
  - [ ] Editable fields:
    - [ ] workout days per week
    - [ ] preferred workout length
    - [ ] movement minimum
    - [ ] sleep target window
    - [ ] nutrition anchor
    - [ ] fallback difficulty
  - [ ] Changes must update future daily plans  

UI
  - [ ] Form-based settings with clear defaults
  - [ ] No more than 1–2 levels deep  

Deliver
  - [ ] Plan tab
  - [ ] Settings forms
  - [ ] Update logic for future plan generation  

Acceptance Criteria
  - [ ] User can change plan inputs without rerunning onboarding
  - [ ] New settings are reflected in next generated days  

Out of Scope
  - [ ] Unlimited habit customization
  - [ ] Advanced periodization

### EPIC F9 — Local Persistence, API, and Offline-First Data Flow
[FOUNDATION – Technical implementation layer]  

[ ] US-F9.1 — Offline-first local data persistence  

User Story  
As a user, I want the app to work reliably without internet, so I can use it anywhere without interruptions.  

Actionable Prompt  
Implement local-first persistence for all core MVP entities in Flutter.  

Requirements
  - [ ] Persist locally:
    - [ ] profile
    - [ ] onboarding settings
    - [ ] weekly plans
    - [ ] daily actions
    - [ ] check-ins
    - [ ] completions
    - [ ] weekly reviews
  - [ ] App must load from local state by default  

UI
  - [ ] No explicit offline UI required in MVP, but app must not break  

Deliver
  - [ ] Local repository layer
  - [ ] Cached entities
  - [ ] App boot hydration  

Acceptance Criteria
  - [ ] Core user flow works fully offline
  - [ ] App restores prior state after app restart  

Out of Scope
  - [ ] Sync conflict handling
  - [ ] Cross-device sync

[ ] US-F9.2 — ASP.NET Web API domain endpoints  

User Story  
As a product team, we want stable backend endpoints for the MVP domain, so we can add sync and admin capabilities safely.  

Actionable Prompt  
Implement ASP.NET Web API endpoints and Postgres persistence for the core health MVP entities.  

Requirements
  - [ ] CRUD-ready endpoints for:
    - [ ] users
    - [ ] onboarding settings
    - [ ] plans
    - [ ] daily check-ins
    - [ ] completions
    - [ ] weekly reviews
  - [ ] Postgres schema must support versioned plans
  - [ ] Use clear DTOs and entity separation
  - [ ] No heavy auth dependency required in MVP 

UI
  - [ ] No consumer UI  

Deliver
  - [ ] ASP.NET Web API project structure
  - [ ] Postgres schema / migrations
  - [ ] DTOs, controllers, services, repositories  

Acceptance Criteria
  - [ ] Backend can persist and retrieve all core entities
  - [ ] API contracts are stable enough for Flutter integration
  - [ ] Local-only mode still possible  

Out of Scope
  - [ ] Enterprise auth
  - [ ] Full RBAC
  - [ ] Billing

### EPIC F10 — Admin Web App
[ADMIN – Internal operations only]  

[ ] US-F10.1 — Admin dashboard for users and plans  

User Story  
As an internal admin, I want to inspect users, onboarding data, and generated plans, so I can validate that the system behaves correctly.  

Actionable Prompt  
Implement a React admin web app for internal inspection of user profiles, plans, and weekly reviews.  

Requirements
  - [ ] Admin can view:
    - [ ] user list
    - [ ] user profile detail
    - [ ] onboarding selections
    - [ ] current plan
    - [ ] recent daily check-ins
    - [ ] weekly review output
  - [ ] Read-only in MVP is sufficient  

UI
  - [ ] Simple table + detail panel layout
  - [ ] Built for internal use, not public polish  

Deliver
  - [ ] React admin app
  - [ ] Route structure
  - [ ] API integration for read-only views  

Acceptance Criteria
  - [ ] Internal team can inspect whether onboarding and plan generation behave as expected  
  - [ ] No consumer-facing exposure  
  
Out of Scope
  - [ ] User-facing web app
  - [ ] Admin editing flows
  - [ ] Marketing website
