//
//  MainScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI
import UIKit
import AppMeditationAttention
import AppProgressModel

public struct HomeView: View {
    @State private var isGridMode = false
    @State private var selectedFilter: String = "Today"
    @State private var path = NavigationPath()
    @State private var showFilterMenu = false
    @State private var navigateToNotifications = false
    @EnvironmentObject var progressModel: AppProgressModel

    let bigSize = UIDevice.current.userInterfaceIdiom == .pad
    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .topTrailing) {
                Group {
                    if isGridMode {
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
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                ProgressAndContributionsCell()
                                    .environmentObject(progressModel)
                                DailyAdviceCell()
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
                }
                .navigationTitle("Current progress")
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: String.self) { route in
                    if route == "meditations" {
                        MeditationsView()
                            .environmentObject(progressModel)
                    } else if route == "notifications" {
//                        NotificationsView()
                        MeditationsView()
                            .environmentObject(progressModel)
                    }
                }

                if showFilterMenu {
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
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showFilterMenu.toggle()
                    }) {
                        if let uiImage = UIImage(named: "filter") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: bigSize ? 30 : 30)
                                .padding(.top, 40)
                        }
                    }
                }
            }
            .background(Color.white)
        }
    }

    private var filterButtons: some View {
        HStack(spacing: 12) {
            ForEach(["Today", "Last 7 days", "All"], id: \.self) { filter in
                Button(action: { selectedFilter = filter }) {
                    Text(filter)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedFilter == filter ? .white : .black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedFilter == filter ? Color.black : Color.clear)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}


struct CurrentProgressContent: View {
    @EnvironmentObject var progressModel: AppProgressModel

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.red, lineWidth: 10)
                    .frame(width: 70, height: 70)
                Text("55%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
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
            .foregroundColor(.black)
        }
    }
}


struct DailyContributionsContent: View {
    let rows = 7
    let columns = 12
    let cellSize: CGFloat = 20
    let spacing: CGFloat = 4
    let contributions: [Bool] = (0..<84).map { _ in Bool.random() }
    @EnvironmentObject var progressModel: AppProgressModel
    private var dailyData: [DailyActivity] {
            progressModel.activities(forLastDays: 84)
        }

    private var monthLabels: [Int: String] {
        var labels: [Int: String] = [:]
        let calendar = Calendar.current
        let today = Date()
        for i in 0..<columns {
            if let date = calendar.date(byAdding: .weekOfYear, value: -columns + i + 1, to: today) {
                let month = calendar.component(.month, from: date)
                let monthSymbol = calendar.shortMonthSymbols[month - 1]
                if i == 0 || calendar.component(.month, from: calendar.date(byAdding: .weekOfYear, value: -columns + i, to: today)!) != month {
                    labels[i] = monthSymbol
                }
            }
        }
        return labels
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            SquareViewItems()
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: spacing) {
                        ForEach(0..<columns, id: \.self) { col in
                            if let month = monthLabels[col] {
                                Text(month)
                                    .font(.system(size: 10))
                                    .foregroundColor(Color.gray.opacity(0.6))
                                    .frame(width: cellSize, alignment: .leading)
                            } else {
                                Spacer().frame(width: cellSize)
                            }
                        }
                    }
                    HStack(spacing: spacing) {
                                            ForEach(0..<columns, id: \.self) { column in
                                                VStack(spacing: spacing) {
                                                    ForEach(0..<rows, id: \.self) { row in
                                                        let index = column * rows + row
                                                        if index < dailyData.count {
                                                            let activity = dailyData[index]
                                                            Rectangle()
                                                                .fill(color(for: activity))
                                                                .frame(width: cellSize, height: cellSize)
                                                                .cornerRadius(4)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                }
            }
        }
    }
    
    private func color(for activity: DailyActivity) -> Color {
        if activity.hasNote && activity.hasMeditation {
            return Color.green.opacity(0.8) // темно-зелёный
        } else if activity.hasNote || activity.hasMeditation {
            return Color.green.opacity(0.4) // светло-зелёный
        } else {
            return Color.gray.opacity(0.2)
        }
    }

}

struct DailyAdviceCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Daily advice:")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.purple)
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                .font(.system(size: 16))
                .foregroundColor(.black)
        }
        .padding(20)
        .background(Color.yellow.opacity(0.2))
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
                    .foregroundColor(.black)
            }
            .padding(.trailing, 20 + 15) // учёт ширины иконки и отступа

            Spacer()

            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 40)
                .foregroundColor(.black)
                .padding(.trailing, 20)
        }
        .padding(20)
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(14)
    }
}

#Preview {
    HomeView()
}

struct SquareViewItems: View {
    let rows = 7
    let columns = 12
    let cellSize: CGFloat = 20
    let spacing: CGFloat = 4

    // Подставные данные активности (записи пользователя по дням)
    let contributions: [Bool] = (0..<84).map { _ in Bool.random() }
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                if row == 0 {
                    Text("M")
                        .font(.system(size: 10))
                        .foregroundColor(Color.gray.opacity(0.6))
                        .frame(width: 20, height: cellSize)
                        .padding(.top, 15) // ⬅️ немного опускаем вниз
                } else if row == 2 {
                    Spacer().frame(height: cellSize * CGFloat(row - 1) + spacing * CGFloat(row - 1))
                    Text("W")
                        .font(.system(size: 10))
                        .foregroundColor(Color.gray.opacity(0.6))
                        .frame(width: 20, height: cellSize)
                } else if row == 4 {
                    let offset = CGFloat(row) - 3.3
                    Spacer().frame(height: cellSize * offset + spacing * offset)
                    Text("F")
                        .font(.system(size: 10))
                        .foregroundColor(Color.gray.opacity(0.6))
                        .frame(width: 20, height: cellSize)
                }
            }
            Spacer() // добиваем до полного по высоте
        }
    }
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
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(14)
    }
}
