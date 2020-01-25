//
//  View+Additions.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/25/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

extension View {
    func hideNavigationBar() -> some View {
        self
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
    
    func padding(leading: CGFloat?, trailing: CGFloat?, top: CGFloat?, bottom: CGFloat?) -> some View {
        self
            .padding(.leading, leading)
            .padding(.trailing, trailing)
            .padding(.top, top)
            .padding(.bottom, bottom)
    }
}
