//
//  MainTabBarController.swift
//  iMusic
//
//  Created by user on 08.06.2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        
        tabBar.tintColor = .appPrimary//цвет иконок в таббаре
        
        viewControllers = [
            //здесь инициализируются табы в таббаре
            generateItem(rootViewController: searchVC, image: UIImage(systemName: "magnifyingglass")!, title: "Search"),
            generateItem(rootViewController: ViewController(), image: UIImage(systemName: "music.note.list")!, title: "Library")
        ]
    }
    
    //функция задает названия для табов, картинки
    private func generateItem(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
        
    }
}
