import XCTest
@testable import fire_example

class fire_exampleTests: XCTestCase {

    func testExample() {
        XCTAssertEqual(fire_example().text, "Hello, World!")
    }


    static var allTests : [(String, (fire_exampleTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
