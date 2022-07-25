//
//  AnimalAttributesCard.swift
//  PetSave
//
//  Created by David Duarte on 23/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation
import SwiftUI

struct AnimalAttributesCard: ViewModifier {
  let color: Color
  func body(content: Content) -> some View {
    content
      .padding(4)
      .background(color.opacity(0.2))
      .cornerRadius(8)
      .foregroundColor(color)
      .font(.subheadline)
  }
}
