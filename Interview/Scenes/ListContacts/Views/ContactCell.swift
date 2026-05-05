import UIKit

class ContactCell: UITableViewCell {
    lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    lazy var contactImage: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contactImage.image = nil
    }
    
    func configureViews() {
        contentView.addSubview(contactImage)
        contentView.addSubview(fullnameLabel)
        contactImage.addSubview(activity)
        
        contactImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        contactImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contactImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        contactImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        activity.centerYAnchor.constraint(equalTo: contactImage.centerYAnchor).isActive = true
        activity.centerXAnchor.constraint(equalTo: contactImage.centerXAnchor).isActive = true
        activity.heightAnchor.constraint(equalToConstant: 25).isActive = true
        activity.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        fullnameLabel.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 16).isActive = true
        fullnameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        fullnameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        fullnameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(with contact: Contact) {
        fullnameLabel.text = contact.name
        
        if let urlPhoto = URL(string: contact.photoURL) {
            activity.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                
                let data = try? Data(contentsOf: urlPhoto)
                
                DispatchQueue.main.async {
                    self?.activity.stopAnimating()
                    if let data = data, let image = UIImage(data: data) {
                        self?.contactImage.image = image
                    }
                }
            }
        }
    }
}
