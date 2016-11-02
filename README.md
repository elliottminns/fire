# Fire

Fire is a basic yet extremely fast connection based server.

## How can I use it?

Because fire is so basic, it can be used as a starting point for your own web frameworks, or as a basic mini server setup.

```
main.swift
```

```swift
import Fire
import Foundation

class Handler: HTTPServerDelegate {
    func server(_ server: HTTPServer,
                didReceive request: HTTPRequest,
                response: HTTPResponse) {
        let body = "<h1>Hello</h1><h3>You landed at \(request.path)</h3>"
        response.send(html: "<html><body>\(body)</body></html>")
    }
}

let delegate = Handler()

let server = HTTPServer(delegate: delegate)

try? server.listen(port: 3000)

RunLoop.main.run()
```
