# ASN1Decoder

ASN1Decoder written in Swift

## Usage:

    public struct SignedData: ASN1Decodable {
        public var version: Int
        public var digestAlgorithms: [AlgorithmIdentifier]
        public var encapContentInfo: EncapsulatedContentInfo
        public var certificates: [Any]?
        public var crls: [Any]?
        public var signerInfos: [SignerInfo]

        public init(from decoder: ASN1DecoderProtocol) throws {
            var c = try decoder.sequenceContainer(encoded: .sequence)
            version = try c.decode(Int.self, encoded: .integer)
            var algorightms = try c.setContainer(encoded: .set)
            digestAlgorithms = try algorightms.decodeSequence(of: AlgorithmIdentifier.self, encoded: .none)
            encapContentInfo = try c.decode(EncapsulatedContentInfo.self, encoded: .none)
            
            var set = try? c.setContainer(encoded: .implicit(.contextSpecific(0), .implicit(.set)))
            certificates = try? set?.decodeSequenceOfAny()
            
            set = try? c.setContainer(encoded: .implicit(.contextSpecific(1), .implicit(.set)))
            crls = try? set?.decodeSequenceOfAny()
            
            var set2 = try c.setContainer(encoded: .set)
            signerInfos = try set2.decodeSequence(of: SignerInfo.self, encoded: .none)
        }
    }

    let data = try ASN1Decoder().decode(SignedData.self, from: data)
