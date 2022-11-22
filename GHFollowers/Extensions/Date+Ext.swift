//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Umut Barış Çoşkun on 22.11.2022.
//

import Foundation


extension Date {
    
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
        
    }
}
