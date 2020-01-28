//
//  SelectionDial.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/27/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct SelectionDial: View {
    // MARK: Persistent Properties
    @State private var value: CGFloat = 0
    @State private var showValue: Bool = false
    @Binding var start: Bool
    
    // MARK: Stored Properties
    private let initialValue: CGFloat
    private let scale: CGFloat
    private let indicatorLength: CGFloat
    private let maxValue: CGFloat = 181
    private let stepSize: CGFloat = 1
    
    // MARK: Computed Properties
    private var innerScale: CGFloat {
        return scale - indicatorLength
    }
    
    // MARK: Initialization
    init(start: Binding<Bool>, initialValue: CGFloat, length: CGFloat) {
        self._start = start
        self.initialValue = initialValue
        self.scale = length
        self.indicatorLength = length / 10
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: self.innerScale, height: self.innerScale, alignment: .center)
                .rotationEffect(.degrees(-90))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                        let x: CGFloat = min(max(value.location.x, 0), self.innerScale)
                        let y: CGFloat = min(max(value.location.y, 0), self.innerScale)
                        
                        let ending = CGPoint(x: x, y: y)
                        let start = CGPoint(x: self.innerScale / 2, y: self.innerScale / 2)
                        
                        let angle = self.angle(between: start, ending: ending)
                        self.value = CGFloat(Int(((angle / 360) * (self.maxValue / self.stepSize)))) / (self.maxValue / self.stepSize)
                        self.showValue = true
                    }
                    .onEnded { value in
                        self.showValue = false
                    }
            )
            Circle()
                .stroke(Color.secondary, style: StrokeStyle(lineWidth: self.indicatorLength, lineCap: .butt, lineJoin: .miter, dash: [4]))
                .frame(width: self.scale, height: self.scale, alignment: .center)
            Circle()
                .trim(from: 0.0, to: self.value)
                .stroke(Color.black, style: StrokeStyle(lineWidth: self.indicatorLength, lineCap: .butt, lineJoin: .miter, dash: [4]))
                .rotationEffect(.degrees(-90))
                .frame(width: self.scale, height: self.scale, alignment: .center)
            
            if self.showValue {
                Text("\(self.formatTime(value: self.value * self.maxValue))")
                    .font(.title)
                    .foregroundColor(Color.black)
                    .fontWeight(.semibold)
            } else {
                Button(action: {
                    self.start = true
                }) {
                    Text("Start").foregroundColor(Color.black)
                }
            }
        }
        .onAppear {
            self.value = self.initialValue / self.maxValue
        }
    }
    
    // MARK: Methods
    private func angle(between starting: CGPoint, ending: CGPoint) -> CGFloat {
        let center = CGPoint(x: ending.x - starting.x, y: ending.y - starting.y)
        let radians = atan2(center.y, center.x)
        let degrees = 90 + (radians * 180 / .pi)
        
        return (degrees < 0) ? (degrees + 360) : degrees
    }
    
    private func formatTime(value: CGFloat) -> String {
        let hours = Int(value / 60)
        let min = Int(value) % 60
        
        let time: String
        if hours == 0 {
            time = "\(min) min"
        } else if min == 0 {
            time = "\(hours) hr"
        } else {
            time = "\(hours) hr \(min) min"
        }
        
        return time
    }
}

struct SelectionDial_Previews: PreviewProvider {
    static var previews: some View {
        SelectionDial(start: .constant(false), initialValue: 0, length: 275)
    }
}
