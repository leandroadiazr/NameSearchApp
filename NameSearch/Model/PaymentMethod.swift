struct PaymentMethod: Codable {
    var name: String
    var token: String
    var lastFour: String?
    var displayFormattedEmail: String?
}
