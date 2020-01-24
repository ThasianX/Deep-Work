//
//  DependencyInjector.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/21/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

// MARK: - DIContainer
struct DIContainer: EnvironmentKey {
    let appState: Store<AppState>
    let interactors: Interactors
    
    static var `defaultValue`: Self { Self.default }
    private static let `default` = Self(appState: .init(AppState()), interactors: .stub)
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(appState: .init(AppState.preview), interactors: .stub)
    }
}
#endif

// MARK: - Injection into view hiearchy
extension View {
    func inject(_ appState: AppState,
                _ interactors: DIContainer.Interactors) -> some View {
        let container = DIContainer(appState: .init(appState), interactors: interactors)
        return inject(container)
    }
    
    func inject(_ container: DIContainer) -> some View {
        self
            .modifier(RootViewAppearance())
            .environment(\.injected, container)
    }
}
