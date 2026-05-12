//
// MessageRateLimiterTests.swift
// bitchatTests
//

import Testing
import Foundation
@testable import bitchat

struct MessageRateLimiterTests {

    @Test("Basic allowance and depletion")
    func basicAllowanceAndDepletion() {
        var limiter = MessageRateLimiter(
            senderCapacity: 3,
            senderRefillPerSec: 1,
            contentCapacity: 10,
            contentRefillPerSec: 1
        )
        let now = Date()
        let sender = "sender1"
        let content = "content1"

        // Should allow 3 messages (sender capacity is 3)
        #expect(limiter.allow(senderKey: sender, contentKey: content, now: now))
        #expect(limiter.allow(senderKey: sender, contentKey: content, now: now))
        #expect(limiter.allow(senderKey: sender, contentKey: content, now: now))

        // 4th message should be rejected (exhausted sender bucket)
        #expect(!limiter.allow(senderKey: sender, contentKey: content, now: now))
    }

    @Test("Token refill over time")
    func tokenRefill() {
        var limiter = MessageRateLimiter(
            senderCapacity: 1,
            senderRefillPerSec: 1,
            contentCapacity: 10,
            contentRefillPerSec: 1
        )
        let now = Date()
        let sender = "sender1"
        let content = "content1"

        // Exhaust sender bucket
        #expect(limiter.allow(senderKey: sender, contentKey: content, now: now))
        #expect(!limiter.allow(senderKey: sender, contentKey: content, now: now))

        // Move time forward by 1 second
        let later = now.addingTimeInterval(1.0)
        #expect(limiter.allow(senderKey: sender, contentKey: content, now: later))
        #expect(!limiter.allow(senderKey: sender, contentKey: content, now: later))
    }

    @Test("Capacity boundary (no overfill)")
    func capacityBoundary() {
        var limiter = MessageRateLimiter(
            senderCapacity: 2,
            senderRefillPerSec: 10,
            contentCapacity: 10,
            contentRefillPerSec: 10
        )
        let now = Date()
        let sender = "sender1"
        let content = "content1"

        // Move time forward by 100 seconds (should have 1000 tokens, but capped at 2)
        let wayLater = now.addingTimeInterval(100.0)

        #expect(limiter.allow(senderKey: sender, contentKey: content, now: wayLater))
        #expect(limiter.allow(senderKey: sender, contentKey: content, now: wayLater))
        #expect(!limiter.allow(senderKey: sender, contentKey: content, now: wayLater))
    }

    @Test("Backwards clock jump handling")
    func backwardsClockJump() {
        var limiter = MessageRateLimiter(
            senderCapacity: 1,
            senderRefillPerSec: 1,
            contentCapacity: 10,
            contentRefillPerSec: 1
        )
        let now = Date()
        let sender = "sender1"
        let content = "content1"

        // Exhaust sender bucket
        #expect(limiter.allow(senderKey: sender, contentKey: content, now: now))

        // Jump back in time
        let earlier = now.addingTimeInterval(-10.0)

        // Should still be exhausted (tokens shouldn't have changed)
        #expect(!limiter.allow(senderKey: sender, contentKey: content, now: earlier))

        // Return to "now"
        #expect(!limiter.allow(senderKey: sender, contentKey: content, now: now))

        // Move forward to refill
        let later = now.addingTimeInterval(1.0)
        #expect(limiter.allow(senderKey: sender, contentKey: content, now: later))
    }

    @Test("Independent sender and content buckets")
    func independentBuckets() {
        var limiter = MessageRateLimiter(
            senderCapacity: 1,
            senderRefillPerSec: 1,
            contentCapacity: 1,
            contentRefillPerSec: 1
        )
        let now = Date()

        // Allow sender1, content1
        #expect(limiter.allow(senderKey: "sender1", contentKey: "content1", now: now))

        // sender1 exhausted
        #expect(!limiter.allow(senderKey: "sender1", contentKey: "content2", now: now))

        // content1 exhausted
        #expect(!limiter.allow(senderKey: "sender2", contentKey: "content1", now: now))

        // sender2, content2 allowed
        #expect(limiter.allow(senderKey: "sender2", contentKey: "content2", now: now))
    }

    @Test("Both sender and content limits must pass")
    func bothLimitsMustPass() {
        var limiter = MessageRateLimiter(
            senderCapacity: 1,
            senderRefillPerSec: 1,
            contentCapacity: 10,
            contentRefillPerSec: 1
        )
        let now = Date()

        // Exhaust sender1
        #expect(limiter.allow(senderKey: "sender1", contentKey: "content1", now: now))

        // content2 is fresh, but sender1 is exhausted
        #expect(!limiter.allow(senderKey: "sender1", contentKey: "content2", now: now))
    }

    @Test("Reset functionality")
    func resetFunctionality() {
        var limiter = MessageRateLimiter(
            senderCapacity: 1,
            senderRefillPerSec: 1,
            contentCapacity: 1,
            contentRefillPerSec: 1
        )
        let now = Date()

        #expect(limiter.allow(senderKey: "sender1", contentKey: "content1", now: now))
        #expect(!limiter.allow(senderKey: "sender1", contentKey: "content1", now: now))

        limiter.reset()

        // Should be allowed again after reset
        #expect(limiter.allow(senderKey: "sender1", contentKey: "content1", now: now))
    }
}
