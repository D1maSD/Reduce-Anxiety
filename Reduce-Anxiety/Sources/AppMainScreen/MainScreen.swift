//
//  MainScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI

public struct HomeView: View {
    @State private var isGridMode = false
    @State private var selectedFilter: String = "Today"
    public init() {}
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Current progress")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: { isGridMode.toggle() }) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                if isGridMode {
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
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            CurrentProgressCell()
                            DailyContributionsCell()
                            DailyAdviceCell()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    }
                }
                Spacer()
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
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

struct CurrentProgressCell: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.red, lineWidth: 10)
                    .frame(width: 70, height: 70)
                Text("55%")
                    .font(.system(size: 14, weight: .bold))
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Completed sessions:")
                        .font(.system(size: 16))
                    Spacer()
                    Text("30")
                        .font(.system(size: 16, weight: .bold))
                }
                HStack {
                    Text("Meditations passed:")
                        .font(.system(size: 16))
                    Spacer()
                    Text("30")
                        .font(.system(size: 16, weight: .bold))
                }
                HStack {
                    Text("Notes maked:")
                        .font(.system(size: 16))
                    Spacer()
                    Text("30")
                        .font(.system(size: 16, weight: .bold))
                }
            }
        }
        .padding(20)
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(14)
    }
}

struct DailyContributionsCell: View {
    let rows = 7
    let columns = 12
    let cellSize: CGFloat = 20
    let spacing: CGFloat = 4

    // Подставные данные активности (записи пользователя по дням)
    let contributions: [Bool] = (0..<84).map { _ in Bool.random() }

    // Вычисляемые сокращённые названия месяцев над неделями
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
            // Лейблы дней недели: M, W, F
            
            
            SquareViewItems()
            
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 4) {
                    // Лейблы месяцев
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

                    // Сетка активности: 12 недель × 7 дней
                    HStack(spacing: spacing) {
                        ForEach(0..<columns, id: \.self) { column in
                            VStack(spacing: spacing) {
                                ForEach(0..<rows, id: \.self) { row in
                                    let index = column * rows + row
                                    Rectangle()
                                        .fill(index < contributions.count && contributions[index] ? Color.green : Color.gray.opacity(0.3))
                                        .frame(width: cellSize, height: cellSize)
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                }
            }
            
            
            
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(14)
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
