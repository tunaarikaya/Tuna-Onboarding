import SwiftUI

// MARK: - Challenge Screen View
struct ChallengeScreenView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedChallenge: String = ""
    
    let challenges = [
        ChallengeOption(
            icon: "rocket",
            text: "I won't stop no matter what until I reach my goals"
        ),
        ChallengeOption(
            icon: "car.fill",
            text: "I will use it for at least 60 consecutive days"
        ),
        ChallengeOption(
            icon: "bicycle",
            text: "I will use it for at least 30 consecutive days"
        ),
        ChallengeOption(
            icon: "figure.walk",
            text: "I will use it for at least 7 consecutive days"
        )
    ]
    
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
                    // Title
                    VStack(spacing: 8) {
                        Text("Challenge time!")
                            .font(.system(size: min(geometry.size.width * 0.08, 32), weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("How determined are you to reach your goals?")
                            .font(.system(size: min(geometry.size.width * 0.045, 18), weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    
                    // Challenge options
                    VStack(spacing: 16) {
                        ForEach(Array(challenges.enumerated()), id: \.offset) { index, challenge in
                            ChallengeOptionCard(
                                challenge: challenge,
                                isSelected: selectedChallenge == challenge.text,
                                action: {
                                    selectionHaptic()
                                    selectedChallenge = challenge.text
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    
                    // Bottom spacing for button
                    Spacer()
                }
                
                // Fixed continue button at bottom
                VStack {
                    Button(action: {
                        if !selectedChallenge.isEmpty {
                            successHaptic()
                            viewModel.nextPage()
                        } else {
                            warningHaptic()
                        }
                    }) {
                        Text(selectedChallenge.isEmpty ? "Select an option to continue" : "Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(selectedChallenge.isEmpty ? .gray : .white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedChallenge.isEmpty ? Color.gray.opacity(0.3) : Color.black)
                            )
                    }
                    .disabled(selectedChallenge.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .background(Color.white)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - Challenge Option Model
struct ChallengeOption {
    let icon: String
    let text: String
}

// MARK: - Challenge Option Card
struct ChallengeOptionCard: View {
    let challenge: ChallengeOption
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                if challenge.icon == "rocket" {
                    Image("rocket")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                } else {
                    Image(systemName: challenge.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                }
                
                // Text
                Text(challenge.text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black.opacity(0.05) : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Preview
#Preview {
    ChallengeScreenView(viewModel: OnboardingViewModel())
}
