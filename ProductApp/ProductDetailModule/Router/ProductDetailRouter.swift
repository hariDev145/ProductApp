//
//  ProductDetailRouter.swift
//  ProductApp
//
//  Created by 2714476 on 17/04/24.
//

import UIKit

class ProductDetailRouter: PresenterToRouterProductDetailProtocol {
    
    static func createProductDetailModule(with product: Product) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(identifier: Constants.productDetailViewController) as? ProductDetailViewController {
            
            let presenter: ViewToPresenterProductDetailProtocol & InteractorToPresenterProductDetailProtocol = ProductDetailPresenter()
            viewController.presenter = presenter
            viewController.presenter?.router = ProductDetailRouter()
            viewController.presenter?.view = viewController
            viewController.presenter?.interactor = ProductDetailInteractor()
            viewController.presenter?.interactor?.product = product
            viewController.presenter?.interactor?.presenter = presenter
            
            return viewController
        }
        
        return nil
    }
    
}
