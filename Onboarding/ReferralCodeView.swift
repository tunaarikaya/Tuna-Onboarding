import SwiftUI

// MARK: - Referral Code View
struct ReferralCodeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var referralCode: String = ""
    @State private var isValidating = false
    @State private var validationMessage = ""
    @State private var showValidationMessage = false
    @State private var isCodeValid = false
    
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
                                .frame(width: 20, height: 2)
                        }
                    }
                    
                    Spacer()
                    
                    // Invisible spacer to center progress
                    Color.clear
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Main content
                VStack(spacing: 0) {
                    // Title and subtitle
                    VStack(spacing: 16) {
                        Text("Referral Code")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text("Do you have a referral code? Enter it below to unlock premium features")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 40)
                    
                    // Referral code input section
                    VStack(spacing: 24) {
                        // Input field
                        VStack(spacing: 12) {
                            TextField("Enter referral code", text: $referralCode)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(
                                                    isCodeValid ? Color.green : 
                                                    showValidationMessage && !isCodeValid ? Color.red : 
                                                    Color.gray.opacity(0.3), 
                                                    lineWidth: 1
                                                )
                                        )
                                )
                                .textInputAutocapitalization(.characters)
                                .autocorrectionDisabled()
                                .onChange(of: referralCode) { newValue in
                                    // Clear validation message when user types
                                    if showValidationMessage {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showValidationMessage = false
                                        }
                                    }
                                }
                            
                            // Validation message
                            if showValidationMessage {
                                HStack(spacing: 8) {
                                    Image(systemName: isCodeValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(isCodeValid ? .green : .red)
                                    
                                    Text(validationMessage)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(isCodeValid ? .green : .red)
                                }
                                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                            }
                        }
                        
                        // Validate button
                        Button(action: {
                            validateReferralCode()
                        }) {
                            HStack(spacing: 8) {
                                if isValidating {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                
                                Text(isValidating ? "Validating..." : "Validate Code")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(referralCode.isEmpty ? Color.gray : Color.black)
                            )
                        }
                        .disabled(referralCode.isEmpty || isValidating)
                        .animation(.easeInOut(duration: 0.2), value: referralCode.isEmpty)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Continue button
                    Button(action: {
                        if isCodeValid {
                            successHaptic()
                            // Continue with onboarding, premium status is already set
                            viewModel.nextPage()
                        } else {
                            mediumHaptic()
                            viewModel.nextPage()
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black)
                            )
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // MARK: - Private Methods
    
    private func validateReferralCode() {
        guard !referralCode.isEmpty else { return }
        
        mediumHaptic()
        isValidating = true
        
        // Use ViewModel to validate the code
        viewModel.validateReferralCode(referralCode) { isValid in
            self.isValidating = false
            
            self.isCodeValid = isValid
            self.validationMessage = isValid ? 
                "Valid code! Premium features unlocked. Continue to access the app." : 
                "Invalid code. Please check and try again"
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                self.showValidationMessage = true
            }
            
            if isValid {
                self.successHaptic()
            } else {
                self.errorHaptic()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ReferralCodeView(viewModel: OnboardingViewModel())
}
