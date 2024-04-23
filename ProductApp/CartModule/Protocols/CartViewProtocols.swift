//
//  CartViewProtocols.swift
//  ProductApp
//
//  Created by 2714476 on 18/04/24.
//

import UIKit

protocol ViewToPresenterCartViewProtocol{
    var view: PresenterToViewCartViewProtocol? {get set}
    var interactor: PresenterToInteractorCartViewProtocol? {get set}
    var router: PresenterToRouterCartViewProtocol? {get set}
    
    func viewDidLoad()
    func numberOfRowsInSection() -> Int
    func setCell(tableview: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell
    func tableViewCellHeight() -> CGFloat
    func showDataInTableView(tableView:UITableView)
}

protocol PresenterToViewCartViewProtocol: AnyObject {
    func retrieveCartViewProductsSuccess(productsList: [Product]?)
    func retrieveCartViewProductsFailure(isLoaded:Bool)
    func showActivity()
    func hideActivity()
}

protocol PresenterToInteractorCartViewProtocol {
    var presenter: InteractorToPresenterCartViewProtocol? {get set}
    func getCartViewProducts()
}

protocol InteractorToPresenterCartViewProtocol: AnyObject {
    func fetchCartViewProductsSuccess(productsList: [Product]?)
    func fetchCartViewProductsFailure(isLoaded:Bool)
}


protocol PresenterToRouterCartViewProtocol {
    static func createCartViewModule() -> UIViewController?
}

