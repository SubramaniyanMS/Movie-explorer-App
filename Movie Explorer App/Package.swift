// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Movie Explorer App",
    platforms: [
        .iOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0")
    ],
    targets: [
        .target(
            name: "Movie Explorer App",
            dependencies: ["Alamofire"]
        )
    ]
)