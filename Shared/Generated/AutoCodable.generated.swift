// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

extension Redux.Action.Refined {
    enum CodingKeys: String, CodingKey {
        case state
        case modify
        case setText
    }
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.allKeys.contains(.state), try container.decodeNil(forKey: .state) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .state)
            let associatedValue0 = try associatedValues.decode(Redux.State.self)
            self = .state(associatedValue0)
            return
        }
        if container.allKeys.contains(.modify), try container.decodeNil(forKey: .modify) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .modify)
            let associatedValue0 = try associatedValues.decode(Modification.self)
            self = .modify(associatedValue0)
            return
        }
        if container.allKeys.contains(.setText), try container.decodeNil(forKey: .setText) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .setText)
            let associatedValue0 = try associatedValues.decode(String?.self)
            self = .setText(associatedValue0)
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case"))
    }
    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .state(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .state)
            try associatedValues.encode(associatedValue0)
        case let .modify(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .modify)
            try associatedValues.encode(associatedValue0)
        case let .setText(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .setText)
            try associatedValues.encode(associatedValue0)
        }
    }
}
extension Redux.Action.Refined.Modification {
    enum CodingKeys: String, CodingKey {
        case increase
        case decrease
        case set
    }
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.allKeys.contains(.increase), try container.decodeNil(forKey: .increase) == false {
            self = .increase
            return
        }
        if container.allKeys.contains(.decrease), try container.decodeNil(forKey: .decrease) == false {
            self = .decrease
            return
        }
        if container.allKeys.contains(.set), try container.decodeNil(forKey: .set) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .set)
            let associatedValue0 = try associatedValues.decode(Int.self)
            self = .set(associatedValue0)
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case"))
    }
    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .increase:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .increase)
        case .decrease:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .decrease)
        case let .set(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .set)
            try associatedValues.encode(associatedValue0)
        }
    }
}
