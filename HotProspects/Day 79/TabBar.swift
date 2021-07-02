//
//  TabBar.swift
//  HotProspects
//
//  Created by Alexander Bonney on 6/24/21.
//

import SwiftUI

struct TabBar: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab 1").onTapGesture {
                selectedTab = 1
            }
                .tabItem {
                Image(systemName: "dollarsign.circle")
                Text("Tab 1")
            }.tag(0)
            Text("Tab 2")
                .tabItem {
                Image(systemName: "eurosign.circle")
                Text("Tab 2")
            }.tag(1)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
