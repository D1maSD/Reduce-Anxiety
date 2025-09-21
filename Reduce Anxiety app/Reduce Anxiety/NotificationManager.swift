//
//  NotificationManager.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 9/6/25.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    private init() {
        checkAuthorizationStatus()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.authorizationStatus = .authorized
                } else {
                    self.authorizationStatus = .denied
                }
            }
        }
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func scheduleMeditationNotification(at time: Date, title: String = "Time to Meditate", body: String = "It's time for your daily meditation practice") {
        guard authorizationStatus == .authorized else {
            print("Notification permission not granted")
            return
        }
        
        // Remove existing meditation notifications
        removeMeditationNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        // Create date components for the notification
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "meditation_reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Meditation notification scheduled for \(time)")
            }
        }
    }
    
    func removeMeditationNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["meditation_reminder"])
    }
    
    func scheduleTestNotification() {
        guard authorizationStatus == .authorized else {
            print("Notification permission not granted")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification from Reduce Anxiety app"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "test_notification",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling test notification: \(error)")
            } else {
                print("Test notification scheduled")
            }
        }
    }
}

