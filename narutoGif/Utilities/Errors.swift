//
//  Errors.swift
//  narutoGif
//
//  Created by TXB4 on 28/07/2020.
//  Copyright © 2020 TobaIbrahim. All rights reserved.
//


import UIKit

enum Errors: String,Error {
    
    case invalidURL          = "This url is invalid"
    case unableToComplete    = "Unable to connect start url session"
    case invalidResponse     = "Invalid response from the http call"
    case invalidDataResponse = "Invalid data response from call"
}

