//
//  ProductDetailInteractor.swift
//  ProductApp
//
//  Created by 2714476 on 17/04/24.
//

import UIKit
import CoreData

class ProductDetailInteractor: PresenterToInteractorProductDetailProtocol {
    
    weak var presenter: InteractorToPresenterProductDetailProtocol?
    var product:Product?
    
    func fetchProductDetail() {
        presenter?.fetchProductDetailSuccess(productsList: product)
    }
    
    func loadImageWith(imageURL:String,imgView:UIImageView) {
        if let url = URL(string: imageURL){
            imgView.af.setImage(withURL: url)
        }
    }
    
    func storeProductObjectInCoreData() {
        saveProductData()
    }
    
    func saveProductData() {
        if let product = product {
            let result = CoreDataManager.shared.insertObject(product: product)
            
            if !result.objectSaved && !result.objectExists {
                presenter?.didStoreProductObjectInCoreData(failure: true)
            }else if result.objectSaved && !result.objectExists{
                presenter?.didStoreProductObjectInCoreData(success: true)
            }else if !result.objectSaved && result.objectExists{
                presenter?.didStoreProductObjectInCoreData(success: false)
            }
        }
        
    }
}
