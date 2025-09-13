import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Add top spacing to avoid safe area collision
                    Spacer()
                        .frame(height: geometry.safeAreaInsets.top)
                    
                    // Custom page implementation without TabView to prevent swiping
                    ZStack {
                        // Only show the current page
                        if viewModel.currentPage == 0 {
                            OnboardingPage1(viewModel: viewModel)
                        } else if viewModel.currentPage == 1 {
                            LoginView(viewModel: viewModel)
                        } else if viewModel.currentPage == 2 {
                            OnboardingPage2(viewModel: viewModel)
                        } else if viewModel.currentPage == 3 {
                            OnboardingPage3(viewModel: viewModel)
                        } else if viewModel.currentPage == 4 {
                            OnboardingPage4(viewModel: viewModel)
                        } else if viewModel.currentPage == 5 {
                            OnboardingPage5(viewModel: viewModel)
                        } else if viewModel.currentPage == 6 {
                            OnboardingPage6(viewModel: viewModel)
                        } else if viewModel.currentPage == 7 {
                            OnboardingPage7(viewModel: viewModel)
                        } else if viewModel.currentPage == 8 {
                            ReferralCodeView(viewModel: viewModel)
                        } else if viewModel.currentPage == 9 {
                            NotificationPermissionView(viewModel: viewModel)
                        } else if viewModel.currentPage == 10 {
                            TrustScreenView(viewModel: viewModel)
                    } else if viewModel.currentPage == 11 {
                        ChallengeScreenView(viewModel: viewModel)
                    } else if viewModel.currentPage == 12 {
                        ReviewRequestView(viewModel: viewModel)
                    } else if viewModel.currentPage == 13 {
                        PremiumFeaturesView(viewModel: viewModel)
                    }
                    }
                    .animation(.easeInOut, value: viewModel.currentPage)
                    .transition(.opacity)
                    .offset(y:-30)
                }
            }
        }
        .onAppear {
            viewModel.loadOnboardingData()
        }
    }
}

// MARK: - Onboarding Page 1: Welcome Screen
struct OnboardingPage1: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top spacing
                Spacer()
                    .frame(height: geometry.safeAreaInsets.top + 20)
                
                // Image section
                VStack(spacing: 0) {
                    Image("ob")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: min(geometry.size.width * 0.9,500),
                            height: min(geometry.size.height * 0.9, 500)
                        )
                        .clipped()
                }
                .frame(maxHeight: geometry.size.height * 0.6)
                
                // Content section
                VStack(spacing: 60) {
                    // Title
                    Text("Reaching your financial goals is now very easy")
                        .font(.system(size: min(geometry.size.width * 0.06, 28), weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 30)
                        .lineLimit(nil)
                    
                    // Buttons
                    VStack(spacing: 16) {
                        // Continue Button
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
                        
                        // Login Button
                        Button(action: {
                            lightHaptic()
                            // Handle login action
                            // You can implement login logic here
                        }) {
//                            Text("Do you have an account? Log In")
//                                .font(.system(size: 16))
//                                .foregroundColor(.gray)
//                                .underline()
                        } .offset(y:20)
                    }
                }
                .frame(maxHeight: geometry.size.height * 0.35)
               
                
                // Bottom spacing
                Spacer()
                    .frame(height: geometry.safeAreaInsets.bottom + 20)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - Onboarding Page 2: Birth Date Selection
struct OnboardingPage2: View {
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
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Title and subtitle
                    VStack(spacing: 16) {
                        Text("Your Birth Date")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text("Enter your age to provide you with the most optimal financial advice")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    
                    // Date picker
                    DatePicker("", selection: $viewModel.birthDate, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(height: 200)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Continue button
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
                    .padding(.bottom, 50)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - Onboarding Page 3: Income and Expenses
struct OnboardingPage3: View {
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
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Title and subtitle
                    VStack(spacing: 16) {
                        Text("Your Income & Expenses")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text("Help us understand your financial situation to provide better recommendations")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    
                    // Income and Expense Cards
                    VStack(spacing: 20) {
                        // Income Card
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                
                                Text("Monthly Income")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text(formatCurrencyWithPlus(viewModel.monthlyIncome))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            
                            // Income Slider
                            VStack(spacing: 8) {
                                Slider(value: $viewModel.monthlyIncome, in: 0...100000, step: 1000)
                                    .accentColor(.black)
                                
                                HStack {
                                    Text("$0")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Text("+$100k")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.1))
                        )
                        
                        // Expense Card
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                
                                Text("Monthly Expenses")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text(formatCurrencyWithPlus(viewModel.monthlyExpenses))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            
                            // Expense Slider
                            VStack(spacing: 8) {
                                Slider(value: $viewModel.monthlyExpenses, in: 0...100000, step: 1000)
                                    .accentColor(.black)
                                
                                HStack {
                                    Text("$0")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Text("+$100k")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.1))
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Continue button
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
                    .padding(.bottom, 50)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    private func formatCurrencyWithPlus(_ amount: Double) -> String {
        if amount >= 100000 {
            return "+$100k"
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: amount)) ?? "$0"
        }
    }
}

// MARK: - Onboarding Page 4: Goal Selection
struct OnboardingPage4: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    private let goals = [
        GoalOption(
            id: "budget_tracking",
            title: "Budget Tracking",
            subtitle: "Monitor your income and expenses to stay on track",
            icon: "chart.bar.fill"
        ),
        GoalOption(
            id: "saving_money",
            title: "Saving Money",
            subtitle: "Build your savings and achieve financial security",
            icon: "banknote.fill"
        ),
        GoalOption(
            id: "debt_payment",
            title: "Debt Payment",
            subtitle: "Pay off debts and improve your financial health",
            icon: "creditcard.fill"
        ),
        GoalOption(
            id: "expense_control",
            title: "Expense Control",
            subtitle: "Control spending habits and reduce unnecessary expenses",
            icon: "hand.raised.fill"
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
                    // Title and subtitle
                    VStack(spacing: 16) {
                        Text("Your Goals")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Text("Select your goals so we can provide you with the most suitable financial advice")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 20)
                    
                    // Goal options
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(goals) { goal in
                                GoalSelectionCard(
                                    goal: goal,
                                    isSelected: viewModel.financialGoals.contains(goal.id),
                                    onTap: {
                                        toggleGoal(goal.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                    
                    // Continue button - always visible at bottom
                    VStack {
                        Button(action: {
                            if !viewModel.financialGoals.isEmpty {
                                mediumHaptic()
                                viewModel.nextPage()
                            } else {
                                warningHaptic()
                            }
                        }) {
                            Text(viewModel.financialGoals.isEmpty ? "Select at least one goal" : "Continue")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(viewModel.financialGoals.isEmpty ? .gray : .white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(viewModel.financialGoals.isEmpty ? Color.gray.opacity(0.3) : Color.black)
                                )
                        }
                        .disabled(viewModel.financialGoals.isEmpty)
                        .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 50)
                    .background(Color.white)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    private func toggleGoal(_ goalId: String) {
        if viewModel.financialGoals.contains(goalId) {
            viewModel.financialGoals.removeAll { $0 == goalId }
        } else {
            viewModel.financialGoals.append(goalId)
        }
    }
}

// MARK: - Goal Option Model
struct GoalOption: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
}

// MARK: - Goal Selection Card
struct GoalSelectionCard: View {
    let goal: GoalOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            selectionHaptic()
            onTap()
        }) {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: goal.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .black)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.white.opacity(0.2) : Color.gray.opacity(0.1))
                    )
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text(goal.subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Onboarding Page 5: Budget Goal
struct OnboardingPage5: View {
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
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Title and subtitle
                    VStack(spacing: 16) {
                        Text("What is your budget goal?")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.leading,10)
                        
                        Text("What amount of money do you want to reach?")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .padding(.leading,5)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Budget goal card
                    VStack(spacing: 30) {
                        // Current amount display
                        VStack(spacing: 8) {
                            Text("Target Amount")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Text(formatCurrencyWithPlus(viewModel.budgetAmount))
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.black)
                        }
                        
                        // Slider
                        VStack(spacing: 16) {
                            Slider(value: $viewModel.budgetAmount, in: 0...100000, step: 1000)
                                .accentColor(.black)
                            
                            HStack {
                                Text("$0")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("+$100k")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Continue button
                    Button(action: {
                        if viewModel.budgetAmount > 0 {
                            mediumHaptic()
                            viewModel.nextPage()
                        } else {
                            warningHaptic()
                        }
                    }) {
                        Text(viewModel.budgetAmount <= 0 ? "Set a budget goal" : "Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(viewModel.budgetAmount <= 0 ? .gray : .white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(viewModel.budgetAmount <= 0 ? Color.gray.opacity(0.3) : Color.black)
                            )
                    }
                    .disabled(viewModel.budgetAmount <= 0)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    private func formatCurrencyWithPlus(_ amount: Double) -> String {
        if amount >= 100000 {
            return "+$100k"
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: amount)) ?? "$0"
        }
    }
}

// MARK: - Onboarding Page 6: Risk Profile
struct OnboardingPage6: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    private let riskProfiles = [
        RiskProfileOption(
            id: "conservative",
            title: "Conservative",
            subtitle: "Mostly secure, low-risk investments",
            example: "Example: Savings accounts, bonds",
            icon: "🛡️"
        ),
        RiskProfileOption(
            id: "moderate",
            title: "Moderate",
            subtitle: "Balanced mix of safe and growth investments",
            example: "Example: Mixed portfolio, moderate returns",
            icon: "⚖️"
        ),
        RiskProfileOption(
            id: "aggressive",
            title: "Aggressive",
            subtitle: "Higher risk for potentially higher returns",
            example: "Example: Stocks, crypto, growth investments",
            icon: "📈"
        ),
        RiskProfileOption(
            id: "very_aggressive",
            title: "Very Aggressive",
            subtitle: "Maximum risk for maximum potential gains",
            example: "Example: Day trading, high-risk investments",
            icon: "🚀"
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
                    VStack(spacing: 16) {
                        Text("Choose Your Risk Profile")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // Risk profile options
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(riskProfiles) { profile in
                                RiskProfileCard(
                                    profile: profile,
                                    isSelected: viewModel.riskProfile == profile.id,
                                    onTap: {
                                        viewModel.riskProfile = profile.id
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                    
                    // Continue button - always visible at bottom
                    VStack {
                        Button(action: {
                            if !viewModel.riskProfile.isEmpty {
                                mediumHaptic()
                                viewModel.nextPage()
                            } else {
                                warningHaptic()
                            }
                        }) {
                            Text(viewModel.riskProfile.isEmpty ? "Select a risk profile" : "Continue")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(viewModel.riskProfile.isEmpty ? .gray : .white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(viewModel.riskProfile.isEmpty ? Color.gray.opacity(0.3) : Color.black)
                                )
                        }
                        .disabled(viewModel.riskProfile.isEmpty)
                        .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 50)
                    .background(Color.white)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - Risk Profile Option Model
struct RiskProfileOption: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let example: String
    let icon: String
}

// MARK: - Risk Profile Card
struct RiskProfileCard: View {
    let profile: RiskProfileOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            selectionHaptic()
            onTap()
        }) {
            HStack(spacing: 12) {
                // Icon
                Text(profile.icon)
                    .font(.system(size: 24))
                    .frame(width: 40, height: 40)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .black)
                        .multilineTextAlignment(.leading)
                    
                    Text(profile.subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(isSelected ? .white.opacity(0.9) : .black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(profile.example)
                        .font(.system(size: 12))
                        .foregroundColor(isSelected ? .white.opacity(0.7) : .gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Onboarding Page 7: Success Calculation
struct OnboardingPage7: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var progressValue: Double = 0
    @State private var showSuccessMessage = false
    @State private var calculatedSuccessRate: Double = 0
    @State private var animatedChartData: [ChartDataPoint] = []
    @State private var showChart = false
    
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
                    Text("Your Financial Journey")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    // Calculation content - compact layout
                    VStack(spacing: 16) {
                        // Animated Financial Growth Chart
                        VStack(spacing: 12) {
                            Text("Your Success Path")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            // Animated Chart
                            if showChart {
                                AnimatedFinancialChart(
                                    data: animatedChartData,
                                    successRate: calculatedSuccessRate,
                                    geometry: geometry
                                )
                                .frame(height: 160)
                                .transition(.opacity.combined(with: .scale(scale: 0.8)))
                            }
                            
                            // Success rate display
                            HStack(spacing: 16) {
                                VStack(spacing: 4) {
                                    Text("\(Int(calculatedSuccessRate))%")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                        .scaleEffect(showSuccessMessage ? 1.05 : 1.0)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showSuccessMessage)
                                    
                                    Text("Success Rate")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                // Success message
                                if showSuccessMessage {
                                    VStack(spacing: 4) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.black)
                                            .scaleEffect(showSuccessMessage ? 1.0 : 0.5)
                                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showSuccessMessage)
                                        
                                        Text("Ready!")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    .transition(.opacity.combined(with: .scale))
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                        
                        // User data summary - compact
                        VStack(spacing: 8) {
                            Text("Your Financial Profile")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            
                            VStack(spacing: 6) {
                                ProfileRow(title: "Income", value: formatCurrency(viewModel.monthlyIncome))
                                ProfileRow(title: "Expenses", value: formatCurrency(viewModel.monthlyExpenses))
                                ProfileRow(title: "Goal", value: formatCurrency(viewModel.budgetAmount))
                                ProfileRow(title: "Risk", value: viewModel.riskProfile.capitalized)
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 8)
                    
                    Spacer()
                    
                    // Continue button - always visible at bottom
                    Button(action: {
                        successHaptic()
                        viewModel.nextPage()
                    }) {
                        Text("Start My Journey")
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
        .onAppear {
            calculateSuccessRate()
            generateChartData()
            startAnimation()
        }
    }
    
    private func calculateSuccessRate() {
        // Calculate success rate based on user data
        let income = viewModel.monthlyIncome
        let expenses = viewModel.monthlyExpenses
        let goal = viewModel.budgetAmount
        
        // Basic calculation: (Income - Expenses) / Goal * 100
        let monthlySavings = max(0, income - expenses)
        let monthsToGoal = goal > 0 ? goal / monthlySavings : 0
        
        // Success rate based on how achievable the goal is
        if monthsToGoal <= 12 {
            calculatedSuccessRate = 95
        } else if monthsToGoal <= 24 {
            calculatedSuccessRate = 85
        } else if monthsToGoal <= 36 {
            calculatedSuccessRate = 75
        } else if monthsToGoal <= 60 {
            calculatedSuccessRate = 65
        } else {
            calculatedSuccessRate = 50
        }
    }
    
    private func generateChartData() {
        let income = viewModel.monthlyIncome
        let expenses = viewModel.monthlyExpenses
        let goal = viewModel.budgetAmount
        let monthlySavings = max(0, income - expenses)
        
        // Generate 12 months of projected data
        var data: [ChartDataPoint] = []
        var currentAmount: Double = 0
        
        for month in 0..<12 {
            currentAmount += monthlySavings
            let progress = min(currentAmount / goal, 1.0) * 100
            data.append(ChartDataPoint(
                month: month + 1,
                amount: currentAmount,
                progress: progress,
                isGoalReached: currentAmount >= goal
            ))
        }
        
        animatedChartData = data
    }
    
    private func startAnimation() {
        // Show chart first
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.8)) {
                showChart = true
            }
        }
        
        // Show success message after chart animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showSuccessMessage = true
            }
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// MARK: - Chart Data Point Model
struct ChartDataPoint: Identifiable {
    let id = UUID()
    let month: Int
    let amount: Double
    let progress: Double
    let isGoalReached: Bool
}

// MARK: - Animated Financial Chart Component
struct AnimatedFinancialChart: View {
    let data: [ChartDataPoint]
    let successRate: Double
    let geometry: GeometryProxy
    @State private var animatedProgress: [Double] = []
    @State private var showGoalLine = false
    @State private var showLine = false
    
    private let chartHeight: CGFloat = 120
    private let chartPadding: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 8) {
            // Chart container
            ZStack(alignment: .bottomLeading) {
                // Background grid
                VStack(spacing: 0) {
                    ForEach(0..<4) { _ in
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 1)
                        Spacer()
                    }
                }
                .frame(height: chartHeight)
                
                // Goal line
                if showGoalLine {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .offset(y: -chartHeight/2)
                        .transition(.opacity)
                }
                
                // Line chart
                if showLine {
                    LineChartView(
                        data: data,
                        animatedProgress: animatedProgress,
                        chartHeight: chartHeight,
                        chartPadding: chartPadding
                    )
                    .transition(.opacity)
                }
            }
            .frame(height: chartHeight)
            .padding(.horizontal, chartPadding)
            
            // X-axis labels
            HStack {
                Text("1")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("6")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("12")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, chartPadding)
            
            // Chart labels
            HStack {
                Text("Months")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("Goal: $\(Int(data.last?.amount ?? 0))")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, chartPadding)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        // Initialize animated progress
        animatedProgress = Array(repeating: 0, count: data.count)
        
        // Show line first
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showLine = true
            }
        }
        
        // Animate line points
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 1.5)) {
                animatedProgress = data.map { $0.progress }
            }
        }
        
        // Show goal line
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showGoalLine = true
            }
        }
    }
}

// MARK: - Line Chart View
struct LineChartView: View {
    let data: [ChartDataPoint]
    let animatedProgress: [Double]
    let chartHeight: CGFloat
    let chartPadding: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let chartWidth = geometry.size.width - (chartPadding * 2)
            let maxValue = data.map { $0.progress }.max() ?? 100
            // Minimum value is always 0 for progress
            
            ZStack {
                // Line path
                Path { path in
                    guard !data.isEmpty else { return }
                    
                    let stepX = chartWidth / CGFloat(data.count - 1)
                    
                    for (index, _) in data.enumerated() {
                        let x = CGFloat(index) * stepX
                        let progress = animatedProgress.indices.contains(index) ? animatedProgress[index] : 0
                        let y = chartHeight - (CGFloat(progress) / CGFloat(maxValue)) * chartHeight
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.6), Color.black]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                )
                
                // Data points
                ForEach(Array(data.enumerated()), id: \.element.id) { index, point in
                    let stepX = chartWidth / CGFloat(data.count - 1)
                    let x = CGFloat(index) * stepX
                    let progress = animatedProgress.indices.contains(index) ? animatedProgress[index] : 0
                    let y = chartHeight - (CGFloat(progress) / CGFloat(maxValue)) * chartHeight
                    
                    Circle()
                        .fill(point.isGoalReached ? Color.black : Color.gray.opacity(0.6))
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)
                        .scaleEffect(animatedProgress.indices.contains(index) && animatedProgress[index] > 0 ? 1.0 : 0.0)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(Double(index) * 0.1),
                            value: animatedProgress
                        )
                }
            }
        }
    }
}

// MARK: - Profile Row Component
struct ProfileRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    OnboardingView()
}
