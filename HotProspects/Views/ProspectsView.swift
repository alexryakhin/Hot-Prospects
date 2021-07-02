//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Alexander Bonney on 6/27/21.
//
import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    
    @EnvironmentObject var prospects: Prospects
    @State private var showingScanner = false
    @Binding var selectedTab: String
    @State private var sorting: Sorting = .name
    @State private var showingActionSheet = false
    
    var filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people.sorted {
                switch sorting {
                case .name:
                    return $0.name < $1.name
                case .date:
                    return $0.createdDate > $1.createdDate
                }
            }
        case .contacted:
            return prospects.people.filter { person in
                person.isContacted
            }.sorted {
                switch sorting {
                case .name:
                    return $0.name < $1.name
                case .date:
                    return $0.createdDate > $1.createdDate
                }
            }
        case .uncontacted:
            return prospects.people.filter { person in
                !person.isContacted
            }.sorted {
                switch sorting {
                case .name:
                    return $0.name < $1.name
                case .date:
                    return $0.createdDate > $1.createdDate
                }
            }
        }
    }
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(filteredProspects) { person in
                        VStack(alignment: .leading) {
                            if selectedTab == "Everyone" {
                                HStack {
                                    if person.isContacted {
                                        Image(systemName: "checkmark.circle")
                                    } else {
                                        Image(systemName: "xmark.circle")
                                    }
                                    VStack(alignment: .leading) {
                                        Text("\(person.name)").font(.headline)
                                        Text(person.emailAddress).font(.subheadline).foregroundColor(.secondary)
                                    }
                                }
                            } else {
                                Text("\(person.name)").font(.headline)
                                Text(person.emailAddress).font(.subheadline).foregroundColor(.secondary)
                            }
                            
                        }
                        .contextMenu(ContextMenu(menuItems: {
                            Button(action: {
                                prospects.toggle(person)
                            }, label: {
                                Text(person.isContacted ? "Mark uncontacted" : "Mark contacted")
                            })
                            if person.isContacted {
                                Button(action: {
                                    addNotification(for: person)
                                }, label: {
                                    Text("Remind me")
                                })
                            }
                        }))
                    }
//                    .onDelete(perform: { indexSet in
//                        if selectedTab == "Everyone" {
//                            prospects.remove(of: indexSet)
//                        }
//                    })
                }
            }
            .sheet(isPresented: $showingScanner, content: {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Alex Ryakhin\nbonney977@gmail.com", completion: handleScan)
            })
            .navigationBarItems(leading: Button(action: {
                showingActionSheet = true
            }, label: {
                Text("Sort")
            }), trailing: Button(action: {
                showingScanner = true
            }, label: {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            }))
            .actionSheet(isPresented: $showingActionSheet, content: {
                ActionSheet(title: Text("Sorting"), message: Text("How would you like to sort the list of people?"), buttons: [
                    .default(Text("By name")) { sorting = .name },
                    .default(Text("By most recent")) { sorting = .date }
                ])
            })
            .navigationTitle(title)
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
//            var dateComponents = DateComponents()
//            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
                print("notification has been created")
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                        print("notification has been created")
                    } else if let error = error {
                        print(error.localizedDescription)
                        print("notification has not been created")
                    }
                }
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        showingScanner = false
        switch result {
        case .success(let code):
//            print("\(code)")
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
//            print("\(person.createdDate)")
        case .failure(let error):
            print("Scanning failed")
            print(error.localizedDescription)
        }
    }
}

enum FilterType {
    case none
    case contacted
    case uncontacted
}

enum Sorting {
    case name
    case date
}
