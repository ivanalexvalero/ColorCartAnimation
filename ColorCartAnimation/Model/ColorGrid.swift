//
//  ColorGrid.swift
//  ColorCartAnimation
//
//  Created by Ivan Valero on 24/01/2022.
//

import SwiftUI

struct ColorGrid: Identifiable {
    var id = UUID().uuidString
    var hexValue: String
    var color: Color
    var rotateCard: Bool = false
    var addToGrid: Bool = false
    var showText: Bool = false
    var removeFromView: Bool = false
}
