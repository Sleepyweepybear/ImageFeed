import UIKit
final class ImagesListCell: UITableViewCell {
    
static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!

    override func prepareForReuse() {
         super.prepareForReuse()
         cellImage.kf.cancelDownloadTask()
     }
    
override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    cellImage.layer.cornerRadius = 16
    cellImage.layer.masksToBounds = true
    
    contentView.layer.cornerRadius = 16
    contentView.layer.masksToBounds = true
    backgroundColor = .clear
    }
}
