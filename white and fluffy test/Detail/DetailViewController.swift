//
//  DetailViewController.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 01.06.2022.
//
import UIKit
//import SDWebImage

class DetailViewController: UIViewController  {
    
    override func loadView() {
        view = DetailView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        view.reloadInputViews()
    }
}
