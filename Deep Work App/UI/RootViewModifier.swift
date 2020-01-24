//
//  RootViewModifier.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/21/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Combine

struct RootViewAppearance: ViewModifier {
    @Environment(\.injected) private var injected: DIContainer
    @State private var isActive: Bool = false
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isActive ? 0 : 30)
            .onReceive(stateUpdate) { self.isActive = $0 }
    }
    
    private var stateUpdate: AnyPublisher<Bool, Never> {
        Just(true).eraseToAnyPublisher()
    }
}
