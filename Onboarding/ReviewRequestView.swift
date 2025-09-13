import SwiftUI
import StoreKit

// MARK: - Review Request View
struct ReviewRequestView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    @State private var hasShownReview = false
    
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
                    // Celebration icon
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.yellow.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                            
                            Circle()
                                .fill(Color.yellow.opacity(0.4))
                                .frame(width: 90, height: 90)
                                .scaleEffect(isAnimating ? 1.15 : 0.95)
                                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                            
                            Image(systemName: "heart.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                        }
                        .padding(.top, 40)
                    }
                    .frame(height: geometry.size.height * 0.3)
                    
                    // Text content
                    VStack(spacing: 20) {
                        Text("Your Feedback Makes Us Better")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Text("Every bit of feedback helps us create a better experience for you. Thank you for being part of our journey! ✨")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Continue button - always visible at bottom
                    VStack {
                        Button(action: {
                            mediumHaptic()
                            viewModel.nextPage()
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
                    }
                    .padding(.bottom, 50)
                    .background(Color.white)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            isAnimating = true
            
            // Show review request after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if !hasShownReview {
                    requestReview()
                    hasShownReview = true
                }
            }
        }
    }
    
    private func requestReview() {
        // Request review using StoreKit
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

// MARK: - Preview
#Preview {
    ReviewRequestView(viewModel: OnboardingViewModel())
}
