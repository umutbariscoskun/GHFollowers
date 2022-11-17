//
//  FollowersListVC.swift
//  GHFollowers
//
//  Created by Umut Barış Çoşkun on 14.11.2022.
//

import UIKit

class FollowersListVC: UIViewController {
    
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: userName, page: 1 ) {(followers, errorMessage) in
            guard let followers = followers else {
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: errorMessage!.rawValue, buttonTitle: "OK")
                return
            }
            print("Followers.count = \(followers.count)")
            print(followers)

        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

  

}
