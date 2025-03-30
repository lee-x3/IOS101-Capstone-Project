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
- [ ] Daily Log Screen (Home Screen)
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
- [ ] Profile/Setting Screen
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
- [ ] Daily Log -> New Entry Detail
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
- [ ] Profile -> Settings Screens
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

[Add table of models]

### Networking

- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
