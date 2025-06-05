//
//  NotesScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI

// MARK: - Модель записи
struct Note: Identifiable {
    let id = UUID()
    var date: Date
    var text: String
}

// MARK: - Основной экран задач
struct TasksView: View {
    @State private var selectedDate: Date? = nil
    @State private var showingCreateNote = false
    @State private var pendingNoteDate: Date? = nil

    // 🔹 Переключение между режимами: мок и обычный
    private let isMockMode = true

    private let totalCalendarDays = 92
    private let today = Calendar.current.startOfDay(for: Date())

    private var calendarStartDate: Date {
        if isMockMode {
            return Calendar.current.date(byAdding: .day, value: -10, to: today) ?? today
        } else {
            return today
        }
    }

    @State private var notes: [Note] = []

    public init() {
        if isMockMode {
            _notes = State(initialValue: Self.mockNotes())
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Header with missed days
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Today")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        Spacer()
                    }
                    HStack {
                        Text(formattedDate(today))
                            .font(.system(size: 26, weight: .bold))
                        Spacer()
                        Text("You missed \(missedDays) days")
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)

                WeekCalendar(
                    selectedDate: $selectedDate,
                    notes: notes,
                    calendarStartDate: calendarStartDate,
                    totalDays: totalCalendarDays
                )
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(displayedDates, id: \ .self) { date in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(sectionTitle(for: date))
                                    .font(.system(size: 16, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)

                                if let dayNotes = groupedNotes[date], !dayNotes.isEmpty {
                                    ForEach(dayNotes) { note in
                                        noteCell(note)
                                    }
                                } else {
                                    emptyNoteCell(for: date)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCreateNote) {
                if let pendingDate = pendingNoteDate {
                    CreateNoteView { newNote in
                        var note = newNote
                        note.date = pendingDate
                        notes.append(note)
                        showingCreateNote = false
                        pendingNoteDate = nil
                    }
                }
            }
        }
    }

    private var filteredNotes: [Note] {
        if let selected = selectedDate {
            return notes.filter { Calendar.current.isDate($0.date, inSameDayAs: selected) }
        } else {
            return notes
        }
    }

    private var groupedNotes: [Date: [Note]] {
        Dictionary(grouping: notes, by: { Calendar.current.startOfDay(for: $0.date) })
    }

    private var displayedDates: [Date] {
        (0..<totalCalendarDays).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: calendarStartDate)
        }
    }

    private var missedDays: Int {
        displayedDates.filter { date in
            date <= today && !notes.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
        }.count
    }

    private func sectionTitle(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM"
            return formatter.string(from: date)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }

    private func emptyNoteCell(for date: Date) -> some View {
        let isToday = Calendar.current.isDateInToday(date)
        let isFuture = date > today

        return Button(action: {
            if !isFuture {
                pendingNoteDate = date
                showingCreateNote = true
            }
        }) {
            VStack(spacing: 20) {
                if isFuture {
                    Text("See you soon!")
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .medium))
                } else if isToday {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                } else {
                    VStack(spacing: 20) {
                        Text("Don't forget make\n note on this day")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .medium))
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: isToday ? [] : [5]))
                    .foregroundColor(
                        isFuture ? .yellow : (isToday ? .black : .red)
                    )
            )
            .padding(.horizontal)
        }
    }

    private func noteCell(_ note: Note) -> some View {
        VStack(alignment: .leading) {
            Text(note.text)
                .foregroundColor(.black)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }

    static func mockNotes() -> [Note] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (1...10).compactMap { day in
            guard day % 2 == 0 else { return nil } // Пропускаем нечетные — как будто не вводили
            let date = calendar.date(byAdding: .day, value: -day, to: today)!
            return Note(date: date, text: "Mock note for \(formattedDay(date))")
        }
    }

    static func formattedDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}



#Preview {
    TasksView()
}
