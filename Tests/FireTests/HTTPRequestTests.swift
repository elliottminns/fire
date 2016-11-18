import XCTest
@testable import Fire

class HTTPRequestTests: XCTestCase {
    
    var request: HTTPRequest!
    
    override func setUp() {
        let headers = ["Content-Type": "application/json"]
        request = HTTPRequest(headers: headers, method: .POST, body: "",
                              path: "/hello/world?extra=data&more=stuff",
                              httpProtocol: "")
    }
    
    func testPath() {
        XCTAssertEqual(request.path, "/hello/world")
    }

    func testMethod() {
        XCTAssertEqual(request.method, .POST)
    }

    func testHeaders() {
        XCTAssertEqual(request.headers, ["Content-Type": "application/json"])
    }
    
    func testQuery_count() {
        XCTAssertEqual(request.query.count, 2)
    }
    
    func testQuery_values() {
        XCTAssertEqual(request.query["extra"] as? String, "data")
        XCTAssertEqual(request.query["more"] as? String, "stuff")
    }
    
    func testQueryArray() {
        let req = HTTPRequest(headers: [:], method: .GET, body: "",
                              path: "/test?array=1&array=2&array=3&something=else",
                              httpProtocol: "")
        XCTAssertEqual(req.query["array"] as! [String], ["1", "2", "3"])
        XCTAssertEqual(req.query["something"] as? String, "else")
    }
    
    
    static var allTests : [(String, (HTTPRequestTests) -> () throws -> Void)] {
        return [
            ("testPath", testPath),
            ("testMethod", testMethod),
            ("testHeaders", testHeaders),
            ("testQueryArray", testQueryArray),
            ("testQuery_count", testQuery_count),
            ("testQuery_values", testQuery_values)
        ]
    }
}
