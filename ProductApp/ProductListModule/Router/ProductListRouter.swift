//
//  ProductListRouter.swift
//  ProductApp
//
//  Created by 2714476 on 13/04/24.
//

import UIKit

class ProductListRouter: PresenterToRouterProductListProtocol {
    
    static func createProductListModule() -> UINavigationController? {
        
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(identifier: Constants.productListViewController) as? ProductListViewController {
            let navigationController = UINavigationController(rootViewController: viewController)
            let presenter: ViewToPresenterProductListProtocol & InteractorToPresenterProductListProtocol = ProductListPresenter()
            viewController.presenter = presenter
            viewController.presenter?.router = ProductListRouter()
            viewController.presenter?.view = viewController
            viewController.presenter?.interactor = ProductListInteractor()
            viewController.presenter?.interactor?.presenter = presenter
            return navigationController
        }
        return nil
    }
    
    
    func pushToProductDetail(on view: (any PresenterToViewProductListProtocol)?, with product: Product) {
        if let productDetailViewController = ProductDetailRouter.createProductDetailModule(with: product){
            let viewController = view as? ProductListViewController
            viewController?.navigationController?.pushViewController(productDetailViewController, animated: true)
        }
    }
    
    func pushToCartViewModule(on view: PresenterToViewProductListProtocol?) {
        if let cartViewController = CartViewRouter.createCartViewModule(){
            let viewController = view as? ProductListViewController
            viewController?.navigationController?.pushViewController(cartViewController, animated: true)
        }
    }
}

