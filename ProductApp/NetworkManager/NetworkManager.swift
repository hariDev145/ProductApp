//
//  NetworkManager.swift
//  ProductApp
//
//  Created by 2714476 on 15/04/24.
//

import UIKit
import Alamofire


class NetworkManager{
    
    static let sharedInstance = NetworkManager()
    
    func fetchAPIData(limit:Int, skip:Int, onSuccess: @escaping(ProductsList) -> Void, onFailure: @escaping(Error) -> Void){
        
        let url = Constants.Product.productApiUrl + "?limit=\(limit)&skip=\(skip)"
        
        AF.request(url, method:.get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response{
            response in
            switch response.result{
            case .success(let data):
                do{
                    
                    let jsonData = try JSONDecoder().decode(ProductsList.self, from: data!)
                    onSuccess(jsonData)
                }catch{
                    print(error.localizedDescription)
                }
            case .failure(let error):
                onFailure(error)
                print(error.localizedDescription)
            }
        }
        
    }
    
    
}
