//
//  ViewController.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 31.05.2022.
//

import UIKit
class MainTabBar: UITabBarController {
    let imagesVC = ImagesViewController()
    let favoriteImagesVC = FavoriteImageViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
    }
    private func setupControllers() {
        let navigationImagesController = UINavigationController(rootViewController: imagesVC)
        let navigationFavoriteImagesController = UINavigationController(rootViewController: favoriteImagesVC)
        imagesVC.tabBarItem.title = "Фотографии"
        imagesVC.tabBarItem.image = UIImage(systemName: "photo.on.rectangle")
        imagesVC.navigationItem.title = "Фотографии"
        imagesVC.setupSearchBar()
        favoriteImagesVC.tabBarItem.title = "Любимые фотографии"
        favoriteImagesVC.tabBarItem.image = UIImage(systemName: "heart.rectangle")
        favoriteImagesVC.navigationItem.title = "Любимые фотографии"
        viewControllers = [navigationImagesController, navigationFavoriteImagesController]
    }
}
