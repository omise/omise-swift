// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Omise",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "Omise",
            type: .dynamic,
            targets: ["Omise"]
        ),
    ],
    targets: [
        .target(
            name: "Omise",
            path: "OmiseSwift",
            exclude: ["Info-iOS.plist", "Info-OSX.plist", "Omise.h"],
            resources: [.process("Resources")]
        )
    ]
)
