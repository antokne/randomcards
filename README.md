# randomcards - westpac technical exercise

This is a simple project demonstrating connecting to a ramdom cards api and displaying these in SwiftUI views.

The demo is not using the new Swift macro Observable, nor SwiftData as these are only available in iOS 17 and therefore will not be able to be adopted by westac apps for a numbers of years. 

It is however make use of Structured Concurrency, inlcuding async/await and Combine where appropriate.

Features included are:
1. Sort cards by type, and
2. Save favourite cards.

I have decided to architect this in a way that might be considered for a larger project.

Each layer is it's own package and could be further seperated into repositories if desired. For the purposes of this demo all packages are included in the one repo.

Packages are:
1. The API layer - calls the random cards api and includes it's unit tests,
2. Local Model layer - for storing saved cards, could easily be sync'd with cloud and only be a local offline cache. With it's own unit tests, and
3. View Model layer - Observed objects and calls out to api or model as required. We are using protocols here too that make testing easier.

The final layer is the application itself. All ui is here for this simple test. It is also possible to separate out certain non application specific UI if required to. 

Due to time I have decided no to include unit tests in the view model layer nor the ui.


