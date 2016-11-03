
import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case UNKNOWN = "UNKNOWN"
}

extension HTTPMethod {
    
    init?(string: String) {
        if let method = HTTPMethod.init(rawValue: string) {
            self = method
        } else {
            return nil
        }
    }
}
