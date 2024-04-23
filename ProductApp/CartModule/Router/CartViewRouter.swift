//
//  CartViewRouter.swift
//  ProductApp
//
//  Created by 2714476 on 18/04/24.
//

import UIKit

class CartViewRouter: PresenterToRouterCartViewProtocol {
    
    static func createCartViewModule() -> UIViewController? {
        
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(identifier: Constants.cartViewController) as? CartViewController {
            
            let presenter: ViewToPresenterCartViewProtocol & InteractorToPresenterCartViewProtocol = CartViewPresenter()
            viewController.presenter = presenter
            viewController.presenter?.router = CartViewRouter()
            viewController.presenter?.view = viewController
            viewController.presenter?.interactor = CartViewInteractor()
            viewController.presenter?.interactor?.presenter = presenter
            
            return viewController
        }
        
        return nil
    }
}
