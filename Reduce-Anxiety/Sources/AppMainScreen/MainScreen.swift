//
//  MainScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI
import UIKit
import Foundation
import AppMeditationAttention
import AppProgressModel

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

public struct HomeView: View {
    @State private var isGridMode = false
    @State private var selectedFilter: String = "Today"
    @State private var path = NavigationPath()
    @State private var showFilterMenu = false
    @State private var navigateToNotifications = false
    @EnvironmentObject var progressModel: AppProgressModel
    @StateObject private var settingsManager = SettingsManager.shared
    
    // Navigation callback to switch tabs
    public let onNavigateToProfile: ((String) -> Void)?

    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    
    public init(onNavigateToProfile: ((String) -> Void)? = nil) {
        self.onNavigateToProfile = onNavigateToProfile
    }

    public var body: some View {
        NavigationStack(path: $path) {
            mainContentView
                .navigationTitle("Current progress")
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(Color.defaultAppGray, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showFilterMenu.toggle()
                        }) {
                            if let uiImage = UIImage(named: "filter") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                            }
                        }
                        .tint(.white)
                    }
                }
                .navigationDestination(for: String.self) { route in
                    if route == "meditations" {
                        MeditationsView()
                            .environmentObject(progressModel)
                    } else if route == "notifications" {
                        MeditationsView()
                            .environmentObject(progressModel)
                    }
                }
                .background(Color.defaultAppDark)
        }
    }
    
    private var mainContentView: some View {
        ZStack(alignment: .topTrailing) {
            if isGridMode {
                gridContentView
            } else {
                listContentView
            }
            
            if showFilterMenu {
                filterMenuView
            }
        }
    }
    
    private var gridContentView: some View {
        VStack(spacing: 0) {
            filterButtons
                .padding(.top, 12)
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(0..<(selectedFilter == "Today" ? 1 : selectedFilter == "Last 7 days" ? 7 : 20), id: \.self) { _ in
                        DailyAdviceCell()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
        }
    }
    
    private var listContentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                if settingsManager.showStreaks {
                    ProgressAndContributionsCell()
                        .environmentObject(progressModel)
                } else {
                    DailyAdviceCell()
                }
                
                NavigationButtonsView(onNavigateToProfile: onNavigateToProfile)
                
                RecentlyPlayedSection(onNavigateToProfile: onNavigateToProfile)
                    .environmentObject(progressModel)
                
                MeditationCategorySection(
                    title: "Reduce anxiety meditations",
                    meditations: [getMeditationByTitle("Love to body")],
                    onNavigateToProfile: onNavigateToProfile
                )
                
                MeditationCategorySection(
                    title: "Good mood",
                    meditations: [getMeditationByTitle("Best sides of yourself")],
                    onNavigateToProfile: onNavigateToProfile
                )
                
                MeditationCategorySection(
                    title: "Get happy",
                    meditations: [getMeditationByTitle("Santosha")],
                    onNavigateToProfile: onNavigateToProfile
                )
                
                Button(action: {
                    path.append("meditations")
                }) {
                    HowPassCourseCell()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
    }
    
    private var filterMenuView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button("Days") {
                isGridMode.toggle()
                showFilterMenu = false
            }
            .padding(.vertical, 6)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Notifications") {
                showFilterMenu = false
                path.append("notifications")
            }
            .padding(.vertical, 6)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(width: UIScreen.main.bounds.width * 0.3)
        .padding(.top, 60)
        .padding(.trailing, 12)
        .zIndex(1)
    }

    private var filterButtons: some View {
        HStack(spacing: 12) {
            ForEach(["Today", "Last 7 days", "All"], id: \.self) { filter in
                Button(action: { selectedFilter = filter }) {
                    Text(filter)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedFilter == filter ? .white : .defaultAppWhite)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedFilter == filter ? Color.defaultAppWhite : Color.clear)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.defaultAppWhite, lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}


struct CurrentProgressContent: View {
    @EnvironmentObject var progressModel: AppProgressModel
    @State private var animatedProgress: Double = 0.0
    
    // Calculate progress based on the logic: 1/100 for meditation with record, 1/200 for meditation without record
    private var calculatedProgress: Double {
        let meditationsWithRecord = progressModel.dailyActivities.filter { $0.hasMeditation && $0.hasNote }.count
        let meditationsWithoutRecord = progressModel.dailyActivities.filter { $0.hasMeditation && !$0.hasNote }.count
        
        let totalProgress = (Double(meditationsWithRecord) / 100.0) + (Double(meditationsWithoutRecord) / 200.0)
        return min(totalProgress, 1.0) // Cap at 100%
    }
    
    private var progressPercentage: Int {
        return Int(calculatedProgress * 100)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 18)
                    .frame(width: 74, height: 74)

                Circle()
                    .stroke(Color.defaultAppGray.opacity(0.6), lineWidth: 12)
                    .frame(width: 74, height: 74)

                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        Color.green,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 74, height: 74)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.5), value: animatedProgress)

                Text("\(progressPercentage)%")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.defaultAppWhite)
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Completed sessions:")
                    Spacer()
                    Text("\(progressModel.totalMeditations)")
                }
                HStack {
                    Text("Meditations passed:")
                    Spacer()
                    Text("\(progressModel.totalMeditations)")
                }
                HStack {
                    Text("Notes maked:")
                    Spacer()
                    Text("\(progressModel.totalNotes)")
                }
            }
            .font(.system(size: 16))
            .foregroundColor(.defaultAppWhite)
        }
        .onAppear {
            // Start animation from 100% and animate to current progress
            animatedProgress = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animatedProgress = calculatedProgress
            }
        }
        .onChange(of: calculatedProgress) { _, newProgress in
            // Re-animate when progress changes
            animatedProgress = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animatedProgress = newProgress
            }
        }
    }
}


struct DailyContributionsContent: View {
    @EnvironmentObject var progressModel: AppProgressModel
    @State private var displayedMonth: Date = Calendar.current.startOfMonth(for: Date())

    private let locale = Locale(identifier: "ru_RU")
    private let daySize: CGFloat = 32
    private let circleScale: CGFloat = 1.15
    private let daySpacing: CGFloat = 10
    private let fullFillColor = Color(.sRGB, red: 0.19, green: 0.70, blue: 0.36, opacity: 0.9)
    private let partialFillColor = Color(.sRGB, red: 0.40, green: 0.60, blue: 0.50, opacity: 0.45)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            calendarHeader
            weekdayHeader
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: daySpacing), count: 7), spacing: daySpacing) {
                ForEach(daysForDisplayedMonth, id: \.self) { date in
                    dayCell(for: date)
                }
            }
        }
        .padding(.horizontal, 8)
    }

    private var calendarHeader: some View {
        HStack {
            Button(action: { displayedMonth = adjustedMonth(by: -1) }) {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(.plain)

            Spacer()

            Text(monthTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            Button(action: { if canNavigateForward { displayedMonth = adjustedMonth(by: 1) } }) {
                Image(systemName: "chevron.right")
                    .opacity(canNavigateForward ? 1.0 : 0.3)
            }
            .buttonStyle(.plain)
            .disabled(!canNavigateForward)
        }
        .foregroundColor(.white)
    }

    private var weekdayHeader: some View {
        let symbols = weekdaySymbols
        return HStack(spacing: daySpacing) {
            ForEach(symbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func dayCell(for date: Date) -> some View {
        let calendar = configuredCalendar
        let isCurrentMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
        let isToday = calendar.isDateInToday(date)
        let activity = activity(for: date)
        let fillColor = backgroundColor(for: activity)
        let textColor = isCurrentMonth ? Color.white.opacity(0.8) : Color.white.opacity(0.35)

        return ZStack {
            Circle()
                .fill(fillColor)
                .frame(width: daySize * circleScale, height: daySize * circleScale)
                .overlay(
                    Circle()
                        .stroke(isToday ? Color.white.opacity(0.6) : Color.clear, lineWidth: isToday ? 2 : 0)
                )
                .allowsHitTesting(false)

            Text(dayNumberFormatter.string(from: date))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(textColor)
        }
        .frame(width: daySize, height: daySize)
    }

    private var daysForDisplayedMonth: [Date] {
        let calendar = configuredCalendar
        let startOfMonth = calendar.startOfMonth(for: displayedMonth)
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return [] }

        let firstDayIndex = weekdayIndex(for: startOfMonth)
        let firstDisplayedDay = calendar.date(byAdding: .day, value: -firstDayIndex, to: startOfMonth) ?? startOfMonth

        let lastDay = calendar.date(byAdding: .day, value: range.count - 1, to: startOfMonth) ?? startOfMonth
        let lastDayIndex = weekdayIndex(for: lastDay)
        let trailingDays = 6 - lastDayIndex

        let totalDays = range.count + firstDayIndex + trailingDays

        return (0..<totalDays).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: firstDisplayedDay)
        }
    }

    private var activityMap: [Date: DailyActivity] {
        let calendar = configuredCalendar
        return progressModel.dailyActivities.reduce(into: [Date: DailyActivity]()) { result, activity in
            let key = calendar.startOfDay(for: activity.date)
            result[key] = activity
        }
    }

    private func activity(for date: Date) -> DailyActivity? {
        let calendar = configuredCalendar
        let key = calendar.startOfDay(for: date)
        return activityMap[key]
    }

    private func backgroundColor(for activity: DailyActivity?) -> Color {
        guard let activity = activity else { return .clear }
        if activity.hasNote && activity.hasMeditation {
            return fullFillColor
        }
        if activity.hasNote || activity.hasMeditation {
            return partialFillColor
        }
        return .clear
    }

    private var configuredCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = locale
        calendar.firstWeekday = 2
        return calendar
    }

    private var monthTitle: String {
        monthFormatter.string(from: displayedMonth).capitalized(with: locale)
    }

    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = locale
        let fallback = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        let symbols = formatter.shortWeekdaySymbols ?? fallback
        let startIndex = max(0, min(symbols.count - 1, configuredCalendar.firstWeekday - 1))
        let leading = Array(symbols[startIndex...])
        let trailing = Array(symbols[..<startIndex])
        let reordered = leading + trailing
        return reordered.map { $0.capitalized(with: locale) }
    }

    private func weekdayIndex(for date: Date) -> Int {
        let calendar = configuredCalendar
        let weekday = calendar.component(.weekday, from: date)
        return (weekday - calendar.firstWeekday + 7) % 7
    }

    private func adjustedMonth(by value: Int) -> Date {
        let calendar = configuredCalendar
        let newDate = calendar.date(byAdding: .month, value: value, to: displayedMonth) ?? displayedMonth
        return calendar.startOfMonth(for: newDate)
    }

    private var canNavigateForward: Bool {
        let calendar = configuredCalendar
        return !calendar.isDate(displayedMonth, equalTo: Date(), toGranularity: .month)
    }

    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }

    private var dayNumberFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "d"
        return formatter
    }
}

private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}

extension Color {
    static let defaultAppDark = Color("defaultDark")
    static let defaultAppWhite = Color("defaultWhite")
    static let defaultAppGray = Color("defaultGray")
    static let defaultSelected = Color("defaultSelected")
}

struct DailyAdviceCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Daily advice:")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.defaultAppWhite)
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                .font(.system(size: 16))
                .foregroundColor(.defaultAppWhite)
        }
        .padding(20)
        .background(Color.defaultAppGray)
        .cornerRadius(14)
    }
}

struct HowPassCourseCell: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("How to pass this course:")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.purple)

                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                    .font(.system(size: 16))
                    .foregroundColor(.defaultAppWhite)
            }
            .padding(.trailing, 20 + 15) // учёт ширины иконки и отступа

            Spacer()

            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 40)
                .foregroundColor(.defaultAppWhite)
                .padding(.trailing, 20)
        }
        .padding(20)
        .background(Color.defaultAppGray)
        .cornerRadius(14)
    }
}

#Preview {
    HomeView()
}

struct ProgressAndContributionsCell: View {
    @EnvironmentObject var progressModel: AppProgressModel
    var body: some View {
        VStack(spacing: 20) {
            CurrentProgressContent()
                .environmentObject(progressModel)
            DailyContributionsContent()
                .environmentObject(progressModel)
        }
        .padding(20)
        .background(Color.defaultAppGray)
        .cornerRadius(14)
    }
}

struct NavigationButtonsView: View {
    let onNavigateToProfile: ((String) -> Void)?
    
    var body: some View {
        HStack(spacing: 16) {
            // Favorites Button
            NavigationButton(
                icon: "star",
                title: "Favorites",
                action: { onNavigateToProfile?("favorites") }
            )
            
            // Downloads Button
            NavigationButton(
                icon: "arrow.down.circle",
                title: "Downloads",
                action: { onNavigateToProfile?("downloads") }
            )
            
            // Routine Button
            NavigationButton(
                icon: "calendar",
                title: "Routine",
                action: { onNavigateToProfile?("routine") }
            )
            
            // Recents Button
            NavigationButton(
                icon: "clock",
                title: "Recents",
                action: { onNavigateToProfile?("recents") }
            )
        }
        .padding(.horizontal, 20)
    }
}

struct NavigationButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(Color.defaultAppGray)
            .cornerRadius(16)
        }
    }
}

// MARK: - Helper Functions
func getMeditationByTitle(_ title: String) -> Meditation {
    if let meditation = Meditation.allMeditations.first(where: { $0.title == title }) {
        return meditation
    }

    return Meditation(
        title: title,
        subtitle: "Meditation for \(title.lowercased())",
        imageName: "",
        audioFileName: nil,
        duration: 10,
        isDownloaded: false
    )
}

// MARK: - Recently Played Section
struct RecentlyPlayedSection: View {
    @EnvironmentObject var progressModel: AppProgressModel
    let onNavigateToProfile: ((String) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recently played")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Spacer()
                Button {
                    onNavigateToProfile?("recents")
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)

            RecentlyPlayedCarousel(
                meditations: Array(progressModel.meditationManager.recentlyPlayedMeditations.prefix(3))
            )
        }
    }
}

private struct RecentlyPlayedCarousel: View {
    let meditations: [Meditation]
    private let cardWidth = UIScreen.main.bounds.width - 40
    private let cardHeight: CGFloat = 180
    private let cornerRadius: CGFloat = 20

    var body: some View {
        if meditations.isEmpty {
            TabView {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.defaultAppGray)
                    .frame(width: cardWidth, height: cardHeight)
                    .overlay(
                        Image(systemName: "clock.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    )
                    .padding(.horizontal, 20)
            }
            .frame(height: cardHeight + 20)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        } else {
            TabView {
                ForEach(Array(meditations.enumerated()), id: \.offset) { _, meditation in
                    SimpleMeditationCard(meditation: meditation)
                }
            }
            .frame(height: cardHeight + 20)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}

// MARK: - Meditation Category Section
struct MeditationCategorySection: View {
    let title: String
    let meditations: [Meditation]
    let onNavigateToProfile: ((String) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Spacer()
                Button {
                    onNavigateToProfile?(title.lowercased().replacingOccurrences(of: " ", with: ""))
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)

            TabView {
                ForEach(meditations) { meditation in
                    SimpleMeditationCard(meditation: meditation)
                }
            }
            .frame(height: 200)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}

// MARK: - Simple Meditation Card
struct SimpleMeditationCard: View {
    let meditation: Meditation
    private let cardHeight: CGFloat = 180
    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width - 40
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            backgroundContent

            VStack(alignment: .leading, spacing: 6) {
                Text(meditation.title)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)

                Text(meditation.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .padding(20)
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var backgroundContent: some View {
        if let uiImage = loadImage(named: meditation.imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [Color.black.opacity(0.0), Color.black.opacity(0.65)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
        } else {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.defaultAppGray)
                .frame(width: cardWidth, height: cardHeight)
        }
    }

    private func loadImage(named name: String) -> UIImage? {
        UIImage(named: name)
    }
}
//struct User {
//    let name: String
//    let age: Int
//
//    init(name: String, age: Int) {
//        self.name = name
//        self.age = age
//    }
//
//    // Альтернативный инициализатор
//    init(name: String) {
//        self.name = name
////        self.age = 18
//    }
//}

//actor Counter {
//    let name: String
//    var value: Int// = 0
//
//    init(name: String) {
//        self.name = name
//        // нельзя делать await здесь
//    }
//}
