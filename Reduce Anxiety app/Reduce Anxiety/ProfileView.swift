//
//  ChatsView.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 6/28/25.
//
import SwiftUI
import AppChatView
import AppMeditationAttention
import AppProgressModel
import UserNotifications


private struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let isDestructive: Bool

    init(title: String, value: String, isDestructive: Bool = false) {
        self.title = title
        self.value = value
        self.isDestructive = isDestructive
    }
}

struct ProfileView: View {
    let navigationTarget: String?
    let onNavigationTargetUsed: (() -> Void)?
    @State private var navigateToSettings = false
    @State private var selectedStub: String?
    @State private var navigateToRoutineEditor = false
    @State private var navigateToOptimalRoutine = false
    @State private var navigateToDownloads = false
    @State private var navigateToFavorites = false
    @State private var navigateToRecentlyPlayed = false
    @State private var navigateToReduceAnxietyMeditations = false
    @State private var navigateToGoodMood = false
    @State private var navigateToGetHappy = false
    @EnvironmentObject var progressModel: AppProgressModel
    
    init(navigationTarget: String? = nil, onNavigationTargetUsed: (() -> Void)? = nil) {
        self.navigationTarget = navigationTarget
        self.onNavigationTargetUsed = onNavigationTargetUsed
    }

    let routineCards = [
        ("Create Your Own Routine", "Get Started"),
        ("Optimal Routine", nil),
        ("Custom Routine", nil)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Custom Navigation Bar
                    HStack(alignment: .center) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .foregroundColor(.pink)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Dmitriy")
                                    .font(.title2.bold())
                                    .foregroundColor(.defaultWhite)
                                Text("Add my bio")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }

                        Spacer()

                        Button {
                            navigateToSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 65)

                    // Streak Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Streak")
                            .font(.title3.bold())
                            .padding(.horizontal)
                            .foregroundColor(.defaultWhite)

                        HStack {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.defaultWhite)
                            Text("0")
                                .font(.headline)
                                .foregroundColor(.defaultWhite)
                            Text("Pray today and start building a habit!")
                                .foregroundColor(.defaultWhite)
                                .font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.defaultWhite)
                        )
                        .padding(.horizontal)
                    }

                    // Create a Routine Section
                    VStack(alignment: .leading, spacing: 12) {
                                            Text("Create a Routine")
                                                .font(.title3.bold())
                                                .padding(.horizontal)
                                                .foregroundColor(.defaultWhite)

                        TabView {
                            ForEach(0..<routineCards.count, id: \.self) { i in
                                VStack(spacing: 16) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.blue)
                                        .frame(width: UIScreen.main.bounds.width - 40, height: 180)
                                        .overlay(
                                            VStack(spacing: 12) {
                                                Image(systemName: "calendar")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 48, height: 48)
                                                    .foregroundColor(.white)
                                                Text(routineCards[i].0)
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                                if let buttonText = routineCards[i].1 {
                                                    Button(buttonText) {
                                                        if i == 0 {
                                                            navigateToRoutineEditor = true
                                                        }
                                                    }
                                                    .padding(.horizontal, 24)
                                                    .padding(.vertical, 10)
                                                    .background(Color.white)
                                                    .foregroundColor(.black)
                                                    .clipShape(Capsule())
                                                }
                                            }
                                        )
                                        .onTapGesture {
                                            if i == 1 {
                                                navigateToOptimalRoutine = true
                                            }
                                        }
                                }
                                .frame(width: UIScreen.main.bounds.width - 40)
                            }
                        }
                        .frame(height: 200)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))

                                        }

                                        // Downloads Section
                                        VStack(alignment: .leading, spacing: 12) {
                                            HStack {
                                                Text("Downloads")
                                                    .font(.title3.bold())
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Button {
                                                    navigateToDownloads = true
                                                } label: {
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .padding(.horizontal)

                                            if progressModel.meditationManager.downloadedMeditations.isEmpty {
                                                TabView {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color.defaultAppGray)
                                                        .frame(width: UIScreen.main.bounds.width - 40, height: 180)
                                                        .overlay(
                                                            Image(systemName: "arrow.down.circle.fill")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 40, height: 40)
                                                                .foregroundColor(.white)
                                                        )
                                                        .padding(.horizontal, 20)
                                                }
                                                .frame(height: 200)
                                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                            } else {
                                                TabView {
                                                    ForEach(progressModel.meditationManager.downloadedMeditations.prefix(3)) { downloadedMeditation in
                                                        NavigationLink(destination: MeditationDetailView(meditation: downloadedMeditation.meditation)
                                                            .environmentObject(progressModel)) {
                                                            DownloadedMeditationCard(meditation: downloadedMeditation.meditation)
                                                        }
                                                        .buttonStyle(PlainButtonStyle())
                                                    }
                                                }
                                                .frame(height: 200)
                                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                            }
                                        }

                                        // Recently Played Section
                                        VStack(alignment: .leading, spacing: 12) {
                                            HStack {
                                                Text("Recently played")
                                                    .font(.title3.bold())
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Button {
                                                    navigateToRecentlyPlayed = true
                                                } label: {
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .padding(.horizontal)

                                            if progressModel.meditationManager.recentlyPlayedMeditations.isEmpty {
                                                TabView {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color.defaultAppGray)
                                                        .frame(width: UIScreen.main.bounds.width - 40, height: 180)
                                                        .overlay(
                                                            Image(systemName: "clock.fill")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 40, height: 40)
                                                                .foregroundColor(.white)
                                                        )
                                                        .padding(.horizontal, 20)
                                                }
                                                .frame(height: 200)
                                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                            } else {
                                                TabView {
                                                    ForEach(progressModel.meditationManager.recentlyPlayedMeditations.prefix(3)) { meditation in
                                                        NavigationLink(destination: MeditationDetailView(meditation: meditation)
                                                            .environmentObject(progressModel)) {
                                                            DownloadedMeditationCard(meditation: meditation)
                                                        }
                                                        .buttonStyle(PlainButtonStyle())
                                                    }
                                                }
                                                .frame(height: 200)
                                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                            }
                                        }

                                        // Favorites Section
                                        VStack(alignment: .leading, spacing: 12) {
                                            HStack {
                                                Text("Your favorite practices")
                                                    .font(.title3.bold())
                                                    .foregroundColor(.defaultWhite)
                                                Spacer()
                                                Button {
                                                    navigateToFavorites = true
                                                } label: {
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .padding(.horizontal)

                                            if progressModel.meditationManager.favoriteMeditations.isEmpty {
                                                TabView {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color.defaultAppGray)
                                                        .frame(width: UIScreen.main.bounds.width - 40, height: 180)
                                                        .overlay(
                                                            Image(systemName: "star.fill")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 40, height: 40)
                                                                .foregroundColor(.defaultAppWhite)
                                                        )
                                                        .padding(.horizontal, 20)
                                                }
                                                .frame(height: 200)
                                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                            } else {
                                                TabView {
                                                    ForEach(progressModel.meditationManager.favoriteMeditations.prefix(3)) { meditation in
                                                        NavigationLink(destination: MeditationDetailView(meditation: meditation)
                                                            .environmentObject(progressModel)) {
                                                            DownloadedMeditationCard(meditation: meditation)
                                                        }
                                                        .buttonStyle(PlainButtonStyle())
                                                    }
                                                }
                                                .frame(height: 200)
                                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                            }
                                        }

                                        Spacer().frame(height: 40)
                                    }
                                }
            .background(Color.defaultAppDark.ignoresSafeArea())
                                .edgesIgnoringSafeArea(.top)
                                .navigationDestination(isPresented: $navigateToRoutineEditor) {
                                    EditYourRoutineView()
                                }
                                .navigationDestination(isPresented: $navigateToOptimalRoutine) {
                                    OptimalRoutineView()
                                }
                                .navigationDestination(isPresented: $navigateToDownloads) {
                                    DownloadsView()
                                        .environmentObject(progressModel)
                                }
                                .navigationDestination(isPresented: $navigateToFavorites) {
                                    PlaceholderView(title: "Favorites")
                                        .environmentObject(progressModel)
                                }
                                .navigationDestination(isPresented: $navigateToRecentlyPlayed) {
                                    PlaceholderView(title: "Recently Played")
                                        .environmentObject(progressModel)
                                }
                                .navigationDestination(isPresented: $navigateToSettings) {
                                    SettingsMainView()
                                }
                                .navigationDestination(isPresented: $navigateToReduceAnxietyMeditations) {
                                    MeditationCategoryView(
                                        title: "Reduce anxiety meditations",
                                        meditations: [getMeditationByTitle("Love to body")]
                                    )
                                    .environmentObject(progressModel)
                                    .onDisappear {
                                        if navigateToReduceAnxietyMeditations {
                                            onNavigationTargetUsed?()
                                        }
                                    }
                                }
                                .navigationDestination(isPresented: $navigateToGoodMood) {
                                    MeditationCategoryView(
                                        title: "Good mood",
                                        meditations: [getMeditationByTitle("Best sides of yourself")]
                                    )
                                    .environmentObject(progressModel)
                                    .onDisappear {
                                        if navigateToGoodMood {
                                            onNavigationTargetUsed?()
                                        }
                                    }
                                }
                                .navigationDestination(isPresented: $navigateToGetHappy) {
                                    MeditationCategoryView(
                                        title: "Get happy",
                                        meditations: [getMeditationByTitle("Santosha")]
                                    )
                                    .environmentObject(progressModel)
                                    .onDisappear {
                                        if navigateToGetHappy {
                                            onNavigationTargetUsed?()
                                        }
                                    }
                                }
                                .navigationDestination(item: $selectedStub) { title in
                                    StubView(title: title)
                                }
                                .onAppear {
                                    // Handle navigation target from meditation alerts
                                    if let target = navigationTarget {
                                        // Add a small delay to ensure the view is fully loaded
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            switch target {
                                            case "favorites":
                                                navigateToFavorites = true
                                            case "downloads":
                                                navigateToDownloads = true
                                            case "routine":
                                                navigateToRoutineEditor = true
                                            case "recents":
                                                navigateToRecentlyPlayed = true
                                            case "reduceanxietymeditations":
                                                navigateToReduceAnxietyMeditations = true
                                            case "goodmood":
                                                navigateToGoodMood = true
                                            case "gethappy":
                                                navigateToGetHappy = true
                                            default:
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Для поддержки .navigationDestination(item:)
                    extension String: @retroactive Identifiable {
                        public var id: String { self }
                    }

struct StubView: View {
    let title: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text("\(title) Screen")
                .font(.title)
                .bold()
            Button("Go Back") {
                dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
    }
}
//#Preview {
//    StatefulPreviewWrapper(false) { binding in
//        ProfileView(binding)
//    }
//}

struct SettingsMainView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showLogoutAlert = false
    @StateObject private var themeManager = ThemeManager.shared

    private let userName = "Dmitriy"
    private let userEmail = "your@email.com"

    private let settingsItems: [SettingsItem] = [
        .init(title: "General", value: "General"),
        .init(title: "Contact & Support", value: "Support"),
        .init(title: "Subscribe", value: "Subscribe"),
        .init(title: "Gift Hallow", value: "Gift"),
        .init(title: "Legal", value: "Legal"),
        .init(title: "Onboarding", value: "Onboarding"),
        .init(title: "Log Out", value: "Logout", isDestructive: true)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Custom Back Button + Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .padding(12)
                        .background(Color.defaultGray)
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 50)

            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Settings")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            // Crescent moon icon - color changes based on theme
                            Image(systemName: "moon.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(themeManager.selectedTheme == .dark ? .black : .white)
                        }

                        HStack(spacing: 16) {
                            Image("avatarPlaceholder")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(userName)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)

                                Text(userEmail)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color.defaultAppGray)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    VStack(spacing: 1) {
                        ForEach(settingsItems) { item in
                            if item.value == "Logout" {
                                Button {
                                    showLogoutAlert = true
                                } label: {
                                    settingsRow(for: item)
                                }
                            } else {
                                NavigationLink(destination: destinationView(for: item.value)) {
                                    settingsRow(for: item)
                                }
                            }
                        }
                    }
                    .background(Color.defaultAppGray)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.top, 20)
            }

            Text("v12.2.0 (8310) | \(userEmail)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .padding(.top, 8)
                .padding(.bottom, 20)
        }
        .background(Color.defaultAppDark.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Yes", role: .destructive) {}
            Button("No", role: .cancel) {}
        } message: {
            Text("Are you sure you want to logout?")
        }
        .onAppear {
            print("Main view")
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func destinationView(for value: String) -> some View {
        switch value {
        case "General":
            GeneralSettingsView()
        case "Support":
            ContactSupportView()
        case "Gift":
            GiftHallowView()
        case "Legal":
            LegalView()
        case "Subscribe":
            PlaceholderView(title: "Subscribe")
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func settingsRow(for item: SettingsItem) -> some View {
        HStack {
            Text(item.title)
                .foregroundColor(item.isDestructive ? .red : .white)
                .font(.system(size: 16, weight: .bold))
            Spacer()
            if !item.isDestructive {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.defaultDark)
    }
}
struct GeneralSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var navigateToThemes = false
    @State private var navigateToStreaks = false
    @State private var navigateToNotifications = false
    @State private var navigateToLanguage = false

    let settings = [
        "Switch Theme", "Notification Settings", "Privacy",
        "Language", "Location", "Streaks"
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Custom header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .padding(8)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                Text("General")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()

            // Settings list
            VStack(spacing: 1) {
                ForEach(settings, id: \.self) { setting in
                    Button(action: {
                        switch setting {
                        case "Switch Theme":
                            navigateToThemes = true
                        case "Streaks":
                            navigateToStreaks = true
                        case "Notification Settings":
                            navigateToNotifications = true
                        case "Language":
                            navigateToLanguage = true
                        default:
                            break
                        }
                    }) {
                        HStack {
                            Text(setting)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.defaultDark)
                    }
                }
            }
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
            .padding()

            Spacer()
        }
        .background(Color.defaultAppDark.ignoresSafeArea())
        .navigationDestination(isPresented: $navigateToThemes) {
            ThemesView()
        }
        .navigationDestination(isPresented: $navigateToStreaks) {
            StreaksView()
        }
        .navigationDestination(isPresented: $navigateToNotifications) {
            NotificationSettingsView()
        }
        .navigationDestination(isPresented: $navigateToLanguage) {
            LanguageView()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct GiftHallowView: View {
    @Environment(\.dismiss) var dismiss
    @State private var count = 1

    var body: some View {
        VStack(spacing: 0) {
            // Custom header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .padding(8)
                        .background(Color.defaultGray)
                        .clipShape(Circle())
                }
                Text("Gift Hallow")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()

            // Content
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("For Friends & Family")
                            .font(.headline)
                            .foregroundColor(.white)

                        Text("Give a 1-year gift subscription.")
                            .foregroundColor(.gray)

                        HStack {
                            Button("-") { if count > 1 { count -= 1 } }
                                .padding(.horizontal)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())

                            Text("\(count)")
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            Button("+") { count += 1 }
                                .padding(.horizontal)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())

                            Spacer()
                            Text("Total $\(count * 6999 / 100)")
                                .foregroundColor(.white)
                        }

                        Button("Checkout") {}
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(16)
                }
                .padding()
            }
        }
        .background(Color.defaultAppDark.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct ContactSupportView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Custom header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .padding(8)
                        .background(Color.defaultGray)
                        .clipShape(Circle())
                }
                Text("Contact & Support")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            
            VStack(spacing: 16) {
                Text("Hi Dmitriy 👋\nHow can we help?")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                VStack(spacing: 1) {
                    ForEach(["Search for help", "How do I cancel my subscription or free trial?", "How can I tell if I'm subscribed?"], id: \.self) { item in
                        HStack {
                            Text(item)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.defaultAppGray)
                    }
                }
                .background(Color.defaultAppGray)
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .background(Color.defaultAppDark.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct LegalView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Custom header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .padding(8)
                        .background(Color.defaultGray)
                        .clipShape(Circle())
                }
                Text("Legal")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            
            // Table content
            VStack(spacing: 1) {
                ForEach(["Privacy Policy", "Terms of Service", "Copyright Info"], id: \.self) { title in
                    NavigationLink(value: title) {
                        HStack {
                            Text(title)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.defaultAppGray)
                    }
                }
            }
            .background(Color.defaultAppGray)
            .cornerRadius(12)
            .padding()

            Spacer()
        }
        .background(Color.defaultAppDark.ignoresSafeArea())
        .navigationDestination(for: String.self) { value in
            PlaceholderView(title: value)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
struct PlaceholderView: View {
    let title: String

    var body: some View {
        Text("\(title) Screen")
            .font(.largeTitle)
            .bold()
            .padding()
    }
}

// MARK: - Settings Manager
@MainActor
class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    @Published var showStreaks: Bool = true
    
    private init() {
        loadSettings()
    }
    
    func setShowStreaks(_ show: Bool) {
        showStreaks = show
        saveSettings()
    }
    
    private func loadSettings() {
        showStreaks = UserDefaults.standard.object(forKey: "showStreaks") as? Bool ?? true
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(showStreaks, forKey: "showStreaks")
    }
}

// MARK: - Theme Manager
@MainActor
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var selectedTheme: ThemeOption = .matchDevice
    
    enum ThemeOption: String, CaseIterable {
        case light = "Light Mode"
        case dark = "Dark Mode"
        case matchDevice = "Match Device"
        
        var description: String {
            switch self {
            case .light:
                return "Change the appearance of the app to a lighter theme."
            case .dark:
                return "Change the appearance of the app to a darker theme."
            case .matchDevice:
                return "Appearance of app matches the OS theme."
            }
        }
    }
    
    private init() {
        loadTheme()
    }
    
    func setTheme(_ theme: ThemeOption) {
        selectedTheme = theme
        saveTheme()
        applyTheme()
    }
    
    private func loadTheme() {
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = ThemeOption(rawValue: savedTheme) {
            selectedTheme = theme
        }
        applyTheme()
    }
    
    private func saveTheme() {
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
    }
    
    private func applyTheme() {
        switch selectedTheme {
        case .light:
            // Force light mode
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        case .dark:
            // Force dark mode
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        case .matchDevice:
            // Use system appearance
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
    }
}

// MARK: - Themes View
struct ThemesView: View {
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom header
            HStack {
                Text("Themes")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            
            // Theme options
            VStack(spacing: 1) {
                ForEach(ThemeManager.ThemeOption.allCases, id: \.self) { theme in
                    Button(action: {
                        themeManager.setTheme(theme)
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(theme.rawValue)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text(theme.description)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                            
                            Spacer()
                            
                            // Radio button
                            ZStack {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                
                                if themeManager.selectedTheme == theme {
                                    Circle()
                                        .fill(Color.purple)
                                        .frame(width: 12, height: 12)
                                }
                            }
                        }
                        .padding()
                        .background(Color.defaultAppGray)
                    }
                }
            }
            .cornerRadius(12)
            .padding()
            
            Spacer()
        }
        .background(Color.defaultAppDark.ignoresSafeArea())
    }
}

// MARK: - Streaks View
struct StreaksView: View {
    @StateObject private var settingsManager = SettingsManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom header
            HStack {
                Text("Streaks")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            
            // Streaks toggle
            VStack(spacing: 1) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Show Streaks")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Display the number of consecutive days you've prayed on Hallow.")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    
                    Spacer()
                    
                    // Toggle switch
                    Toggle("", isOn: Binding(
                        get: { settingsManager.showStreaks },
                        set: { settingsManager.setShowStreaks($0) }
                    ))
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                }
                .padding()
                .background(Color.defaultAppGray)
            }
            .cornerRadius(12)
            .padding()
            
            Spacer()
        }
        .background(Color.defaultAppDark.ignoresSafeArea())
    }
}

// MARK: - Notification Settings View
struct NotificationSettingsView: View {
    @State private var dailyQuote: Bool = false
    @State private var campaigns: Bool = true
    @State private var notificationsEnabled: Bool = true
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom header
            HStack {
                Text("Notification Settings")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            
            // Notification toggles
            VStack(spacing: 1) {
                // Off Notifications
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Off Notifications")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Prevent the application from sending local notifications. Enabling this will allow them to be sent again.")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $notificationsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .red))
                        .onChange(of: notificationsEnabled) { enabled in
                            if enabled {
                                // Re-enable notifications
                                notificationManager.requestNotificationPermission()
                            } else {
                                // Disable notifications by removing all pending ones
                                notificationManager.removeMeditationNotifications()
                            }
                        }
                }
                .padding()
                .background(Color.defaultAppGray)
                
                // Daily Quote
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Daily Quote")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Allow Hallow to send you a daily quote to inspire and reflect on the words of scripture, saints and theologians.")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $dailyQuote)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                }
                .padding()
                .background(Color.defaultAppGray)
                
                // Campaigns
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Campaigns")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Allow Hallow to send you reminders to keep up with campaigns you join and get updates on those you create.")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $campaigns)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                }
                .padding()
                .background(Color.defaultAppGray)
            }
            .cornerRadius(12)
            .padding()
            
            Spacer()
        }
        .background(Color.defaultAppDark.ignoresSafeArea())
    }
}

// MARK: - Language View
struct LanguageView: View {
    @State private var selectedLanguage: String = "English"
    
    let languages = [
        ("English", "Default"),
        ("Deutsch", nil),
        ("English + Filipino", nil),
        ("Español", nil),
        ("Français", nil),
        ("Italiano", nil),
        ("Polski", nil),
        ("Português", nil)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom header
            HStack {
                Text("Language")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Suggested Languages section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Suggested Languages")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal)
                        
                        VStack(spacing: 1) {
                            ForEach(Array(languages.prefix(1).enumerated()), id: \.offset) { index, language in
                                Button(action: {
                                    selectedLanguage = language.0
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(language.0)
                                                .foregroundColor(.white)
                                                .font(.system(size: 16, weight: .medium))
                                            
                                            if let subtitle = language.1 {
                                                Text(subtitle)
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 14))
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        if selectedLanguage == language.0 {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.purple)
                                                .font(.system(size: 16, weight: .medium))
                                        }
                                        
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14))
                                    }
                                    .padding()
                                    .background(Color.defaultAppGray)
                                }
                            }
                        }
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        Text("Hallow will use the first language that it supports from Language & Region settings. You can select a different language for Hallow to use if you prefer.")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                            .padding(.horizontal)
                    }
                    
                    // Other Languages section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Other Languages")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal)
                            .padding(.top, 20)
                        
                        VStack(spacing: 1) {
                            ForEach(Array(languages.dropFirst().enumerated()), id: \.offset) { index, language in
                                Button(action: {
                                    selectedLanguage = language.0
                                }) {
                                    HStack {
                                        Text(language.0)
                                            .foregroundColor(.white)
                                            .font(.system(size: 16, weight: .medium))
                                        
                                        Spacer()
                                        
                                        if selectedLanguage == language.0 {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.purple)
                                                .font(.system(size: 16, weight: .medium))
                                        }
                                    }
                                    .padding()
                                    .background(Color.defaultAppGray)
                                }
                            }
                        }
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .background(Color.defaultAppDark.ignoresSafeArea())
    }
}

#Preview {
    SettingsMainView()
}

import SwiftUI

// MARK: - EditYourRoutineView
struct EditYourRoutineView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showTimePicker = false
    @State private var selectedTime = Date()
    @State private var showMeditationsView = false
    @State private var routineMeditations: [Meditation] = []
    @State private var showTimeCarousel = false
    @StateObject private var notificationManager = NotificationManager.shared
    
    // Sample suggested meditations - using the unified model
    let suggestedMeditations = Meditation.allMeditations.filter { meditation in
        !Meditation.coreMeditations.contains { $0.id == meditation.id }
    }.prefix(4).map { $0 }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    Spacer()
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.defaultAppWhite)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Title
                Text("Edit Your Routine")
                    .font(.title2.bold())
                    .foregroundColor(.defaultAppWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                
                // Time Block and Delete Block
                HStack(spacing: 12) {
                    // Time Block (half width)
                    HStack {
                        Button(action: { showTimeCarousel.toggle() }) {
                            HStack(spacing: 8) {
                                Text(timeString(from: selectedTime))
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.defaultAppWhite)
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.defaultAppWhite)
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: notificationManager.authorizationStatus == .authorized ? "bell.fill" : "bell.slash")
                            .foregroundColor(notificationManager.authorizationStatus == .authorized ? .green : .red)
                            .font(.system(size: 20))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.defaultAppGray)
                    .cornerRadius(12)
                    
                    // Delete Block Button (half width)
                    Button("Delete Block") {
                        // Handle delete routine
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.defaultAppGray)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Routine Meditations
                if !routineMeditations.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Routine")
                            .font(.title3.bold())
                            .foregroundColor(.defaultAppWhite)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(routineMeditations) { meditation in
                                RoutineMeditationRow(meditation: meditation) {
                                    removeMeditationFromRoutine(meditation)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Add Session Button
                Button(action: { showMeditationsView = true }) {
                    HStack(spacing: 16) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.defaultAppWhite)
                            .frame(width: 24, height: 24)
                        
                        Text("Add Session")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.defaultAppWhite)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.defaultAppGray)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Suggested Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Suggested")
                        .font(.title3.bold())
                        .foregroundColor(.defaultAppWhite)
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 12) {
                        ForEach(suggestedMeditations) { meditation in
                            SuggestedMeditationRow(meditation: meditation) {
                                addMeditationToRoutine(meditation)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .background(Color.defaultAppDark.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showMeditationsView) {
            TopRoutineResultsView(selectedMeditations: $routineMeditations)
        }
        .sheet(isPresented: $showTimeCarousel) {
            TimePickerCarousel(selectedTime: $selectedTime, isPresented: $showTimeCarousel)
        }
        .onAppear {
            if notificationManager.authorizationStatus == .notDetermined {
                notificationManager.requestNotificationPermission()
            }
        }
        .onChange(of: selectedTime) { newTime in
            // Schedule notification when time changes
            if notificationManager.authorizationStatus == .authorized {
                notificationManager.scheduleMeditationNotification(at: newTime)
            }
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func addMeditationToRoutine(_ meditation: Meditation) {
        if !routineMeditations.contains(where: { $0.id == meditation.id }) {
            routineMeditations.append(meditation)
        }
    }
    
    private func removeMeditationFromRoutine(_ meditation: Meditation) {
        routineMeditations.removeAll { $0.id == meditation.id }
    }
}

// MARK: - SuggestedMeditationRow
struct SuggestedMeditationRow: View {
    let meditation: Meditation
    let onAdd: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Meditation Icon
            Circle()
                .fill(meditationIconColor(for: meditation.title))
                .frame(width: 50, height: 50)
                .overlay(
                    meditationIcon(for: meditation.title)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meditation.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.defaultAppWhite)
                
                Text(meditation.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button("Add") {
                onAdd()
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.defaultAppWhite)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.defaultAppGray)
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.defaultAppGray)
        .cornerRadius(12)
    }
    
    private func meditationIconColor(for title: String) -> Color {
        switch title {
        case "Daily Trivia":
            return .purple
        case "The Word":
            return .blue
        case "Daily Rosary":
            return .brown
        case "Divine Revelation":
            return .orange
        default:
            return .gray
        }
    }
    
    private func meditationIcon(for title: String) -> some View {
        switch title {
        case "Daily Trivia":
            return Image(systemName: "questionmark.circle")
        case "The Word":
            return Image(systemName: "textformat.abc")
        case "Daily Rosary":
            return Image(systemName: "cross")
        case "Divine Revelation":
            return Image(systemName: "book")
        default:
            return Image(systemName: "heart")
        }
    }
}

// MARK: - OptimalRoutineView
struct OptimalRoutineView: View {
    @State private var showTimePicker = false
    @State private var selectedTime = Date()

    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.purple)
                .frame(height: 200)
                .padding(.horizontal)

            Text("This is a sample optimal routine description.")
                .font(.system(size: 15))
                .foregroundColor(.black)
                .padding(.horizontal)

            Button("Add to your routine") {
                // Add logic later
            }
            .font(.system(size: 17, weight: .semibold))
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)

            Button(action: { showTimePicker.toggle() }) {
                Text(timeString(from: selectedTime))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
            }

            if showTimePicker {
                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
            }

            Spacer()
        }
    }

    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - NotificationsView
struct NotificationsView: View {
    var body: some View {
        VStack {
            Text("Notifications")
                .font(.largeTitle.bold())
                .foregroundColor(.black)
                .padding()
            Spacer()
        }
        .background(Color.white)
    }
}

// MARK: - RoutineMeditationRow
struct RoutineMeditationRow: View {
    let meditation: Meditation
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Meditation Icon
            Circle()
                .fill(meditationIconColor(for: meditation.title))
                .frame(width: 40, height: 40)
                .overlay(
                    meditationIcon(for: meditation.title)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(meditation.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.defaultAppWhite)
                
                Text(meditation.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button("Remove") {
                onRemove()
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.red)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.defaultAppGray)
            .cornerRadius(6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.defaultAppGray)
        .cornerRadius(12)
    }
    
    private func meditationIconColor(for title: String) -> Color {
        switch title {
        case "Love to body":
            return .pink
        case "Daily Trivia":
            return .purple
        case "The Word":
            return .blue
        case "Daily Rosary":
            return .brown
        case "Divine Revelation":
            return .orange
        case "Rosary":
            return .indigo
        case "Daily Reflections":
            return .green
        case "Daily Gospel":
            return .defaultSelected
        case "Morning Psalms":
            return .cyan
        case "Daily Mass Readings":
            return .mint
        case "Daily Saint":
            return .red
        case "Gospel of Matthew":
            return .teal
        default:
            return .gray
        }
    }
    
    private func meditationIcon(for title: String) -> some View {
        switch title {
        case "Love to body":
            return Image(systemName: "heart.fill")
        case "Daily Trivia":
            return Image(systemName: "questionmark.circle")
        case "The Word":
            return Image(systemName: "textformat.abc")
        case "Daily Rosary":
            return Image(systemName: "cross")
        case "Divine Revelation":
            return Image(systemName: "book")
        case "Rosary":
            return Image(systemName: "pray")
        case "Daily Reflections":
            return Image(systemName: "lightbulb")
        case "Daily Gospel":
            return Image(systemName: "book.closed")
        case "Morning Psalms":
            return Image(systemName: "sunrise")
        case "Daily Mass Readings":
            return Image(systemName: "book.pages")
        case "Daily Saint":
            return Image(systemName: "person.2")
        case "Gospel of Matthew":
            return Image(systemName: "scroll")
        default:
            return Image(systemName: "heart")
        }
    }
}

// MARK: - TopRoutineResultsView (MeditationsView)
struct TopRoutineResultsView: View {
    @Binding var selectedMeditations: [Meditation]
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    // Using the unified meditation model
    let allMeditations = Meditation.allMeditations
    
    var filteredMeditations: [Meditation] {
        if searchText.isEmpty {
            return allMeditations
        } else {
            return allMeditations.filter { meditation in
                meditation.title.localizedCaseInsensitiveContains(searchText) ||
                meditation.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.defaultAppWhite)
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Text("Top Routine Results")
                        .font(.title3.bold())
                        .foregroundColor(.defaultAppWhite)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.defaultAppWhite)
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search meditations...", text: $searchText)
                        .foregroundColor(.defaultAppWhite)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.defaultAppGray)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Meditations List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredMeditations) { meditation in
                            MeditationRow(meditation: meditation) {
                                addMeditationToRoutine(meditation)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 100) // Add bottom padding for better scrolling
                }
            }
            .background(Color.defaultAppDark.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    private func addMeditationToRoutine(_ meditation: Meditation) {
        if !selectedMeditations.contains(where: { $0.id == meditation.id }) {
            selectedMeditations.append(meditation)
        }
    }
}

// MARK: - MeditationRow
struct MeditationRow: View {
    let meditation: Meditation
    let onAdd: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Meditation Icon
            Circle()
                .fill(meditationIconColor(for: meditation.title))
                .frame(width: 50, height: 50)
                .overlay(
                    meditationIcon(for: meditation.title)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meditation.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.defaultAppWhite)
                
                Text(meditation.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button("Add") {
                onAdd()
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.defaultAppWhite)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.defaultAppGray)
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.defaultAppGray)
        .cornerRadius(12)
    }
    
    private func meditationIconColor(for title: String) -> Color {
        switch title {
        case "Love to body":
            return .pink
        case "Daily Trivia":
            return .purple
        case "The Word":
            return .blue
        case "Daily Rosary":
            return .brown
        case "Divine Revelation":
            return .orange
        case "Rosary":
            return .indigo
        case "Daily Reflections":
            return .green
        case "Daily Gospel":
            return .defaultSelected
        case "Morning Psalms":
            return .cyan
        case "Daily Mass Readings":
            return .mint
        case "Daily Saint":
            return .red
        case "Gospel of Matthew":
            return .teal
        default:
            return .gray
        }
    }
    
    private func meditationIcon(for title: String) -> some View {
        switch title {
        case "Love to body":
            return Image(systemName: "heart.fill")
        case "Daily Trivia":
            return Image(systemName: "questionmark.circle")
        case "The Word":
            return Image(systemName: "textformat.abc")
        case "Daily Rosary":
            return Image(systemName: "cross")
        case "Divine Revelation":
            return Image(systemName: "book")
        case "Rosary":
            return Image(systemName: "pray")
        case "Daily Reflections":
            return Image(systemName: "lightbulb")
        case "Daily Gospel":
            return Image(systemName: "book.closed")
        case "Morning Psalms":
            return Image(systemName: "sunrise")
        case "Daily Mass Readings":
            return Image(systemName: "book.pages")
        case "Daily Saint":
            return Image(systemName: "person.2")
        case "Gospel of Matthew":
            return Image(systemName: "scroll")
        default:
            return Image(systemName: "heart")
        }
    }
}

// MARK: - TimePickerCarousel
struct TimePickerCarousel: View {
    @Binding var selectedTime: Date
    @Binding var isPresented: Bool
    @State private var tempTime: Date
    @StateObject private var notificationManager = NotificationManager.shared
    
    init(selectedTime: Binding<Date>, isPresented: Binding<Bool>) {
        self._selectedTime = selectedTime
        self._isPresented = isPresented
        self._tempTime = State(initialValue: selectedTime.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .foregroundColor(.defaultAppWhite)
                
                Spacer()
                
                Text("Select Time")
                    .font(.headline)
                    .foregroundColor(.defaultAppWhite)
                
                Spacer()
                
                Button("Done") {
                    selectedTime = tempTime
                    // Schedule notification for the new time
                    if notificationManager.authorizationStatus == .authorized {
                        notificationManager.scheduleMeditationNotification(at: tempTime)
                    }
                    isPresented = false
                }
                .foregroundColor(.defaultAppWhite)
                .fontWeight(.semibold)
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Time Picker
            DatePicker("", selection: $tempTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .colorScheme(.dark)
                .padding(.horizontal)
            
            Spacer()
        }
        .background(Color.defaultAppDark.ignoresSafeArea())
    }
}

// MARK: - DownloadedMeditationCard
struct DownloadedMeditationCard: View {
    let meditation: Meditation
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.defaultAppGray)
            .frame(width: UIScreen.main.bounds.width - 40, height: 180)
            .overlay(
                VStack(spacing: 12) {
                    // Meditation Icon
                    Circle()
                        .fill(meditationIconColor(for: meditation.title))
                        .frame(width: 60, height: 60)
                        .overlay(
                            meditationIcon(for: meditation.title)
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                        )
                    
                    VStack(spacing: 4) {
                        Text(meditation.title)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(meditation.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
                .padding()
            )
            .padding(.horizontal, 20)
    }
    
    private func meditationIconColor(for title: String) -> Color {
        switch title {
        case "Love to body":
            return .pink
        case "Best sides of yourself":
            return .blue
        case "Santosha":
            return .green
        case "Focus mind meditation":
            return .purple
        case "Daily Trivia":
            return .purple
        case "The Word":
            return .blue
        case "Daily Rosary":
            return .brown
        case "Divine Revelation":
            return .orange
        case "Rosary":
            return .indigo
        case "Daily Reflections":
            return .green
        case "Daily Gospel":
            return .defaultSelected
        case "Morning Psalms":
            return .cyan
        case "Daily Mass Readings":
            return .mint
        case "Daily Saint":
            return .red
        case "Gospel of Matthew":
            return .teal
        default:
            return .gray
        }
    }
    
    private func meditationIcon(for title: String) -> some View {
        switch title {
        case "Love to body":
            return Image(systemName: "heart.fill")
        case "Best sides of yourself":
            return Image(systemName: "star.fill")
        case "Santosha":
            return Image(systemName: "leaf.fill")
        case "Focus mind meditation":
            return Image(systemName: "brain.head.profile")
        case "Daily Trivia":
            return Image(systemName: "questionmark.circle")
        case "The Word":
            return Image(systemName: "textformat.abc")
        case "Daily Rosary":
            return Image(systemName: "cross")
        case "Divine Revelation":
            return Image(systemName: "book")
        case "Rosary":
            return Image(systemName: "pray")
        case "Daily Reflections":
            return Image(systemName: "lightbulb")
        case "Daily Gospel":
            return Image(systemName: "book.closed")
        case "Morning Psalms":
            return Image(systemName: "sunrise")
        case "Daily Mass Readings":
            return Image(systemName: "book.pages")
        case "Daily Saint":
            return Image(systemName: "person.2")
        case "Gospel of Matthew":
            return Image(systemName: "scroll")
        default:
            return Image(systemName: "heart")
        }
    }
}

// MARK: - DownloadsView
struct DownloadsView: View {
    @EnvironmentObject var progressModel: AppProgressModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedMeditation: Meditation?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.defaultAppWhite)
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Text("Downloads")
                        .font(.title2.bold())
                        .foregroundColor(.defaultAppWhite)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.clear)
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                if progressModel.meditationManager.downloadedMeditations.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "arrow.down.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        Text("No Downloads Yet")
                            .font(.title2.bold())
                            .foregroundColor(.defaultAppWhite)
                        
                        Text("Download meditations to listen offline")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Downloads list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(progressModel.meditationManager.downloadedMeditations) { downloadedMeditation in
                                DownloadedMeditationRow(
                                    meditation: downloadedMeditation.meditation,
                                    onDelete: {
                                        progressModel.meditationManager.removeDownloadedMeditation(downloadedMeditation.meditation)
                                    },
                                    onTap: {
                                        selectedMeditation = downloadedMeditation.meditation
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                }
            }
            .background(Color.defaultAppDark.ignoresSafeArea())
            .navigationBarHidden(true)
            .navigationDestination(item: $selectedMeditation) { meditation in
                MeditationDetailView(meditation: meditation)
                    .environmentObject(progressModel)
            }
        }
    }
}

// MARK: - DownloadedMeditationRow
struct DownloadedMeditationRow: View {
    let meditation: Meditation
    let onDelete: () -> Void
    let onTap: () -> Void
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Delete button background (only visible when swiped)
            HStack {
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 60, height: 60)
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .opacity(offset < -20 ? 1 : 0)
            }
            .padding(.trailing, 16)
            
            // Main content
            HStack(spacing: 16) {
                // Meditation Icon
                Circle()
                    .fill(meditationIconColor(for: meditation.title))
                    .frame(width: 50, height: 50)
                    .overlay(
                        meditationIcon(for: meditation.title)
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(meditation.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.defaultAppWhite)
                    
                    Text(meditation.subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Duration if available
                if let duration = meditation.duration {
                    Text("\(duration) min")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.defaultAppGray)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.defaultAppGray)
            .cornerRadius(12)
            .offset(x: offset)
            .onTapGesture {
                onTap()
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offset = max(value.translation.width, -80)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width < -40 {
                                offset = -80
                            } else {
                                offset = 0
                            }
                        }
                    }
            )
        }
    }
    
    private func meditationIconColor(for title: String) -> Color {
        switch title {
        case "Love to body":
            return .pink
        case "Best sides of yourself":
            return .blue
        case "Santosha":
            return .green
        case "Focus mind meditation":
            return .purple
        case "Daily Trivia":
            return .purple
        case "The Word":
            return .blue
        case "Daily Rosary":
            return .brown
        case "Divine Revelation":
            return .orange
        case "Rosary":
            return .indigo
        case "Daily Reflections":
            return .green
        case "Daily Gospel":
            return .defaultSelected
        case "Morning Psalms":
            return .cyan
        case "Daily Mass Readings":
            return .mint
        case "Daily Saint":
            return .red
        case "Gospel of Matthew":
            return .teal
        default:
            return .gray
        }
    }
    
    private func meditationIcon(for title: String) -> some View {
        switch title {
        case "Love to body":
            return Image(systemName: "heart.fill")
        case "Best sides of yourself":
            return Image(systemName: "star.fill")
        case "Santosha":
            return Image(systemName: "leaf.fill")
        case "Focus mind meditation":
            return Image(systemName: "brain.head.profile")
        case "Daily Trivia":
            return Image(systemName: "questionmark.circle")
        case "The Word":
            return Image(systemName: "textformat.abc")
        case "Daily Rosary":
            return Image(systemName: "cross")
        case "Divine Revelation":
            return Image(systemName: "book")
        case "Rosary":
            return Image(systemName: "pray")
        case "Daily Reflections":
            return Image(systemName: "lightbulb")
        case "Daily Gospel":
            return Image(systemName: "book.closed")
        case "Morning Psalms":
            return Image(systemName: "sunrise")
        case "Daily Mass Readings":
            return Image(systemName: "book.pages")
        case "Daily Saint":
            return Image(systemName: "person.2")
        case "Gospel of Matthew":
            return Image(systemName: "scroll")
        default:
            return Image(systemName: "heart")
        }
    }
}


// MARK: - Helper Functions
func getMeditationByTitle(_ title: String) -> Meditation {
    // This is a placeholder - in a real app, you'd fetch from your data source
    return Meditation(
        title: title,
        subtitle: "Meditation for \(title.lowercased())",
        imageName: "heart.fill",
        duration: 10,
        isDownloaded: false
    )
}

// MARK: - Meditation Category View
struct MeditationCategoryView: View {
    let title: String
    let meditations: [Meditation]
    @EnvironmentObject var progressModel: AppProgressModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedMeditation: Meditation?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.defaultAppWhite)
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Text(title)
                        .font(.title2.bold())
                        .foregroundColor(.defaultAppWhite)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.clear)
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                if meditations.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        Text("No Meditations Yet")
                            .font(.title2.bold())
                            .foregroundColor(.defaultAppWhite)
                        
                        Text("Meditations will appear here when available")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Meditations list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(meditations) { meditation in
                                DownloadedMeditationRow(
                                    meditation: meditation,
                                    onDelete: {
                                        // No delete action for category meditations
                                    },
                                    onTap: {
                                        selectedMeditation = meditation
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                }
            }
            .background(Color.defaultAppDark.ignoresSafeArea())
            .navigationBarHidden(true)
            .navigationDestination(item: $selectedMeditation) { meditation in
                MeditationDetailView(meditation: meditation)
                    .environmentObject(progressModel)
            }
        }
    }
}
