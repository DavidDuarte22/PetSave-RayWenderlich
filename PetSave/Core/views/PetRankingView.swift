//
//  PetRankingView.swift
//  PetSave
//
//  Created by David Duarte on 4/9/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import SwiftUI

struct PetRankingView: View {
  // PetRankingViewModel, which is an @ObservedObject, responds to changes in the published elements of the model.
  @ObservedObject var viewModel: PetRankingViewModel
  var animal: AnimalEntity
  // The init method sets the animal and initializes the PetRankingViewModel.
  init(animal: AnimalEntity) {
    self.animal = animal
    viewModel = PetRankingViewModel(animal: animal)
  }
  // The body consists of a Text label in front of five PetRankImages arranged in an HStack.
  var body: some View {
    HStack {
      Text("Rank me!")
        .multilineTextAlignment(.center)
      ForEach(0...4, id: \.self) { index in
        PetRankImage(index: index, recentIndex: $viewModel.ranking)
      }
    }
  }
}

struct PetRankImage: View {
  // opacity and tapped are @State properties. They track whether this particular image is enabled, contributing to the overall ranking. The recentIndex @Binding comes in from the parent control and determines whether this image is enabled.
  let index: Int
  @State var opacity: Double = 0.4
  @State var tapped = false
  @Binding var recentIndex: Int

  var body: some View {
    // The Image has opacity, onTapGesture and onChange modifiers to help change the state based on user interaction.
    Image("creature_dog-and-bone")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .opacity(opacity)
      .frame(width: 50, height: 50)
      .onTapGesture {
        opacity = tapped ? 0.4 : 1.0
        tapped.toggle()
        recentIndex = index
      }
      .onChange(of: recentIndex) { value in
        checkOpacity(value: value)
      }
      .onAppear {
        checkOpacity(value: recentIndex)
      }
  }
  // checkOpacity updates the image’s opacity based on the passed in recentIndex.
  func checkOpacity(value: Int) {
    opacity = value >= index ? 1.0 : 0.4
    tapped.toggle()
  }
}

final class PetRankingViewModel: ObservableObject {
  var animal: AnimalEntity
  // The ranking property has didSet that publishes the change to listeners of the model using objectWillChange.send().
  var ranking: Int {
    didSet {
      animal.ranking = Int32(ranking)
      objectWillChange.send()
    }
  }
  // The init method initializes the animal and ranking properties based on the passed in animal property.
  init(animal: AnimalEntity) {
    self.animal = animal
    self.ranking = Int(animal.ranking)
  }
}

struct PetRankingView_Previews: PreviewProvider {
  static var previews: some View {
    if let animal = CoreDataHelper.getTestAnimalEntity() {
      PetRankingView(animal: animal)
        .padding()
        .previewLayout(.sizeThatFits)
    }
  }
}
