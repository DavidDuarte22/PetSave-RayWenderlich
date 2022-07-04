/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct AnimalsNearYouView: View {
  
  private let requestManager = RequestManager()
  @SectionedFetchRequest<String, AnimalEntity>(
    sectionIdentifier: \AnimalEntity.animalSpecies,
    sortDescriptors: [
      NSSortDescriptor(keyPath: \AnimalEntity.timestamp,
                     ascending: true)
      ],
    animation: .default
  ) private var sectionedAnimals:
      SectionedFetchResults<String, AnimalEntity>

  @State var isLoading = true
  
  
  func fetchAnimals() async {
    do {
      // perform(_:) connects to the Petfinder API and gets the animals in a structure.
      let animalsContainer: AnimalsContainer = try await
      requestManager.perform(
        AnimalsRequest.getAnimalsWith(
          page: 1,
          latitude: nil,
          longitude: nil
        )
      )

      for var animal in animalsContainer.animals {
        // Iterate over each animal and call toManagedObject(context:) to convert it from the structure to a Core Data object.
        animal.toManagedObject()
      }

      await stopLoading()
    } catch {
      print("Error fetching animals...\(error)")
    }
  }
  
  var body: some View {
    NavigationView {
      // 1. Sets up a List with a ForEach that creates an AnimalRow for each animal.
      List {
        ForEach(sectionedAnimals) { animals in
          Section(header: Text(animals.id)) {
            ForEach(animals) { animal in
              NavigationLink(destination: AnimalDetailsView()) {
                AnimalRow(animal: animal)
              }
            }
          }
        }
      }
      // 2. Uses task(priority:_:) to call fetchAnimals(). Since this is an asynchronous method, you need to use await so the system can handle it properly.
      .task {
          await fetchAnimals()
        }
        .listStyle(.plain)
        .navigationTitle("Animals near you")
      // 3 Adds an overlay(alignment:content:) that will show a ProgressView when isLoading is true.
        .overlay {
          if isLoading {
            ProgressView("Finding Animals near you...")
          }
        }
    }.navigationViewStyle(StackNavigationViewStyle())
  }
  
  @MainActor
  func stopLoading() async {
    isLoading = false
  }
}

struct AnimalsNearYouView_Previews: PreviewProvider {
  static var previews: some View {
    AnimalsNearYouView(isLoading: false)
      .environment(\.managedObjectContext,
        PersistenceController.preview.container.viewContext)
  }
}
