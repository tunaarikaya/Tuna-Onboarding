import SwiftUI
import Foundation

// MARK: - Haptic Feedback Compatibility
func lightHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}

func mediumHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}

func successHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

func warningHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.warning)
}

func errorHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.error)
}

func selectionHaptic() {
    let generator = UISelectionFeedbackGenerator()
    generator.selectionChanged()
}

// MARK: - Firebase & Auth Mocks
struct User {
    var uid: String = "mock_uid"
    var email: String? = "mock@example.com"
}

struct AuthDataResult {
    var user: User = User()
}

class Auth {
    static let shared = Auth()
    static func auth() -> Auth { return shared }
    var currentUser: User? = User()
    
    func signIn(with credential: Any, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        completion(AuthDataResult(), nil)
    }
    func signInAnonymously(completion: @escaping (AuthDataResult?, Error?) -> Void) {
        completion(AuthDataResult(), nil)
    }
}

class OAuthProvider {
    static func appleCredential(withIDToken: String, rawNonce: String, fullName: Any?) -> Any {
        return "mock_apple_credential"
    }
}

class GoogleAuthProvider {
    static func credential(withIDToken: String, accessToken: String) -> Any {
        return "mock_google_credential"
    }
}

// MARK: - Google Sign In Mock
struct GIDUser {
    var idToken: GIDToken? = GIDToken()
    var accessToken: GIDToken = GIDToken()
}

struct GIDToken {
    var tokenString: String = "mock_token"
}

struct GIDSignInResult {
    var user: GIDUser = GIDUser()
}

class GIDSignIn {
    static let sharedInstance = GIDSignIn()
    func signIn(withPresenting: UIViewController, completion: @escaping (GIDSignInResult?, Error?) -> Void) {
        completion(GIDSignInResult(), nil)
    }
}

// MARK: - Superwall & RevenueCat Mocks
class Superwall {
    static let shared = Superwall()
    func register(placement: String, completion: @escaping () -> Void) {
        completion()
    }
}

// MARK: - OneSignal Mock
class OneSignal {
    struct Notifications {
        static func requestPermission(_ completion: @escaping (Bool) -> Void, fallbackToSettings: Bool) {
            completion(true)
        }
    }
}

// MARK: - Analytics Mocks
class AnalyticsManager {
    static let shared = AnalyticsManager()
    func logScreenView(screenName: String, screenClass: String) {}
    func logButtonClick(buttonName: String, screenName: String) {}
    func logError(errorCode: String, errorMessage: String, screen: String) {}
    func setUserId(userId: String) {}
    func setAuthProvider(provider: String) {}
    func setUserProperty(value: String, forName: String) {}
}

struct AnalyticsEvents {
    struct Screen {
        static let login = "login"
    }
    struct Button {
        static let signInWithApple = "apple"
        static let signInWithGoogle = "google"
        static let signInAnonymously = "anonymous"
    }
}

// MARK: - UI Mock Views
struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        Text("Main Application Content")
            .font(.title)
    }
}

class MainViewModel: ObservableObject {}

// MARK: - Missing Imports Shims
// These dummy frameworks allow the code to compile without the real ones
// In a real project, you would add these via SPM.

// Firebase
// We don't actually need to define these as 'module' just provide the types if needed.
// Since the files import them directly, we might need to comment out the imports or 
// use a trick. The easiest way for a "quick fix" that also looks clean is to 
// tell the user to use SPM or I can just mock the classes as I did above.
// However, 'import' will fail if the module isn't found.

// Since I cannot modify 'Build Settings', I will comment out the imports in the files.
