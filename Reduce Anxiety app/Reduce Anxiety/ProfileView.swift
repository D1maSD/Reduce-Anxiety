//
//  ChatsView.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 6/28/25.
//
import SwiftUI
import AppChatView
import AppMeditationAttention
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
    @State private var navigateToSettings = false
    @State private var selectedStub: String?
    @State private var navigateToRoutineEditor = false
    @State private var navigateToOptimalRoutine = false

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
                                                    selectedStub = "Downloads"
                                                } label: {
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .padding(.horizontal)

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
                                        }

                                        // Recently Played Section
                                        VStack(alignment: .leading, spacing: 12) {
                                            HStack {
                                                Text("Recently played")
                                                    .font(.title3.bold())
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Button {
                                                    selectedStub = "Recently Played"
                                                } label: {
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .padding(.horizontal)

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
                                        }

                                        // Favorites Section (оставлена без изменений)
                                        VStack(alignment: .leading, spacing: 12) {
                                            HStack {
                                                Text("Your favorite practices")
                                                    .font(.title3.bold())
                                                    .foregroundColor(.defaultWhite)
                                                Spacer()
                                                Button {
                                                    selectedStub = "Favorites"
                                                } label: {
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .padding(.horizontal)

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
                                .navigationDestination(isPresented: $navigateToSettings) {
                                    SettingsMainView()
                                }
                                .navigationDestination(item: $selectedStub) { title in
                                    StubView(title: title)
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
                        Text("Settings")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

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

    let settings = [
        "Switch Theme", "Notification Settings", "Privacy",
        "Language", "Location", "Streaks",
        "Apple Health", "Siri Shortcuts", "Export Journals"
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
                    NavigationLink(value: setting) {
                        HStack {
                            Text(setting)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray)
                    }
                }
            }
            .background(Color.white.opacity(0.05))
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
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.primary)
                }
            }
            .padding()

            Text("Hi Dmitriy 👋\nHow can we help?")
                .font(.title2.bold())
                .padding()

            List {
                Text("Search for help")
                Text("How do I cancel my subscription or free trial?")
                Text("How can I tell if I’m subscribed?")
            }
        }
        .navigationBarBackButtonHidden()
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
                        .background(Color.white.opacity(0.1))
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
                        .background(Color.white)
                    }
                }
            }
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
            .padding()

            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
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
    
    // Sample suggested meditations
    let suggestedMeditations = [
        Meditation(title: "Daily Trivia", subtitle: "Learn about the faith", imageName: "daily_trivia"),
        Meditation(title: "The Word", subtitle: "Solve the word of the day and learn more about your faith!", imageName: "the_word"),
        Meditation(title: "Daily Rosary", subtitle: "Daily Mysteries", imageName: "daily_rosary"),
        Meditation(title: "Divine Revelation", subtitle: "Part 1, Section 1", imageName: "divine_revelation")
    ]

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
            return .yellow
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
    
    // Extended meditation list based on the screenshot
    let allMeditations = [
        Meditation(title: "Love to body", subtitle: "Relax and unwind", imageName: "love_to_body"),
        Meditation(title: "Daily Trivia", subtitle: "Learn about the faith", imageName: "daily_trivia"),
        Meditation(title: "The Word", subtitle: "Solve the word of the day and learn more about your faith!", imageName: "the_word"),
        Meditation(title: "Daily Rosary", subtitle: "Daily Mysteries • 7 sessions", imageName: "daily_rosary"),
        Meditation(title: "Divine Revelation", subtitle: "Part 1, Section 1 • 25 sessions", imageName: "divine_revelation"),
        Meditation(title: "Rosary", subtitle: "Dr. Scott Hahn • 7 sessions", imageName: "rosary"),
        Meditation(title: "Daily Reflections", subtitle: "Jeff Cavins & Jonathan Roumie • 1415 sessions", imageName: "daily_reflections"),
        Meditation(title: "Daily Gospel", subtitle: "Daily Lectio Divina • 2136 sessions", imageName: "daily_gospel"),
        Meditation(title: "Morning Psalms", subtitle: "Bishop Barron • 28 sessions", imageName: "morning_psalms"),
        Meditation(title: "Daily Mass Readings", subtitle: "Listen & Pray • 1439 sessions", imageName: "daily_mass_readings"),
        Meditation(title: "Daily Saint", subtitle: "Pray with the Saints • 262 sessions", imageName: "daily_saint"),
        Meditation(title: "Gospel of Matthew", subtitle: "Biblical Study • 45 sessions", imageName: "gospel_matthew")
    ]
    
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
            return .yellow
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
