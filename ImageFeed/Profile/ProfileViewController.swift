import UIKit
import WebKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var profileImageView: UIImageView?
    private var logoutButton: UIButton?
    private var profileInformation: [UIView] = []
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named:"YP_Black")
        
        addViewToTheScreen()
        
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(profile: profile)
        }
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL),
            let imageView = profileImageView
        else { return }
        
        print("imageUrl: \(imageUrl)")
        let url = URL(string: profileImageURL)
        
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: imageUrl,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel?.text = profile.name.isEmpty
        ? "Имя не указано"
        : profile.name
        loginLabel?.text = profile.loginName.isEmpty
        ? "@неизвестный_пользователь"
        : profile.loginName
        descriptionLabel?.text = (profile.bio?.isEmpty ?? true)
        ? "Профиль не заполнен"
        : profile.bio
    }
    
    private func addViewToTheScreen () {
        
        let profileImageView = UIImageView(image: UIImage(resource: .avatar))
        let nameLabel = UILabel()
        let loginLabel = UILabel()
        let descriptionLabel = UILabel()
        let logoutButtonImage = UIImage(named: "logout_button") ?? UIImage()
        let logoutButton = UIButton.systemButton(
            with: logoutButtonImage,
            target: self,
            action: #selector(didTapLogoutButton)
        )
        
        self.nameLabel = nameLabel
        self.loginLabel = loginLabel
        self.descriptionLabel = descriptionLabel
        self.profileImageView = profileImageView
        self.logoutButton = logoutButton
        
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
        
        logoutButton.tintColor = UIColor(named: "YP_Red")
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(profileImageView)
        view.addSubview(logoutButton)
        
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
            
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
        guard let logoutButton = self.logoutButton else { return }
        
        NSLayoutConstraint.activate([
            emptyProfile.widthAnchor.constraint(equalToConstant: 70),
            emptyProfile.heightAnchor.constraint(equalToConstant: 70),
            emptyProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyProfile.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            logoutButton.centerYAnchor.constraint(equalTo: emptyProfile.centerYAnchor)
        ])
    }
    
}
