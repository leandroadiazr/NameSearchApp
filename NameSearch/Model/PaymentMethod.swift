struct PaymentMethod: Decodable {
    let name: String
    let token: String
    let lastFour: String?
    let displayFormattedEmail: String?
}
