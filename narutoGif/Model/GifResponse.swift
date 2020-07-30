//
//  GifResponse.swift
//  narutoGif
//
//  Created by TXB4 on 28/07/2020.
//  Copyright © 2020 TobaIbrahim. All rights reserved.
//

import UIKit

struct GifResponse: Codable {
    
    let data:[newData]
}

struct newData:Codable {
    
    var images:[String:original]
}



struct original:Codable {
    
//    var original:[String:DeepNestedData]?
////    var downsizedLarge:[String:deepNestedData]?
//    let height:String?
//    let width:String?
    let url:String!
}


struct DeepNestedData:Codable {

//    var height:String?
//    var width:String?
    var url:String
}




