//
//  AnimalRow.swift
//  PetSave
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import SwiftUI

struct AnimalRow: View {
  let animal: AnimalEntity

  var body: some View {
    HStack {
      AsyncImage(url: animal.picture) { image in
        image
          .resizable()
      } placeholder: {
        Image("rw-logo")
          .resizable()
          .overlay {
            if animal.picture != nil {
              ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray.opacity(0.4))
            }
          }
      }
      .aspectRatio(contentMode: .fit)
      .frame(width: 112, height: 112)
      .cornerRadius(8)

      VStack(alignment: .leading) {
        Text(animal.name ?? "")
          .multilineTextAlignment(.center)
          .font(.title3)
      }
      .lineLimit(1)
    }
  }
}

struct AnimalRow_Previews: PreviewProvider {
  static var previews: some View {
    if let animal = CoreDataHelper.getTestAnimalEntity() {
      AnimalRow(animal: animal)
    }
  }
}
