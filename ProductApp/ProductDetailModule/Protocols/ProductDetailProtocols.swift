//
//  ProductDetailProtocols.swift
//  ProductApp
//
//  Created by 2714476 on 17/04/24.
//

import UIKit

protocol ViewToPresenterProductDetailProtocol{
    var view: PresenterToViewProductDetailProtocol? {get set}
    var interactor: PresenterToInteractorProductDetailProtocol? {get set}
    var router: PresenterToRouterProductDetailProtocol? {get set}
    
    func viewDidLoad()
    func getProductDetailImage(imageUrl:String,imgView:UIImageView)
    func storeProductObjectInCoreData()
}

protocol PresenterToViewProductDetailProtocol: AnyObject {
    func retrieveProductDetailSuccess(productsList: Product?)
    func didStoreProductObjectInCoreData(success:Bool)
    func didStoreProductObjectInCoreData(failure:Bool)
}

protocol PresenterToInteractorProductDetailProtocol {
    var presenter: InteractorToPresenterProductDetailProtocol? {get set}
    var product:Product? {get set}
    func fetchProductDetail()
    func loadImageWith(imageURL:String,imgView:UIImageView)
    func storeProductObjectInCoreData()
}

protocol InteractorToPresenterProductDetailProtocol: AnyObject {
    func fetchProductDetailSuccess(productsList: Product?)
    func didStoreProductObjectInCoreData(success:Bool)
    func didStoreProductObjectInCoreData(failure:Bool)
    
}

protocol PresenterToRouterProductDetailProtocol {
    static func createProductDetailModule(with product:Product) -> UIViewController?
}

