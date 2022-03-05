//
//  ErrorMessage.swift
//  SportsAPP
//
//  Created by Najeh on 26/02/2022.
//

import Foundation
enum SPError :String , Error{
    case invalidRequest    = "This User Created an Invalid request"
    case unableToComplete  = "Unable to complete your request , please check your connection"
    case invalidResponse   = "Invalid response from the server , please try again "
    case invalidData       = "Invalid response from the server , please try again"
}
