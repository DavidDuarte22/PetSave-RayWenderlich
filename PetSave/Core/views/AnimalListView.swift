//
//  AnimalListView.swift
//  PetSave
//
//  Created by David Duarte on 25/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import SwiftUI

// it defines constraints to those types, Content being a View, Data a RandomAccessCollection and Data.Element an AnimalEntity. Now, you can use AnimalListView with any type of collection, as long as it’s a collection of AnimalEntity.
struct AnimalListView<Content, Data>: View
  where Content: View,
  Data: RandomAccessCollection,
  Data.Element: AnimalEntity {
  let animals: Data

  // A property for holding the list’s footer view.
  let footer: Content

  // An initializer that takes an array of animal entities and a view builder closure for the footer view.
  init(animals: Data, @ViewBuilder footer: () -> Content) {
    self.animals = animals
    self.footer = footer()
  }

  // A second initializer that takes only an array of animal entities. This initializer uses an empty view for the list’s footer.
  init(animals: Data) where Content == EmptyView {
    self.init(animals: animals) {
      EmptyView()
    }
  }

  var body: some View {
    // The body of the view, laying down a list with rows of animals.
    List {
      ForEach(animals) { animal in
        NavigationLink(destination: AnimalDetailsView()) {
          AnimalRow(animal: animal)
        }
      }

      // The footer view passed in the initializer, placed at the bottom of the list.
      footer
    }
    .listStyle(.plain)
  }
}

struct AnimalListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AnimalListView(animals: CoreDataHelper.getTestAnimalEntities() ?? [])
    }

    NavigationView {
      AnimalListView(animals: []) {
        Text("This is a footer")
      }
    }
  }
}
