# Fire

![Fire Image]
(http://i.imgur.com/jk3iigF.jpg)

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

## What about JSON?

Super easy

```swift
import Fire
import Foundation

class Handler: HTTPServerDelegate {
    
    func server(_ server: HTTPServer,
                didReceive request: HTTPRequest,
                response: HTTPResponse) {
        
        let json = [
            "server": "fire",
            "speed": "blazing",
            "easeOfUse": "high"
        ] as [String : Any]
        
        // json can fail to parse, so we want to catch that.
        do {
            try response.send(json: json)
        } catch {
            response.send(error: "Could not send JSON")
        }
    }
}

let delegate = Handler()

let server = HTTPServer(delegate: delegate)

try? server.listen(port: 3000)

RunLoop.main.run()
```
