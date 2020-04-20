// swift-tools-version:5.1
import PackageDescription

let package = Package(
	name: "AnyDiffabeDataSource",
	platforms: [ .iOS( .v10 ), .tvOS( .v10 ) ],
	products: [
		.library( name: "AnyDiffabeDataSources", targets: ["AnyDiffabeDataSources"] ),
		.library( name: "ReactiveAnyDiffabeDataSource", targets: ["ReactiveAnyDiffabeDataSource"] ),
	],
	dependencies: [
		.package(url: "https://github.com/ra1028/DiffableDataSources", from: "0.4.0"),
		.package(url: "https://github.com/ReactiveCocoa/ReactiveCocoa", from: "10.2.0"),
	],
	targets: [
		.target( name: "AnyDiffabeDataSources", dependencies: ["DiffableDataSources"], path: "Sources" ),
		.target( name: "ReactiveAnyDiffabeDataSource", dependencies: ["AnyDiffabeDataSources", "ReactiveCocoa"], path: "ReactiveExtensions" ),
	],
	swiftLanguageVersions: [ .v5 ]
)
