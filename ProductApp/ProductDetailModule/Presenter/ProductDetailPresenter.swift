//
//  ProductDetailPresenter.swift
//  ProductApp
//
//  Created by 2714476 on 17/04/24.
//

import UIKit

class ProductDetailPresenter: ViewToPresenterProductDetailProtocol {
    
    weak var view: PresenterToViewProductDetailProtocol?
    var interactor: PresenterToInteractorProductDetailProtocol?
    var router: PresenterToRouterProductDetailProtocol?
    
    func viewDidLoad() {
        interactor?.fetchProductDetail()
    }
    
    func getProductDetailImage(imageUrl:String,imgView:UIImageView) {
        interactor?.loadImageWith(imageURL: imageUrl,imgView:imgView)
    }
    
    func storeProductObjectInCoreData() {
        interactor?.storeProductObjectInCoreData()
    }
    
    
}


extension ProductDetailPresenter: InteractorToPresenterProductDetailProtocol {
    func didStoreProductObjectInCoreData(success: Bool) {
        view?.didStoreProductObjectInCoreData(success: success)
    }
    
    func didStoreProductObjectInCoreData(failure: Bool) {
        view?.didStoreProductObjectInCoreData(failure: failure)
    }
    
    func fetchProductDetailSuccess(productsList: Product?) {
        view?.retrieveProductDetailSuccess(productsList: productsList)
    }
}
