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

class NavigationState: ObservableObject {
  @Published var isNavigatingDisabled = false
}

struct AnimalsNearYouView: View {
  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(keyPath: \AnimalEntity.timestamp, ascending: true)
    ],
    animation: .default
  )
  
  private var animals: FetchedResults<AnimalEntity>

  @ObservedObject var viewModel: AnimalsNearYouViewModel
  @EnvironmentObject var locationManager: LocationManager

  var body: some View {
    NavigationView {
      // First, you use locationIsDisabled to check if you have access to the user’s location. It’s a computed property of LocationManager that checks the app’s location status. If the app doesn’t have permission to access the user’s location data, you show the new RequestLocationView to ask for authorization.
      if locationManager.locationIsDisabled {
        RequestLocationView()
          .navigationTitle("Animals near you")
      } else {
        // 1. Sets up a List with a ForEach that creates an AnimalRow for each animal.
        AnimalListView(animals: animals) {
          // When it appears, the task(priority:_:) modifier calls fetchMoreAnimals() to asynchronously fetch more animals from the API.
          if !animals.isEmpty && viewModel.hasMoreAnimals {
            // You used an HStack and set alignment to be center
            HStack(alignment: .center) {
              // Inside the HStack is the new LoadingAnimation and a frame modifier that sets the max width and height. Also, you added a Text to display the message “Loading more animals…”
              LoadingAnimation()
                .frame(maxWidth: 125, minHeight: 125)
              Text("Loading more animals...")
            }
            // Put the asynchronous call to fetchMoreAnimals inside a task(priority:_:) modifier. You need to do this because the method is async. This code is called when the view appears.
            .task {
              await viewModel.fetchMoreAnimals(location: locationManager.lastSeenLocation)
            }
          }
        }
        
        
        // 2. Uses task(priority:_:) to call fetchAnimals(). Since this is an asynchronous method, you need to use await so the system can handle it properly.
        .task {
          await viewModel.fetchAnimals(location: locationManager.lastSeenLocation)
          }
        .listStyle(.plain)
        .navigationTitle("Animals near you")
        // 3 Adds an overlay(alignment:content:) that will show a ProgressView when isLoading is true.
        .overlay {
          if viewModel.isLoading && animals.isEmpty {
            ProgressView("Finding Animals near you...")
          }
        }
      }
    }
  }
}

struct AnimalsNearYouView_Previews: PreviewProvider {
  static var previews: some View {
    AnimalsNearYouView(viewModel:
                        AnimalsNearYouViewModel(
                          animalFetcher: AnimalsFetcherMock(),
                          animalStore: AnimalStoreService(context: CoreDataHelper.previewContext)
                        )
    )
  }
}
