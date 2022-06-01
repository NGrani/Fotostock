//
//  FavoriteCollectionViewCell.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 01.06.2022.
//

import UIKit
import SDWebImage

class FavoriteTableViewCell: UITableViewCell {
    
    private let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = .white
        return cellView
    }()
    
    private var photoImage:UIImageView = {
        let photoImage = UIImageView()
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        photoImage.contentMode = .scaleAspectFill
        photoImage.backgroundColor = .black
        photoImage.clipsToBounds = true
        return photoImage
    }()
    
    var autorLabel: UILabel = {
        let autorLabel = UILabel()
        autorLabel.translatesAutoresizingMaskIntoConstraints = false
        autorLabel.numberOfLines = 2
        autorLabel.font = .systemFont(ofSize: 20, weight: .bold)
        autorLabel.textColor = .black
        autorLabel.text = "sometext"
        return autorLabel
    }()
    
    
    var randomUnsplashPhoto: ImagesResults! {
        didSet {
            let photoUrl = randomUnsplashPhoto.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            photoImage.sd_setImage(with: url, completed: nil)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customizeCell()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.image = nil
    }
    
    private func layout() {
        [cellView, photoImage, autorLabel].forEach { contentView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            photoImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            photoImage.heightAnchor.constraint(equalToConstant: 100),
            photoImage.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            autorLabel.leadingAnchor.constraint(equalTo: photoImage.trailingAnchor, constant: 16),
            autorLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
        ])
    }
    
    private func customizeCell(){
        photoImage.layer.cornerRadius = 6
    }
}
