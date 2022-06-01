//
//  ImagesViewController.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 31.05.2022.
//

import UIKit

class ImagesViewController: UIViewController {

    private var networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    private var image: [ImagesResults] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .white
        collection.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: ImagesCollectionViewCell.identifier)

        return collection
    }()

    func setupSearchBar() {
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
    }
    private let viewUnderImage: UIView = {
        let viewUnderImage = UIView()
        viewUnderImage.translatesAutoresizingMaskIntoConstraints = false
        viewUnderImage.backgroundColor = .black
        viewUnderImage.alpha = 0.0
        return viewUnderImage
    }()

    private func getRandomImage(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchRequest: "") { [weak self] (randomResults) in
                guard let fetchedPhotos = randomResults else { return }
                self?.image = fetchedPhotos
                self?.collectionView.reloadData()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        layout()
        getRandomImage()
    }
    private func layout(){
        [collectionView, viewUnderImage].forEach {view.addSubview($0)}

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            viewUnderImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewUnderImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewUnderImage.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
            viewUnderImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
// MARK: - UICollectionViewDataSource

extension ImagesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.identifier, for: indexPath) as! ImagesCollectionViewCell
        let unspashPhoto = image[indexPath.item]
        cell.randomUnsplashPhoto = unspashPhoto
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImagesViewController: UICollectionViewDelegateFlowLayout{
    private var sideInset: CGFloat { return 8 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - sideInset * 4) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sideInset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sideInset
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.setupDetailPostVC(model: image[indexPath.item])
        detailVC.modelForSave = image[indexPath.item]
        present(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ImagesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewUnderImage.alpha = 0
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewUnderImage.alpha = 0
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn) {
            self.viewUnderImage.alpha = 0.7
        }
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchRequest: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.image = fetchedPhotos
                self?.collectionView.reloadData()
            }
        })
    }
}
