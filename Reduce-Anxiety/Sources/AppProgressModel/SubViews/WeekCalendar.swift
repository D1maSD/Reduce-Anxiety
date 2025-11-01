//
//  NotesScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI

struct WeekCalendar: View {
    @Binding var selectedDate: Date?
    let notes: [Note]
    let calendarStartDate: Date
    let totalDays: Int

    private let calendar = Calendar.current
    private let centerThreshold = 3

    private var weekDates: [Date] {
        guard totalDays > 0 else { return [] }
        return (0..<totalDays).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: calendarStartDate)
        }
    }

    private var todayIndex: Int? {
        let today = calendar.startOfDay(for: Date())
        return weekDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: today) })
    }

    var body: some View {
        GeometryReader { geometry in
            let itemWidth = (geometry.size.width - 6 * 12) / 7 // 7 элементов и 6 отступов по 12

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(weekDates, id: \.self) { date in
                            let isFuture = date > calendar.startOfDay(for: Date())
                            let isToday = calendar.isDateInToday(date)
                            let hasNote = notes.contains { calendar.isDate($0.date, inSameDayAs: date) }

                            VStack(spacing: 4) {
                                if !isFuture {
                                    Circle()
                                        .strokeBorder(Color.white, lineWidth: 2)
                                        .background(Circle().fill(hasNote ? Color.green : Color.red))
                                        .frame(width: 10, height: 10)
                                        .offset(y: -5)
                                } else {
                                    Color.clear.frame(width: 10, height: 10).offset(y: -5)
                                }

                                Text(shortDayName(for: date))
                                    .font(.caption2)
                                    .foregroundColor(.defaultAppWhite)
                                Text(dayNumber(for: date))
                                    .font(.headline)
                                    .foregroundColor(.defaultAppWhite)
                            }
                            .frame(width: itemWidth)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.defaultSelected, lineWidth: 2)
                                    .background(
                                        selectedDate.map { calendar.isDate($0, inSameDayAs: date) } == true ? Color.defaultSelected : Color.defaultAppGray
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                    .foregroundColor((isToday && !hasNote) ? .red : .clear)
                            )
                            .cornerRadius(8)
                            .onTapGesture {
                                if selectedDate == date {
                                    selectedDate = nil
                                } else {
                                    selectedDate = date
                                }
                            }
                            .id(date)
                        }
                    }
                }
                .onAppear {
                    centerTodayIfNeeded(proxy: proxy)
                }
                .onChange(of: calendarStartDate) { _ in
                    centerTodayIfNeeded(proxy: proxy)
                }
            }
        }
        .frame(height: 90)
    }

    private func centerTodayIfNeeded(proxy: ScrollViewProxy) {
        guard let index = todayIndex, index >= centerThreshold else { return }
        let todayDate = weekDates[index]
        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                proxy.scrollTo(todayDate, anchor: .center)
            }
        }
    }

    private func shortDayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    private func dayNumber(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

//#Preview {
//    WeekCalendar()
//}

