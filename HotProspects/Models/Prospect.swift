//
//  Prospect.swift
//  HotProspects
//
//  Created by Alexander Bonney on 6/27/21.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name: String = "Anonymos"
    var emailAddress: String = ""
    var createdDate = Date()
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    static let saveKey = "People"
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    @Published private(set) var people: [Prospect]
    
    init() {
        var decodedData = [Prospect]()
//        if let people = UserDefaults.standard.data(forKey: Self.saveKey) {
//            let decoder = JSONDecoder()
//            do {
//                decodedData = try decoder.decode([Prospect].self, from: people)
//                print("loaded")
//            }
//            catch let error {
//                print(error.localizedDescription)
//            }
//        } else {
//            self.people = []
//        }
//        self.people = decodedData
//
        let filename = Self.documentsDirectory.appendingPathComponent(Self.saveKey)
        let decoder = JSONDecoder()
        do {
            let people = try Data(contentsOf: filename)
            decodedData = try decoder.decode([Prospect].self, from: people)
        } catch {
            print("Unable to load saved data.")
        }
        self.people = decodedData
    }
    
    private func save() {
        let encoder = JSONEncoder()
//        do {
//            let encoded = try encoder.encode(people)
//            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
//            print("saved")
//        }
//        catch let error {
//            print(error.localizedDescription)
//        }
        do {
            let filename = Self.documentsDirectory.appendingPathComponent(Self.saveKey)
            let encoded = try encoder.encode(people)
            try encoded.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
        
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
//    func remove(_ prospect: Prospect) {
//        people.remove(at: <#T##Int#>)
//        save()
//    }
    
    func toggle(_ person: Prospect) {
        objectWillChange.send()
        person.isContacted.toggle()
        save()
    }
}
