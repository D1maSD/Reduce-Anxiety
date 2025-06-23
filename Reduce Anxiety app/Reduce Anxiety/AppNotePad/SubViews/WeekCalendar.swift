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

    
    func someView() -> some View {
        Text("Hello, World!")
    }
    
    
    private var weekDates: [Date] {
        let calendar = Calendar.current
        return (0..<totalDays).compactMap {
            calendar.date(byAdding: .day, value: $0, to: calendarStartDate)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let itemWidth = (geometry.size.width - 6 * 12) / 7 // 7 элементов и 6 отступов по 12

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(weekDates, id: \.self) { date in
                        let isFuture = date > Calendar.current.startOfDay(for: Date())
                        let isToday = Calendar.current.isDateInToday(date)
                        let hasNote = notes.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }

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
                                .foregroundColor(.black)
                            Text(dayNumber(for: date))
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .frame(width: itemWidth)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.yellow, lineWidth: 2)
                                .background(
                                    selectedDate.map { Calendar.current.isDate($0, inSameDayAs: date) } == true ? Color.yellow : Color.clear
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
                    }
                }
            }
        }
        .frame(height: 90)
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
