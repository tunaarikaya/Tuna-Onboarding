import SwiftUI
import SuperwallKit
import UIKit

// MARK: - Premium Features View
struct PremiumFeaturesView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var navigateToHome = false
    
    let features = [
        PremiumFeature(
            icon: "camera.fill",
            title: "Receipt Scanning",
            description: "Scan your receipts and automatically categorize your expenses"
        ),
        PremiumFeature(
            icon: "creditcard.fill",
            title: "Credit Card Analysis",
            description: "Analyze your credit card statements and get spending insights"
        ),
         PremiumFeature(
            icon: "brain.head.profile",
            title: "AI Smart Budget Recommendations",
            description: "Get personalized budget suggestions powered by artificial intelligence"
        ),
        PremiumFeature(
            icon: "chart.bar.fill",
            title: "Detailed Reports & Charts",
            description: "Get comprehensive financial reports and beautiful visualizations"
        ),
        PremiumFeature(
            icon: "xmark.circle.fill",
            title: "Ad-Free Experience",
            description: "Use the app without any distracting advertisements"
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
                    Text("We have a special gift for you! 🎁")
                        .font(.system(size: min(geometry.size.width * 0.06, 24), weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    // Free trial details
                    VStack(spacing: 6) {
                        Text("All premium features for 3 days")
                            .font(.system(size: min(geometry.size.width * 0.04, 16), weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text("FREE")
                            .font(.system(size: min(geometry.size.width * 0.08, 28), weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("you can use")
                            .font(.system(size: min(geometry.size.width * 0.04, 16), weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 16)
                    
                    // Features list
                    VStack(spacing: 12) {
                        ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                            PremiumFeatureCard(feature: feature)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    // Bottom spacing for button
                    Spacer()
                }
                
                // Fixed continue button at bottom
                VStack {
                    Button(action: {
                        successHaptic()
                        
                        // Check if user has a valid referral code
                        if viewModel.isPremium {
                            // Skip paywall if user has a valid referral code and go directly to HomeView
                            navigateToHome = true
                            
                            // Save onboarding completion status
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        } else {
                            // Show Superwall paywall
                            Superwall.shared.register(placement: "campaign_trigger") {
                                // This code runs if the user has access (purchased or free trial active)
                                // User has purchased premium, navigate to HomeView
                                navigateToHome = true
                                
                                // Save onboarding completion status
                                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                                UserDefaults.standard.set(true, forKey: "isPremium") // Mark as premium
                            }
                        }
                    }) {
                        Text(viewModel.isPremium ? "Continue" : "Start Free Trial")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .background(Color.white)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .fullScreenCover(isPresented: $navigateToHome) {
            MainView(viewModel: MainViewModel())
        }
    }
}

// MARK: - Premium Feature Model
struct PremiumFeature {
    let icon: String
    let title: String
    let description: String
}

// MARK: - Premium Feature Card
struct PremiumFeatureCard: View {
    let feature: PremiumFeature
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 40, height: 40)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(feature.description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Checkmark
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 20, height: 20)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

// MARK: - Preview
#Preview {
    PremiumFeaturesView(viewModel: OnboardingViewModel())
}
