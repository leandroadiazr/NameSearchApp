import UIKit

protocol CartItemTableViewCellDelegate {
    func didRemoveFromCart()
}

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var removeButton: UIButton!
    var domain: Domain?

    @IBAction func removeFromCartButtonTapped(_ sender: UIButton) {
        ShoppingCart.shared.domains = ShoppingCart.shared.domains.filter { $0.name != nameLabel.text! }

        delegate.didRemoveFromCart()
    }

    var delegate: CartItemTableViewCellDelegate!
}
