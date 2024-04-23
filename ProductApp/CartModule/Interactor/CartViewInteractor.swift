//
//  CartViewInteractor.swift
//  ProductApp
//
//  Created by 2714476 on 18/04/24.
//

import UIKit
import CoreData

class CartViewInteractor: PresenterToInteractorCartViewProtocol {
    
    weak var presenter: InteractorToPresenterCartViewProtocol?
    
    func getCartViewProducts() {
        if let products = CoreDataManager.shared.retrieveAllProducts(){
            print("PRODUCTS COUNT \(products.count)")
            presenter?.fetchCartViewProductsSuccess(productsList: products)
        }else{
            presenter?.fetchCartViewProductsFailure(isLoaded: false)
        }
    }
  
}
