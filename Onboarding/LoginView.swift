import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseAnalytics
import AuthenticationServices
import CryptoKit
import GoogleSignIn



// MARK: - Apple Sign In Manager
@available(iOS 13, *)
class AppleSignInManager: NSObject, ObservableObject {
    @Published var isLoading = false
    private var currentNonce: String?
    private var onSuccess: (() -> Void)?
    
    func signInWithApple(onSuccess: @escaping () -> Void) {
        self.onSuccess = onSuccess
        isLoading = true
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func handleSuccess() {
        // Success animation logic
        DispatchQueue.main.async {
            self.isLoading = false
            self.onSuccess?()
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}



// MARK: - Apple Sign In Delegates
@available(iOS 13.0, *)
extension AppleSignInManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                isLoading = false
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                isLoading = false
                return
            }
            
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                          rawNonce: nonce,
                                                          fullName: appleIDCredential.fullName)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        print("Apple Sign In Error: \(error.localizedDescription)")
                        return
                    }
                    
                        if let user = authResult?.user {
                            print("Apple Sign In successful with user ID: \(user.uid)")
                            
                            // Track successful Apple sign-in
                            AnalyticsManager.shared.setUserId(userId: user.uid)
                            AnalyticsManager.shared.setAuthProvider(provider: "apple")
                            
                            // Track if user has email
                            if let email = user.email, !email.isEmpty {
                                AnalyticsManager.shared.setUserProperty(value: "true", forName: "has_email")
                            }
                            
                            UserDefaults.standard.set(true, forKey: "isUserAuthenticated")
                            UserDefaults.standard.set("apple", forKey: "authProvider")
                            self.onSuccess?()
                        }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
        DispatchQueue.main.async {
            self.isLoading = false
            
            // Track Apple sign-in error
            AnalyticsManager.shared.logError(
                errorCode: "apple_sign_in_failed",
                errorMessage: error.localizedDescription,
                screen: AnalyticsEvents.Screen.login
            )
        }
    }
}

@available(iOS 13.0, *)
extension AppleSignInManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}

struct LoginView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @StateObject private var appleSignInManager = AppleSignInManager()
    @State private var isLoading = false
    @State private var isShowingSuccess = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header with back button and progress
                HStack {
                    Button(action: {
                        lightHaptic()
                        viewModel.previousPage()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    // Progress indicator
                    HStack(spacing: 4) {
                        ForEach(0..<viewModel.totalPages, id: \.self) { index in
                            Rectangle()
                                .fill(index <= viewModel.currentPage ? Color.black : Color.gray.opacity(0.3))
                                .frame(width: geometry.size.width * 0.05, height: 3)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)
                        }
                    }
                    
                    Spacer()
                    
                    // Invisible spacer to center progress
                    Color.clear
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, geometry.safeAreaInsets.top + 10)
                
                // Main content
                VStack(spacing: 0) {
                    // Animated illustration area
                    VStack(spacing: 16) {
                        // Security icon with subtle animation
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.04))
                                .frame(width: min(geometry.size.width * 0.25, 120))
                            
                            Circle()
                                .fill(Color.black.opacity(0.08))
                                .frame(width: min(geometry.size.width * 0.2, 96))
                            
                            Image(systemName: "shield.checkered")
                                .font(.system(size: min(geometry.size.width * 0.08, 40), weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        // Title with better spacing
                        VStack(spacing: 8) {
                            Text("Save your progress")
                                .font(.system(size: min(geometry.size.width * 0.08, 32), weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text("Your data stays secure and synced across devices")
                                .font(.system(size: min(geometry.size.width * 0.04, 16)))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.top, geometry.size.height * 0.08)
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Login options with better spacing
                    VStack(spacing: 16) {
                        // Apple Sign In
                        Button(action: {
                            mediumHaptic()
                            if #available(iOS 13, *) {
                                appleSignInManager.signInWithApple {
                                    // Track successful Apple sign-in
                                    AnalyticsManager.shared.logButtonClick(
                                        buttonName: AnalyticsEvents.Button.signInWithApple,
                                        screenName: AnalyticsEvents.Screen.login
                                    )
                                    viewModel.nextPage()
                                }
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text("Continue with Apple")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 26)
                                    .fill(Color.black)
                            )
                        }
                        .scaleEffect(appleSignInManager.isLoading ? 0.95 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: appleSignInManager.isLoading)
                        
                        // Google Sign In
                        Button(action: {
                            mediumHaptic()
                            signInWithGoogle()
                        }) {
                            HStack(spacing: 12) {
                                Image("googleLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                
                                Text("Continue with Google")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 26)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 26)
                                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                    )
                            )
                        }
                        .scaleEffect(isLoading ? 0.95 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: isLoading)
                        
                        // Divider with "or"
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("or")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)
                        
                        // Skip option with better styling
                        Button(action: {
                            lightHaptic()
                            signInAnonymously()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.right.circle")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black.opacity(0.7))
                                
                                Text("Continue without account")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.gray.opacity(0.08))
                            )
                        }
                    }
                    .padding(.horizontal, max(24, geometry.size.width * 0.08))
                    
                    // Bottom spacing with privacy note
                    VStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "lock.shield")
                                .font(.system(size: 12))
                                .foregroundColor(.gray.opacity(0.7))
                            
                            Text("Your data is encrypted and secure")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray.opacity(0.7))
                        }
                    }
                    .padding(.top, 24)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 30)
                }
            }
            .overlay(
                Group {
                    if isLoading || appleSignInManager.isLoading {
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea(.all)
                            
                            VStack(spacing: 20) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                                
                                Text("Signing in...")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding(30)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.7))
                            )
                        }
                    }
                }
            )
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            // Track screen view
            AnalyticsManager.shared.logScreenView(
                screenName: AnalyticsEvents.Screen.login,
                screenClass: "LoginView"
            )
        }
    }
    
    private func signInAnonymously() {
        isLoading = true
        
        // Track anonymous sign-in attempt
        AnalyticsManager.shared.logButtonClick(
            buttonName: AnalyticsEvents.Button.signInAnonymously,
            screenName: AnalyticsEvents.Screen.login
        )
        
        Auth.auth().signInAnonymously { authResult, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    print("Error signing in anonymously: \(error.localizedDescription)")
                    
                    // Track authentication error
                    AnalyticsManager.shared.logError(
                        errorCode: "anonymous_auth_failed",
                        errorMessage: error.localizedDescription,
                        screen: AnalyticsEvents.Screen.login
                    )
                    return
                }
                
                if let user = authResult?.user {
                    print("Signed in anonymously with user ID: \(user.uid)")
                    
                    // Track successful anonymous sign-in
                    AnalyticsManager.shared.setUserId(userId: user.uid)
                    AnalyticsManager.shared.setAuthProvider(provider: "anonymous")
                    
                    showSuccessAndNavigate {
                        UserDefaults.standard.set(true, forKey: "isUserAuthenticated")
                        UserDefaults.standard.set("anonymous", forKey: "authProvider")
                        viewModel.nextPage()
                    }
                }
            }
        }
    }
    
    // MARK: - Authentication Methods
    
    private func signInWithGoogle() {
        isLoading = true
        
        // Track Google sign-in attempt
        AnalyticsManager.shared.logButtonClick(
            buttonName: AnalyticsEvents.Button.signInWithGoogle,
            screenName: AnalyticsEvents.Screen.login
        )
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let presentingViewController = windowScene.windows.first?.rootViewController else {
            isLoading = false
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("Google Sign In Error: \(error)")
                    
                    // Track Google sign-in error
                    AnalyticsManager.shared.logError(
                        errorCode: "google_sign_in_failed",
                        errorMessage: error.localizedDescription,
                        screen: AnalyticsEvents.Screen.login
                    )
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                              accessToken: user.accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Firebase Google Auth Error: \(error)")
                        
                        // Track Firebase auth error
                        AnalyticsManager.shared.logError(
                            errorCode: "firebase_google_auth_failed",
                            errorMessage: error.localizedDescription,
                            screen: AnalyticsEvents.Screen.login
                        )
                        return
                    }
                    
                    // Track successful Google sign-in
                    if let userId = authResult?.user.uid {
                        AnalyticsManager.shared.setUserId(userId: userId)
                        AnalyticsManager.shared.setAuthProvider(provider: "google")
                        
                        // Track if user has email
                        if let email = authResult?.user.email, !email.isEmpty {
                            AnalyticsManager.shared.setUserProperty(value: "true", forName: "has_email")
                        }
                    }
                    
                    self.showSuccessAndNavigate {
                        UserDefaults.standard.set(true, forKey: "isUserAuthenticated")
                        UserDefaults.standard.set("google", forKey: "authProvider")
                        self.viewModel.nextPage()
                    }
                }
            }
        }
    }
    
    private func showSuccessAndNavigate(completion: @escaping () -> Void) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isShowingSuccess = true
        }
        
        lightHaptic()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion()
            
            // Reset success state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isShowingSuccess = false
            }
        }
    }
}

#Preview {
    LoginView(viewModel: OnboardingViewModel())
}

