//
//  ImagesCollectionViewCell.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 31.05.2022.
//

import UIKit
import SDWebImage

class ImagesCollectionViewCell: UICollectionViewCell {
    var photoImage:UIImageView = {
        let photoImage = UIImageView()
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        photoImage.contentMode = .scaleToFill
        photoImage.backgroundColor = .black
        photoImage.clipsToBounds = true
        return photoImage
    }()
    var randomUnsplashPhoto: ImagesResults! {
        didSet {
            let photoUrl = randomUnsplashPhoto.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            photoImage.sd_setImage(with: url, completed: nil)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        contentView.addSubview(photoImage)
        
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    private func customizeCell() {
        photoImage.layer.cornerRadius = 6
    }
}
