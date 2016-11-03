
import Foundation

public class HTTPResponse {
    
    let connection: Connection
    
    public var status: Int
    
    public var headers: [String: String]
    
    var body: Buffer {
        didSet {
            if body.size > 0 {
                self.headers["Content-Length"] = "\(body.size)"
            }
        }
    }
    
    init(connection: Connection) {
        self.connection = connection
        self.status = 200
        self.headers = [:]
        self.body = Buffer(size: 0)
    }
    
    func send() {
        var http = "HTTP/1.1 \(status)\r\n"
        for (key, value) in headers {
            http += "\(key): \(value)\r\n"
        }
        http += "\r\n"
        http += self.body.toString()
        connection.write(http)
    }
    
    public func send(text: String) {
        self.headers["Content-Type"] = "text/plain"
        self.body = Buffer(string: text)
        send()
    }
    
    public func send(html: String) {
        self.headers["Content-Type"] = "text/html"
        self.body = Buffer(string: html)
        send()
    }
    
    public func send(json: Any) throws {
        self.headers["Content-Type"] = "text/json"
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        self.body = Buffer(data: data)
        send()
    }
    
    public func send(data: Data) {
        connection.write(data: data)
    }
    
    public func send(error: String) {
        status = 400
        
    }
    
    
}
