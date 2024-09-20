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
        let appearance = UITabBarAppearance()
        appearance.backgroundColor =  #colorLiteral(red: 0.737254902, green: 0, blue: 0.1764705882, alpha: 1)
        let itemAppearances = UITabBarItemAppearance()
        itemAppearances.normal.iconColor = UIColor(red: 184/255, green: 134/255, blue: 11/255, alpha: 1)
        itemAppearances.normal.titleTextAttributes = [.foregroundColor: UIColor(red: 184/255, green: 134/255, blue: 11/255, alpha: 1)]
        itemAppearances.selected.titleTextAttributes = [.foregroundColor:UIColor.white]
        itemAppearances.selected.iconColor = UIColor.white
        appearance.stackedLayoutAppearance = itemAppearances
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        

     
        let writerVC = self.createVC(nibName: "WriterVC", title: "Writer", imageName: "keyboard")
        
        let sheetsVC = self.createVC(nibName: "SheetsVC", title: "Sheets", imageName: "book.pages")
        let flashCardVC = self.createVC(nibName: "FlashCardVC", title: "Flash Card", imageName: "menucard")
        
        self.viewControllers = [writerVC,sheetsVC,flashCardVC]
        
    }
    
    func createVC(nibName: String,title: String,imageName: String) -> UIViewController{
        let viewController: UIViewController
          switch nibName {
          case "WriterVC":
              viewController = WriterVC(nibName: nibName, bundle: nil)
          case "SheetsVC":
              viewController = SheetsVC(nibName: nibName, bundle: nil)
          case "FlashCardVC":
              viewController = SavedWordsListVC(nibName: nibName, bundle: nil)
          default:
              viewController = UIViewController(nibName: nibName, bundle: nil)
          }
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(systemName: imageName)
        return viewController
    }
}
