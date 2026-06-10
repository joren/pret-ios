# Pret iOS

A [Hotwire Native](https://native.hotwired.dev) iOS shell for
[Pret](https://pret-app.com).

The app wraps `https://pret-app.com` in a native iOS container using
`HotwireNative.Navigator`, with path-configuration-driven navigation
(modals for forms, pull-to-refresh, native back behavior) on top of the
web app.

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
Pret.xcodeproj/               # Xcode project
Pret/
├── AppConfiguration.swift    # Root URL, start URL, remote path config URL
├── AppDelegate.swift         # Hotwire configuration (path config, modals, logging)
├── SceneDelegate.swift       # Creates the Hotwire Native Navigator
├── path-configuration.json   # Bundled navigation rules
├── PrivacyInfo.xcprivacy     # Apple privacy manifest
├── Info.plist                # Scene manifest, export compliance
├── Assets.xcassets/          # App icon + accent color
└── Base.lproj/
    └── LaunchScreen.storyboard
```

## Navigation

The app launches at `https://pret-app.com/login` (`AppConfiguration.startURL`).
Signed-out users see the sign-in form immediately; the server redirects
signed-in users (existing session cookie) on to their home screen. If the
web app's sign-in path is not `/login`, change `startURL` in
`AppConfiguration.swift`.

Navigation rules live in `Pret/path-configuration.json`:

- Every screen gets **pull-to-refresh** by default.
- Auth screens (`/login`, `/session/new`, …) replace the navigation stack
  root, so users can't swipe back into the app after signing out.
- `…/new` and `…/edit` URLs are presented as **modal sheets** with a Done
  button, matching native form conventions.
- The Turbo Rails `recede/resume/refresh_historical_location` routes are
  handled so modals dismiss correctly after form submissions.

On launch the app also tries to fetch an updated rule set from
`https://pret-app.com/configurations/ios_v1.json`, so navigation rules can
be changed server-side without an App Store release. Until that endpoint
exists in the Rails app, the bundled rules are used on their own (the
failed fetch is harmless).

### Recommended Rails-side additions

In the [pret](https://github.com/joren/pret) app:

- Serve the path configuration: `get "configurations/ios_v1", defaults: { format: :json }`
  returning the same JSON shape as `path-configuration.json`.
- After sign-in, use `recede_or_redirect_to` / regular redirects — the
  Navigator follows server redirects natively.
- Use `hotwire_native_app?` in views to hide web-only chrome (top nav,
  footer) inside the app.

## App Store submission checklist

Already handled in this repo:

- [x] App icon: single 1024×1024 PNG, RGB without alpha.
- [x] Launch screen storyboard.
- [x] `ITSAppUsesNonExemptEncryption = false` (no export-compliance prompt
      on each upload; the app only uses standard HTTPS).
- [x] Privacy manifest (`PrivacyInfo.xcprivacy`): no tracking, no collected
      data types, UserDefaults declared with reason `CA92.1`.
- [x] Marketing version `1.0`, build `1`
      (`MARKETING_VERSION` / `CURRENT_PROJECT_VERSION`).
- [x] Bundle ID `com.notatechcompany.pret`, automatic signing,
      team `3M44Y52N28`.

Still to do in App Store Connect / Xcode before you press submit:

1. Create the app record in App Store Connect with bundle ID
   `com.notatechcompany.pret`.
2. Fill in the **App Privacy** questionnaire. Match the privacy manifest:
   if Pret accounts only need an email address + password, declare
   "Email Address (App Functionality, linked to identity)".
3. Provide a **privacy policy URL** and a **support URL** (e.g. pages on
   pret-app.com) — both are required fields.
4. Add screenshots for 6.7" and 6.5" iPhones (and 12.9" iPad, since the
   target supports iPad).
5. If sign-in is required to use the app, supply a **demo account** in the
   App Review notes.
6. Review Guideline 4.2 (minimum functionality): web wrappers get rejected
   when they add nothing native. The modal forms, pull-to-refresh, and
   native navigation here help; push notifications or a native tab bar
   would strengthen the case further.
7. Archive (**Product → Archive**) and upload via the Organizer.

## Next steps

To add bridge components, native screens, or a native tab bar
(`HotwireTabBarController`), see the
[Hotwire Native iOS demo app](https://github.com/hotwired/hotwire-native-ios/tree/main/Demo)
for worked examples.
