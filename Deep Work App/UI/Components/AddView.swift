//
//  AddView.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/24/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Binding var show: Bool
    
    var body: some View {
        Button(action: {
            self.show = true
        }) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}
