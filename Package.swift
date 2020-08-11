// swift-tools-version:5.1
import PackageDescription

let package = Package(
	name: "AnyDiffabeDataSources",
	platforms: [ .iOS( .v10 ), .tvOS( .v10 ) ],
	products: [
		.library( name: "AnyDiffabeDataSources", targets: ["AnyDiffabeDataSources"] ),
		.library( name: "ReactiveAnyDiffabeDataSources", targets: ["ReactiveAnyDiffabeDataSources"] ),
	],
	dependencies: [
		.package(url: "https://github.com/ra1028/DiffableDataSources", from: "0.4.0"),
		.package(url: "https://github.com/ReactiveCocoa/ReactiveCocoa", from: "10.2.0"),
	],
	targets: [
		.target( name: "AnyDiffabeDataSources", dependencies: ["DiffableDataSources"], path: "Sources" ),
		.target( name: "ReactiveAnyDiffabeDataSources", dependencies: ["AnyDiffabeDataSources", "ReactiveCocoa"], path: "ReactiveExtensions" ),
	],
	swiftLanguageVersions: [ .v5 ]
)
