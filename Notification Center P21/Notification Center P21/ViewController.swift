//
//  ViewController.swift
//  Notification Center P21
//
//  Created by Rev on 03/03/2022.
//

import UIKit
import NotificationCenter

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
            granted, error in
            if granted {
                print("Granted!")
            } else {
                print("Denied!!")
            }
        })
    }
    
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        registerCategory()
        
        let content = UNMutableNotificationContent()
        content.title = "Wake up call reminder"
        content.body = "It might not be your fault but it is your responsibility"
        content.categoryIdentifier = "myCat"
        content.userInfo = ["someId" : 12]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
        center.add(request)
    }
    
    func registerCategory() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let showAction = UNNotificationAction(identifier: "showAction", title: "Open the app gently", options: .foreground)
        let remindAction = UNNotificationAction(identifier: "remindAction", title: "Remind me in 10s", options: .destructive)
        
        let category = UNNotificationCategory(identifier: "myCat", actions: [showAction, remindAction], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customId = userInfo["someId"] as? Int {
            print("Custom data recieved which is an id: \(customId)")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("User swiped or tapped the notif to Open the app")
        case "showAction":
            print("User used our custom made Action (showAction) of a custom made category")
        case "remindAction":
            print("if u wanna change value gotta call a new func or refactor so most code becomes shared in some new func")
            scheduleLocal()
        default:
            break
        }
        
        completionHandler()
    }

}

