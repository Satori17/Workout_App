//
//  NotificationManager.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 11.09.22.
//

import UIKit
import UserNotifications

enum NotificationError: String, Error {
    case authFailed = "Notification Authorisation Failed, please try again."
    case requestFailed = "Adding notification Failed, please try again."
}

final class NotificationManager {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let userDefaults = UserDefaults.standard
    
    func checkUserPermission(completionHandler: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard error == nil else {
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
    
    func deniedNotificationAlert(onVC vc: UIViewController)  {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "Notifications Denied", message: "If you want to schedule workouts, please enable Notifications in Settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            
            alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { action in
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }))
            vc.present(alert, animated: true)
        }
    }
}
