//
//  ContentView.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/20/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct RootView: View {
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    var body: some View {
        HomeView().inject(container)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(container: .preview)
    }
}
