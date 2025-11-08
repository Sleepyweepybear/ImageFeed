import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    @IBOutlet private var exitButton: UIButton!

    @IBAction private func didTapLogoutButton() {
    }
}
