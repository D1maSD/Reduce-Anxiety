//
//  AppProgressModel.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 8/2/25.
//

//import Foundation
//import SwiftUI
//

//
//public class AppProgressModel: ObservableObject {
//    @Published var dailyActivities: [DailyActivity] = []
//
//    private let storageKey = "AppProgressModel_Activities"
//
//    init() {
//        load()
//    }
//
//    func recordNote(on date: Date) {
//        update(date: date) { $0.hasNote = true }
//    }
//
//    func recordMeditation(on date: Date) {
//        update(date: date) { $0.hasMeditation = true }
//    }
//
//    func activities(forLastDays days: Int) -> [DailyActivity] {
//        let calendar = Calendar.current
//        let today = calendar.startOfDay(for: Date())
//        return (0..<days).map { offset in
//            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
//            return dailyActivities.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) ?? DailyActivity(date: date, hasNote: false, hasMeditation: false)
//        }.reversed()
//    }
//
//    var totalNotes: Int {
//        dailyActivities.filter { $0.hasNote }.count
//    }
//
//    var totalMeditations: Int {
//        dailyActivities.filter { $0.hasMeditation }.count
//    }
//
//    // MARK: - Private Methods
//
//    private func update(date: Date, update: (inout DailyActivity) -> Void) {
//        let calendar = Calendar.current
//        let dateStart = calendar.startOfDay(for: date)
//
//        if let index = dailyActivities.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: dateStart) }) {
//            update(&dailyActivities[index])
//        } else {
//            var activity = DailyActivity(date: dateStart, hasNote: false, hasMeditation: false)
//            update(&activity)
//            dailyActivities.append(activity)
//        }
//        save()
//    }
//
//    private func save() {
//        if let data = try? JSONEncoder().encode(dailyActivities) {
//            UserDefaults.standard.set(data, forKey: storageKey)
//        }
//    }
//
//    private func load() {
//        if let data = UserDefaults.standard.data(forKey: storageKey),
//           let decoded = try? JSONDecoder().decode([DailyActivity].self, from: data) {
//            dailyActivities = decoded
//        }
//    }
//}
