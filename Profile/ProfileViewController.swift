import UIKit

final class ProfileViewController: UIViewController {
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var profileImageView: UIImageView?
    private var exitButton: UIButton?
    private var profileInformation: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewToTheScreen()
    }
    
    private func addViewToTheScreen () {
        
        let profileImageView = UIImageView(image: UIImage(resource: .avatar))
        let nameLabel = UILabel()
        let loginLabel = UILabel()
        let descriptionLabel = UILabel()
        let exitButton = UIButton.systemButton(with: UIImage(named:"logout_button")!, target: self, action: #selector(didTapLogoutButton)
        )
        
        self.nameLabel = nameLabel
        self.loginLabel = loginLabel
        self.descriptionLabel = descriptionLabel
        self.profileImageView = profileImageView
        self.exitButton = exitButton
        
        profileInformation = [nameLabel, loginLabel, descriptionLabel, profileImageView]
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor(named: "YP_Gray")
        loginLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        exitButton.tintColor = UIColor(named: "YP_Red")
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(profileImageView)
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        )
    }
    @objc private func didTapLogoutButton () {
        
        for view in profileInformation {
            view.removeFromSuperview()
        }
        profileInformation.removeAll()
        
        nameLabel = nil
        loginLabel = nil
        descriptionLabel = nil
        profileImageView = nil
        
        let emptyProfile = UIImageView(image: UIImage(named: "emptyProfile"))
        emptyProfile.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(emptyProfile)
        guard let exitButton = self.exitButton else { return }
                
                NSLayoutConstraint.activate([
                    emptyProfile.widthAnchor.constraint(equalToConstant: 70),
                    emptyProfile.heightAnchor.constraint(equalToConstant: 70),
                    emptyProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    emptyProfile.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
                    
                    exitButton.centerYAnchor.constraint(equalTo: emptyProfile.centerYAnchor)
                ])
    }
    
}
