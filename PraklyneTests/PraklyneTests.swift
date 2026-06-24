//
//  PraklyneTests.swift
//  PraklyneTests
//
//  Created by ISHAN-KM on 2025-08-07.
//

import XCTest
@testable import Praklyne

final class PraklyneTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Reset NotificationHistoryStore before each test for a clean slate
        NotificationHistoryStore.shared.clearAll()
    }

    override func tearDownWithError() throws {
        // Clean up NotificationHistoryStore
        NotificationHistoryStore.shared.clearAll()
        try super.tearDownWithError()
    }

    func testNotificationHistoryStoreAddAndDuplicatePrevention() throws {
        let store = NotificationHistoryStore.shared
        XCTAssertEqual(store.items.count, 0)

        let expectation1 = expectation(description: "First notification added")
        
        // Add a notification
        store.addNotification(title: "Task Alert", body: "Study electricity today!", date: Date())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(store.items.count, 1)
            XCTAssertEqual(store.items.first?.title, "Task Alert")
            XCTAssertEqual(store.items.first?.body, "Study electricity today!")
            XCTAssertEqual(store.items.first?.isRead, false)
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 1.0)

        // Attempt adding a duplicate notification (same title, body, and timestamp within 5 seconds)
        let expectation2 = expectation(description: "Duplicate notification ignored")
        
        store.addNotification(title: "Task Alert", body: "Study electricity today!", date: Date().addingTimeInterval(2))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Count must remain 1 because it's a duplicate
            XCTAssertEqual(store.items.count, 1)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 1.0)
    }

    func testNotificationHistoryStoreMarkAllAsRead() throws {
        let store = NotificationHistoryStore.shared
        XCTAssertEqual(store.items.count, 0)

        let expectation = expectation(description: "Notifications added and marked read")
        
        store.addNotification(title: "Subject 1", body: "Learn physics concepts", date: Date())
        store.addNotification(title: "Subject 2", body: "Learn programming concepts", date: Date().addingTimeInterval(-10))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(store.items.count, 2)
            XCTAssertFalse(store.items[0].isRead)
            XCTAssertFalse(store.items[1].isRead)
            
            // Mark all as read
            store.markAllAsRead()
            
            XCTAssertTrue(store.items[0].isRead)
            XCTAssertTrue(store.items[1].isRead)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testDiagramURLsValidity() throws {
        // Verify every topic's diagram URLs are well-formed and use standard Wikimedia Commons sizes
        XCTAssertFalse(allTopics.isEmpty, "Topics list should not be empty")

        for topic in allTopics {
            for urlString in topic.diagramImageURLs {
                guard let url = URL(string: urlString) else {
                    XCTFail("Invalid URL string: \(urlString)")
                    continue
                }
                
                XCTAssertEqual(url.scheme, "https", "Diagram URLs must use HTTPS: \(urlString)")
                
                // For Wikipedia Commons URLs, verify they point to standard widths
                if urlString.contains("upload.wikimedia.org") {
                    // Standard sizes for Wikimedia Commons thumbnails
                    let standardSizes = ["120px", "250px", "330px", "500px", "960px", "1280px", "1920px", "3840px"]
                    let hasStandardSize = standardSizes.contains { size in
                        urlString.contains("/\(size)-")
                    }
                    
                    // Note: Raw/Original files on Commons don't have "/thumb/" and don't require width prefixes
                    let isOriginalFile = !urlString.contains("/thumb/")
                    
                    XCTAssertTrue(
                        hasStandardSize || isOriginalFile,
                        "Wikimedia URL must use a standard width step or be a raw original file link: \(urlString)"
                    )
                    
                    // Verify it does not use blocked/non-standard sizes (400px, 300px, 200px)
                    let usesBlockedSize = ["400px", "300px", "200px"].contains { size in
                        urlString.contains("/\(size)-")
                    }
                    XCTAssertFalse(
                        usesBlockedSize,
                        "Wikimedia URL must not use non-standard/blocked width sizes: \(urlString)"
                    )
                }
            }
        }
    }
}
