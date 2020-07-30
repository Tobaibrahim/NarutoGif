//
//  NetworkManager.swift
//  narutoGif
//
//  Created by TXB4 on 28/07/2020.
//  Copyright © 2020 TobaIbrahim. All rights reserved.
//

import UIKit

class NetworkManager {

static let shared     = NetworkManager()

let cache             = NSCache<NSString,UIImage>()
let key               =  "UFA2wVfgxH1nHxII7dJoTyuxSc314QJo"
private let baseURL   =  "http://api.giphy.com/v1/gifs/search?"
private init () {}


    
    
    func getGifImage (pagination:String, name:String,completed:@escaping(Result<GifResponse,Errors>) -> Void) {
        
        let endpoint = baseURL + "q=\(name)&random&api_key=\(key)&limit=\(pagination)"
        print("DEBUG: ENDPOINT URL = \(endpoint)")
        
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data,response,error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
                
            }
            
            guard let data = data else {
                completed(.failure(.invalidDataResponse))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let gif  = try decoder.decode(GifResponse.self, from: data)
                
                completed(.success(gif))
                print(response.statusCode)
                
            }
                
            catch {
                
                completed(.failure(.invalidDataResponse))
                print(error)
                //              print(data)
            }
        }
        
        task.resume()
    }
    
    
    
}
