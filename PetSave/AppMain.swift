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
import PetSaveOnboarding

@main
struct AppMain: App {
  // @AppStorage is a SwiftUI property wrapper that works hand-in-hand with UserDefaults. It saves the value of shouldPresentOnboarding in UserDefaults.
  @AppStorage(AppUserDefaultsKeys.onboarding)
    var shouldPresentOnboarding = true
  // The model data to show the first time of app launch.
  var onboardingModels: [OnboardingModel] {
    [
      OnboardingModel(
        title: "Welcome to\n PetSave",
        description:
          "Looking for a Pet?\n Then you're at the right place",
        image: .bird
      ),
      OnboardingModel(
        title: "Search...",
        description:
          "Search from a list of our huge database of animals.",
        image: .dogBoneStand
      ),
      OnboardingModel(
        title: "Nearby",
        description:
          "Find pets to adopt from nearby your place...",
        image: .chameleon
      )
    ]
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
      // Shows the full-screen cover if shouldPresentOnboarding is true.
      .sheet(
        isPresented: $shouldPresentOnboarding, onDismiss: nil
      ) {
          // Presents PetSaveOnboardingView with the model data.
          PetSaveOnboardingView(items: onboardingModels)
          .onSkip { // On Skip button tap, set shouldPresentOnboarding to false to avoid showing the onboarding again.
            shouldPresentOnboarding = false
          }
        }
      }
  }
}
