//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Umut Barış Çoşkun on 21.11.2022.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
        
        
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    
    }
}
