//
//  NotificationManager.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 11.09.22.
//

import UIKit
import UserNotifications

enum NotificationError: Error {
    case authFailed
    case requestFailed
}

final class NotificationManager {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let userDefaults = UserDefaults.standard
    
    func checkUserPermission(completionHandler: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard error == nil else {
                //TODO: - FIX  this with alert
                print(NotificationError.authFailed)
                return
            }
            completionHandler(granted)
        }
    }
    
    func createNotification(withTitle title: String, description text: String, weekDay: Int, hourDate: Date) {
        //content setup
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = text
        content.sound = .default
        //trigger configuration
        let id = UUID().uuidString
        userDefaults.set(id, forKey: title)
        let timeInterval = hourDate.addingTimeInterval(60 * 60 * 24 * 7)
        var dateComponents = Calendar.current.dateComponents(
            [.hour, .minute],
            from: timeInterval
        )
        dateComponents.weekday = weekDay
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        //creating request object
        let notificationRequest = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        //scheduling request
        notificationCenter.add(notificationRequest) { error in
            guard error == nil else {
                print(NotificationError.requestFailed)
                return
            }
        }
    }
    
    func removePendingNotification(key: String?) {        
        if let key = key,
           let identifier = userDefaults.string(forKey: key) {
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
            userDefaults.removeObject(forKey: key)
        }
    }
}
