//
//  ContentView.swift
//  HotProspects
//
//  Created by Alexander Bonney on 6/24/21.
//

import SwiftUI

struct ContentView: View {
    var prospects = Prospects()
    @State private var selectedTab = "Everyone"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProspectsView(selectedTab: $selectedTab, filter: .none)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Everyone")
                }.tag("Everyone")
            ProspectsView(selectedTab: $selectedTab, filter: .contacted)
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Contacted")
                }.tag("Contacted")
            ProspectsView(selectedTab: $selectedTab, filter: .uncontacted)
                .tabItem {
                    Image(systemName: "questionmark.diamond")
                    Text("Uncontacted")
                }.tag("Uncontacted")
            MeView()
                .tabItem {
                    Image(systemName: "person.crop.square")
                    Text("Me")
                }.tag("Me")
        }.environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
