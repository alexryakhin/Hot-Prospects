//
//  ManuallyPuplishingView.swift
//  HotProspects
//
//  Created by Alexander Bonney on 6/26/21.
//

import SwiftUI


class DelayedUpdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ManuallyPuplishingView: View {
    
    @ObservedObject var vm = DelayedUpdater()
    
    var body: some View {
        Text("Value: \(vm.value)")
    }
}

struct ManuallyPuplishingView_Previews: PreviewProvider {
    static var previews: some View {
        ManuallyPuplishingView()
    }
}
