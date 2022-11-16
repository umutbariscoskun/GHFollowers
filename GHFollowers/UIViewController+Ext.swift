//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Umut Barış Çoşkun on 16.11.2022.
//

import UIKit


extension UIViewController {
 func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
     DispatchQueue.main.async {
         let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
         
         alertVC.modalPresentationStyle = .overFullScreen
         alertVC.modalTransitionStyle  = .crossDissolve
         
         self.present(alertVC, animated: true )
     }
    }
}
