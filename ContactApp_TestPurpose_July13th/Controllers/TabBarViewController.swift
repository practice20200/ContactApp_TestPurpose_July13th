//
//  TabBarViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit

class TabBarViewController: UITabBarController{
    
    override func viewDidLoad() {
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
       
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName:"magnifyingglass.circle"), tag: 1)
       
        
        let addVC = AddContactViewController()
        addVC.tabBarItem = UITabBarItem(title: "Add", image:UIImage(systemName:"person.badge.plus"), tag: 2)

        tabBar.backgroundColor = UIColor.systemGray4
        tabBar.tintColor = UIColor.systemGray

        viewControllers = [homeVC, searchVC, addVC]

    }
}
