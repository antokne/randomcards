// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RandomCardsViewModel",
	platforms: [
		.iOS(.v15),
		.tvOS(.v15),
		.macOS(.v13),
	],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "RandomCardsViewModel",
			targets: ["RandomCardsViewModel"]),
	],
	dependencies: [
		.package(path: "./RandomCardsAPI"),
		.package(path: "./RandomCardsModel"),
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "RandomCardsViewModel",
			dependencies: [
				.product(name: "RandomCardsAPI", package: "RandomCardsAPI"),
				.product(name: "RandomCardsModel", package: "RandomCardsModel"),
			]),
		.testTarget(
			name: "RandomCardsViewModelTests",
			dependencies: ["RandomCardsViewModel"]),
	]
)
