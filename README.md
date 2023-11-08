# randomcards - westpac tecnical exercise

This is a simple project demonstrating connecting to a ramdom cards api and diplaying these in a SwiftUI

A few features included are:
1. Sort cards by type
2. Save favourite cards.

I have decided to architect this in a way that might be considered for a larger project.

Each layer has it's own package and could be further seperated into seperate repositories if desired. For the purposes of this demo all packages are included in the one repo.

Packages are:
1. the API layer - calls the random cards api and includes it's unit tests.
2. Local Model layer - for storing saved cards, could easily be sync'd with cloud and only be a local offline cache. with it's own unit tests.
3. View Model layer - Observed objects and calls out to api or model as required. Includes it's own unit tests.

The final layer is the application itself. All ui is here for this simple test. It is also possible to separate out certain non application specific UI if required to. 
