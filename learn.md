# Swift/iOS for Flutter Developers — Learning Guide

This document teaches Swift and SwiftUI concepts using **your own movie app code** as examples. Every snippet here is real code from this project.

---

## Table of Contents

1. [App Entry Point](#1-app-entry-point)
2. [Structs vs Classes](#2-structs-vs-classes)
3. [Protocols — Swift's "Interfaces"](#3-protocols--swifts-interfaces)
4. [Optionals — Swift's Null Safety](#4-optionals--swifts-null-safety)
5. [SwiftUI Views vs Flutter Widgets](#5-swiftui-views-vs-flutter-widgets)
6. [Layout: Stacks, ScrollView, LazyStack](#6-layout-stacks-scrollview-lazystack)
7. [State Management: @State and @Observable](#7-state-management-state-and-observable)
8. [Enums with Associated Values](#8-enums-with-associated-values)
9. [Error Handling: throw / try / catch](#9-error-handling-throw--try--catch)
10. [async / await and Task](#10-async--await-and-task)
11. [Result Type](#11-result-type)
12. [Extensions — Adding Methods to Existing Types](#12-extensions--adding-methods-to-existing-types)
13. [Guard Statement — Early Exit](#13-guard-statement--early-exit)
14. [inout Parameters — Pass by Reference](#14-inout-parameters--pass-by-reference)
15. [Static Members and Computed Properties](#15-static-members-and-computed-properties)
16. [JSON Decoding — No Code Generation Needed](#16-json-decoding--no-code-generation-needed)
17. [Networking with URLSession](#17-networking-with-urlsession)
18. [SwiftUI Modifiers — The Decorator Pattern](#18-swiftui-modifiers--the-decorator-pattern)
19. [ForEach — Rendering Lists](#19-foreach--rendering-lists)
20. [AsyncImage — Network Images](#20-asyncimage--network-images)
21. [TabView — Bottom Navigation](#21-tabview--bottom-navigation)
22. [Common Patterns & Gotchas](#22-common-patterns--gotchas)

---

## 1. App Entry Point

### Flutter
```dart
void main() {
  runApp(const MyApp());
}
```

### Swift (movieApp.swift)
```swift
@main
struct movieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

**Key differences:**
- `@main` is an attribute (annotation) that marks the entry point. No separate `main()` function.
- `App` is a protocol (like an interface). Your struct conforms to it.
- `Scene` and `WindowGroup` are SwiftUI concepts for multi-window support on iPad/Mac. On iPhone, `WindowGroup` just shows one window.
- `body` is a **computed property**, not a method — it has no `()` and no `return` keyword (Swift infers the return for single-expression bodies).

---

## 2. Structs vs Classes

In Flutter/Dart, you use classes for almost everything. **In Swift, structs are preferred** for most things.

### Your code uses structs for:
- Data models: `Title`, `ApiObject`, `ApiConfig`
- Views: every SwiftUI view (`HomeView`, `ContentView`, etc.)
- Utilities: `DataFetcher`, `Constans`

### Why structs?
| | Dart Class | Swift Struct |
|---|---|---|
| Passed by | Reference | **Value** (copied) |
| Inheritance | Yes | No |
| Mutability | Mutable by default | Immutable by default |
| Memory | Heap | Stack (usually faster) |

```swift
// Title.swift — a struct as a data model (like a Dart class but value-type)
struct Title : Decodable, Identifiable {
    var id : Int?
    var title : String?
    var poster_path : String?
}
```

This is like a Dart class but you cannot subclass it. Use classes when you need inheritance or reference semantics (like `TitleViewModel`).

---

## 3. Protocols — Swift's "Interfaces"

Protocols are like `abstract class` / interfaces in Dart but more powerful.

```swift
// Title conforms to two protocols at once
struct Title : Decodable, Identifiable { ... }

// ApiConfig conforms to Decodable
struct ApiConfig : Decodable { ... }

// Error types conform to Error and LocalizedError
enum NetworkError: Error, LocalizedError { ... }
```

**Common protocols you'll see:**
| Protocol | What it means | Flutter equivalent |
|---|---|---|
| `Decodable` | Can be created from JSON | `json_serializable` / `fromJson()` |
| `Identifiable` | Has a unique `id` property | Needed for `ForEach`, like a `key` in Flutter |
| `View` | Is a SwiftUI view | `Widget` |
| `Error` | Can be thrown as an error | `Exception` |
| `LocalizedError` | Error with human-readable message | Custom exception with `toString()` |

---

## 4. Optionals — Swift's Null Safety

Swift has optionals like Dart's null safety, but the syntax differs.

```swift
// In Title.swift — every field is optional (can be nil/null)
var id : Int?          // Int? means "Int or nil"
var title : String?    // String? means "String or nil"
```

### Unwrapping optionals

#### `if let` — safely unwrap in a block
```swift
// ContentView.swift
if let config = ApiConfig.shared {
    print(config.apiKey)   // config is non-optional inside here
}
```
Flutter/Dart equivalent: `if (config != null) { ... }`

#### `guard let` — unwrap or exit early
```swift
// dataFetch.swift
guard let apiKey = apiKey else {
    throw NetworkError.invalidURL   // exits the function if nil
}
// apiKey is non-optional below this line
```
There's no direct Dart equivalent — it's like `if (x == null) return;` but it also unwraps in one step.

#### `??` — nil coalescing (same as Dart!)
```swift
// TrendingMoviesHorizontalView.swift
URL(string: title.poster_path ?? "")
// If poster_path is nil, use "" instead
```

#### `try?` — convert throw to optional
```swift
// ApiConfig.swift
let data = try? Data(contentsOf: url)
// If this throws, data is nil instead of crashing
```

---

## 5. SwiftUI Views vs Flutter Widgets

| Concept | Flutter | SwiftUI |
|---|---|---|
| Base type | `Widget` (class) | `View` (protocol on a struct) |
| UI definition | `build()` method | `body` computed property |
| Stateless widget | `StatelessWidget` | Any `View` struct without `@State` |
| Stateful widget | `StatefulWidget + State` | `View` struct with `@State` properties |

```swift
// HomeView.swift — a stateless-like view
struct HomeView: View {
    var image = Constans.imageBaseURL

    var body: some View {   // "some View" = opaque return type, Swift figures out the type
        ScrollView(.vertical) {
            // ...
        }
    }
}
```

**`some View`** — the `some` keyword means "some specific type that conforms to View, but I won't tell you exactly which one." This is Swift's **opaque type** feature. You use it because `body` always returns the same concrete type, Swift just hides the complexity.

---

## 6. Layout: Stacks, ScrollView, LazyStack

| Flutter | SwiftUI |
|---|---|
| `Column` | `VStack` |
| `Row` | `HStack` |
| `Stack` (overlay) | `ZStack` |
| `ListView` | `ScrollView` + `LazyVStack` |
| `ListView` horizontal | `ScrollView(.horizontal)` + `LazyHStack` |

```swift
// HomeView.swift
ScrollView(.vertical, showsIndicators: false) {
    LazyVStack() {             // like ListView — only renders visible items
        AsyncImage(...)        // header image
        HStack() {             // like Row
            Button() { } label: { Text("Play") }
            Button() { } label: { Text("Download") }
        }
    }
    TrendingMoviesHorizontalView(header: "Trending")
}
.padding(.horizontal, 10)     // modifiers applied AFTER the closing brace
```

```swift
// TrendingMoviesHorizontalView.swift
ScrollView(.horizontal, showsIndicators: false) {
    LazyHStack(spacing: 10) {   // like ListView with horizontal scroll
        ForEach(viewModel.trendingMoviesList) { title in
            // each item
        }
    }
}
```

**`Lazy` stacks** only render what's visible — always use them inside `ScrollView` for long lists, just like Flutter's `ListView.builder`.

---

## 7. State Management: @State and @Observable

### `@State` — local component state

```swift
// TrendingMoviesHorizontalView.swift
@State private var viewModel = TitleViewModel()
```

- `@State` is a **property wrapper** (like `@override` but it wraps the value with observation logic).
- When a `@State` variable changes, SwiftUI **automatically rebuilds** the view — just like `setState()` in Flutter, but you don't call anything.
- `private` means only this view can access it.

Flutter equivalent:
```dart
late TitleViewModel viewModel;  // but you'd need setState() or a ChangeNotifier
```

### `@Observable` — observable class (like ChangeNotifier)

```swift
// ViewModel.swift
@Observable
class TitleViewModel {
    var trendingMoviesList: [Title] = []
    var popularMoviesList: [Title] = []
    // ...
}
```

`@Observable` is a **macro** (new in Swift 5.9). It automatically makes all `var` properties observable. Any SwiftUI view that reads these properties will re-render when they change.

Flutter equivalent: `class TitleViewModel extends ChangeNotifier { ... }`

**The key difference from Flutter:** You don't need `notifyListeners()`. Any assignment to a property of an `@Observable` class automatically notifies SwiftUI.

### `private(set)` — read-only from outside

```swift
private(set) var homeState : fetchState = .notStarted
```

Outside the class, you can read `homeState` but not write to it. Flutter doesn't have this built in — you'd use a private field with a getter.

---

## 8. Enums with Associated Values

Swift enums are far more powerful than Dart enums. They can carry data.

```swift
// ViewModel.swift
enum fetchState {
    case notStarted
    case loading
    case success
    case failed(underLyingError: Error)   // carries an Error value!
}
```

```swift
// Error.swift
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(underlyingError: Error)
    case invalidResponse
}

enum ApiConFigError: Error, LocalizedError {
    case fileNotFound
    case dataLoadingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
}
```

### Pattern matching with `switch`

```swift
// ViewModel.swift
switch trendingMovies {
case .success(let movies):        // extract the associated value
    trendingMoviesList = movies
case .failure(let error):
    homeState = .failed(underLyingError: error)
}
```

Dart's switch on enums can't extract associated data — you'd need sealed classes for this.

### Enum + `var` for computed properties

```swift
// Error.swift — LocalizedError requires an errorDescription property
var errorDescription: String? {
    switch self {
    case .fileNotFound:
        return "File not found"
    case .dataLoadingFailed(underlyingError: let error):
        return "Failed to load data: \(error.localizedDescription)"
    }
}
```

---

## 9. Error Handling: throw / try / catch

Very similar to Dart, but with different keywords in places.

```swift
// dataFetch.swift
func fetchMovies(for media: String, by type: String) async throws -> Result<[Title], Error> {
    guard let apiKey = apiKey else {
        throw NetworkError.invalidURL   // throw an enum case
    }
    // ...
}
```

| Dart | Swift |
|---|---|
| `throws` on return type | `throws` before `->` return type |
| `throw MyException()` | `throw NetworkError.invalidURL` |
| `try expression` | `try expression` |
| `try? expression` | `try? expression` (returns optional) |
| `try! expression` | `try! expression` (crashes if throws) |
| `catch (e) { }` | `catch { }` (error bound to `error`) |
| `catch (MyException e) { }` | `catch let e as MyException { }` |

```swift
// ApiConfig.swift — catching specific error types
do {
    let data = try? Data(contentsOf: url)
    let config = try! JSONDecoder().decode(ApiConfig.self, from: data!)
    return config
} catch let error as DecodingError {
    throw ApiConFigError.decodingFailed(underlyingError: error)
} catch {
    throw ApiConFigError.dataLoadingFailed(underlyingError: error)
}
```

> **Note:** `try!` and `try?` in `ApiConfig.swift` are shortcuts the project uses but aren't best practice — `try!` crashes if it throws, `try?` silently swallows errors. In production code, prefer plain `try` inside a `do/catch`.

---

## 10. async / await and Task

Swift uses `async/await` just like Dart, but launching async work from a synchronous context requires a `Task {}`.

```swift
// ViewModel.swift
func fetchMovies() {              // NOT marked async — called from .onAppear
    Task {                        // like Future(() => ...) in Dart
        homeState = .loading
        do {
            let trendingMovies = try await dataFetcher.fetchMovies(for: "movie", by: "trending")
            // ...
        } catch {
            homeState = .failed(underLyingError: error)
        }
    }
}
```

```swift
// dataFetch.swift
func fetchMovies(for media: String, by type: String) async throws -> Result<[Title], Error> {
    let (data, _) = try await URLSession.shared.data(for: request)
    // ...
}
```

**`Task {}`** is like Dart's `Future(() { ... })` or `compute()`. It runs async code from a sync context. SwiftUI's `.onAppear` is synchronous, so you need `Task` to kick off async work.

```swift
// TrendingMoviesHorizontalView.swift
.onAppear { viewModel.fetchMovies() }   // onAppear is like initState()
```

---

## 11. Result Type

Swift has a built-in `Result<Success, Failure>` type — like a discriminated union for success/failure.

```swift
// dataFetch.swift
func fetchMovies(...) async throws -> Result<[Title], Error> {
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        var titles = try JSONDecoder().decode(ApiObject.self, from: data).results
        return .success(titles)       // wrap in .success
    } catch {
        return .failure(error)        // wrap in .failure
    }
}
```

```swift
// ViewModel.swift — consuming the Result
let trendingMovies = try await dataFetcher.fetchMovies(for: "movie", by: "trending")
switch trendingMovies {
case .success(let movies):
    trendingMoviesList = movies
case .failure(let error):
    homeState = .failed(underLyingError: error)
}
```

Dart doesn't have a built-in `Result` type — packages like `dartz` or `fpdart` add this pattern.

---

## 12. Extensions — Adding Methods to Existing Types

Extensions let you add methods/properties to **any** existing type, including built-in ones. Flutter/Dart has this too with `extension`.

```swift
// constants.swift — extending SwiftUI's Text type
extension Text {
    func elevatedButton() -> some View {
        self
            .frame(width: 100, height: 30)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }

    func outlinedButton() -> some View {
        self
            .frame(width: 100, height: 30)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.buttonBorder, lineWidth: 2)
            }
    }
}
```

```swift
// HomeView.swift — using the extension as if it's a built-in modifier
Text("Play").elevatedButton()
Text("Download").outlinedButton()
```

This is the SwiftUI way to create **reusable button styles**. Flutter equivalent: a custom `ButtonStyle` or a wrapper widget.

---

## 13. Guard Statement — Early Exit

`guard` is a Swift-specific construct for early exits. Think of it as an "assert this is true or bail out" statement.

```swift
// dataFetch.swift
func fetchMovies(...) async throws -> Result<[Title], Error> {
    guard let apiKey = apiKey else {
        throw NetworkError.invalidURL   // exits here if apiKey is nil
    }

    guard let url = try buildUrl(media: media, type: type) else {
        throw NetworkError.invalidURL   // exits here if url is nil
    }

    // At this point, both apiKey and url are guaranteed non-nil
    var request = URLRequest(url: url)
    // ...
}
```

**Why `guard` instead of `if`?**
- After `guard let x = ...`, `x` is available in the **rest of the function** (not just inside a block like `if let`).
- It keeps the "happy path" at the left margin — errors/exits are handled first.
- Dart equivalent: multiple `if (x == null) return;` checks at the top of a method.

---

## 14. inout Parameters — Pass by Reference

Normally Swift passes structs by value (a copy). `inout` lets you pass a reference so the function can modify the original.

```swift
// constants.swift
static func addPosterPath(to title: inout [Title]) {
    for i in title.indices {
        if let posterPath = title[i].poster_path {
            title[i].poster_path = "\(Constans.posterPathInitUrl)/\(posterPath)"
        }
    }
}
```

```swift
// dataFetch.swift — called with & prefix to signal "pass by reference"
var titles = try JSONDecoder().decode(ApiObject.self, from: data).results
Constans.addPosterPath(to: &titles)   // & means "pass as inout"
```

Dart doesn't have `inout` — since classes are reference types in Dart, you just pass objects. For value types in Dart (like `int`), you'd return the modified value instead.

---

## 15. Static Members and Computed Properties

```swift
// constants.swift
struct Constans {
    static let homeString = "Home"       // constant (like static const in Dart)
    static let imageBaseURL = "https://..." // another constant

    static func addPosterPath(to title: inout [Title]) { ... }  // static method
}
```

```swift
// ApiConfig.swift — static computed property (lazy singleton)
static let shared: ApiConfig? = {
    do {
        return try ApiConfig.laodConfig()
    } catch {
        print("failed to load config \(error.localizedDescription)")
        return nil
    }
}()   // the () at the end immediately calls this closure to produce the value
```

This `static let shared = { ... }()` pattern is the Swift singleton. The closure runs **once** when first accessed and caches the result. Dart equivalent:
```dart
static final ApiConfig? shared = _loadConfig();
```

**Computed property vs stored property:**
```swift
// This is a STORED property (stores a value)
var image = Constans.imageBaseURL

// This is a COMPUTED property (runs code each time)
var body: some View {
    Text("Hello")   // re-computed when SwiftUI needs it
}
```

---

## 16. JSON Decoding — No Code Generation Needed

Unlike Flutter where you need `json_serializable` + `build_runner`, Swift's `Codable` (or just `Decodable`) works automatically for matching property names.

```swift
// Title.swift
struct ApiObject : Decodable {
    var results : [Title] = []
}

struct Title : Decodable, Identifiable {
    var id : Int?
    var title : String?
    var backdrop_path : String?      // must match JSON key exactly
    var poster_path : String?
    var vote_average : Double?
}
```

```swift
// dataFetch.swift — decoding JSON
let (data, _) = try await URLSession.shared.data(for: request)
var titles = try JSONDecoder().decode(ApiObject.self, from: data).results
//                                   ^^^^^^^^^^^ the type to decode into
```

If your JSON keys use `camelCase` but your Swift properties are different, you can set:
```swift
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase  // e.g. "vote_average" → voteAverage
```

**Loading from a bundled JSON file** (ApiConfig.swift):
```swift
guard let url = Bundle.main.url(forResource: "ApiConfig", withExtension: "json") else {
    throw ApiConFigError.fileNotFound
}
let data = try Data(contentsOf: url)
let config = try JSONDecoder().decode(ApiConfig.self, from: data)
```

`Bundle.main` is the app bundle — the package that contains your compiled code and resources. `ApiConfig.json` is bundled with the app, like assets in Flutter's `pubspec.yaml`.

---

## 17. Networking with URLSession

`URLSession` is the built-in HTTP client — like Flutter's `http` package or `Dio`.

```swift
// dataFetch.swift
var request = URLRequest(url: url)
request.httpMethod = "GET"
request.setValue("application/json", forHTTPHeaderField: "accept")
request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

let (data, _) = try await URLSession.shared.data(for: request)
```

| Flutter (http package) | Swift (URLSession) |
|---|---|
| `http.get(uri, headers: {...})` | `URLRequest` + set headers + `URLSession.shared.data(for:)` |
| `response.bodyBytes` | `data` (the first element of the tuple) |
| `response.statusCode` | `response` (the `_` we ignored — it's an `HTTPURLResponse`) |
| `jsonDecode(response.body)` | `JSONDecoder().decode(Type.self, from: data)` |

The `let (data, _) = ...` is **tuple destructuring** — the function returns `(Data, URLResponse)` but we only care about the `Data` part, so we ignore the response with `_`.

---

## 18. SwiftUI Modifiers — The Decorator Pattern

In Flutter, you wrap widgets with other widgets to decorate them:
```dart
Padding(
  padding: EdgeInsets.all(10),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image(...),
  ),
)
```

In SwiftUI, you chain **modifiers** on a view:
```swift
// TrendingMoviesHorizontalView.swift
AsyncImage(url: ...) { image in
    image
        .resizable()
        .scaledToFill()
        .clipShape(RoundedRectangle(cornerRadius: 10))
} placeholder: {
    ProgressView()
}
.frame(width: 100, height: 150)
```

Each modifier returns a **new view** wrapping the previous one — same concept as Flutter's widget wrapping, just written differently. The order matters — `.frame()` before `.background()` behaves differently than the reverse.

---

## 19. ForEach — Rendering Lists

Flutter's list rendering:
```dart
children: movies.map((movie) => MovieCard(movie: movie)).toList()
// or with ListView.builder
```

SwiftUI's `ForEach`:
```swift
// TrendingMoviesHorizontalView.swift
ForEach(viewModel.trendingMoviesList) { title in
    AsyncImage(url: URL(string: title.poster_path ?? "")) { ... }
        .frame(width: 100, height: 150)
}
```

`ForEach` requires items to be `Identifiable` (have a unique `id`) — that's why `Title` conforms to `Identifiable`. Without it, you'd need to provide a key path: `ForEach(list, id: \.id)`.

---

## 20. AsyncImage — Network Images

SwiftUI's built-in network image loader — like Flutter's `Image.network()` or `CachedNetworkImage`.

```swift
// HomeView.swift
AsyncImage(url: URL(string: image)) { image in
    image
        .resizable()
        .scaledToFit()
        .clipShape(RoundedRectangle(cornerRadius: 10))
} placeholder: {
    ProgressView()   // shown while loading (like CircularProgressIndicator)
}
```

The closure receives a **phase** or the loaded image. Here we use the shorthand that gives us the loaded `Image` directly. `ProgressView()` is SwiftUI's equivalent of Flutter's `CircularProgressIndicator`.

---

## 21. TabView — Bottom Navigation

```swift
// ContentView.swift
TabView {
    Tab(Constans.homeString, systemImage: "house") {
        HomeView()
    }
    Tab(Constans.upcomingString, systemImage: "play.circle") {
        // empty — not yet implemented
    }
    Tab(Constans.searchString, systemImage: "magnifyingglass") {
        Text("Add page search")
    }
    Tab(Constans.downloadString, systemImage: "arrow.down") {
        Text("Add page download")
    }
}
```

Flutter equivalent:
```dart
Scaffold(
  body: pages[_selectedIndex],
  bottomNavigationBar: BottomNavigationBar(items: [...]),
)
```

SwiftUI's `TabView` handles the selection state automatically — no `_selectedIndex` needed. `systemImage` refers to **SF Symbols**, Apple's built-in icon set (thousands of icons, free to use in Apple apps).

### `.onAppear` — lifecycle hook

```swift
.onAppear() {
    if let config = ApiConfig.shared {
        print(config.apiKey)
    }
}
```

| Flutter | SwiftUI |
|---|---|
| `initState()` | `.onAppear { }` |
| `dispose()` | `.onDisappear { }` |

---

## 22. Common Patterns & Gotchas

### String interpolation
Swift: `"Bearer \(apiKey)"` — same as Dart's `"Bearer $apiKey"` but uses `\()` instead of `$`.

### Named parameters (argument labels)
```swift
// dataFetch.swift
func fetchMovies(for media: String, by type: String) async throws -> ...
//               ^^^             ^^
//           external label   external label

// Called as:
dataFetcher.fetchMovies(for: "movie", by: "trending")
```

Swift functions have two labels: an **external label** (used at call site) and an **internal name** (used inside the function). `for media` means call with `for:` but use `media` inside. This makes call sites read like English.

### `some View` vs `any View`
- `some View` — a specific type known at compile time (use this, it's efficient)
- `any View` — any type (use only when you need true dynamic dispatch)

### `#Preview` macro
```swift
#Preview {
    HomeView()
}
```
This creates a live preview in Xcode's canvas — like Flutter's `hot reload` but visual and static. No need to run the simulator for UI tweaks.

### Value semantics gotcha
Because structs are value types, this in `constants.swift` is necessary:
```swift
static func addPosterPath(to title: inout [Title]) {
    title[i].poster_path = "..."   // modifying the inout copy, which writes back
}
```
If `inout` was missing, the modifications would be lost — you'd be editing a copy.

### `private` vs no access modifier
- In Swift, the default access level is `internal` — visible within the module (your app).
- `private` — visible only within the same file/type.
- `private(set)` — readable everywhere, writable only internally.

---

## Quick Reference: Flutter → SwiftUI Cheatsheet

| Flutter/Dart | Swift/SwiftUI |
|---|---|
| `class MyWidget extends StatelessWidget` | `struct MyView: View` |
| `class MyWidget extends StatefulWidget` | `struct MyView: View` + `@State` |
| `Widget build(BuildContext context)` | `var body: some View` |
| `ChangeNotifier` | `@Observable class` |
| `notifyListeners()` | (automatic with `@Observable`) |
| `setState(() { ... })` | Just assign to `@State` var directly |
| `Column` | `VStack` |
| `Row` | `HStack` |
| `ListView.builder` | `ScrollView` + `LazyVStack` + `ForEach` |
| `Padding(padding: ..., child: ...)` | `.padding(...)` modifier |
| `SizedBox(width: w, height: h)` | `.frame(width: w, height: h)` |
| `Image.network(url)` | `AsyncImage(url: ...)` |
| `CircularProgressIndicator` | `ProgressView()` |
| `BottomNavigationBar` | `TabView` with `Tab` |
| `initState()` | `.onAppear { }` |
| `dispose()` | `.onDisappear { }` |
| `Navigator.push(...)` | `NavigationStack` + `.navigationDestination` |
| `http.get(url)` | `URLSession.shared.data(for: request)` |
| `jsonDecode(body)` | `JSONDecoder().decode(Type.self, from: data)` |
| `if (x == null) return;` | `guard let x = x else { return }` |
| `x ?? defaultValue` | `x ?? defaultValue` (same!) |
| `async/await` | `async/await` (same!) |
| `Future(() { ... })` | `Task { ... }` |
| `extension MyClass { ... }` | `extension MyClass { ... }` (same!) |
| `sealed class` (result pattern) | `enum` with associated values |
| `pubspec.yaml` assets | `Bundle.main.url(forResource:)` |
