//
//  DailyActivity.swift
//  Reduce-Anxiety
//
//  Created by Dima Melnik on 8/8/25.
//


import Foundation
import SwiftUI
import AppProgressModel

public struct DailyActivity: Codable {
    public var date: Date
    public var hasNote: Bool
    public var hasMeditation: Bool
}

public class AppProgressModel: ObservableObject {
    @Published public var dailyActivities: [DailyActivity] = []
    @Published public var notes: [Note] = [] // ← добавили
    @Published public var meditationManager = MeditationManager()

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

import Foundation
import SwiftUI

// MARK: - Unified Meditation Model
public struct Meditation: Identifiable, Codable, Equatable, Hashable, Sendable {
   public let id: UUID
   public let title: String
   public let subtitle: String
   public let imageName: String
   public let audioFileName: String?
   public let duration: Int? // in minutes
   public let isDownloaded: Bool
   
   public init(title: String, subtitle: String, imageName: String, audioFileName: String? = nil, duration: Int? = nil, isDownloaded: Bool = false) {
       self.id = UUID()
       self.title = title
       self.subtitle = subtitle
       self.imageName = imageName
       self.audioFileName = audioFileName
       self.duration = duration
       self.isDownloaded = isDownloaded
   }
   
   // MARK: - Static Data
   public static let allMeditations: [Meditation] = [
       Meditation(title: "Love to body", subtitle: "Relax and unwind", imageName: "love_to_body", audioFileName: "love_to_body.mp3", duration: 10),
       Meditation(title: "Best sides of yourself", subtitle: "Focus your mind", imageName: "meditation2", audioFileName: "best_sides.mp3", duration: 15),
       Meditation(title: "Santosha", subtitle: "Focus your mind", imageName: "meditation2", audioFileName: "santosha.mp3", duration: 12),
       Meditation(title: "Focus mind meditation", subtitle: "Focus your mind", imageName: "meditation2", audioFileName: "focus_mind.mp3", duration: 8),
       Meditation(title: "Daily Trivia", subtitle: "Learn about the faith", imageName: "daily_trivia", audioFileName: "daily_trivia.mp3", duration: 5),
       Meditation(title: "The Word", subtitle: "Solve the word of the day and learn more about your faith!", imageName: "the_word", audioFileName: "the_word.mp3", duration: 7),
       Meditation(title: "Daily Rosary", subtitle: "Daily Mysteries • 7 sessions", imageName: "daily_rosary", audioFileName: "daily_rosary.mp3", duration: 20),
       Meditation(title: "Divine Revelation", subtitle: "Part 1, Section 1 • 25 sessions", imageName: "divine_revelation", audioFileName: "divine_revelation.mp3", duration: 15),
       Meditation(title: "Rosary", subtitle: "Dr. Scott Hahn • 7 sessions", imageName: "rosary", audioFileName: "rosary.mp3", duration: 18),
       Meditation(title: "Daily Reflections", subtitle: "Jeff Cavins & Jonathan Roumie • 1415 sessions", imageName: "daily_reflections", audioFileName: "daily_reflections.mp3", duration: 10),
       Meditation(title: "Daily Gospel", subtitle: "Daily Lectio Divina • 2136 sessions", imageName: "daily_gospel", audioFileName: "daily_gospel.mp3", duration: 12),
       Meditation(title: "Morning Psalms", subtitle: "Bishop Barron • 28 sessions", imageName: "morning_psalms", audioFileName: "morning_psalms.mp3", duration: 8),
       Meditation(title: "Daily Mass Readings", subtitle: "Listen & Pray • 1439 sessions", imageName: "daily_mass_readings", audioFileName: "daily_mass_readings.mp3", duration: 15),
       Meditation(title: "Daily Saint", subtitle: "Pray with the Saints • 262 sessions", imageName: "daily_saint", audioFileName: "daily_saint.mp3", duration: 6),
       Meditation(title: "Gospel of Matthew", subtitle: "Biblical Study • 45 sessions", imageName: "gospel_matthew", audioFileName: "gospel_matthew.mp3", duration: 25)
   ]
   
   // MARK: - Core Meditations (the 4 main ones)
   public static let coreMeditations: [Meditation] = [
       Meditation(title: "Love to body", subtitle: "Relax and unwind", imageName: "love_to_body", audioFileName: "love_to_body.mp3", duration: 10),
       Meditation(title: "Best sides of yourself", subtitle: "Focus your mind", imageName: "meditation2", audioFileName: "best_sides.mp3", duration: 15),
       Meditation(title: "Santosha", subtitle: "Focus your mind", imageName: "meditation2", audioFileName: "santosha.mp3", duration: 12),
       Meditation(title: "Focus mind meditation", subtitle: "Focus your mind", imageName: "meditation2", audioFileName: "focus_mind.mp3", duration: 8)
   ]
}

// MARK: - Downloaded Meditation Model
public struct DownloadedMeditation: Identifiable, Codable, Sendable {
   public let id: UUID
   public let meditation: Meditation
   public let downloadDate: Date
   public let localFilePath: String
   
   public init(meditation: Meditation, localFilePath: String) {
       self.id = UUID()
       self.meditation = meditation
       self.downloadDate = Date()
       self.localFilePath = localFilePath
   }
}

// MARK: - Meditation Manager
public class MeditationManager: ObservableObject {
   @Published public var downloadedMeditations: [DownloadedMeditation] = []
   @Published public var favoriteMeditations: [Meditation] = []
   @Published public var recentlyPlayedMeditations: [Meditation] = []
   @Published public var routineMeditations: [Meditation] = []
   
   private let downloadedMeditationsKey = "DownloadedMeditations"
   private let favoriteMeditationsKey = "FavoriteMeditations"
   private let recentlyPlayedKey = "RecentlyPlayedMeditations"
   private let routineMeditationsKey = "RoutineMeditations"
   
   public init() {
       loadDownloadedMeditations()
       loadFavoriteMeditations()
       loadRecentlyPlayedMeditations()
       loadRoutineMeditations()
   }
   
   // MARK: - Download Management
   public func downloadMeditation(_ meditation: Meditation) {
       // Simulate download by creating a local file path
       let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
       let audioPath = documentsPath.appendingPathComponent("\(meditation.audioFileName ?? "meditation.mp3")")
       
       // Create the downloaded meditation
       let downloadedMeditation = DownloadedMeditation(
           meditation: meditation,
           localFilePath: audioPath.path
       )
       
       // Add to downloaded meditations if not already downloaded
       if !downloadedMeditations.contains(where: { $0.meditation.id == meditation.id }) {
           downloadedMeditations.append(downloadedMeditation)
           saveDownloadedMeditations()
       }
   }
   
   public func removeDownloadedMeditation(_ meditation: Meditation) {
       downloadedMeditations.removeAll { $0.meditation.id == meditation.id }
       saveDownloadedMeditations()
   }
   
   public func isDownloaded(_ meditation: Meditation) -> Bool {
       return downloadedMeditations.contains { $0.meditation.id == meditation.id }
   }
   
   // MARK: - Favorites Management
   public func addToFavorites(_ meditation: Meditation) {
       if !favoriteMeditations.contains(where: { $0.id == meditation.id }) {
           favoriteMeditations.append(meditation)
           saveFavoriteMeditations()
       }
   }
   
   public func removeFromFavorites(_ meditation: Meditation) {
       favoriteMeditations.removeAll { $0.id == meditation.id }
       saveFavoriteMeditations()
   }
   
   public func isFavorite(_ meditation: Meditation) -> Bool {
       return favoriteMeditations.contains { $0.id == meditation.id }
   }
   
   // MARK: - Recently Played Management
   public func markAsPlayed(_ meditation: Meditation) {
       // Remove if already exists to avoid duplicates
       recentlyPlayedMeditations.removeAll { $0.id == meditation.id }
       // Add to beginning
       recentlyPlayedMeditations.insert(meditation, at: 0)
       // Keep only last 10
       if recentlyPlayedMeditations.count > 10 {
           recentlyPlayedMeditations = Array(recentlyPlayedMeditations.prefix(10))
       }
       saveRecentlyPlayedMeditations()
   }
   
   // MARK: - Routine Management
   public func addToRoutine(_ meditation: Meditation) {
       if !routineMeditations.contains(where: { $0.id == meditation.id }) {
           routineMeditations.append(meditation)
           saveRoutineMeditations()
       }
   }
   
   public func removeFromRoutine(_ meditation: Meditation) {
       routineMeditations.removeAll { $0.id == meditation.id }
       saveRoutineMeditations()
   }
   
   public func isInRoutine(_ meditation: Meditation) -> Bool {
       return routineMeditations.contains { $0.id == meditation.id }
   }
   
   // MARK: - Persistence
   private func saveDownloadedMeditations() {
       if let data = try? JSONEncoder().encode(downloadedMeditations) {
           UserDefaults.standard.set(data, forKey: downloadedMeditationsKey)
       }
   }
   
   private func loadDownloadedMeditations() {
       if let data = UserDefaults.standard.data(forKey: downloadedMeditationsKey),
          let decoded = try? JSONDecoder().decode([DownloadedMeditation].self, from: data) {
           downloadedMeditations = decoded
       }
   }
   
   private func saveFavoriteMeditations() {
       if let data = try? JSONEncoder().encode(favoriteMeditations) {
           UserDefaults.standard.set(data, forKey: favoriteMeditationsKey)
       }
   }
   
   private func loadFavoriteMeditations() {
       if let data = UserDefaults.standard.data(forKey: favoriteMeditationsKey),
          let decoded = try? JSONDecoder().decode([Meditation].self, from: data) {
           favoriteMeditations = decoded
       }
   }
   
   private func saveRecentlyPlayedMeditations() {
       if let data = try? JSONEncoder().encode(recentlyPlayedMeditations) {
           UserDefaults.standard.set(data, forKey: recentlyPlayedKey)
       }
   }
   
   private func loadRecentlyPlayedMeditations() {
       if let data = UserDefaults.standard.data(forKey: recentlyPlayedKey),
          let decoded = try? JSONDecoder().decode([Meditation].self, from: data) {
           recentlyPlayedMeditations = decoded
       }
   }
   
   private func saveRoutineMeditations() {
       if let data = try? JSONEncoder().encode(routineMeditations) {
           UserDefaults.standard.set(data, forKey: routineMeditationsKey)
       }
   }
   
   private func loadRoutineMeditations() {
       if let data = UserDefaults.standard.data(forKey: routineMeditationsKey),
          let decoded = try? JSONDecoder().decode([Meditation].self, from: data) {
           routineMeditations = decoded
       }
   }
}
