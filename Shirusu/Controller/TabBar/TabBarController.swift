//
//  TabBarController.swift
//  Shirusu
//
//  Created by Sai Balaji on 31/08/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createTabBar()
        
    }
    
    
    func createTabBar(){
        let writerVC = self.createVC(nibName: "WriterVC", title: "Writer", imageName: "keyboard")
        let sheetsVC = self.createVC(nibName: "SheetsVC", title: "Sheets", imageName: "book.pages")
        let settingsVC = self.createVC(nibName: "SettingsVC", title: "Settings", imageName: "gear")
        self.viewControllers = [writerVC,sheetsVC,settingsVC]
    }
    
    func createVC(nibName: String,title: String,imageName: String) -> UIViewController{
        let viewController = UIViewController(nibName: nibName, bundle: nil)
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(systemName: imageName)
        return viewController
    }
}
