# Pret iOS

A minimal [Hotwire Native](https://native.hotwired.dev) iOS shell for Pret,
created by following the official
[Hotwire Native iOS: Getting Started](https://native.hotwired.dev/ios/getting-started)
guide.

The app wraps `https://pret-app.com` in a native iOS container using
`HotwireNative.Navigator`, giving you basic forward/back navigation and error
handling for free.

## Requirements

- Xcode 15 or newer
- iOS 17 or newer

## Running

1. Open `Pret.xcodeproj` in Xcode.
2. Xcode will resolve the
   [`hotwire-native-ios`](https://github.com/hotwired/hotwire-native-ios)
   Swift package automatically on first open.
3. Select an iOS Simulator and press **Product → Run** (⌘R).

## Project layout

```
Pret.xcodeproj/          # Xcode project
Pret/
├── AppDelegate.swift    # Standard UIKit app delegate (scene-based lifecycle)
├── SceneDelegate.swift  # Creates the Hotwire Native Navigator and root URL
├── Info.plist           # UIApplicationSceneManifest → SceneDelegate
├── Assets.xcassets/     # App icon + accent color
└── Base.lproj/
    └── LaunchScreen.storyboard
```

## What the template does

Per the getting-started guide, `SceneDelegate` is the only file that differs
from a stock iOS "App" template. It creates a `Navigator` pointed at the Pret
root URL and installs its `rootViewController` as the window root:

```swift
import HotwireNative
import UIKit

let rootURL = URL(string: "https://pret-app.com")!

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let navigator = Navigator(configuration: .init(
        name: "main",
        startLocation: rootURL
    ))

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigator.rootViewController
        window?.makeKeyAndVisible()
        navigator.start()
    }
}
```

To point the app at a different environment (e.g. a staging server or a local
dev server), change the `rootURL` constant.

## Next steps

This shell only covers the core Hotwire Native requirements. To add bridge
components, native screens, path configuration, tabs, etc., see the
[Hotwire Native iOS demo app](https://github.com/hotwired/hotwire-native-ios/tree/main/Demo)
for worked examples.
