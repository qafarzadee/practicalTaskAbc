# Discover Bahrain

A tourism iOS application that showcases popular places and attractions in Bahrain. Users can browse different categories of places through a carousel, search for specific locations, and view statistics about the listed places.

## Technical Stack

- **Language**: Swift
- **UI Frameworks**: SwiftUI, UIKit
- **Minimum iOS Version**: 16.0
- **Architecture**: MVVM
- **Dependencies**: No third-party libraries

## Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures representing places and gallery pages
- **ViewModels**: Business logic, data transformation, and state management
- **Views/Pages**: UI components organized by screen (Main, Stats)
- **Services**: API layer with protocol-based dependency injection

## Repository Branches

| Branch | Description |
|--------|-------------|
| `main` | Shared data models, services, and resources |
| `feature/swiftui` | SwiftUI implementation of the app |
| `feature/uikit` | UIKit implementation of the app |

## How to Run

1. Clone the repository
2. Open `ABCBankTask.xcodeproj` in Xcode
3. Select the desired branch (`feature/swiftui` or `feature/uikit`)
4. Choose a simulator or connected device (iOS 16.0+)
5. Press `Cmd + R` to build and run

## Project Structure

```
ABCBankTask/
├── Models/          # Data models (PlaceItem, GalleryPage)
├── Services/        # API layer and image loading
├── Resources/       # Constants, JSON mock data
├── Pages/
│   ├── Main/        # Main screen (carousel, search, place list)
│   └── Stats/       # Statistics screen
└── Assets.xcassets  # Images and colors
```

## Possible Improvements

- Replace mock data with a real networking layer and REST API
- Add image caching with disk persistence
- Implement UI tests for critical user flows
- Add localization support for multiple languages
- Implement a detail screen for each place
- Add offline mode with local data storage
