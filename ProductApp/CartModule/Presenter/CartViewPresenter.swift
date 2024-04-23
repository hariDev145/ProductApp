//
//  CartViewPresenter.swift
//  ProductApp
//
//  Created by 2714476 on 18/04/24.
//

import UIKit

class CartViewPresenter: ViewToPresenterCartViewProtocol {
    
    var products = [Product]()
    
    weak var view: PresenterToViewCartViewProtocol?
    var interactor: PresenterToInteractorCartViewProtocol?
    var router: PresenterToRouterCartViewProtocol?
    
    func viewDidLoad() {
        view?.showActivity()
        interactor?.getCartViewProducts()
    }
    
    func numberOfRowsInSection() -> Int {
        products.count
    }
    
    func setCell(tableview: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: Constants.CartProduct.cartCellIdentifier, for: indexPath) as? CartTableViewCell {
            cell.selectionStyle = .none
            cell.setData(product: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableViewCellHeight() -> CGFloat {
        return Constants.CartProduct.cellHeight
    }
    
    func showDataInTableView(tableView: UITableView) {
        tableView.reloadData()
    }
    
}




extension CartViewPresenter: InteractorToPresenterCartViewProtocol {
    func fetchCartViewProductsSuccess(productsList: [Product]?) {
        if let products = productsList{
            self.products = products
        }
        view?.retrieveCartViewProductsSuccess(productsList: productsList)
    }
    
    func fetchCartViewProductsFailure(isLoaded:Bool){
        view?.retrieveCartViewProductsFailure(isLoaded: isLoaded)
    }
}
