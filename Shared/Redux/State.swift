enum Redux {
    struct State: Codable, Equatable {
        var text: String?
        var counter: Int
    }
}
