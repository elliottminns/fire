import XCTest
@testable import Fire

class MockConnection: Connection {

    var writeCalled: Bool = false
    var data: Fire.Data?

    func read(callback: @escaping (_ data: Buffer, _ amount: Int) -> ()) {
    
    }

    func write(data: Fire.Data) {
        self.data = data
        writeCalled = true
    }
}

class HTTPResponseTests: XCTestCase {

    var connection: MockConnection!
    var response: HTTPResponse!

    override func setUp() {
        connection = MockConnection()
        response = HTTPResponse(connection: connection)
    }

    func testSendingStatus() {
        response.send(status: 200)
        XCTAssertTrue(connection.writeCalled)
    }

    func testSendingStatus_data() {
        response.send(status: 200)
        let data = Fire.Data(string: "HTTP/1.1 200 OK\r\n\r\n")
        XCTAssertEqual(connection.data!.bytes, data.bytes)
    }

    func testSendingHtml() {
        response.send(html: "<h1>Hello</h1>")
        let data = Fire.Data(string: "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 14\r\n\r\n<h1>Hello</h1>")
        XCTAssertEqual(connection.data!.bytes, data.bytes)
    }

    func testSendingText() {
        response.send(text: "Hello World")
        let data = Fire.Data(string: "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 11\r\n\r\nHello World")
        XCTAssertEqual(connection.data!.bytes, data.bytes)
    }



    static var allTests : [(String, (HTTPResponseTests) -> () throws -> Void)] {
        return [
            ("testSendingStatus", testSendingStatus),
            ("testSendingStatus_data", testSendingStatus_data)
        ]
    }
}
    
