import Foundation

protocol AutoDecodable: Decodable {}
protocol AutoEncodable: Encodable {}
protocol AutoCodable: AutoDecodable, AutoEncodable {}

// It's recommended that you use enums for your actions to ensure a well typed implementation.
extension Redux {
    enum Action {
        enum Refined: AutoCodable, Equatable {
            case state(Redux.State)
            case modify(Modification)
            case setText(String?)

            enum Modification: AutoCodable, Equatable {
                case increase
                case decrease
                case set(Int)
            }
        }

        enum Raw {
            case networkCall(URL)
            case reset
        }
    }
}
