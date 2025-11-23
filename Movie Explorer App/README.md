# 🎬 Movie Explorer App

A modern SwiftUI-based iOS app that provides a comprehensive movie browsing experience with popular movies, detailed information, trailers, search functionality, and favorites management using clean MVVM architecture.

## 📱 Features

### Core Functionality
- 🎭 **Popular Movies Grid**: Browse trending movies in adaptive card layout
- 🔍 **Real-time Search**: Instant movie search with 500ms debouncing
- ❤️ **Favorites Management**: Save/remove movies with immediate UI updates
- 📱 **Tab Navigation**: Seamless switching between Movies and Favorites
- 🎥 **Movie Details**: Full-screen details with backdrop images and comprehensive info
- ▶️ **YouTube Integration**: Direct trailer playback in YouTube app with web fallback
- 📡 **Network Monitoring**: Real-time connectivity alerts and retry mechanisms
- 🔔 **Local Notifications**: Get notified when adding movies to favorites
- 🍞 **Toast Messages**: Bottom-screen error alerts for API/network issues
- 📐 **Adaptive UI**: Responsive design that scales across all device sizes

### Technical Features
- 🏗️ **MVVM Architecture**: Clean separation of concerns with reactive programming
- 💾 **CoreData Persistence**: Local storage for favorites with automatic sync
- 🌐 **Alamofire Networking**: Robust API calls with comprehensive error handling
- 🔄 **Combine Framework**: Reactive search debouncing and state management
- 🎨 **Modern SwiftUI**: Declarative UI with animations and transitions

## 🏗️ Architecture

### Design Pattern: MVVM + Clean Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Views       │───▶│   ViewModels    │───▶│    Services     │
│   (SwiftUI)     │    │   (Business)    │    │   (Network)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│    Models       │    │    Storage      │    │   Utilities     │
│  (Data Layer)   │    │  (CoreData)     │    │ (Extensions)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Key Components
- **Views**: SwiftUI components with adaptive sizing
- **ViewModels**: `@MainActor` classes with `@Published` properties
- **Services**: Network layer with Alamofire and error handling
- **Storage**: CoreData manager with ObservableObject conformance
- **Models**: Codable structs for API responses
- **Utilities**: Extensions for formatting and adaptive sizing

## 📊 Project Statistics

- **Total Files**: 22 Swift files
- **Lines of Code**: 1,823 lines
- **Test Coverage**: 25+ comprehensive unit tests
- **Supported iOS**: 15.0+
- **Architecture**: MVVM with Clean Architecture principles

## 🚀 Setup Instructions

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0+ deployment target
- Swift 5.8+

### 🔑 TMDb API Key Setup
To run the app successfully, you must configure your TMDb API Key.

**1️⃣ Get Your API Key**
- Create a free account on https://www.themoviedb.org/
- Go to Settings → API
- Request a v3 API Key
- Copy your API key

**2️⃣ Configure API Key**
- Open `NetworkService.swift`
- Replace the existing API key with yours:
  ```swift
  private let apiKey = "YOUR_API_KEY_HERE"
  ```

### 📦 Dependencies
- **Alamofire 5.8.0+**: HTTP networking library for API calls
- **SwiftUI**: Native iOS UI framework
- **Combine**: Reactive programming for search debouncing
- **CoreData**: Local data persistence for favorites
- **Foundation**: Core iOS system frameworks
- **Network**: Connectivity monitoring

**Package Management**: All dependencies auto-managed via Swift Package Manager

### 🔨 Build & Run Steps
1. **Clone Repository**:
   ```bash
   git clone <repository-url>
   cd "Movie Explorer App"
   ```

2. **Open Project**:
   ```bash
   open "Movie Explorer App.xcodeproj"
   ```

3. **Configure API Key** (see TMDb setup above)

4. **Verify Dependencies**:
   - Xcode will auto-resolve Swift Package Manager dependencies
   - Alamofire should download automatically

5. **Select Target**:
   - Choose iOS device or simulator (iOS 15.0+)
   - Recommended: iPhone 14 Pro simulator

6. **Build and Run**:
   - Press `Cmd+R` or click the Play button
   - ✅ **Status**: Compiles without errors
   - 🍞 **Toast messages** will appear for any network errors
   
   
⚠️ Important Note: TMDb API on Jio Network

   Some users have reported that the TMDb API may not work on Jio mobile data due to network-level restrictions.
 -- If you face connection errors on a Jio network:

 -- Try switching to Wi-Fi Or Use a different mobile network — Airtel is tested and works stably with the TMDb API.

This is a known issue and not related to the app or API key.

## 🔧 Configuration

### API Configuration
- **Provider**: The Movie Database (TMDb)
- **Base URL**: `https://api.themoviedb.org/3`
- **API Key**: `e4a7b4a5adfd738ad66341ad5d772381`
- **Image Base**: `https://image.tmdb.org/t/p/w500`

### App Permissions
- **Network Access**: Required for API calls
- **Notifications**: Optional for favorite alerts
- **YouTube Scheme**: `youtube://` for direct app opening

## 🧪 Testing

### Test Coverage (25+ Tests)
```bash
# Run all tests
Cmd+U in Xcode

# Test categories:
├── CoreData Tests (4 tests)      # Favorites CRUD operations
├── ViewModel Tests (8 tests)      # Business logic validation
├── Network Tests (5 tests)        # API and URL generation
├── Model Tests (2 tests)          # JSON decoding validation
├── Extension Tests (12 tests)     # Utility function testing
└── UI Tests (Auto-generated)      # Interface testing
```

### Test Categories
- **Unit Tests**: Core business logic and data operations
- **Integration Tests**: ViewModel-Service interactions
- **Utility Tests**: Extension functions and formatting
- **Edge Cases**: Boundary conditions and error scenarios

## 📁 Project Structure

```
Movie Explorer App/ (1,823 lines)
├── 📱 App/
│   ├── Movie_Explorer_AppApp.swift     # App entry point
│   ├── ContentView.swift               # Root view
│   └── Info.plist                      # App configuration
├── 🎨 Views/ (7 files)
│   ├── TabBarView.swift                # Main navigation
│   ├── MoviesListView.swift            # Movies grid with search
│   ├── MovieRowView.swift              # Movie card component
│   ├── MovieDetailView.swift           # Full-screen movie details
│   ├── FavoritesView.swift             # Favorites management
│   ├── NetworkAlertView.swift          # Connectivity alerts
│   └── ToastView.swift                 # Error toast messages
├── 🧠 ViewModels/ (2 files)
│   ├── MoviesViewModel.swift           # Movies list logic
│   └── MovieDetailViewModel.swift      # Movie details logic
├── 📊 Models/
│   └── MovieModels.swift               # API response models
├── 🌐 Services/
│   └── NetworkService.swift            # Alamofire network layer
├── 💾 Storage/
│   ├── CoreDataManager.swift           # Favorites persistence
│   ├── Persistence.swift               # CoreData stack
│   └── Movie_Explorer_App.xcdatamodeld # Data model
├── 🛠️ Utilities/
│   └── Extensions.swift                # Adaptive sizing & formatting
└── 🧪 Tests/ (4 files)
    ├── Movie_Explorer_AppTests.swift   # Core functionality tests
    ├── ViewModelTests.swift            # ViewModel logic tests
    ├── NetworkServiceTests.swift       # Network layer tests
    └── ExtensionTests.swift            # Utility function tests
```

## 🎯 Key Features Implementation

### Adaptive UI System
```swift
// Responsive design across all devices
.padding(16.adaptedWidth)
.frame(height: 250.adaptedHeight)
.cornerRadius(12.adaptedWidth)
```

### Reactive Search
```swift
// 500ms debounced search with Combine
$searchText
    .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
    .sink { searchText in /* API call */ }
```

### Immediate UI Updates
```swift
// Real-time favorites synchronization
@Published var favoritesChanged = false
coreDataManager.$favoritesChanged.sink { _ in
    self.objectWillChange.send()
}
```

## 🔄 Data Flow

1. **User Interaction** → SwiftUI Views
2. **View Events** → ViewModels (@Published properties)
3. **Business Logic** → Services (Network/Storage)
4. **API Calls** → TMDb API via Alamofire
5. **Data Persistence** → CoreData with ObservableObject
6. **UI Updates** → Automatic via Combine publishers

## 🚀 Performance Optimizations

- **LazyVGrid**: Efficient rendering of large movie lists
- **AsyncImage**: Automatic image caching and loading
- **Search Debouncing**: Reduced API calls with 500ms delay
- **Adaptive Sizing**: Consistent UI across device sizes
- **Memory Management**: Proper cleanup with cancellables

## 🔮 Future Enhancements

- [ ] **Offline Mode**: Cache popular movies for offline viewing
- [ ] **User Profiles**: Personal movie recommendations
- [ ] **Social Features**: Share favorites with friends
- [ ] **Advanced Filters**: Genre, year, rating filters
- [ ] **Watchlist**: Separate list for movies to watch
- [ ] **Dark Mode**: Enhanced theme support
- [ ] **iPad Support**: Optimized layout for larger screens

## 📄 License

This project is available for educational and personal use.

## 🤝 Contributing

Contributions are welcome! Please ensure all tests pass and follow the existing code style.

---
