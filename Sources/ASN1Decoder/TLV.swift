//
//  File.swift
//  
//
//  Created by Artem Shimanski on 6/28/20.
//

import Foundation

struct TLV {
    
    var type: ASN1Identifier
    var value: Data
    
    init(type: ASN1Identifier, value: Data) {
        self.type = type
        self.value = value
    }
    
    init?(data: Data) {
        var data = data

        guard data.count > 1 else {return nil}
        type = ASN1Identifier(rawValue: data.removeFirst())
        let l = data.removeFirst()
        
        let flag: UInt8 = 0b1000_0000
        let length: Int
        if l & flag == 0 {
            length = Int(l)
        }
        else {
            let c = (l ^ flag)
            guard data.count >= c else {return nil}
            length = data.prefix(Int(c)).reduce(0) { (r, i) in (r << 8) + Int(i) }
            data.removeFirst(Int(c))
        }
        guard data.count >= length, length >= 0 else {return nil}
        value = data.prefix(length)
    }
    
    var subitems: TLVSequence {
        TLVSequence(tlv: self)
    }
    
    var description: String {
        let subitems = self.subitems.map{$0.description}.joined(separator: ",\n").replacingOccurrences(of: "\n", with: "\n\t")
        let tag = String(format: "%x", type.rawValue)
        if !subitems.isEmpty {
            return "{Type(\(tag)), \(value), [\n\t\(subitems)]}"
        }
        else {
            return "{Type(\(tag)), \(value)}"
        }
    }
}

struct TLVSequence: Sequence {
    typealias Element = TLV
    typealias Iterator = TLVIterator

    var tlv: TLV
    
    func makeIterator() -> TLVIterator {
        TLVIterator(data: tlv.value)
    }
}

struct TLVIterator: IteratorProtocol {
    typealias Element = TLV
    var data: Data
    
    mutating func next() -> Element? {
        guard let tlv = TLV(data: data) else {return nil}
        data = data[tlv.value.endIndex...]
        return tlv
    }
}



extension TLV {
    func decode(_ encoding: ASN1Encoding) throws -> TLV {
        try decode(encoding, topLevel: true)
    }
    
    private func decode(_ encoding: ASN1Encoding, topLevel: Bool) throws -> TLV {
        switch encoding {
        case .none:
            return self
//            throw ASN1Error.noASN1Encoding
        case let .implicit(id, next):
            if topLevel {
                guard type.tag == id.tag && type.class == id.class else {
                    throw ASN1Error.typeMismatch(expected: id, actual: type)
                }
            }
            
            if let next = next {
                return try decode(next, topLevel: false)
            }
            else {
                return TLV(type: id, value: value)
            }
        case let .explicit(id, next):
            if topLevel {
                guard type.tag == id.tag && type.class == id.class else {
                    throw ASN1Error.typeMismatch(expected: id, actual: type)
                }
            }

            var i = self.subitems.makeIterator()
            guard let tlv = i.next() else {throw ASN1Error.valueNotFound(id)}
            if let next = next {
                return try tlv.decode(next, topLevel: true)
            }
            else {
                return tlv
            }
        }
    }
}

