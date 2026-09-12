# Movie

A SwiftUI iOS app for browsing movies, built as a hands-on project for learning native iOS development.

## Features

- Browse trending, popular, and upcoming movies via [The Movie Database (TMDB)](https://www.themoviedb.org/) API
- Movie detail screen with poster, overview, and an embedded YouTube trailer player
- Trailer lookup via the YouTube Data API v3, played inline through a `WKWebView`
- Tab-based navigation (Home, Upcoming, Search, Download)

## Tech stack

- SwiftUI + Swift Concurrency (`async`/`await`)
- `@Observable` view models
- `WKWebView` (via `UIViewRepresentable`) for trailer playback
- `Codable`/`Decodable` models for JSON API responses

## Requirements

- Xcode (recent version, targets iOS 26.5+)
- A [TMDB API Read Access Token](https://developer.themoviedb.org/docs/authentication-application)
- A [YouTube Data API v3 key](https://console.cloud.google.com/apis/library/youtube.googleapis.com)

## Setup

1. Clone the repo and open `movie.xcodeproj` in Xcode.
2. Create `movie/ApiConfig.json` (this file is gitignored and not included in the repo) with your own API credentials:

   ```json
   {
       "baseUrl": "https://api.themoviedb.org",
       "apiKey": "YOUR_TMDB_READ_ACCESS_TOKEN",
       "youTubeBaseUrl": "https://www.youtube-nocookie.com/embed",
       "youTubeApiKey": "YOUR_YOUTUBE_DATA_API_KEY",
       "youTubeSearchBaseUrl": "https://www.googleapis.com/youtube/v3/search"
   }
   ```

3. Build and run on a simulator or device.

## Project structure

| File | Purpose |
|---|---|
| `ApiConfig.swift` / `ApiConfig.json` | Loads API credentials bundled as a JSON resource |
| `dataFetch.swift` | Networking layer — fetches movie lists and trailer video IDs |
| `ViewModel.swift` | `MovieViewModel`, exposing fetch state and movie lists to views |
| `Movie.swift` | `Movie` and TMDB response models |
| `youTubeApiObject.swift` | YouTube search response models |
| `ContentView.swift` / `HomeView.swift` | Tab navigation and home screen |
| `MovieDetailView.swift` | Movie detail screen with trailer playback |
| `YouTubePlayer.swift` | `WKWebView`-backed YouTube embed player |
| `TrendingMoviesHorizontalView.swift` / `UpcomingMoviesView.swift` | Horizontal movie carousels |

## Roadmap

- Search tab (currently a placeholder)
- Download tab (currently a placeholder)
- Top rated / now playing movie lists (already fetched in some flows, not yet surfaced in UI)
