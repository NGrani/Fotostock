//
//  FavoriteImageViewController.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 31.05.2022.
//

import UIKit

class FavoriteImageViewController: UIViewController {
    
    var networkDatafetcher = NetworkDataFetcher()
    lazy var image: [ImagesResults] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        layout()
        image =  networkDatafetcher.loadJson(filename: "favorite")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        image =  networkDatafetcher.loadJson(filename: "favorite")
        tableView.reloadData()
        print(image)
    }
    
    private func layout(){
        [tableView].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}
// MARK: - UITableViewDataSource

extension  FavoriteImageViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return image.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as! FavoriteTableViewCell
        let unspashPhoto = image[indexPath.row]
        cell.randomUnsplashPhoto = unspashPhoto
        cell.autorLabel.text = image[indexPath.row].user?.name
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteImageViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.setupDetailPostVC(model: image[indexPath.item])
        detailVC.modelForSave = image[indexPath.item]
        present(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let post = image[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {[self] _,_,_   in
            image.removeAll(where: {$0 == post })
            tableView.deleteRows(at: [indexPath], with: .automatic)
            networkDatafetcher.saveJson(fileName: "favorite", model: image)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
        
    }
}



