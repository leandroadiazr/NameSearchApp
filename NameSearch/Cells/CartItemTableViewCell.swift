import UIKit

protocol CartItemTableViewCellDelegate {
    func didRemoveFromCart()
}

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var removeButton: UIButton!
    var domain: Domain?
    var shoppingCart : [Domain] = []

    @IBAction func removeFromCartButtonTapped(_ sender: UIButton) {
        shoppingCart = shoppingCart.filter { $0.name != nameLabel.text! }
        delegate.didRemoveFromCart()
    }

    var delegate: CartItemTableViewCellDelegate!
}
