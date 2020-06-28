//
//  ASN1Encoding.swift
//  
//
//  Created by Artem Shimanski on 6/28/20.
//

import Foundation

public indirect enum ASN1Encoding {
    case none
    case implicit(ASN1Identifier, ASN1Encoding?)
    case explicit(ASN1Identifier, ASN1Encoding?)
    
    public static func implicit(_ id: ASN1Identifier) -> ASN1Encoding {
        .implicit(id, nil)
    }

    public static func explicit(_ id: ASN1Identifier) -> ASN1Encoding {
        .explicit(id, nil)
    }
    
    public func appending(_ encoding: ASN1Encoding) -> ASN1Encoding {
        if case .none = encoding {
            return self
        }
        
        switch self {
        case .none:
            return encoding
        case let .implicit(id, next):
            if let next = next {
                return .implicit(id, next.appending(encoding))
            }
            else {
                return .implicit(id, encoding)
            }
        case let .explicit(id, next):
            if let next = next {
                return .explicit(id, next.appending(encoding))
            }
            else {
                return .explicit(id, encoding)
            }
        }
    }
}

extension ASN1Encoding {
    public static let endOfContent: ASN1Encoding = .implicit(.universal(.endOfContent))
    public static let boolean: ASN1Encoding = .implicit(.universal(.boolean))
    public static let integer: ASN1Encoding = .implicit(.universal(.integer))
    public static let bitString: ASN1Encoding = .implicit(.universal(.bitString))
    public static let octetString: ASN1Encoding = .implicit(.universal(.octetString))
    public static let null: ASN1Encoding = .implicit(.universal(.null))
    public static let objectIdentifier: ASN1Encoding = .implicit(.universal(.objectIdentifier))
    public static let objectDescriptor: ASN1Encoding = .implicit(.universal(.objectDescriptor))
    public static let external: ASN1Encoding = .implicit(.universal(.external))
    public static let read: ASN1Encoding = .implicit(.universal(.read))
    public static let enumerated: ASN1Encoding = .implicit(.universal(.enumerated))
    public static let embeddedPdv: ASN1Encoding = .implicit(.universal(.embeddedPdv))
    public static let utf8String: ASN1Encoding = .implicit(.universal(.utf8String))
    public static let relativeOid: ASN1Encoding = .implicit(.universal(.relativeOid))
    public static let sequence: ASN1Encoding = .implicit(ASN1Identifier.universal(.sequence).constructed())
    public static let set: ASN1Encoding = .implicit(ASN1Identifier.universal(.set).constructed())
    public static let numericString: ASN1Encoding = .implicit(.universal(.numericString))
    public static let printableString: ASN1Encoding = .implicit(.universal(.printableString))
    public static let t61String: ASN1Encoding = .implicit(.universal(.t61String))
    public static let videotexString: ASN1Encoding = .implicit(.universal(.videotexString))
    public static let ia5String: ASN1Encoding = .implicit(.universal(.ia5String))
    public static let utcTime: ASN1Encoding = .implicit(.universal(.utcTime))
    public static let generalizedTime: ASN1Encoding = .implicit(.universal(.generalizedTime))
    public static let graphicString: ASN1Encoding = .implicit(.universal(.graphicString))
    public static let visibleString: ASN1Encoding = .implicit(.universal(.visibleString))
    public static let generalString: ASN1Encoding = .implicit(.universal(.generalString))
    public static let universalString: ASN1Encoding = .implicit(.universal(.universalString))
    public static let characterString: ASN1Encoding = .implicit(.universal(.characterString))
    public static let bmpString: ASN1Encoding = .implicit(.universal(.bmpString))
}
