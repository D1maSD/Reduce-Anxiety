//
//  ChatsView.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 6/28/25.
//
import SwiftUI
import AppChatView


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
                                    .foregroundColor(.black)
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
                    .padding(.top, 45)

                    // Streak Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Streak")
                            .font(.title3.bold())
                            .padding(.horizontal)
                            .foregroundColor(.black)

                        HStack {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.gray)
                            Text("0")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("Pray today and start building a habit!")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.2))
                        )
                        .padding(.horizontal)
                    }

                    // Create a Routine Section
                    VStack(alignment: .leading, spacing: 12) {
                                            Text("Create a Routine")
                                                .font(.title3.bold())
                                                .padding(.horizontal)
                                                .foregroundColor(.black)

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
                                                    .fill(Color.gray.opacity(0.2))
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
                                                    .fill(Color.gray.opacity(0.2))
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
                                                    .foregroundColor(.black)
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
                                                    .fill(Color.gray.opacity(0.15))
                                                    .frame(width: UIScreen.main.bounds.width - 40, height: 180)
                                                    .overlay(
                                                        Image(systemName: "star.fill")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 40, height: 40)
                                                            .foregroundColor(.gray)
                                                    )
                                                    .padding(.horizontal, 20)
                                            }
                                            .frame(height: 200)
                                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                        }

                                        Spacer().frame(height: 40)
                                    }
                                }
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
                    extension String: Identifiable {
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
                        .background(Color.white.opacity(0.1))
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
                        .background(Color.white.opacity(0.05))
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
                    .background(Color.white.opacity(0.05))
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
        .background(Color.black.ignoresSafeArea())
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
        .background(Color.black)
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
        .background(Color.black.ignoresSafeArea())
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
                        .background(Color.white.opacity(0.1))
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
        .background(Color.black.ignoresSafeArea())
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
    @State private var showAddSessionSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
                .padding()
            }

            Button(action: { showTimePicker.toggle() }) {
                Text(timeString(from: selectedTime))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal)
            }

            if showTimePicker {
                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding(.horizontal)
            }

            Button(action: { showAddSessionSheet.toggle() }) {
                HStack {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.black)
                    Text("Add session")
                        .foregroundColor(.black)
                        .font(.system(size: 17, weight: .medium))
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.yellow)
                        .frame(width: 100, height: 100)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red)
                        .frame(width: 100, height: 100)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                        .frame(width: 100, height: 100)
                }
                .padding(.horizontal)
            }

            Button("Delete block") {}
                .font(.system(size: 15))
                .foregroundColor(.red)
                .padding(.horizontal)

            Spacer()
        }
        .sheet(isPresented: $showAddSessionSheet) {
            AddSessionView()
        }
    }

    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
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

// MARK: - AddSessionView (mock)
struct AddSessionView: View {
    var body: some View {
        VStack {
            Text("Add Session")
                .font(.title)
                .padding()
            Spacer()
        }
    }
}
