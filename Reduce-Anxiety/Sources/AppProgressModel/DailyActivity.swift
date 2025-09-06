//
//  DailyActivity.swift
//  Reduce-Anxiety
//
//  Created by Dima Melnik on 8/8/25.
//


import Foundation
import AppNotePad
import SwiftUI

public struct DailyActivity: Codable {
    public var date: Date
    public var hasNote: Bool
    public var hasMeditation: Bool
}

public class AppProgressModel: ObservableObject {
    @Published var dailyActivities: [DailyActivity] = []
    @Published var notes: [Note] = [] // ← добавили

        private let storageKey = "AppProgressModel_Activities"
        private let notesKey = "AppProgressModel_Notes"

    public init() {
        load()
    }

    public func recordNote(_ note: Note) {
            update(date: note.date) { activity in
                activity.hasNote = true
            }
            if let idx = notes.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: note.date) }) {
                notes[idx] = note
            } else {
                notes.append(note)
            }
            save()
        }

    public func recordMeditation(on date: Date) {
        update(date: date) { activity in
            activity.hasMeditation = true
        }
    }

    public func activities(forLastDays days: Int) -> [DailyActivity] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<days).map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
            return dailyActivities.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) ?? DailyActivity(date: date, hasNote: false, hasMeditation: false)
        }.reversed()
    }

    public var totalNotes: Int {
        dailyActivities.filter { $0.hasNote }.count
    }

    public var totalMeditations: Int {
        dailyActivities.filter { $0.hasMeditation }.count
    }

    // MARK: - Private Methods

    private func update(date: Date, modify: (inout DailyActivity) -> Void) {
        let calendar = Calendar.current
        let dateStart = calendar.startOfDay(for: date)
        if let idx = dailyActivities.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: dateStart) }) {
            modify(&dailyActivities[idx])
        } else {
            var new = DailyActivity(date: dateStart, hasNote: false, hasMeditation: false)
            modify(&new)
            dailyActivities.append(new)
        }
        save()
    }

    private func save() {
            if let data = try? JSONEncoder().encode(dailyActivities) {
                UserDefaults.standard.set(data, forKey: storageKey)
            }
            if let data = try? JSONEncoder().encode(notes) {
                UserDefaults.standard.set(data, forKey: notesKey)
            }
        }

    private func load() {
            if let data = UserDefaults.standard.data(forKey: storageKey),
               let decoded = try? JSONDecoder().decode([DailyActivity].self, from: data) {
                dailyActivities = decoded
            }
            if let data = UserDefaults.standard.data(forKey: notesKey),
               let decoded = try? JSONDecoder().decode([Note].self, from: data) {
                notes = decoded
            }
        }
}
