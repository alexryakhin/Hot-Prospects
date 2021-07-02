//
//  ContextMenuView.swift
//  HotProspects
//
//  Created by Alexander Bonney on 6/26/21.
//

import SwiftUI

struct ContextMenuView: View {
    
    @State private var background = Color.white
    
    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            Text("Change backgroung")
                .font(.headline)
                .contextMenu(ContextMenu(menuItems: {
                    Button(action: {
                        background = .red
                    }, label: {
                        Text("Red")
                    })
                    Button(action: {
                        background = .white
                    }, label: {
                        Text("White")
                    })
                    Button(action: {
                        background = .blue
                    }, label: {
                        Text("Blue")
                    })
                }))
        }
    }
}

struct ContextMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ContextMenuView()
    }
}
