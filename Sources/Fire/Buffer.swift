//
//  Buffer.swift
//  Echo
//
//  Created by Elliott Minns on 14/05/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

class Buffer {
    
    let size: Int
    
    let buffer: UnsafeMutableRawPointer
    
    // Used to prevent the string from dying.
    private var bytes: [UInt8] = []
    
    init(string: String) {
        self.bytes = [UInt8](string.utf8)
        let bytes = UnsafeMutablePointer<UInt8>(mutating: self.bytes)
        self.buffer = UnsafeMutableRawPointer(bytes)
        self.size = self.bytes.count
    }
    
    init(size: Int) {
        self.size = size
        self.buffer = UnsafeMutableRawPointer.allocate(bytes: size, alignedTo: 1)

    }
    
    deinit {
//        self.buffer.deallocate(bytes: size, alignedTo: 1)
    }
    
    func toString() -> String {
        let string = String(bytesNoCopy: buffer, length: size,
                            encoding: String.Encoding.utf8,
                            freeWhenDone: false) ?? ""
        return string
    }
    
}
