//
//  GFBodyLabel.swift
//  GHFollowers
//
//  Created by Umut Barış Çoşkun on 16.11.2022.
//

import UIKit

class GFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("initCoder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment){
        
        super.init(frame: .zero)
        self.textAlignment = textAlignment

        configure()
                
    }
    
    private func configure(){
        textColor = .secondaryLabel
        font    = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        // textOverflow.elipsis
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
        
        
    }

}
