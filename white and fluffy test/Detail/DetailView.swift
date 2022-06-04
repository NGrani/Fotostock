//
//  DetailView.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 04.06.2022.
//

import UIKit
import SDWebImage

class DetailView: UIView{
    static var model: ImagesResults?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDetailPostVC(model: DetailView.model)
        layout()
        favoriteImage = LocalDataService.shared.loadJson(filename: "favorite")
        checkFovorite()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var favoriteImage: [ImagesResults] = []
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        return $0
    }(UIView())
    let image:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        image.clipsToBounds = true
        return image
    }()
    private let autorLabel: UILabel = {
        let autorLabel = UILabel()
        autorLabel.translatesAutoresizingMaskIntoConstraints = false
        autorLabel.numberOfLines = 2
        autorLabel.font = .systemFont(ofSize: 20, weight: .bold)
        autorLabel.textColor = .black
        autorLabel.text = "sometext"
        return autorLabel
    }()
    private let dateCreation: UILabel = {
        let dateCreation = UILabel()
        dateCreation.translatesAutoresizingMaskIntoConstraints = false
        dateCreation.font = .systemFont(ofSize: 14)
        dateCreation.textColor = .systemGray
        dateCreation.text = "date"
        return dateCreation
    }()
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = .systemFont(ofSize: 16)
        locationLabel.textColor = .black
        locationLabel.numberOfLines = 0
        locationLabel.text = "Нет информации"
        return locationLabel
    }()
    private let downloadCountLabel: UILabel = {
        let downloadCountLabel = UILabel()
        downloadCountLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadCountLabel.font = .systemFont(ofSize: 16)
        downloadCountLabel.textColor = .black
        downloadCountLabel.text = ""
        return downloadCountLabel
    }()
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
        likeButton.addTarget(self, action: #selector(deleteToFavorite), for: .touchUpInside)
        likeButton.alpha = 0
        return likeButton
    }()
    private lazy var unlikeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
        likeButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        return likeButton
    }()

    @objc private func addToFavorite() {

        let alertController = UIAlertController(title: "",
                                                message: " Фото будет добавлено в альбом",
                                                preferredStyle: .alert)
        let add = UIAlertAction(title: "Добавить", style: .default) { [self] (action) in
            favoriteImage.append(DetailView.model!)
            LocalDataService.shared.saveJson(fileName: "favorite", model: favoriteImage)
            likeButton.alpha = 1
            unlikeButton.alpha = 0
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) in
        }
        alertController.addAction(add)
        alertController.addAction(cancel)
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        window?.rootViewController?.presentedViewController?.present(alertController,
                                                                     animated: true,
                                                                     completion: nil)
    }
    @objc private func deleteToFavorite(){
        let alertController = UIAlertController(title: "",
                                                message: " Фото будет удалено из альбом",
                                                preferredStyle: .alert)
        let add = UIAlertAction(title: "Удалить", style: .default) { [self] (action) in
            let index = favoriteImage.firstIndex(where: {$0 == DetailView.model})
            if let index = index{
                favoriteImage.remove(at: index)
                LocalDataService.shared.saveJson(fileName: "favorite", model: favoriteImage)
                likeButton.alpha = 0
                unlikeButton.alpha = 1
            }
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) in
        }
        alertController.addAction(add)
        alertController.addAction(cancel)
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        window?.rootViewController?.presentedViewController?.present(alertController,
                                                                     animated: true,
                                                                     completion: nil)
    }
    func setupDetailPostVC(model: ImagesResults?) {
        guard let model = model else { return }
        let photoUrl = model.urls["regular"]
        guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
        image.sd_setImage(with: url, completed: nil)
        autorLabel.text = model.user?.name
        dateCreation.text = model.created_at
        locationLabel.text = model.location?.name
        downloadCountLabel.text = "Downloads \(model.downloads)"
    }
    private func checkFovorite(){
        if favoriteImage.contains(where: { $0 == DetailView.model }){
            likeButton.alpha = 1
            unlikeButton.alpha = 0
        }
    }
    private func layout(){
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [image, autorLabel, dateCreation, locationLabel, likeButton, downloadCountLabel, unlikeButton].forEach {
            contentView.addSubview($0)
            
        }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            autorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            autorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: autorLabel.bottomAnchor, constant: 12),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            image.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            dateCreation.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            dateCreation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateCreation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            locationLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            locationLabel.widthAnchor.constraint(equalToConstant: 250)
        ])
        NSLayoutConstraint.activate([
            downloadCountLabel.centerYAnchor.constraint(equalTo: dateCreation.centerYAnchor),
            downloadCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            downloadCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: dateCreation.bottomAnchor, constant: 16),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            unlikeButton.topAnchor.constraint(equalTo: dateCreation.bottomAnchor, constant: 16),
            unlikeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            unlikeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8)
        ])
    }
}
