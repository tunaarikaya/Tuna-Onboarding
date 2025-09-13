import SwiftUI
import UserNotifications
import OneSignalFramework

// MARK: - Notification Permission View
struct NotificationPermissionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isRequestingPermission = false
    @State private var permissionGranted = false
    @State private var showPermissionDenied = false
    
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
                        Text("Stay on Track")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text("Get personalized notifications to help you achieve your financial goals")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 40)
                    
                    // Benefits section
                    VStack(spacing: 24) {
                        // Notification benefits
                        VStack(spacing: 20) {
                            NotificationBenefitRow(
                                icon: "bell.badge.fill",
                                title: "Spending Alerts",
                                description: "Get notified when you're close to your budget limit"
                            )
                            
                            NotificationBenefitRow(
                                icon: "target",
                                title: "Goal Reminders",
                                description: "Stay motivated with daily progress updates"
                            )
                            
                            NotificationBenefitRow(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Smart Insights",
                                description: "Receive AI-powered financial tips and recommendations"
                            )
                            
                            NotificationBenefitRow(
                                icon: "calendar.badge.clock",
                                title: "Bill Reminders",
                                description: "Never miss important payment deadlines"
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Permission request section
                        VStack(spacing: 16) {
                            if permissionGranted {
                                // Success state
                                VStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(.green)
                                    
                                    Text("Notifications Enabled!")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    Text("You'll receive helpful reminders to stay on track with your financial goals")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                }
                                .padding(.vertical, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.green.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            } else if showPermissionDenied {
                                // Denied state
                                VStack(spacing: 12) {
                                    Image(systemName: "bell.slash.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(.orange)
                                    
                                    Text("Notifications Disabled")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    Text("You can enable notifications later in Settings if you change your mind")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                }
                                .padding(.vertical, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.orange.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            } else {
                                // Request permission button
                                Button(action: {
                                    requestNotificationPermission()
                                }) {
                                    HStack(spacing: 12) {
                                        if isRequestingPermission {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .scaleEffect(0.8)
                                        } else {
                                            Image(systemName: "bell.fill")
                                                .font(.system(size: 18, weight: .medium))
                                        }
                                        
                                        Text(isRequestingPermission ? "Requesting..." : "Enable Notifications")
                                            .font(.system(size: 18, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.black)
                                    )
                                }
                                .disabled(isRequestingPermission)
                                .animation(.easeInOut(duration: 0.2), value: isRequestingPermission)
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Continue button
                    Button(action: {
                        if permissionGranted {
                            successHaptic()
                        } else {
                            mediumHaptic()
                        }
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
        .onAppear {
            checkNotificationStatus()
        }
    }
    
    // MARK: - Private Methods
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    permissionGranted = true
                case .denied:
                    showPermissionDenied = true
                case .notDetermined:
                    // Show request button
                    break
                case .ephemeral:
                    permissionGranted = true
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func requestNotificationPermission() {
        mediumHaptic()
        isRequestingPermission = true
        
        // First request iOS notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                isRequestingPermission = false
                
                if granted {
                    permissionGranted = true
                    successHaptic()
                    
                    // Save notification preference
                    viewModel.notificationPreferences = true
                    UserDefaults.standard.set(true, forKey: "notificationPreferences")
                    
                    // Request OneSignal permission after iOS permission is granted
                    OneSignal.Notifications.requestPermission({ accepted in
                        print("OneSignal bildirim izni: \(accepted)")
                    }, fallbackToSettings: true)
                } else {
                    showPermissionDenied = true
                    warningHaptic()
                    
                    // Save notification preference
                    viewModel.notificationPreferences = false
                    UserDefaults.standard.set(false, forKey: "notificationPreferences")
                }
            }
        }
    }
}

// MARK: - Notification Benefit Row
struct NotificationBenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Preview
#Preview {
    NotificationPermissionView(viewModel: OnboardingViewModel())
}
