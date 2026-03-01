// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "X-HAL",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/soffes/HotKey", from: "0.2.1"),
    ],
    targets: [
        .executableTarget(
            name: "X-HAL",
            dependencies: ["HotKey"],
            path: "X-HAL",
            exclude: [
                "Info.plist",
                "X-HAL.entitlements",
            ],
            resources: [
                .copy("Resources/Sounds"),
                .copy("Resources/Assets.xcassets"),
            ]
        ),
    ]
)
