//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Umut Barış Çoşkun on 23.11.2022.
//


import UIKit

extension UITableView {
    
    func reloadDataOnMainThread(){
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeExcessCells(){
        tableFooterView = UIView(frame: .zero)
    }
    
}

