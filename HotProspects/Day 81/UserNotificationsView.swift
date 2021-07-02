//
//  UserNotificationsView.swift
//  HotProspects
//
//  Created by Alexander Bonney on 6/26/21.
//

import SwiftUI
import UserNotifications

struct UserNotificationsView: View {
    var body: some View {
        VStack {
            Button(action: {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }, label: {
                Text("Request permission")
            })
            Button(action: {
                let content = UNMutableNotificationContent()
                content.sound = UNNotificationSound.default
                content.title = "Time to feed the cat"
                content.subtitle = "It looks hungry"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }, label: {
                Text("Schedule Notification")
            })
        }
    }
}

struct UserNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        UserNotificationsView()
    }
}
