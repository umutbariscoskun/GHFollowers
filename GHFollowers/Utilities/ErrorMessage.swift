//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Umut Barış Çoşkun on 17.11.2022.
//

import Foundation


enum GFError: String, Error{
   case invalidUsername  = "This username created at an invalid request. Please try again."
   case unableToComplete = "Unable to complete your request. Please check your internet connection"
   case invalidReponse  = "Invalid response from the server. Please try again"
   case invalidData    = "The data received from the server was invalid. Please try again later."
}
