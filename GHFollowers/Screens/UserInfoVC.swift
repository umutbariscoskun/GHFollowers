//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Umut Barış Çoşkun on 20.11.2022.
//

import UIKit

class UserInfoVC: UIViewController {
    var username: string!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self , action: #selector(dismissVC))
        navigationItem.rightBarButtonItem  = doneButton

   
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    

 

}
