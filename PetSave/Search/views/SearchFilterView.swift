//
//  SearchFilterView.swift
//  PetSave
//
//  Created by David Duarte on 25/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import SwiftUI

struct SearchFilterView: View {
  
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var viewModel: SearchViewModel

  var body: some View {
    Form {
      Section {
        // it adds a Picker view for selecting the pet’s age. This value can either be baby, young, adult or senior which are the cases for AnimalSearchAge.
        Picker("Age", selection: $viewModel.ageSelection) {
          ForEach(AnimalSearchAge.allCases, id: \.self) { age in
            Text(age.rawValue.capitalized)
          }
        }
        // it adds an onChange(of:perform:) view modifier that triggers a call to viewModel.search when an age is selected.
        .onChange(of: viewModel.ageSelection) { _ in
          viewModel.search()
        }

        // It adds another Picker view for selecting the pet’s type. This value can be cat, dog, rabbit, smallAndFurry, horse, bird, scalesFinsAndOther or barnyard, which are the cases for AnimalSearchType.
        Picker("Type", selection: $viewModel.typeSelection) {
          ForEach(AnimalSearchType.allCases, id: \.self) { type in
            Text(type.rawValue.capitalized)
          }
        }
        //  it adds an onChange(of:perform:) view modifier that also triggers a call to viewModel.search, but this time, with the selected type.
        .onChange(of: viewModel.typeSelection) { _ in
          viewModel.search()
        }
      } footer: {
        Text("You can mix both, age and type, to make a more accurate search.")
      }

      // It adds two buttons, one for clearing both filters and another for dismissing the view.
      Button("Clear", role: .destructive, action: viewModel.clearFilters)
      Button("Done") {
        dismiss()
      }
    }
    .navigationBarTitle("Filters")
    .toolbar {
      // It adds a toolbar button for dismissing the view.
      ToolbarItem {
        Button {
          dismiss()
        } label: {
          Label("Close", systemImage: "xmark.circle.fill")
        }
      }
    }
  }
}

struct SearchFilterView_Previews: PreviewProvider {
  static var previews: some View {
    let context = PersistenceController.preview.container.viewContext
    
    NavigationView {
      SearchFilterView(
        viewModel: SearchViewModel(
          animalSearcher: AnimalSearcherMock(),
          animalStore: AnimalStoreService(context: context)
        )
      )
    }
  }
}
