IOS 101 Capstone Project - README Template
===

# Mood Journal

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

Mood Journal is a mobile app that helps users track their daily moods, discover emotional patterns, and build self-awareness through journaling. Users can log their mood states, write journal entries, visualize their emotional trends, and receive personalized insights based on their mood history. 

### App Evaluation

- **Category:** Mental Health & Wellness
- **Mobile:** Uses daily mood logging, graphs, and journaling prompts
- **Story:** Users can track their emotional well-being, recognize patterns, and reflect on their moods
- **Market:** People looking to improve self-awareness and mental well-being
- **Habit:** Users check in daily, log their mood, and review patterns over time
- **Scope:** Start with basic mood logging; expand to insights, AI-generated prompts, and mental wellness tips

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can create an account and log in
* Users record their daily mood using emoji selections
* Users can track energy levels along with mood
* Users can write journal entries to accompany mood recordings
* Users can view weekly and monthly mood trend visualizations
* Users can review past journal entries
  
**Optional Nice-to-have Stories**

* Users can set custom reminders for mood check-ins
* Users can export their mood data and journal entries
* Users can identify correlations between activities and mood states
* Users can add photos to journal entries
* Users can set goals for emotional wellness

### 2. Screen Archetypes

- [ ] Login/Sign Up Screen
* Users create an account or log in
- [x] Daily Log Screen (Home Screen)
* Users record their current mood with emoji selection
* Users track their energy levels
* Users write quick journal entries
- [ ] Insights Screen
* Displays weekly mood trends in chart form
* Shows monthly mood calendar
* Presents pattern analysis and correlations
- [ ] Journal Screen
* Lists all past journal entries with data and mood indicator
* Allows filtering and searching of past entries
- [x] Profile/Setting Screen
* User account information
* Reminder settings
* App preferences
* Data export options
- [ ] Notifications Screen (optional)
* Sends daily notifications based on custom reminders for mood check-ins

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* 📝 Daily Log
* 📊 Insights
* 📔 Journal
* 👤 Profile

**Flow Navigation** (Screen to Screen)

- [ ] Login -> Daily Log Screen
  * User logs in or signs up
  * App loads today's entry if already created or displays new entry form
  * Navigates to the Daily Log Screen for mood recording
- [x] Daily Log -> New Entry Detail
  * User completes quick mood selection
  * User taps to expand for detailed journaling 
  * Navigates to full journal entry screen for extended writing
- [ ] Journal -> Entry Detail
  * User taps on a past journal entry from the list
  * App fetches the complete entry with mood data
  * Navigates to entry detail screen showing full content and context
- [ ] Insights -> Specific Time Period Analysis
  * User taps on a specific week or day in the visualization
  * App generates detailed analysis for the selected period
  * Displays factors correlated with mood during that time
- [x] Profile -> Settings Screens
  * User taps on settings options
  * Navigates to specific settings screens (reminders, themes, etc.)
  * Settings changes apply immediately when toggled


## Wireframes

Below is a rough sketch of the low-fidelity wireframe that I will be using for the creation of this app.
<img src="https://github.com/user-attachments/assets/5ea57b96-190f-4bca-999b-7736bda2a772" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

[This section will be completed in Unit 9]

### Models

#### User
| Property      | Type     | Description |
| ------------- | -------- | ----------- |
| userId        | String   | unique id for the user (default field) |
| username      | String   | user's display name |
| email         | String   | user's email address |
| password      | String   | user's password (securely stored) |
| createdAt     | DateTime | date when user account was created |
| profileImage  | File     | user's profile image (optional) |

#### MoodEntry
| Property      | Type     | Description |
| ------------- | -------- | ----------- |
| entryId       | String   | unique id for the mood entry |
| userId        | String   | id of user who created the entry |
| date          | DateTime | date and time when entry was recorded |
| moodScore     | Number   | numerical value representing mood (1-5) |
| moodEmoji     | String   | emoji representation of mood |
| energyLevel   | Number   | energy level value (1-10) |
| activities    | Array    | array of activity tags associated with entry |
| journalText   | String   | user's journal entry content |
| isEdited      | Boolean  | indicates if entry was edited after creation |
| weatherData   | Object   | weather conditions when entry was created (optional) |
| mediaAttached | Boolean  | indicates if entry has photos attached |

#### Reminder
| Property      | Type     | Description |
| ------------- | -------- | ----------- |
| reminderId    | String   | unique id for the reminder |
| userId        | String   | id of user who created the reminder |
| time          | DateTime | time when reminder should trigger |
| days          | Array    | days of week when reminder is active |
| message       | String   | custom reminder message |
| isActive      | Boolean  | indicates if reminder is turned on |

### Networking

- Login/Register Screen
  - (Create/POST) Create a new user account
  - (Read/GET) Authenticate user credentials
- Daily Log Screen
  - (Create/POST) Create a new mood entry
  - (Read/GET) Query for today's entry if it exists
  - (Update/PUT) Update today's entry if already created
- Journal Screen
  - (Read/GET) Query all mood entries for current user
  - (Delete) Delete an existing entry
- Insights Screen
  - (Read/GET) Query entries for specified time periods
  - (Read/GET) Get activity correlation data
- Profile Screen
  - (Read/GET) Query logged in user data
  - (Update/PUT) Update user profile information
  - (Create/POST) Create new reminder settings
  - (Update/PUT) Update reminder settings
