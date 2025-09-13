import Foundation
import SwiftUI

// Notification name extension for onboarding completion
extension Notification.Name {
    static let onboardingCompleted = Notification.Name("onboardingCompleted")
}

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var totalPages = 14 // Updated to include review request and premium features screen pages
    
    // User data collected during onboarding
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var birthDate: Date = Date()
    @Published var monthlyIncome: Double = 0
    @Published var monthlyExpenses: Double = 0
    @Published var financialGoals: [String] = []
    @Published var selectedCategories: [String] = []
    @Published var notificationPreferences: Bool = true
    @Published var budgetAmount: Double = 0
    @Published var riskProfile: String = ""
    @Published var isPremium: Bool = false
    @Published var referralCode: String = ""
    
    // Onboarding completion status
    @Published var isOnboardingCompleted: Bool = false
    
    func nextPage() {
        if currentPage < totalPages - 1 {
            currentPage += 1
        } else {
            completeOnboarding()
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
        // Save the collected data to UserDefaults
        saveOnboardingData()
    }
    
    private func saveOnboardingData() {
        // Save user data but don't mark onboarding as completed yet
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(userEmail, forKey: "userEmail")
        UserDefaults.standard.set(birthDate, forKey: "birthDate")
        UserDefaults.standard.set(monthlyIncome, forKey: "monthlyIncome")
        UserDefaults.standard.set(monthlyExpenses, forKey: "monthlyExpenses")
        UserDefaults.standard.set(financialGoals, forKey: "financialGoals")
        UserDefaults.standard.set(selectedCategories, forKey: "selectedCategories")
        UserDefaults.standard.set(notificationPreferences, forKey: "notificationPreferences")
        UserDefaults.standard.set(budgetAmount, forKey: "budgetAmount")
        UserDefaults.standard.set(riskProfile, forKey: "riskProfile")
    }
    
    func loadOnboardingData() {
        userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        birthDate = UserDefaults.standard.object(forKey: "birthDate") as? Date ?? Date()
        monthlyIncome = UserDefaults.standard.double(forKey: "monthlyIncome")
        monthlyExpenses = UserDefaults.standard.double(forKey: "monthlyExpenses")
        financialGoals = UserDefaults.standard.stringArray(forKey: "financialGoals") ?? []
        selectedCategories = UserDefaults.standard.stringArray(forKey: "selectedCategories") ?? []
        notificationPreferences = UserDefaults.standard.bool(forKey: "notificationPreferences")
        budgetAmount = UserDefaults.standard.double(forKey: "budgetAmount")
        riskProfile = UserDefaults.standard.string(forKey: "riskProfile") ?? ""
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")
        referralCode = UserDefaults.standard.string(forKey: "referralCode") ?? ""
    }
    
    // MARK: - Premium Status Management
    
    func setPremiumStatus(_ isPremium: Bool) {
        self.isPremium = isPremium
        UserDefaults.standard.set(isPremium, forKey: "isPremium")
    }
    
    func setReferralCode(_ code: String) {
        self.referralCode = code
        UserDefaults.standard.set(code, forKey: "referralCode")
    }
    
    func validateReferralCode(_ code: String, completion: @escaping (Bool) -> Void) {
        // Mock validation - in real app, this would be an API call
        let validCodes = ["tuna.2025", "tunafree25", "TUNAFREE25"]
        let isValid = validCodes.contains(code.uppercased()) || validCodes.contains(code.lowercased())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if isValid {
                self.setReferralCode(code)
                self.setPremiumStatus(true)
            }
            completion(isValid)
        }
    }
}
