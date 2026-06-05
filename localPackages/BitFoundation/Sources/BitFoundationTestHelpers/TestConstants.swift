//
// TestConstants.swift
// bitchatTests
//
// This is free and unencumbered software released into the public domain.
// For more information, see <https://unlicense.org>
//

import Foundation

public struct TestConstants {
    public static let defaultTimeout: TimeInterval = 5.0
    public static let shortTimeout: TimeInterval = 1.0
    public static let longTimeout: TimeInterval = 10.0

    public static let testNickname1 = "Alice"
    public static let testNickname2 = "Bob"
    public static let testNickname3 = "Charlie"
    public static let testNickname4 = "David"

    public static let testMessage1 = "Hello, World!"
    public static let testMessage2 = "How are you?"
    public static let testMessage3 = "This is a test message"
    public static let testLongMessage = String(repeating: "This is a long message. ", count: 100)

    public static let testSignature = Data(repeating: 0xAB, count: 64)
}
