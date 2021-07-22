class PaymentsManager: Codable {
    static var shared = PaymentsManager()

    var selectedPaymentMethod: PaymentMethod?
}
