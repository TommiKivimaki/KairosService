import XCTest
@testable import KairosService

final class KairosServiceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(KairosService().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
