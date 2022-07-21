// swift-tools-version:5.1
import PackageDescription

let package = Package(
	name: "AnyDiffableDataSources",
	platforms: [ .iOS( .v10 ), .tvOS( .v10 ) ],
	products: [
		.library( name: "AnyDiffableDataSources", targets: ["AnyDiffableDataSources"] ),
		.library( name: "ReactiveAnyDiffableDataSources", targets: ["ReactiveAnyDiffableDataSources"] ),
	],
	dependencies: [
		.package(url: "https://github.com/ra1028/DiffableDataSources", from: "0.5.0"),
		.package(url: "https://github.com/ReactiveCocoa/ReactiveCocoa", from: "12.0.0"),
	],
	targets: [
		.target( name: "AnyDiffableDataSources", dependencies: ["DiffableDataSources"], path: "Sources" ),
		.target( name: "ReactiveAnyDiffableDataSources", dependencies: ["AnyDiffableDataSources", "ReactiveCocoa"], path: "ReactiveExtensions" ),
	],
	swiftLanguageVersions: [ .v5 ]
)
