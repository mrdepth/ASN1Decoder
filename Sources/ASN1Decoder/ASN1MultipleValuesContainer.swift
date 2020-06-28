//
//  ASN1MultipleValuesContainer.swift
//  
//
//  Created by Artem Shimanski on 6/28/20.
//

import Foundation

struct _ASN1SequenceContainer: ASN1MultipleValuesContainer {
    var container: [TLV]
    var currentIndex: Int = 0
    
    var isAtEnd: Bool {
        return currentIndex >= container.count
    }
    
    private func currentValue() throws -> ASN1SingleValueContainer {
        guard !isAtEnd else { throw ASN1Error.endOfDataReached }
        return _ASN1SingleValueContainer(container: container[currentIndex], containerEncoding: .none)
    }
    
    mutating func decode(_ type: Data.Type, encoded encoding: ASN1Encoding) throws -> Data {
        let result = try currentValue().decode(type, encoded: encoding)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Bool.Type, encoded encoding: ASN1Encoding) throws -> Bool {
        let result = try currentValue().decode(type, encoded: encoding)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int.Type, encoded encoding: ASN1Encoding) throws -> Int {
        let result = try currentValue().decode(type, encoded: encoding)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int8.Type, encoded encoding: ASN1Encoding) throws -> Int8 {
        let result = try currentValue().decode(type, encoded: encoding)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int16.Type, encoded encoding: ASN1Encoding) throws -> Int16 {
        let result = try currentValue().decode(type, encoded: encoding)
        currentIndex += 1
        return result
    }
    
    mutating func decode(_ type: Int32.Type, encoded encoding: ASN1Encoding) throws -> Int32 {
        let result = try currentValue().decode(type, encoded: encoding)
        currentIndex += 1
        return result
    }
    

    mutating func decode(_ type: Int64.Type, encoded encoding: ASN1Encoding) throws -> Int64 {
        let result = try currentValue().decode(type, encoded: encoding)
        currentIndex += 1
        return result
    }
    
    mutating func decode(_ type: String.Type, encoded encoding: ASN1Encoding) throws -> String {
        let result = try currentValue().decode(type, encoded: encoding)
        currentIndex += 1
        return result
    }
    
    mutating func decode(_ type: Date.Type, encoded encoding: ASN1Encoding) throws -> Date {
        let result = try currentValue().decode(type, encoded: encoding)
        currentIndex += 1
        return result
    }
    
    mutating func decode<T>(_ type: T.Type, encoded encoding: ASN1Encoding) throws -> T where T : ASN1Decodable {
        let result = try currentValue().decode(type, encoded: encoding)
        currentIndex += 1
        return result
    }
    
    mutating func decodeAny() throws -> Any {
        let result = try currentValue().decodeAny()
        currentIndex += 1
        return result
    }
    
    mutating func decodeSequence(of type: Data.Type, encoded encoding: ASN1Encoding) throws -> [Data] {
        var result = [Data]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }

    mutating func decodeSequence(of type: Bool.Type, encoded encoding: ASN1Encoding) throws -> [Bool] {
        var result = [Bool]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }

    mutating func decodeSequence(of type: Int.Type, encoded encoding: ASN1Encoding) throws -> [Int] {
        var result = [Int]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }

    mutating func decodeSequence(of type: Int8.Type, encoded encoding: ASN1Encoding) throws -> [Int8] {
        var result = [Int8]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }

    mutating func decodeSequence(of type: Int16.Type, encoded encoding: ASN1Encoding) throws -> [Int16] {
        var result = [Int16]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }
    
    mutating func decodeSequence(of type: Int32.Type, encoded encoding: ASN1Encoding) throws -> [Int32] {
        var result = [Int32]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }

    mutating func decodeSequence(of type: Int64.Type, encoded encoding: ASN1Encoding) throws -> [Int64] {
        var result = [Int64]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }
    
    mutating func decodeSequence(of type: String.Type, encoded encoding: ASN1Encoding) throws -> [String] {
        var result = [String]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }
    
    mutating func decodeSequence(of type: Date.Type, encoded encoding: ASN1Encoding) throws -> [Date] {
        var result = [Date]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }
    
    mutating func decodeSequence<T>(of type: T.Type, encoded encoding: ASN1Encoding) throws -> [T] where T : ASN1Decodable {
        var result = [T]()
        while !isAtEnd {
            try result.append(currentValue().decode(type, encoded: encoding))
            currentIndex += 1
        }
        return result
    }
    
    mutating func decodeSequenceOfAny() throws -> [Any] {
        var result = [Any]()
        while !isAtEnd {
            try result.append(decodeAny())
        }
        return result
    }
    
    mutating func sequenceContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer {
        let result = try currentValue().sequenceContainer(encoded: encoding)
        currentIndex += 1
        return result
    }
    
    mutating func setContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer {
        let result = try currentValue().setContainer(encoded: encoding)
        currentIndex += 1
        return result
    }
    
    mutating func value(encoded encoding: ASN1Encoding) throws -> ASN1SingleValueContainer {
        let result = try currentValue().value(encoded: encoding)
        currentIndex += 1
        return result
    }
}

struct ASN1SetContainer: ASN1MultipleValuesContainer {
    var container: [TLV]
    var isAtEnd: Bool
    
    mutating func decode(_ type: Data.Type, encoded encoding: ASN1Encoding) throws -> Data {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).decode(type, encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }

    mutating func decode(_ type: Bool.Type, encoded encoding: ASN1Encoding) throws -> Bool {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).decode(type, encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }

    mutating func decode(_ type: Int.Type, encoded encoding: ASN1Encoding) throws -> Int {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).decode(type, encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }

    mutating func decode(_ type: Int8.Type, encoded encoding: ASN1Encoding) throws -> Int8 {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).decode(type, encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }

    mutating func decode(_ type: Int16.Type, encoded encoding: ASN1Encoding) throws -> Int16 {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).decode(type, encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }
    
    mutating func decode(_ type: Int32.Type, encoded encoding: ASN1Encoding) throws -> Int32 {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).decode(type, encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }
    

    mutating func decode(_ type: Int64.Type, encoded encoding: ASN1Encoding) throws -> Int64 {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).decode(type, encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }
    
    mutating func decode(_ type: String.Type, encoded encoding: ASN1Encoding) throws -> String {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).decode(type, encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }
    
    mutating func decode(_ type: Date.Type, encoded encoding: ASN1Encoding) throws -> Date {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).decode(type, encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }
    
    mutating func decode<T>(_ type: T.Type, encoded encoding: ASN1Encoding) throws -> T where T : ASN1Decodable {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).decode(type, encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }
    
    mutating func decodeAny() throws -> Any {
        guard let c = container.first else {throw ASN1Error.endOfDataReached}
        return try _ASN1SingleValueContainer(container: c, containerEncoding: .none).decodeAny()
    }
    
    mutating func decodeSequence(of type: Data.Type, encoded encoding: ASN1Encoding) throws -> [Data] {
        var result = [Data]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }

    mutating func decodeSequence(of type: Bool.Type, encoded encoding: ASN1Encoding) throws -> [Bool] {
        var result = [Bool]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }

    mutating func decodeSequence(of type: Int.Type, encoded encoding: ASN1Encoding) throws -> [Int] {
        var result = [Int]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }

    mutating func decodeSequence(of type: Int8.Type, encoded encoding: ASN1Encoding) throws -> [Int8] {
        var result = [Int8]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }

    mutating func decodeSequence(of type: Int16.Type, encoded encoding: ASN1Encoding) throws -> [Int16] {
        var result = [Int16]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }
    
    mutating func decodeSequence(of type: Int32.Type, encoded encoding: ASN1Encoding) throws -> [Int32] {
        var result = [Int32]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }

    mutating func decodeSequence(of type: Int64.Type, encoded encoding: ASN1Encoding) throws -> [Int64] {
        var result = [Int64]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }
    
    mutating func decodeSequence(of type: String.Type, encoded encoding: ASN1Encoding) throws -> [String] {
        var result = [String]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }
    
    mutating func decodeSequence(of type: Date.Type, encoded encoding: ASN1Encoding) throws -> [Date] {
        var result = [Date]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }
    
    mutating func decodeSequence<T>(of type: T.Type, encoded encoding: ASN1Encoding) throws -> [T] where T : ASN1Decodable {
        var result = [T]()
        while !isAtEnd {
            try result.append(decode(type, encoded: encoding))
        }
        return result
    }
    
    mutating func decodeSequenceOfAny() throws -> [Any] {
        var result = [Any]()
        while !isAtEnd {
            try result.append(decodeAny())
        }
        return result
    }
    
    mutating func sequenceContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).sequenceContainer(encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }
    
    mutating func setContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).setContainer(encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }
    
    mutating func value(encoded encoding: ASN1Encoding) throws -> ASN1SingleValueContainer {
        for i in container.indices {
            if let result = try? _ASN1SingleValueContainer(container: container[i], containerEncoding: .none).value(encoded: encoding) {
                container.remove(at: i)
                return result
            }
        }
        throw ASN1Error.typeNotFound(encoding)
    }
    
    
}
