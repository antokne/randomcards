// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RandomCardsAPI",
	platforms: [
		.iOS(.v15),
		.tvOS(.v15),
		.macOS(.v13),
	],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "RandomCardsAPI",
			targets: ["RandomCardsAPI"]),
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "RandomCardsAPI"),
		.testTarget(
			name: "RandomCardsAPITests",
			dependencies: ["RandomCardsAPI"],
			resources: [
				.process("Resources"),
			]),
	]
)
