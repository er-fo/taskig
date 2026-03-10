// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Taskig",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "TaskigMenuBar", targets: ["TaskigMenuBar"])
    ],
    targets: [
        .executableTarget(
            name: "TaskigMenuBar",
            path: "Sources/TaskigMenuBar"
        )
    ]
)
