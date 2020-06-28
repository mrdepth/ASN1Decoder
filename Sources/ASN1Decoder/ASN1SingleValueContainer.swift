//
//  ASN1SingleValueContainer.swift
//  
//
//  Created by Artem Shimanski on 6/28/20.
//

import Foundation

struct _ASN1SingleValueContainer: ASN1SingleValueContainer {
    var container: TLV
    var containerEncoding: ASN1Encoding
    
    func decode(_ type: Data.Type, encoded encoding: ASN1Encoding) throws -> Data {
        let tlv = try container.decode(containerEncoding.appending(encoding))
        if tlv.type == .integer {
            if tlv.value.first == 0 {
                return tlv.value.dropFirst()
            }
        }
        return tlv.value
    }

    func decode(_ type: Bool.Type, encoded encoding: ASN1Encoding) throws -> Bool {
        let tlv = try container.decode(containerEncoding.appending(encoding))
        return (tlv.value.first ?? 0) != 0
    }

    
    func decode(_ type: Int.Type, encoded encoding: ASN1Encoding) throws -> Int {
        let i = try decode(Int64.self, encoded: encoding)
        guard let result = Int(exactly: i) else {throw ASN1Error.overflow}
        return result
    }

    func decode(_ type: Int8.Type, encoded encoding: ASN1Encoding) throws -> Int8 {
        let i = try decode(Int64.self, encoded: encoding)
        guard let result = Int8(exactly: i) else {throw ASN1Error.overflow}
        return result
    }

    func decode(_ type: Int16.Type, encoded encoding: ASN1Encoding) throws -> Int16 {
        let i = try decode(Int64.self, encoded: encoding)
        guard let result = Int16(exactly: i) else {throw ASN1Error.overflow}
        return result
    }
    
    func decode(_ type: Int32.Type, encoded encoding: ASN1Encoding) throws -> Int32 {
        let i = try decode(Int64.self, encoded: encoding)
        guard let result = Int32(exactly: i) else {throw ASN1Error.overflow}
        return result
    }

    
    func decode(_ type: Int64.Type, encoded encoding: ASN1Encoding) throws -> Int64 {
        let tlv = try container.decode(containerEncoding.appending(encoding))
        var data = tlv.value
        guard !data.isEmpty else {return 0}
        let sign: Int64
        
        if data.first == 0 {
            _ = data.removeFirst()
            sign = 0
        }
        else {
            sign = 1
        }
        
        if data.count <= MemoryLayout<Int64>.size {
            guard !data.isEmpty else {return 0}
            var n: Int64
            if data[data.startIndex] & 0b1000_0000 == 0 {
                n = 0
            }
            else {
                n = sign * -1
            }
            for i in data {
                n = (n << 8) | Int64(i)
            }
            return n
        }
        else {
            throw ASN1Error.overflow
        }

    }
    
    func decode(_ type: String.Type, encoded encoding: ASN1Encoding) throws -> String {
        let tlv = try container.decode(containerEncoding.appending(encoding))
        switch tlv.type {
        case .bmpString:
            guard let s = String(data: tlv.value, encoding: .unicode) else {throw ASN1Error.invalidStringEncoding}
            return s
        case .ia5String, .visibleString:
            guard let s = String(data: tlv.value, encoding: .ascii) else {throw ASN1Error.invalidStringEncoding}
            return s
        case .generalString, .graphicString, .numericString, .videotexString, .characterString, .printableString, .universalString, .utf8String:
            guard let s = String(data: tlv.value, encoding: .utf8) else {throw ASN1Error.invalidStringEncoding}
            return s
        case .objectIdentifier:
            var data = tlv.value
            guard !data.isEmpty else {return ""}
            let first = data.removeFirst()
            var oid = "\(first / 40).\(first % 40)"
            
            var t = 0
            for i in data {
                let n = Int(i)
                t = (t << 7) | (n & 0b0111_1111)
                if n & 0b1000_0000 == 0 {
                    oid += ".\(t)"
                    t = 0
                }
            }
            return oid
        default:
            throw ASN1Error.typeMismatch(expected: .utf8String, actual: tlv.type)
        }
    }
    
    static let utcTimeFormatters = ["yyMMddHHmmssZ", "yyMMddHHmmZ"].map { format -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
    
    static let generalizedTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    func decode(_ type: Date.Type, encoded encoding: ASN1Encoding) throws -> Date {
        let tlv = try container.decode(containerEncoding.appending(encoding))
        switch tlv.type {
        case .utcTime:
            guard let s = String(data: tlv.value, encoding: .unicode) else {throw ASN1Error.invalidStringEncoding}
            guard let date = Self.utcTimeFormatters.lazy.compactMap({$0.date(from: s)}).first else {throw ASN1Error.invalidDateFormat(s)}
            return date
        case .generalizedTime:
            guard let s = String(data: tlv.value, encoding: .unicode) else {throw ASN1Error.invalidStringEncoding}
            guard let date = Self.generalizedTimeFormatter.date(from: s) else {throw ASN1Error.invalidDateFormat(s)}
            return date
        default:
            throw ASN1Error.typeMismatch(expected: .utcTime, actual: tlv.type)
        }
    }
    
    func decode<T: ASN1Decodable>(_ type: T.Type, encoded encoding: ASN1Encoding) throws -> T {
        try T(from: _ASN1Decoder(container: container, containerEncoding: containerEncoding.appending(encoding)))
    }
    
    func decodeAny() throws -> Any {
        switch container.type {
        case .bitString, .octetString:
            return try decode(Data.self, encoded: .implicit(container.type))
        case .ia5String, .visibleString, .objectIdentifier:
            return try decode(String.self, encoded: .implicit(container.type))
        case .generalString, .graphicString, .numericString, .videotexString, .characterString, .printableString, .universalString, .utf8String:
            return try decode(String.self, encoded: .implicit(container.type))
        case .integer:
            if container.value.count <= MemoryLayout<Int64>.size {
                return try decode(Int64.self, encoded: .implicit(container.type))
            }
            else {
                return try decode(String.self, encoded: .implicit(container.type))
            }
        default:
            if container.type.isConstructed {
                var set = try sequenceContainer(encoded: .implicit(container.type))
                return try set.decodeSequenceOfAny()
            }
            else {
                return try decode(Data.self, encoded: .implicit(container.type))
            }
        }
    }
    
    func sequenceContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer {
        let tlv = try container.decode(containerEncoding.appending(encoding))
        return _ASN1SequenceContainer(container: tlv.subitems.map{$0})
    }
    
    func setContainer(encoded encoding: ASN1Encoding) throws -> ASN1MultipleValuesContainer {
        let tlv = try container.decode(containerEncoding.appending(encoding))
        return _ASN1SequenceContainer(container: tlv.subitems.map{$0})
    }
    
    func value(encoded encoding: ASN1Encoding) throws -> ASN1SingleValueContainer {
        let tlv = try container.decode(containerEncoding.appending(encoding))
        return _ASN1SingleValueContainer(container: tlv, containerEncoding: .implicit(tlv.type, nil))
    }

}
