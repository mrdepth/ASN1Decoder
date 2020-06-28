//
//  ASN1Decoder.swift
//
//
//  Created by Artem Shimanski on 6/28/20.
//

import Foundation

public struct ASN1Decoder {
    public init() {}
    
    public func decode(_ type: Data.Type, encoded encoding: ASN1Encoding, from data: Data) throws -> Data {
        guard let tlv = TLV(data: data) else {throw ASN1Error.formatError}
        return try _ASN1Decoder(container: tlv, containerEncoding: .none).value(encoded: .none).decode(type, encoded: encoding)
    }

    public func decode(_ type: Bool.Type, encoded encoding: ASN1Encoding, from data: Data) throws -> Bool {
        guard let tlv = TLV(data: data) else {throw ASN1Error.formatError}
        return try _ASN1Decoder(container: tlv, containerEncoding: .none).value(encoded: .none).decode(type, encoded: encoding)
    }

    public func decode(_ type: Int.Type, encoded encoding: ASN1Encoding, from data: Data) throws -> Int {
        guard let tlv = TLV(data: data) else {throw ASN1Error.formatError}
        return try _ASN1Decoder(container: tlv, containerEncoding: .none).value(encoded: .none).decode(type, encoded: encoding)
    }

    public func decode(_ type: Int8.Type, encoded encoding: ASN1Encoding, from data: Data) throws -> Int8 {
        guard let tlv = TLV(data: data) else {throw ASN1Error.formatError}
        return try _ASN1Decoder(container: tlv, containerEncoding: .none).value(encoded: .none).decode(type, encoded: encoding)
    }

    public func decode(_ type: Int16.Type, encoded encoding: ASN1Encoding, from data: Data) throws -> Int16 {
        guard let tlv = TLV(data: data) else {throw ASN1Error.formatError}
        return try _ASN1Decoder(container: tlv, containerEncoding: .none).value(encoded: .none).decode(type, encoded: encoding)
    }
    
    public func decode(_ type: Int32.Type, encoded encoding: ASN1Encoding, from data: Data) throws -> Int32 {
        guard let tlv = TLV(data: data) else {throw ASN1Error.formatError}
        return try _ASN1Decoder(container: tlv, containerEncoding: .none).value(encoded: .none).decode(type, encoded: encoding)
    }
    
    public func decode(_ type: Int64.Type, encoded encoding: ASN1Encoding, from data: Data) throws -> Int64 {
        guard let tlv = TLV(data: data) else {throw ASN1Error.formatError}
        return try _ASN1Decoder(container: tlv, containerEncoding: .none).value(encoded: .none).decode(type, encoded: encoding)
    }
    
    public func decode(_ type: String.Type, encoded encoding: ASN1Encoding, from data: Data) throws -> String {
        guard let tlv = TLV(data: data) else {throw ASN1Error.formatError}
        return try _ASN1Decoder(container: tlv, containerEncoding: .none).value(encoded: .none).decode(type, encoded: encoding)
    }
    
    public func decode(_ type: Date.Type, encoded encoding: ASN1Encoding, from data: Data) throws -> Date {
        guard let tlv = TLV(data: data) else {throw ASN1Error.formatError}
        return try _ASN1Decoder(container: tlv, containerEncoding: .none).value(encoded: .none).decode(type, encoded: encoding)
    }

    public func decode<T: ASN1Decodable>(_ type: T.Type, from data: Data) throws -> T {
        guard let tlv = TLV(data: data) else {throw ASN1Error.formatError}
        return try T(from: _ASN1Decoder(container: tlv, containerEncoding: .none))
    }
}

public enum ASN1Error: Error {
    case formatError
    case typeMismatch(expected: ASN1Identifier, actual: ASN1Identifier)
    case valueNotFound(ASN1Identifier)
    case overflow
    case invalidStringEncoding
    case invalidDateFormat(String)
    case endOfDataReached
    case invalidEnum(Any)
    case typeNotFound(ASN1Encoding)
}

public protocol ASN1Decodable {
    init(from decoder: ASN1DecoderProtocol) throws
}

public protocol ASN1SingleValueContainer {
    func decode(_ type: Data.Type, encoded encoding: ASN1Encoding) throws -> Data
    func decode(_ type: Bool.Type, encoded encoding: ASN1Encoding) throws -> Bool
    func decode(_ type: Int.Type, encoded encoding: ASN1Encoding) throws -> Int
    func decode(_ type: Int8.Type, encoded encoding: ASN1Encoding) throws -> Int8
    func decode(_ type: Int16.Type, encoded encoding: ASN1Encoding) throws -> Int16
    func decode(_ type: Int32.Type, encoded encoding: ASN1Encoding) throws -> Int32
    func decode(_ type: Int64.Type, encoded encoding: ASN1Encoding) throws -> Int64
    func decode(_ type: String.Type, encoded encoding: ASN1Encoding) throws -> String
    func decode(_ type: Date.Type, encoded encoding: ASN1Encoding) throws -> Date
    func decode<T: ASN1Decodable>(_ type: T.Type, encoded encoding: ASN1Encoding) throws -> T
    func decodeAny() throws -> Any
    func sequenceContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer
    func setContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer
    func value(encoded encoding: ASN1Encoding) throws -> ASN1SingleValueContainer
}

public protocol ASN1MultipleValuesContainer {
    var isAtEnd: Bool {get}
    mutating func decode(_ type: Data.Type, encoded encoding: ASN1Encoding) throws -> Data
    mutating func decode(_ type: Bool.Type, encoded encoding: ASN1Encoding) throws -> Bool
    mutating func decode(_ type: Int.Type, encoded encoding: ASN1Encoding) throws -> Int
    mutating func decode(_ type: Int8.Type, encoded encoding: ASN1Encoding) throws -> Int8
    mutating func decode(_ type: Int16.Type, encoded encoding: ASN1Encoding) throws -> Int16
    mutating func decode(_ type: Int32.Type, encoded encoding: ASN1Encoding) throws -> Int32
    mutating func decode(_ type: Int64.Type, encoded encoding: ASN1Encoding) throws -> Int64
    mutating func decode(_ type: String.Type, encoded encoding: ASN1Encoding) throws -> String
    mutating func decode(_ type: Date.Type, encoded encoding: ASN1Encoding) throws -> Date
    mutating func decode<T: ASN1Decodable>(_ type: T.Type, encoded encoding: ASN1Encoding) throws -> T
    mutating func decodeAny() throws -> Any
    mutating func decodeSequence(of type: Data.Type, encoded encoding: ASN1Encoding) throws -> [Data]
    mutating func decodeSequence(of type: Bool.Type, encoded encoding: ASN1Encoding) throws -> [Bool]
    mutating func decodeSequence(of type: Int.Type, encoded encoding: ASN1Encoding) throws -> [Int]
    mutating func decodeSequence(of type: Int8.Type, encoded encoding: ASN1Encoding) throws -> [Int8]
    mutating func decodeSequence(of type: Int16.Type, encoded encoding: ASN1Encoding) throws -> [Int16]
    mutating func decodeSequence(of type: Int32.Type, encoded encoding: ASN1Encoding) throws -> [Int32]
    mutating func decodeSequence(of type: Int64.Type, encoded encoding: ASN1Encoding) throws -> [Int64]
    mutating func decodeSequence(of type: String.Type, encoded encoding: ASN1Encoding) throws -> [String]
    mutating func decodeSequence(of type: Date.Type, encoded encoding: ASN1Encoding) throws -> [Date]
    mutating func decodeSequence<T: ASN1Decodable>(of type: T.Type, encoded encoding: ASN1Encoding) throws -> [T]
    mutating func decodeSequenceOfAny() throws -> [Any]
    mutating func sequenceContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer
    mutating func setContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer
    mutating func value(encoded encoding: ASN1Encoding) throws -> ASN1SingleValueContainer
}

public protocol ASN1DecoderProtocol {
    func sequenceContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer
    func setContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer
    func value(encoded encoding: ASN1Encoding) throws -> ASN1SingleValueContainer
}

struct _ASN1Decoder: ASN1DecoderProtocol {
    var container: TLV
    var containerEncoding: ASN1Encoding
    
    func sequenceContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer {
        try _ASN1SingleValueContainer(container: container, containerEncoding: containerEncoding).sequenceContainer(encoded: encoding)
    }
    
    func setContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer {
        try _ASN1SingleValueContainer(container: container, containerEncoding: containerEncoding).setContainer(encoded: encoding)
    }
    
    func value(encoded encoding: ASN1Encoding) throws -> ASN1SingleValueContainer {
        try _ASN1SingleValueContainer(container: container, containerEncoding: containerEncoding).value(encoded: encoding)
    }

}
