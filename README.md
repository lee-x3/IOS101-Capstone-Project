IOS 101 Capstone Project - README Template
===

# Personal Anime Tracker

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

Anime Tracker is a mobile app that helps anime fans track their watch progress, discover new shows, and organize their watchlists. Users can log watched episodes, get personalized recommendations, and receive notifications for new episodes releases.

### App Evaluation

- **Category:** Entertainment
- **Mobile:** Uses camera, mobile notifications for new episodes and suggestions
- **Story:** Allows user to discover, track, and manage anime they're wsatching or are interested in
- **Market:** Anime fans who want to organize their watching experience
- **Habit:** Users can check in after watching episodes, regularly search for new shoes. Users can explore endless anime options
- **Scope:** Start with core tracking feautres, expandable to social sharing and recommendations

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can create an account and log in
* Users can search for anime using an API
* Users can add anime to their watchlist
* Users can mark episodes as watched
* Users can get recommendations based on their watch history
* Userrs can receive notifications when new episodes are released
  
**Optional Nice-to-have Stories**

* Users can rate and review anime
* Users can follow friends and see what they're watching
* Users can create custom anime lists (e.g., "Want to Watch," "Favorites")
* Users can get personalized anime suggestions based on their ratings
* Users can set reminders for upcoming anime episodes

### 2. Screen Archetypes

- [ ] Login/Sign Up Screen
* Users create an account or log in
- [ ] Home Screen (Watchlist & Anime Feed)
* Displays the user's "Currently Watching" anime and progress
* Shows recommended anime based on preferences
- [ ] Search Screen
* Users can search for anime using an API
* Displays anime detials when selected
- [ ] Anime Detail Screen
* Shoe anime description episode list, and ratings
* Allows users to add the anime to their watchlist
- [ ] Episode Tracker Screen
* Displays episode list
* Users can mark episodes as watched
- [ ] Notifications Screen (optional)
* Shows alearts for new episode releases and recommendations

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* 📺 Home (Watchlist & Recommendations)
* 🔍 Search
* 🔔 Notifications
* ⚙️ Profile

**Flow Navigation** (Screen to Screen)

- [ ] Login -> Home Screen
* User logs in or signs up
* App retrieves the user's watchlist and recommendations
* Navigates to the Home Screen displaying tracked anime
- [ ] Home -> Search -> Anime Details
* User taps on the Search tab
* User enters an anime name in the search bar
* App fetches search results using an API
* User selects and anime from the search results
* Navigates to the Anime Details screen
- [ ] Anime Details -> Add to Watchlist -> Episode Tracker
* User taps "Add to Watchlist"
* Anime is added to the user's tracked list
* Button updates to "Tracking"
* User taps "View Episodes" to navigate to the Episode Tracker screen
- [ ] Episode Tracker -> Mark Episode as Watched -> Update Progress
* User taps an episode checkbox to mark it as watched
* App updates watch progress in the database
* Progress bar updates dynamically
* Navigates back to the Home Screen if the user exits
- [ ] Notifcations -> Anime Details
* User receives a notifcation about a new episode
* User taps the notification
* Navigates to the Anime Details screen to view episode information

## Wireframes

[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

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
