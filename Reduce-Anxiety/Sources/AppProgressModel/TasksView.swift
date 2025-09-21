//
//  NotesScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI

// MARK: - Модель записи
public struct Note: Identifiable, Codable {
    public let id: UUID
    public var date: Date
    public var text: String

    init(id: UUID = UUID(), date: Date, text: String) {
        self.id = id
        self.date = date
        self.text = text
    }
}
// MARK: - Основной экран задач
public struct TasksView: View {
    @State private var selectedDate: Date? = nil
    @State private var pendingNoteDate: SheetDate? = nil

    @EnvironmentObject var progressModel: AppProgressModel
    private let isMockMode = false

    private let totalCalendarDays = 92
    private let today = Calendar.current.startOfDay(for: Date())

    private var calendarStartDate: Date {
        if isMockMode {
            return Calendar.current.date(byAdding: .day, value: -10, to: today) ?? today
        } else {
            return today
        }
    }
    public init() {
        
    }
    public var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Header
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
                            .foregroundColor(.defaultAppWhite)
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
                    notes: progressModel.notes, // 👈 теперь берём из модели
                    calendarStartDate: calendarStartDate,
                    totalDays: totalCalendarDays
                )
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(displayedDates, id: \.self) { date in
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
            .background(Color.defaultAppDark.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(item: $pendingNoteDate) { wrapper in
                CreateNoteView { newNote in
                    var note = newNote
                    note.date = wrapper.value
                    progressModel.recordNote(note) // 👈 только в модель
                    pendingNoteDate = nil
                }
            }
            .onAppear {
                print("TasksView opened")
            }
        }
    }

    // MARK: - Computed properties

    private var groupedNotes: [Date: [Note]] {
        Dictionary(grouping: progressModel.notes, by: { Calendar.current.startOfDay(for: $0.date) })
    }

    private var displayedDates: [Date] {
        (0..<totalCalendarDays).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: calendarStartDate)
        }
    }

    private var missedDays: Int {
        displayedDates.filter { date in
            date <= today && !progressModel.notes.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
        }.count
    }

    // MARK: - Helpers

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
                pendingNoteDate = SheetDate(value: Calendar.current.startOfDay(for: date))
            }
        }) {
            VStack(spacing: 20) {
                if isFuture {
                    Text("See you soon!")
                        .foregroundColor(.defaultAppWhite)
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
                            .foregroundColor(.defaultAppWhite)
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
            .background(Color.defaultAppGray)
            .padding(.horizontal)
        }
    }

    private func noteCell(_ note: Note) -> some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(note.text)
                    .foregroundColor(.defaultAppWhite)
                    .font(.system(size: 16))
                    .lineLimit(nil) // многострочный текст
                    .padding(.trailing, 8) // отступ, чтобы текст не залезал под дату
                    .layoutPriority(1)

                Spacer()

                Text(formattedShortDate(note.date))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .fixedSize() // не переносим дату
            }
            .padding(12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.defaultAppGray)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                .foregroundColor(Color.green.opacity(0.7)) // зелёно-салатовая пунктирная рамка
        )
        .cornerRadius(10)
        .padding(.horizontal)
    }

    private func formattedShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: date)
    }
}




#Preview {
    TasksView()
}
struct SheetDate: Identifiable, Equatable {
    let value: Date
    // Стабильный id по дню (чтобы один и тот же день = один id)
    var id: TimeInterval { Calendar.current.startOfDay(for: value).timeIntervalSince1970 }
}
extension Color {
    static let defaultAppDark = Color("defaultDark")
    static let defaultAppWhite = Color("defaultWhite")
    static let defaultAppGray = Color("defaultGray")
}
