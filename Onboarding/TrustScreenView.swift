import SwiftUI

// MARK: - Trust Screen View
struct TrustScreenView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
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
                VStack(spacing: 15) {
                    // Title
                    Text("Thousands of people trust Finance AI")
                        .font(.system(size: min(geometry.size.width * 0.06, 22), weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Image("5star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(geometry.size.width * 0.5, 140), height: min(geometry.size.width * 0.3, 80))
                    
                    Text("Perfect rating on App Store")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    // Profile photos row
                    HStack(spacing: -8) {
                        ForEach(["pp1", "pp2", "pp3"], id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                        
                        Spacer()
                        
                        Text("+1,000 users")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                    
                    // Testimonials section
                    VStack(spacing: 14) {
                        // First testimonial
                        TestimonialCard(
                            profileImage: "pp1",
                            name: "Marcus Johnson",
                            rating: 5,
                            review: "This app completely changed how I manage my finances. The AI insights helped me save $500 last month alone. The receipt scanning feature is a game changer!"
                        )
                        
                        // Second testimonial
                        TestimonialCard(
                            profileImage: "pp2",
                            name: "David Chen",
                            rating: 5,
                            review: "Finally, a budgeting app that actually works. The spending predictions are incredibly accurate and the interface is so clean. Highly recommend!"
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 10)
                    
                    // Bottom spacing for button
                    Spacer()
                }
                
                // Fixed continue button at bottom
                VStack {
                    Button(action: {
                        successHaptic()
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .background(Color.white)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - Testimonial Card
struct TestimonialCard: View {
    let profileImage: String
    let name: String
    let rating: Int
    let review: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // User info
            HStack(spacing: 12) {
                Image(profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    
                    // Star rating
                    HStack(spacing: 2) {
                        ForEach(0..<rating, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                Spacer()
            }
            
            // Review text
            Text(review)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    TrustScreenView(viewModel: OnboardingViewModel())
}
