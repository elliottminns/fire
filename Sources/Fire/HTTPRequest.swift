
import Foundation

public class HTTPRequest {
 	
    public let method: HTTPMethod
    
 	public let headers: [String: String]
    
    public let body: String
    
    public let path: String
    
    public let httpProtocol: String
    
    var connection: Connection?

    public init(headers: [String: String], method: HTTPMethod, body: String,
         path: String, httpProtocol: String) {
        
        self.headers = headers
        self.body = body
        self.method = method
        self.httpProtocol = httpProtocol
        self.path = path
    }
}
