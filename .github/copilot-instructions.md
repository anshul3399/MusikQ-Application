# AI Agent Instructions for MusikQ Application

# App Overview
A Flutter application for **filtering and browsing songs** based on multiple criteria.  
Data is sourced from **Google Sheets** via API, cached locally in **SQLite**, and filtered on-device.  
Includes **Google Firebase** authentication and user-based access control.

---

## Core Features
1. **Song Browsing**
   - “Song List” tab displays all songs from the local SQLite DB.
   - Search bar for keyword-based filtering by song title.

2. **Advanced Filtering**
   - “Filter” tab contains multiple filter categories:
     - `Primary Search Label`
     - `Secondary Search Label`
     - `Likeability Index`
     - `Year`
     - `Singers`
     - `Music Director`
     - `Lyricist`
     - `Artist`
     - `Resource Type`
   - Users select filter chips to build a query dynamically.

3. **User Authentication & Authorization**
   - Google Sign-In via Firebase Authentication.
   - User access controlled via `appAccessKey` (must match configuration in Firebase).

4. **Protected Operations via PIN**
   - Clicking app icon (top-left of Home screen) opens a **PIN entry screen** (`pincode_view.dart`).
   - If the PIN matches `accessPin` from Firebase, the user gains access to:
     - Download latest song DB from Google Sheets.
     - Perform operational/configuration actions.

5. **Remote Configuration & Control via Firebase**
   - `applicationConfiguration/AppData` document:
     - `accessPin` *(string)* – required for DB download access.
     - `appAccessKey` *(string)* – must match `userData.appAccessKey` for app use.
     - `deleteDB` *(boolean)* – if true, deletes local DB for all users.
   - `userData/{userId}` document:
     - `appAccessKey` *(string)* – must match app config for access.
     - `email` *(string)*
     - `remotelyDeleteDB` *(boolean)* – deletes local DB for that user.
     - `userPrivilegeLevel` *(int)* – defines permissions.

---

## Tech Stack
- **Frontend/UI:** Flutter
- **Backend:** Firebase Firestore (config & user data), Google Sheets API (song data)
- **Local Storage:** SQLite
- **Auth:** Firebase Authentication (Google Sign-In)

---

## Data Flow
1. **App Launch**
   - App loads random background gradient from `app_bg_gradient_provider`.
   - Authentication wrapper decides whether to show `HomePage` or `SignUpPage`.

2. **Fetching Data**
   - Upon PIN validation:
     - Google Sheets API fetches song data.
     - Data stored locally in SQLite.

3. **Filtering**
   - Filter chips populated from DB attributes.
   - Query built dynamically (`query_processing.dart`) based on selected chips.
   - Results shown in `filtered_result_list.dart`.

4. **Remote Control**
   - Firebase config flags (`deleteDB`, `remotelyDeleteDB`) trigger local DB deletions when needed.

---

## Directory Structure & Key Files
```plaintext
lib/
 ├─ screens/
 │   ├─ authentication/
 │   │   ├─ authentication_wrapper.dart – Listens for auth state changes.
 │   │   └─ sign_in_widget.dart – Google Sign-In UI.
 │   └─ primaryScreens/
 │       ├─ apply_filters.dart – Filter chip UI & selection handling.
 │       ├─ app_access_key_error_widget.dart – Shown if access key mismatch.
 │       ├─ compute_filter_attributes.dart – Builds chip data list.
 │       ├─ empty_database_error_widget.dart – Shown if local DB empty.
 │       ├─ fetchsongs_listview.dart – Song list UI from online sheets DB (currently the view is not being used in application).
 │       ├─ filtered_result_list.dart – Displays query results.
 │       ├─ home.dart – Bottom navigation for “Song List” & “Filter”.
 │       ├─ operations_and_configurations_view.dart – DB download & operations screen.
 │       ├─ pincode_view.dart – PIN entry screen.
 │       └─ song_listview.dart – Song list with search bar.
 ├─ services/
 │   ├─ AppConfigsDatabase/firestore_app_configs_database.dart – Firebase config handling.
 │   ├─ authentication/auth.dart – Google Sign-In logic.
 │   ├─ model/
 │   │   ├─ app_configuration.dart – App config model.
 │   │   ├─ app_user.dart – User model.
 │   │   ├─ filter_chips.dart – Filter chip data model.
 │   │   ├─ songs_database.dart – SQLite DB init, CRUD, query building.
 │   │   └─ song_record.dart – Song DB schema fields.
 │   ├─ providers/app_bg_gradient_provider.dart – Background color logic.
 │   ├─ queryProcessing_LocalDB/query_processing.dart – Search query builder.
 │   └─ sheets_api/sheets_api.dart – Google Sheets integration.
 ├─ shared/
 │   ├─ loading_widget.dart – Loading UI component.
 │   ├─ searchBox_widget.dart – Search box UI component.
 │   └─ theme_constants.dart – Style/theme constants.
 └─ main.dart
```
---

## Current Implementation Status
✅ Google Sheets → SQLite sync  
✅ Firebase Authentication with Google Sign-In  
✅ Bottom navigation UI with two main sections  
✅ Filtering UI & search functionality  
✅ PIN-protected DB operations screen  
✅ Firebase-based access control  

---

## Architecture Overview
This is a Flutter application with a hybrid online/offline architecture:
- **Data Source**: Google Sheets API (primary) → SQLite (local cache)
- **Configuration**: Firebase Firestore
- **Authentication**: Firebase Auth with Google Sign-in
- **Access Control**: Multi-layer (Firebase appAccessKey + PIN protection for admin operations)


### Critical Files & Components
- `lib/services/model/songs_database.dart` - Core SQLite operations and query building
- `lib/services/queryProcessing_LocalDB/query_processing.dart` - Search/filter logic
- `lib/screens/primaryScreens/apply_filters.dart` - Filter UI implementation
- `lib/services/AppConfigsDatabase/firestore_app_configs_database.dart` - Firebase config

## Project-Specific Patterns

### Authentication & Authorization
- Multi-layer auth pattern:
  1. Firebase Authentication (Google Sign-in)
  2. `appAccessKey` validation
  3. PIN protection for admin features
- Example in `lib/screens/authentication/authentication_wrapper.dart`

### Filter Implementation
- Filter chips dynamically populated from DB attributes
- Query building uses custom pattern in `query_processing.dart`
- Filters: Primary/Secondary Labels, Likeability, Year, Artists, etc.



## Integration Points

### Google Sheets Integration
- API calls handled in `lib/services/sheets_api/sheets_api.dart`
- Data synced to SQLite on-demand (PIN-protected operation)

### Firebase Integration
- Config changes (e.g., `deleteDB` flag) trigger immediate local actions
- User document changes affect individual app instances

## Common Tasks & Commands
- Fetching fresh data requires admin PIN entry
- Background gradient randomizes on app launch
- SQLite DB can be remotely purged via Firebase flags

## Error Handling Approach
- Network failures show user-friendly error states
- Empty database conditions have dedicated error widgets
- Access key mismatches show specific error screens


<!--

## Potential Enhancements for AI Copilot to Assist
1. **Offline Mode Improvements**
   - Background sync & incremental updates from Google Sheets.
2. **Advanced Querying**
   - Full-text search, multi-criteria combinations.
3. **Role-Based Access**
   - Leverage `userPrivilegeLevel` for feature restrictions.
4. **UI Enhancements**
   - Animated filter chip selection, better empty-state visuals.
5. **Error Handling**
   - Network failures, API rate limits, SQLite corruption recovery.
6. **Analytics**
   - Track filter usage, search patterns.

-->
