//
//  CustomDivider.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/25/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct CustomDivider: View {
    let color: Color = .gray
    let width: CGFloat = 0.25
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct CustomDivider_Previews: PreviewProvider {
    static var previews: some View {
        CustomDivider()
    }
}
