//
//  ASN1Identifier.swift
//  
//
//  Created by Artem Shimanski on 6/28/20.
//

import Foundation

public struct ASN1Identifier: RawRepresentable, Equatable {
    public let rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    public init(class: Class, tag: Tag) {
        rawValue = `class`.rawValue | tag.rawValue
    }

    public enum Class: UInt8 {
        case universal       = 0b0000_0000
        case application     = 0b0100_0000
        case contextSpecific = 0b1000_0000
        case `private`       = 0b1100_0000
    }

    public struct Tag: RawRepresentable, Equatable {
        public let rawValue: UInt8
        public static let endOfContent = Tag(rawValue: 0x00)
        public static let boolean = Tag(rawValue: 0x01)
        public static let integer = Tag(rawValue: 0x02)
        public static let bitString = Tag(rawValue: 0x03)
        public static let octetString = Tag(rawValue: 0x04)
        public static let null = Tag(rawValue: 0x05)
        public static let objectIdentifier = Tag(rawValue: 0x06)
        public static let objectDescriptor = Tag(rawValue: 0x07)
        public static let external = Tag(rawValue: 0x08)
        public static let read = Tag(rawValue: 0x09)
        public static let enumerated = Tag(rawValue: 0x0A)
        public static let embeddedPdv = Tag(rawValue: 0x0B)
        public static let utf8String = Tag(rawValue: 0x0C)
        public static let relativeOid = Tag(rawValue: 0x0D)
        public static let sequence = Tag(rawValue: 0x10)
        public static let set = Tag(rawValue: 0x11)
        public static let numericString = Tag(rawValue: 0x12)
        public static let printableString = Tag(rawValue: 0x13)
        public static let t61String = Tag(rawValue: 0x14)
        public static let videotexString = Tag(rawValue: 0x15)
        public static let ia5String = Tag(rawValue: 0x16)
        public static let utcTime = Tag(rawValue: 0x17)
        public static let generalizedTime = Tag(rawValue: 0x18)
        public static let graphicString = Tag(rawValue: 0x19)
        public static let visibleString = Tag(rawValue: 0x1A)
        public static let generalString = Tag(rawValue: 0x1B)
        public static let universalString = Tag(rawValue: 0x1C)
        public static let characterString = Tag(rawValue: 0x1D)
        public static let bmpString = Tag(rawValue: 0x1E)
        
        public init (rawValue: UInt8) {
            self.rawValue = rawValue
        }
        
        public static func custom(_ rawValue: UInt8) -> Tag {
            Tag(rawValue: rawValue)
        }
    }
    
    public static let endOfContent: ASN1Identifier = .universal(.endOfContent)
    public static let boolean: ASN1Identifier = .universal(.boolean)
    public static let integer: ASN1Identifier = .universal(.integer)
    public static let bitString: ASN1Identifier = .universal(.bitString)
    public static let octetString: ASN1Identifier = .universal(.octetString)
    public static let null: ASN1Identifier = .universal(.null)
    public static let objectIdentifier: ASN1Identifier = .universal(.objectIdentifier)
    public static let objectDescriptor: ASN1Identifier = .universal(.objectDescriptor)
    public static let external: ASN1Identifier = .universal(.external)
    public static let read: ASN1Identifier = .universal(.read)
    public static let enumerated: ASN1Identifier = .universal(.enumerated)
    public static let embeddedPdv: ASN1Identifier = .universal(.embeddedPdv)
    public static let utf8String: ASN1Identifier = .universal(.utf8String)
    public static let relativeOid: ASN1Identifier = .universal(.relativeOid)
    public static let sequence: ASN1Identifier = ASN1Identifier.universal(.sequence).constructed()
    public static let set: ASN1Identifier = ASN1Identifier.universal(.set).constructed()
    public static let numericString: ASN1Identifier = .universal(.numericString)
    public static let printableString: ASN1Identifier = .universal(.printableString)
    public static let t61String: ASN1Identifier = .universal(.t61String)
    public static let videotexString: ASN1Identifier = .universal(.videotexString)
    public static let ia5String: ASN1Identifier = .universal(.ia5String)
    public static let utcTime: ASN1Identifier = .universal(.utcTime)
    public static let generalizedTime: ASN1Identifier = .universal(.generalizedTime)
    public static let graphicString: ASN1Identifier = .universal(.graphicString)
    public static let visibleString: ASN1Identifier = .universal(.visibleString)
    public static let generalString: ASN1Identifier = .universal(.generalString)
    public static let universalString: ASN1Identifier = .universal(.universalString)
    public static let characterString: ASN1Identifier = .universal(.characterString)
    public static let bmpString: ASN1Identifier = .universal(.bmpString)
    
    public static func universal(_ tag: Tag) -> ASN1Identifier {
        ASN1Identifier(class: .universal, tag: tag)
    }

    public static func application(_ tag: UInt8) -> ASN1Identifier {
        ASN1Identifier(class: .application, tag: .custom(tag))
    }

    public static func contextSpecific(_ tag: UInt8) -> ASN1Identifier {
        ASN1Identifier(class: .contextSpecific, tag: .custom(tag))
    }

    public static func `private`(_ tag: UInt8) -> ASN1Identifier {
        ASN1Identifier(class: .private, tag: .custom(tag))
    }

    public func constructed() -> ASN1Identifier {
        ASN1Identifier(rawValue: rawValue | 0b0010_0000)
    }
    
    public var isConstructed: Bool {
        rawValue & 0b0010_0000 != 0
    }
    
    public var isPrimitive: Bool {
        !isConstructed
    }
    
    public var tag: Tag {
        Tag(rawValue: rawValue & 0b0001_1111)
    }
    
    public var `class`: Class {
        Class(rawValue: rawValue & 0b1100_0000)!
    }
}
