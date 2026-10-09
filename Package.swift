// swift-tools-version: 6.0

import PackageDescription

// The frameworks ship under a `Filmio` prefix. SwiftPM target names and
// product names are unique across the whole dependency graph, and every other
// FFmpeg packaged for Apple platforms (FFmpegKit and its forks, MobileVLCKit,
// the mpv builds) declares targets named Libavcodec, Libavformat and friends.
// Sharing those names made this package unresolvable next to any of them, and
// the frameworks then collided a second time on one install name inside
// App.app/Frameworks/. The prefix settles both, and `otool -L` says which
// FFmpeg answered without anyone having to guess.
let package = Package(
    name: "FFmpegBuild",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macOS(.v14),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "FilmioFFmpeg",
            targets: ["FilmioFFmpeg"]
        ),
        // Individual libraries for consumers that want fine-grained control
        .library(name: "FilmioLibavcodec", targets: ["FilmioLibavcodec"]),
        .library(name: "FilmioLibavformat", targets: ["FilmioLibavformat"]),
        .library(name: "FilmioLibavutil", targets: ["FilmioLibavutil"]),
        .library(name: "FilmioLibswresample", targets: ["FilmioLibswresample"]),
        .library(name: "FilmioLibswscale", targets: ["FilmioLibswscale"]),
        .library(name: "FilmioLibdav1d", targets: ["FilmioLibdav1d"]),
        .library(name: "FilmioLibavfilter", targets: ["FilmioLibavfilter"]),
        .library(name: "FilmioLibzimg", targets: ["FilmioLibzimg"]),
        .library(name: "FilmioLibzvbi", targets: ["FilmioLibzvbi"]),
    ],
    targets: [
        // Umbrella target that links all FFmpeg libraries + dav1d + system frameworks
        .target(
            name: "FilmioFFmpeg",
            dependencies: [
                "FilmioLibavcodec",
                "FilmioLibavformat",
                "FilmioLibavutil",
                "FilmioLibswresample",
                "FilmioLibswscale",
                "FilmioLibavfilter",
                "FilmioLibdav1d",
                "FilmioLibzimg",
                "FilmioLibzvbi",
            ],
            path: "Sources/FilmioFFmpeg",
            linkerSettings: [
                .linkedFramework("AudioToolbox"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreVideo"),
                .linkedFramework("VideoToolbox"),
                .linkedLibrary("z"),
                .linkedLibrary("bz2"),
                .linkedLibrary("iconv"),
                .linkedLibrary("c++"),
            ]
        ),
        // Prebuilt xcframeworks (created by build.sh)
        .binaryTarget(name: "FilmioLibavcodec", path: "Sources/FilmioLibavcodec.xcframework"),
        .binaryTarget(name: "FilmioLibavformat", path: "Sources/FilmioLibavformat.xcframework"),
        .binaryTarget(name: "FilmioLibavutil", path: "Sources/FilmioLibavutil.xcframework"),
        .binaryTarget(name: "FilmioLibswresample", path: "Sources/FilmioLibswresample.xcframework"),
        .binaryTarget(name: "FilmioLibswscale", path: "Sources/FilmioLibswscale.xcframework"),
        .binaryTarget(name: "FilmioLibdav1d", path: "Sources/FilmioLibdav1d.xcframework"),
        .binaryTarget(name: "FilmioLibavfilter", path: "Sources/FilmioLibavfilter.xcframework"),
        .binaryTarget(name: "FilmioLibzimg", path: "Sources/FilmioLibzimg.xcframework"),
        .binaryTarget(name: "FilmioLibzvbi", path: "Sources/FilmioLibzvbi.xcframework"),
        .testTarget(
            name: "FFmpegBuildTests",
            dependencies: ["FilmioFFmpeg", "FilmioLibavfilter", "FilmioLibavutil"],
            path: "Tests/FFmpegBuildTests"
        ),
    ]
)
