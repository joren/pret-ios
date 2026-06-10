import Foundation

enum AppConfiguration {
    /// The Pret web app this shell wraps. Point this at a staging or local
    /// server to test against a different environment.
    static let rootURL = URL(string: "https://pret-app.com")!

    /// Shown on first launch. Signed-in users are redirected by the server
    /// to their home screen; everyone else lands on the sign-in form.
    static let startURL = rootURL.appendingPathComponent("login")

    /// Remote path configuration, so navigation rules can be updated without
    /// shipping a new app version. Serve this JSON from the Rails app; until
    /// it exists the bundled path-configuration.json is used on its own.
    static let remotePathConfigurationURL = rootURL.appendingPathComponent("configurations/ios_v1.json")
}
