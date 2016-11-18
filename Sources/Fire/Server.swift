
import Foundation

#if os(Linux)
import Glibc
import Dispatch
#endif

public protocol ServerDelegate {
    func server(_ server: Server, didCreateConnection connection: Connection)
}

public class Server {
    
    let type: SocketType

    let socket: Socket
    
    let port: Int
    
    let dispatcher: DispatchSourceRead
    
    let delegate: ServerDelegate
    
    init(socket: Socket, port: Int, delegate: ServerDelegate, type: SocketType = .tcp) {
        self.socket = socket
        self.port = port
        self.delegate = delegate
        self.type = type
        dispatcher = DispatchSource.makeReadSource(fileDescriptor: socket.raw)
    }
    
    public convenience init(port: Int, delegate: ServerDelegate, type: SocketType) throws {
        let socket = try Socket()
        self.init(socket: socket, port: port, delegate: delegate)
    }
    
    public func listen() throws {
        
        let address = try Address(address: "0.0.0.0", port: self.port)
        
        var value = 1
        
        if setsockopt(socket.raw, SOL_SOCKET, SO_REUSEADDR,
                      &value, socklen_t(MemoryLayout<Int32>.size)) == -1 {
            throw SocketError.CouldNotListen
        }
        
	#if !os(Linux)
        var no_sig_pipe: Int32 = 1
        setsockopt(socket.raw, SOL_SOCKET, SO_NOSIGPIPE, &no_sig_pipe, socklen_t(MemoryLayout<Int32>.size))
        #endif

        try bind(socket: socket, address: address)
        
        if (systemListen(socket.raw, 128) < 0) {
            throw SocketError.CouldNotListen
        }
        
        dispatcher.setEventHandler {
            if let connection = try? self.accept() {
                self.delegate.server(self, didCreateConnection: connection)
            }
        }
        
        #if os(Linux)
//        dispatch_resume(dispatch_object_t(_ds: dispatcher))
            dispatcher.resume()
        #else
            dispatcher.resume()
        #endif
    }
    
    func accept() throws -> Connection {
        let addr = UnsafeMutablePointer<sockaddr>.allocate(capacity: 1)
        var len = socklen_t(0)
        let fd = systemAccept(self.socket.raw, addr, &len)
        let client = try Socket(raw: fd)
        addr.deallocate(capacity: 1)
        return Connection(socket: client)
    }
    
    private func bind(socket: Socket, address: Address) throws {
        try address.raw.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            let r = systemBind(socket.raw,
                               $0,
                               socklen_t(MemoryLayout<sockaddr_in>.size))
            if r < 0 {
                throw SocketError.CouldNotBind
            }
        }
    }
    
}
