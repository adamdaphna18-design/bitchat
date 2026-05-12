//
// ReadReceiptsSecurityTests.swift
// bitchatTests
//

import Testing
import Foundation
import BitFoundation
@testable import bitchat

@MainActor
struct ReadReceiptsSecurityTests {

    @Test
    func persistence_usesKeychain() async {
        let keychain = MockKeychain()
        let idBridge = NostrIdentityBridge(keychain: keychain)
        let identityManager = MockIdentityManager(keychain)
        let transport = MockTransport()

        let viewModel = ChatViewModel(
            keychain: keychain,
            idBridge: idBridge,
            identityManager: identityManager,
            transport: transport
        )

        let testReceipts = Set(["msg1", "msg2"])
        viewModel.sentReadReceipts = testReceipts

        // Verify it's in the keychain
        let data = keychain.load(key: "sentReadReceipts", service: BitchatApp.bundleID)
        #expect(data != nil)

        if let data = data {
            let decoded = try? JSONDecoder().decode([String].self, from: data)
            #expect(Set(decoded ?? []) == testReceipts)
        }
    }

    @Test
    func initialization_loadsFromKeychain() async {
        let keychain = MockKeychain()
        let testReceipts = ["msg-k1", "msg-k2"]
        let data = try! JSONEncoder().encode(testReceipts)
        keychain.save(key: "sentReadReceipts", data: data, service: BitchatApp.bundleID, accessible: kSecAttrAccessibleWhenUnlocked)

        let idBridge = NostrIdentityBridge(keychain: keychain)
        let identityManager = MockIdentityManager(keychain)
        let transport = MockTransport()

        let viewModel = ChatViewModel(
            keychain: keychain,
            idBridge: idBridge,
            identityManager: identityManager,
            transport: transport
        )

        #expect(viewModel.sentReadReceipts == Set(testReceipts))
    }

    @Test
    func migration_fromUserDefaultsToKeychain() async {
        // Clean up any existing data in UserDefaults first
        UserDefaults.standard.removeObject(forKey: "sentReadReceipts")

        let keychain = MockKeychain()
        let testReceipts = ["msg-old1", "msg-old2"]
        let data = try! JSONEncoder().encode(testReceipts)

        // Put data in UserDefaults
        UserDefaults.standard.set(data, forKey: "sentReadReceipts")

        let idBridge = NostrIdentityBridge(keychain: keychain)
        let identityManager = MockIdentityManager(keychain)
        let transport = MockTransport()

        let viewModel = ChatViewModel(
            keychain: keychain,
            idBridge: idBridge,
            identityManager: identityManager,
            transport: transport
        )

        // 1. Verify loaded into viewModel
        #expect(viewModel.sentReadReceipts == Set(testReceipts))

        // 2. Verify migrated to keychain
        let keychainData = keychain.load(key: "sentReadReceipts", service: BitchatApp.bundleID)
        #expect(keychainData != nil)

        // 3. Verify removed from UserDefaults
        #expect(UserDefaults.standard.data(forKey: "sentReadReceipts") == nil)

        // Clean up
        UserDefaults.standard.removeObject(forKey: "sentReadReceipts")
    }
}
