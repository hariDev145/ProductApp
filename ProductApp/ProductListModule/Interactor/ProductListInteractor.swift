//
//  ProductListInteractor.swift
//  ProductApp
//
//  Created by 2714476 on 13/04/24.
//

import UIKit
import SwiftyJSON

class ProductListInteractor: PresenterToInteractorProductListProtocol {
    
    weak var presenter: InteractorToPresenterProductListProtocol?

    
    func fetchProductList(limit:Int, skip:Int) {
        
        //Network call for fetching Api response
      /*  NetworkManager.sharedInstance.fetchAPIData(limit: limit, skip: skip) { ProductsList in
            self.presenter?.fetchProductListSuccess(productsList: ProductsList)
        } onFailure: { error in
            self.presenter?.fetchProductListFailure(error: error)
        }*/
        
        //Loading JSON response from Bundle
        loadJsonDataFromBundle()
    }
    
    
    func loadJsonDataFromBundle(){
        if let url = Bundle.main.url(forResource: "ProductJson", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let productsList = try decoder.decode(ProductsList.self, from: data)
                presenter?.fetchProductListSuccess(productsList: productsList)
            } catch {
                print("error:\(error)")
            }
        }
    }
    
}
